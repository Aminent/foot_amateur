const express = require('express');
const bcrypt = require('bcryptjs');
const { body, validationResult } = require('express-validator');
const { Op } = require('sequelize');
const { auth, requireRole } = require('../middleware/auth');
const { User, Match, Team, Tournament } = require('../models');

const router = express.Router();
const requireAdmin = requireRole(['admin']);
const requireDelegate = requireRole(['delegue']);

const publicFields = (u) => ({ id: u.id, name: u.name, email: u.email, phone: u.phone, isActive: u.isActive });
const matchInclude = [
  { model: Team, as: 'homeTeam', attributes: ['id', 'name'] },
  { model: Team, as: 'awayTeam', attributes: ['id', 'name'] },
  { model: Tournament, as: 'tournament', attributes: ['id', 'name', 'format'] },
];

// ── Delegate: matches assigned to me ─────────────────────────────────────────
router.get('/me/matches', auth, requireDelegate, async (req, res) => {
  try {
    const matches = await Match.findAll({
      where: { delegateId: req.user.id, status: { [Op.ne]: 'cancelled' } },
      include: matchInclude,
      order: [['date', 'ASC']],
    });
    res.json({ matches });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

// ── Admin: list delegates with their matches ─────────────────────────────────
router.get('/', auth, requireAdmin, async (req, res) => {
  try {
    const delegates = await User.findAll({
      where: { role: 'delegue' },
      attributes: ['id', 'name', 'email', 'phone', 'isActive', 'createdAt'],
      include: [{ model: Match, as: 'delegatedMatches', attributes: ['id', 'date', 'status'], include: matchInclude.slice(0, 2) }],
      order: [['name', 'ASC']],
    });
    res.json({ delegates });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

// ── Admin: create a delegate account (they log into the mobile app) ──────────
router.post('/', auth, requireAdmin,
  body('name').trim().isLength({ min: 2 }).withMessage('Nom requis'),
  body('email').isEmail().normalizeEmail().withMessage('Email invalide'),
  body('password').isLength({ min: 6 }).withMessage('Mot de passe : 6 caractères minimum'),
  async (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) return res.status(400).json({ message: errors.array()[0].msg });
    try {
      const { name, email, password, phone } = req.body;
      if (await User.findOne({ where: { email } })) return res.status(409).json({ message: 'Email déjà utilisé' });
      const user = await User.create({ name, email, phone: phone || null, role: 'delegue', isActive: true, password: await bcrypt.hash(password, 10) });
      res.status(201).json({ delegate: publicFields(user) });
    } catch (err) {
      res.status(500).json({ message: err.message });
    }
  }
);

// ── Admin: update a delegate (password optional) ─────────────────────────────
router.put('/:id', auth, requireAdmin, async (req, res) => {
  try {
    const user = await User.findOne({ where: { id: req.params.id, role: 'delegue' } });
    if (!user) return res.status(404).json({ message: 'Délégué introuvable' });
    const { name, phone, isActive, password } = req.body;
    if (password !== undefined && password !== '' && String(password).length < 6) {
      return res.status(400).json({ message: 'Mot de passe : 6 caractères minimum' });
    }
    await user.update({
      ...(name !== undefined && { name }),
      ...(phone !== undefined && { phone: phone || null }),
      ...(isActive !== undefined && { isActive: Boolean(isActive) }),
      ...(password ? { password: await bcrypt.hash(password, 10) } : {}),
    });
    res.json({ delegate: publicFields(user) });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

// ── Admin: delete a delegate (their matches lose their delegate) ─────────────
router.delete('/:id', auth, requireAdmin, async (req, res) => {
  try {
    const user = await User.findOne({ where: { id: req.params.id, role: 'delegue' } });
    if (!user) return res.status(404).json({ message: 'Délégué introuvable' });
    const live = await Match.count({ where: { delegateId: user.id, status: { [Op.in]: ['in_progress', 'half_time'] } } });
    if (live) return res.status(400).json({ message: 'Ce délégué suit un match en cours : attendez la fin du match' });
    await Match.update({ delegateId: null }, { where: { delegateId: user.id } });
    await user.destroy();
    res.json({ message: 'Délégué supprimé' });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

// ── Admin: assign the delegate of a match (null = none) ──────────────────────
router.put('/match/:matchId', auth, requireAdmin, async (req, res) => {
  try {
    const match = await Match.findByPk(req.params.matchId);
    if (!match) return res.status(404).json({ message: 'Match introuvable' });
    const delegateId = req.body.delegateId ? Number(req.body.delegateId) : null;
    if (String(delegateId ?? '') === String(match.delegateId ?? '')) return res.json({ message: 'Inchangé' });
    if (['in_progress', 'half_time'].includes(match.status)) {
      return res.status(400).json({ message: 'Le match est en cours : le délégué ne peut plus être changé' });
    }
    if (delegateId) {
      const delegate = await User.findOne({ where: { id: delegateId, role: 'delegue', isActive: true } });
      if (!delegate) return res.status(404).json({ message: 'Délégué introuvable ou inactif' });
    }
    await match.update({ delegateId });
    res.json({ message: 'Délégué mis à jour' });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

module.exports = router;
