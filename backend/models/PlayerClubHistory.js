const { DataTypes } = require('sequelize');
const sequelize = require('../config/database');

const PlayerClubHistory = sequelize.define('PlayerClubHistory', {
  id:        { type: DataTypes.INTEGER, primaryKey: true, autoIncrement: true },
  playerId:  { type: DataTypes.INTEGER, allowNull: false },
  teamId:    { type: DataTypes.INTEGER, allowNull: true },   // null if team deleted
  teamName:  { type: DataTypes.STRING,  allowNull: false },  // denormalized for safety
  teamLogo:  { type: DataTypes.STRING,  allowNull: true },
  startDate: { type: DataTypes.DATEONLY, allowNull: true },
  endDate:   { type: DataTypes.DATEONLY, allowNull: true },  // null = current club
  // stat snapshot taken when player leaves
  goals:          { type: DataTypes.INTEGER, defaultValue: 0 },
  assists:        { type: DataTypes.INTEGER, defaultValue: 0 },
  matches:        { type: DataTypes.INTEGER, defaultValue: 0 },
  minutesPlayed:  { type: DataTypes.INTEGER, defaultValue: 0 },
  yellowCards:    { type: DataTypes.INTEGER, defaultValue: 0 },
  redCards:       { type: DataTypes.INTEGER, defaultValue: 0 },
  cleanSheets:    { type: DataTypes.INTEGER, defaultValue: 0 },
  saves:          { type: DataTypes.INTEGER, defaultValue: 0 },
  tackles:        { type: DataTypes.INTEGER, defaultValue: 0 },
});

module.exports = PlayerClubHistory;
