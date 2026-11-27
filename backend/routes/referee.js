/**
 * Espace Arbitre — reconstruit d'après l'APK du 15/10.
 *
 * Arbitre (rôle 'arbitre') :
 *   GET  /api/referee/me/missions                 ?status=pending|accepted|declined
 *   GET  /api/referee/me/stats
 *   POST /api/referee/me/missions/:id/respond     { action: 'accept'|'decline', reason? }
 *   POST /api/referee/me/missions/:id/upload-sheet  multipart: sheet (image), type: presence|match
 * Admin :
 *   GET  /api/referee/referees
 *   POST /api/referee/missions                    { matchId, refereeId, role }
 */
const express = require('express');
const multer = require('multer');
const path = require('path');
const fs = require('fs');
const { auth, requireRole, requireAdmin } = require('../middleware/auth');
const { RefereeMission, Match, Team, Tournament, User } = require('../models');
const notificationService = require('../services/notificationService');

const router = express.Router();
const requireReferee = requireRole(['arbitre']);

const sheetDir = path.join(__dirname, '..', 'uploads', 'sheets');
fs.mkdirSync(sheetDir, { recursive: true });
const upload = multer({
  storage: multer.diskStorage({
    destination: (req, file, cb) => cb(null, sheetDir),
    filename: (req, file, cb) => cb(null, `mission_${req.params.id}_${req.body.type || 'sheet'}_${Date.now()}${path.extname(file.originalname) || '.jpg'}`),
  }),
  limits: { fileSize: 10 * 1024 * 1024 },
  fileFilter: (req, file, cb) => (/^image\/(jpeg|png|webp|heic)$/.test(file.mimetype) ? cb(null, true) : cb(new Error('Format d\'image non supporté'))),
});

const teamAttrs = ['id', 'name', 'shortName', 'logo'];
const missionInclude = [{
  model: Match, as: 'match',
  include: [
    { model: Team, as: 'homeTeam', attributes: teamAttrs },
    { model: Team, as: 'awayTeam', attributes: teamAttrs },
    { model: Tournament, as: 'tournament', attributes: ['id', 'name'] },
  ],
}];

const findOwnMission = (req) => RefereeMission.findOne({ where: { id: req.params.id, refereeId: req.user.id }, include: missionInclude });

router.get('/me/missions', auth, requireReferee, async (req, res) => {
  try {
    const where = { refereeId: req.user.id };
    if (['pending', 'accepted', 'declined'].includes(req.query.status)) where.status = req.query.status;
    const missions = await RefereeMission.findAll({ where, include: missionInclude, order: [[{ model: Match, as: 'match' }, 'date', 'ASC']] });
    res.json({ missions });
  } catch (e) {
    res.status(500).json({ message: 'Erreur lors du chargement des missions', error: e.message });
  }
});

router.get('/me/stats', auth, requireReferee, async (req, res) => {
  try {
    const missions = await RefereeMission.findAll({ where: { refereeId: req.user.id }, include: missionInclude });
    const count = (s) => missions.filter((m) => m.status === s).length;
    const accepted = count('accepted'), declined = count('declined');
    const answered = accepted + declined;
    const now = new Date();
    const next = missions
      .filter((m) => m.status === 'accepted' && m.match && new Date(m.match.date) >= now)
      .sort((a, b) => new Date(a.match.date) - new Date(b.match.date))[0] || null;
    res.json({
      totalMissions: missions.length,
      pending: count('pending'),
      accepted,
      declined,
      matchesRefereed: missions.filter((m) => m.status === 'accepted' && m.match?.status === 'completed').length,
      acceptanceRate: answered ? Math.round((accepted / answered) * 100) : 0,
      officialDisputes: 0,
      nextMission: next,
    });
  } catch (e) {
    res.status(500).json({ message: 'Erreur lors du chargement des statistiques', error: e.message });
  }
});

router.post('/me/missions/:id/respond', auth, requireReferee, async (req, res) => {
  try {
    const { action, reason } = req.body;
    if (!['accept', 'decline'].includes(action)) return res.status(400).json({ message: 'Action invalide (accept|decline)' });
    const mission = await findOwnMission(req);
    if (!mission) return res.status(404).json({ message: 'Mission introuvable' });
    if (mission.status !== 'pending') return res.status(409).json({ message: 'Cette mission a déjà reçu une réponse' });
    await mission.update({ status: action === 'accept' ? 'accepted' : 'declined', respondedAt: new Date(), declineReason: action === 'decline' ? (reason || null) : null });
    res.json({ mission });
  } catch (e) {
    res.status(500).json({ message: 'Erreur lors de la réponse', error: e.message });
  }
});

router.post('/me/missions/:id/upload-sheet', auth, requireReferee, upload.single('sheet'), async (req, res) => {
  try {
    if (!req.file) return res.status(400).json({ message: 'Image de la feuille requise (champ "sheet")' });
    const type = req.body.type === 'match' ? 'match' : 'presence';
    const mission = await findOwnMission(req);
    if (!mission) { fs.unlink(req.file.path, () => {}); return res.status(404).json({ message: 'Mission introuvable' }); }
    if (mission.status !== 'accepted') { fs.unlink(req.file.path, () => {}); return res.status(409).json({ message: 'La mission doit être acceptée' }); }
    const url = `/uploads/sheets/${req.file.filename}`;
    await mission.update(type === 'match' ? { matchSheetUrl: url } : { presenceSheetUrl: url });
    res.json({ mission, url, type });
  } catch (e) {
    res.status(500).json({ message: 'Erreur lors de l\'envoi de la feuille', error: e.message });
  }
});

// ── Admin ────────────────────────────────────────────────────────────────────
router.get('/referees', auth, requireAdmin, async (req, res) => {
  const referees = await User.findAll({ where: { role: 'arbitre', isActive: true }, attributes: ['id', 'name', 'email', 'phone'], order: [['name', 'ASC']] });
  res.json({ referees });
});

router.post('/missions', auth, requireAdmin, async (req, res) => {
  try {
    const { matchId, refereeId, role = 'main' } = req.body;
    if (!['main', 'assistant', 'fourth'].includes(role)) return res.status(400).json({ message: 'Rôle invalide' });
    const [match, referee] = await Promise.all([Match.findByPk(matchId), User.findOne({ where: { id: refereeId, role: 'arbitre' } })]);
    if (!match) return res.status(404).json({ message: 'Match introuvable' });
    if (!referee) return res.status(404).json({ message: 'Arbitre introuvable' });
    const existing = await RefereeMission.findOne({ where: { matchId, refereeId } });
    if (existing) return res.status(409).json({ message: 'Arbitre déjà désigné sur ce match' });
    const mission = await RefereeMission.create({ matchId, refereeId, role, assignedById: req.user.id });
    if (role === 'main') await match.update({ referee: referee.name });
    if (referee.fcmToken) {
      notificationService.sendToToken(referee.fcmToken, 'Nouvelle mission assignée', `Match du ${new Date(match.date).toLocaleDateString('fr-FR')}`, { type: 'referee_mission', missionId: String(mission.id) }).catch(() => {});
    }
    res.status(201).json({ mission });
  } catch (e) {
    res.status(500).json({ message: 'Erreur lors de la désignation', error: e.message });
  }
});

router.put('/me/fcm-token', auth, requireReferee, async (req, res) => {
  await req.user.update({ fcmToken: req.body.fcmToken || null });
  res.json({ ok: true });
});

// ── Admin : gestion des arbitres (page « Arbitres » de l'admin) ─────────────
const bcrypt = require('bcryptjs');
const crypto = require('crypto');
const refereePublic = (u) => ({ id: u.id, name: u.name, email: u.email, phone: u.phone, isActive: u.isActive });

router.get('/', auth, requireAdmin, async (req, res) => {
  try {
    const referees = await User.findAll({
      where: { role: 'arbitre' },
      attributes: ['id', 'name', 'email', 'phone', 'isActive', 'createdAt'],
      include: [{ model: RefereeMission, as: 'refereeMissions', attributes: ['id', 'matchId', 'role', 'status'], required: false }],
      order: [['createdAt', 'DESC']],
    });
    res.json({ referees: referees.map(r => ({ ...refereePublic(r), missions: r.refereeMissions || [] })) });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

router.post('/', auth, requireAdmin, async (req, res) => {
  try {
    const name = String(req.body.name || '').trim();
    const email = String(req.body.email || '').trim().toLowerCase();
    const phone = req.body.phone || null;
    if (name.length < 2) return res.status(400).json({ message: 'Nom requis' });
    if (!/^\S+@\S+\.\S+$/.test(email)) return res.status(400).json({ message: 'Email invalide' });
    if (await User.findOne({ where: { email } })) return res.status(409).json({ message: 'Email déjà utilisé' });
    // L'arbitre n'a plus d'app : mot de passe aléatoire, inutilisable.
    const password = await bcrypt.hash(crypto.randomBytes(24).toString('hex'), 10);
    const referee = await User.create({ name, email, phone, password, role: 'arbitre', isActive: true });
    res.status(201).json({ referee: refereePublic(referee) });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

router.put('/:id', auth, requireAdmin, async (req, res) => {
  try {
    const referee = await User.findOne({ where: { id: req.params.id, role: 'arbitre' } });
    if (!referee) return res.status(404).json({ message: 'Arbitre introuvable' });
    const updates = {};
    for (const k of ['name', 'phone', 'isActive']) if (req.body[k] !== undefined) updates[k] = req.body[k];
    await referee.update(updates);
    res.json({ referee: refereePublic(referee) });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

router.delete('/:id', auth, requireAdmin, async (req, res) => {
  try {
    const referee = await User.findOne({ where: { id: req.params.id, role: 'arbitre' } });
    if (!referee) return res.status(404).json({ message: 'Arbitre introuvable' });
    await RefereeMission.destroy({ where: { refereeId: referee.id } });
    await referee.destroy();
    res.json({ message: 'Arbitre supprimé' });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

module.exports = router;
