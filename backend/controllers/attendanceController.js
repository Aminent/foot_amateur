const { TrainingSession, TrainingAttendance, Player, User, Team } = require('../models');

// ── Coach: GET /coaches/me/trainings/:id/attendance ───────────────────────────
// Returns all team players + their attendance status for this session
const getAttendance = async (req, res) => {
  try {
    const coach = await User.findOne({ where: { id: req.user.id, role: 'coach' } });
    if (!coach || !coach.teamId) return res.status(404).json({ message: 'Aucune équipe assignée' });

    const session = await TrainingSession.findOne({
      where: { id: req.params.id, teamId: coach.teamId },
    });
    if (!session) return res.status(404).json({ message: 'Séance introuvable' });

    const players = await Player.findAll({
      where: { teamId: coach.teamId, isActive: true },
      attributes: ['id', 'name', 'jerseyNumber', 'position'],
      order: [['jerseyNumber', 'ASC']],
    });

    const existing = await TrainingAttendance.findAll({
      where: { trainingSessionId: session.id },
    });
    const map = {};
    existing.forEach(a => { map[a.playerId] = { status: a.status, note: a.note }; });

    const attendance = players.map(p => ({
      playerId: p.id,
      name: p.name,
      jerseyNumber: p.jerseyNumber,
      position: p.position,
      status: map[p.id]?.status ?? null,
      note: map[p.id]?.note ?? null,
    }));

    res.json({ session: { id: session.id, title: session.title, date: session.date }, attendance });
  } catch (err) {
    console.error('getAttendance error:', err);
    res.status(500).json({ message: 'Erreur serveur' });
  }
};

// ── Coach: PUT /coaches/me/trainings/:id/attendance ───────────────────────────
// Bulk upsert attendance: body = { attendance: [{playerId, status, note?}] }
const saveAttendance = async (req, res) => {
  try {
    const coach = await User.findOne({ where: { id: req.user.id, role: 'coach' } });
    if (!coach || !coach.teamId) return res.status(404).json({ message: 'Aucune équipe assignée' });

    const session = await TrainingSession.findOne({
      where: { id: req.params.id, teamId: coach.teamId },
    });
    if (!session) return res.status(404).json({ message: 'Séance introuvable' });

    const records = req.body.attendance;
    if (!Array.isArray(records)) return res.status(400).json({ message: 'attendance[] requis' });

    for (const r of records) {
      if (!r.playerId || !['present', 'absent', 'excused'].includes(r.status)) continue;
      await TrainingAttendance.upsert({
        trainingSessionId: session.id,
        playerId: r.playerId,
        status: r.status,
        note: r.note ?? null,
      });
    }

    res.json({ message: 'Présences enregistrées' });
  } catch (err) {
    console.error('saveAttendance error:', err);
    res.status(500).json({ message: 'Erreur serveur' });
  }
};

// ── Player: GET /players/me/attendance ───────────────────────────────────────
// Returns player's attendance summary (rate + per-session list)
const getMyAttendance = async (req, res) => {
  try {
    const player = await Player.findOne({ where: { userId: req.user.id } });
    if (!player) return res.json({ rate: null, records: [] });

    const records = await TrainingAttendance.findAll({
      where: { playerId: player.id },
      include: [{
        model: TrainingSession,
        as: 'session',
        attributes: ['id', 'title', 'date', 'type'],
      }],
      order: [[{ model: TrainingSession, as: 'session' }, 'date', 'DESC']],
    });

    const total = records.length;
    const present = records.filter(r => r.status === 'present').length;
    const rate = total > 0 ? Math.round((present / total) * 100) : null;

    res.json({
      rate,
      total,
      present,
      absent: records.filter(r => r.status === 'absent').length,
      excused: records.filter(r => r.status === 'excused').length,
      records: records.map(r => ({
        sessionId: r.trainingSessionId,
        title: r.session?.title,
        date: r.session?.date,
        type: r.session?.type,
        status: r.status,
        note: r.note,
      })),
    });
  } catch (err) {
    console.error('getMyAttendance error:', err);
    res.status(500).json({ message: 'Erreur serveur' });
  }
};

module.exports = { getAttendance, saveAttendance, getMyAttendance };
