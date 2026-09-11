const { DataTypes } = require('sequelize');
const sequelize = require('../config/database');

const TrainingAttendance = sequelize.define('TrainingAttendance', {
  id: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true,
  },
  trainingSessionId: {
    type: DataTypes.INTEGER,
    allowNull: false,
    references: { model: 'TrainingSessions', key: 'id' },
  },
  playerId: {
    type: DataTypes.INTEGER,
    allowNull: false,
    references: { model: 'Players', key: 'id' },
  },
  status: {
    type: DataTypes.ENUM('present', 'absent', 'excused'),
    defaultValue: 'absent',
  },
  note: {
    type: DataTypes.STRING(300),
    allowNull: true,
  },
}, {
  indexes: [
    { unique: true, fields: ['trainingSessionId', 'playerId'] },
  ],
});

module.exports = TrainingAttendance;
