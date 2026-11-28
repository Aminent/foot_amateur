const express = require('express');
const { body } = require('express-validator');
const { auth, requireCoach } = require('../middleware/auth');
const {
  getMatches, getMatch, createMatch, updateMatch, deleteMatch,
  addMatchEvent, deleteMatchEvent,
  scheduleMatch, submitScore, liveAction,
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
    body('status').optional().isIn(['scheduled', 'in_progress', 'half_time', 'completed', 'cancelled', 'postponed']),
  ],
  updateMatch
);

// ── Delete ────────────────────────────────────────────────────────────────────
router.delete('/:id', auth, requireCoach, deleteMatch);

// Admin/coach comme avant, ou le délégué affecté à ce match (faits : seulement pendant le match).
const canTrackMatch = (liveOnly) => async (req, res, next) => {
  if (['admin', 'coach'].includes(req.user.role)) return next();
  if (req.user.role !== 'delegue') return res.status(403).json({ message: 'Accès refusé' });
  const { Match } = require('../models');
  const match = await Match.findByPk(req.params.id, { attributes: ['delegateId', 'status'] });
  if (!match) return res.status(404).json({ message: 'Match introuvable' });
  if (match.delegateId !== req.user.id) return res.status(403).json({ message: 'Ce match ne vous est pas affecté' });
  if (liveOnly && !['in_progress', 'half_time'].includes(match.status)) {
    return res.status(400).json({ message: "Les faits se saisissent pendant le match (après le coup d'envoi, avant la fin)" });
  }
  next();
};

// Chrono du match : coup d'envoi, mi-temps, 2e mi-temps, fin
router.put('/:id/live', auth, canTrackMatch(false), liveAction);

// ── Events ────────────────────────────────────────────────────────────────────
router.post(
  '/:id/events',
  auth,
  canTrackMatch(true),
  [
    body('type').isIn(['goal', 'assist', 'yellow_card', 'red_card', 'substitution', 'injury', 'penalty_goal', 'own_goal']),
    body('minute').isInt({ min: 1, max: 120 }),
    body('isHomeTeam').isBoolean(),
  ],
  addMatchEvent
);

router.delete('/:id/events/:eventId', auth, canTrackMatch(true), deleteMatchEvent);

// ── Legacy routes (kept for bracket generator compat) ─────────────────────────
router.put('/:id/schedule', auth, requireCoach, scheduleMatch);
router.put('/:id/score', auth, requireCoach, submitScore);

module.exports = router;
