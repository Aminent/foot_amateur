const { Op } = require('sequelize');
const { Match, MatchEvent, Team, Tournament, Player, User, PlayerStat } = require('../models');
const notificationService = require('../services/notificationService');
const { recomputePlayerStats, playerIdsOfEvents, playerIdsOfMatches, scoreFromEvents } = require('../services/statsService');

// Minutes, goals conceded and clean sheets depend on the whole match: recompute everyone involved.
const recomputeMatchPlayers = async (matchId, extraIds = []) =>
  recomputePlayerStats([...await playerIdsOfMatches([matchId]), ...extraIds]);
const { syncTournamentStatus } = require('../services/tournamentService');

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

// A tournament match may only oppose teams registered in that tournament.
const teamsOutsideTournament = async (tournamentId, ids) => {
  if (!tournamentId) return null;
  const teams = await Team.findAll({ where: { id: ids.filter(Boolean) }, attributes: ['id', 'name', 'tournamentId'] });
  const outside = teams.filter(t => String(t.tournamentId) !== String(tournamentId));
  return outside.length ? `${outside.map(t => t.name).join(', ')} : équipe non inscrite à ce tournoi` : null;
};

// Winner of a match given its (saved or prospective) state; a bracket draw needs an explicit shoot-out winner.
const winnerOf = ({ status, homeTeamId, awayTeamId, homeTeamScore, awayTeamScore, matchIndex }, chosen) => {
  if (status !== 'completed' || !homeTeamId || !awayTeamId) return null;
  if (homeTeamScore > awayTeamScore) return homeTeamId;
  if (awayTeamScore > homeTeamScore) return awayTeamId;
  if (matchIndex !== null && matchIndex !== undefined
      && chosen && [String(homeTeamId), String(awayTeamId)].includes(String(chosen))) return Number(chosen);
  return null;
};

// A stored winner only counts as shoot-out winner if the stored result was already a draw.
const shootoutWinner = (match) =>
  match.status === 'completed' && match.homeTeamScore === match.awayTeamScore ? match.winnerTeamId : null;

// The next bracket match is frozen once played: its slot must not change under it.
const nextSlotConflict = async (match, winnerTeamId) => {
  if (!match.advancesToMatchId) return null;
  const next = await Match.findByPk(match.advancesToMatchId);
  if (!next) return null;
  const key = (match.matchIndex ?? 0) % 2 === 0 ? 'homeTeamId' : 'awayTeamId';
  if (String(next[key] ?? '') === String(winnerTeamId ?? '')) return null;
  return next.status === 'completed'
    ? 'Le match suivant du tableau est déjà joué : ce résultat ne peut plus changer le qualifié'
    : null;
};

const advanceWinner = async (match) => {
  if (!match.advancesToMatchId) return;
  const next = await Match.findByPk(match.advancesToMatchId);
  if (!next) return;
  const key = (match.matchIndex ?? 0) % 2 === 0 ? 'homeTeamId' : 'awayTeamId';
  if (String(next[key] ?? '') === String(match.winnerTeamId ?? '')) return;
  await next.update({ [key]: match.winnerTeamId });
  emit(match.tournamentId, 'match-updated', { matchId: next.id, tournamentId: match.tournamentId });
};

// GET /api/matches
const getMatches = async (req, res) => {
  try {
    const { tournamentId, status, teamId } = req.query;
    const where = {};
    if (tournamentId) where.tournamentId = tournamentId;
    if (status) where.status = status;
    if (teamId) {
      // a team's list shows games it played, not byes (no opponent)
      where[Op.or] = [{ homeTeamId: teamId }, { awayTeamId: teamId }];
      where[Op.and] = [{ homeTeamId: { [Op.ne]: null } }, { awayTeamId: { [Op.ne]: null } }];
    }

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
    if (tournamentId) {
      const tournament = await Tournament.findByPk(tournamentId);
      if (!tournament) return res.status(404).json({ message: 'Tournoi introuvable' });
      if (tournament.format === 'knockout') {
        return res.status(400).json({ message: "Les matchs d'un tournoi à élimination sont créés par la génération du tableau" });
      }
      const outside = await teamsOutsideTournament(tournamentId, [homeTeamId, awayTeamId]);
      if (outside) return res.status(400).json({ message: outside });
    }

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
    await syncTournamentStatus(match.tournamentId);
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

    // An empty select sends '' — treat it as "unchanged", never as "remove the team".
    const pick = (v, cur) => (v === undefined || v === '' ? cur : v);
    const finalHomeId = pick(homeTeamId, match.homeTeamId);
    const finalAwayId = pick(awayTeamId, match.awayTeamId);
    const finalTournamentId = pick(tournamentId, match.tournamentId);
    const finalStatus = status ?? match.status;
    const isBracketMatch = match.matchIndex !== null && match.matchIndex !== undefined;

    const teamsChanged = String(finalHomeId ?? '') !== String(match.homeTeamId ?? '')
      || String(finalAwayId ?? '') !== String(match.awayTeamId ?? '');
    const tournamentChanged = String(finalTournamentId ?? '') !== String(match.tournamentId ?? '');
    if (isBracketMatch && (teamsChanged || tournamentChanged)) {
      return res.status(400).json({ message: "Les équipes d'un match du tableau sont fixées par le tableau et ne peuvent pas être modifiées" });
    }
    if (teamsChanged || tournamentChanged) {
      const outside = await teamsOutsideTournament(finalTournamentId, [finalHomeId, finalAwayId]);
      if (outside) return res.status(400).json({ message: outside });
    }

    // Once goal events exist, they decide the score.
    const eventScore = await scoreFromEvents(match.id);
    const homeScore = eventScore ? eventScore.homeTeamScore : homeTeamScore !== undefined ? Number(homeTeamScore) : match.homeTeamScore;
    const awayScore = eventScore ? eventScore.awayTeamScore : awayTeamScore !== undefined ? Number(awayTeamScore) : match.awayTeamScore;

    if (finalStatus === 'completed' && (!finalHomeId || !finalAwayId)) {
      return res.status(400).json({ message: 'Impossible de clôturer un match sans ses deux équipes' });
    }
    const winnerTeamId = winnerOf({
      status: finalStatus, homeTeamId: finalHomeId, awayTeamId: finalAwayId,
      homeTeamScore: homeScore, awayTeamScore: awayScore, matchIndex: match.matchIndex,
    }, req.body.winnerTeamId ?? shootoutWinner(match));
    if (finalStatus === 'completed' && isBracketMatch && !winnerTeamId) {
      return res.status(400).json({ message: 'Match nul en élimination : choisissez le vainqueur aux tirs au but' });
    }
    const conflict = await nextSlotConflict(match, winnerTeamId);
    if (conflict) return res.status(400).json({ message: conflict });

    // ── #2 : Avertissement si clôture avec score 0-0 ─────────────────────────
    const scoreWarning = (status === 'completed' && homeScore === 0 && awayScore === 0)
      ? 'Attention : le match est clôturé avec un score de 0-0. Vérifiez que le résultat est correct.'
      : null;

    await match.update({
      tournamentId: finalTournamentId,
      homeTeamId: finalHomeId,
      awayTeamId: finalAwayId,
      date: date ?? match.date,
      location: location !== undefined ? location : match.location,
      roundNumber: isBracketMatch ? match.roundNumber
        : roundNumber !== undefined ? (roundNumber ? parseInt(roundNumber) : null) : match.roundNumber,
      referee: referee !== undefined ? referee : match.referee,
      notes: notes !== undefined ? notes : match.notes,
      status: finalStatus,
      homeTeamScore: homeScore,
      awayTeamScore: awayScore,
      halfTimeHomeScore: halfTimeHomeScore !== undefined ? Number(halfTimeHomeScore) : match.halfTimeHomeScore,
      halfTimeAwayScore: halfTimeAwayScore !== undefined ? Number(halfTimeAwayScore) : match.halfTimeAwayScore,
      attendance: attendance !== undefined ? (attendance ? parseInt(attendance) : null) : match.attendance,
      weather: weather !== undefined ? weather : match.weather,
      winnerTeamId,
    });

    await advanceWinner(match);
    await syncTournamentStatus(match.tournamentId);
    await recomputeMatchPlayers(match.id);

    const full = await Match.findByPk(match.id, { include: matchIncludes });
    emit(match.tournamentId, 'match-updated', { matchId: match.id, tournamentId: match.tournamentId });
    emitLive(match.id, 'status', { match: full });
    res.json({ match: full, ...(scoreWarning ? { warning: scoreWarning } : {}) });

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
    if (match.matchIndex !== null && match.matchIndex !== undefined) {
      return res.status(400).json({ message: 'Un match du tableau ne peut pas être supprimé seul : régénérez le tableau du tournoi' });
    }
    const affected = await playerIdsOfMatches([match.id]);
    await MatchEvent.destroy({ where: { matchId: match.id } });
    await match.destroy();
    await recomputePlayerStats(affected);
    await syncTournamentStatus(match.tournamentId);

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

// After an event change: score from goal events, then winner/advancement. Returns an error message to roll back.
const resyncAfterEvents = async (match) => {
  const score = await scoreFromEvents(match.id) || { homeTeamScore: 0, awayTeamScore: 0 };
  const next = { ...match.toJSON(), ...score };
  const winnerTeamId = winnerOf(next, shootoutWinner(match));
  if (next.status === 'completed' && next.matchIndex !== null && next.matchIndex !== undefined && !winnerTeamId) {
    return 'Ce changement rend le match nul : rouvrez le résultat et choisissez le vainqueur aux tirs au but';
  }
  const conflict = await nextSlotConflict(match, winnerTeamId);
  if (conflict) return conflict;
  await match.update({ ...score, winnerTeamId });
  await advanceWinner(match);
  await syncTournamentStatus(match.tournamentId);
  return null;
};

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

    const sideTeamId = isHomeTeam ? match.homeTeamId : match.awayTeamId;
    const names = {};
    for (const [idKey, nameKey] of [['relatedPlayerId', 'relatedPlayerName'], ['substitutionPlayerInId', 'substitutionPlayerInName'], ['substitutionPlayerOutId', 'substitutionPlayerOutName']]) {
      if (!req.body[idKey]) continue;
      const p = await Player.findByPk(req.body[idKey], { attributes: ['id', 'name', 'teamId'] });
      if (!p || String(p.teamId) !== String(sideTeamId)) {
        return res.status(400).json({ message: "Le joueur choisi n'appartient pas à l'équipe indiquée pour cet événement" });
      }
      names[nameKey] = p.name;
    }

    const event = await MatchEvent.create({
      matchId: match.id, type, minute: parseInt(minute),
      extraMinute: extraMinute ? parseInt(extraMinute) : null,
      isHomeTeam: Boolean(isHomeTeam),
      relatedPlayerName: names.relatedPlayerName || relatedPlayerName || null,
      relatedPlayerId: relatedPlayerId || null,
      description: description || null,
      substitutionPlayerInId: substitutionPlayerInId || null,
      substitutionPlayerInName: names.substitutionPlayerInName || substitutionPlayerInName || null,
      substitutionPlayerOutId: substitutionPlayerOutId || null,
      substitutionPlayerOutName: names.substitutionPlayerOutName || substitutionPlayerOutName || null,
    });

    const err = await resyncAfterEvents(match);
    if (err) {
      await event.destroy();
      return res.status(400).json({ message: err });
    }
    await recomputeMatchPlayers(match.id);

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

    const snapshot = event.toJSON();
    await event.destroy();
    const err = await resyncAfterEvents(match);
    if (err) {
      await MatchEvent.create(snapshot);
      return res.status(400).json({ message: err });
    }
    await recomputeMatchPlayers(match.id, playerIdsOfEvents([snapshot]));
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
