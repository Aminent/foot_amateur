const { Player, PlayerStat, Match, MatchEvent } = require('../models');
const { matchesPlayedCount, playedMatchIds, recomputePlayerStats } = require('../services/statsService');

// Faits du joueur match par match (ordre chronologique) : alimente les courbes d'évolution.
const EVENT_KEY = { goal: 'goals', penalty_goal: 'goals', assist: 'assists', yellow_card: 'yellowCards', red_card: 'redCards' };
const perMatchStatsOf = async (playerId) => {
  const ids = [...await playedMatchIds(playerId)];
  if (!ids.length) return [];
  const [matches, events] = await Promise.all([
    Match.findAll({ where: { id: ids }, attributes: ['id', 'date'], order: [['date', 'ASC']], raw: true }),
    MatchEvent.findAll({ where: { matchId: ids, relatedPlayerId: playerId }, attributes: ['matchId', 'type'], raw: true }),
  ]);
  return matches.map(m => {
    const row = { matchId: m.id, date: m.date, goals: 0, assists: 0, yellowCards: 0, redCards: 0 };
    for (const e of events) if (e.matchId === m.id && EVENT_KEY[e.type]) row[EVENT_KEY[e.type]]++;
    return row;
  });
};

const getStats = async (req, res) => {
  try {
    const { playerId } = req.params;
    let stats = await PlayerStat.findOne({ where: { playerId } });
    if (!stats) stats = await PlayerStat.create({ playerId });

    const [matchesPlayed, perMatchStats] = await Promise.all([matchesPlayedCount(playerId), perMatchStatsOf(Number(playerId))]);

    res.json({ stats: { ...stats.toJSON(), matchesPlayed, perMatchStats } });
  } catch (error) {
    console.error('Error getting stats:', error);
    res.status(500).json({ message: 'Erreur lors de la récupération des statistiques' });
  }
};

const setStats = async (req, res) => {
  try {
    const { playerId } = req.params;
    let stats = await PlayerStat.findOne({ where: { playerId } });
    if (!stats) stats = await PlayerStat.create({ playerId });
    // goals, assists, cards, minutes, clean sheets and goals conceded are derived from matches (services/statsService).
    const {
      shots, shotsOnTarget, passes, keyPasses, tackles,
      interceptions, clearances, dribbles, foulsCommitted, foulsSuffered,
      offsides, saves, penaltiesSaved,
      duelsWon, aerialDuelsWon,
    } = req.body;
    await stats.update({
      ...(shots !== undefined && { shots }),
      ...(shotsOnTarget !== undefined && { shotsOnTarget }),
      ...(passes !== undefined && { passes }),
      ...(keyPasses !== undefined && { keyPasses }),
      ...(tackles !== undefined && { tackles }),
      ...(interceptions !== undefined && { interceptions }),
      ...(clearances !== undefined && { clearances }),
      ...(dribbles !== undefined && { dribbles }),
      ...(foulsCommitted !== undefined && { foulsCommitted }),
      ...(foulsSuffered !== undefined && { foulsSuffered }),
      ...(offsides !== undefined && { offsides }),
      ...(saves !== undefined && { saves }),
      ...(penaltiesSaved !== undefined && { penaltiesSaved }),
      ...(duelsWon !== undefined && { duelsWon }),
      ...(aerialDuelsWon !== undefined && { aerialDuelsWon }),
    });
    res.json({ message: 'Statistiques mises à jour', stats });
  } catch (error) {
    console.error('Error setting stats:', error);
    res.status(500).json({ message: 'Erreur lors de la mise à jour des statistiques' });
  }
};

const incrementStat = async (req, res) => {
  try {
    const { playerId } = req.params;
    const { field, amount = 1 } = req.body;
    const allowed = ['shots','shotsOnTarget','passes','keyPasses','tackles','interceptions','clearances','dribbles','foulsCommitted','foulsSuffered','offsides','saves','penaltiesSaved','duelsWon','aerialDuelsWon'];
    if (!allowed.includes(field)) return res.status(400).json({ message: 'Champ invalide' });
    let stats = await PlayerStat.findOne({ where: { playerId } });
    if (!stats) stats = await PlayerStat.create({ playerId });
    stats[field] = (stats[field] || 0) + Number(amount);
    await stats.save();
    res.json({ message: 'Statistique incrémentée', stats });
  } catch (error) {
    console.error('Error incrementing stat:', error);
    res.status(500).json({ message: 'Erreur lors de la mise à jour des statistiques' });
  }
};

// ── #8 : Recalcul complet des stats depuis les MatchEvent ────────────────────
// POST /api/player-stats/recalculate   (admin uniquement)
const recalculateAllStats = async (req, res) => {
  try {
    const ids = (await Player.findAll({ attributes: ['id'], raw: true })).map(p => p.id);
    await recomputePlayerStats(ids);
    res.json({ message: `Recalcul terminé : ${ids.length} joueur(s) mis à jour`, playersUpdated: ids.length });
  } catch (error) {
    console.error('[Stats] recalculateAllStats error:', error);
    res.status(500).json({ message: 'Erreur lors du recalcul des statistiques' });
  }
};

module.exports = { getStats, setStats, incrementStat, recalculateAllStats };


