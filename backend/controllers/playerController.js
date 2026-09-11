const { Player, Team, User, Match, MatchEvent, Tournament, PlayerStat } = require('../models');
const { validationResult } = require('express-validator');
const { Op } = require('sequelize');
const bcrypt = require('bcryptjs');

// GET /players?teamId=&search=&page=1&limit=50
const getAllPlayers = async (req, res) => {
  try {
    const { teamId, search, page = 1, limit = 50 } = req.query;

    const parsedPage  = Math.max(1, parseInt(page)  || 1);
    const parsedLimit = Math.min(200, Math.max(1, parseInt(limit) || 50));
    const offset      = (parsedPage - 1) * parsedLimit;

    const where = {};
    if (teamId) where.teamId = teamId;
    if (search) where.name   = { [Op.iLike]: `%${search.trim()}%` };

    const { count, rows: players } = await Player.findAndCountAll({
      where,
      order: [['name', 'ASC']],
      limit: parsedLimit,
      offset,
      distinct: true, // correct count when joining associations
      include: [
        { model: Team,       as: 'team',  required: false, attributes: ['id', 'name'] },
        { model: PlayerStat, as: 'stats', required: false },
        { model: User,       as: 'user',  required: false, attributes: ['id', 'name', 'email', 'phone'] },
      ],
    });

    res.json({
      players,
      pagination: {
        page:       parsedPage,
        limit:      parsedLimit,
        total:      count,
        totalPages: Math.ceil(count / parsedLimit),
      },
    });
  } catch (error) {
    console.error('Error fetching players:', error);
    res.status(500).json({ message: 'Erreur lors du chargement des joueurs' });
  }
};

// GET /players/:id
const getPlayerById = async (req, res) => {
  try {
    const { id } = req.params;
    const player = await Player.findByPk(id, { include: [{ model: Team, as: 'team' }] });
    if (!player) return res.status(404).json({ message: 'Joueur non trouvé' });
    res.json({ player });
  } catch (error) {
    console.error('Error fetching player:', error);
    res.status(500).json({ message: 'Erreur lors du chargement du joueur' });
  }
};

// POST /players
const createPlayer = async (req, res) => {
  try {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }
    const { email, password, ...raw } = req.body;

    // Custom validation: if email is provided, password must be provided
    if (email && !password) {
      return res.status(400).json({ message: 'Le mot de passe est requis lorsque vous fournissez un email' });
    }

    // Custom validation: if password is provided, email must be provided
    if (password && !email) {
      return res.status(400).json({ message: 'L\'email est requis lorsque vous fournissez un mot de passe' });
    }

    // Helper: parse optional integer — '' / null → null
    const optInt = (v) => {
      if (v === undefined || v === null || v === '') return null;
      const n = parseInt(v, 10);
      return isNaN(n) ? null : n;
    };

    // Sanitize player fields so empty strings never reach Sequelize ENUM/INTEGER columns
    const playerData = {};
    if (raw.name)                          playerData.name          = raw.name;
    if (raw.position)                      playerData.position      = raw.position;      // ENUM — skip if empty
    if (raw.preferredFoot)                 playerData.preferredFoot = raw.preferredFoot; // ENUM — skip if empty
    if (raw.jerseyNumber !== undefined)    playerData.jerseyNumber  = optInt(raw.jerseyNumber);
    if (raw.teamId       !== undefined)    playerData.teamId        = optInt(raw.teamId);
    if (raw.isCaptain    !== undefined)    playerData.isCaptain     = raw.isCaptain;
    if (raw.isActive     !== undefined)    playerData.isActive      = raw.isActive;
    if (raw.dateOfBirth)                   playerData.dateOfBirth   = raw.dateOfBirth;
    if (raw.joinDate)                      playerData.joinDate      = raw.joinDate;
    if (raw.nationality)                   playerData.nationality   = raw.nationality;
    if (raw.height       !== undefined)    playerData.height        = optInt(raw.height);
    if (raw.weight       !== undefined)    playerData.weight        = optInt(raw.weight);
    if (raw.phone)                         playerData.phone         = raw.phone;

    let createdUser = null;
    if (email && password) {
      // Ensure email not used
      const existing = await User.findOne({ where: { email } });
      if (existing) {
        return res.status(400).json({ message: 'Email déjà utilisé' });
      }

      // Hash the password
      const hashedPassword = await bcrypt.hash(password, 10);
      createdUser = await User.create({
        name: playerData.name,
        email,
        password: hashedPassword,
        role: 'joueur',
        isActive: true
      });
      playerData.userId  = createdUser.id;
      playerData.email   = email;
    }

    const player = await Player.create(playerData);
    res.status(201).json({
      message: email ? 'Joueur créé avec succès avec compte utilisateur' : 'Joueur créé avec succès',
      player,
      user: createdUser
    });
  } catch (error) {
    console.error('Error creating player:', error);
    // Sequelize validation errors → 400 with readable message
    if (error.name === 'SequelizeValidationError' || error.name === 'SequelizeUniqueConstraintError') {
      const messages = error.errors?.map(e => e.message).join(', ') || error.message;
      return res.status(400).json({ message: messages });
    }
    res.status(500).json({ message: 'Erreur lors de la création du joueur', error: error.message });
  }
};

// PUT /players/:id
const updatePlayer = async (req, res) => {
  try {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }
    
    const { id } = req.params;
    const updateData = req.body;
    
    console.log('Updating player with data:', { id, updateData });
    
    const player = await Player.findByPk(id, {
      include: [{ model: User, as: 'user' }]
    });
    if (!player) {
      return res.status(404).json({ message: 'Joueur non trouvé' });
    }
    
    // Validate teamId if provided
    if (updateData.teamId) {
      const { Team } = require('../models');
      const team = await Team.findByPk(updateData.teamId);
      if (!team) {
        return res.status(400).json({ message: 'Équipe non trouvée' });
      }
    }
    
    // Handle empty string teamId (should be null)
    if (updateData.teamId === '') {
      updateData.teamId = null;
    }
    
    // Helper: parse an optional integer field — '' and null both become null
    const optInt = (v) => {
      if (v === undefined) return undefined;
      if (v === null || v === '') return null;
      const n = parseInt(v, 10);
      return isNaN(n) ? null : n;
    };

    // Build player record update (includes email/phone for coach mobile sync)
    const playerData = {
      name:          updateData.name,
      // Only set ENUM fields if they carry a valid non-empty value —
      // an empty string would violate the DB ENUM constraint.
      position:      updateData.position      || undefined,
      preferredFoot: updateData.preferredFoot || undefined,
      jerseyNumber:  updateData.jerseyNumber  !== undefined ? optInt(updateData.jerseyNumber)  : undefined,
      teamId:        updateData.teamId        !== undefined ? (updateData.teamId === '' ? null : (parseInt(updateData.teamId, 10) || null)) : undefined,
      isCaptain:     updateData.isCaptain     !== undefined ? updateData.isCaptain : undefined,
      isActive:      updateData.isActive      !== undefined ? updateData.isActive  : undefined,
      dateOfBirth:   updateData.dateOfBirth   || undefined,
      height:        updateData.height        !== undefined ? optInt(updateData.height)  : undefined,
      weight:        updateData.weight        !== undefined ? optInt(updateData.weight)  : undefined,
      nationality:   updateData.nationality   || undefined,
      joinDate:      updateData.joinDate      || undefined,
      email:         updateData.email  !== undefined ? (updateData.email  || null) : undefined,
      phone:         updateData.phone  ?? undefined,
    };

    // Remove undefined values
    Object.keys(playerData).forEach(key => {
      if (playerData[key] === undefined) delete playerData[key];
    });

    await player.update(playerData);

    // Sync User account (login credentials for mobile app)
    if (player.user) {
      const userData = {};
      if (updateData.name)  userData.name  = updateData.name;
      if (updateData.email) userData.email = updateData.email;
      if (updateData.phone) userData.phone = updateData.phone;
      if (updateData.password && updateData.password.trim().length >= 6) {
        userData.password = await bcrypt.hash(updateData.password.trim(), 10);
      }
      if (Object.keys(userData).length > 0) await player.user.update(userData);
    }
    
    // Reload player with associations
    await player.reload({
      include: [
        { model: Team, as: 'team', required: false },
        { model: User, as: 'user', attributes: ['id', 'name', 'email', 'phone'], required: false }
      ]
    });
    
    res.json({ message: 'Joueur mis à jour avec succès', player });
  } catch (error) {
    console.error('Error updating player:', error);
    console.error('Error details:', error.message);

    // Sequelize validation errors → 400 with human-readable message
    if (error.name === 'SequelizeValidationError' || error.name === 'SequelizeUniqueConstraintError') {
      const messages = error.errors?.map(e => e.message).join(', ') || error.message;
      return res.status(400).json({ message: messages });
    }

    res.status(500).json({
      message: 'Erreur lors de la mise à jour du joueur',
      error: error.message
    });
  }
};

// DELETE /players/:id
const deletePlayer = async (req, res) => {
  try {
    const { id } = req.params;
    const player = await Player.findByPk(id);
    if (!player) return res.status(404).json({ message: 'Joueur non trouvé' });
    await player.destroy();
    res.json({ message: 'Joueur supprimé avec succès' });
  } catch (error) {
    console.error('Error deleting player:', error);
    res.status(500).json({ message: 'Erreur lors de la suppression du joueur' });
  }
};

// POST /teams/:teamId/players/:playerId (assign)
const assignPlayerToTeam = async (req, res) => {
  try {
    const { teamId, playerId } = req.params;
    const player = await Player.findByPk(playerId);
    if (!player) return res.status(404).json({ message: 'Joueur non trouvé' });
    player.teamId = teamId;
    await player.save();
    res.json({ message: 'Joueur assigné à l\'équipe', player });
  } catch (error) {
    console.error('Error assigning player:', error);
    res.status(500).json({ message: 'Erreur lors de l\'assignation du joueur' });
  }
};

// GET /players/:id/overview
const getPlayerOverview = async (req, res) => {
  try {
    const { id } = req.params;
    console.log('Fetching player overview for ID:', id);
    
    const player = await Player.findByPk(id, { 
      include: [
        { 
          model: Team, 
          as: 'team', 
          required: false,
          include: [{ 
            model: Tournament, 
            as: 'tournament',
            required: false
          }] 
        }, 
        { 
          model: User, 
          as: 'user', 
          attributes: ['id', 'name', 'email'],
          required: false
        }
      ] 
    });
    
    if (!player) {
      console.log('Player not found with ID:', id);
      return res.status(404).json({ message: 'Joueur non trouvé' });
    }

    console.log('Found player:', player.name);

    // Fetch real stats from database
    let playerStats = await PlayerStat.findOne({ where: { playerId: id } });
    
    // If no stats exist, create default stats
    if (!playerStats) {
      playerStats = await PlayerStat.create({ playerId: id });
    }

    const stats = {
      goals: playerStats.goals || 0,
      assists: playerStats.assists || 0,
      yellowCards: playerStats.yellowCards || 0,
      redCards: playerStats.redCards || 0,
      shots: playerStats.shots || 0,
      shotsOnTarget: playerStats.shotsOnTarget || 0,
      passes: playerStats.passes || 0,
      keyPasses: playerStats.keyPasses || 0,
      dribbles: playerStats.dribbles || 0,
      tackles: playerStats.tackles || 0,
      interceptions: playerStats.interceptions || 0,
      clearances: playerStats.clearances || 0,
      foulsCommitted: playerStats.foulsCommitted || 0,
      foulsSuffered: playerStats.foulsSuffered || 0,
      offsides: playerStats.offsides || 0,
      saves: playerStats.saves || 0,
      cleanSheets: playerStats.cleanSheets || 0,
      goalsConceded: playerStats.goalsConceded || 0,
      penaltiesSaved: playerStats.penaltiesSaved || 0,
      duelsWon: playerStats.duelsWon || 0,
      aerialDuelsWon: playerStats.aerialDuelsWon || 0,
      minutesPlayed: playerStats.minutesPlayed || 0,
    };

    res.json({ 
      player, 
      team: player.team, 
      tournament: player.team?.tournament, 
      matches: [], // Empty for now
      stats 
    });
  } catch (error) {
    console.error('Error fetching player overview:', error);
    console.error('Error details:', error.message);
    res.status(500).json({ message: 'Erreur lors du chargement du profil joueur' });
  }
};

// Player-specific functions for mobile app
const getMyPlayerProfile = async (req, res) => {
  try {
    const userId = req.user.id;
    
    // Find player profile linked to this user
    const player = await Player.findOne({
      where: { userId },
      include: [
        { model: Team, as: 'team', include: [{ model: Tournament, as: 'tournament' }] },
        { model: PlayerStat, as: 'stats' }
      ]
    });

    if (!player) {
      return res.status(404).json({ message: 'Profil joueur non trouvé' });
    }

    // Get upcoming matches for the player's team
    const upcomingMatches = await Match.findAll({
      where: {
        [Op.or]: [
          { homeTeamId: player.teamId },
          { awayTeamId: player.teamId }
        ],
        status: 'scheduled',
        date: { [Op.gte]: new Date() }
      },
      include: [
        { model: Team, as: 'homeTeam' },
        { model: Team, as: 'awayTeam' }
      ],
      order: [['date', 'ASC']],
      limit: 5
    });

    // Get recent matches
    const recentMatches = await Match.findAll({
      where: {
        [Op.or]: [
          { homeTeamId: player.teamId },
          { awayTeamId: player.teamId }
        ],
        status: 'completed',
        date: { [Op.lt]: new Date() }
      },
      include: [
        { model: Team, as: 'homeTeam' },
        { model: Team, as: 'awayTeam' }
      ],
      order: [['date', 'DESC']],
      limit: 5
    });

    res.json({
      player: player.toJSON(),
      team: player.team,
      stats: player.stats,
      upcomingMatches: upcomingMatches.map(m => m.toJSON()),
      recentMatches: recentMatches.map(m => m.toJSON())
    });
  } catch (error) {
    console.error('Error fetching player profile:', error);
    res.status(500).json({ message: 'Erreur lors du chargement du profil' });
  }
};

const getMyStats = async (req, res) => {
  try {
    const userId = req.user.id;

    const player = await Player.findOne({
      where: { userId },
      include: [{ model: PlayerStat, as: 'stats' }],
    });

    if (!player) {
      return res.status(404).json({ message: 'Profil joueur non trouvé' });
    }

    const stats = player.stats || {};

    // Count team's completed matches
    const matchesPlayed = await Match.count({
      where: {
        [Op.or]: [{ homeTeamId: player.teamId }, { awayTeamId: player.teamId }],
        status: 'completed',
      },
    });

    // ── Per-match breakdown from MatchEvent ───────────────────────────────────
    // Fetch all events where this player is the actor (relatedPlayerId)
    const events = await MatchEvent.findAll({
      where: { relatedPlayerId: player.id },
      include: [{
        model: Match,
        as: 'match',
        attributes: ['id', 'date', 'status', 'homeTeamId', 'awayTeamId', 'homeTeamScore', 'awayTeamScore'],
        where: { status: 'completed' },
        required: true,
        include: [
          { model: Team, as: 'homeTeam', attributes: ['id', 'name'] },
          { model: Team, as: 'awayTeam', attributes: ['id', 'name'] },
        ],
      }],
    });

    // Group by match → count each event type
    const byMatch = {};
    for (const ev of events) {
      const m = ev.match;
      if (!byMatch[m.id]) {
        const isHome = m.homeTeamId === player.teamId;
        const opponent = isHome ? m.awayTeam?.name : m.homeTeam?.name;
        const gf = isHome ? (m.homeTeamScore ?? 0) : (m.awayTeamScore ?? 0);
        const ga = isHome ? (m.awayTeamScore ?? 0) : (m.homeTeamScore ?? 0);
        byMatch[m.id] = {
          matchId: m.id,
          date: m.date,
          opponent: opponent ?? '?',
          goalsFor: gf,
          goalsAgainst: ga,
          result: gf > ga ? 'V' : gf < ga ? 'D' : 'N',
          goals: 0,
          assists: 0,
          yellowCards: 0,
          redCards: 0,
          shots: 0,
        };
      }
      const row = byMatch[m.id];
      if (ev.type === 'goal' || ev.type === 'penalty_goal') row.goals++;
      else if (ev.type === 'assist') row.assists++;
      else if (ev.type === 'yellow_card') row.yellowCards++;
      else if (ev.type === 'red_card') row.redCards++;
    }

    // Also include completed matches where the player's team played but player had no events
    // (so the chart axis covers all matches, not just ones where player scored)
    const teamMatches = await Match.findAll({
      where: {
        [Op.or]: [{ homeTeamId: player.teamId }, { awayTeamId: player.teamId }],
        status: 'completed',
      },
      include: [
        { model: Team, as: 'homeTeam', attributes: ['id', 'name'] },
        { model: Team, as: 'awayTeam', attributes: ['id', 'name'] },
      ],
      order: [['date', 'ASC']],
    });

    for (const m of teamMatches) {
      if (!byMatch[m.id]) {
        const isHome = m.homeTeamId === player.teamId;
        const opponent = isHome ? m.awayTeam?.name : m.homeTeam?.name;
        const gf = isHome ? (m.homeTeamScore ?? 0) : (m.awayTeamScore ?? 0);
        const ga = isHome ? (m.awayTeamScore ?? 0) : (m.homeTeamScore ?? 0);
        byMatch[m.id] = {
          matchId: m.id,
          date: m.date,
          opponent: opponent ?? '?',
          goalsFor: gf,
          goalsAgainst: ga,
          result: gf > ga ? 'V' : gf < ga ? 'D' : 'N',
          goals: 0,
          assists: 0,
          yellowCards: 0,
          redCards: 0,
          shots: 0,
        };
      }
    }

    const perMatchStats = Object.values(byMatch)
      .sort((a, b) => new Date(a.date) - new Date(b.date));

    res.json({
      ...(stats.toJSON ? stats.toJSON() : {}),
      matchesPlayed,
      averageRating: 0.0,
      perMatchStats,
    });
  } catch (error) {
    console.error('Error fetching player stats:', error);
    res.status(500).json({ message: 'Erreur lors du chargement des statistiques' });
  }
};

const getMyTeam = async (req, res) => {
  try {
    const userId = req.user.id;
    
    const player = await Player.findOne({
      where: { userId },
      include: [
        { 
          model: Team, as: 'team',
          include: [
            { model: User, as: 'coach' },
            { model: Player, as: 'players' },
            { model: Tournament, as: 'tournament' }
          ]
        }
      ]
    });

    // ── #9 : Joueur sans équipe → 200 avec null plutôt que 404 ──────────────
    // Évite un crash sur le mobile quand les deux appels sont chaînés
    if (!player || !player.team) {
      return res.json({ team: null, players: [], coach: null });
    }

    res.json({
      team: player.team.toJSON(),
      players: player.team.players.map(p => p.toJSON()),
      coach: player.team.coach
    });
  } catch (error) {
    console.error('Error fetching player team:', error);
    res.status(500).json({ message: 'Erreur lors du chargement de l\'équipe' });
  }
};

const getMyMatches = async (req, res) => {
  try {
    const userId = req.user.id;
    const player = await Player.findOne({ where: { userId } });
    if (!player) return res.status(404).json({ message: 'Profil joueur non trouvé' });

    const teamId = player.teamId;
    if (!teamId) return res.json({ upcomingMatches: [], recentMatches: [], tournament: null, myPosition: null });

    // Get team with tournament
    const team = await Team.findByPk(teamId, {
      include: [{ model: Tournament, as: 'tournament' }],
    });

    const tournament = team?.tournament || null;

    // All matches for this team
    const allMatches = await Match.findAll({
      where: { [Op.or]: [{ homeTeamId: teamId }, { awayTeamId: teamId }] },
      include: [
        { model: Team, as: 'homeTeam', attributes: ['id', 'name'] },
        { model: Team, as: 'awayTeam', attributes: ['id', 'name'] },
        { model: Tournament, as: 'tournament', attributes: ['id', 'name'] },
      ],
      order: [['date', 'DESC']],
    });

    // Enrich each match with opponent name (always from the other side)
    const enriched = allMatches.map(m => {
      const raw = m.toJSON();
      const isHome = m.homeTeamId === teamId;
      raw.opponent = isHome ? (raw.awayTeam?.name ?? '?') : (raw.homeTeam?.name ?? '?');
      raw.myTeamIsHome = isHome;
      raw.goalsFor     = isHome ? (m.homeTeamScore ?? 0) : (m.awayTeamScore ?? 0);
      raw.goalsAgainst = isHome ? (m.awayTeamScore ?? 0) : (m.homeTeamScore ?? 0);
      if (m.status === 'completed') {
        raw.result = raw.goalsFor > raw.goalsAgainst ? 'V'
                   : raw.goalsFor < raw.goalsAgainst ? 'D' : 'N';
      }
      return raw;
    });

    const now = new Date();
    const upcomingMatches = enriched.filter(m => m.status === 'scheduled' && new Date(m.date) >= now);
    const recentMatches   = enriched.filter(m => m.status === 'completed');

    // Standings if team has a tournament (league format)
    let standings = [];
    let myPosition = null;
    if (tournament) {
      const allTeams = await Team.findAll({
        where: { tournamentId: tournament.id },
        attributes: ['id', 'name'],
      });
      const tournamentMatches = await Match.findAll({
        where: { tournamentId: tournament.id, status: 'completed' },
      });

      const rows = {};
      allTeams.forEach(t => {
        rows[t.id] = { id: t.id, name: t.name, P:0, W:0, D:0, L:0, GF:0, GA:0, GD:0, Pts:0 };
      });
      tournamentMatches.forEach(m => {
        const h = rows[m.homeTeamId], a = rows[m.awayTeamId];
        if (!h || !a) return;
        const hg = m.homeTeamScore ?? 0, ag = m.awayTeamScore ?? 0;
        h.P++; h.GF += hg; h.GA += ag; h.GD += hg - ag;
        a.P++; a.GF += ag; a.GA += hg; a.GD += ag - hg;
        if (hg > ag)      { h.W++; h.Pts += 3; a.L++; }
        else if (hg < ag) { a.W++; a.Pts += 3; h.L++; }
        else              { h.D++; h.Pts++;     a.D++; a.Pts++; }
      });

      standings = Object.values(rows)
        .sort((a, b) => b.Pts - a.Pts || b.GD - a.GD || b.GF - a.GF)
        .map((r, i) => ({ ...r, position: i + 1, isMyTeam: r.id === teamId }));

      myPosition = standings.findIndex(r => r.id === teamId) + 1 || null;
    }

    res.json({
      upcomingMatches,
      recentMatches,
      tournament: tournament ? {
        id: tournament.id,
        name: tournament.name,
        format: tournament.format,
        status: tournament.status,
        startDate: tournament.startDate,
        endDate: tournament.endDate,
        location: tournament.location,
        teamsCount: await Team.count({ where: { tournamentId: tournament.id } }),
      } : null,
      standings,
      myPosition,
    });
  } catch (error) {
    console.error('Error fetching player matches:', error);
    res.status(500).json({ message: 'Erreur lors du chargement des matchs' });
  }
};

const getMyTournaments = async (req, res) => {
  try {
    const userId = req.user.id;
    
    const player = await Player.findOne({
      where: { userId },
      include: [
        { 
          model: Team, as: 'team',
          include: [{ model: Tournament, as: 'tournament' }]
        }
      ]
    });

    if (!player || !player.team) {
      return res.status(404).json({ message: 'Équipe non trouvée' });
    }

    const tournaments = player.team.tournament ? [player.team.tournament.toJSON()] : [];

    res.json(tournaments);
  } catch (error) {
    console.error('Error fetching player tournaments:', error);
    res.status(500).json({ message: 'Erreur lors du chargement des tournois' });
  }
};

// ── #17 : Redirection vers getPlayerTrainings (trainingController) ────────────
const getMyTrainingSessions = async (req, res) => {
  try {
    const userId = req.user.id;
    const player = await Player.findOne({ where: { userId } });
    if (!player || !player.teamId) {
      return res.json({ sessions: [] });
    }

    const { TrainingSession } = require('../models');
    const sessions = await TrainingSession.findAll({
      where: { teamId: player.teamId },
      include: [
        { model: Team, as: 'team', attributes: ['id', 'name'] },
        { model: User, as: 'coach', attributes: ['id', 'name'] },
      ],
      order: [['date', 'DESC']],
    });

    res.json({ sessions });
  } catch (error) {
    console.error('getMyTrainingSessions error:', error);
    res.status(500).json({ message: 'Erreur lors du chargement des séances d\'entraînement' });
  }
};

const updateMyProfile = async (req, res) => {
  try {
    const userId = req.user.id;
    const allowedFields = ['height', 'weight', 'preferredFoot', 'avatar'];
    const updateData = {};
    
    allowedFields.forEach(field => {
      if (req.body[field] !== undefined) {
        updateData[field] = req.body[field];
      }
    });

    const player = await Player.findOne({ where: { userId } });

    if (!player) {
      return res.status(404).json({ message: 'Profil joueur non trouvé' });
    }

    await player.update(updateData);

    res.json({ message: 'Profil mis à jour avec succès', player: player.toJSON() });
  } catch (error) {
    console.error('Error updating player profile:', error);
    res.status(500).json({ message: 'Erreur lors de la mise à jour du profil' });
  }
};

module.exports = {
  getAllPlayers,
  getPlayerById,
  createPlayer,
  updatePlayer,
  deletePlayer,
  assignPlayerToTeam,
  getPlayerOverview,
  // Player-specific routes for mobile app
  getMyPlayerProfile,
  getMyStats,
  getMyTeam,
  getMyMatches,
  getMyTournaments,
  getMyTrainingSessions,
  updateMyProfile
};


