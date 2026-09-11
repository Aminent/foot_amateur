const { DataTypes } = require('sequelize');
const sequelize = require('../config/database');

const PlayerBadge = sequelize.define('PlayerBadge', {
  id: { type: DataTypes.INTEGER, primaryKey: true, autoIncrement: true },
  playerId: { type: DataTypes.INTEGER, allowNull: false },
  name: { type: DataTypes.STRING, allowNull: false },
  type: { 
    type: DataTypes.ENUM('tournament', 'training', 'match', 'achievement', 'participation', 'excellence'),
    allowNull: false,
    defaultValue: 'achievement'
  },
  rarity: { 
    type: DataTypes.ENUM('common', 'uncommon', 'rare', 'epic', 'legendary'),
    allowNull: false,
    defaultValue: 'common'
  },
  description: { type: DataTypes.TEXT },
  count: { type: DataTypes.INTEGER, defaultValue: 1 },
  source: { 
    type: DataTypes.ENUM('coach', 'admin', 'tournament', 'system'),
    allowNull: false,
    defaultValue: 'coach'
  },
  icon: { type: DataTypes.STRING },
  awardedById: { type: DataTypes.INTEGER },
  tournamentId: { type: DataTypes.INTEGER }
});

module.exports = PlayerBadge;
