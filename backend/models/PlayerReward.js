const { DataTypes } = require('sequelize');
const sequelize = require('../config/database');

const PlayerReward = sequelize.define('PlayerReward', {
  id: { type: DataTypes.INTEGER, primaryKey: true, autoIncrement: true },
  playerId: { type: DataTypes.INTEGER, allowNull: false },
  name: { type: DataTypes.STRING, allowNull: false },
  description: { type: DataTypes.TEXT },
  type: { 
    type: DataTypes.ENUM('tournament', 'training', 'special', 'milestone'),
    allowNull: false,
    defaultValue: 'special'
  },
  category: { 
    type: DataTypes.ENUM('tournament', 'training', 'special', 'milestone'),
    allowNull: false,
    defaultValue: 'special'
  },
  value: { type: DataTypes.INTEGER, defaultValue: 0 },
  icon: { type: DataTypes.STRING },
  awardedById: { type: DataTypes.INTEGER },
  tournamentId: { type: DataTypes.INTEGER }
});

module.exports = PlayerReward;
