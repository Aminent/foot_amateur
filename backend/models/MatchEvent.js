const { DataTypes } = require('sequelize');
const sequelize = require('../config/database');

const MatchEvent = sequelize.define('MatchEvent', {
  id: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true
  },
  matchId: {
    type: DataTypes.INTEGER,
    allowNull: true
  },
  type: {
    type: DataTypes.ENUM('goal', 'assist', 'yellow_card', 'red_card', 'substitution', 'injury', 'penalty_goal', 'own_goal'),
    allowNull: false
  },
  minute: {
    type: DataTypes.INTEGER,
    allowNull: false,
    validate: {
      min: 1,
      max: 120
    }
  },
  extraMinute: {
    type: DataTypes.INTEGER,
    allowNull: true,
    validate: {
      min: 0,
      max: 10
    }
  },
  description: {
    type: DataTypes.TEXT,
    allowNull: true
  },
  isHomeTeam: {
    type: DataTypes.BOOLEAN,
    allowNull: false
  },
  relatedPlayerId: {
    type: DataTypes.INTEGER,
    allowNull: true
  },
  relatedPlayerName: {
    type: DataTypes.STRING,
    allowNull: true
  },
  substitutionPlayerInId: {
    type: DataTypes.INTEGER,
    allowNull: true
  },
  substitutionPlayerInName: {
    type: DataTypes.STRING,
    allowNull: true
  },
  substitutionPlayerOutId: {
    type: DataTypes.INTEGER,
    allowNull: true
  },
  substitutionPlayerOutName: {
    type: DataTypes.STRING,
    allowNull: true
  }
});

module.exports = MatchEvent;