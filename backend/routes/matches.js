const express = require('express');
const { body } = require('express-validator');
const { auth, requireCoach } = require('../middleware/auth');
const {
  getMatches, getMatch, createMatch, updateMatch, deleteMatch,
  addMatchEvent, deleteMatchEvent,
  scheduleMatch, submitScore,
  getPublicMatches,
} = require('../controllers/matchController');

const router = express.Router();

// ── Public (no auth) ─────────────────────────────────────────────────────────
router.get('/public/recent', getPublicMatches);

// ── List / get ───────────────────────────────────────────────────────────────
router.get('/', auth, getMatches);
router.get('/:id', auth, getMatch);

// ── Create ───────────────────────────────────────────────────────────────────
router.post(
  '/',
  auth,
  requireCoach,
  [
    body('homeTeamId').notEmpty().withMessage('homeTeamId requis'),
    body('awayTeamId').notEmpty().withMessage('awayTeamId requis'),
    body('date').notEmpty().isISO8601().withMessage('date ISO8601 requise'),
    body('location').optional().isString().isLength({ max: 200 }),
    body('roundNumber').optional().isInt({ min: 1 }),
    body('referee').optional().isString().isLength({ max: 100 }),
  ],
  createMatch
);

// ── Full update (schedule + score + status) ───────────────────────────────────
router.put(
  '/:id',
  auth,
  requireCoach,
  [
    body('date').optional().isISO8601(),
    body('homeTeamScore').optional().isInt({ min: 0 }),
    body('awayTeamScore').optional().isInt({ min: 0 }),
    body('status').optional().isIn(['scheduled', 'in_progress', 'completed', 'cancelled', 'postponed']),
  ],
  updateMatch
);

// ── Delete ────────────────────────────────────────────────────────────────────
router.delete('/:id', auth, requireCoach, deleteMatch);

// ── Events ────────────────────────────────────────────────────────────────────
router.post(
  '/:id/events',
  auth,
  requireCoach,
  [
    body('type').isIn(['goal', 'assist', 'yellow_card', 'red_card', 'substitution', 'injury', 'penalty_goal', 'own_goal']),
    body('minute').isInt({ min: 1, max: 120 }),
    body('isHomeTeam').isBoolean(),
  ],
  addMatchEvent
);

router.delete('/:id/events/:eventId', auth, requireCoach, deleteMatchEvent);

// ── Legacy routes (kept for bracket generator compat) ─────────────────────────
router.put('/:id/schedule', auth, requireCoach, scheduleMatch);
router.put('/:id/score', auth, requireCoach, submitScore);

module.exports = router;
