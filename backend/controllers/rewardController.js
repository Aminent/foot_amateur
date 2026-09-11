const { Player, PlayerBadge, PlayerReward, Tournament, MatchEvent } = require('../models');
const { Op } = require('sequelize');

const getMyRewards = async (req, res) => {
  try {
    const userId = req.user.id;
    
    // Get player with badges and rewards
    const player = await Player.findOne({
      where: { userId },
      include: [
        { 
          model: PlayerBadge, 
          as: 'badges',
          include: [
            { model: Tournament, as: 'tournament' },
            { model: Player, as: 'awardedBy', attributes: ['name'] }
          ]
        },
        { 
          model: PlayerReward, 
          as: 'rewards',
          include: [
            { model: Tournament, as: 'tournament' },
            { model: Player, as: 'awardedBy', attributes: ['name'] }
          ]
        }
      ]
    });

    if (!player) {
      return res.status(404).json({ message: 'Profil joueur non trouvé' });
    }

    // Format badges
    const badges = player.badges ? player.badges.map(badge => ({
      id: badge.id,
      name: badge.name,
      type: badge.type,
      rarity: badge.rarity,
      description: badge.description,
      count: badge.count,
      source: badge.source,
      date: badge.createdAt,
      icon: badge.icon,
      tournamentName: badge.tournament ? badge.tournament.name : null,
      awardedBy: badge.awardedBy ? badge.awardedBy.name : 'Système'
    })) : [];

    // Format rewards
    const rewards = player.rewards ? player.rewards.map(reward => ({
      id: reward.id,
      name: reward.name,
      description: reward.description,
      type: reward.type,
      category: reward.category,
      value: reward.value,
      date: reward.createdAt,
      icon: reward.icon,
      tournamentName: reward.tournament ? reward.tournament.name : null,
      awardedBy: reward.awardedBy ? reward.awardedBy.name : 'Système'
    })) : [];

    res.json({
      badges,
      rewards,
      totalBadges: badges.length,
      totalRewards: rewards.length
    });
  } catch (error) {
    console.error('Error fetching player rewards:', error);
    res.status(500).json({ message: 'Erreur lors du chargement des récompenses' });
  }
};

const awardBadge = async (req, res) => {
  try {
    const { playerId, badgeData } = req.body;

    // awardedById must be a Player.id (FK → Player table), not a User.id.
    // Look up the Player record linked to the logged-in coach/admin.
    // Admins may have no Player record → null is fine (allowNull not set to false).
    const awardingPlayer = await Player.findOne({ where: { userId: req.user.id } });
    const awardedById = awardingPlayer ? awardingPlayer.id : null;

    const source = req.user.role === 'admin' ? 'admin' : 'coach';

    const badge = await PlayerBadge.create({
      playerId,
      name: badgeData.name,
      type: badgeData.type,
      rarity: badgeData.rarity,
      description: badgeData.description || null,
      source: badgeData.source || source,
      count: badgeData.count || 1,
      icon: badgeData.icon,
      awardedById
    });

    res.status(201).json({
      message: 'Badge attribué avec succès',
      badge
    });
  } catch (error) {
    console.error('Error awarding badge:', error);
    res.status(500).json({ message: 'Erreur lors de l\'attribution du badge' });
  }
};

const awardReward = async (req, res) => {
  try {
    const { playerId, rewardData } = req.body;

    const awardingPlayer = await Player.findOne({ where: { userId: req.user.id } });
    const awardedById = awardingPlayer ? awardingPlayer.id : null;

    const reward = await PlayerReward.create({
      playerId,
      name: rewardData.name,
      description: rewardData.description || null,
      type: rewardData.type,
      category: rewardData.category,
      value: rewardData.value,
      icon: rewardData.icon,
      awardedById
    });

    res.status(201).json({
      message: 'Récompense attribuée avec succès',
      reward
    });
  } catch (error) {
    console.error('Error awarding reward:', error);
    res.status(500).json({ message: 'Erreur lors de l\'attribution de la récompense' });
  }
};

const getBadgeTypes = async (req, res) => {
  try {
    const badgeTypes = [
      { type: 'tournament', name: 'Tournoi', icon: 'emoji_events' },
      { type: 'training', name: 'Entraînement', icon: 'fitness_center' },
      { type: 'match', name: 'Match', icon: 'sports_soccer' },
      { type: 'achievement', name: 'Succès', icon: 'military_tech' },
      { type: 'participation', name: 'Participation', icon: 'star' },
      { type: 'excellence', name: 'Excellence', icon: 'workspace_premium' }
    ];

    const rarities = [
      { rarity: 'common', name: 'Commun', color: '#9E9E9E' },
      { rarity: 'uncommon', name: 'Peu Commun', color: '#4CAF50' },
      { rarity: 'rare', name: 'Rare', color: '#2196F3' },
      { rarity: 'epic', name: 'Épique', color: '#9C27B0' },
      { rarity: 'legendary', name: 'Légendaire', color: '#FF9800' }
    ];

    res.json({
      types: badgeTypes,
      rarities
    });
  } catch (error) {
    console.error('Error fetching badge types:', error);
    res.status(500).json({ message: 'Erreur lors du chargement des types de badges' });
  }
};

// GET /rewards/player/:playerId/badges — coach views a specific player's badges
const getPlayerBadges = async (req, res) => {
  try {
    const { playerId } = req.params;
    const badges = await PlayerBadge.findAll({
      where: { playerId },
      order: [['createdAt', 'DESC']],
    });
    res.json({ badges });
  } catch (error) {
    console.error('getPlayerBadges error:', error);
    res.status(500).json({ message: 'Erreur lors du chargement des badges' });
  }
};

module.exports = {
  getMyRewards,
  awardBadge,
  awardReward,
  getBadgeTypes,
  getPlayerBadges,
};
