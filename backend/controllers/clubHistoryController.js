const { Player, PlayerStat, PlayerClubHistory, Team } = require('../models');
const { matchesPlayedCount } = require('../services/statsService');

// GET /players/:id/club-history
const getClubHistory = async (req, res) => {
  try {
    const { id } = req.params;
    const history = await PlayerClubHistory.findAll({
      where: { playerId: id },
      order: [['startDate', 'DESC']],
    });
    res.json({ history });
  } catch (err) {
    console.error('getClubHistory error:', err);
    res.status(500).json({ message: 'Erreur lors du chargement de l\'historique' });
  }
};

// DELETE /players/:id/team  — remove player from current team, snapshot stats
const removeFromTeam = async (req, res) => {
  try {
    const { id } = req.params;
    const player = await Player.findByPk(id, {
      include: [
        { model: Team, as: 'team' },
        { model: PlayerStat, as: 'stats' },
      ],
    });

    if (!player) return res.status(404).json({ message: 'Joueur non trouvé' });
    if (!player.teamId) return res.status(400).json({ message: 'Le joueur n\'est dans aucune équipe' });

    const team = player.team;
    const stats = player.stats;

    // Record this passage in club history
    await PlayerClubHistory.create({
      playerId:     player.id,
      teamId:       team.id,
      teamName:     team.name,
      teamLogo:     team.logo || null,
      startDate:    player.joinDate || null,
      endDate:      new Date().toISOString().split('T')[0],
      goals:        stats?.goals        || 0,
      assists:      stats?.assists      || 0,
      matches:      await matchesPlayedCount(player.id),
      minutesPlayed:stats?.minutesPlayed || 0,
      yellowCards:  stats?.yellowCards  || 0,
      redCards:     stats?.redCards     || 0,
      cleanSheets:  stats?.cleanSheets  || 0,
      saves:        stats?.saves        || 0,
      tackles:      stats?.tackles      || 0,
    });

    // Detach player from team
    await player.update({ teamId: null, isCaptain: false, joinDate: null, isActive: false });

    res.json({ message: 'Joueur retiré de l\'équipe avec succès' });
  } catch (err) {
    console.error('removeFromTeam error:', err);
    res.status(500).json({ message: 'Erreur lors du retrait du joueur' });
  }
};

module.exports = { getClubHistory, removeFromTeam };
