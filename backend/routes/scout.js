const express = require('express');
const router = express.Router();
const { auth } = require('../middleware/auth');
const {
  getEvaluations,
  createEvaluation,
  deleteEvaluation,
  getWatchlist,
  addToWatchlist,
  removeFromWatchlist,
} = require('../controllers/scoutController');

router.get('/me/evaluations', auth, getEvaluations);
router.post('/me/evaluations', auth, createEvaluation);
router.delete('/me/evaluations/:id', auth, deleteEvaluation);
router.get('/me/watchlist', auth, getWatchlist);
router.post('/me/watchlist', auth, addToWatchlist);
router.delete('/me/watchlist/:playerId', auth, removeFromWatchlist);

module.exports = router;
