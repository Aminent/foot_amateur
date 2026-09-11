const { DataTypes } = require('sequelize');
const sequelize = require('../config/database');

const ScoutWatchlist = sequelize.define('ScoutWatchlist', {
  id: { type: DataTypes.INTEGER, primaryKey: true, autoIncrement: true },
  scoutId: { type: DataTypes.INTEGER, allowNull: false },
  playerId: { type: DataTypes.INTEGER, allowNull: false },
  notes: { type: DataTypes.STRING(300), allowNull: true },
}, {
  indexes: [{ unique: true, fields: ['scoutId', 'playerId'] }],
});

module.exports = ScoutWatchlist;
