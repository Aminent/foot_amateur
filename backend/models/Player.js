const { DataTypes } = require('sequelize');
const sequelize = require('../config/database');

const Player = sequelize.define('Player', {
  id: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true
  },
  name: {
    type: DataTypes.STRING,
    allowNull: false,
    validate: {
      len: [2, 100]
    }
  },
  position: {
    type: DataTypes.ENUM('gardien', 'defenseur', 'milieu', 'attaquant'),
    allowNull: false
  },
  jerseyNumber: {
    type: DataTypes.INTEGER,
    allowNull: true,
    validate: {
      min: 1,
      max: 99
    }
  },
  teamId: {
    type: DataTypes.INTEGER,
    allowNull: true
  },
  userId: {
    type: DataTypes.INTEGER,
    allowNull: true
  },
  dateOfBirth: {
    type: DataTypes.DATEONLY,
    allowNull: true
  },
  height: {
    type: DataTypes.INTEGER, // en cm
    allowNull: true,
    validate: {
      min: 1,
      max: 300
    }
  },
  weight: {
    type: DataTypes.INTEGER, // en kg
    allowNull: true,
    validate: {
      min: 1,
      max: 300
    }
  },
  nationality: {
    type: DataTypes.STRING,
    allowNull: true
  },
  preferredFoot: {
    type: DataTypes.ENUM('gauche', 'droit', 'ambidextre'),
    allowNull: true
  },
  isCaptain: {
    type: DataTypes.BOOLEAN,
    defaultValue: false
  },
  isActive: {
    type: DataTypes.BOOLEAN,
    defaultValue: true
  },
  joinDate: {
    type: DataTypes.DATEONLY,
    allowNull: true
  },
  avatar: {
    type: DataTypes.STRING,
    allowNull: true
  },
  email: {
    type: DataTypes.STRING,
    allowNull: true,
    validate: {
      isEmail: true
    }
  },
  phone: {
    type: DataTypes.STRING,
    allowNull: true
  }
});

module.exports = Player;