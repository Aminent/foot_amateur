const express = require('express');
const { body } = require('express-validator');
const { auth, requireAdmin, requireCoach } = require('../middleware/auth');
const {
  getAllTournaments,
  getTournamentById,
  createTournament,
  updateTournament,
  deleteTournament,
  getTournamentStats
} = require('../controllers/tournamentController');

const router = express.Router();

// Validation pour la création/mise à jour de tournoi
const tournamentValidation = [
  body('name')
    .trim()
    .isLength({ min: 2, max: 100 })
    .withMessage('Le nom doit contenir entre 2 et 100 caractères'),
  body('description')
    .optional()
    .trim()
    .isLength({ max: 1000 })
    .withMessage('La description ne peut pas dépasser 1000 caractères'),
  body('startDate')
    .isISO8601()
    .withMessage('Date de début invalide'),
  body('endDate')
    .isISO8601()
    .withMessage('Date de fin invalide'),
  body('maxTeams')
    .optional()
    .isInt({ min: 2 })
    .withMessage('Le nombre maximum d\'équipes doit être au moins 2'),
  body('location')
    .optional()
    .trim()
    .isLength({ max: 200 })
    .withMessage('La localisation ne peut pas dépasser 200 caractères'),
  body('rules')
    .optional()
    .trim()
    .isLength({ max: 2000 })
    .withMessage('Les règles ne peuvent pas dépasser 2000 caractères'),
  body('status')
    .optional()
    .isIn(['draft', 'active', 'completed', 'cancelled'])
    .withMessage('Statut invalide'),
  body('format')
    .optional()
    .isIn(['league', 'knockout', 'group_then_knockout'])
    .withMessage('Format invalide'),
  body('entryFee')
    .optional()
    .isFloat({ min: 0 })
    .withMessage('Les frais d\'inscription doivent être positifs'),
  body('prizePool')
    .optional()
    .isFloat({ min: 0 })
    .withMessage('La cagnotte doit être positive'),
  body('registrationDeadline')
    .optional()
    .isISO8601()
    .withMessage('Date limite d\'inscription invalide'),
  body('isPublic')
    .optional()
    .isBoolean()
    .withMessage('Valeur isPublic invalide')
];

// Routes publiques (lecture seule)
router.get('/', getAllTournaments);
router.get('/:id', getTournamentById);
router.get('/:id/stats', getTournamentStats);
// Bracket endpoints
const { generateBracket, getBracket } = require('../controllers/tournamentBracketController');
router.post('/:id/bracket/generate', auth, requireCoach, generateBracket);
router.get('/:id/bracket', getBracket);

// Routes protégées (création, modification, suppression)
router.post('/', auth, requireCoach, tournamentValidation, createTournament);
router.put('/:id', auth, requireCoach, tournamentValidation, updateTournament);
router.delete('/:id', auth, requireAdmin, deleteTournament);

module.exports = router; 