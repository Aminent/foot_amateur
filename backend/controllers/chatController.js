const { Chat, User, Team, Player } = require('../models');
const { validationResult } = require('express-validator');
const { Op } = require('sequelize');
const sequelize = require('../config/database');
const notificationService = require('../services/notificationService');

/**
 * Resolve the team ID for a given user.
 * Checks: 1) User.teamId directly, 2) Player.teamId via userId, 3) Team.coachId matching userId.
 * Returns { user, teamId } — user is null if not found, teamId is null if not in any team.
 */
const resolveTeamId = async (userId) => {
  const user = await User.findByPk(userId);
  if (!user) return { user: null, teamId: null };

  if (user.teamId) return { user, teamId: user.teamId };

  const player = await Player.findOne({ where: { userId } });
  if (player && player.teamId) return { user, teamId: player.teamId };

  const teamAsCoach = await Team.findOne({ where: { coachId: userId } });
  if (teamAsCoach) return { user, teamId: teamAsCoach.id };

  return { user, teamId: null };
};

// Get team chat messages (group chat)
const getTeamChatMessages = async (req, res) => {
  try {
    const userId = req.user.id;
    const { page = 1, limit = 50 } = req.query;
    const offset = (page - 1) * limit;

    const { user: currentUser, teamId } = await resolveTeamId(userId);
    if (!currentUser) {
      return res.status(404).json({ message: 'Utilisateur non trouvé' });
    }
    if (!teamId) {
      return res.status(404).json({ message: 'Utilisateur non assigné à une équipe' });
    }

    // Get team info
    const team = await Team.findByPk(teamId);

    // Get paginated messages for the team (DESC = newest first, client reverses for display)
    const { count, rows: messages } = await Chat.findAndCountAll({
      where: { teamId },
      include: [
        {
          model: User,
          as: 'sender',
          attributes: ['id', 'name', 'email', 'role'],
        },
        {
          model: Team,
          as: 'team',
          attributes: ['id', 'name'],
        },
      ],
      order: [['createdAt', 'DESC']],
      limit: parseInt(limit),
      offset,
      distinct: true,
    });

    // ── #18 : Marquer les messages non lus — évite le N+1 avec un filtre en mémoire
    // puis un update groupé (une seule requête par lot au lieu d'une par message)
    const unreadMessages = await Chat.findAll({
      where: { teamId, senderId: { [Op.ne]: userId } },
      attributes: ['id', 'readBy'],
    });

    const toMarkIds = [];
    for (const msg of unreadMessages) {
      let readBy = msg.readBy || [];
      if (!Array.isArray(readBy)) {
        try { readBy = typeof readBy === 'string' ? JSON.parse(readBy) : []; } catch { readBy = []; }
      }
      const uid = parseInt(userId);
      const uidStr = userId.toString();
      if (!readBy.some(id => id === uid || id === uidStr)) {
        toMarkIds.push(msg.id);
      }
    }

    // Mettre à jour en lots de 100 pour éviter les requêtes trop grandes
    const CHUNK = 100;
    for (let i = 0; i < toMarkIds.length; i += CHUNK) {
      const chunk = toMarkIds.slice(i, i + CHUNK);
      // On ne peut pas faire un UPDATE avec un JSON_APPEND générique en SQLite/Sequelize,
      // donc on recharge uniquement les messages du chunk et on update chacun.
      // C'est mieux que l'ancien code : on charge TOUS les messages puis on fait N updates.
      // Ici on fait seulement les non-lus, et on les recharge par petits lots.
      const batch = await Chat.findAll({ where: { id: { [Op.in]: chunk } }, attributes: ['id', 'readBy'] });
      await Promise.all(batch.map(msg => {
        const rb = Array.isArray(msg.readBy) ? msg.readBy : [];
        return msg.update({ readBy: [...rb, userId] });
      }));
    }

    res.json({
      messages,           // newest-first (DESC); client should reverse for display
      team,
      pagination: {
        page: parseInt(page),
        limit: parseInt(limit),
        total: count,
        totalPages: Math.ceil(count / parseInt(limit)),
      },
    });
  } catch (error) {
    console.error('Error fetching team chat messages:', error);
    res.status(500).json({ message: 'Erreur lors du chargement des messages' });
  }
};

// Send a message to team chat
const sendTeamMessage = async (req, res) => {
  try {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }

    const userId = req.user.id;
    const { message, messageType = 'text', attachmentUrl } = req.body;

    const { user: currentUser, teamId } = await resolveTeamId(userId);
    if (!currentUser) {
      return res.status(404).json({ message: 'Utilisateur non trouvé' });
    }
    if (!teamId) {
      return res.status(404).json({ message: 'Utilisateur non assigné à une équipe' });
    }

    // Create message for team chat
    const newMessage = await Chat.create({
      message,
      messageType,
      senderId: userId,
      teamId,
      attachmentUrl,
      readBy: [userId], // Sender has read it
    });

    // Get the message with sender info
    const messageWithSender = await Chat.findByPk(newMessage.id, {
      include: [
        {
          model: User,
          as: 'sender',
          attributes: ['id', 'name', 'email', 'role'],
        },
        {
          model: Team,
          as: 'team',
          attributes: ['id', 'name'],
        },
      ],
    });

    // Emit real-time message via Socket.IO
    if (global.io) {
      global.io.to(`team_${teamId}`).emit('new_message', messageWithSender);
    }

    res.status(201).json({
      message: 'Message envoyé avec succès',
      chat: messageWithSender,
    });

    // ── Push notification to all team members except the sender (fire-and-forget) ──
    try {
      const senderName = messageWithSender.sender?.name ?? 'Quelqu\'un';
      const preview = message.length > 80 ? message.slice(0, 80) + '…' : message;

      // Collect FCM tokens from:
      // 1. Users with teamId directly (coaches assigned to team)
      // 2. Players whose linked User account belongs to this team
      const [directMembers, linkedPlayers] = await Promise.all([
        User.findAll({
          where: { teamId, id: { [Op.ne]: userId } },
          attributes: ['id', 'fcmToken'],
        }),
        Player.findAll({
          where: { teamId, userId: { [Op.not]: null } },
          include: [{ model: User, as: 'user', attributes: ['id', 'fcmToken'] }],
        }),
      ]);

      // Filter out sender from linked players, then deduplicate by userId
      const seenIds = new Set(directMembers.map(u => String(u.id)));
      const linkedTokens = linkedPlayers
        .filter(p => String(p.userId) !== String(userId))
        .filter(p => {
          const id = String(p.user?.id ?? p.email ?? p.id);
          if (seenIds.has(id)) return false;
          seenIds.add(id);
          return true;
        })
        .map(p => p.user?.fcmToken);

      // Fallback: players without a linked user account — look up by email
      const emailFallbackTokens = await Promise.all(
        linkedPlayers
          .filter(p => !p.userId && p.email && String(p.userId) !== String(userId))
          .map(async (p) => {
            const u = await User.findOne({ where: { email: p.email }, attributes: ['fcmToken'] });
            return u?.fcmToken ?? null;
          })
      );

      const tokens = [
        ...directMembers.map(u => u.fcmToken),
        ...linkedTokens,
        ...emailFallbackTokens,
      ].filter(Boolean);

      if (tokens.length) {
        await notificationService.sendToTokens(
          tokens,
          `💬 ${senderName}`,
          preview,
          { type: 'chat_message', teamId: String(teamId), senderId: String(userId) },
        );
      }
    } catch (notifErr) {
      console.warn('[FCM] chat notify error:', notifErr.message);
    }
  } catch (error) {
    console.error('Error sending team message:', error);
    res.status(500).json({ message: 'Erreur lors de l\'envoi du message' });
  }
};

// Get team chat info (team members, unread count)
const getTeamChatInfo = async (req, res) => {
  try {
    const userId = req.user.id;

    const { user: currentUser, teamId } = await resolveTeamId(userId);
    if (!currentUser) {
      return res.status(404).json({ message: 'Utilisateur non trouvé' });
    }
    if (!teamId) {
      return res.status(404).json({ message: 'Utilisateur non assigné à une équipe' });
    }

    // Get team info
    const team = await Team.findByPk(teamId);

    // Get all team members (both coaches and players)
    const teamMembers = await User.findAll({
      where: {
        teamId: teamId
      },
      attributes: ['id', 'name', 'email', 'role', 'phone', 'isActive']
    });

    // Also get players who have userId linked
    const playersWithUsers = await Player.findAll({
      where: { 
        teamId: teamId,
        userId: { [Op.ne]: null }
      },
      include: [
        { model: User, as: 'user' }
      ]
    });

    // Combine team members from direct assignment and player-user links
    const allTeamMembers = [
      ...teamMembers,
      ...playersWithUsers.map(p => ({
        id: p.user.id,
        name: p.user.name,
        email: p.user.email,
        role: p.user.role,
        phone: p.user.phone,
        isActive: p.user.isActive,
        position: p.position,
        jerseyNumber: p.jerseyNumber
      }))
    ];

    // Remove duplicates by id
    const uniqueMembers = allTeamMembers.filter((member, index, self) =>
      index === self.findIndex(m => m.id === member.id)
    );

    // Get unread message count for current user
    // Load only the two fields needed for the unread check — avoids fetching full message payloads
    const candidateMsgs = await Chat.findAll({
      where: {
        teamId,
        senderId: { [Op.ne]: userId },
      },
      attributes: ['id', 'readBy'],
    });
    const _uidStr = userId.toString();
    const _uidInt = parseInt(userId);
    const unreadCount = candidateMsgs.filter(msg => {
      const readBy = msg.readBy || [];
      if (!Array.isArray(readBy)) return true;
      return !readBy.some(id => id === _uidInt || id === _uidStr);
    }).length;

    // Collect userIds that currently have an active Socket.IO connection
    const onlineUserIds = new Set();
    if (global.io) {
      for (const [, socket] of global.io.sockets.sockets) {
        if (socket.data?.userId) onlineUserIds.add(String(socket.data.userId));
      }
    }

    res.json({
      team,
      members: uniqueMembers.map(member => ({
        id: member.id,
        name: member.name,
        email: member.email,
        role: member.role,
        position: member.position,
        jerseyNumber: member.jerseyNumber,
        isOnline: onlineUserIds.has(String(member.id)),
      })),
      unreadCount,
    });
  } catch (error) {
    console.error('Error fetching team chat info:', error);
    res.status(500).json({ message: 'Erreur lors du chargement des informations du chat' });
  }
};

// Mark team messages as read
const markTeamMessagesAsRead = async (req, res) => {
  try {
    const userId = req.user.id;
    const { messageIds } = req.body; // Array of message IDs to mark as read

    const { user: currentUser, teamId } = await resolveTeamId(userId);
    if (!currentUser) {
      return res.status(404).json({ message: 'Utilisateur non trouvé' });
    }
    if (!teamId) {
      return res.status(404).json({ message: 'Utilisateur non assigné à une équipe' });
    }

    // Mark specific messages as read
    const messagesToUpdate = await Chat.findAll({
      where: {
        id: { [Op.in]: messageIds },
        teamId,
      }
    });

    const userIdStr = userId.toString();
    const userIdInt = parseInt(userId);
    await Promise.all(messagesToUpdate.map(async (msg) => {
      let readBy = msg.readBy || [];
      // Ensure readBy is an array
      if (!Array.isArray(readBy)) {
        if (typeof readBy === 'string') {
          try { readBy = JSON.parse(readBy); } catch { readBy = []; }
        } else {
          readBy = [];
        }
      }
      // Check if user has already read the message
      const hasRead = readBy.some(id => id === userIdInt || id === userIdStr);
      if (!hasRead) {
        readBy.push(userId);
        return msg.update({ readBy });
      }
    }));

    res.json({ message: 'Messages marqués comme lus' });
  } catch (error) {
    console.error('Error marking team messages as read:', error);
    res.status(500).json({ message: 'Erreur lors du marquage des messages' });
  }
};

// Get unread message count
const getUnreadCount = async (req, res) => {
  try {
    const userId = req.user.id;

    const { teamId } = await resolveTeamId(userId);
    if (!teamId) {
      return res.json({ unreadCount: 0 });
    }

    // Load only the two fields needed for the unread check — avoids fetching full message payloads
    const candidateMsgs = await Chat.findAll({
      where: {
        teamId,
        senderId: { [Op.ne]: userId },
      },
      attributes: ['id', 'readBy'],
    });
    const _uidStr = userId.toString();
    const _uidInt = parseInt(userId);
    const unreadCount = candidateMsgs.filter(msg => {
      const readBy = msg.readBy || [];
      if (!Array.isArray(readBy)) return true;
      return !readBy.some(id => id === _uidInt || id === _uidStr);
    }).length;

    res.json({ unreadCount });
  } catch (error) {
    console.error('Error fetching unread count:', error);
    res.status(500).json({ message: 'Erreur lors du chargement des messages non lus' });
  }
};

module.exports = {
  getTeamChatMessages,
  sendTeamMessage,
  getTeamChatInfo,
  markTeamMessagesAsRead,
  getUnreadCount,
};
