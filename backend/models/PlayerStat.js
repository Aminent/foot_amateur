const { DataTypes } = require('sequelize');
const sequelize = require('../config/database');

const PlayerStat = sequelize.define('PlayerStat', {
  id: { type: DataTypes.INTEGER, primaryKey: true, autoIncrement: true },
  playerId: { type: DataTypes.INTEGER, allowNull: true },
  goals: { type: DataTypes.INTEGER, defaultValue: 0 },
  assists: { type: DataTypes.INTEGER, defaultValue: 0 },
  shots: { type: DataTypes.INTEGER, defaultValue: 0 },
  shotsOnTarget: { type: DataTypes.INTEGER, defaultValue: 0 },
  passes: { type: DataTypes.INTEGER, defaultValue: 0 },
  keyPasses: { type: DataTypes.INTEGER, defaultValue: 0 },
  tackles: { type: DataTypes.INTEGER, defaultValue: 0 },
  interceptions: { type: DataTypes.INTEGER, defaultValue: 0 },
  clearances: { type: DataTypes.INTEGER, defaultValue: 0 },
  dribbles: { type: DataTypes.INTEGER, defaultValue: 0 },
  foulsCommitted: { type: DataTypes.INTEGER, defaultValue: 0 },
  foulsSuffered: { type: DataTypes.INTEGER, defaultValue: 0 },
  offsides: { type: DataTypes.INTEGER, defaultValue: 0 },
  saves: { type: DataTypes.INTEGER, defaultValue: 0 },
  cleanSheets: { type: DataTypes.INTEGER, defaultValue: 0 },
  goalsConceded: { type: DataTypes.INTEGER, defaultValue: 0 },
  penaltiesSaved: { type: DataTypes.INTEGER, defaultValue: 0 },
  duelsWon: { type: DataTypes.INTEGER, defaultValue: 0 },
  aerialDuelsWon: { type: DataTypes.INTEGER, defaultValue: 0 },
  minutesPlayed: { type: DataTypes.INTEGER, defaultValue: 0 },
  yellowCards: { type: DataTypes.INTEGER, defaultValue: 0 },
  redCards: { type: DataTypes.INTEGER, defaultValue: 0 }
});

module.exports = PlayerStat;


