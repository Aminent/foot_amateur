const express = require('express');
const { body } = require('express-validator');
const { auth, requireCoach } = require('../middleware/auth');
const {
  getAllTeams,
  getTeamById,
  createTeam,
  updateTeam,
  deleteTeam
} = require('../controllers/teamController');

const router = express.Router();

const teamValidation = [
  body('name')
    .optional()
    .trim()
    .isLength({ min: 2, max: 100 })
    .withMessage('Le nom doit contenir entre 2 et 100 caractères'),
  body('shortName')
    .optional()
    .trim()
    .isLength({ max: 10 })
    .withMessage('Le nom court ne peut pas dépasser 10 caractères'),
  body('foundedYear')
    .optional()
    .isInt({ min: 1800, max: new Date().getFullYear() })
    .withMessage('Année de fondation invalide'),
  body('coachId')
    .optional()
    .isInt()
    .withMessage('coachId doit être un entier')
];

// Read-only
router.get('/', auth, getAllTeams);
router.get('/:id', auth, getTeamById);

// Mutations require coach/admin
router.post('/', auth, requireCoach, teamValidation, createTeam);
router.put('/:id', auth, requireCoach, teamValidation, updateTeam);
router.delete('/:id', auth, requireCoach, deleteTeam);

module.exports = router;


