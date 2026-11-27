const { Tournament, Team, Match, MatchEvent } = require('../models');
const { recomputePlayerStats, playerIdsOfMatches } = require('../services/statsService');

// ── Utilitaire : plus petite puissance de 2 >= n ─────────────────────────────
const nextPow2 = (n) => Math.pow(2, Math.ceil(Math.log2(Math.max(n, 2))));

// Generate knockout bracket matches if not already generated
const generateBracket = async (req, res) => {
  try {
    const { id } = req.params;
    const tournament = await Tournament.findByPk(id, { include: [{ model: Team, as: 'teams' }] });
    if (!tournament) return res.status(404).json({ message: 'Tournament not found' });
    if (tournament.format !== 'knockout') return res.status(400).json({ message: 'Bracket only for knockout format' });

    // ── FIX #7 : interdire la régénération si le tournoi est déjà actif ───────
    if (tournament.status === 'active' || tournament.status === 'completed') {
      return res.status(400).json({
        message: 'Impossible de régénérer le tableau : le tournoi est déjà lancé. Repassez-le en brouillon pour le régénérer (tous ses matchs seront supprimés).',
      });
    }

    const teams = tournament.teams || [];
    if (teams.length < 2) return res.status(400).json({ message: 'Not enough teams' });

    // ── FIX #5 : arrondir à la prochaine puissance de 2 ──────────────────────
    // Sized on registered teams (registrations close here), so every first-round match has at least one team.
    const maxTeams = nextPow2(teams.length);
    const totalRounds = Math.log2(maxTeams); // maintenant toujours un entier

    // Clear existing matches; the stats their events produced must go with them.
    const oldMatchIds = (await Match.findAll({ where: { tournamentId: tournament.id }, attributes: ['id'], raw: true })).map(m => m.id);
    const affectedPlayers = await playerIdsOfMatches(oldMatchIds);
    if (oldMatchIds.length) await MatchEvent.destroy({ where: { matchId: oldMatchIds } });
    await Match.destroy({ where: { tournamentId: tournament.id } });
    await recomputePlayerStats(affectedPlayers);

    // Spread byes so that no first-round match is empty: slot 2i = team i, slot 2i+1 = team half+i.
    const half = maxTeams / 2;
    const slots = [];
    for (let i = 0; i < half; i++) {
      slots.push(teams[i] ? teams[i].id : null, teams[half + i] ? teams[half + i].id : null);
    }

    const createdMatches = [];
    for (let round = 1; round <= totalRounds; round++) {
      const matchesInRound = maxTeams / Math.pow(2, round);
      for (let idx = 0; idx < matchesInRound; idx++) {
        const isFirstRound = round === 1;
        const match = await Match.create({
          tournamentId: tournament.id,
          roundNumber: round,
          matchIndex: idx,
          homeTeamId: isFirstRound ? slots[idx * 2] : null,
          awayTeamId: isFirstRound ? slots[idx * 2 + 1] : null,
          date: tournament.startDate || new Date(),
          status: 'scheduled'
        });
        createdMatches.push(match);
      }
    }

    for (const match of createdMatches) {
      if (match.roundNumber >= totalRounds) continue;
      const next = createdMatches.find(m => m.roundNumber === match.roundNumber + 1 && m.matchIndex === Math.floor(match.matchIndex / 2));
      if (next) await match.update({ advancesToMatchId: next.id });
    }

    // A team without an opponent in round 1 goes straight through.
    for (const match of createdMatches.filter(m => m.roundNumber === 1)) {
      const lone = match.homeTeamId && !match.awayTeamId ? match.homeTeamId : null;
      if (!lone) continue;
      await match.update({ status: 'completed', winnerTeamId: lone, notes: 'Qualifié d\'office (exempt)' });
      const next = createdMatches.find(m => m.id === match.advancesToMatchId);
      if (next) await next.update(match.matchIndex % 2 === 0 ? { homeTeamId: lone } : { awayTeamId: lone });
    }

    await tournament.update({ status: 'active' });

    const matches = await Match.findAll({ where: { tournamentId: tournament.id }, order: [['roundNumber', 'ASC'], ['matchIndex', 'ASC']] });
    
    // Emit live update
    if (global.io) {
      global.io.to(`tournament-${tournament.id}`).emit('bracket-updated', {
        type: 'bracket-generated',
        tournamentId: tournament.id
      });
    }
    
    res.json({ message: 'Bracket generated', matches });
  } catch (error) {
    console.error('generateBracket error:', error);
    res.status(500).json({ message: 'Error generating bracket' });
  }
};

// Round-robin pairings (circle method): every team meets every other team once per leg.
// Returns [[ [homeId, awayId], ... ] per round]. Home/away alternates so no team is always at home.
const roundRobin = (teamIds, doubleLeg) => {
  const ids = [...teamIds];
  if (ids.length % 2) ids.push(null); // odd count: one team rests each round
  const n = ids.length;
  const rounds = [];
  let ring = ids.slice(1);
  for (let r = 0; r < n - 1; r++) {
    const order = [ids[0], ...ring];
    const pairs = [];
    for (let i = 0; i < n / 2; i++) {
      const a = order[i], b = order[n - 1 - i];
      if (a === null || b === null) continue;
      // fixed team alternates every round; the others by board position — gives 7/8 home games each
      const aAtHome = i === 0 ? r % 2 === 0 : i % 2 === 1;
      pairs.push(aAtHome ? [a, b] : [b, a]);
    }
    rounds.push(pairs);
    ring = [ring[ring.length - 1], ...ring.slice(0, -1)];
  }
  return doubleLeg ? [...rounds, ...rounds.map(p => p.map(([h, a]) => [a, h]))] : rounds;
};

// POST /tournaments/:id/schedule/generate  { firstDate, time, daysBetween, doubleLeg, location }
// League fixture list: one "journée" every `daysBetween` days. Closes registrations.
const generateLeagueSchedule = async (req, res) => {
  try {
    const tournament = await Tournament.findByPk(req.params.id, { include: [{ model: Team, as: 'teams' }] });
    if (!tournament) return res.status(404).json({ message: 'Tournoi introuvable' });
    if (tournament.format !== 'league') return res.status(400).json({ message: 'Réservé aux tournois de type championnat' });
    const teams = tournament.teams || [];
    if (teams.length < 2) return res.status(400).json({ message: 'Il faut au moins 2 équipes' });

    const existing = await Match.findAll({ where: { tournamentId: tournament.id }, attributes: ['id', 'status'], raw: true });
    if (existing.some(m => ['completed', 'in_progress', 'half_time'].includes(m.status))) {
      return res.status(400).json({ message: 'Des matchs ont déjà été joués : le calendrier ne peut plus être régénéré' });
    }

    const { firstDate, time = '15:00', daysBetween = 7, doubleLeg = false, location } = req.body;
    const start = new Date(`${(firstDate || tournament.startDate?.toISOString?.().slice(0, 10) || new Date().toISOString().slice(0, 10))}T${time}:00`);
    if (isNaN(start)) return res.status(400).json({ message: 'Date ou heure invalide' });
    const gap = Math.max(1, parseInt(daysBetween) || 7);

    if (existing.length) {
      await MatchEvent.destroy({ where: { matchId: existing.map(m => m.id) } });
      await Match.destroy({ where: { tournamentId: tournament.id } });
    }

    const rounds = roundRobin(teams.map(t => t.id), Boolean(doubleLeg));
    for (const [r, pairs] of rounds.entries()) {
      // calendar days, not milliseconds: keeps the kick-off hour across daylight-saving changes
      const date = new Date(start); date.setDate(start.getDate() + r * gap);
      for (const [homeTeamId, awayTeamId] of pairs) {
        await Match.create({
          tournamentId: tournament.id, homeTeamId, awayTeamId, date,
          roundNumber: r + 1, status: 'scheduled', homeTeamScore: 0, awayTeamScore: 0,
          location: location || null,
        });
      }
    }
    await tournament.update({ status: 'active' });

    if (global.io) global.io.to(`tournament-${tournament.id}`).emit('bracket-updated', { type: 'schedule-generated', tournamentId: tournament.id });
    const total = rounds.reduce((s, p) => s + p.length, 0);
    res.json({ message: `Calendrier créé : ${rounds.length} journées, ${total} matchs`, rounds: rounds.length, matches: total });
  } catch (error) {
    console.error('generateLeagueSchedule error:', error);
    res.status(500).json({ message: 'Erreur lors de la génération du calendrier' });
  }
};

// Get bracket grouped by rounds
const getBracket = async (req, res) => {
  try {
    const { id } = req.params;
    const tournament = await Tournament.findByPk(id);
    if (!tournament) return res.status(404).json({ message: 'Tournament not found' });

  const matches = await Match.findAll({
      where: { tournamentId: id },
      include: [
        { association: Match.associations.homeTeam, attributes: ['id', 'name'] },
        { association: Match.associations.awayTeam, attributes: ['id', 'name'] }
      ],
      order: [['roundNumber', 'ASC'], ['matchIndex', 'ASC']]
    });

    const rounds = {};
    for (const m of matches) {
      if (!rounds[m.roundNumber]) rounds[m.roundNumber] = [];
      rounds[m.roundNumber].push(m);
    }

    res.json({ rounds, matches });
  } catch (error) {
    console.error('getBracket error:', error);
    res.status(500).json({ message: 'Error fetching bracket' });
  }
};

module.exports = { generateBracket, getBracket, generateLeagueSchedule, roundRobin };


