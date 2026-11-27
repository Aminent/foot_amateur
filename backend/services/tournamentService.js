const { Tournament, Match } = require('../models');

// draft = registrations open · active = bracket generated / games played · completed = final (or every league game) played
const syncTournamentStatus = async (tournamentId) => {
  if (!tournamentId) return;
  const tournament = await Tournament.findByPk(tournamentId);
  if (!tournament || tournament.status === 'cancelled') return;

  const matches = await Match.findAll({ where: { tournamentId }, attributes: ['status', 'roundNumber', 'matchIndex', 'advancesToMatchId'], raw: true });
  if (!matches.length) return;

  let finished;
  if (tournament.format === 'knockout') {
    const final = matches.find(m => m.matchIndex !== null && !m.advancesToMatchId);
    finished = final?.status === 'completed';
  } else {
    const played = matches.filter(m => m.status !== 'cancelled');
    finished = played.length > 0 && played.every(m => m.status === 'completed');
  }

  const started = matches.some(m => ['completed', 'in_progress', 'half_time'].includes(m.status))
    || (tournament.format === 'knockout' && matches.some(m => m.matchIndex !== null));

  const next = finished ? 'completed' : started ? 'active' : tournament.status;
  if (next !== tournament.status) await tournament.update({ status: next });
};

// League table; a knockout tournament has no points table (its bracket is the standing).
// Tie-break, same as the web page: points, goal difference, goals scored, name.
const computeStandings = async (tournament, teams, completedMatches) => {
  if (!tournament || tournament.format === 'knockout') return [];
  const rows = {};
  teams.forEach(t => { rows[t.id] = { id: t.id, name: t.name, P: 0, W: 0, D: 0, L: 0, GF: 0, GA: 0, GD: 0, Pts: 0 }; });
  completedMatches.forEach(m => {
    const h = rows[m.homeTeamId], a = rows[m.awayTeamId];
    if (!h || !a) return;
    const hg = m.homeTeamScore ?? 0, ag = m.awayTeamScore ?? 0;
    h.P++; h.GF += hg; h.GA += ag; h.GD += hg - ag;
    a.P++; a.GF += ag; a.GA += hg; a.GD += ag - hg;
    if (hg > ag) { h.W++; h.Pts += 3; a.L++; }
    else if (hg < ag) { a.W++; a.Pts += 3; h.L++; }
    else { h.D++; h.Pts++; a.D++; a.Pts++; }
  });
  return Object.values(rows)
    .sort((a, b) => b.Pts - a.Pts || b.GD - a.GD || b.GF - a.GF || a.name.localeCompare(b.name))
    .map((r, i) => ({ ...r, position: i + 1 }));
};

module.exports = { syncTournamentStatus, computeStandings };
