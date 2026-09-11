const express = require('express');
const multer = require('multer');
const path = require('path');
const fs = require('fs');
const { auth, requireAdmin } = require('../middleware/auth');
const { Team, Player } = require('../models');

const router = express.Router();

// Create upload directories
const avatarUploadDir = path.join(__dirname, '..', 'uploads', 'avatars');
const teamUploadDir = path.join(__dirname, '..', 'uploads', 'teams');
const playerUploadDir = path.join(__dirname, '..', 'uploads', 'players');

try {
  fs.mkdirSync(avatarUploadDir, { recursive: true });
  fs.mkdirSync(teamUploadDir, { recursive: true });
  fs.mkdirSync(playerUploadDir, { recursive: true });
} catch (error) {
  console.error('❌ Error creating upload directories:', error);
}

// Avatar storage configuration
const avatarStorage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, avatarUploadDir);
  },
  filename: (req, file, cb) => {
    const ext = path.extname(file.originalname);
    const safeName = `${req.user.id}_${Date.now()}${ext}`;
    cb(null, safeName);
  }
});

// Team photo storage configuration
const teamStorage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, teamUploadDir);
  },
  filename: (req, file, cb) => {
    const ext = path.extname(file.originalname);
    const teamId = req.params.teamId || 'unknown';
    const safeName = `team_${teamId}_${Date.now()}${ext}`;
    cb(null, safeName);
  }
});

// Player photo storage configuration
const playerStorage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, playerUploadDir);
  },
  filename: (req, file, cb) => {
    const ext = path.extname(file.originalname);
    const playerId = req.params.playerId || 'unknown';
    const safeName = `player_${playerId}_${Date.now()}${ext}`;
    cb(null, safeName);
  }
});

const fileFilter = (req, file, cb) => {
  if (/^image\/(jpeg|png|gif|webp)$/.test(file.mimetype)) return cb(null, true);
  cb(new Error('Invalid file type'));
};

// Create multer instances
const avatarUpload = multer({ 
  storage: avatarStorage, 
  fileFilter, 
  limits: { fileSize: 2 * 1024 * 1024 } 
});

const teamUpload = multer({ 
  storage: teamStorage, 
  fileFilter, 
  limits: { fileSize: 5 * 1024 * 1024 } // 5MB for team photos
});

const playerUpload = multer({ 
  storage: playerStorage, 
  fileFilter, 
  limits: { fileSize: 5 * 1024 * 1024 } // 5MB for player photos
});

// Avatar upload endpoint
router.post('/avatar', auth, avatarUpload.single('avatar'), async (req, res) => {
  try {
    const relative = `/uploads/avatars/${req.file.filename}`;
    res.json({ url: relative });
  } catch (error) {
    console.error('Upload error:', error);
    res.status(500).json({ message: 'Erreur lors du téléchargement' });
  }
});

// Team photo upload endpoint with error handling
router.post('/team/:teamId/photo', auth, requireAdmin, (req, res, next) => {
  teamUpload.single('photo')(req, res, (err) => {
    if (err) {
      console.error('Multer error:', err);
      if (err.code === 'LIMIT_FILE_SIZE') {
        return res.status(400).json({ message: 'Fichier trop volumineux (max 5MB)' });
      }
      if (err.message === 'Invalid file type') {
        return res.status(400).json({ message: 'Type de fichier invalide. Utilisez JPEG, PNG, GIF ou WebP.' });
      }
      return res.status(500).json({ message: 'Erreur lors du téléchargement: ' + err.message });
    }
    next();
  });
}, async (req, res) => {
  try {
    const { teamId } = req.params;
    
    if (!req.file) {
      return res.status(400).json({ message: 'Aucun fichier téléchargé' });
    }
    
    // Verify team exists
    const team = await Team.findByPk(teamId);
    if (!team) {
      return res.status(404).json({ message: 'Équipe non trouvée' });
    }

    const photoUrl = `/uploads/teams/${req.file.filename}`;
    
    // Update team with new photo URL
    await team.update({ logo: photoUrl });
    
    res.json({ 
      message: 'Photo de l\'équipe téléchargée avec succès',
      url: photoUrl,
      team: team
    });
  } catch (error) {
    console.error('Team photo upload error:', error);
    console.error('Error stack:', error.stack);
    res.status(500).json({ 
      message: 'Erreur lors du téléchargement de la photo',
      error: error.message 
    });
  }
});

// Player photo upload endpoint with error handling
router.post('/player/:playerId/photo', auth, requireAdmin, (req, res, next) => {
  playerUpload.single('photo')(req, res, (err) => {
    if (err) {
      console.error('Multer error:', err);
      if (err.code === 'LIMIT_FILE_SIZE') {
        return res.status(400).json({ message: 'Fichier trop volumineux (max 5MB)' });
      }
      if (err.message === 'Invalid file type') {
        return res.status(400).json({ message: 'Type de fichier invalide. Utilisez JPEG, PNG, GIF ou WebP.' });
      }
      return res.status(500).json({ message: 'Erreur lors du téléchargement: ' + err.message });
    }
    next();
  });
}, async (req, res) => {
  try {
    const { playerId } = req.params;
    
    if (!req.file) {
      return res.status(400).json({ message: 'Aucun fichier téléchargé' });
    }
    
    // Verify player exists
    const player = await Player.findByPk(playerId);
    if (!player) {
      return res.status(404).json({ message: 'Joueur non trouvé' });
    }

    const photoUrl = `/uploads/players/${req.file.filename}`;
    
    // Update player with new photo URL
    await player.update({ avatar: photoUrl });
    
    res.json({ 
      message: 'Photo du joueur téléchargée avec succès',
      url: photoUrl,
      player: player
    });
  } catch (error) {
    console.error('Player photo upload error:', error);
    console.error('Error stack:', error.stack);
    res.status(500).json({ 
      message: 'Erreur lors du téléchargement de la photo',
      error: error.message 
    });
  }
});

module.exports = router;
