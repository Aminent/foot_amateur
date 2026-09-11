const { Op } = require('sequelize');
const { Match, MatchEvent, Team, Tournament, Player, User, PlayerStat } = require('../models');
const notificationService = require('../services/notificationService');

// ── Mapping événement → champ de stat (delta = +1 ou -1) ──────────────────────
const EVENT_STAT_MAP = {
  goal:         { field: 'goals',       playerId: 'relatedPlayerId' },
  penalty_goal: { field: 'goals',       playerId: 'relatedPlayerId' },
  assist:       { field: 'assists',     playerId: 'relatedPlayerId' },
  yellow_card:  { field: 'yellowCards', playerId: 'relatedPlayerId' },
  red_card:     { field: 'redCards',    playerId: 'relatedPlayerId' },
};

// Incrémente (delta=+1) ou décrémente (delta=-1) une stat pour un joueur
const applyStatDelta = async (playerId, field, delta) => {
  if (!playerId || !field) return;
  const [stat] = await PlayerStat.findOrCreate({ where: { playerId }, defaults: { playerId } });
  const current = stat[field] || 0;
  await stat.update({ [field]: Math.max(0, current + delta) });
};

// Calcule et enregistre les minutes jouées pour tous les joueurs d'un match terminé
const computeMinutesPlayed = async (matchId, matchDuration = 90) => {
  try {
    const events = await MatchEvent.findAll({ where: { matchId, type: 'substitution' } });
    const match = await Match.findByPk(matchId, {
      include: [
        { model: Team, as: 'homeTeam', include: [{ model: Player, as: 'players', attributes: ['id'] }] },
        { model: Team, as: 'awayTeam', include: [{ model: Player, as: 'players', attributes: ['id'] }] },
      ],
    });
    if (!match) return;

    const allPlayers = [
      ...(match.homeTeam?.players || []),
      ...(match.awayTeam?.players || []),
    ];

    // Build substitution map
    const subOutAt = {}; // playerId → minute they left
    const subInAt  = {}; // playerId → minute they entered
    for (const ev of events) {
      if (ev.substitutionPlayerOutId) subOutAt[ev.substitutionPlayerOutId] = ev.minute;
      if (ev.substitutionPlayerInId)  subInAt[ev.substitutionPlayerInId]  = ev.minute;
    }

    for (const player of allPlayers) {
      const pid = player.id;
      let minutes = 0;
      if (subInAt[pid] !== undefined) {
        // Player entered mid-game
        minutes = matchDuration - subInAt[pid];
      } else if (subOutAt[pid] !== undefined) {
        // Player left mid-game
        minutes = subOutAt[pid];
      } else {
        // Player played full match
        minutes = matchDuration;
      }
      if (minutes > 0) {
        const [stat] = await PlayerStat.findOrCreate({ where: { playerId: pid }, defaults: { playerId: pid } });
        await stat.update({ minutesPlayed: (stat.minutesPlayed || 0) + minutes });
      }
    }
  } catch (err) {
    console.error('[Stats] computeMinutesPlayed error:', err.message);
  }
};

const matchIncludes = [
  { model: Team, as: 'homeTeam', attributes: ['id', 'name'], include: [{ model: Player, as: 'players', attributes: ['id', 'name', 'jerseyNumber', 'position'], required: false }] },
  { model: Team, as: 'awayTeam', attributes: ['id', 'name'], include: [{ model: Player, as: 'players', attributes: ['id', 'name', 'jerseyNumber', 'position'], required: false }] },
  { model: Tournament, as: 'tournament', attributes: ['id', 'name', 'format'] },
  { model: MatchEvent, as: 'events', separate: true, order: [['minute', 'ASC'], ['extraMinute', 'ASC']] },
];

const emit = (tournamentId, type, data) => {
  if (global.io) global.io.to(`tournament-${tournamentId}`).emit('bracket-updated', { type, ...data });
};

const emitLive = (matchId, type, data) => {
  if (global.io) global.io.to(`match_${matchId}`).emit('live-update', { type, ...data });
};

// GET /api/matches
const getMatches = async (req, res) => {
  try {
    const { tournamentId, status, teamId } = req.query;
    const where = {};
    if (tournamentId) where.tournamentId = tournamentId;
    if (status) where.status = status;
    if (teamId) where[Op.or] = [{ homeTeamId: teamId }, { awayTeamId: teamId }];

    const matches = await Match.findAll({
      where,
      include: matchIncludes,
      order: [['date', 'ASC']],
    });
    res.json({ matches });
  } catch (error) {
    console.error('getMatches error:', error);
    res.status(500).json({ message: 'Erreur lors du chargement des matchs' });
  }
};

// GET /api/matches/:id
const getMatch = async (req, res) => {
  try {
    const match = await Match.findByPk(req.params.id, { include: matchIncludes });
    if (!match) return res.status(404).json({ message: 'Match introuvable' });
    res.json({ match });
  } catch (error) {
    console.error('getMatch error:', error);
    res.status(500).json({ message: 'Erreur lors du chargement du match' });
  }
};

// POST /api/matches
const createMatch = async (req, res) => {
  try {
    const { tournamentId, homeTeamId, awayTeamId, date, location, roundNumber, matchIndex, referee, notes } = req.body;

    if (!date) return res.status(400).json({ message: 'La date est requise' });
    if (!homeTeamId || !awayTeamId) return res.status(400).json({ message: 'Les deux équipes sont requises' });
    if (String(homeTeamId) === String(awayTeamId)) return res.status(400).json({ message: "L'équipe domicile et l'équipe visiteur doivent être différentes" });

    const match = await Match.create({
      tournamentId: tournamentId || null,
      homeTeamId,
      awayTeamId,
      date,
      location: location || null,
      roundNumber: roundNumber ? parseInt(roundNumber) : null,
      matchIndex: matchIndex !== undefined ? parseInt(matchIndex) : null,
      referee: referee || null,
      notes: notes || null,
      status: 'scheduled',
      homeTeamScore: 0,
      awayTeamScore: 0,
    });

    const full = await Match.findByPk(match.id, { include: matchIncludes });
    emit(tournamentId, 'match-created', { matchId: match.id, tournamentId });
    res.status(201).json({ match: full });
  } catch (error) {
    console.error('createMatch error:', error);
    res.status(500).json({ message: 'Erreur lors de la création du match' });
  }
};

// PUT /api/matches/:id  (full update — schedule details + scores + status)
const updateMatch = async (req, res) => {
  try {
    const match = await Match.findByPk(req.params.id);
    if (!match) return res.status(404).json({ message: 'Match introuvable' });

    const {
      tournamentId, homeTeamId, awayTeamId, date, location,
      roundNumber, referee, notes, status,
      homeTeamScore, awayTeamScore, halfTimeHomeScore, halfTimeAwayScore,
      attendance, weather,
    } = req.body;

    const homeScore = homeTeamScore !== undefined ? Number(homeTeamScore) : match.homeTeamScore;
    const awayScore = awayTeamScore !== undefined ? Number(awayTeamScore) : match.awayTeamScore;

    let winnerTeamId = match.winnerTeamId;
    if (status === 'completed' || req.body.winnerTeamId !== undefined) {
      winnerTeamId = homeScore > awayScore
        ? (homeTeamId || match.homeTeamId)
        : awayScore > homeScore
          ? (awayTeamId || match.awayTeamId)
          : null;
    }

    // ── #2 : Avertissement si clôture avec score 0-0 ─────────────────────────
    const scoreWarning = (status === 'completed' && homeScore === 0 && awayScore === 0)
      ? 'Attention : le match est clôturé avec un score de 0-0. Vérifiez que le résultat est correct.'
      : null;

    await match.update({
      tournamentId: tournamentId ?? match.tournamentId,
      homeTeamId: homeTeamId ?? match.homeTeamId,
      awayTeamId: awayTeamId ?? match.awayTeamId,
      date: date ?? match.date,
      location: location !== undefined ? location : match.location,
      roundNumber: roundNumber !== undefined ? (roundNumber ? parseInt(roundNumber) : null) : match.roundNumber,
      referee: referee !== undefined ? referee : match.referee,
      notes: notes !== undefined ? notes : match.notes,
      status: status ?? match.status,
      homeTeamScore: homeScore,
      awayTeamScore: awayScore,
      halfTimeHomeScore: halfTimeHomeScore !== undefined ? Number(halfTimeHomeScore) : match.halfTimeHomeScore,
      halfTimeAwayScore: halfTimeAwayScore !== undefined ? Number(halfTimeAwayScore) : match.halfTimeAwayScore,
      attendance: attendance !== undefined ? (attendance ? parseInt(attendance) : null) : match.attendance,
      weather: weather !== undefined ? weather : match.weather,
      winnerTeamId,
    });

    // advance winner if knockout
    if (winnerTeamId && match.advancesToMatchId) {
      const next = await Match.findByPk(match.advancesToMatchId);
      if (next) {
        const fillHome = (match.matchIndex ?? 0) % 2 === 0;
        await next.update(fillHome ? { homeTeamId: winnerTeamId } : { awayTeamId: winnerTeamId });
      }
    }

    // ── #6 : Match nul en tournoi avec avancement attendu → alerte admin ────
    if (status === 'completed' && !winnerTeamId && match.advancesToMatchId) {
      if (global.io) {
        global.io.to('admins').emit('match-draw-no-advance', {
          matchId: match.id,
          homeTeam: match.homeTeamId,
          awayTeam: match.awayTeamId,
          homeScore,
          awayScore,
          message: 'Match nul en tournoi knockout : veuillez désigner un vainqueur (tirs au but, etc.)',
        });
      }
      console.warn(`[Bracket] Match #${match.id} nul ${homeScore}-${awayScore} sans vainqueur — avancement bloqué`);
    }

    const full = await Match.findByPk(match.id, { include: matchIncludes });
    emit(match.tournamentId, 'match-updated', { matchId: match.id, tournamentId: match.tournamentId });
    emitLive(match.id, 'status', { match: full });
    res.json({ match: full, ...(scoreWarning ? { warning: scoreWarning } : {}) });

    // ── #4 : Calcul des minutes jouées — protégé contre les doubles appels ──
    // On vérifie `minutesComputed` en base avant de lancer le calcul.
    // Le flag est posé atomiquement pour éviter la concurrence.
    if (status === 'completed' && !match.minutesComputed) {
      // Marquer immédiatement pour bloquer tout appel concurrent
      match.update({ minutesComputed: true }).catch(() => {});
      computeMinutesPlayed(match.id).catch(err =>
        console.warn('[Stats] minutesPlayed error:', err.message)
      );
    }

    // Push notification when score/result is set (fire-and-forget)
    try {
      const scoreChanged = homeTeamScore !== undefined || awayTeamScore !== undefined;
      const matchCompleted = status === 'completed';
      if (scoreChanged || matchCompleted) {
        const homeName = full.homeTeam?.name ?? '?';
        const awayName = full.awayTeam?.name ?? '?';
        const scoreStr = `${full.homeTeamScore} - ${full.awayTeamScore}`;

        const collectTokens = async (teamId) => {
          if (!teamId) return [];
          const players = await Player.findAll({
            where: { teamId },
            include: [{ model: User, as: 'user', attributes: ['fcmToken'] }],
          });
          return players.map(p => p.user?.fcmToken).filter(Boolean);
        };

        const [homeTokens, awayTokens] = await Promise.all([
          collectTokens(full.homeTeamId),
          collectTokens(full.awayTeamId),
        ]);

        const allTokens = [...homeTokens, ...awayTokens];
        if (allTokens.length) {
          const title = matchCompleted ? '🏁 Résultat final' : '⚽ Score mis à jour';
          const body = `${homeName} ${scoreStr} ${awayName}`;
          await notificationService.sendToTokens(allTokens, title, body, {
            type: matchCompleted ? 'match_result' : 'score_update',
            matchId: String(match.id),
          });
        }
      }
    } catch (notifErr) {
      console.warn('[FCM] updateMatch notify error:', notifErr.message);
    }
  } catch (error) {
    console.error('updateMatch error:', error);
    res.status(500).json({ message: 'Erreur lors de la mise à jour du match' });
  }
};

// DELETE /api/matches/:id
const deleteMatch = async (req, res) => {
  try {
    const match = await Match.findByPk(req.params.id);
    if (!match) return res.status(404).json({ message: 'Match introuvable' });

    // ── #3 : Annuler les stats joueurs avant de supprimer les événements ─────
    const events = await MatchEvent.findAll({ where: { matchId: match.id } });
    for (const ev of events) {
      const statMap = EVENT_STAT_MAP[ev.type];
      if (statMap && ev[statMap.playerId]) {
        await applyStatDelta(ev[statMap.playerId], statMap.field, -1);
      }
    }

    await MatchEvent.destroy({ where: { matchId: match.id } });
    await match.destroy();

    emit(match.tournamentId, 'match-deleted', { matchId: match.id, tournamentId: match.tournamentId });
    res.json({ message: 'Match supprimé' });
  } catch (error) {
    console.error('deleteMatch error:', error);
    res.status(500).json({ message: 'Erreur lors de la suppression du match' });
  }
};

// ── #14 : Liste blanche des types d'événements valides ───────────────────────
const VALID_EVENT_TYPES = [
  'goal', 'penalty_goal', 'own_goal',
  'yellow_card', 'red_card',
  'substitution', 'assist',
  'foul', 'offside', 'corner', 'var',
];

// POST /api/matches/:id/events
const addMatchEvent = async (req, res) => {
  try {
    const match = await Match.findByPk(req.params.id);
    if (!match) return res.status(404).json({ message: 'Match introuvable' });

    const { type, minute, extraMinute, isHomeTeam, relatedPlayerName, relatedPlayerId, description,
      substitutionPlayerInId, substitutionPlayerInName, substitutionPlayerOutId, substitutionPlayerOutName } = req.body;

    if (!type) return res.status(400).json({ message: 'Le type d\'événement est requis' });
    // ── #14 : Validation du type ─────────────────────────────────────────────
    if (!VALID_EVENT_TYPES.includes(type)) {
      return res.status(400).json({
        message: `Type d'événement invalide : "${type}". Valeurs acceptées : ${VALID_EVENT_TYPES.join(', ')}`,
      });
    }
    if (!minute) return res.status(400).json({ message: 'La minute est requise' });

    const event = await MatchEvent.create({
      matchId: match.id, type, minute: parseInt(minute),
      extraMinute: extraMinute ? parseInt(extraMinute) : null,
      isHomeTeam: Boolean(isHomeTeam),
      relatedPlayerName: relatedPlayerName || null,
      relatedPlayerId: relatedPlayerId || null,
      description: description || null,
      substitutionPlayerInId: substitutionPlayerInId || null,
      substitutionPlayerInName: substitutionPlayerInName || null,
      substitutionPlayerOutId: substitutionPlayerOutId || null,
      substitutionPlayerOutName: substitutionPlayerOutName || null,
    });

    // auto-update score on goal events
    if (type === 'goal' || type === 'penalty_goal') {
      const field = isHomeTeam ? 'homeTeamScore' : 'awayTeamScore';
      await match.update({ [field]: (match[field] || 0) + 1 });
    } else if (type === 'own_goal') {
      // own goal → opposite team scores
      const field = isHomeTeam ? 'awayTeamScore' : 'homeTeamScore';
      await match.update({ [field]: (match[field] || 0) + 1 });
    }

    // ── Auto-update player stats ──────────────────────────────────────────────
    const statMap = EVENT_STAT_MAP[type];
    if (statMap && event[statMap.playerId]) {
      await applyStatDelta(event[statMap.playerId], statMap.field, +1);
    }

    const refreshed = await Match.findByPk(match.id, { include: matchIncludes });
    emit(match.tournamentId, 'match-event-added', { matchId: match.id, eventId: event.id });
    emitLive(match.id, 'event', { match: refreshed, event });
    res.status(201).json({ event, match: refreshed });
  } catch (error) {
    console.error('addMatchEvent error:', error);
    res.status(500).json({ message: 'Erreur lors de l\'ajout de l\'événement' });
  }
};

// DELETE /api/matches/:id/events/:eventId
const deleteMatchEvent = async (req, res) => {
  try {
    const { id, eventId } = req.params;
    const event = await MatchEvent.findOne({ where: { id: eventId, matchId: id } });
    if (!event) return res.status(404).json({ message: 'Événement introuvable' });

    const match = await Match.findByPk(id);

    // reverse score impact
    if (event.type === 'goal' || event.type === 'penalty_goal') {
      const field = event.isHomeTeam ? 'homeTeamScore' : 'awayTeamScore';
      await match.update({ [field]: Math.max(0, (match[field] || 0) - 1) });
    } else if (event.type === 'own_goal') {
      const field = event.isHomeTeam ? 'awayTeamScore' : 'homeTeamScore';
      await match.update({ [field]: Math.max(0, (match[field] || 0) - 1) });
    }

    // ── Reverse player stats ──────────────────────────────────────────────────
    const statMap = EVENT_STAT_MAP[event.type];
    if (statMap && event[statMap.playerId]) {
      await applyStatDelta(event[statMap.playerId], statMap.field, -1);
    }

    await event.destroy();
    const refreshed = await Match.findByPk(id, { include: matchIncludes });
    emit(match.tournamentId, 'match-event-deleted', { matchId: id, eventId });
    emitLive(id, 'event-deleted', { match: refreshed, eventId });
    res.json({ message: 'Événement supprimé', match: refreshed });
  } catch (error) {
    console.error('deleteMatchEvent error:', error);
    res.status(500).json({ message: 'Erreur lors de la suppression de l\'événement' });
  }
};

// Legacy routes kept for compatibility
const scheduleMatch = async (req, res) => {
  req.body.status = req.body.status || 'scheduled';
  return updateMatch(req, res);
};

const submitScore = async (req, res) => {
  req.body.status = req.body.status || 'completed';
  return updateMatch(req, res);
};

// GET /api/matches/public/recent  — no auth required
const getPublicMatches = async (req, res) => {
  try {
    const matches = await Match.findAll({
      where: {
        status: { [Op.in]: ['completed', 'in_progress', 'scheduled'] },
      },
      include: [
        { model: Team,       as: 'homeTeam',   attributes: ['id', 'name'] },
        { model: Team,       as: 'awayTeam',   attributes: ['id', 'name'] },
        { model: Tournament, as: 'tournament', attributes: ['id', 'name'] },
      ],
      order: [['date', 'DESC']],
      limit: 5,
    });
    res.json({ matches });
  } catch (error) {
    console.error('getPublicMatches error:', error);
    res.status(500).json({ message: 'Erreur chargement matchs publics' });
  }
};

module.exports = {
  getMatches, getMatch, createMatch, updateMatch, deleteMatch,
  addMatchEvent, deleteMatchEvent,
  scheduleMatch, submitScore,
  getPublicMatches,
};
