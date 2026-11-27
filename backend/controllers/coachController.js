const { User, Team, Player, Match, Tournament, PlayerStat, TournamentApplication } = require('../models');
const { resultFor } = require('../services/statsService');
const { computeStandings } = require('../services/tournamentService');
const { Op } = require('sequelize');
const { validationResult } = require('express-validator');
const bcrypt = require('bcryptjs');

// GET /coaches
const getAllCoaches = async (req, res) => {
  try {
    const coaches = await User.findAll({
      where: { role: 'coach' },
      attributes: ['id', 'name', 'email', 'phone', 'teamId', 'createdAt'],
      include: [{
        model: Team,
        as: 'team',
        attributes: ['id', 'name', 'description']
      }]
    });
    res.json({ coaches });
  } catch (error) {
    console.error('Error fetching coaches:', error);
    res.status(500).json({ message: 'Erreur lors du chargement des coaches' });
  }
};
// GET /coaches/:id
const getCoachById = async (req, res) => {
  try {
    const coach = await User.findOne({
      where: { id: req.params.id, role: 'coach' },
      attributes: ['id', 'name', 'email', 'phone', 'teamId'],
      include: [{
        model: Team,
        as: 'team',
        attributes: ['id', 'name', 'description'],
        include: [{
          model: Player,
          as: 'players',
          attributes: ['id', 'name', 'position', 'jerseyNumber', 'isCaptain']
        }]
      }]
    });

    if (!coach) {
      return res.status(404).json({ message: 'Coach non trouvé' });
    }

    res.json({ coach });
  } catch (error) {
    console.error('Error fetching coach:', error);
    res.status(500).json({ message: 'Erreur lors du chargement du coach' });
  }
};

// POST /coaches
const createCoach = async (req, res) => {
  try {
    const { name, email, password, phone, teamId } = req.body;

    console.log('Creating coach with data:', { name, email, phone, teamId });

    // Validation côté serveur
    if (!name || !email || !password) {
      return res.status(400).json({ message: 'Nom, email et mot de passe sont requis' });
    }

    // Check if email already exists
    const existingUser = await User.findOne({ where: { email } });
    if (existingUser) {
      return res.status(400).json({ message:'Email déjà utilisé' });
    }

    // Convert empty string to null for teamId
    const normalizedTeamId = teamId === '' ? null : teamId;

    // Check if team exists and is not already assigned to another coach
    if (normalizedTeamId) {
      const team = await Team.findByPk(normalizedTeamId);
      if (!team) {
        return res.status(400).json({ message: 'Équipe non trouvée' });
      }

      const teamCoach = await User.findOne({ where: { teamId: normalizedTeamId, role: 'coach' } });
      if (teamCoach) {
        return res.status(400).json({ message: 'Cette équipe a déjà un coach assigné' });
      }
    }

    // Hash password
    const hashedPassword = await bcrypt.hash(password, 10);

    const coach = await User.create({ 
      name, 
      email, 
      password: hashedPassword, 
      phone,
      teamId: normalizedTeamId,
      role: 'coach' 
    });

    res.status(201).json({ 
      message: 'Coach créé avec succès', 
      coach: { 
        id: coach.id, 
        name: coach.name, 
        email: coach.email, 
        phone: coach.phone,
        teamId: coach.teamId
      } 
    });
  } catch (error) {
    console.error('Error creating coach:', error);
    console.error('Error details:', error.message);
    res.status(500).json({ 
      message: 'Erreur lors de la création du coach',
      error: error.message 
    });
  }
};

// PUT /coaches/:id
const updateCoach = async (req, res) => {
  try {
    const { name, email, phone, teamId } = req.body;
    const coachId = req.params.id;

    console.log('Updating coach:', { coachId, name, email, phone, teamId });

    const coach = await User.findOne({ where: { id: coachId, role: 'coach' } });
    if (!coach) {
      return res.status(404).json({ message: 'Coach non trouvé' });
    }

    // Check if email is taken by another user
    if (email && email !== coach.email) {
      const existing = await User.findOne({ where: { email } });
      if (existing) {
        return res.status(400).json({ message: 'Email déjà utilisé' });
      }
    }

    // Convert empty string to null for teamId
    const normalizedTeamId = teamId === '' ? null : teamId;

    // Check if team exists if teamId is provided and not null
    if (normalizedTeamId) {
      const team = await Team.findByPk(normalizedTeamId);
      if (!team) {
        return res.status(400).json({ message: 'Équipe non trouvée' });
      }

      // Check if team is already assigned to another coach (but not this coach)
      if (normalizedTeamId !== coach.teamId) {
        const teamCoach = await User.findOne({ where: { teamId: normalizedTeamId, role: 'coach' } });
        if (teamCoach && teamCoach.id !== coach.id) {
          return res.status(400).json({ message: 'Cette équipe a déjà un coach assigné' });
        }
      }
    }

    // Update coach data
    const updateData = {};
    if (name !== undefined) updateData.name = name;
    if (email !== undefined) updateData.email = email;
    if (phone !== undefined) updateData.phone = phone;
    if (teamId !== undefined) updateData.teamId = normalizedTeamId;

    console.log('Update data:', updateData);

    await coach.update(updateData);

    res.json({ 
      message: 'Coach mis à jour avec succès',
      coach: {
        id: coach.id,
        name: coach.name,
        email: coach.email,
        phone: coach.phone,
        teamId: coach.teamId
      }
    });
  } catch (error) {
    console.error('Error updating coach:', error);
    console.error('Error details:', error.message);
    res.status(500).json({ 
      message: 'Erreur lors de la mise à jour du coach',
      error: error.message 
    });
  }
};

// DELETE /coaches/:id
const deleteCoach = async (req, res) => {
  try {
    const coach = await User.findOne({ where: { id: req.params.id, role: 'coach' } });
    if (!coach) {
      return res.status(404).json({ message: 'Coach non trouvé' });
    }

    await coach.destroy();
    res.json({ message: 'Coach supprimé avec succès' });
  } catch (error) {
    console.error('Error deleting coach:', error);
    res.status(500).json({ message: 'Erreur lors de la suppression du coach' });
  }
};

// GET /coaches/me (for authenticated coach)
const getMyTeam = async (req, res) => {
  try {
    const coachId = req.user.id;
    
    const coach = await User.findOne({
      where: { id: coachId, role: 'coach' },
      attributes: ['id', 'name', 'email', 'teamId', 'role', 'isActive'],
      include: [{
        model: Team,
        as: 'team',
        required: false,
        include: [{
          model: Player,
          as: 'players',
          required: false,
          attributes: ['id', 'name', 'position', 'jerseyNumber', 'isCaptain', 'email', 'phone'],
          include: [{
            model: PlayerStat,
            as: 'stats',
            required: false
          }]
        }]
      }]
    });

    if (!coach) {
      return res.status(404).json({ message: 'Coach non trouvé' });
    }

    if (!coach.team) {
      return res.status(404).json({ message: 'Aucune équipe assignée' });
    }

    res.json({ team: coach.team });
  } catch (error) {
    console.error('Error fetching coach team:', error);
    res.status(500).json({ message: 'Erreur lors du chargement de l\'équipe' });
  }
};

// GET /coaches/me/matches - Matches for coach's team across tournaments
const getMyTeamMatches = async (req, res) => {
  try {
    const coachId = req.user.id;
    const coach = await User.findOne({ where: { id: coachId, role: 'coach' } });
    if (!coach) return res.status(404).json({ message: 'Coach non trouvé' });
    if (!coach.teamId) return res.status(404).json({ message: 'Aucune équipe assignée' });

    const teamId = Number(coach.teamId);

    const matches = await Match.findAll({
      where: {
        [Op.or]: [
          { homeTeamId: teamId },
          { awayTeamId: teamId }
        ]
      },
      include: [
        { association: Match.associations.tournament, attributes: ['id', 'name'] },
        { association: Match.associations.homeTeam, attributes: ['id', 'name'] },
        { association: Match.associations.awayTeam, attributes: ['id', 'name'] }
      ],
      order: [['date', 'DESC']]
    });

    const formatted = matches.map(m => {
      const isHome = Number(m.homeTeamId) === teamId;
      const opponent = isHome ? m.awayTeam : m.homeTeam;
      const goalsFor = isHome ? (m.homeTeamScore || 0) : (m.awayTeamScore || 0);
      const goalsAgainst = isHome ? (m.awayTeamScore || 0) : (m.homeTeamScore || 0);
      const r = resultFor(m, teamId);
      const result = m.status !== 'completed' ? 'Programmé' : r === 'V' ? 'Victoire' : r === 'D' ? 'Défaite' : 'Match nul';
      return {
        id: m.id,
        date: m.date,
        tournament: m.tournament?.name || '-',
        opponent: opponent?.name || '-',
        score: m.status === 'completed' ? `${m.homeTeamScore ?? 0}-${m.awayTeamScore ?? 0}` : '-',
        result,
        goalsFor,
        goalsAgainst,
        status: m.status
      };
    });

    res.json({ matches: formatted });
  } catch (error) {
    console.error('Error fetching coach team matches:', error);
    res.status(500).json({ message: 'Erreur lors du chargement des matchs' });
  }
};

// GET /coaches/me/tournament
// Returns current tournament the team belongs to, with standings + team's matches
const getMyTournament = async (req, res) => {
  try {
    const coach = await User.findOne({ where: { id: req.user.id, role: 'coach' } });
    if (!coach || !coach.teamId) {
      return res.json({ tournament: null, standings: [], matches: [], applications: [] });
    }

    const teamId = Number(coach.teamId);

    // Load team with its tournament
    const team = await Team.findByPk(teamId, {
      include: [{ model: Tournament, as: 'tournament' }],
    });

    if (!team) return res.json({ tournament: null, standings: [], matches: [], applications: [] });

    // ── Pending / recent applications ────────────────────────────────────────
    const applications = await TournamentApplication.findAll({
      where: { teamId },
      include: [{ model: Tournament, as: 'tournament', attributes: ['id', 'name', 'status', 'format'] }],
      order: [['appliedAt', 'DESC']],
    });

    if (!team.tournament) {
      return res.json({
        tournament: null,
        standings: [],
        matches: [],
        applications: applications.map(a => ({
          id: a.id,
          status: a.status,
          appliedAt: a.appliedAt,
          tournament: a.tournament,
          notes: a.notes,
        })),
      });
    }

    const tournament = team.tournament;

    // ── All matches in this tournament ───────────────────────────────────────
    const allMatches = await Match.findAll({
      where: { tournamentId: tournament.id },
      include: [
        { model: Team, as: 'homeTeam', attributes: ['id', 'name'] },
        { model: Team, as: 'awayTeam', attributes: ['id', 'name'] },
      ],
      order: [['date', 'ASC']],
    });

    // ── All teams in this tournament (for standings) ─────────────────────────
    const allTeams = await Team.findAll({ where: { tournamentId: tournament.id }, attributes: ['id', 'name'] });

    // ── Classement : même calcul que la page tournoi (services/tournamentService) ──
    const standings = (await computeStandings(tournament, allTeams, allMatches.filter(m => m.status === 'completed')))
      .map(r => ({ ...r, isMyTeam: r.id === teamId }));

    const myPosition = standings.findIndex(r => r.id === teamId) + 1;

    // ── Team's own matches ───────────────────────────────────────────────────
    const teamMatches = allMatches
      .filter(m => m.homeTeamId === teamId || m.awayTeamId === teamId)
      .map(m => {
        const isHome = m.homeTeamId === teamId;
        const opponent = isHome ? m.awayTeam : m.homeTeam;
        const gf = isHome ? (m.homeTeamScore ?? 0) : (m.awayTeamScore ?? 0);
        const ga = isHome ? (m.awayTeamScore ?? 0) : (m.homeTeamScore ?? 0);
        const result = m.status === 'completed' ? resultFor(m, teamId) : null;
        return {
          id: m.id,
          date: m.date,
          opponent: opponent?.name ?? '?',
          isHome,
          homeTeamScore: m.homeTeamScore,
          awayTeamScore: m.awayTeamScore,
          goalsFor: gf,
          goalsAgainst: ga,
          result,
          status: m.status,
          location: m.location,
          roundNumber: m.roundNumber,
          homeTeam: m.homeTeam,
          awayTeam: m.awayTeam,
        };
      });

    res.json({
      tournament: {
        id: tournament.id,
        name: tournament.name,
        format: tournament.format,
        status: tournament.status,
        startDate: tournament.startDate,
        endDate: tournament.endDate,
        location: tournament.location,
        maxTeams: tournament.maxTeams,
        description: tournament.description,
        teamsCount: allTeams.length,
      },
      standings,
      myPosition,
      matches: teamMatches,
      applications: [],
    });
  } catch (error) {
    console.error('getMyTournament error:', error);
    res.status(500).json({ message: 'Erreur lors du chargement du tournoi' });
  }
};

// GET /coaches/me/available-tournaments
// Returns active tournaments the team hasn't already applied to or joined
const getAvailableTournamentsForCoach = async (req, res) => {
  try {
    const coach = await User.findOne({ where: { id: req.user.id, role: 'coach' } });
    if (!coach || !coach.teamId) return res.json({ tournaments: [] });

    const teamId = Number(coach.teamId);
    const team = await Team.findByPk(teamId);

    // Already in a tournament
    if (team?.tournamentId) return res.json({ tournaments: [] });

    // Tournaments already applied for
    const existingApps = await TournamentApplication.findAll({
      where: { teamId },
      attributes: ['tournamentId'],
    });
    const appliedIds = existingApps.map(a => a.tournamentId);

    const tournaments = await Tournament.findAll({
      where: {
        status: 'draft', // inscriptions ouvertes tant que le tableau n'est pas généré
        ...(appliedIds.length ? { id: { [Op.notIn]: appliedIds } } : {}),
      },
      attributes: ['id', 'name', 'format', 'startDate', 'endDate', 'location', 'maxTeams', 'description'],
      order: [['startDate', 'ASC']],
    });

    res.json({ tournaments });
  } catch (error) {
    console.error('getAvailableTournamentsForCoach error:', error);
    res.status(500).json({ message: 'Erreur lors du chargement des tournois disponibles' });
  }
};

module.exports = {
  getAllCoaches,
  getCoachById,
  createCoach,
  updateCoach,
  deleteCoach,
  getMyTeam,
  getMyTeamMatches,
  getMyTournament,
  getAvailableTournamentsForCoach,
};
