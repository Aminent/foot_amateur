import React, { useEffect, useState, useRef, useCallback } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import {
  Box, Typography, Card, CardContent, Button, Chip, IconButton,
  Dialog, DialogTitle, DialogContent, DialogActions,
  TextField, MenuItem, Grid, CircularProgress, Alert,
  Avatar, Tooltip, Autocomplete, LinearProgress,
} from '@mui/material';
import ArrowBackIcon          from '@mui/icons-material/ArrowBack';
import SportsSoccerIcon       from '@mui/icons-material/SportsSoccer';
import DeleteIcon             from '@mui/icons-material/Delete';
import FiberManualRecordIcon  from '@mui/icons-material/FiberManualRecord';
import TimerIcon              from '@mui/icons-material/Timer';
import PauseCircleIcon        from '@mui/icons-material/PauseCircle';
import PlayCircleIcon         from '@mui/icons-material/PlayCircle';
import AddIcon                from '@mui/icons-material/Add';
import { io } from 'socket.io-client';
import { API, BASE, authHeaders } from '../utils/api';

// ── Constants ────────────────────────────────────────────────────────────────

const HALF_DURATION   = 45 * 60; // 45 min en secondes
const BREAK_DURATION  = 15 * 60; // 15 min de pause
const MATCH_DURATION  = 90 * 60; // 90 min total

const EVENT_TYPES = [
  { value: 'goal',         label: '⚽ But',             color: '#16a34a' },
  { value: 'assist',       label: '🅰️ Passe décisive',   color: '#0284c7' },
  { value: 'penalty_goal', label: '🎯 But sur penalty',  color: '#15803d' },
  { value: 'own_goal',     label: '⚽ CSC',              color: '#dc2626' },
  { value: 'yellow_card',  label: '🟨 Carton jaune',     color: '#ca8a04' },
  { value: 'red_card',     label: '🟥 Carton rouge',      color: '#dc2626' },
  { value: 'substitution', label: '🔄 Remplacement',      color: '#7c3aed' },
  { value: 'injury',       label: '🚑 Blessure',          color: '#ea580c' },
];

const STATUS_LABELS = {
  scheduled:   { label: 'Planifié',      color: '#3b82f6' },
  in_progress: { label: '🔴 En direct',  color: '#16a34a' },
  half_time:   { label: '⏸ Mi-temps',   color: '#ca8a04' },
  completed:   { label: '✅ Terminé',    color: '#64748b' },
  postponed:   { label: 'Reporté',       color: '#8b5cf6' },
  cancelled:   { label: 'Annulé',        color: '#ef4444' },
};

const EVENT_ICON = {
  goal: '⚽', penalty_goal: '🎯', own_goal: '⚽',
  yellow_card: '🟨', red_card: '🟥', substitution: '🔄', injury: '🚑',
};

const NEEDS_PLAYER = ['goal', 'penalty_goal', 'yellow_card', 'red_card', 'assist'];

// ── Phase helpers (persistées en localStorage) ───────────────────────────────

const phaseKey       = (id) => `lm_phase_${id}`;
const startKey       = (id) => `lm_start_${id}`;
const halfKey        = (id) => `lm_half_${id}`;
const secondKey      = (id) => `lm_second_${id}`;

const savePhase = (id, phase) => localStorage.setItem(phaseKey(id), phase);
const loadPhase = (id) => localStorage.getItem(phaseKey(id)) || 'first_half';

const saveTs = (key, ts) => localStorage.setItem(key, String(ts));
const loadTs = (key) => { const v = localStorage.getItem(key); return v ? parseInt(v) : null; };

// ── Timer computation ─────────────────────────────────────────────────────────
// Returns { minutes, seconds, extra, isExtra, phase }
const computeTimer = (phase, startAt, halfAt, secondAt) => {
  const now = Date.now();

  if (phase === 'first_half') {
    if (!startAt) return null;
    const elapsed = Math.floor((now - startAt) / 1000);
    if (elapsed < HALF_DURATION) {
      return { minutes: Math.floor(elapsed / 60), seconds: elapsed % 60, extra: 0, isExtra: false, phase };
    }
    const extra = Math.floor((elapsed - HALF_DURATION) / 60);
    return { minutes: 45, seconds: 0, extra, isExtra: true, phase };
  }

  if (phase === 'half_time') {
    if (!halfAt) return null;
    const remaining = Math.max(0, BREAK_DURATION - Math.floor((now - halfAt) / 1000));
    return { remaining, breakDone: remaining === 0, phase };
  }

  if (phase === 'second_half') {
    if (!secondAt) return null;
    const elapsed = HALF_DURATION + Math.floor((now - secondAt) / 1000);
    if (elapsed < MATCH_DURATION) {
      return { minutes: Math.floor(elapsed / 60), seconds: elapsed % 60, extra: 0, isExtra: false, phase };
    }
    const extra = Math.floor((elapsed - MATCH_DURATION) / 60);
    return { minutes: 90, seconds: 0, extra, isExtra: true, phase };
  }

  return null;
};

// ── Component ─────────────────────────────────────────────────────────────────

export default function LiveMatch() {
  const { id } = useParams();
  const navigate = useNavigate();

  const [match, setMatch]     = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError]     = useState('');

  // Phase state
  const [phase, setPhaseState]   = useState(() => loadPhase(id));
  const [startAt, setStartAt]    = useState(() => loadTs(startKey(id)));
  const [halfAt, setHalfAt]      = useState(() => loadTs(halfKey(id)));
  const [secondAt, setSecondAt]  = useState(() => loadTs(secondKey(id)));
  const [timerTick, setTimerTick] = useState(0); // force re-render

  // Dialog state
  const [dialogOpen, setDialogOpen]     = useState(false);
  const [selectedTeam, setSelectedTeam] = useState('home');
  const [eventType, setEventType]       = useState('goal');
  const [minute, setMinute]             = useState('');
  const [selectedPlayer, setSelectedPlayer]   = useState(null);
  const [playerInputName, setPlayerInputName] = useState('');
  const [selectedSubIn, setSelectedSubIn]     = useState(null);
  const [subInInputName, setSubInInputName]   = useState('');
  const [submitting, setSubmitting] = useState(false);
  const [toast, setToast] = useState({ msg: '', err: false });

  const socketRef  = useRef(null);
  const timerRef   = useRef(null);

  // ── Fetch ──────────────────────────────────────────────────────────────────
  const fetchMatch = useCallback(async () => {
    try {
      const r = await fetch(`${API}/matches/${id}`, { headers: authHeaders() });
      const d = await r.json();
      setMatch(d.match);
    } catch {
      setError('Impossible de charger le match');
    } finally {
      setLoading(false);
    }
  }, [id]);

  useEffect(() => { fetchMatch(); }, [fetchMatch]);

  // ── Socket.IO ──────────────────────────────────────────────────────────────
  useEffect(() => {
    const token = localStorage.getItem('token');
    const socket = io(BASE, { auth: { token } });
    socketRef.current = socket;
    socket.emit('join-match', id);
    socket.on('live-update', ({ match: updated }) => { if (updated) setMatch(updated); });
    return () => socket.disconnect();
  }, [id]);

  // ── Tick timer every second ───────────────────────────────────────────────
  useEffect(() => {
    const running = match?.status === 'in_progress' || match?.status === 'half_time';
    if (!running) { clearInterval(timerRef.current); return; }
    timerRef.current = setInterval(() => setTimerTick(t => t + 1), 1000);
    return () => clearInterval(timerRef.current);
  }, [match?.status]);

  // ── Phase transitions ─────────────────────────────────────────────────────
  const setPhase = (p) => { setPhaseState(p); savePhase(id, p); };

  const changeStatus = async (newStatus, opts = {}) => {
    try {
      const body = { status: newStatus, ...opts };
      const r = await fetch(`${API}/matches/${id}`, {
        method: 'PUT', headers: authHeaders(), body: JSON.stringify(body),
      });
      const d = await r.json();
      if (!r.ok) throw new Error(d.message);
      setMatch(d.match);
      showToast(`Statut : ${STATUS_LABELS[newStatus]?.label || newStatus}`);
    } catch (e) { showToast(e.message, true); }
  };

  const handleStart = async () => {
    const ts = Date.now();
    setStartAt(ts); saveTs(startKey(id), ts);
    setPhase('first_half');
    await changeStatus('in_progress');
  };

  const handleHalfTime = async () => {
    const ts = Date.now();
    setHalfAt(ts); saveTs(halfKey(id), ts);
    setPhase('half_time');
    // Calculer le score mi-temps
    await changeStatus('half_time', {
      halfTimeHomeScore: match.homeTeamScore,
      halfTimeAwayScore: match.awayTeamScore,
    });
  };

  const handleSecondHalf = async () => {
    const ts = Date.now();
    setSecondAt(ts); saveTs(secondKey(id), ts);
    setPhase('second_half');
    await changeStatus('in_progress');
  };

  const handleEnd = async () => {
    await changeStatus('completed');
    // Nettoyer localStorage
    [phaseKey, startKey, halfKey, secondKey].forEach(fn => localStorage.removeItem(fn(id)));
  };

  // ── Current timer value ───────────────────────────────────────────────────
  // eslint-disable-next-line react-hooks/exhaustive-deps
  const timer = (() => {
    if (!match || match.status === 'completed' || match.status === 'scheduled') return null;
    if (match.status === 'half_time') return computeTimer('half_time', startAt, halfAt, secondAt);
    return computeTimer(phase, startAt, halfAt, secondAt);
  })();
  // Force evaluation every tick
  // eslint-disable-next-line no-unused-expressions
  timerTick;

  // ── Current minute for auto-fill ─────────────────────────────────────────
  const currentMatchMinute = () => {
    if (!timer || timer.phase === 'half_time') return '';
    return String(timer.minutes + (timer.isExtra ? timer.extra : 0));
  };

  // ── Event submission ──────────────────────────────────────────────────────
  const submitEvent = async () => {
    if (!minute) return showToast('La minute est requise', true);
    // A typed name is not linked to any profile, so it would never reach the player's stats.
    if ((playerInputName && !selectedPlayer) || (subInInputName && !selectedSubIn)) {
      return showToast('Choisissez le joueur dans la liste de l\'équipe', true);
    }
    setSubmitting(true);
    try {
      const isSub = eventType === 'substitution';
      const body = {
        type: eventType, minute: parseInt(minute),
        isHomeTeam: selectedTeam === 'home',
        relatedPlayerId:   selectedPlayer?.id    || undefined,
        relatedPlayerName: selectedPlayer?.label || playerInputName || undefined,
        substitutionPlayerOutId:   isSub ? (selectedPlayer?.id    || undefined) : undefined,
        substitutionPlayerOutName: isSub ? (selectedPlayer?.label || playerInputName || undefined) : undefined,
        substitutionPlayerInId:    isSub ? (selectedSubIn?.id     || undefined) : undefined,
        substitutionPlayerInName:  isSub ? (selectedSubIn?.label  || subInInputName || undefined) : undefined,
      };
      const r = await fetch(`${API}/matches/${id}/events`, {
        method: 'POST', headers: authHeaders(), body: JSON.stringify(body),
      });
      const d = await r.json();
      if (!r.ok) throw new Error(d.message);
      setMatch(d.match);
      setDialogOpen(false);
      resetForm();
      showToast('Événement ajouté ✓');
    } catch (e) { showToast(e.message, true); }
    finally { setSubmitting(false); }
  };

  const deleteEvent = async (eventId) => {
    try {
      const r = await fetch(`${API}/matches/${id}/events/${eventId}`, {
        method: 'DELETE', headers: authHeaders(),
      });
      const d = await r.json();
      if (!r.ok) throw new Error(d.message);
      setMatch(d.match);
      showToast('Événement supprimé');
    } catch (e) { showToast(e.message, true); }
  };

  const resetForm = () => {
    setMinute(''); setSelectedPlayer(null); setPlayerInputName('');
    setSelectedSubIn(null); setSubInInputName('');
    setEventType('goal'); setSelectedTeam('home');
  };

  const openDialog = (team, type = 'goal') => {
    setSelectedTeam(team); setEventType(type);
    setMinute(currentMatchMinute());
    setDialogOpen(true);
  };

  const showToast = (msg, err = false) => {
    setToast({ msg, err });
    setTimeout(() => setToast({ msg: '', err: false }), 3500);
  };

  const teamPlayers = (side) => {
    const team = side === 'home' ? match?.homeTeam : match?.awayTeam;
    return (team?.players || []).map(p => ({ id: p.id, label: p.name || `Joueur #${p.id}` }));
  };

  // ── Render guards ─────────────────────────────────────────────────────────
  if (loading) return <Box sx={{ display: 'flex', justifyContent: 'center', mt: 8 }}><CircularProgress /></Box>;
  if (error || !match) return <Box sx={{ p: 4 }}><Alert severity="error">{error || 'Match introuvable'}</Alert></Box>;

  const homeTeam   = match.homeTeam?.name || 'Domicile';
  const awayTeam   = match.awayTeam?.name || 'Extérieur';
  const statusCfg  = STATUS_LABELS[match.status] || { label: match.status, color: '#64748b' };
  const canEdit    = !['completed', 'cancelled'].includes(match.status);
  const events     = [...(match.events || [])].sort((a, b) => b.minute - a.minute || b.id - a.id);
  const isSub      = eventType === 'substitution';
  const dialogPlayers = teamPlayers(selectedTeam);

  // ── Timer display ─────────────────────────────────────────────────────────
  const TimerDisplay = () => {
    if (!timer) return null;

    // ── Mi-temps : countdown ────────────────────────────────────────────────
    if (timer.phase === 'half_time') {
      const mins = Math.floor(timer.remaining / 60);
      const secs = timer.remaining % 60;
      const pct  = ((BREAK_DURATION - timer.remaining) / BREAK_DURATION) * 100;

      return (
        <Box sx={{ textAlign: 'center', mt: 1 }}>
          <Box sx={{ display: 'flex', alignItems: 'center', justifyContent: 'center', gap: 1, mb: 0.5 }}>
            <PauseCircleIcon sx={{ color: '#fbbf24', fontSize: 18 }} />
            <Typography sx={{ color: '#fbbf24', fontWeight: 700, fontSize: '0.8rem', textTransform: 'uppercase', letterSpacing: 1 }}>
              Pause mi-temps
            </Typography>
          </Box>
          {timer.breakDone ? (
            <Typography sx={{ color: '#f97316', fontWeight: 800, fontSize: '1.1rem', animation: 'liveP 1s infinite' }}>
              ⚡ Reprise !
            </Typography>
          ) : (
            <>
              <Typography sx={{ color: 'white', fontWeight: 900, fontSize: '2rem', fontVariantNumeric: 'tabular-nums' }}>
                {String(mins).padStart(2, '0')}:{String(secs).padStart(2, '0')}
              </Typography>
              <Box sx={{ mt: 0.5, mx: 2 }}>
                <LinearProgress
                  variant="determinate" value={pct}
                  sx={{ height: 4, borderRadius: 2,
                    bgcolor: 'rgba(251,191,36,0.20)',
                    '& .MuiLinearProgress-bar': { bgcolor: '#fbbf24' },
                  }}
                />
              </Box>
              <Typography sx={{ color: '#94a3b8', fontSize: '0.7rem', mt: 0.3 }}>
                Pause : {mins}min {secs}s restantes
              </Typography>
            </>
          )}
        </Box>
      );
    }

    // ── 1ère ou 2ème mi-temps ────────────────────────────────────────────────
    const halfLabel = timer.phase === 'first_half' ? '1ère mi-temps' : '2ème mi-temps';
    const progressPct = timer.phase === 'first_half'
      ? Math.min(100, (timer.minutes * 60 + timer.seconds) / HALF_DURATION * 100)
      : Math.min(100, ((timer.minutes - 45) * 60 + timer.seconds) / HALF_DURATION * 100);

    return (
      <Box sx={{ textAlign: 'center', mt: 1 }}>
        <Box sx={{ display: 'flex', alignItems: 'center', justifyContent: 'center', gap: 1, mb: 0.5 }}>
          <FiberManualRecordIcon sx={{ fontSize: 10, color: '#10b981', animation: 'liveP 1.5s infinite' }} />
          <Typography sx={{ color: '#94a3b8', fontSize: '0.72rem', textTransform: 'uppercase', letterSpacing: 1 }}>
            {halfLabel}
          </Typography>
        </Box>

        {timer.isExtra ? (
          // Temps additionnel
          <Box>
            <Typography sx={{ color: '#f97316', fontWeight: 900, fontSize: '2rem', lineHeight: 1, fontVariantNumeric: 'tabular-nums' }}>
              {timer.minutes}'
              <Box component="span" sx={{ fontSize: '1.3rem', color: '#fb923c' }}>
                {' '}+{timer.extra}'
              </Box>
            </Typography>
            <Typography sx={{ color: '#f97316', fontSize: '0.7rem', fontWeight: 700, mt: 0.3,
              textTransform: 'uppercase', letterSpacing: 1, animation: 'liveP 1.5s infinite' }}>
              ⏱ Temps additionnel
            </Typography>
          </Box>
        ) : (
          // Temps normal
          <Box>
            <Typography sx={{ color: '#10b981', fontWeight: 900, fontSize: '2rem', lineHeight: 1, fontVariantNumeric: 'tabular-nums' }}>
              {String(timer.minutes).padStart(2, '0')}:{String(timer.seconds).padStart(2, '0')}
            </Typography>
            <Box sx={{ mt: 0.5, mx: 2 }}>
              <LinearProgress
                variant="determinate" value={progressPct}
                sx={{ height: 4, borderRadius: 2,
                  bgcolor: 'rgba(16,185,129,0.15)',
                  '& .MuiLinearProgress-bar': {
                    bgcolor: progressPct > 90 ? '#f97316' : '#10b981',
                    transition: 'none',
                  },
                }}
              />
            </Box>
          </Box>
        )}
      </Box>
    );
  };

  // ── Action buttons ────────────────────────────────────────────────────────
  const ActionButtons = () => {
    const s = match.status;

    if (s === 'scheduled') return (
      <Button variant="contained" startIcon={<PlayCircleIcon />}
        onClick={handleStart}
        sx={{ bgcolor: '#16a34a', '&:hover': { bgcolor: '#15803d' }, fontWeight: 700, borderRadius: 2, px: 3 }}>
        Démarrer le match
      </Button>
    );

    if (s === 'in_progress' && phase === 'first_half') return (
      <Box sx={{ display: 'flex', gap: 1.5, flexWrap: 'wrap' }}>
        <Button variant="contained" startIcon={<PauseCircleIcon />}
          onClick={handleHalfTime}
          sx={{ bgcolor: '#ca8a04', '&:hover': { bgcolor: '#a16207' }, fontWeight: 700, borderRadius: 2 }}>
          ⏸ Mi-temps
        </Button>
      </Box>
    );

    if (s === 'half_time') return (
      <Box sx={{ display: 'flex', gap: 1.5, flexWrap: 'wrap', alignItems: 'center' }}>
        <Button variant="contained" startIcon={<PlayCircleIcon />}
          onClick={handleSecondHalf}
          sx={{ bgcolor: '#16a34a', '&:hover': { bgcolor: '#15803d' }, fontWeight: 700, borderRadius: 2, px: 3 }}>
          ▶ Reprendre — 2ème mi-temps
        </Button>
        {timer?.breakDone && (
          <Typography sx={{ color: '#f97316', fontWeight: 700, fontSize: '0.85rem', animation: 'liveP 1s infinite' }}>
            ⚡ Pause terminée !
          </Typography>
        )}
      </Box>
    );

    if (s === 'in_progress' && phase === 'second_half') return (
      <Box sx={{ display: 'flex', gap: 1.5, flexWrap: 'wrap' }}>
        <Button variant="contained"
          onClick={handleEnd}
          sx={{ bgcolor: '#dc2626', '&:hover': { bgcolor: '#b91c1c' }, fontWeight: 700, borderRadius: 2 }}>
          🏁 Terminer le match
        </Button>
      </Box>
    );

    return null;
  };

  return (
    <Box sx={{ p: { xs: 2, md: 3 }, maxWidth: 900, mx: 'auto' }}>

      {/* ── Header ── */}
      <Box sx={{ display: 'flex', alignItems: 'center', mb: 3, gap: 1 }}>
        <IconButton onClick={() => navigate(-1)} size="small"><ArrowBackIcon /></IconButton>
        <SportsSoccerIcon sx={{ color: '#3b82f6' }} />
        <Typography sx={{ fontWeight: 700, fontSize: '1.1rem', flex: 1 }}>
          Mode Live — {homeTeam} vs {awayTeam}
        </Typography>
        <Chip
          label={statusCfg.label} size="small"
          sx={{ fontWeight: 700, bgcolor: statusCfg.color + '22', color: statusCfg.color, border: `1px solid ${statusCfg.color}44` }}
          icon={match.status === 'in_progress'
            ? <FiberManualRecordIcon sx={{ fontSize: '10px !important', color: `${statusCfg.color} !important`, animation: 'liveP 1.5s infinite' }} />
            : undefined}
        />
      </Box>

      {toast.msg && (
        <Alert severity={toast.err ? 'error' : 'success'} sx={{ mb: 2, borderRadius: 2 }}>{toast.msg}</Alert>
      )}

      {/* ── Scoreboard ── */}
      <Card sx={{ mb: 3, background: 'linear-gradient(135deg, #0f172a 0%, #1e3a5f 100%)', borderRadius: 3, boxShadow: '0 8px 32px rgba(0,0,0,0.3)' }}>
        <CardContent sx={{ p: 3, pb: '20px !important' }}>
          {match.location && (
            <Typography sx={{ color: '#94a3b8', fontSize: '0.8rem', textAlign: 'center', mb: 1.5 }}>
              📍 {match.location}
            </Typography>
          )}

          <Grid container alignItems="center" justifyContent="center" spacing={2}>
            {/* Home */}
            <Grid item xs={4} sx={{ textAlign: 'center' }}>
              <Avatar sx={{ width: 52, height: 52, bgcolor: '#3b82f6', mx: 'auto', mb: 1, fontSize: '1.2rem', fontWeight: 700 }}>{homeTeam[0]}</Avatar>
              <Typography sx={{ color: 'white', fontWeight: 700, fontSize: '0.95rem' }}>{homeTeam}</Typography>
              <Typography sx={{ color: '#94a3b8', fontSize: '0.72rem' }}>Domicile</Typography>
            </Grid>

            {/* Score + timer */}
            <Grid item xs={4} sx={{ textAlign: 'center' }}>
              <Typography sx={{ color: 'white', fontSize: '3.2rem', fontWeight: 900, lineHeight: 1, letterSpacing: '-2px' }}>
                {match.homeTeamScore ?? 0} – {match.awayTeamScore ?? 0}
              </Typography>

              {/* Timer intelligent */}
              {match.status !== 'completed' && match.status !== 'scheduled' && <TimerDisplay />}

              {/* Score mi-temps affiché sur le scoreboard à la reprise */}
              {match.status === 'in_progress' && phase === 'second_half' && (
                <Typography sx={{ color: '#fbbf24', fontSize: '0.72rem', fontWeight: 600, mt: 0.5 }}>
                  Mi-temps : {match.halfTimeHomeScore ?? 0} – {match.halfTimeAwayScore ?? 0}
                </Typography>
              )}

              {match.status === 'completed' && (
                <Box>
                  <Typography sx={{ color: '#64748b', fontSize: '0.78rem', mt: 0.5 }}>Match terminé</Typography>
                  {(match.halfTimeHomeScore != null) && (
                    <Typography sx={{ color: '#94a3b8', fontSize: '0.7rem' }}>
                      Mi-temps : {match.halfTimeHomeScore} – {match.halfTimeAwayScore}
                    </Typography>
                  )}
                </Box>
              )}
            </Grid>

            {/* Away */}
            <Grid item xs={4} sx={{ textAlign: 'center' }}>
              <Avatar sx={{ width: 52, height: 52, bgcolor: '#ef4444', mx: 'auto', mb: 1, fontSize: '1.2rem', fontWeight: 700 }}>{awayTeam[0]}</Avatar>
              <Typography sx={{ color: 'white', fontWeight: 700, fontSize: '0.95rem' }}>{awayTeam}</Typography>
              <Typography sx={{ color: '#94a3b8', fontSize: '0.72rem' }}>Extérieur</Typography>
            </Grid>
          </Grid>

          {/* Phase indicator bar */}
          {match.status !== 'completed' && match.status !== 'scheduled' && (
            <Box sx={{ mt: 2, display: 'flex', justifyContent: 'center', gap: 1 }}>
              {['first_half', 'half_time', 'second_half'].map((p, i) => {
                const labels = ['1ère mi-t.', 'Mi-temps', '2ème mi-t.'];
                const active = match.status === 'half_time' ? p === 'half_time'
                  : match.status === 'in_progress' ? p === phase : false;
                const done = match.status === 'half_time'
                  ? i < 1 : match.status === 'in_progress' && phase === 'second_half' ? i < 2 : i < 0;
                return (
                  <Box key={p} sx={{ display: 'flex', alignItems: 'center', gap: 0.5 }}>
                    <Box sx={{
                      width: 8, height: 8, borderRadius: '50%',
                      bgcolor: active ? '#10b981' : done ? '#3b82f6' : '#334155',
                    }} />
                    <Typography sx={{ fontSize: '0.65rem', color: active ? '#10b981' : done ? '#3b82f6' : '#64748b', fontWeight: active ? 700 : 400 }}>
                      {labels[i]}
                    </Typography>
                  </Box>
                );
              })}
            </Box>
          )}
        </CardContent>
      </Card>

      {/* ── Boutons d'action ── */}
      {canEdit && (
        <Box sx={{ mb: 3 }}>
          <ActionButtons />
        </Box>
      )}

      {/* ── Ajout d'événements ── */}
      {canEdit && match.status !== 'half_time' && (
        <Card sx={{ mb: 3, border: '1px solid', borderColor: 'divider', boxShadow: 'none', borderRadius: 2 }}>
          <Box sx={{ px: 2.5, py: 1.5, borderBottom: '1px solid', borderColor: 'divider', display: 'flex', alignItems: 'center', gap: 1 }}>
            <TimerIcon sx={{ fontSize: 16, color: 'text.secondary' }} />
            <Typography sx={{ fontWeight: 600, fontSize: '0.9rem', flex: 1 }}>Ajouter un événement</Typography>
            {timer && !timer.breakDone && timer.minutes !== undefined && (
              <Chip
                label={timer.isExtra ? `${timer.minutes}'+${timer.extra}'` : `${String(timer.minutes).padStart(2,'0')}:${String(timer.seconds).padStart(2,'0')}`}
                size="small"
                sx={{ fontWeight: 700, height: 20, fontSize: '0.7rem',
                  bgcolor: timer.isExtra ? 'rgba(249,115,22,0.12)' : 'rgba(16,185,129,0.12)',
                  color: timer.isExtra ? '#f97316' : '#10b981' }}
              />
            )}
          </Box>
          <CardContent sx={{ p: 2 }}>
            <Grid container spacing={2}>
              {[{ side: 'home', name: homeTeam, color: '#3b82f6', icon: '🏠' },
                { side: 'away', name: awayTeam, color: '#ef4444', icon: '✈️' }].map(({ side, name, color, icon }) => (
                <Grid item xs={12} sm={6} key={side}>
                  <Typography sx={{ fontWeight: 600, color, mb: 1, fontSize: '0.85rem' }}>{icon} {name}</Typography>
                  <Box sx={{ display: 'flex', flexWrap: 'wrap', gap: 1 }}>
                    {EVENT_TYPES.map(et => (
                      <Button key={et.value} size="small" variant="outlined"
                        onClick={() => openDialog(side, et.value)}
                        startIcon={<AddIcon sx={{ fontSize: '12px !important' }} />}
                        sx={{ fontSize: '0.72rem', borderColor: et.color + '66', color: et.color,
                          '&:hover': { borderColor: et.color, bgcolor: et.color + '11' } }}>
                        {et.label}
                      </Button>
                    ))}
                  </Box>
                </Grid>
              ))}
            </Grid>
          </CardContent>
        </Card>
      )}

      {/* ── Timeline ── */}
      <Card sx={{ border: '1px solid', borderColor: 'divider', boxShadow: 'none', borderRadius: 2 }}>
        <Box sx={{ px: 2.5, py: 1.5, borderBottom: '1px solid', borderColor: 'divider', display: 'flex', alignItems: 'center', gap: 1 }}>
          <Typography sx={{ fontWeight: 600, fontSize: '0.9rem', flex: 1 }}>Événements</Typography>
          <Chip label={events.length} size="small" sx={{ fontWeight: 700, height: 20, fontSize: '0.7rem' }} />
        </Box>
        {events.length === 0
          ? <Box sx={{ py: 5, textAlign: 'center' }}><Typography fontSize="0.875rem" color="text.secondary">Aucun événement</Typography></Box>
          : (
            <Box sx={{ p: 1 }}>
              {events.map(ev => {
                const isHome     = ev.isHomeTeam;
                const playerLabel = ev.relatedPlayerName || ev.substitutionPlayerOutName || '—';
                return (
                  <Box key={ev.id}
                    sx={{ display: 'flex', alignItems: 'center', gap: 1.5, py: 0.75, px: 1,
                      borderRadius: 1.5, '&:hover': { bgcolor: 'action.hover' },
                      flexDirection: isHome ? 'row' : 'row-reverse' }}>
                    <Box sx={{ flex: 1, textAlign: isHome ? 'left' : 'right' }}>
                      <Typography sx={{ fontWeight: 600, fontSize: '0.875rem' }}>
                        {EVENT_ICON[ev.type] || '•'} {playerLabel}
                        {ev.type === 'substitution' && ev.substitutionPlayerInName && (
                          <Box component="span" sx={{ color: '#10b981', fontWeight: 400 }}> → {ev.substitutionPlayerInName}</Box>
                        )}
                      </Typography>
                      <Typography sx={{ fontSize: '0.72rem', color: 'text.secondary' }}>{isHome ? homeTeam : awayTeam}</Typography>
                    </Box>
                    <Box sx={{ minWidth: 46, height: 26, borderRadius: 13, bgcolor: 'text.primary', color: 'background.paper',
                      display: 'flex', alignItems: 'center', justifyContent: 'center',
                      fontSize: '0.75rem', fontWeight: 700, flexShrink: 0 }}>
                      {ev.minute}'{ev.extraMinute ? `+${ev.extraMinute}` : ''}
                    </Box>
                    {canEdit && (
                      <Tooltip title="Supprimer">
                        <IconButton size="small" onClick={() => deleteEvent(ev.id)}
                          sx={{ color: '#ef4444', opacity: 0.4, '&:hover': { opacity: 1 } }}>
                          <DeleteIcon fontSize="small" />
                        </IconButton>
                      </Tooltip>
                    )}
                  </Box>
                );
              })}
            </Box>
          )
        }
      </Card>

      {/* ── Dialog saisie événement ── */}
      <Dialog open={dialogOpen} onClose={() => { setDialogOpen(false); resetForm(); }} maxWidth="xs" fullWidth>
        <DialogTitle sx={{ fontWeight: 700, pb: 1 }}>
          {EVENT_TYPES.find(e => e.value === eventType)?.label} —{' '}
          {selectedTeam === 'home' ? `🏠 ${homeTeam}` : `✈️ ${awayTeam}`}
        </DialogTitle>
        <DialogContent sx={{ pt: '8px !important', display: 'flex', flexDirection: 'column', gap: 2 }}>

          <TextField select fullWidth label="Type d'événement" value={eventType}
            onChange={e => setEventType(e.target.value)} size="small">
            {EVENT_TYPES.map(et => <MenuItem key={et.value} value={et.value}>{et.label}</MenuItem>)}
          </TextField>

          <TextField fullWidth label="Minute" type="number" value={minute}
            onChange={e => setMinute(e.target.value)} size="small"
            inputProps={{ min: 1, max: 120 }}
            helperText={timer && timer.isExtra ? `Temps additionnel — saisir ${timer.minutes} + temps add.` : undefined} />

          {dialogPlayers.length > 0 ? (
            <Autocomplete options={dialogPlayers} value={selectedPlayer}
              onChange={(_, v) => setSelectedPlayer(v)}
              inputValue={playerInputName} onInputChange={(_, v) => setPlayerInputName(v)}
              freeSolo size="small"
              renderInput={(params) => (
                <TextField {...params} label={isSub ? 'Joueur sortant' : `Joueur ${NEEDS_PLAYER.includes(eventType) ? '*' : '(optionnel)'}`} />
              )}
            />
          ) : (
            <TextField fullWidth size="small"
              label={isSub ? 'Joueur sortant (nom)' : 'Joueur (optionnel)'}
              value={playerInputName} onChange={e => setPlayerInputName(e.target.value)} />
          )}

          {isSub && (
            dialogPlayers.length > 0 ? (
              <Autocomplete options={dialogPlayers} value={selectedSubIn}
                onChange={(_, v) => setSelectedSubIn(v)}
                inputValue={subInInputName} onInputChange={(_, v) => setSubInInputName(v)}
                freeSolo size="small"
                renderInput={(params) => <TextField {...params} label="Joueur entrant" />}
              />
            ) : (
              <TextField fullWidth size="small" label="Joueur entrant (nom)"
                value={subInInputName} onChange={e => setSubInInputName(e.target.value)} />
            )
          )}

          {NEEDS_PLAYER.includes(eventType) && !selectedPlayer && !playerInputName && (
            <Typography sx={{ fontSize: '0.75rem', color: '#ca8a04' }}>
              ⚠️ Sélectionne un joueur pour que les stats soient mises à jour automatiquement.
            </Typography>
          )}
        </DialogContent>
        <DialogActions sx={{ px: 3, pb: 2 }}>
          <Button onClick={() => { setDialogOpen(false); resetForm(); }}>Annuler</Button>
          <Button variant="contained" onClick={submitEvent} disabled={submitting}>
            {submitting ? <CircularProgress size={18} /> : 'Confirmer'}
          </Button>
        </DialogActions>
      </Dialog>

      <style>{`
        @keyframes liveP { 0%,100%{opacity:1} 50%{opacity:0.2} }
      `}</style>
    </Box>
  );
}
