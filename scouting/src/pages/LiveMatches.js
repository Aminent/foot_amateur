import React, { useEffect, useState, useRef, useMemo } from 'react';
import {
  Box, Card, Typography, Grid, Chip, CircularProgress,
  Avatar, IconButton, Collapse, Divider, TextField,
  InputAdornment, MenuItem, Select, FormControl, InputLabel,
  Button, Stack, alpha,
} from '@mui/material';
import ExpandMoreIcon        from '@mui/icons-material/ExpandMore';
import ExpandLessIcon        from '@mui/icons-material/ExpandLess';
import FiberManualRecordIcon from '@mui/icons-material/FiberManualRecord';
import SearchIcon            from '@mui/icons-material/Search';
import FilterListIcon        from '@mui/icons-material/FilterList';
import CloseIcon             from '@mui/icons-material/Close';
import SportsSoccerIcon      from '@mui/icons-material/SportsSoccer';
import EmojiEventsIcon       from '@mui/icons-material/EmojiEvents';
import LocationOnIcon        from '@mui/icons-material/LocationOn';
import AccessTimeIcon        from '@mui/icons-material/AccessTime';
import { io } from 'socket.io-client';
import { apiFetch, BASE } from '../utils/api';

// ── Palette ────────────────────────────────────────────────────────────────
const TEAL      = '#0c9e96';
const TEAL_DARK = '#0a8880';
const TEAL_PALE = '#f0fdfa';

const STATUS_CFG = {
  in_progress: { label: 'En direct',  color: '#16a34a', bg: '#dcfce7', dot: '#16a34a', emoji: '🔴' },
  half_time:   { label: 'Mi-temps',   color: '#b45309', bg: '#fef9c3', dot: '#ca8a04', emoji: '⏸' },
  scheduled:   { label: 'Planifié',   color: '#1d4ed8', bg: '#dbeafe', dot: '#3b82f6', emoji: '📅' },
  completed:   { label: 'Terminé',    color: '#475569', bg: '#e2e8f0', dot: '#94a3b8', emoji: '✅' },
  postponed:   { label: 'Reporté',    color: '#6d28d9', bg: '#ede9fe', dot: '#8b5cf6', emoji: '⏳' },
  cancelled:   { label: 'Annulé',     color: '#dc2626', bg: '#fee2e2', dot: '#ef4444', emoji: '❌' },
};

const EVENT_ICON = {
  goal: '⚽', penalty_goal: '🎯', own_goal: '⚽',
  yellow_card: '🟨', red_card: '🟥', substitution: '🔄', injury: '🚑',
};

const STATUS_ORDER = { in_progress: 0, half_time: 1, scheduled: 2, completed: 3, postponed: 4, cancelled: 5 };

const FIXED_DATE_OPTS = [
  { value: 'all',   label: 'Toutes les dates' },
  { value: 'today', label: "Aujourd'hui" },
  { value: 'week',  label: 'Cette semaine' },
  { value: 'month', label: 'Ce mois' },
];

// ── Helpers ────────────────────────────────────────────────────────────────
const selectSx = {
  borderRadius: 2,
  '& .MuiOutlinedInput-root': { borderRadius: 2 },
  '& .MuiOutlinedInput-notchedOutline': { borderColor: '#e2e8f0' },
  '&:hover .MuiOutlinedInput-notchedOutline': { borderColor: TEAL },
  '&.Mui-focused .MuiOutlinedInput-notchedOutline': { borderColor: TEAL },
};

// ── MatchCard ──────────────────────────────────────────────────────────────
function MatchCard({ match: initialMatch }) {
  const [match,    setMatch]    = useState(initialMatch);
  const [expanded, setExpanded] = useState(match.status === 'in_progress');
  const socketRef = useRef(null);

  useEffect(() => {
    const token  = localStorage.getItem('scout_token');
    const socket = io(BASE, { auth: { token } });
    socketRef.current = socket;
    socket.emit('join-match', match.id);
    socket.on('live-update', ({ match: updated }) => {
      if (updated) { setMatch(updated); setExpanded(true); }
    });
    return () => socket.disconnect();
  }, [match.id]);

  const st     = STATUS_CFG[match.status] || { label: match.status, color: '#64748b', bg: '#e2e8f0', dot: '#94a3b8', emoji: '•' };
  const events = [...(match.events || [])].sort((a, b) => b.minute - a.minute);
  const isLive = match.status === 'in_progress' || match.status === 'half_time';
  const isDone = match.status === 'completed';

  // Determine winner for highlighting
  const homeWon = isDone && (match.homeTeamScore ?? 0) > (match.awayTeamScore ?? 0);
  const awayWon = isDone && (match.awayTeamScore ?? 0) > (match.homeTeamScore ?? 0);

  return (
    <Card sx={{
      overflow: 'hidden',
      border: '1px solid',
      borderColor: isLive ? alpha(st.color, 0.35) : '#eef2f7',
      borderRadius: 3,
      boxShadow: isLive
        ? `0 0 0 1px ${alpha(st.color, 0.15)}, 0 4px 24px ${alpha(st.color, 0.12)}`
        : '0 1px 4px rgba(0,0,0,0.06)',
      transition: 'all .25s',
      '&:hover': {
        boxShadow: isLive
          ? `0 0 0 1px ${alpha(st.color, 0.25)}, 0 8px 32px ${alpha(st.color, 0.18)}`
          : '0 4px 20px rgba(0,0,0,0.10)',
        transform: 'translateY(-1px)',
      },
    }}>
      {/* Coloured top bar */}
      <Box sx={{ height: 3, background: isLive ? `linear-gradient(90deg, ${st.color}, ${alpha(st.color, 0.4)})` : st.bg }} />

      {/* Card body */}
      <Box sx={{ p: 2.5, cursor: 'pointer' }} onClick={() => setExpanded(e => !e)}>

        {/* Meta row */}
        <Box sx={{ display: 'flex', alignItems: 'center', gap: 0.8, mb: 2, flexWrap: 'wrap' }}>
          {/* Status chip */}
          <Box sx={{
            display: 'inline-flex', alignItems: 'center', gap: 0.6,
            bgcolor: alpha(st.color, 0.1), color: st.color,
            borderRadius: 10, px: 1.2, py: 0.35,
            fontSize: '0.70rem', fontWeight: 700,
          }}>
            {isLive && (
              <Box sx={{
                width: 6, height: 6, borderRadius: '50%',
                bgcolor: st.color, animation: 'liveP 1.2s ease-in-out infinite',
              }} />
            )}
            {st.emoji} {st.label}
          </Box>

          {match.tournament && (
            <Box sx={{
              display: 'inline-flex', alignItems: 'center', gap: 0.5,
              bgcolor: 'background.default', color: 'text.secondary',
              border: '1px solid', borderColor: 'divider', borderRadius: 10,
              px: 1, py: 0.3, fontSize: '0.68rem', fontWeight: 500,
            }}>
              <EmojiEventsIcon sx={{ fontSize: 11 }} />
              {match.tournament.name}
            </Box>
          )}

          <Box sx={{ flex: 1 }} />

          {match.location && (
            <Box sx={{ display: 'flex', alignItems: 'center', gap: 0.3, color: '#94a3b8', fontSize: '0.68rem' }}>
              <LocationOnIcon sx={{ fontSize: 11 }} />
              {match.location}
            </Box>
          )}
          {match.date && (
            <Box sx={{ display: 'flex', alignItems: 'center', gap: 0.3, color: '#94a3b8', fontSize: '0.68rem' }}>
              <AccessTimeIcon sx={{ fontSize: 11 }} />
              {new Date(match.date).toLocaleString('fr-FR', { day: '2-digit', month: 'short', hour: '2-digit', minute: '2-digit' })}
            </Box>
          )}
          <IconButton size="small" sx={{ p: 0.4, color: '#94a3b8' }}>
            {expanded ? <ExpandLessIcon fontSize="small" /> : <ExpandMoreIcon fontSize="small" />}
          </IconButton>
        </Box>

        {/* Score area */}
        <Box sx={{
          display: 'flex', alignItems: 'center',
          bgcolor: 'background.default', borderRadius: 2.5, px: 2, py: 1.5,
        }}>
          {/* Home team */}
          <Box sx={{ flex: 1, display: 'flex', alignItems: 'center', justifyContent: 'flex-end', gap: 1.2 }}>
            <Typography sx={{
              fontWeight: homeWon ? 800 : 600,
              fontSize: '0.92rem',
              color: 'text.primary',
              textAlign: 'right',
            }}>
              {match.homeTeam?.name || '?'}
            </Typography>
            <Avatar sx={{
              width: 36, height: 36,
              background: homeWon
                ? 'linear-gradient(135deg, #1e40af, #3b82f6)'
                : 'linear-gradient(135deg, #cbd5e1, #94a3b8)',
              color: 'white', fontSize: '0.78rem', fontWeight: 800,
              boxShadow: homeWon ? '0 2px 8px rgba(30,64,175,0.35)' : 'none',
            }}>
              {match.homeTeam?.name?.[0] || '?'}
            </Avatar>
          </Box>

          {/* Score / VS */}
          <Box sx={{ mx: 2, textAlign: 'center', minWidth: 72 }}>
            {match.status === 'scheduled' ? (
              <Typography sx={{ fontSize: '0.85rem', fontWeight: 700, color: '#94a3b8', letterSpacing: 1 }}>VS</Typography>
            ) : (
              <Box sx={{
                display: 'inline-flex', alignItems: 'center', gap: 0.5,
                background: isLive
                  ? `linear-gradient(135deg, ${st.color}, ${TEAL_DARK})`
                  : 'linear-gradient(135deg, #0f172a, #1e293b)',
                borderRadius: 2, px: 1.8, py: 0.6,
                boxShadow: isLive ? `0 2px 12px ${alpha(st.color, 0.4)}` : '0 2px 8px rgba(0,0,0,0.2)',
              }}>
                <Typography sx={{ fontSize: '1.5rem', fontWeight: 900, color: 'white', lineHeight: 1 }}>
                  {match.homeTeamScore ?? 0}
                </Typography>
                <Typography sx={{ fontSize: '0.9rem', color: 'rgba(255,255,255,0.5)', fontWeight: 700, mx: 0.2 }}>
                  –
                </Typography>
                <Typography sx={{ fontSize: '1.5rem', fontWeight: 900, color: 'white', lineHeight: 1 }}>
                  {match.awayTeamScore ?? 0}
                </Typography>
              </Box>
            )}
          </Box>

          {/* Away team */}
          <Box sx={{ flex: 1, display: 'flex', alignItems: 'center', gap: 1.2 }}>
            <Avatar sx={{
              width: 36, height: 36,
              background: awayWon
                ? 'linear-gradient(135deg, #991b1b, #ef4444)'
                : 'linear-gradient(135deg, #cbd5e1, #94a3b8)',
              color: 'white', fontSize: '0.78rem', fontWeight: 800,
              boxShadow: awayWon ? '0 2px 8px rgba(153,27,27,0.35)' : 'none',
            }}>
              {match.awayTeam?.name?.[0] || '?'}
            </Avatar>
            <Typography sx={{
              fontWeight: awayWon ? 800 : 600,
              fontSize: '0.92rem',
              color: 'text.primary',
            }}>
              {match.awayTeam?.name || '?'}
            </Typography>
          </Box>
        </Box>
      </Box>

      {/* Events panel */}
      <Collapse in={expanded}>
        <Divider sx={{ borderColor: '#f1f5f9' }} />
        <Box sx={{ px: 2.5, py: 2, bgcolor: 'background.default' }}>
          <Typography sx={{
            fontSize: '0.70rem', fontWeight: 700, color: '#94a3b8',
            textTransform: 'uppercase', letterSpacing: '0.08em', mb: 1.5,
          }}>
            Événements · {events.length}
          </Typography>
          {events.length === 0 ? (
            <Box sx={{ textAlign: 'center', py: 2 }}>
              <SportsSoccerIcon sx={{ fontSize: 28, color: '#cbd5e1', mb: 0.5 }} />
              <Typography sx={{ fontSize: '0.8rem', color: '#94a3b8' }}>Aucun événement</Typography>
            </Box>
          ) : (
            <Stack spacing={0.4}>
              {events.map(ev => (
                <Box key={ev.id} sx={{
                  display: 'flex', alignItems: 'center', gap: 1.5,
                  flexDirection: ev.isHomeTeam ? 'row' : 'row-reverse',
                  py: 0.5, px: 1, borderRadius: 1.5,
                  '&:hover': { bgcolor: 'action.hover' },
                }}>
                  <Box sx={{ flex: 1, textAlign: ev.isHomeTeam ? 'left' : 'right' }}>
                    <Typography sx={{ fontSize: '0.82rem', fontWeight: 600, color: 'text.primary' }}>
                      {EVENT_ICON[ev.type] || '•'} {ev.relatedPlayerName || ev.substitutionPlayerOutName || '—'}
                      {ev.type === 'substitution' && ev.substitutionPlayerInName && (
                        <Box component="span" sx={{ color: '#16a34a', fontWeight: 500 }}>
                          {' '}→ {ev.substitutionPlayerInName}
                        </Box>
                      )}
                    </Typography>
                    <Typography sx={{ fontSize: '0.68rem', color: '#94a3b8' }}>
                      {ev.isHomeTeam ? match.homeTeam?.name : match.awayTeam?.name}
                    </Typography>
                  </Box>
                  <Box sx={{
                    minWidth: 36, height: 22, borderRadius: 1,
                    bgcolor: '#1e293b', display: 'flex', alignItems: 'center', justifyContent: 'center',
                  }}>
                    <Typography sx={{ fontSize: '0.68rem', fontWeight: 700, color: 'white' }}>
                      {ev.minute}'
                    </Typography>
                  </Box>
                </Box>
              ))}
            </Stack>
          )}
        </Box>
      </Collapse>
    </Card>
  );
}

// ── Stat card ──────────────────────────────────────────────────────────────
function StatCard({ value, label, color, icon, gradient }) {
  return (
    <Box sx={{
      flex: 1, minWidth: 0,
      borderRadius: 3, overflow: 'hidden',
      background: gradient || `linear-gradient(135deg, ${color}18, ${color}08)`,
      border: `1px solid ${color}22`,
      p: 2, textAlign: 'center',
      transition: 'transform .2s',
      '&:hover': { transform: 'translateY(-2px)' },
    }}>
      <Typography sx={{ fontSize: '1.5rem', mb: 0.2 }}>{icon}</Typography>
      <Typography sx={{ fontSize: '1.8rem', fontWeight: 900, color, lineHeight: 1 }}>{value}</Typography>
      <Typography sx={{ fontSize: '0.70rem', color: '#64748b', mt: 0.4, fontWeight: 500 }}>{label}</Typography>
    </Box>
  );
}

// ── Section header ─────────────────────────────────────────────────────────
function Section({ title, emoji, accentColor, items, empty, defaultOpen = true }) {
  const [open, setOpen] = useState(defaultOpen);
  if (items.length === 0) return (
    <Box sx={{ mb: 3 }}>
      <Box sx={{ display: 'flex', alignItems: 'center', gap: 1, mb: 1.5 }}>
        <Typography sx={{ fontWeight: 700, fontSize: '0.78rem', color: '#94a3b8', textTransform: 'uppercase', letterSpacing: '0.07em' }}>
          {emoji} {title}
        </Typography>
        <Box sx={{ height: 1, flex: 1, bgcolor: '#f1f5f9' }} />
        <Typography sx={{ fontSize: '0.72rem', color: '#cbd5e1', fontWeight: 600 }}>0</Typography>
      </Box>
    </Box>
  );
  return (
    <Box sx={{ mb: 4 }}>
      <Box
        onClick={() => setOpen(o => !o)}
        sx={{ display: 'flex', alignItems: 'center', gap: 1.5, mb: 2, cursor: 'pointer', userSelect: 'none' }}
      >
        {/* Accent bar */}
        <Box sx={{ width: 4, height: 20, borderRadius: 2, bgcolor: accentColor }} />
        <Typography sx={{ fontWeight: 700, fontSize: '0.8rem', color: 'text.primary', textTransform: 'uppercase', letterSpacing: '0.07em' }}>
          {emoji} {title}
        </Typography>
        <Box sx={{
          minWidth: 24, height: 20, borderRadius: 10,
          bgcolor: `${accentColor}18`, color: accentColor,
          fontSize: '0.68rem', fontWeight: 800,
          display: 'flex', alignItems: 'center', justifyContent: 'center', px: 0.8,
        }}>
          {items.length}
        </Box>
        <Box sx={{ flex: 1 }} />
        <IconButton size="small" sx={{ p: 0.3, color: '#94a3b8' }}>
          {open ? <ExpandLessIcon sx={{ fontSize: 18 }} /> : <ExpandMoreIcon sx={{ fontSize: 18 }} />}
        </IconButton>
      </Box>
      <Collapse in={open}>
        <Grid container spacing={2}>
          {items.map(m => (
            <Grid item xs={12} md={6} key={m.id}>
              <MatchCard match={m} />
            </Grid>
          ))}
        </Grid>
      </Collapse>
    </Box>
  );
}

// ── Main page ──────────────────────────────────────────────────────────────
export default function LiveMatches() {
  const [matches,      setMatches]      = useState([]);
  const [loading,      setLoading]      = useState(true);
  const [search,       setSearch]       = useState('');
  const [statusFilter, setStatusFilter] = useState('all');
  const [tournamentId, setTournamentId] = useState('all');
  const [dateRange,    setDateRange]    = useState('all');

  useEffect(() => {
    apiFetch('/matches').then(d => {
      const sorted = (d.matches || []).sort((a, b) =>
        (STATUS_ORDER[a.status] ?? 9) - (STATUS_ORDER[b.status] ?? 9) ||
        new Date(a.date) - new Date(b.date)
      );
      setMatches(sorted);
    }).catch(err => { console.error('Erreur chargement matchs:', err); })
    .finally(() => setLoading(false));
  }, []);

  const tournaments = useMemo(() => {
    const map = {};
    matches.forEach(m => { if (m.tournament) map[m.tournament.id] = m.tournament.name; });
    return Object.entries(map).map(([id, name]) => ({ id, name }));
  }, [matches]);

  const dateOpts = useMemo(() => {
    const years = [...new Set(
      matches.filter(m => m.date).map(m => new Date(m.date).getFullYear())
    )].sort((a, b) => b - a);
    return [
      ...FIXED_DATE_OPTS,
      ...(years.length ? [{ value: '_div', label: '──────────', disabled: true }] : []),
      ...years.map(y => ({ value: `year_${y}`, label: String(y) })),
    ];
  }, [matches]);

  const filtered = useMemo(() => {
    const now      = new Date();
    const today    = new Date(now.getFullYear(), now.getMonth(), now.getDate());
    const weekEnd  = new Date(today); weekEnd.setDate(today.getDate() + 7);
    const monthEnd = new Date(today); monthEnd.setDate(today.getDate() + 30);

    return matches.filter(m => {
      if (search.trim()) {
        const q = search.trim().toLowerCase();
        if (!(m.homeTeam?.name || '').toLowerCase().includes(q) &&
            !(m.awayTeam?.name || '').toLowerCase().includes(q)) return false;
      }
      if (statusFilter !== 'all' && m.status !== statusFilter) return false;
      if (tournamentId !== 'all' && String(m.tournament?.id) !== String(tournamentId)) return false;
      if (dateRange !== 'all' && m.date) {
        const d = new Date(m.date);
        if (dateRange === 'today' && (d < today || d >= new Date(today.getTime() + 86400000))) return false;
        if (dateRange === 'week'  && (d < today || d >= weekEnd))  return false;
        if (dateRange === 'month' && (d < today || d >= monthEnd)) return false;
        if (dateRange.startsWith('year_') && d.getFullYear() !== parseInt(dateRange.split('_')[1], 10)) return false;
      }
      return true;
    });
  }, [matches, search, statusFilter, tournamentId, dateRange]);

  const live     = filtered.filter(m => m.status === 'in_progress' || m.status === 'half_time');
  const upcoming = filtered.filter(m => m.status === 'scheduled');
  const past     = filtered.filter(m => m.status === 'completed');
  const other    = filtered.filter(m => m.status === 'postponed' || m.status === 'cancelled');

  const activeCount = [search.trim(), statusFilter !== 'all', tournamentId !== 'all', dateRange !== 'all'].filter(Boolean).length;

  const resetFilters = () => { setSearch(''); setStatusFilter('all'); setTournamentId('all'); setDateRange('all'); };

  const totalLive = matches.filter(m => m.status === 'in_progress' || m.status === 'half_time').length;

  if (loading) return (
    <Box sx={{ display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center', pt: 12, gap: 2 }}>
      <CircularProgress sx={{ color: TEAL }} size={40} thickness={3} />
      <Typography sx={{ color: '#94a3b8', fontSize: '0.85rem' }}>Chargement des matchs…</Typography>
    </Box>
  );

  return (
    <Box>
      {/* ── Page header ── */}
      <Box sx={{ mb: 3 }}>
        <Box sx={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', flexWrap: 'wrap', gap: 2, mb: 2 }}>
          <Box>
            <Typography sx={{ fontSize: '0.72rem', fontWeight: 600, textTransform: 'uppercase', letterSpacing: '0.06em', color: '#0c9e96', mb: 0.5 }}>
              Live
            </Typography>
            <Typography sx={{ fontWeight: 800, fontSize: '1.5rem', color: 'text.primary', lineHeight: 1.2 }}>
              Matchs en direct
            </Typography>
            <Typography sx={{ fontSize: '0.875rem', color: 'text.secondary', mt: 0.5 }}>
              Suivez les matchs en temps réel
            </Typography>
          </Box>
          {totalLive > 0 && (
            <Chip
              label={`${totalLive} en direct`}
              icon={<Box sx={{ width: 7, height: 7, borderRadius: '50%', bgcolor: '#16a34a', animation: 'liveP 1.2s ease-in-out infinite', ml: '8px !important' }} />}
              sx={{ bgcolor: '#dcfce7', color: '#15803d', fontWeight: 700, fontSize: '0.78rem', border: '1px solid #bbf7d0' }}
            />
          )}
        </Box>

        {/* KPI tiles */}
        <Grid container spacing={2}>
          {[
            { label: 'En direct', value: matches.filter(m => m.status === 'in_progress' || m.status === 'half_time').length, color: '#dc2626', bg: '#fee2e2' },
            { label: 'À venir',   value: matches.filter(m => m.status === 'scheduled').length,  color: '#0c9e96', bg: 'rgba(12,158,150,0.08)' },
            { label: 'Terminés',  value: matches.filter(m => m.status === 'completed').length,  color: '#16a34a', bg: '#dcfce7' },
            { label: 'Total',     value: matches.length,                                         color: '#64748b', bg: '#f1f5f9' },
          ].map(s => (
            <Grid item xs={6} md={3} key={s.label}>
              <Card sx={{ border: '1px solid', borderColor: 'divider', borderRadius: 3, boxShadow: '0 1px 4px rgba(0,0,0,0.05)', bgcolor: 'background.paper', p: 2 }}>
                <Typography sx={{ fontSize: '0.7rem', fontWeight: 600, textTransform: 'uppercase', letterSpacing: '0.06em', color: 'text.secondary', mb: 0.75 }}>{s.label}</Typography>
                <Typography sx={{ fontSize: '1.75rem', fontWeight: 800, color: s.color }}>{s.value}</Typography>
              </Card>
            </Grid>
          ))}
        </Grid>
      </Box>

      {/* ── Filter panel ── */}
      <Box sx={{
        bgcolor: 'background.paper', borderRadius: 3,
        border: '1px solid',
        borderColor: 'divider',
        boxShadow: '0 1px 8px rgba(0,0,0,0.05)',
        p: 2.5, mb: 3,
      }}>
        {/* Filter title row */}
        <Box sx={{ display: 'flex', alignItems: 'center', gap: 1, mb: 2 }}>
          <Box sx={{
            width: 28, height: 28, borderRadius: 1.5,
            bgcolor: TEAL_PALE, display: 'flex', alignItems: 'center', justifyContent: 'center',
          }}>
            <FilterListIcon sx={{ fontSize: 16, color: TEAL }} />
          </Box>
          <Typography sx={{ fontWeight: 700, fontSize: '0.85rem', color: 'text.primary' }}>Filtres</Typography>
          {activeCount > 0 && (
            <Box sx={{
              bgcolor: TEAL, color: 'white', borderRadius: 10,
              fontSize: '0.68rem', fontWeight: 800, minWidth: 20, height: 20,
              display: 'flex', alignItems: 'center', justifyContent: 'center', px: 0.7,
            }}>
              {activeCount}
            </Box>
          )}
          {activeCount > 0 && (
            <Button
              size="small"
              onClick={resetFilters}
              startIcon={<CloseIcon sx={{ fontSize: '13px !important' }} />}
              sx={{ ml: 'auto', color: '#94a3b8', fontSize: '0.75rem', textTransform: 'none', '&:hover': { color: '#ef4444', bgcolor: '#fef2f2' } }}
            >
              Réinitialiser
            </Button>
          )}
        </Box>

        <Grid container spacing={2}>
          {/* Search */}
          <Grid item xs={12} sm={6} md={3}>
            <TextField
              fullWidth size="small"
              placeholder="Rechercher une équipe…"
              value={search}
              onChange={e => setSearch(e.target.value)}
              InputProps={{
                startAdornment: <InputAdornment position="start"><SearchIcon sx={{ fontSize: 17, color: '#94a3b8' }} /></InputAdornment>,
                endAdornment: search ? (
                  <InputAdornment position="end">
                    <IconButton size="small" onClick={() => setSearch('')} sx={{ p: 0.3 }}>
                      <CloseIcon sx={{ fontSize: 13, color: '#94a3b8' }} />
                    </IconButton>
                  </InputAdornment>
                ) : null,
                sx: { borderRadius: 2, fontSize: '0.85rem' },
              }}
              sx={{ '& .MuiOutlinedInput-root': { borderRadius: 2, '&:hover fieldset': { borderColor: TEAL }, '&.Mui-focused fieldset': { borderColor: TEAL } } }}
            />
          </Grid>

          {/* Status */}
          <Grid item xs={12} sm={6} md={3}>
            <FormControl fullWidth size="small">
              <InputLabel sx={{ fontSize: '0.85rem', '&.Mui-focused': { color: TEAL } }}>Statut</InputLabel>
              <Select label="Statut" value={statusFilter} onChange={e => setStatusFilter(e.target.value)}
                sx={{ borderRadius: 2, fontSize: '0.85rem', ...selectSx }}>
                <MenuItem value="all" sx={{ fontSize: '0.85rem' }}>Tous les statuts</MenuItem>
                {Object.entries(STATUS_CFG).map(([key, cfg]) => (
                  <MenuItem key={key} value={key} sx={{ fontSize: '0.85rem' }}>
                    <Box sx={{ display: 'flex', alignItems: 'center', gap: 1 }}>
                      <Box sx={{ width: 8, height: 8, borderRadius: '50%', bgcolor: cfg.color, flexShrink: 0 }} />
                      {cfg.emoji} {cfg.label}
                    </Box>
                  </MenuItem>
                ))}
              </Select>
            </FormControl>
          </Grid>

          {/* Tournament */}
          <Grid item xs={12} sm={6} md={3}>
            <FormControl fullWidth size="small" disabled={tournaments.length === 0}>
              <InputLabel sx={{ fontSize: '0.85rem', '&.Mui-focused': { color: TEAL } }}>Tournoi</InputLabel>
              <Select label="Tournoi" value={tournamentId} onChange={e => setTournamentId(e.target.value)}
                sx={{ borderRadius: 2, fontSize: '0.85rem', ...selectSx }}>
                <MenuItem value="all" sx={{ fontSize: '0.85rem' }}>Tous les tournois</MenuItem>
                {tournaments.map(t => <MenuItem key={t.id} value={t.id} sx={{ fontSize: '0.85rem' }}>{t.name}</MenuItem>)}
              </Select>
            </FormControl>
          </Grid>

          {/* Date */}
          <Grid item xs={12} sm={6} md={3}>
            <FormControl fullWidth size="small">
              <InputLabel sx={{ fontSize: '0.85rem', '&.Mui-focused': { color: TEAL } }}>Période</InputLabel>
              <Select label="Période" value={dateRange} onChange={e => setDateRange(e.target.value)}
                sx={{ borderRadius: 2, fontSize: '0.85rem', ...selectSx }}>
                {dateOpts.map(o => (
                  <MenuItem key={o.value} value={o.value} disabled={o.disabled}
                    sx={{ fontSize: '0.85rem', ...(o.disabled ? { opacity: 0.35, minHeight: 'unset', py: 0.3 } : {}) }}>
                    {o.label}
                  </MenuItem>
                ))}
              </Select>
            </FormControl>
          </Grid>
        </Grid>

        {/* Active chips */}
        {activeCount > 0 && (
          <Box sx={{ display: 'flex', flexWrap: 'wrap', gap: 0.8, mt: 2, pt: 2, borderTop: '1px solid', borderColor: 'divider' }}>
            {search.trim() && (
              <Chip size="small" label={`Équipe : "${search}"`} onDelete={() => setSearch('')}
                sx={{ bgcolor: TEAL_PALE, color: TEAL_DARK, fontSize: '0.72rem', '& .MuiChip-deleteIcon': { color: TEAL, fontSize: 14 } }} />
            )}
            {statusFilter !== 'all' && (
              <Chip size="small" label={`${STATUS_CFG[statusFilter]?.emoji} ${STATUS_CFG[statusFilter]?.label}`}
                onDelete={() => setStatusFilter('all')}
                sx={{ bgcolor: TEAL_PALE, color: TEAL_DARK, fontSize: '0.72rem', '& .MuiChip-deleteIcon': { color: TEAL, fontSize: 14 } }} />
            )}
            {tournamentId !== 'all' && (
              <Chip size="small" label={`🏆 ${tournaments.find(t => t.id === tournamentId)?.name}`}
                onDelete={() => setTournamentId('all')}
                sx={{ bgcolor: TEAL_PALE, color: TEAL_DARK, fontSize: '0.72rem', '& .MuiChip-deleteIcon': { color: TEAL, fontSize: 14 } }} />
            )}
            {dateRange !== 'all' && (
              <Chip size="small" label={dateOpts.find(o => o.value === dateRange)?.label}
                onDelete={() => setDateRange('all')}
                sx={{ bgcolor: TEAL_PALE, color: TEAL_DARK, fontSize: '0.72rem', '& .MuiChip-deleteIcon': { color: TEAL, fontSize: 14 } }} />
            )}
          </Box>
        )}
      </Box>

      {/* Results count */}
      {activeCount > 0 && (
        <Typography sx={{ fontSize: '0.8rem', color: '#94a3b8', mb: 2.5, fontWeight: 500 }}>
          <Box component="span" sx={{ color: TEAL, fontWeight: 700 }}>{filtered.length}</Box>
          {' '}résultat{filtered.length > 1 ? 's' : ''} sur {matches.length} matchs
        </Typography>
      )}

      {/* Empty state */}
      {filtered.length === 0 && (
        <Box sx={{
          textAlign: 'center', py: 8, px: 4,
          bgcolor: 'background.paper', borderRadius: 3,
          border: '1px dashed',
          borderColor: 'divider',
        }}>
          <Box sx={{ fontSize: '3rem', mb: 1.5 }}>🔍</Box>
          <Typography sx={{ fontWeight: 700, fontSize: '1rem', color: 'text.primary', mb: 0.5 }}>
            Aucun match trouvé
          </Typography>
          <Typography sx={{ color: '#94a3b8', fontSize: '0.85rem', mb: 2.5 }}>
            Aucun match ne correspond à vos critères de recherche
          </Typography>
          <Button
            variant="outlined"
            onClick={resetFilters}
            sx={{ borderColor: TEAL, color: TEAL, textTransform: 'none', borderRadius: 2,
              '&:hover': { bgcolor: TEAL_PALE, borderColor: TEAL_DARK } }}
          >
            Réinitialiser les filtres
          </Button>
        </Box>
      )}

      {/* Match sections */}
      {filtered.length > 0 && (
        <>
          <Section emoji="🔴" title="En direct"  accentColor="#16a34a" items={live}     empty="Aucun match en cours"  defaultOpen />
          <Section emoji="📅" title="À venir"    accentColor="#3b82f6" items={upcoming} empty="Aucun match planifié"   defaultOpen />
          <Section emoji="✅" title="Terminés"   accentColor="#64748b" items={past}     empty="Aucun match terminé"    defaultOpen={!live.length && !upcoming.length} />
          {other.length > 0 && (
            <Section emoji="📋" title="Autres" accentColor="#8b5cf6" items={other} empty="" defaultOpen={false} />
          )}
        </>
      )}

      <style>{`
        @keyframes liveP {
          0%, 100% { opacity: 1; transform: scale(1); }
          50%       { opacity: 0.3; transform: scale(0.8); }
        }
      `}</style>
    </Box>
  );
}
