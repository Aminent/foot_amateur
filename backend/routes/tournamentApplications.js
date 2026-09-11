const express = require('express');
const { body } = require('express-validator');
const { auth, requireAdmin, requireCoach } = require('../middleware/auth');
const {
  getMyApplications,
  applyForTournament,
  getAvailableTournaments,
  getAllApplications,
  reviewApplication
} = require('../controllers/tournamentApplicationController');

const router = express.Router();

// @route   GET /api/tournament-applications
// @desc    Get all tournament applications for a coach's teams
// @access  Private (Coach)
router.get('/', auth, requireCoach, getMyApplications);

// @route   POST /api/tournament-applications
// @desc    Apply for a tournament
// @access  Private (Coach)
router.post('/', [
  auth,
  requireCoach,
  body('teamId').isInt().withMessage('ID d\'équipe invalide'),
  body('tournamentId').isInt().withMessage('ID de tournoi invalide')
], applyForTournament);

// @route   GET /api/tournament-applications/available-tournaments
// @desc    Get tournaments available for application
// @access  Private (Coach)
router.get('/available-tournaments', auth, requireCoach, getAvailableTournaments);

// @route   GET /api/tournament-applications/admin
// @desc    Get all tournament applications (Admin only)
// @access  Private (Admin)
router.get('/admin', auth, requireAdmin, getAllApplications);

// @route   PUT /api/tournament-applications/:id/review
// @desc    Review a tournament application (Admin only)
// @access  Private (Admin)
router.put('/:id/review', [
  auth,
  requireAdmin,
  body('status').isIn(['approved', 'rejected']).withMessage('Statut invalide'),
  body('notes').optional().isString().withMessage('Notes invalides')
], reviewApplication);

module.exports = router;
