import React, { useEffect, useState } from 'react';
import { useNavigate } from 'react-router-dom';
import {
  Box, Grid, Card, Typography, Avatar, Chip,
  CircularProgress, Button, Stack,
} from '@mui/material';
import PeopleIcon        from '@mui/icons-material/People';
import BookmarkIcon      from '@mui/icons-material/Bookmark';
import AssessmentIcon    from '@mui/icons-material/Assessment';
import SportsSoccerIcon  from '@mui/icons-material/SportsSoccer';
import SearchIcon        from '@mui/icons-material/Search';
import BalanceIcon       from '@mui/icons-material/Balance';
import ArrowForwardIcon  from '@mui/icons-material/ArrowForward';
import { apiFetch }      from '../utils/api';
import { useAuth }       from '../contexts/AuthContext';

// ── Color constants ───────────────────────────────────────────────────────────
const TEAL      = '#0c9e96';
const TEAL_DARK = '#0a8880';
const TEAL_PALE = '#f0fdfa';

const STATUS_CFG = {
  scheduled:   { label: 'Planifié',  color: '#0c9e96', bg: '#dbeafe', dot: '#3b82f6' },
  in_progress: { label: 'En direct', color: '#16a34a', bg: '#dcfce7', dot: '#16a34a' },
  half_time:   { label: 'Mi-temps',  color: '#b45309', bg: '#fef9c3', dot: '#ca8a04' },
  completed:   { label: 'Terminé',   color: '#475569', bg: '#e2e8f0', dot: '#94a3b8' },
  postponed:   { label: 'Reporté',   color: '#6d28d9', bg: '#ede9fe', dot: '#8b5cf6' },
  cancelled:   { label: 'Annulé',    color: '#dc2626', bg: '#fee2e2', dot: '#ef4444' },
};

// ── Count-up hook ─────────────────────────────────────────────────────────────
const useCountUp = (target, duration = 900) => {
  const [count, setCount] = React.useState(0);
  React.useEffect(() => {
    if (!target || target === 0) { setCount(0); return; }
    const n = Number(target);
    if (isNaN(n)) { setCount(target); return; }
    let current = 0;
    const step = n / (duration / 16);
    const timer = setInterval(() => {
      current += step;
      if (current >= n) { setCount(n); clearInterval(timer); }
      else setCount(Math.floor(current));
    }, 16);
    return () => clearInterval(timer);
  }, [target, duration]);
  return count;
};

// ── Card interaction (mouse glow + color cycle + touch) ───────────────────────

const CARD_GLOW_COLORS = [
  'rgba(12,158,150,0.14)', 'rgba(99,102,241,0.14)',
  'rgba(245,158,11,0.14)', 'rgba(239,68,68,0.14)',
  'rgba(16,185,129,0.14)', 'rgba(168,85,247,0.14)',
  'rgba(236,72,153,0.14)', 'rgba(14,165,233,0.14)',
];

const useCardInteraction = () => {
  const [mouse, setMouse] = React.useState({ x: 0, y: 0 });
  const [hovered, setHovered] = React.useState(false);
  const [colorIdx, setColorIdx] = React.useState(0);
  const move = (clientX, clientY, el) => {
    const r = el.getBoundingClientRect();
    setMouse({ x: clientX - r.left, y: clientY - r.top });
  };
  return {
    mouse, hovered, glow: CARD_GLOW_COLORS[colorIdx],
    cycleColor: () => setColorIdx(i => (i + 1) % CARD_GLOW_COLORS.length),
    handlers: {
      onMouseMove:  (e) => move(e.clientX, e.clientY, e.currentTarget),
      onMouseEnter: () => setHovered(true),
      onMouseLeave: () => setHovered(false),
      onTouchStart: (e) => { const t = e.touches[0]; move(t.clientX, t.clientY, e.currentTarget); setHovered(true); },
      onTouchMove:  (e) => { const t = e.touches[0]; move(t.clientX, t.clientY, e.currentTarget); },
      onTouchEnd:   () => setHovered(false),
    },
  };
};

// ── KPI card ─────────────────────────────────────────────────────────────────
const KpiCard = ({ icon, label, value, sub, iconBg = 'rgba(12,158,150,0.10)', onClick, index = 0 }) => {
  const animated = useCountUp(typeof value === 'number' ? value : 0);
  const display = typeof value === 'number' ? animated : (value ?? '—');
  const { mouse, hovered, glow, cycleColor, handlers } = useCardInteraction();

  return (
    <Box sx={{
      animation: 'fadeInUp 0.35s ease both',
      animationDelay: `${index * 0.08}s`,
      '@keyframes fadeInUp': { from: { opacity: 0, transform: 'translateY(18px)' }, to: { opacity: 1, transform: 'translateY(0)' } },
    }}>
      <Card
        {...handlers}
        onClick={() => { cycleColor(); onClick?.(); }}
        sx={{
          border: '1px solid',
          borderColor: hovered ? 'rgba(12,158,150,0.30)' : 'divider',
          borderRadius: 3,
          boxShadow: hovered ? '0 20px 40px rgba(12,158,150,0.18)' : '0 1px 4px rgba(0,0,0,0.05)',
          bgcolor: 'background.paper',
          position: 'relative',
          overflow: 'hidden',
          cursor: 'pointer',
          transform: hovered ? 'translateY(-10px)' : 'translateY(0)',
          transition: 'transform 0.5s cubic-bezier(0.34,1.56,0.64,1), box-shadow 0.5s ease, border-color 0.3s ease',
        }}
      >
        {/* Mouse-tracking radial gradient spotlight */}
        <Box sx={{
          position: 'absolute', inset: 0, borderRadius: 'inherit',
          opacity: hovered ? 1 : 0,
          transition: 'opacity 0.5s',
          background: `radial-gradient(600px circle at ${mouse.x}px ${mouse.y}px, ${glow}, transparent 50%)`,
          pointerEvents: 'none',
          zIndex: 1,
        }} />
        <Box sx={{ p: 3, position: 'relative', zIndex: 2 }}>
          <Box sx={{
            width: 48, height: 48, borderRadius: 2,
            bgcolor: hovered ? glow : iconBg,
            display: 'flex', alignItems: 'center', justifyContent: 'center',
            mb: 2.5, transition: 'background 0.3s',
            '& svg': { fontSize: 24, color: '#0c9e96' },
          }}>
            {icon}
          </Box>
          <Typography sx={{ fontSize: '0.72rem', fontWeight: 600, textTransform: 'uppercase', letterSpacing: '0.06em', color: 'text.secondary', mb: 1 }}>
            {label}
          </Typography>
          <Typography sx={{ fontSize: '2.4rem', fontWeight: 800, color: 'text.primary', lineHeight: 1, mb: sub ? 0.75 : 0 }}>
            {display}
          </Typography>
          {sub && (
            <Typography sx={{ fontSize: '0.72rem', color: '#0c9e96', fontWeight: 500 }}>{sub}</Typography>
          )}
        </Box>
      </Card>
    </Box>
  );
};

// ── Section header ────────────────────────────────────────────────────────────
const Section = ({ title, action, onAction }) => (
  <Box sx={{ display: 'flex', alignItems: 'center', gap: 1, mb: 2 }}>
    <Box sx={{ width: 4, height: 20, borderRadius: 2, bgcolor: TEAL }} />
    <Typography sx={{ fontWeight: 700, fontSize: '1rem', flex: 1 }}>{title}</Typography>
    {action && (
      <Button size="small" endIcon={<ArrowForwardIcon sx={{ fontSize: 14 }} />}
        onClick={onAction}
        sx={{ fontSize: '0.75rem', color: TEAL, '&:hover': { bgcolor: TEAL_PALE } }}>
        {action}
      </Button>
    )}
  </Box>
);

// ── Match row ─────────────────────────────────────────────────────────────────
const MatchRow = ({ match, onClick }) => {
  const st = STATUS_CFG[match.status] || STATUS_CFG.scheduled;
  const isLive = match.status === 'in_progress' || match.status === 'half_time';
  const dateStr = match.date
    ? new Date(match.date).toLocaleString('fr-FR', { day: '2-digit', month: 'short', hour: '2-digit', minute: '2-digit' })
    : '—';

  return (
    <Box
      onClick={onClick}
      sx={{
        display: 'flex', alignItems: 'center', gap: 2,
        p: 1.5, borderRadius: 2, cursor: 'pointer',
        transition: 'background .15s',
        '&:hover': { bgcolor: TEAL_PALE },
      }}
    >
      {/* Teams column */}
      <Box sx={{ flex: 1, minWidth: 0 }}>
        <Typography sx={{ fontWeight: 700, fontSize: '0.875rem', whiteSpace: 'nowrap', overflow: 'hidden', textOverflow: 'ellipsis' }}>
          <Box component="span" sx={{ color: 'text.primary' }}>{match.homeTeam?.name || '?'}</Box>
          <Box component="span" sx={{ color: 'text.secondary', mx: 0.75, fontWeight: 400 }}>vs</Box>
          <Box component="span" sx={{ color: 'text.primary' }}>{match.awayTeam?.name || '?'}</Box>
        </Typography>
        <Typography sx={{ fontSize: '0.72rem', color: 'text.secondary', mt: 0.25 }}>
          {dateStr}{match.location ? ` · ${match.location}` : ''}
        </Typography>
      </Box>

      {/* Score (if live/done) */}
      {(isLive || match.status === 'completed') && (
        <Box sx={{
          minWidth: 52, textAlign: 'center', py: 0.4, px: 1,
          borderRadius: 1.5,
          background: isLive
            ? `linear-gradient(135deg, ${TEAL} 0%, ${TEAL_DARK} 100%)`
            : 'linear-gradient(135deg, #334155 0%, #1e293b 100%)',
        }}>
          <Typography sx={{ color: 'white', fontWeight: 900, fontSize: '0.85rem', letterSpacing: 1 }}>
            {match.homeTeamScore ?? 0} – {match.awayTeamScore ?? 0}
          </Typography>
        </Box>
      )}

      {/* Status chip */}
      <Chip
        size="small"
        label={
          <Box sx={{ display: 'flex', alignItems: 'center', gap: 0.5 }}>
            <Box sx={{
              width: 6, height: 6, borderRadius: '50%', bgcolor: st.dot,
              ...(isLive ? { animation: 'livePulse 1.5s infinite' } : {}),
            }} />
            {st.label}
          </Box>
        }
        sx={{
          bgcolor: st.bg, color: st.color,
          fontWeight: 600, fontSize: '0.7rem',
          height: 22, flexShrink: 0,
        }}
      />
    </Box>
  );
};

// ── Quick action button ───────────────────────────────────────────────────────
const QuickBtn = ({ icon, label, desc, color, onClick }) => (
  <Box
    onClick={onClick}
    sx={{
      display: 'flex', alignItems: 'center', gap: 2,
      p: 1.75, borderRadius: 2, cursor: 'pointer',
      border: `1px solid ${color}22`,
      transition: 'all .15s',
      '&:hover': { bgcolor: color + '0a', borderColor: color + '55', transform: 'translateX(3px)' },
    }}
  >
    <Box sx={{
      width: 40, height: 40, borderRadius: 2, flexShrink: 0,
      bgcolor: color + '18',
      display: 'flex', alignItems: 'center', justifyContent: 'center',
      fontSize: '1.2rem',
    }}>
      {icon}
    </Box>
    <Box sx={{ minWidth: 0 }}>
      <Typography sx={{ fontWeight: 700, fontSize: '0.875rem', color: 'text.primary' }}>{label}</Typography>
      <Typography sx={{ fontSize: '0.72rem', color: 'text.secondary' }}>{desc}</Typography>
    </Box>
    <ArrowForwardIcon sx={{ color: color, fontSize: 16, ml: 'auto', flexShrink: 0 }} />
  </Box>
);

// ── Main component ────────────────────────────────────────────────────────────
export default function Dashboard() {
  const { user } = useAuth();
  const navigate = useNavigate();
  const [stats, setStats]             = useState({ players: 0, matches: 0 });
  const [upcomingMatches, setUpcoming] = useState([]);
  const [liveMatches, setLive]         = useState([]);
  const [loading, setLoading]          = useState(true);
  const [watchlistCount, setWatchlistCount]     = useState(null);
  const [evaluationsCount, setEvaluationsCount] = useState(null);

  useEffect(() => {
    apiFetch('/scouts/me/watchlist').then(d => setWatchlistCount(d.watchlist?.length ?? 0)).catch(() => setWatchlistCount(0));
    apiFetch('/scouts/me/evaluations').then(d => setEvaluationsCount(d.evaluations?.length ?? 0)).catch(() => setEvaluationsCount(0));
  }, []);

  useEffect(() => {
    Promise.all([
      apiFetch('/players').catch(() => ({ players: [] })),
      apiFetch('/matches').catch(() => ({ matches: [] })),
    ]).then(([p, m]) => {
      const all = m.matches || [];
      setStats({ players: p.players?.length || 0, matches: all.length });

      const live = all.filter(x => x.status === 'in_progress' || x.status === 'half_time')
        .sort((a, b) => new Date(b.date) - new Date(a.date));
      const upcoming = all.filter(x => x.status === 'scheduled')
        .sort((a, b) => new Date(a.date) - new Date(b.date))
        .slice(0, 5);

      setLive(live);
      setUpcoming(upcoming);
    }).finally(() => setLoading(false));
  }, []);

  const hour = new Date().getHours();
  const greeting = hour < 12 ? 'Bonjour' : hour < 18 ? 'Bon après-midi' : 'Bonsoir';

  if (loading) return (
    <Box sx={{ display: 'flex', justifyContent: 'center', pt: 10 }}>
      <CircularProgress sx={{ color: TEAL }} />
    </Box>
  );

  return (
    <Box>

      {/* ── Page header ────────────────────────────────────────────────── */}
      <Box sx={{ mb: 3 }}>
        <Box sx={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', flexWrap: 'wrap', gap: 2 }}>
          <Box>
            <Typography sx={{ fontSize: '0.72rem', fontWeight: 600, textTransform: 'uppercase', letterSpacing: '0.06em', color: '#0c9e96', mb: 0.5 }}>
              Plateforme de Scouting
            </Typography>
            <Typography sx={{ fontWeight: 800, fontSize: '1.5rem', color: 'text.primary', lineHeight: 1.2 }}>
              {greeting}, {user?.name?.split(' ')[0] || 'Scout'}
            </Typography>
            <Typography sx={{ fontSize: '0.875rem', color: 'text.secondary', mt: 0.5 }}>
              {new Date().toLocaleDateString('fr-FR', { weekday: 'long', day: 'numeric', month: 'long', year: 'numeric' })}
            </Typography>
          </Box>
          {liveMatches.length > 0 && (
            <Chip
              onClick={() => navigate('/live')}
              label={
                <Box sx={{ display: 'flex', alignItems: 'center', gap: 0.75 }}>
                  <Box sx={{ width: 7, height: 7, borderRadius: '50%', bgcolor: '#4ade80', animation: 'livePulse 1.5s infinite' }} />
                  {liveMatches.length} match{liveMatches.length > 1 ? 's' : ''} en direct
                </Box>
              }
              sx={{ bgcolor: '#dcfce7', color: '#15803d', fontWeight: 700, fontSize: '0.8rem', height: 30, border: '1px solid #bbf7d0', cursor: 'pointer' }}
            />
          )}
        </Box>
      </Box>

      {/* ── KPI cards ──────────────────────────────────────────────────── */}
      <Grid container spacing={3} sx={{ mb: 4 }}>
        <Grid item xs={12} sm={6} md={3}>
          <KpiCard
            icon={<PeopleIcon />}
            label="Joueurs dans la base"
            value={stats.players}
            sub={watchlistCount != null ? `${watchlistCount} en watchlist` : null}
            onClick={() => navigate('/players')}
            index={0}
          />
        </Grid>
        <Grid item xs={12} sm={6} md={3}>
          <KpiCard
            icon={<SportsSoccerIcon />}
            label="Matchs en direct"
            value={liveMatches.length}
            sub={liveMatches.length > 0 ? 'Maintenant' : 'Aucun en cours'}
            iconBg="rgba(22,163,74,0.10)"
            onClick={() => navigate('/live')}
            index={1}
          />
        </Grid>
        <Grid item xs={12} sm={6} md={3}>
          <KpiCard
            icon={<BookmarkIcon />}
            label="Ma watchlist"
            value={watchlistCount ?? '—'}
            sub="joueurs suivis"
            iconBg="rgba(234,179,8,0.10)"
            onClick={() => navigate('/watchlist')}
            index={2}
          />
        </Grid>
        <Grid item xs={12} sm={6} md={3}>
          <KpiCard
            icon={<AssessmentIcon />}
            label="Évaluations"
            value={evaluationsCount ?? '—'}
            sub="ce mois"
            iconBg="rgba(124,58,237,0.10)"
            onClick={() => navigate('/evaluations')}
            index={3}
          />
        </Grid>
      </Grid>

      <Grid container spacing={3}>

        {/* ── Matchs ──────────────────────────────────────────────────── */}
        <Grid item xs={12} md={7}>

          {/* Live matches */}
          {liveMatches.length > 0 && (
            <Card sx={{ borderRadius: 3, mb: 3, border: `1px solid ${TEAL}33`, boxShadow: `0 0 0 3px ${TEAL}11` }}>
              <Box sx={{ px: 2.5, pt: 2, pb: 1 }}>
                <Section title="🔴 Matchs en direct" action="Voir tout" onAction={() => navigate('/live')} />
              </Box>
              <Box sx={{ px: 1.5, pb: 1.5 }}>
                {liveMatches.map(m => (
                  <MatchRow key={m.id} match={m} onClick={() => navigate('/live')} />
                ))}
              </Box>
            </Card>
          )}

          {/* Upcoming matches */}
          <Card sx={{ borderRadius: 3, border: '1px solid', borderColor: 'divider', boxShadow: 'none' }}>
            <Box sx={{ px: 2.5, pt: 2, pb: 1 }}>
              <Section title="Prochains matchs" action="Voir tout" onAction={() => navigate('/live')} />
            </Box>
            {upcomingMatches.length === 0 ? (
              <Box sx={{ py: 5, textAlign: 'center' }}>
                <Box sx={{ fontSize: '2.5rem', mb: 1 }}>📅</Box>
                <Typography color="text.secondary" fontSize="0.875rem">Aucun match planifié</Typography>
              </Box>
            ) : (
              <Box sx={{ px: 1.5, pb: 1.5 }}>
                {upcomingMatches.map(m => (
                  <MatchRow key={m.id} match={m} onClick={() => navigate('/live')} />
                ))}
              </Box>
            )}
          </Card>
        </Grid>

        {/* ── Quick actions ────────────────────────────────────────────── */}
        <Grid item xs={12} md={5}>
          <Card sx={{ borderRadius: 3, border: '1px solid', borderColor: 'divider', boxShadow: 'none' }}>
            <Box sx={{ px: 2.5, pt: 2, pb: 1 }}>
              <Section title="Accès rapides" />
            </Box>
            <Stack spacing={1.25} sx={{ px: 1.5, pb: 2 }}>
              <QuickBtn
                icon="🔍" color={TEAL}
                label="Rechercher un joueur"
                desc="Parcourir tous les profils"
                onClick={() => navigate('/players')}
              />
              <QuickBtn
                icon="⭐" color="#ca8a04"
                label="Ma watchlist"
                desc="Joueurs à suivre de près"
                onClick={() => navigate('/watchlist')}
              />
              <QuickBtn
                icon="📋" color="#7c3aed"
                label="Nouvelle évaluation"
                desc="Évaluer un joueur observé"
                onClick={() => navigate('/evaluations')}
              />
              <QuickBtn
                icon="⚖️" color="#16a34a"
                label="Comparer des joueurs"
                desc="Analyse côte à côte"
                onClick={() => navigate('/compare')}
              />
            </Stack>
          </Card>

          {/* Tip box */}
          <Box sx={{
            mt: 2, p: 2, borderRadius: 3,
            background: `linear-gradient(135deg, ${TEAL}15 0%, ${TEAL}08 100%)`,
            border: `1px solid ${TEAL}25`,
          }}>
            <Typography sx={{ fontWeight: 700, fontSize: '0.8rem', color: TEAL, mb: 0.5 }}>
              💡 Conseil du jour
            </Typography>
            <Typography sx={{ fontSize: '0.78rem', color: 'text.secondary', lineHeight: 1.5 }}>
              Utilisez le comparateur pour identifier les talents en analysant les statistiques clés côte à côte.
            </Typography>
            <Button size="small" onClick={() => navigate('/compare')}
              sx={{ mt: 1, color: TEAL, fontSize: '0.72rem', p: 0,
                '&:hover': { bgcolor: 'transparent', textDecoration: 'underline' } }}>
              Essayer le comparateur →
            </Button>
          </Box>
        </Grid>
      </Grid>

      <style>{`
        @keyframes livePulse { 0%,100%{opacity:1} 50%{opacity:0.25} }
      `}</style>
    </Box>
  );
}
