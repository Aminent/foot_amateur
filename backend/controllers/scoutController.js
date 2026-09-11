const { ScoutEvaluation, ScoutWatchlist, Player, User } = require('../models');

// GET /scouts/me/evaluations
const getEvaluations = async (req, res) => {
  try {
    const evals = await ScoutEvaluation.findAll({
      where: { scoutId: req.user.id },
      include: [{ model: Player, as: 'player', attributes: ['id', 'name', 'position', 'teamId'] }],
      order: [['createdAt', 'DESC']],
    });
    res.json({ evaluations: evals });
  } catch (err) {
    console.error('[Scout] getEvaluations error:', err.message);
    res.status(500).json({ message: err.message });
  }
};

// POST /scouts/me/evaluations
const createEvaluation = async (req, res) => {
  try {
    const { playerId, date, overallRating, technicalScore, physicalScore, mentalScore, tacticalScore, recommendation, potential, notes, position } = req.body;
    if (!playerId || !overallRating) return res.status(422).json({ message: 'playerId et overallRating requis' });
    const evaluation = await ScoutEvaluation.create({
      scoutId: req.user.id, playerId, date: date || new Date(),
      overallRating, technicalScore, physicalScore, mentalScore, tacticalScore, recommendation, potential, notes, position,
    });
    res.status(201).json({ evaluation });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};

// DELETE /scouts/me/evaluations/:id
const deleteEvaluation = async (req, res) => {
  try {
    const ev = await ScoutEvaluation.findOne({ where: { id: req.params.id, scoutId: req.user.id } });
    if (!ev) return res.status(404).json({ message: 'Evaluation non trouvée' });
    await ev.destroy();
    res.json({ message: 'Supprimé' });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};

// GET /scouts/me/watchlist
const getWatchlist = async (req, res) => {
  try {
    const items = await ScoutWatchlist.findAll({
      where: { scoutId: req.user.id },
      include: [{ model: Player, as: 'player', attributes: ['id', 'name', 'position', 'teamId'] }],
    });
    res.json({ watchlist: items });
  } catch (err) {
    console.error('[Scout] getWatchlist error:', err.message);
    res.status(500).json({ message: err.message });
  }
};

// POST /scouts/me/watchlist
const addToWatchlist = async (req, res) => {
  try {
    const { playerId, notes } = req.body;
    if (!playerId) return res.status(422).json({ message: 'playerId requis' });
    const [item, created] = await ScoutWatchlist.findOrCreate({
      where: { scoutId: req.user.id, playerId },
      defaults: { notes },
    });
    res.status(created ? 201 : 200).json({ item });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};

// DELETE /scouts/me/watchlist/:playerId
const removeFromWatchlist = async (req, res) => {
  try {
    const deleted = await ScoutWatchlist.destroy({
      where: { scoutId: req.user.id, playerId: req.params.playerId },
    });
    if (!deleted) return res.status(404).json({ message: 'Non trouvé' });
    res.json({ message: 'Retiré de la watchlist' });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};

module.exports = { getEvaluations, createEvaluation, deleteEvaluation, getWatchlist, addToWatchlist, removeFromWatchlist };
