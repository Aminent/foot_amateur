import React, { useEffect, useState, useCallback } from 'react';
import { useNavigate } from 'react-router-dom';
import {
  Box, Card, Typography, Avatar, Chip, CircularProgress, Alert,
  IconButton, Tooltip, Grid, Button,
} from '@mui/material';
import VisibilityIcon from '@mui/icons-material/Visibility';
import BookmarkIcon   from '@mui/icons-material/Bookmark';
import AddIcon        from '@mui/icons-material/Add';
import { apiFetch } from '../utils/api';
import { POSITION_CONFIG } from '../utils/positionConfig';

export default function Watchlist() {
  const navigate = useNavigate();
  const [items,   setItems]   = useState([]); // [{ id, playerId, player: {...} }]
  const [loading, setLoading] = useState(true);
  const [error,   setError]   = useState('');

  const loadWatchlist = useCallback(async () => {
    try {
      const data = await apiFetch('/scouts/me/watchlist');
      setItems(data.watchlist || []);
    } catch (e) {
      setError('Impossible de charger la watchlist.');
    } finally {
      setLoading(false);
    }
  }, []);

  useEffect(() => { loadWatchlist(); }, [loadWatchlist]);

  const remove = async (playerId) => {
    try {
      await apiFetch(`/scouts/me/watchlist/${playerId}`, { method: 'DELETE' });
      setItems(prev => prev.filter(it => Number(it.playerId) !== Number(playerId)));
    } catch (e) {
      setError('Impossible de retirer le joueur.');
    }
  };

  const playerName = (p) =>
    p?.name || (p?.user ? `${p.user.firstName} ${p.user.lastName}` : '?');

  if (loading) return <Box sx={{ display: 'flex', justifyContent: 'center', pt: 8 }}><CircularProgress /></Box>;

  return (
    <Box>
      <Box sx={{ display: 'flex', alignItems: 'flex-start', justifyContent: 'space-between', flexWrap: 'wrap', gap: 2, mb: 3 }}>
        <Box>
          <Typography sx={{ fontSize: '0.72rem', fontWeight: 600, textTransform: 'uppercase', letterSpacing: '0.06em', color: '#0c9e96', mb: 0.5 }}>
            Scouting
          </Typography>
          <Typography sx={{ fontWeight: 800, fontSize: '1.5rem', color: 'text.primary', lineHeight: 1.2 }}>
            Ma Watchlist
          </Typography>
          <Typography sx={{ fontSize: '0.875rem', color: 'text.secondary', mt: 0.5 }}>
            {items.length} joueur{items.length > 1 ? 's' : ''} suivi{items.length > 1 ? 's' : ''}
          </Typography>
        </Box>
        <Button variant="outlined" onClick={() => navigate('/players')} startIcon={<AddIcon />}>
          Ajouter
        </Button>
      </Box>

      {error && <Alert severity="error" sx={{ mb: 2 }} onClose={() => setError('')}>{error}</Alert>}

      {items.length === 0 ? (
        <Card sx={{ py: 8, textAlign: 'center' }}>
          <BookmarkIcon sx={{ fontSize: 48, color: '#e2e8f0', mb: 2 }} />
          <Typography color="text.secondary" sx={{ mb: 2 }}>Votre watchlist est vide</Typography>
          <Button variant="contained" onClick={() => navigate('/players')} sx={{ bgcolor: '#0c9e96' }}>
            Rechercher des joueurs
          </Button>
        </Card>
      ) : (
        <Grid container spacing={2}>
          {items.map(({ id, playerId, player }) => {
            const name = playerName(player);
            const pos  = POSITION_CONFIG[player?.position];
            return (
              <Grid item xs={12} sm={6} md={4} key={id}>
                <Card sx={{ p: 2.5, display: 'flex', gap: 2, alignItems: 'flex-start' }}>
                  <Avatar sx={{ width: 48, height: 48, bgcolor: '#0c9e96', fontWeight: 700, fontSize: '1.1rem', flexShrink: 0 }}>
                    {name[0]?.toUpperCase() || '?'}
                  </Avatar>
                  <Box sx={{ flex: 1, minWidth: 0 }}>
                    <Typography sx={{ fontWeight: 700, fontSize: '0.95rem' }} noWrap>{name}</Typography>
                    <Typography sx={{ fontSize: '0.78rem', color: 'text.secondary' }}>
                      {player?.team?.name || 'Sans équipe'}
                    </Typography>
                    {pos && (
                      <Chip label={pos.label} size="small" sx={{ bgcolor: pos.bg, color: pos.color, mt: 0.75, fontWeight: 600, height: 20, fontSize: '0.68rem' }} />
                    )}
                  </Box>
                  <Box sx={{ display: 'flex', flexDirection: 'column', gap: 0.5 }}>
                    <Tooltip title="Voir la fiche">
                      <IconButton size="small" onClick={() => navigate(`/players/${playerId}`)} sx={{ color: '#0c9e96' }}>
                        <VisibilityIcon fontSize="small" />
                      </IconButton>
                    </Tooltip>
                    <Tooltip title="Retirer de la watchlist">
                      <IconButton size="small" onClick={() => remove(playerId)} sx={{ color: '#ca8a04' }}>
                        <BookmarkIcon fontSize="small" />
                      </IconButton>
                    </Tooltip>
                  </Box>
                </Card>
              </Grid>
            );
          })}
        </Grid>
      )}
    </Box>
  );
}
