const { Op } = require('sequelize');
const { Player, PlayerStat, Match, MatchEvent } = require('../models');

const getStats = async (req, res) => {
  try {
    const { playerId } = req.params;
    let stats = await PlayerStat.findOne({ where: { playerId } });
    if (!stats) stats = await PlayerStat.create({ playerId });

    // Compute matchesPlayed from real match data
    let matchesPlayed = 0;
    try {
      const player = await Player.findByPk(playerId);
      if (player && player.teamId) {
        matchesPlayed = await Match.count({
          where: {
            [Op.or]: [{ homeTeamId: player.teamId }, { awayTeamId: player.teamId }],
            status: 'completed',
          },
        });
      }
    } catch (_) {}

    res.json({ stats: { ...stats.toJSON(), matchesPlayed } });
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
    const {
      goals, assists, shots, shotsOnTarget, passes, keyPasses, tackles,
      interceptions, clearances, dribbles, foulsCommitted, foulsSuffered,
      offsides, saves, cleanSheets, goalsConceded, penaltiesSaved,
      duelsWon, aerialDuelsWon, minutesPlayed, yellowCards, redCards,
    } = req.body;
    await stats.update({
      ...(goals !== undefined && { goals }),
      ...(assists !== undefined && { assists }),
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
      ...(cleanSheets !== undefined && { cleanSheets }),
      ...(goalsConceded !== undefined && { goalsConceded }),
      ...(penaltiesSaved !== undefined && { penaltiesSaved }),
      ...(duelsWon !== undefined && { duelsWon }),
      ...(aerialDuelsWon !== undefined && { aerialDuelsWon }),
      ...(minutesPlayed !== undefined && { minutesPlayed }),
      ...(yellowCards !== undefined && { yellowCards }),
      ...(redCards !== undefined && { redCards }),
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
    const allowed = ['goals','assists','shots','shotsOnTarget','passes','keyPasses','tackles','interceptions','clearances','dribbles','foulsCommitted','foulsSuffered','offsides','saves','cleanSheets','goalsConceded','penaltiesSaved','duelsWon','aerialDuelsWon','minutesPlayed','yellowCards','redCards'];
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
    const EVENT_STAT_MAP = {
      goal:         { field: 'goals',       playerId: 'relatedPlayerId' },
      penalty_goal: { field: 'goals',       playerId: 'relatedPlayerId' },
      assist:       { field: 'assists',     playerId: 'relatedPlayerId' },
      yellow_card:  { field: 'yellowCards', playerId: 'relatedPlayerId' },
      red_card:     { field: 'redCards',    playerId: 'relatedPlayerId' },
    };

    // Réinitialiser toutes les stats calculables à 0
    await PlayerStat.update(
      { goals: 0, assists: 0, yellowCards: 0, redCards: 0 },
      { where: {} }
    );

    // Recalculer depuis tous les MatchEvent
    const events = await MatchEvent.findAll({
      where: { type: { [Op.in]: Object.keys(EVENT_STAT_MAP) } },
    });

    const counters = {}; // { playerId: { goals: n, assists: n, ... } }

    for (const ev of events) {
      const map = EVENT_STAT_MAP[ev.type];
      if (!map || !ev[map.playerId]) continue;
      const pid = ev[map.playerId];
      if (!counters[pid]) counters[pid] = {};
      counters[pid][map.field] = (counters[pid][map.field] || 0) + 1;
    }

    let updated = 0;
    for (const [playerId, fields] of Object.entries(counters)) {
      const [stat] = await PlayerStat.findOrCreate({
        where: { playerId },
        defaults: { playerId },
      });
      await stat.update(fields);
      updated++;
    }

    console.log(`[Stats] Recalcul terminé : ${updated} joueur(s) mis à jour sur ${events.length} événements`);
    res.json({
      message: `Recalcul terminé : ${updated} joueur(s) mis à jour`,
      eventsProcessed: events.length,
      playersUpdated: updated,
    });
  } catch (error) {
    console.error('[Stats] recalculateAllStats error:', error);
    res.status(500).json({ message: 'Erreur lors du recalcul des statistiques' });
  }
};

module.exports = { getStats, setStats, incrementStat, recalculateAllStats };


