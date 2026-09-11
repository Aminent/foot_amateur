const { Player, PlayerBadge, PlayerReward } = require('../models');

const seedRewards = async () => {
  try {
    console.log('🌱 Seeding rewards and badges data...');

    // Get the first player (or create if doesn't exist)
    let player = await Player.findOne({ where: { id: 1 } });
    
    if (!player) {
      console.log('❌ No player found with ID 1. Please create a player first.');
      return;
    }

    // Define badges with icons and multiple counts
    const badges = [
      {
        playerId: 1,
        name: 'Premier But',
        type: 'match',
        rarity: 'common',
        description: 'Marqué votre premier but en match officiel',
        source: 'system',
        icon: '⚽',
        count: 3
      },
      {
        playerId: 1,
        name: 'Joueur Assidu',
        type: 'training',
        rarity: 'uncommon',
        description: 'Participé à 10 entraînements consécutifs',
        source: 'coach',
        icon: '💪',
        count: 2
      },
      {
        playerId: 1,
        name: 'Vainqueur de Tournoi',
        type: 'tournament',
        rarity: 'rare',
        description: 'Gagné un tournoi avec votre équipe',
        source: 'tournament',
        icon: '🏆',
        count: 1
      },
      {
        playerId: 1,
        name: 'Meilleur Buteur',
        type: 'achievement',
        rarity: 'epic',
        description: 'Terminé la saison avec le plus de buts',
        source: 'admin',
        icon: '🥅',
        count: 1
      },
      {
        playerId: 1,
        name: 'Légende du Club',
        type: 'excellence',
        rarity: 'legendary',
        description: 'Membre du club depuis plus de 2 ans',
        source: 'admin',
        icon: '👑',
        count: 1
      },
      {
        playerId: 1,
        name: 'Passe Décisive',
        type: 'match',
        rarity: 'common',
        description: 'Donné votre première passe décisive',
        source: 'system',
        icon: '🎯',
        count: 5
      },
      {
        playerId: 1,
        name: 'Joueur du Mois',
        type: 'achievement',
        rarity: 'rare',
        description: 'Élu meilleur joueur du mois',
        source: 'coach',
        icon: '⭐',
        count: 2
      },
      {
        playerId: 1,
        name: 'Capitaine',
        type: 'excellence',
        rarity: 'uncommon',
        description: 'Désigné capitaine pour un match',
        source: 'coach',
        icon: '🎖️',
        count: 4
      }
    ];

    // Define rewards with icons
    const rewards = [
      {
        playerId: 1,
        name: 'Bonus de Performance',
        description: 'Excellent performance dans les 5 derniers matchs',
        type: 'special',
        category: 'special',
        value: 100,
        icon: '🎁'
      },
      {
        playerId: 1,
        name: 'Récompense d\'Entraînement',
        description: 'Complété tous les entraînements du mois',
        type: 'training',
        category: 'training',
        value: 50,
        icon: '🏋️'
      },
      {
        playerId: 1,
        name: 'Milestone 10 Matchs',
        description: 'Joué 10 matchs officiels',
        type: 'milestone',
        category: 'milestone',
        value: 75,
        icon: '📈'
      },
      {
        playerId: 1,
        name: 'Tournoi Participé',
        description: 'Participation active au tournoi mensuel',
        type: 'tournament',
        category: 'tournament',
        value: 150,
        icon: '🏅'
      },
      {
        playerId: 1,
        name: 'Meilleur Joueur du Match',
        description: 'Sélectionné comme meilleur joueur du match',
        type: 'special',
        category: 'special',
        value: 200,
        icon: '🌟'
      }
    ];

    // Insert badges
    for (const badge of badges) {
      await PlayerBadge.findOrCreate({
        where: {
          playerId: badge.playerId,
          name: badge.name
        },
        defaults: badge
      });
    }

    // Insert rewards
    for (const reward of rewards) {
      await PlayerReward.findOrCreate({
        where: {
          playerId: reward.playerId,
          name: reward.name
        },
        defaults: reward
      });
    }

    console.log('✅ Badges and rewards seeded successfully!');
    console.log(`📊 Created ${badges.length} badges`);
    console.log(`🎁 Created ${rewards.length} rewards`);
    
  } catch (error) {
    console.error('❌ Error seeding rewards:', error);
  }
};

// Run if called directly
if (require.main === module) {
  seedRewards()
    .then(() => process.exit(0))
    .catch((error) => {
      console.error(error);
      process.exit(1);
    });
}

module.exports = seedRewards;
