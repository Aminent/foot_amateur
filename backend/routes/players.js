const express = require('express');
const { body } = require('express-validator');
const { auth, requireCoach, requireAdmin } = require('../middleware/auth');
const { getClubHistory, removeFromTeam } = require('../controllers/clubHistoryController');
const {
  getAllPlayers,
  getPlayerById,
  createPlayer,
  updatePlayer,
  deletePlayer,
  assignPlayerToTeam,
  getPlayerOverview
} = require('../controllers/playerController');

const router = express.Router();

const playerValidation = [
  body('name').optional().trim().isLength({ min: 2, max: 100 }),
  body('position').optional({ checkFalsy: true }).isIn(['gardien', 'defenseur', 'milieu', 'attaquant']),
  body('jerseyNumber').optional({ checkFalsy: true }).isInt({ min: 1, max: 99 }),
  body('preferredFoot').optional({ checkFalsy: true }).isIn(['gauche', 'droit', 'ambidextre']),
  body('email').optional({ checkFalsy: true }).isEmail(),
  body('password').optional({ checkFalsy: true }).isLength({ min: 6 })
];

// Read-only
router.get('/', auth, getAllPlayers);
router.get('/:id', auth, getPlayerById);
router.get('/:id/overview', auth, getPlayerOverview);

// Mutations require coach/admin
router.post('/', auth, requireCoach, playerValidation, createPlayer);
router.put('/:id', auth, requireCoach, playerValidation, updatePlayer);
router.delete('/:id', auth, requireCoach, deletePlayer);

// Assign player to team
router.post('/assign/:playerId/team/:teamId', auth, requireCoach, assignPlayerToTeam);

// Club history
router.get('/:id/club-history', auth, getClubHistory);
router.delete('/:id/team', auth, requireAdmin, removeFromTeam);

module.exports = router;