const express = require('express');
const { auth, requireCoach } = require('../middleware/auth');
const {
  getMyRewards,
  awardBadge,
  awardReward,
  getBadgeTypes,
  getPlayerBadges,
} = require('../controllers/rewardController');

const router = express.Router();

// All routes require authentication
router.use(auth);

// Player routes
router.get('/me', getMyRewards);

// Coach/Admin routes
router.post('/award-badge', requireCoach, awardBadge);
router.post('/award-reward', requireCoach, awardReward);
router.get('/types', getBadgeTypes);
router.get('/player/:playerId/badges', requireCoach, getPlayerBadges);

module.exports = router;
