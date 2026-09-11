import React, { useEffect, useState, useCallback } from 'react';
import { useNavigate } from 'react-router-dom';
import {
  Box, Card, Typography, TextField, MenuItem, Grid,
  Avatar, Chip, CircularProgress, InputAdornment, Button,
  Table, TableBody, TableCell, TableHead, TableRow, TableContainer,
  IconButton, Tooltip,
} from '@mui/material';
import SearchIcon     from '@mui/icons-material/Search';
import BookmarkIcon   from '@mui/icons-material/BookmarkBorder';
import BookmarkedIcon from '@mui/icons-material/Bookmark';
import VisibilityIcon from '@mui/icons-material/Visibility';
import { apiFetch } from '../utils/api';
import { POSITION_CONFIG } from '../utils/positionConfig';

const POSITIONS = ['', 'gardien', 'defenseur', 'milieu', 'attaquant'];

export default function PlayerSearch() {
  const navigate = useNavigate();
  const [players, setPlayers] = useState([]);
  const [teams,   setTeams]   = useState([]);
  const [loading, setLoading] = useState(true);
  const [search,  setSearch]  = useState('');
  const [posFilter, setPosFilter] = useState('');
  const [teamFilter, setTeamFilter] = useState('');
  const [watchlist, setWatchlist] = useState([]);

  useEffect(() => {
    Promise.all([
      apiFetch('/players').catch(() => ({ players: [] })),
      apiFetch('/teams').catch(() => ({ teams: [] })),
      apiFetch('/scouts/me/watchlist').catch(() => ({ watchlist: [] })),
    ]).then(([p, t, w]) => {
      setPlayers(p.players || []);
      setTeams(t.teams || []);
      setWatchlist((w?.watchlist || []).map(it => Number(it.playerId)));
    }).finally(() => setLoading(false));
  }, []);

  const toggleWatchlist = useCallback(async (id) => {
    const nid = Number(id);
    const isIn = watchlist.includes(nid);
    setWatchlist(prev => isIn ? prev.filter(x => x !== nid) : [...prev, nid]);
    try {
      if (isIn) {
        await apiFetch(`/scouts/me/watchlist/${nid}`, { method: 'DELETE' });
      } else {
        await apiFetch('/scouts/me/watchlist', {
          method: 'POST',
          body: JSON.stringify({ playerId: nid }),
        });
      }
    } catch {
      setWatchlist(prev => isIn ? [...prev, nid] : prev.filter(x => x !== nid));
    }
  }, [watchlist]);

  const filtered = players.filter(p => {
    const q = search.toLowerCase();
    if (q && !p.name?.toLowerCase().includes(q)) return false;
    if (posFilter && p.position !== posFilter) return false;
    if (teamFilter && String(p.teamId ?? p.team?.id) !== String(teamFilter)) return false;
    return true;
  });

  if (loading) return <Box sx={{ display: 'flex', justifyContent: 'center', pt: 8 }}><CircularProgress /></Box>;

  return (
    <Box>
      <Box sx={{ mb: 3 }}>
        <Typography sx={{ fontSize: '0.72rem', fontWeight: 600, textTransform: 'uppercase', letterSpacing: '0.06em', color: '#0c9e96', mb: 0.5 }}>
          Scouting
        </Typography>
        <Typography sx={{ fontWeight: 800, fontSize: '1.5rem', color: 'text.primary', lineHeight: 1.2 }}>
          Recherche de joueurs
        </Typography>
        <Typography sx={{ fontSize: '0.875rem', color: 'text.secondary', mt: 0.5 }}>
          {players.length} joueurs dans la base
        </Typography>
      </Box>

      {/* Filtres */}
      <Card sx={{ p: 2, mb: 3 }}>
        <Grid container spacing={2} alignItems="center">
          <Grid item xs={12} sm={5}>
            <TextField fullWidth placeholder="Rechercher un joueur…" value={search}
              onChange={e => setSearch(e.target.value)}
              InputProps={{ startAdornment: <InputAdornment position="start"><SearchIcon sx={{ color: 'text.secondary' }} /></InputAdornment> }} />
          </Grid>
          <Grid item xs={6} sm={3}>
            <TextField select fullWidth label="Poste" value={posFilter} onChange={e => setPosFilter(e.target.value)}>
              <MenuItem value="">Tous les postes</MenuItem>
              {POSITIONS.filter(Boolean).map(p => <MenuItem key={p} value={p}>{POSITION_CONFIG[p]?.label || p}</MenuItem>)}
            </TextField>
          </Grid>
          <Grid item xs={6} sm={3}>
            <TextField select fullWidth label="Équipe" value={teamFilter} onChange={e => setTeamFilter(e.target.value)}>
              <MenuItem value="">Toutes les équipes</MenuItem>
              {teams.map(t => <MenuItem key={t.id} value={t.id}>{t.name}</MenuItem>)}
            </TextField>
          </Grid>
          <Grid item xs={12} sm={1}>
            <Button fullWidth variant="outlined" onClick={() => { setSearch(''); setPosFilter(''); setTeamFilter(''); }}>
              Reset
            </Button>
          </Grid>
        </Grid>
      </Card>

      {/* Résultats */}
      <Card>
        <Box sx={{ px: 2.5, py: 1.75, borderBottom: '1px solid', borderColor: 'divider', display: 'flex', alignItems: 'center', gap: 1 }}>
          <Typography sx={{ fontWeight: 700, fontSize: '0.9rem', flex: 1 }}>Résultats</Typography>
          <Chip label={filtered.length} size="small" sx={{ fontWeight: 700 }} />
        </Box>
        {filtered.length === 0 ? (
          <Box sx={{ py: 6, textAlign: 'center' }}>
            <Typography color="text.secondary">Aucun joueur trouvé</Typography>
          </Box>
        ) : (
          <TableContainer>
            <Table>
              <TableHead>
                <TableRow sx={{ bgcolor: 'background.default' }}>
                  {['Joueur', 'Poste', 'Équipe', 'N°', 'Pied', 'Actions'].map(h => (
                    <TableCell key={h} sx={{ fontWeight: 700, fontSize: '0.78rem', color: 'text.secondary', textTransform: 'uppercase', letterSpacing: '0.04em' }}>{h}</TableCell>
                  ))}
                </TableRow>
              </TableHead>
              <TableBody>
                {filtered.map(p => {
                  const pos = POSITION_CONFIG[p.position];
                  const inWatchlist = watchlist.includes(Number(p.id));
                  return (
                    <TableRow key={p.id} sx={{ '&:hover': { bgcolor: 'action.hover' }, '& td': { py: 1.5 } }}>
                      <TableCell>
                        <Box sx={{ display: 'flex', alignItems: 'center', gap: 1.5 }}>
                          <Avatar sx={{ width: 34, height: 34, bgcolor: '#dbeafe', color: '#0a8880', fontSize: '0.8rem', fontWeight: 700 }}>
                            {p.name?.[0]?.toUpperCase() || '?'}
                          </Avatar>
                          <Box>
                            <Typography sx={{ fontWeight: 600, fontSize: '0.875rem' }}>{p.name}</Typography>
                            {p.age && <Typography sx={{ fontSize: '0.72rem', color: 'text.secondary' }}>{p.age} ans</Typography>}
                          </Box>
                        </Box>
                      </TableCell>
                      <TableCell>
                        {pos ? <Chip label={pos.label} size="small" sx={{ bgcolor: pos.bg, color: pos.color, fontWeight: 600, fontSize: '0.72rem' }} /> : '—'}
                      </TableCell>
                      <TableCell sx={{ fontSize: '0.875rem', color: 'text.secondary' }}>{p.team?.name || '—'}</TableCell>
                      <TableCell sx={{ fontSize: '0.875rem', color: 'text.secondary' }}>{p.jerseyNumber ? `#${p.jerseyNumber}` : '—'}</TableCell>
                      <TableCell sx={{ fontSize: '0.875rem', color: 'text.secondary' }}>{p.preferredFoot === 'right' ? '🦶 Droit' : p.preferredFoot === 'left' ? '🦶 Gauche' : '—'}</TableCell>
                      <TableCell>
                        <Box sx={{ display: 'flex', gap: 0.5 }}>
                          <Tooltip title="Voir la fiche">
                            <IconButton size="small" onClick={() => navigate(`/players/${p.id}`)} sx={{ color: '#0c9e96' }}>
                              <VisibilityIcon fontSize="small" />
                            </IconButton>
                          </Tooltip>
                          <Tooltip title={inWatchlist ? 'Retirer de la watchlist' : 'Ajouter à la watchlist'}>
                            <IconButton size="small" onClick={() => toggleWatchlist(p.id)} sx={{ color: inWatchlist ? '#ca8a04' : '#94a3b8' }}>
                              {inWatchlist ? <BookmarkedIcon fontSize="small" /> : <BookmarkIcon fontSize="small" />}
                            </IconButton>
                          </Tooltip>
                        </Box>
                      </TableCell>
                    </TableRow>
                  );
                })}
              </TableBody>
            </Table>
          </TableContainer>
        )}
      </Card>
    </Box>
  );
}
