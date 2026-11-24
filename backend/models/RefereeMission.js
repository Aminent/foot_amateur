const { DataTypes } = require('sequelize');
const sequelize = require('../config/database');

// Désignation d'un arbitre sur un match (reconstruit d'après l'APK du 15/10).
const RefereeMission = sequelize.define('RefereeMission', {
  id: { type: DataTypes.INTEGER, primaryKey: true, autoIncrement: true },
  matchId: { type: DataTypes.INTEGER, allowNull: false },
  refereeId: { type: DataTypes.INTEGER, allowNull: false },
  role: {
    type: DataTypes.ENUM('main', 'assistant', 'fourth'),
    allowNull: false,
    defaultValue: 'main',
  },
  status: {
    type: DataTypes.ENUM('pending', 'accepted', 'declined'),
    allowNull: false,
    defaultValue: 'pending',
  },
  respondedAt: { type: DataTypes.DATE, allowNull: true },
  declineReason: { type: DataTypes.STRING(300), allowNull: true },
  presenceSheetUrl: { type: DataTypes.STRING, allowNull: true },
  matchSheetUrl: { type: DataTypes.STRING, allowNull: true },
  assignedById: { type: DataTypes.INTEGER, allowNull: true },
}, {
  tableName: 'RefereeMissions',
  timestamps: true,
  indexes: [{ unique: true, fields: ['matchId', 'refereeId'] }],
});

module.exports = RefereeMission;
