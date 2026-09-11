const { DataTypes } = require('sequelize');
const sequelize = require('../config/database');

const Match = sequelize.define('Match', {
  id: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true
  },
  tournamentId: {
    type: DataTypes.INTEGER,
    allowNull: true
  },
  roundNumber: {
    type: DataTypes.INTEGER,
    allowNull: true,
    validate: { min: 1 }
  },
  matchIndex: {
    // index/order within the round (0-based)
    type: DataTypes.INTEGER,
    allowNull: true,
    validate: { min: 0 }
  },
  homeTeamId: {
    type: DataTypes.INTEGER,
    allowNull: true
  },
  awayTeamId: {
    type: DataTypes.INTEGER,
    allowNull: true
  },
  date: {
    type: DataTypes.DATE,
    allowNull: false
  },
  location: {
    type: DataTypes.STRING,
    allowNull: true
  },
  status: {
    type: DataTypes.ENUM('scheduled', 'in_progress', 'completed', 'cancelled', 'postponed'),
    defaultValue: 'scheduled'
  },
  homeTeamScore: {
    type: DataTypes.INTEGER,
    allowNull: true,
    defaultValue: 0,
    validate: {
      min: 0
    }
  },
  awayTeamScore: {
    type: DataTypes.INTEGER,
    allowNull: true,
    defaultValue: 0,
    validate: {
      min: 0
    }
  },
  winnerTeamId: {
    type: DataTypes.INTEGER,
    allowNull: true
  },
  advancesToMatchId: {
    // next match in bracket where winner advances
    type: DataTypes.INTEGER,
    allowNull: true
  },
  halfTimeHomeScore: {
    type: DataTypes.INTEGER,
    allowNull: true,
    defaultValue: 0
  },
  halfTimeAwayScore: {
    type: DataTypes.INTEGER,
    allowNull: true,
    defaultValue: 0
  },
  referee: {
    type: DataTypes.STRING,
    allowNull: true
  },
  assistantReferee1: {
    type: DataTypes.STRING,
    allowNull: true
  },
  assistantReferee2: {
    type: DataTypes.STRING,
    allowNull: true
  },
  fourthOfficial: {
    type: DataTypes.STRING,
    allowNull: true
  },
  weather: {
    type: DataTypes.STRING,
    allowNull: true
  },
  attendance: {
    type: DataTypes.INTEGER,
    allowNull: true,
    validate: {
      min: 0
    }
  },
  notes: {
    type: DataTypes.TEXT,
    allowNull: true
  },
  reminderSent: {
    type: DataTypes.BOOLEAN,
    allowNull: false,
    defaultValue: false
  },
  // ── #12 : Indique que la notif "match bientôt" a déjà été envoyée ─────────
  // Persisté en base → survit aux redémarrages du serveur
  notifSoonSent: {
    type: DataTypes.BOOLEAN,
    allowNull: false,
    defaultValue: false
  },
  // ── #4 : Indique que les minutes jouées ont déjà été calculées ───────────
  // Évite le double calcul en cas d'appel concurrent sur updateMatch
  minutesComputed: {
    type: DataTypes.BOOLEAN,
    allowNull: false,
    defaultValue: false
  }
});

module.exports = Match;