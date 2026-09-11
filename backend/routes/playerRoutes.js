const express = require('express');
const { auth, requirePlayer } = require('../middleware/auth');
const {
  getMyPlayerProfile,
  getMyStats,
  getMyTeam,
  getMyMatches,
  getMyTournaments,
  updateMyProfile
} = require('../controllers/playerController');
const { getPlayerTrainings } = require('../controllers/trainingController');
const { getMyAttendance } = require('../controllers/attendanceController');
const { getPlayerLineup } = require('../controllers/lineupController');
const { User } = require('../models');

const router = express.Router();

// All routes require authentication and player role
router.use(auth);
router.use(requirePlayer);

// Player-specific routes
router.get('/me/profile', getMyPlayerProfile);
router.get('/me/stats', getMyStats);
router.get('/me/team', getMyTeam);
router.get('/me/matches', getMyMatches);
router.get('/me/tournaments', getMyTournaments);
router.get('/me/training-sessions', getPlayerTrainings);
router.get('/me/attendance', getMyAttendance);
router.put('/me/profile', updateMyProfile);
router.get('/me/lineup/:matchId', getPlayerLineup);

// FCM token registration
router.put('/me/fcm-token', async (req, res) => {
  try {
    const { fcmToken } = req.body;
    if (!fcmToken) return res.status(400).json({ message: 'fcmToken requis' });
    await User.update({ fcmToken }, { where: { id: req.user.id } });
    res.json({ message: 'Token FCM enregistré' });
  } catch (err) {
    res.status(500).json({ message: 'Erreur serveur' });
  }
});

module.exports = router;
