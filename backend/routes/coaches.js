const express = require('express');
const { body } = require('express-validator');
const { auth, requireAdmin, requireCoach } = require('../middleware/auth');
const { User } = require('../models');
const {
  getAllCoaches,
  getCoachById,
  createCoach,
  updateCoach,
  deleteCoach,
  getMyTeam,
  getMyTeamMatches,
  getMyTournament,
  getAvailableTournamentsForCoach,
} = require('../controllers/coachController');
const {
  getMyTrainings,
  createTraining,
  updateTraining,
  deleteTraining,
} = require('../controllers/trainingController');
const {
  getAttendance,
  saveAttendance,
} = require('../controllers/attendanceController');
const {
  getLineup,
  saveLineup,
  publishLineup,
} = require('../controllers/lineupController');

const router = express.Router();

// Validation rules
const coachValidation = [
  body('name').notEmpty().withMessage('Le nom est requis'),
  body('email').isEmail().withMessage('Email invalide'),
  body('password').isLength({ min: 6 }).withMessage('Le mot de passe doit contenir au moins 6 caractères'),
  body('phone').optional().isLength({ max: 20 }).withMessage('Numéro de téléphone trop long')
];

const updateCoachValidation = [
  body('name').optional().notEmpty().withMessage('Le nom ne peut pas être vide'),
  body('email').optional().isEmail().withMessage('Email invalide'),
  body('phone').optional().isLength({ max: 20 }).withMessage('Numéro de téléphone trop long')
];

// Coach self-service routes (must be before /:id route)
router.get('/me/team', auth, requireCoach, getMyTeam);
router.get('/me/matches', auth, requireCoach, getMyTeamMatches);
router.get('/me/tournament', auth, requireCoach, getMyTournament);
router.get('/me/available-tournaments', auth, requireCoach, getAvailableTournamentsForCoach);

// Training sessions (coach manages their team's sessions)
const trainingCreateValidation = [
  body('title').notEmpty().withMessage('Le titre est requis'),
  body('date').notEmpty().isISO8601().withMessage('Date ISO8601 requise'),
  body('type').optional().isIn(['technique', 'tactique', 'physique', 'match', 'autre']),
  body('duration').optional({ nullable: true }).isInt({ min: 1, max: 480 }),
  body('status').optional().isIn(['scheduled', 'completed', 'cancelled']),
];

const trainingUpdateValidation = [
  body('title').optional().notEmpty().withMessage('Le titre ne peut pas être vide'),
  body('date').optional().isISO8601().withMessage('Date ISO8601 requise'),
  body('type').optional().isIn(['technique', 'tactique', 'physique', 'match', 'autre']),
  body('duration').optional({ nullable: true }).isInt({ min: 1, max: 480 }),
  body('status').optional().isIn(['scheduled', 'completed', 'cancelled']),
];

// Lineup routes
router.get('/me/matches/:matchId/lineup', auth, requireCoach, getLineup);
router.put('/me/matches/:matchId/lineup', auth, requireCoach, saveLineup);
router.post('/me/matches/:matchId/lineup/publish', auth, requireCoach, publishLineup);

router.get('/me/trainings', auth, requireCoach, getMyTrainings);
router.post('/me/trainings', auth, requireCoach, trainingCreateValidation, createTraining);
router.put('/me/trainings/:id', auth, requireCoach, trainingUpdateValidation, updateTraining);
router.delete('/me/trainings/:id', auth, requireCoach, deleteTraining);

// Attendance
router.get('/me/trainings/:id/attendance', auth, requireCoach, getAttendance);
router.put('/me/trainings/:id/attendance', auth, requireCoach, saveAttendance);

// FCM token registration for coach
router.put('/me/fcm-token', auth, requireCoach, async (req, res) => {
  try {
    const { fcmToken } = req.body;
    if (!fcmToken) return res.status(400).json({ message: 'fcmToken requis' });
    await User.update({ fcmToken }, { where: { id: req.user.id } });
    res.json({ message: 'Token FCM enregistré' });
  } catch (err) {
    res.status(500).json({ message: 'Erreur serveur' });
  }
});

// Admin routes
router.get('/', auth, requireAdmin, getAllCoaches);
router.get('/:id', auth, requireAdmin, getCoachById);
router.post('/', auth, requireAdmin, coachValidation, createCoach);
router.put('/:id', auth, requireAdmin, updateCoachValidation, updateCoach);
router.delete('/:id', auth, requireAdmin, deleteCoach);

module.exports = router;


