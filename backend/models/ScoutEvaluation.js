const { DataTypes } = require('sequelize');
const sequelize = require('../config/database');

const ScoutEvaluation = sequelize.define('ScoutEvaluation', {
  id: { type: DataTypes.INTEGER, primaryKey: true, autoIncrement: true },
  scoutId: { type: DataTypes.INTEGER, allowNull: false },
  playerId: { type: DataTypes.INTEGER, allowNull: false },
  date: { type: DataTypes.DATEONLY, allowNull: false, defaultValue: DataTypes.NOW },
  overallRating: { type: DataTypes.FLOAT, allowNull: false, validate: { min: 1, max: 10 } },
  technicalScore: { type: DataTypes.FLOAT, allowNull: true },
  physicalScore: { type: DataTypes.FLOAT, allowNull: true },
  mentalScore: { type: DataTypes.FLOAT, allowNull: true },
  tacticalScore: { type: DataTypes.FLOAT, allowNull: true },
  recommendation: { type: DataTypes.ENUM('sign', 'watch', 'reject'), allowNull: true },
  potential: { type: DataTypes.ENUM('low', 'medium', 'high', 'elite'), allowNull: true },
  notes: { type: DataTypes.TEXT, allowNull: true },
  position: { type: DataTypes.STRING(50), allowNull: true },
}, {
  indexes: [{ fields: ['scoutId', 'playerId'] }],
});

module.exports = ScoutEvaluation;
