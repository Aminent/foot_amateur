const { DataTypes } = require('sequelize');
const sequelize = require('../config/database');

const MatchLineup = sequelize.define('MatchLineup', {
  id: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true
  },
  matchId: {
    type: DataTypes.INTEGER,
    allowNull: false
  },
  teamId: {
    type: DataTypes.INTEGER,
    allowNull: false
  },
  formation: {
    type: DataTypes.STRING(10),
    allowNull: false,
    defaultValue: '4-3-3'
  },
  // JSON array: [{playerId, playerName, jerseyNumber, positionLabel, positionX, positionY, isStarter}]
  players: {
    type: DataTypes.JSON,
    allowNull: false,
    defaultValue: []
  },
  status: {
    type: DataTypes.ENUM('draft', 'published'),
    allowNull: false,
    defaultValue: 'draft'
  }
}, {
  timestamps: true,
  indexes: [
    { unique: true, fields: ['matchId', 'teamId'] }
  ]
});

module.exports = MatchLineup;
