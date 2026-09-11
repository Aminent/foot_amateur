const { TrainingSession, Team, User, Player } = require('../models');
const { validationResult } = require('express-validator');
const notificationService = require('../services/notificationService');

// Shared include for full session data
const sessionIncludes = [
  { model: Team, as: 'team', attributes: ['id', 'name'] },
  { model: User, as: 'coach', attributes: ['id', 'name', 'email'] },
];

// ── Coach: GET /coaches/me/trainings ─────────────────────────────────────────
const getMyTrainings = async (req, res) => {
  try {
    const coach = await User.findOne({ where: { id: req.user.id, role: 'coach' } });
    if (!coach || !coach.teamId) {
      return res.status(404).json({ message: 'Aucune équipe assignée à ce coach' });
    }

    const sessions = await TrainingSession.findAll({
      where: { teamId: coach.teamId },
      include: sessionIncludes,
      order: [['date', 'DESC']],
    });

    res.json({ sessions });
  } catch (error) {
    console.error('getMyTrainings error:', error);
    res.status(500).json({ message: 'Erreur lors du chargement des séances' });
  }
};

// ── Coach: POST /coaches/me/trainings ────────────────────────────────────────
const createTraining = async (req, res) => {
  try {
    const errors = validationResult(req);
    if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });

    const coach = await User.findOne({ where: { id: req.user.id, role: 'coach' } });
    if (!coach || !coach.teamId) {
      return res.status(404).json({ message: 'Aucune équipe assignée à ce coach' });
    }

    const { title, description, type, date, duration, location, notes } = req.body;

    const session = await TrainingSession.create({
      teamId: coach.teamId,
      coachId: coach.id,
      title,
      description: description || null,
      type: type || 'technique',
      date: new Date(date),
      duration: duration ? parseInt(duration) : null,
      location: location || null,
      notes: notes || null,
      status: 'scheduled',
    });

    const full = await TrainingSession.findByPk(session.id, { include: sessionIncludes });
    res.status(201).json({ session: full });

    // Push notification to all team players (fire-and-forget)
    try {
      const teamPlayers = await Player.findAll({
        where: { teamId: coach.teamId },
        include: [{ model: User, as: 'user', attributes: ['fcmToken'] }],
      });
      const tokens = teamPlayers.map(p => p.user?.fcmToken).filter(Boolean);
      if (tokens.length) {
        const dateStr = `${_formatDate(session.date)} à ${_formatTime(session.date)}`;
        await notificationService.sendToTokens(
          tokens,
          '📋 Nouvel entraînement planifié',
          `${title} — ${dateStr}${location ? ' @ ' + location : ''}`,
          { type: 'training_scheduled', trainingId: String(session.id) }
        );
      }
    } catch (notifErr) {
      console.warn('[FCM] createTraining notify error:', notifErr.message);
    }
  } catch (error) {
    console.error('createTraining error:', error);
    res.status(500).json({ message: 'Erreur lors de la création de la séance' });
  }
};

// ── Coach: PUT /coaches/me/trainings/:id ─────────────────────────────────────
const updateTraining = async (req, res) => {
  try {
    const errors = validationResult(req);
    if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });

    const coach = await User.findOne({ where: { id: req.user.id, role: 'coach' } });
    if (!coach) return res.status(404).json({ message: 'Coach non trouvé' });

    const session = await TrainingSession.findOne({
      where: { id: req.params.id, coachId: coach.id },
    });
    if (!session) return res.status(404).json({ message: 'Séance introuvable' });

    const { title, description, type, date, duration, location, status, notes } = req.body;

    await session.update({
      title:       title       !== undefined ? title       : session.title,
      description: description !== undefined ? description : session.description,
      type:        type        !== undefined ? type        : session.type,
      date:        date        !== undefined ? new Date(date) : session.date,
      duration:    duration    !== undefined ? (duration ? parseInt(duration) : null) : session.duration,
      location:    location    !== undefined ? location    : session.location,
      status:      status      !== undefined ? status      : session.status,
      notes:       notes       !== undefined ? notes       : session.notes,
    });

    const full = await TrainingSession.findByPk(session.id, { include: sessionIncludes });
    res.json({ session: full });

    // Push notification to all team players (fire-and-forget)
    try {
      const teamId = full.teamId;
      const teamPlayers = await Player.findAll({
        where: { teamId },
        include: [{ model: User, as: 'user', attributes: ['fcmToken'] }],
      });
      const tokens = teamPlayers.map(p => p.user?.fcmToken).filter(Boolean);
      if (tokens.length) {
        const dateStr = `${_formatDate(full.date)} à ${_formatTime(full.date)}`;
        const sessionTitle = full.title;
        const sessionLocation = full.location;

        let notifTitle, notifBody;
        if (status === 'cancelled') {
          notifTitle = '❌ Séance annulée';
          notifBody = `"${sessionTitle}" a été annulée.`;
        } else if (status === 'completed') {
          notifTitle = '✅ Séance terminée';
          notifBody = `"${sessionTitle}" a été marquée comme terminée.`;
        } else {
          notifTitle = '✏️ Séance modifiée';
          notifBody = `"${sessionTitle}" — ${dateStr}${sessionLocation ? ' @ ' + sessionLocation : ''}`;
        }

        await notificationService.sendToTokens(tokens, notifTitle, notifBody, {
          type: 'training_updated',
          trainingId: String(full.id),
        });
      }
    } catch (notifErr) {
      console.warn('[FCM] updateTraining notify error:', notifErr.message);
    }
  } catch (error) {
    console.error('updateTraining error:', error);
    res.status(500).json({ message: 'Erreur lors de la mise à jour de la séance' });
  }
};

// ── Coach: DELETE /coaches/me/trainings/:id ───────────────────────────────────
const deleteTraining = async (req, res) => {
  try {
    const coach = await User.findOne({ where: { id: req.user.id, role: 'coach' } });
    if (!coach) return res.status(404).json({ message: 'Coach non trouvé' });

    const session = await TrainingSession.findOne({
      where: { id: req.params.id, coachId: coach.id },
    });
    if (!session) return res.status(404).json({ message: 'Séance introuvable' });

    await session.destroy();
    res.json({ message: 'Séance supprimée' });
  } catch (error) {
    console.error('deleteTraining error:', error);
    res.status(500).json({ message: 'Erreur lors de la suppression de la séance' });
  }
};

// ── Player: GET /players/me/training-sessions ────────────────────────────────
// Returns all scheduled/completed sessions for the player's team
const getPlayerTrainings = async (req, res) => {
  try {
    // req.user is the User (joueur role). Find linked Player → teamId
    const player = await Player.findOne({ where: { userId: req.user.id } });
    if (!player || !player.teamId) {
      return res.json([]); // no team yet → empty list, not an error
    }

    const sessions = await TrainingSession.findAll({
      where: { teamId: player.teamId },
      include: sessionIncludes,
      order: [['date', 'DESC']],
    });

    // Return plain array (matches existing mobile expectation)
    const formatted = sessions.map(s => ({
      id: s.id,
      title: s.title,
      description: s.description,
      type: _typeLabel(s.type),
      date: _formatDate(s.date),
      time: _formatTime(s.date),
      duration: s.duration ? `${s.duration} min` : null,
      location: s.location,
      status: _statusLabel(s.status),
      coach: s.coach?.name || 'Coach',
    }));

    res.json(formatted);
  } catch (error) {
    console.error('getPlayerTrainings error:', error);
    res.status(500).json({ message: 'Erreur lors du chargement des séances' });
  }
};

// ── helpers ───────────────────────────────────────────────────────────────────
function _typeLabel(type) {
  const map = { technique: 'Technique', tactique: 'Tactique', physique: 'Physique', match: 'Match', autre: 'Autre' };
  return map[type] || 'Entraînement';
}

function _statusLabel(status) {
  const map = { scheduled: 'À venir', completed: 'Terminé', cancelled: 'Annulé' };
  return map[status] || status;
}

function _formatDate(d) {
  if (!d) return '';
  const dt = new Date(d);
  return `${String(dt.getDate()).padStart(2, '0')}/${String(dt.getMonth() + 1).padStart(2, '0')}/${dt.getFullYear()}`;
}

function _formatTime(d) {
  if (!d) return '';
  const dt = new Date(d);
  return `${String(dt.getHours()).padStart(2, '0')}:${String(dt.getMinutes()).padStart(2, '0')}`;
}

module.exports = {
  getMyTrainings,
  createTraining,
  updateTraining,
  deleteTraining,
  getPlayerTrainings,
};
