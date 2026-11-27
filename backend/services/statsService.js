const { Op } = require('sequelize');
const { Match, MatchEvent, MatchLineup, Player, PlayerStat } = require('../models');

const MATCH_MINUTES = 90;

// Match data is the single source of truth for these fields; they are never typed by hand.
const EVENT_STAT_MAP = {
  goal:         'goals',
  penalty_goal: 'goals',
  assist:       'assists',
  yellow_card:  'yellowCards',
  red_card:     'redCards',
};
const EVENT_FIELDS = ['goals', 'assists', 'yellowCards', 'redCards'];
const DERIVED_FIELDS = [...EVENT_FIELDS, 'minutesPlayed', 'cleanSheets', 'goalsConceded'];

const lineupStarters = (lineups) =>
  lineups.flatMap(l => (Array.isArray(l.players) ? l.players : []).filter(p => p.isStarter).map(p => Number(p.playerId)));

// For one completed match: { playerId → { teamId, minutes } } for everyone who took part.
const participationIn = (match, lineups, events) => {
  const out = {};
  const sideOf = (isHome) => (isHome ? match.homeTeamId : match.awayTeamId);
  for (const l of lineups) {
    for (const p of (Array.isArray(l.players) ? l.players : [])) {
      if (p.isStarter) out[Number(p.playerId)] = { teamId: l.teamId, minutes: MATCH_MINUTES };
    }
  }
  for (const e of events.filter(x => x.type === 'substitution')) {
    const team = sideOf(e.isHomeTeam);
    if (e.substitutionPlayerOutId) {
      const id = Number(e.substitutionPlayerOutId);
      out[id] = { teamId: out[id]?.teamId ?? team, minutes: Math.min(out[id]?.minutes ?? MATCH_MINUTES, e.minute) };
    }
    if (e.substitutionPlayerInId) {
      out[Number(e.substitutionPlayerInId)] = { teamId: team, minutes: Math.max(0, MATCH_MINUTES - e.minute) };
    }
  }
  // Someone with an event but in no lineup: assume a full match (no better information).
  for (const e of events) {
    if (e.relatedPlayerId && !out[Number(e.relatedPlayerId)]) {
      out[Number(e.relatedPlayerId)] = { teamId: sideOf(e.isHomeTeam), minutes: MATCH_MINUTES };
    }
  }
  return out;
};

const recomputePlayerStats = async (playerIds) => {
  const ids = [...new Set((playerIds || []).filter(Boolean).map(Number))];
  if (!ids.length) return;

  const players = await Player.findAll({ where: { id: ids }, attributes: ['id', 'position'], raw: true });
  const completed = await Match.findAll({ where: { status: 'completed' }, raw: true });
  const completedIds = completed.map(m => m.id);
  const [lineups, events] = await Promise.all([
    completedIds.length ? MatchLineup.findAll({ where: { matchId: completedIds }, raw: true }) : [],
    MatchEvent.findAll({ raw: true }),
  ]);

  const fields = Object.fromEntries(ids.map(id => [id, Object.fromEntries(DERIVED_FIELDS.map(f => [f, 0]))]));
  for (const e of events) {
    const f = EVENT_STAT_MAP[e.type];
    if (f && fields[e.relatedPlayerId]) fields[e.relatedPlayerId][f]++;
  }

  const isKeeper = Object.fromEntries(players.map(p => [p.id, p.position === 'gardien']));
  for (const m of completed) {
    if (!m.homeTeamId || !m.awayTeamId) continue; // bye
    const part = participationIn(m, lineups.filter(l => l.matchId === m.id), events.filter(e => e.matchId === m.id));
    for (const id of ids) {
      const p = part[id];
      if (!p) continue;
      fields[id].minutesPlayed += p.minutes;
      if (isKeeper[id]) {
        const conceded = String(p.teamId) === String(m.homeTeamId) ? m.awayTeamScore ?? 0 : m.homeTeamScore ?? 0;
        fields[id].goalsConceded += conceded;
        if (conceded === 0) fields[id].cleanSheets++;
      }
    }
  }

  for (const id of ids) {
    const [stat] = await PlayerStat.findOrCreate({ where: { playerId: id }, defaults: { playerId: id } });
    await stat.update(fields[id]);
  }
};

const playerIdsOfEvents = (events) =>
  events.flatMap(e => [e.relatedPlayerId, e.substitutionPlayerInId, e.substitutionPlayerOutId]).filter(Boolean);

// Everyone whose stats depend on these matches: lineups and events.
const playerIdsOfMatches = async (matchIds) => {
  if (!matchIds.length) return [];
  const [events, lineups] = await Promise.all([
    MatchEvent.findAll({ where: { matchId: { [Op.in]: matchIds } }, raw: true }),
    MatchLineup.findAll({ where: { matchId: { [Op.in]: matchIds } }, raw: true }),
  ]);
  return [
    ...playerIdsOfEvents(events),
    ...lineups.flatMap(l => (Array.isArray(l.players) ? l.players : []).map(p => Number(p.playerId))),
  ];
};

// Goal events decide the score once at least one goal has been recorded.
const scoreFromEvents = async (matchId) => {
  const events = await MatchEvent.findAll({
    where: { matchId, type: { [Op.in]: ['goal', 'penalty_goal', 'own_goal'] } },
    attributes: ['type', 'isHomeTeam'],
    raw: true,
  });
  if (!events.length) return null;
  let home = 0, away = 0;
  for (const e of events) {
    const forHome = e.type === 'own_goal' ? !e.isHomeTeam : e.isHomeTeam;
    if (forHome) home++; else away++;
  }
  return { homeTeamScore: home, awayTeamScore: away };
};

const playedMatchIds = async (playerId) => {
  const pid = Number(playerId);
  const completed = await Match.findAll({
    where: { status: 'completed', homeTeamId: { [Op.ne]: null }, awayTeamId: { [Op.ne]: null } },
    attributes: ['id'], raw: true,
  });
  const completedIds = completed.map(m => m.id);
  if (!completedIds.length) return new Set();
  const [lineups, events] = await Promise.all([
    MatchLineup.findAll({ where: { matchId: completedIds }, raw: true }),
    MatchEvent.findAll({
      where: { matchId: completedIds, [Op.or]: [{ relatedPlayerId: pid }, { substitutionPlayerInId: pid }] },
      attributes: ['matchId'], raw: true,
    }),
  ]);
  const played = new Set(events.map(e => e.matchId));
  for (const l of lineups) if (lineupStarters([l]).includes(pid)) played.add(l.matchId);
  return played;
};

const matchesPlayedCount = async (playerId) => (await playedMatchIds(playerId)).size;

// V / N / D from a team's point of view; a shoot-out winner (winnerTeamId on a draw) counts as a win.
const resultFor = (match, teamId) => {
  if (match.status !== 'completed' || !match.homeTeamId || !match.awayTeamId) return null;
  if (match.winnerTeamId) return String(match.winnerTeamId) === String(teamId) ? 'V' : 'D';
  const isHome = String(match.homeTeamId) === String(teamId);
  const gf = (isHome ? match.homeTeamScore : match.awayTeamScore) ?? 0;
  const ga = (isHome ? match.awayTeamScore : match.homeTeamScore) ?? 0;
  return gf > ga ? 'V' : gf < ga ? 'D' : 'N';
};

module.exports = {
  DERIVED_FIELDS,
  recomputePlayerStats,
  playerIdsOfEvents,
  playerIdsOfMatches,
  scoreFromEvents,
  playedMatchIds,
  matchesPlayedCount,
  resultFor,
};
