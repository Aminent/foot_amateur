const express = require('express');
const { auth, requireCoach, requireAdmin } = require('../middleware/auth');
const { getStats, setStats, incrementStat, recalculateAllStats } = require('../controllers/playerStatController');

const router = express.Router();

// ── #8 : Recalcul global des stats (admin uniquement) — monter AVANT /:playerId
router.post('/recalculate', auth, requireAdmin, recalculateAllStats);

// Anyone authenticated can view stats
router.get('/:playerId', auth, getStats);
// Admin and coach can update stats
router.put('/:playerId', auth, requireCoach, setStats);
router.post('/:playerId/increment', auth, requireCoach, incrementStat);

module.exports = router;


