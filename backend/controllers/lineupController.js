const { MatchLineup, Match, Team, Player, User } = require('../models');
const notificationService = require('../services/notificationService');
const { recomputePlayerStats } = require('../services/statsService');

// ── helpers ───────────────────────────────────────────────────────────────────

async function _getCoachTeam(userId) {
  const coach = await User.findOne({ where: { id: userId, role: 'coach' } });
  if (!coach || !coach.teamId) return null;
  return coach;
}

async function _getMatch(matchId, teamId) {
  const match = await Match.findByPk(matchId, {
    include: [
      { model: Team, as: 'homeTeam', attributes: ['id', 'name'] },
      { model: Team, as: 'awayTeam', attributes: ['id', 'name'] },
    ],
  });
  if (!match) return null;
  const isInvolved =
    Number(match.homeTeamId) === Number(teamId) ||
    Number(match.awayTeamId) === Number(teamId);
  return isInvolved ? match : null;
}

// ── GET /coaches/me/matches/:matchId/lineup ───────────────────────────────────
const getLineup = async (req, res) => {
  try {
    const coach = await _getCoachTeam(req.user.id);
    if (!coach) return res.status(404).json({ message: 'Équipe introuvable' });

    const match = await _getMatch(req.params.matchId, coach.teamId);
    if (!match) return res.status(404).json({ message: 'Match introuvable' });

    // Fetch squad (players of coach's team)
    const squad = await Player.findAll({
      where: { teamId: coach.teamId, isActive: true },
      attributes: ['id', 'name', 'position', 'jerseyNumber'],
      order: [['jerseyNumber', 'ASC']],
    });

    // Existing lineup (or empty)
    const lineup = await MatchLineup.findOne({
      where: { matchId: match.id, teamId: coach.teamId },
    });

    const isHome = Number(match.homeTeamId) === Number(coach.teamId);
    const opponent = isHome ? match.awayTeam : match.homeTeam;

    res.json({
      match: {
        id: match.id,
        date: match.date,
        opponent: opponent?.name ?? '?',
        location: match.location,
        status: match.status,
      },
      squad: squad.map(p => ({
        id: p.id,
        name: p.name,
        position: p.position,
        jerseyNumber: p.jerseyNumber,
      })),
      lineup: lineup
        ? {
            id: lineup.id,
            formation: lineup.formation,
            players: lineup.players,
            status: lineup.status,
          }
        : null,
    });
  } catch (err) {
    console.error('getLineup error:', err);
    res.status(500).json({ message: 'Erreur serveur' });
  }
};

// ── PUT /coaches/me/matches/:matchId/lineup ───────────────────────────────────
// Save (create or update) as draft
const saveLineup = async (req, res) => {
  try {
    const coach = await _getCoachTeam(req.user.id);
    if (!coach) return res.status(404).json({ message: 'Équipe introuvable' });

    const match = await _getMatch(req.params.matchId, coach.teamId);
    if (!match) return res.status(404).json({ message: 'Match introuvable' });

    const { formation, players } = req.body;
    if (!formation) return res.status(400).json({ message: 'Formation requise' });
    if (!Array.isArray(players)) return res.status(400).json({ message: 'Joueurs requis' });

    const squadIds = new Set((await Player.findAll({ where: { teamId: coach.teamId }, attributes: ['id'], raw: true })).map(p => p.id));
    if (players.some(p => !squadIds.has(Number(p.playerId)))) {
      return res.status(400).json({ message: "La composition contient un joueur qui n'est pas dans l'équipe" });
    }
    const before = await MatchLineup.findOne({ where: { matchId: match.id, teamId: coach.teamId }, raw: true });
    const previousIds = (before?.players || []).map(p => Number(p.playerId));

    const [lineup] = await MatchLineup.upsert({
      matchId: match.id,
      teamId: coach.teamId,
      formation,
      players,
      status: 'draft',
    }, { returning: true });

    // Re-fetch after upsert (upsert may return stale data on some DBs)
    const saved = await MatchLineup.findOne({
      where: { matchId: match.id, teamId: coach.teamId },
    });

    // The lineup decides who played: minutes and goalkeeper stats follow it.
    if (match.status === 'completed') {
      await recomputePlayerStats([...previousIds, ...players.map(p => Number(p.playerId))]);
    }

    res.json({ lineup: { id: saved.id, formation: saved.formation, players: saved.players, status: saved.status } });
  } catch (err) {
    console.error('saveLineup error:', err);
    res.status(500).json({ message: 'Erreur serveur' });
  }
};

// ── POST /coaches/me/matches/:matchId/lineup/publish ─────────────────────────
// Publish lineup + notify each player
const publishLineup = async (req, res) => {
  try {
    const coach = await _getCoachTeam(req.user.id);
    if (!coach) return res.status(404).json({ message: 'Équipe introuvable' });

    const match = await _getMatch(req.params.matchId, coach.teamId);
    if (!match) return res.status(404).json({ message: 'Match introuvable' });

    const lineup = await MatchLineup.findOne({
      where: { matchId: match.id, teamId: coach.teamId },
    });
    if (!lineup) return res.status(404).json({ message: 'Aucune composition enregistrée' });

    await lineup.update({ status: 'published' });

    res.json({ message: 'Composition publiée', lineup: { id: lineup.id, status: 'published' } });

    // ── Push notifications (fire-and-forget) ─────────────────────────────────
    try {
      const isHome = Number(match.homeTeamId) === Number(coach.teamId);
      const opponent = (isHome ? match.awayTeam : match.homeTeam)?.name ?? '?';
      const matchDate = new Date(match.date).toLocaleDateString('fr-FR', {
        day: '2-digit', month: '2-digit',
      });

      for (const entry of lineup.players) {
        if (!entry.playerId) continue;

        const player = await Player.findByPk(entry.playerId, {
          include: [{ model: User, as: 'user', attributes: ['fcmToken'] }],
        });
        if (!player) continue;

        // Primary: token via linked user account (Player.userId → User.fcmToken)
        let token = player.user?.fcmToken;

        // Fallback: player was admin-created with an email but Player.userId is null
        // → look up the User by matching email
        if (!token && player.email) {
          const userByEmail = await User.findOne({
            where: { email: player.email },
            attributes: ['fcmToken'],
          });
          token = userByEmail?.fcmToken;
        }

        if (!token) continue;

        const isStarter = entry.isStarter !== false;
        const title = isStarter
          ? '🟢 Vous êtes titulaire !'
          : '🟡 Vous êtes remplaçant';
        const body = isStarter
          ? `Composition publiée vs ${opponent} (${matchDate}) — ${lineup.formation}`
          : `Vous êtes sur le banc vs ${opponent} (${matchDate})`;

        await notificationService.sendToToken(token, title, body, {
          type: 'lineup_published',
          matchId: String(match.id),
          isStarter: String(isStarter),
        });
      }
    } catch (notifErr) {
      console.warn('[FCM] publishLineup notify error:', notifErr.message);
    }
  } catch (err) {
    console.error('publishLineup error:', err);
    res.status(500).json({ message: 'Erreur serveur' });
  }
};

// ── GET /players/me/lineup/:matchId ──────────────────────────────────────────
// Player sees their team's published lineup for a match
const getPlayerLineup = async (req, res) => {
  try {
    const playerRecord = await require('../models').Player.findOne({
      where: { userId: req.user.id },
    });
    if (!playerRecord || !playerRecord.teamId) {
      return res.status(404).json({ message: 'Joueur introuvable' });
    }

    const lineup = await MatchLineup.findOne({
      where: {
        matchId: req.params.matchId,
        teamId: playerRecord.teamId,
        status: 'published',
      },
    });

    if (!lineup) return res.status(404).json({ message: 'Composition non encore publiée' });

    const match = await _getMatch(req.params.matchId, playerRecord.teamId);
    const isHome = match && Number(match.homeTeamId) === Number(playerRecord.teamId);
    const opponent = match ? (isHome ? match.awayTeam?.name : match.homeTeam?.name) : '?';

    res.json({
      formation: lineup.formation,
      players: lineup.players,
      match: {
        id: match?.id,
        date: match?.date,
        opponent,
      },
    });
  } catch (err) {
    console.error('getPlayerLineup error:', err);
    res.status(500).json({ message: 'Erreur serveur' });
  }
};

module.exports = { getLineup, saveLineup, publishLineup, getPlayerLineup };
