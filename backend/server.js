require('dotenv').config();
const notificationService = require('./services/notificationService');
notificationService.init();
const express = require('express');
const cors = require('cors');
const path = require('path');
const http = require('http');
const jwt = require('jsonwebtoken');
const { Server } = require('socket.io');
const sequelize = require('./config/database');

const app = express();
const server = http.createServer(app);
// ── CORS origin checker — accepte localhost, LAN et tous les tunnels ngrok ──
const isAllowedOrigin = (origin) => {
  if (!origin) return true; // same-origin / mobile app
  const fixed = [
    'http://localhost:3000',
    'http://localhost:3001',
    'http://localhost:3002',
    'http://localhost:5000',
    'http://192.168.1.10:3000',
    'http://192.168.1.10:5000',
    'capacitor://localhost',
    'http://localhost',
    'http://105.155.250.204:3000',
    'http://105.155.250.204:5000',
    process.env.FRONTEND_URL,
  ].filter(Boolean);
  if (fixed.includes(origin)) return true;
  // Accepte tout domaine ngrok (*.ngrok-free.app, *.ngrok-free.dev, *.ngrok.io, *.ngrok.app)
  if (/\.ngrok(-free)?\.(app|dev|io)$/.test(new URL(origin).hostname)) return true;
  return false;
};

const corsOptions = {
  origin: (origin, cb) => cb(null, isAllowedOrigin(origin)),
  credentials: true,
};

const io = new Server(server, {
  cors: { ...corsOptions, methods: ['GET', 'POST'] }
});

// Middleware
app.use(cors(corsOptions));
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Serve static files from uploads directory
app.use('/uploads', express.static(path.join(__dirname, 'uploads')));

// Import routes
/** @type {import('express').Router} */
const authRoutes = require('./routes/auth');
const tournamentRoutes = require('./routes/tournaments');
const tournamentApplicationRoutes = require('./routes/tournamentApplications');
const { 
  getPlayerOverview,
  // Player-specific routes for mobile app
  getMyPlayerProfile,
  getMyStats,
  getMyTeam,
  getMyMatches,
  getMyTournaments,
  getMyTrainingSessions,
  updateMyProfile
} = require('./controllers/playerController');
const { 
  getMyRewards,
  awardBadge,
  awardReward,
  getBadgeTypes
} = require('./controllers/rewardController');
const teamRoutes = require('./routes/teams');
const playerRoutes = require('./routes/players');
const playerRoutesMobile = require('./routes/playerRoutes');
const coachRoutes = require('./routes/coaches');
const uploadRoutes = require('./routes/uploads');
const matchRoutes = require('./routes/matches');
const playerStatsRoutes = require('./routes/playerStats');
const chatRoutes = require('./routes/chatRoutes');
const rewardRoutes = require('./routes/rewardRoutes');
const scoutRoutes = require('./routes/scout');
const refereeRoutes = require('./routes/referee');

// Use routes
app.use('/api/auth', authRoutes);
app.use('/api/tournaments', tournamentRoutes);
app.use('/api/tournament-applications', tournamentApplicationRoutes);
app.use('/api/teams', teamRoutes);
// Mobile routes must be mounted before generic /:id routes to avoid shadowing
app.use('/api/players', playerRoutesMobile);
app.use('/api/players', playerRoutes);
app.use('/api/coaches', coachRoutes);
app.use('/api/uploads', uploadRoutes);
app.use('/api/matches', matchRoutes);
app.use('/api/player-stats', playerStatsRoutes);
app.use('/api/chat', chatRoutes);
app.use('/api/rewards', rewardRoutes);
app.use('/api/scouts', scoutRoutes);
app.use('/api/referee', refereeRoutes);

// Base API route
app.get('/api', (req, res) => {
  res.json({
    message: 'Football Amateur API',
    version: '1.0.0',
    endpoints: {
      auth: '/api/auth',
      tournaments: '/api/tournaments',
      tournamentApplications: '/api/tournament-applications',
      teams: '/api/teams',
      players: '/api/players',
      coaches: '/api/coaches',
      matches: '/api/matches',
      playerStats: '/api/player-stats',
      uploads: '/api/uploads'
    },
    status: 'running'
  });
});

// ── Serve Scouting build under /scout ───────────────────────────────────────
const scoutingBuild = path.join(__dirname, '../scouting/build');
if (require('fs').existsSync(scoutingBuild)) {
  app.use('/scout', express.static(scoutingBuild));
  app.get(/^\/scout(\/.*)?$/, (req, res) => {
    res.sendFile(path.join(scoutingBuild, 'index.html'));
  });
  console.log('✅ Serving Scouting frontend from /scouting/build at /scout');
}

// ── Serve React build (admin frontend) ──────────────────────────────────────
const frontendBuild = path.join(__dirname, '../frontend/build');
if (require('fs').existsSync(frontendBuild)) {
  app.use(express.static(frontendBuild));
  // All non-API routes → React index.html (client-side routing)
  app.get(/^(?!\/api|\/uploads|\/scout).*/, (req, res) => {
    res.sendFile(path.join(frontendBuild, 'index.html'));
  });
  console.log('✅ Serving React frontend from /frontend/build');
}

// ── #13 : Middleware d'erreur global — retourne du JSON ──────────────────────
app.use((err, req, res, next) => {
  console.error('[Server Error]', err.stack);
  res.status(err.status || 500).json({
    message: err.message || 'Erreur interne du serveur',
    ...(process.env.NODE_ENV === 'development' ? { stack: err.stack } : {}),
  });
});

// Start server function
const startServer = async () => {
  try {
    await sequelize.authenticate();
    // Force sync in development only
    if (process.env.NODE_ENV === 'development') {
      await sequelize.sync({ alter: true });
    } else {
      await sequelize.sync();
    }
    console.log('✅ Database synchronized successfully');
    // ── #11 : Premier lancement avec fenêtre élargie (rattrapage redémarrage) ─
    send24hMatchReminders(2);

    const PORT = process.env.PORT || 5000;
    server.listen(PORT, () => {
      console.log(`✅ Server is running on port ${PORT}`);
    });
  } catch (error) {
    console.error('❌ Error starting server:', error);
    process.exit(1);
  }
};

// Start the server
startServer();

// ── Socket.IO models (needed by socket handlers below) ──────────────────────
const { Op } = require('sequelize');
const { Match, Team, Player, User, Tournament } = require('./models');

// ── Socket.IO JWT authentication middleware ──────────────────────────────────
io.use((socket, next) => {
  const token = socket.handshake.auth?.token;
  if (!token) {
    return next(new Error('AUTH_REQUIRED'));
  }
  try {
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    socket.data.userId = decoded.userId;
    next();
  } catch {
    next(new Error('AUTH_INVALID'));
  }
});

// ── Socket.IO connection handling ────────────────────────────────────────────
io.on('connection', async (socket) => {
  const userId = socket.data.userId;

  // Auto-join admins to the 'admins' room for broadcast notifications
  try {
    const adminUser = await User.findOne({ where: { id: userId, role: 'admin' }, attributes: ['id'] });
    if (adminUser) socket.join('admins');
  } catch (_) {}

  // join-tournament: verify the tournament exists; admin/coach/player can all
  // watch bracket updates — no strict membership needed (brackets are not secret)
  socket.on('join-tournament', async (tournamentId) => {
    try {
      const id = parseInt(tournamentId);
      if (!id) return;

      const tournament = await Tournament.findByPk(id, { attributes: ['id'] });
      if (!tournament) return;

      socket.join(`tournament-${id}`);
    } catch (err) {
      console.error('[Socket] join-tournament error:', err.message);
    }
  });

  // join-team: user must be a player on the team OR its coach
  socket.on('join-team', async (teamId) => {
    try {
      const id = parseInt(teamId);
      if (!id) return;

      const [isMember, isCoach] = await Promise.all([
        Player.findOne({ where: { teamId: id, userId }, attributes: ['id'] }),
        Team.findOne({ where: { id, coachId: userId }, attributes: ['id'] }),
      ]);

      if (!isMember && !isCoach) {
        // Check if admin (admins can monitor any room)
        const adminUser = await User.findOne({
          where: { id: userId, role: 'admin' },
          attributes: ['id'],
        });
        if (!adminUser) return; // silently refuse — no error sent to client
      }

      socket.join(`team_${id}`);
    } catch (err) {
      console.error('[Socket] join-team error:', err.message);
    }
  });

  // join-match: any authenticated user can watch a match live
  socket.on('join-match', async (matchId) => {
    try {
      const id = parseInt(matchId);
      if (!id) return;
      const match = await Match.findByPk(id, { attributes: ['id'] });
      if (!match) return;
      socket.join(`match_${id}`);
    } catch (err) {
      console.error('[Socket] join-match error:', err.message);
    }
  });

  socket.on('disconnect', () => {
    // no-op — socket.io handles room cleanup automatically
  });
});

// Make io available globally for emitting events
global.io = io;

// ── 24h match reminder scheduler (runs every hour) ──────────────────────────
// ── #11 : La fenêtre est élargie au démarrage pour rattraper les rappels ─────
// manqués si le serveur était arrêté pendant la fenêtre [+23h, +25h].
// windowHours = 1  → exécution normale (horaire)
// windowHours = 2  → premier lancement après redémarrage (rattrapage ±1h)

async function send24hMatchReminders(windowHours = 1) {
  try {
    const now = new Date();
    const in23h = new Date(now.getTime() + (23 - windowHours) * 60 * 60 * 1000);
    const in25h = new Date(now.getTime() + (25 + windowHours) * 60 * 60 * 1000);

    const upcoming = await Match.findAll({
      where: {
        status: 'scheduled',
        date: { [Op.between]: [in23h, in25h] },
        reminderSent: { [Op.ne]: true },
      },
      include: [
        {
          model: Team,
          as: 'homeTeam',
          include: [{ model: Player, as: 'players', include: [{ model: User, as: 'user', attributes: ['fcmToken'] }] }],
        },
        {
          model: Team,
          as: 'awayTeam',
          include: [{ model: Player, as: 'players', include: [{ model: User, as: 'user', attributes: ['fcmToken'] }] }],
        },
      ],
    });

    for (const match of upcoming) {
      const dateStr = new Date(match.date).toLocaleString('fr-FR', { day: '2-digit', month: '2-digit', hour: '2-digit', minute: '2-digit' });
      const collectTokens = (team) =>
        (team?.players || []).map(p => p.user?.fcmToken).filter(Boolean);

      const homeTokens = collectTokens(match.homeTeam);
      const awayTokens = collectTokens(match.awayTeam);
      const allTokens = [...homeTokens, ...awayTokens];

      if (allTokens.length) {
        const title = '⚽ Match dans 24h !';
        const body = `${match.homeTeam?.name ?? '?'} vs ${match.awayTeam?.name ?? '?'} — ${dateStr}${match.location ? ' @ ' + match.location : ''}`;
        await notificationService.sendToTokens(allTokens, title, body, { matchId: String(match.id), type: 'match_reminder' });
        // Mark as sent to avoid duplicates
        try { await match.update({ reminderSent: true }); } catch (_) {}
      }
    }
  } catch (err) {
    console.error('[Scheduler] 24h reminder error:', err.message);
  }
}

// Premier lancement : fenêtre élargie (±1h) pour rattraper les rappels manqués
// pendant un éventuel arrêt serveur. Exécutions suivantes : fenêtre normale.
// (Le premier appel vient de startServer() après le sync DB)
setInterval(() => send24hMatchReminders(1), 60 * 60 * 1000);

// ── Match-starting-soon notifier (runs every minute) ────────────────────────
// ── #12 : notifSoonSent persisté en base → survit aux redémarrages ───────────
// L'ancien Set en mémoire est remplacé par le flag `notifSoonSent` sur Match.

async function notifyUpcomingMatches() {
  try {
    const now  = new Date();
    const in15 = new Date(now.getTime() + 15 * 60 * 1000);
    const in1  = new Date(now.getTime() +  1 * 60 * 1000);

    const upcoming = await Match.findAll({
      where: {
        status: 'scheduled',
        date: { [Op.between]: [in1, in15] },
        notifSoonSent: false, // ← filtre en base, pas de Set en mémoire
      },
      include: [
        { model: Team, as: 'homeTeam', attributes: ['id', 'name'] },
        { model: Team, as: 'awayTeam', attributes: ['id', 'name'] },
      ],
    });

    for (const match of upcoming) {
      const minutesLeft = Math.round((new Date(match.date) - now) / 60000);
      const payload = {
        matchId:   match.id,
        homeTeam:  match.homeTeam?.name || '?',
        awayTeam:  match.awayTeam?.name || '?',
        date:      match.date,
        location:  match.location || null,
        minutesLeft,
      };

      io.to('admins').emit('match-starting-soon', payload);
      // Marquer en base → persistant après redémarrage
      try { await match.update({ notifSoonSent: true }); } catch (_) {}
      console.log(`[Notif] Match soon: ${payload.homeTeam} vs ${payload.awayTeam} in ${minutesLeft}min`);
    }
  } catch (err) {
    console.error('[Notif] upcoming match check error:', err.message);
  }
}

setInterval(notifyUpcomingMatches, 60 * 1000);

// ── Matchs périmés : scheduled mais date dépassée > 2h (runs every 30 min) ──
// Ne modifie pas le statut automatiquement — notifie l'admin pour qu'il agisse.
async function checkOverdueMatches() {
  try {
    const threshold = new Date(Date.now() - 2 * 60 * 60 * 1000); // now - 2h

    const overdue = await Match.findAll({
      where: {
        status: 'scheduled',
        date: { [Op.lt]: threshold },
      },
      include: [
        { model: Team, as: 'homeTeam', attributes: ['id', 'name'] },
        { model: Team, as: 'awayTeam', attributes: ['id', 'name'] },
      ],
    });

    if (overdue.length === 0) return;

    const payload = overdue.map(m => ({
      matchId:  m.id,
      homeTeam: m.homeTeam?.name || '?',
      awayTeam: m.awayTeam?.name || '?',
      date:     m.date,
      location: m.location || null,
      hoursAgo: Math.round((Date.now() - new Date(m.date)) / 3600000),
    }));

    io.to('admins').emit('matches-overdue', payload);
    console.log(`[Notif] ${overdue.length} match(s) périmé(s) sans résultat :`,
      payload.map(p => `${p.homeTeam} vs ${p.awayTeam}`).join(', '));
  } catch (err) {
    console.error('[Notif] checkOverdueMatches error:', err.message);
  }
}

// Premier contrôle au démarrage, puis toutes les 30 min
checkOverdueMatches();
setInterval(checkOverdueMatches, 30 * 60 * 1000);

module.exports = app;
