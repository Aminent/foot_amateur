import React, { useEffect, useState } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import {
  Box, Card, CardContent, Grid, Typography, Avatar, Chip,
  CircularProgress, Alert, IconButton, Tooltip, Divider, Button,
} from '@mui/material';
import ArrowBackIcon  from '@mui/icons-material/ArrowBack';
import BookmarkIcon   from '@mui/icons-material/BookmarkBorder';
import BookmarkedIcon from '@mui/icons-material/Bookmark';
import AddIcon        from '@mui/icons-material/Add';
import {
  RadarChart, Radar, PolarGrid, PolarAngleAxis, PolarRadiusAxis,
  ResponsiveContainer, Tooltip as RTooltip,
} from 'recharts';
import { apiFetch } from '../utils/api';
import { POSITION_CONFIG } from '../utils/positionConfig';

const StatBox = ({ label, value, color = '#0c9e96' }) => (
  <Box sx={{ textAlign: 'center', p: 1.5, borderRadius: 2, bgcolor: 'background.default', border: '1px solid', borderColor: 'divider' }}>
    <Typography sx={{ fontSize: '1.5rem', fontWeight: 800, color }}>{value ?? '—'}</Typography>
    <Typography sx={{ fontSize: '0.72rem', color: 'text.secondary', mt: 0.25 }}>{label}</Typography>
  </Box>
);

export default function PlayerProfile() {
  const { id } = useParams();
  const navigate = useNavigate();
  const [player, setPlayer] = useState(null);
  const [stats,  setStats]  = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');
  const [inWatchlist, setInWatchlist] = useState(false);
  const [wlLoading,   setWlLoading]   = useState(false);

  useEffect(() => {
    Promise.all([
      apiFetch(`/players/${id}`).catch(() => null),
      apiFetch(`/player-stats/${id}`).catch(() => null),
      apiFetch('/scouts/me/watchlist').catch(() => ({ watchlist: [] })),
    ]).then(([p, s, w]) => {
      if (!p) { setError('Joueur introuvable'); return; }
      setPlayer(p.player);
      setStats(s?.stats ?? null);
      const ids = (w?.watchlist || []).map(it => Number(it.playerId));
      setInWatchlist(ids.includes(Number(id)));
    }).catch(() => setError('Erreur de chargement'))
      .finally(() => setLoading(false));
  }, [id]);

  const toggleWatchlist = async () => {
    setWlLoading(true);
    try {
      if (inWatchlist) {
        await apiFetch(`/scouts/me/watchlist/${id}`, { method: 'DELETE' });
      } else {
        await apiFetch('/scouts/me/watchlist', {
          method: 'POST',
          body: JSON.stringify({ playerId: Number(id) }),
        });
      }
      setInWatchlist(prev => !prev);
    } catch (e) {
      setError('Erreur watchlist : ' + (e.message || 'Réessayez.'));
    } finally {
      setWlLoading(false);
    }
  };

  if (loading) return <Box sx={{ display: 'flex', justifyContent: 'center', pt: 8 }}><CircularProgress /></Box>;
  if (error)   return <Box sx={{ p: 3 }}><Alert severity="error">{error}</Alert></Box>;

  const pos = POSITION_CONFIG[player?.position];

  // Données radar — normaliser sur 100
  const radarData = stats ? [
    { subject: 'Buts',       value: Math.min((stats.goals || 0) * 10, 100) },
    { subject: 'Passes D.',  value: Math.min((stats.assists || 0) * 10, 100) },
    { subject: 'Cartons',    value: Math.max(100 - ((stats.yellowCards || 0) + (stats.redCards || 0)) * 20, 0) },
    { subject: 'Minutes',    value: Math.min(Math.round((stats.minutesPlayed || 0) / 10), 100) },
    { subject: 'Tirs',       value: Math.min((stats.shots || 0) * 5, 100) },
    { subject: 'Tacles',     value: Math.min((stats.tackles || 0) * 5, 100) },
  ] : [];

  return (
    <Box>
      {/* Header */}
      <Box sx={{ display: 'flex', alignItems: 'center', gap: 1, mb: 3 }}>
        <IconButton onClick={() => navigate(-1)} size="small"><ArrowBackIcon /></IconButton>
        <Typography sx={{ fontWeight: 700, fontSize: '1rem', flex: 1 }}>Fiche joueur</Typography>
        <Tooltip title={inWatchlist ? 'Retirer de la watchlist' : 'Ajouter à la watchlist'}>
          <IconButton onClick={toggleWatchlist} sx={{ color: inWatchlist ? '#ca8a04' : '#94a3b8' }}>
            {inWatchlist ? <BookmarkedIcon /> : <BookmarkIcon />}
          </IconButton>
        </Tooltip>
        <Button variant="contained" startIcon={<AddIcon />} size="small"
          onClick={() => navigate(`/evaluations/new?playerId=${id}`)}
          sx={{ bgcolor: '#0c9e96', '&:hover': { bgcolor: '#0a8880' } }}>
          Évaluer
        </Button>
      </Box>

      <Grid container spacing={3}>
        {/* Identité */}
        <Grid item xs={12} md={4}>
          <Card>
            <CardContent sx={{ textAlign: 'center', p: 3 }}>
              <Avatar sx={{ width: 80, height: 80, bgcolor: '#0c9e96', mx: 'auto', mb: 2, fontSize: '2rem', fontWeight: 800 }}>
                {player?.name?.[0]?.toUpperCase() || '?'}
              </Avatar>
              <Typography variant="h6" sx={{ fontWeight: 800 }}>{player?.name}</Typography>
              {pos && <Chip label={pos.label} size="small" sx={{ bgcolor: pos.bg, color: pos.color, mt: 1, fontWeight: 600 }} />}

              <Divider sx={{ my: 2 }} />

              {[
                { label: 'Équipe',    value: player?.team?.name || '—' },
                { label: 'N° maillot', value: player?.jerseyNumber ? `#${player.jerseyNumber}` : '—' },
                { label: 'Pied',      value: player?.preferredFoot === 'right' ? 'Droit' : player?.preferredFoot === 'left' ? 'Gauche' : '—' },
                { label: 'Âge',       value: player?.age ? `${player.age} ans` : '—' },
                { label: 'Taille',    value: player?.height ? `${player.height} cm` : '—' },
                { label: 'Poids',     value: player?.weight ? `${player.weight} kg` : '—' },
              ].map(({ label, value }) => (
                <Box key={label} sx={{ display: 'flex', justifyContent: 'space-between', py: 0.75 }}>
                  <Typography sx={{ fontSize: '0.82rem', color: 'text.secondary' }}>{label}</Typography>
                  <Typography sx={{ fontSize: '0.82rem', fontWeight: 600 }}>{value}</Typography>
                </Box>
              ))}
            </CardContent>
          </Card>
        </Grid>

        {/* Stats + Radar */}
        <Grid item xs={12} md={8}>
          {/* Stats numériques */}
          <Card sx={{ mb: 3 }}>
            <Box sx={{ px: 2.5, py: 2, borderBottom: '1px solid', borderColor: 'divider' }}>
              <Typography sx={{ fontWeight: 700, fontSize: '0.9rem' }}>Statistiques</Typography>
            </Box>
            <CardContent>
              {!stats ? (
                <Typography color="text.secondary" fontSize="0.875rem" sx={{ textAlign: 'center', py: 2 }}>
                  Aucune statistique disponible
                </Typography>
              ) : (
                <Grid container spacing={1.5}>
                  {[
                    { label: 'Buts',      value: stats.goals,         color: '#16a34a' },
                    { label: 'Passes D.', value: stats.assists,       color: '#0c9e96' },
                    { label: 'Minutes',   value: stats.minutesPlayed, color: '#7c3aed' },
                    { label: 'Tirs',      value: stats.shots,         color: '#ca8a04' },
                    { label: 'Tacles',    value: stats.tackles,       color: '#0891b2' },
                    { label: 'Cartons J.',value: stats.yellowCards,   color: '#ca8a04' },
                    { label: 'Cartons R.',value: stats.redCards,      color: '#dc2626' },
                    { label: 'Arrêts',    value: stats.saves,         color: '#16a34a' },
                  ].map(s => (
                    <Grid item xs={6} sm={3} key={s.label}>
                      <StatBox {...s} />
                    </Grid>
                  ))}
                </Grid>
              )}
            </CardContent>
          </Card>

          {/* Radar chart */}
          {radarData.length > 0 && (
            <Card>
              <Box sx={{ px: 2.5, py: 2, borderBottom: '1px solid', borderColor: 'divider' }}>
                <Typography sx={{ fontWeight: 700, fontSize: '0.9rem' }}>Profil radar</Typography>
              </Box>
              <CardContent>
                <ResponsiveContainer width="100%" height={260}>
                  <RadarChart data={radarData}>
                    <PolarGrid stroke="#e2e8f0" />
                    <PolarAngleAxis dataKey="subject" tick={{ fontSize: 12, fill: '#64748b' }} />
                    <PolarRadiusAxis angle={90} domain={[0, 100]} tick={false} axisLine={false} />
                    <Radar name="Joueur" dataKey="value" stroke="#1d4ed8" fill="#1d4ed8" fillOpacity={0.25} strokeWidth={2} />
                    <RTooltip />
                  </RadarChart>
                </ResponsiveContainer>
              </CardContent>
            </Card>
          )}
        </Grid>
      </Grid>
    </Box>
  );
}
