import React, { useState, useEffect, useRef, useMemo } from 'react';
import { authHeaders } from '../utils/api';
import { useParams, useNavigate } from 'react-router-dom';
import { io } from 'socket.io-client';
import {
  Box, Grid, Card, CardContent, Typography, Button,
  Table, TableBody, TableCell, TableHead, TableRow,
  IconButton, Chip, Alert, Divider, Paper, List,
  ListItem, ListItemText, ListItemIcon, Dialog, DialogTitle,
  DialogContent, DialogActions, FormControl, InputLabel,
  Select, MenuItem, Tab, Tabs, Avatar, LinearProgress, Tooltip,
} from '@mui/material';
import {
  ArrowBack as ArrowBackIcon,
  EmojiEvents as TrophyIcon,
  Group as GroupIcon,
  Add as AddIcon,
  Remove as RemoveIcon,
  Sports as SportsIcon,
  CalendarToday as CalendarIcon,
  LocationOn as LocationIcon,
  Assessment as AssessmentIcon,
  AccountTree as BracketIcon,
  Visibility as VisibilityIcon,
  SportsSoccer as GoalIcon,
  Star as StarIcon,
} from '@mui/icons-material';

/* ─── helpers ─────────────────────────────────────────────────────────────── */

const API = process.env.REACT_APP_API_URL || 'http://localhost:5000/api';
const WS  = process.env.REACT_APP_API_URL
  ? process.env.REACT_APP_API_URL.replace('/api', '')
  : window.location.origin;

const fmt = (d) => d ? new Date(d).toLocaleDateString('fr-FR') : 'Non défini';

const STATUS_LABEL = { draft:'Brouillon', active:'Actif', completed:'Terminé', cancelled:'Annulé' };
const STATUS_COLOR = { draft:'default', active:'success', completed:'info', cancelled:'error' };
const FORMAT_LABEL = { league:'Championnat', knockout:'Élimination directe', group_then_knockout:'Poules + élimination' };

const ROUND_NAMES = (r, total) => {
  if (r === total)     return 'Finale';
  if (r === total - 1) return 'Demi-finales';
  if (r === total - 2) return 'Quarts de finale';
  if (r === total - 3) return 'Huitièmes de finale';
  return `Tour ${r}`;
};

/* ─── standings computation ──────────────────────────────────────────────── */

const computeStandings = (matches, teams) => {
  const rows = {};
  teams.forEach(t => {
    rows[t.id] = { id: t.id, name: t.name, P: 0, W: 0, D: 0, L: 0, GF: 0, GA: 0, GD: 0, Pts: 0 };
  });

  matches.filter(m => m.status === 'completed').forEach(m => {
    const h = rows[m.homeTeamId];
    const a = rows[m.awayTeamId];
    if (!h || !a) return;
    const hg = m.homeTeamScore ?? 0;
    const ag = m.awayTeamScore ?? 0;

    h.P++; h.GF += hg; h.GA += ag; h.GD += hg - ag;
    a.P++; a.GF += ag; a.GA += hg; a.GD += ag - hg;

    if (hg > ag) { h.W++; h.Pts += 3; a.L++; }
    else if (hg < ag) { a.W++; a.Pts += 3; h.L++; }
    else { h.D++; h.Pts++; a.D++; a.Pts++; }
  });

  return Object.values(rows).sort((a, b) =>
    b.Pts - a.Pts || b.GD - a.GD || b.GF - a.GF || a.name.localeCompare(b.name)
  );
};

/* ─── top scorers computation ─────────────────────────────────────────────── */

const computeScorers = (matches) => {
  const map = {};
  matches.forEach(m => {
    (m.events || []).forEach(ev => {
      if (!['goal', 'penalty_goal'].includes(ev.type)) return;
      const name = ev.relatedPlayerName || 'Inconnu';
      const team = ev.isHomeTeam
        ? (m.homeTeam?.name || '?')
        : (m.awayTeam?.name || '?');
      const key = `${name}__${team}`;
      if (!map[key]) map[key] = { name, team, goals: 0 };
      map[key].goals++;
    });
  });
  return Object.values(map).sort((a, b) => b.goals - a.goals);
};

/* ─── sub-components ─────────────────────────────────────────────────────── */

const TabPanel = ({ children, value, index }) => (
  <div hidden={value !== index}>
    {value === index && <Box sx={{ p: 3 }}>{children}</Box>}
  </div>
);

/* Standings table */
const StandingsTable = ({ standings }) => {
  if (!standings.length) return (
    <Paper sx={{ p: 4, textAlign: 'center' }}>
      <Typography color="text.secondary">
        Aucun match terminé — le classement sera disponible dès le premier résultat enregistré.
      </Typography>
    </Paper>
  );
  return (
    <Box sx={{ overflowX: 'auto' }}>
      <Table size="small">
        <TableHead>
          <TableRow sx={{ bgcolor: '#f1f5f9' }}>
            <TableCell sx={{ fontWeight: 700, width: 36 }}>#</TableCell>
            <TableCell sx={{ fontWeight: 700 }}>Équipe</TableCell>
            {['J','V','N','D','BP','BC','DB','Pts'].map(h => (
              <TableCell key={h} align="center" sx={{ fontWeight: 700, minWidth: 36 }}>
                <Tooltip title={{ J:'Joués', V:'Victoires', N:'Nuls', D:'Défaites', BP:'Buts pour', BC:'Buts contre', DB:'Différence', Pts:'Points' }[h]}>
                  <span>{h}</span>
                </Tooltip>
              </TableCell>
            ))}
          </TableRow>
        </TableHead>
        <TableBody>
          {standings.map((row, i) => {
            const podium = i === 0 ? '#f59e0b' : i === 1 ? '#94a3b8' : i === 2 ? '#b45309' : 'transparent';
            return (
              <TableRow key={row.id} hover sx={{ bgcolor: i < 3 ? `${podium}11` : undefined }}>
                <TableCell>
                  <Box sx={{ width: 24, height: 24, borderRadius: '50%', bgcolor: i < 3 ? podium : '#e2e8f0',
                    display: 'flex', alignItems: 'center', justifyContent: 'center',
                    color: i < 3 ? 'white' : '#64748b', fontSize: 12, fontWeight: 700 }}>
                    {i + 1}
                  </Box>
                </TableCell>
                <TableCell sx={{ fontWeight: i < 3 ? 700 : 400 }}>{row.name}</TableCell>
                <TableCell align="center">{row.P}</TableCell>
                <TableCell align="center" sx={{ color: '#16a34a', fontWeight: 600 }}>{row.W}</TableCell>
                <TableCell align="center">{row.D}</TableCell>
                <TableCell align="center" sx={{ color: '#dc2626' }}>{row.L}</TableCell>
                <TableCell align="center">{row.GF}</TableCell>
                <TableCell align="center">{row.GA}</TableCell>
                <TableCell align="center" sx={{ color: row.GD > 0 ? '#16a34a' : row.GD < 0 ? '#dc2626' : undefined, fontWeight: 600 }}>
                  {row.GD > 0 ? `+${row.GD}` : row.GD}
                </TableCell>
                <TableCell align="center">
                  <Box sx={{ bgcolor: '#3b82f6', color: 'white', borderRadius: 1, px: 1, py: 0.25,
                    fontWeight: 800, fontSize: 14, display: 'inline-block', minWidth: 32, textAlign: 'center' }}>
                    {row.Pts}
                  </Box>
                </TableCell>
              </TableRow>
            );
          })}
        </TableBody>
      </Table>
    </Box>
  );
};

/* Top scorers */
const TopScorers = ({ scorers }) => {
  if (!scorers.length) return (
    <Paper sx={{ p: 3, textAlign: 'center' }}>
      <Typography color="text.secondary" fontSize={14}>
        Aucun buteur enregistré pour l'instant.
      </Typography>
    </Paper>
  );
  const max = scorers[0]?.goals || 1;
  return (
    <Box>
      {scorers.slice(0, 10).map((s, i) => (
        <Box key={i} sx={{ display: 'flex', alignItems: 'center', gap: 1.5, mb: 1.25 }}>
          <Box sx={{ width: 24, textAlign: 'center', color: '#94a3b8', fontSize: 12, fontWeight: 700 }}>
            {i === 0 ? '🥇' : i === 1 ? '🥈' : i === 2 ? '🥉' : i + 1}
          </Box>
          <Avatar sx={{ width: 30, height: 30, bgcolor: '#3b82f6', fontSize: 12, fontWeight: 700 }}>
            {s.name[0]?.toUpperCase()}
          </Avatar>
          <Box sx={{ flex: 1, minWidth: 0 }}>
            <Typography fontSize={13} fontWeight={600} noWrap>{s.name}</Typography>
            <Typography fontSize={11} color="text.secondary" noWrap>{s.team}</Typography>
            <LinearProgress
              variant="determinate"
              value={(s.goals / max) * 100}
              sx={{ height: 4, borderRadius: 2, mt: 0.4, bgcolor: '#e2e8f0',
                '& .MuiLinearProgress-bar': { bgcolor: '#3b82f6' } }}
            />
          </Box>
          <Box sx={{ display: 'flex', alignItems: 'center', gap: 0.5, bgcolor: '#f1f5f9',
            borderRadius: 1.5, px: 1, py: 0.4 }}>
            <GoalIcon sx={{ fontSize: 14, color: '#64748b' }} />
            <Typography fontSize={14} fontWeight={800}>{s.goals}</Typography>
          </Box>
        </Box>
      ))}
    </Box>
  );
};

/* Visual bracket — one column per round */
const VisualBracket = ({ bracketRounds, openSchedule, openScore }) => {
  const roundKeys = Object.keys(bracketRounds).map(Number).sort((a, b) => a - b);
  const total = roundKeys.length;
  if (!total) return (
    <Paper sx={{ p: 3, textAlign: 'center' }}>
      <Typography>Le tableau n'est pas encore généré.</Typography>
    </Paper>
  );

  return (
    <Box sx={{ overflowX: 'auto', pb: 2 }}>
      <Box sx={{ display: 'flex', gap: 0, minWidth: total * 260 }}>
        {roundKeys.map((rNum) => {
          const matches = bracketRounds[rNum] || [];
          const label = ROUND_NAMES(rNum, total);
          return (
            <Box key={rNum} sx={{ flex: '0 0 260px', display: 'flex', flexDirection: 'column' }}>
              {/* Round header */}
              <Box sx={{ textAlign: 'center', py: 1.25, mb: 1,
                bgcolor: '#0f172a', color: 'white', borderRadius: '6px 6px 0 0', mx: 1 }}>
                <Typography fontSize={12} fontWeight={700} letterSpacing={0.5}
                  textTransform="uppercase">{label}</Typography>
              </Box>

              {/* Matches vertically centered with flex spacing */}
              <Box sx={{ flex: 1, display: 'flex', flexDirection: 'column',
                justifyContent: 'space-around', px: 1, gap: 2 }}>
                {matches.map((m) => {
                  const hWin = m.status === 'completed' && m.homeTeamScore > m.awayTeamScore;
                  const aWin = m.status === 'completed' && m.awayTeamScore > m.homeTeamScore;
                  return (
                    <Box key={m.id} sx={{ bgcolor: 'white', border: '1px solid #e2e8f0',
                      borderRadius: 1.5, overflow: 'hidden',
                      boxShadow: m.status === 'completed' ? '0 0 0 2px #22c55e33' : '0 1px 4px #0001' }}>
                      {/* Home team */}
                      <Box sx={{ display: 'flex', alignItems: 'center', px: 1.25, py: 0.9,
                        bgcolor: hWin ? '#f0fdf4' : '#f8fafc',
                        borderBottom: '1px solid #f1f5f9' }}>
                        <Typography fontSize={12} sx={{ flex: 1, fontWeight: hWin ? 700 : 400,
                          color: hWin ? '#15803d' : '#1e293b' }} noWrap>
                          {m.homeTeam?.name || 'En attente...'}
                        </Typography>
                        <Box sx={{ ml: 1, minWidth: 22, textAlign: 'right',
                          fontWeight: 800, fontSize: 14, color: hWin ? '#15803d' : '#475569' }}>
                          {m.status === 'completed' || m.status === 'in_progress' ? m.homeTeamScore ?? '-' : '–'}
                        </Box>
                      </Box>
                      {/* Away team */}
                      <Box sx={{ display: 'flex', alignItems: 'center', px: 1.25, py: 0.9,
                        bgcolor: aWin ? '#f0fdf4' : 'white' }}>
                        <Typography fontSize={12} sx={{ flex: 1, fontWeight: aWin ? 700 : 400,
                          color: aWin ? '#15803d' : '#1e293b' }} noWrap>
                          {m.awayTeam?.name || 'En attente...'}
                        </Typography>
                        <Box sx={{ ml: 1, minWidth: 22, textAlign: 'right',
                          fontWeight: 800, fontSize: 14, color: aWin ? '#15803d' : '#475569' }}>
                          {m.status === 'completed' || m.status === 'in_progress' ? m.awayTeamScore ?? '-' : '–'}
                        </Box>
                      </Box>
                      {/* Action row */}
                      <Box sx={{ display: 'flex', justifyContent: 'flex-end', gap: 0.5,
                        px: 1, py: 0.6, bgcolor: '#f8fafc', borderTop: '1px solid #f1f5f9' }}>
                        {m.date && (
                          <Typography fontSize={10} color="text.secondary" sx={{ flex: 1, alignSelf: 'center' }}>
                            {fmt(m.date)}
                          </Typography>
                        )}
                        <Button size="small" variant="outlined"
                          sx={{ fontSize: 10, py: 0.2, px: 1, minWidth: 0 }}
                          onClick={() => openSchedule(m)}>⏱</Button>
                        <Button size="small" variant="contained"
                          sx={{ fontSize: 10, py: 0.2, px: 1, minWidth: 0 }}
                          onClick={() => openScore(m)}>Score</Button>
                      </Box>
                    </Box>
                  );
                })}
              </Box>
            </Box>
          );
        })}
      </Box>
    </Box>
  );
};

/* ─── main component ─────────────────────────────────────────────────────── */

const TournamentDetails = () => {
  const { id } = useParams();
  const navigate = useNavigate();
  const socketRef = useRef(null);
  const fetchBracketRef = useRef(null);
  const fetchAllRef = useRef(null);

  const [tournament, setTournament]   = useState(null);
  const [teams, setTeams]             = useState([]);
  const [matches, setMatches]         = useState([]);
  const [availableTeams, setAvailableTeams] = useState([]);
  const [bracketRounds, setBracketRounds]   = useState({});
  const [loading, setLoading]         = useState(true);
  const [bracketLoading, setBracketLoading] = useState(false);
  const [error, setError]             = useState('');
  const [activeTab, setActiveTab]     = useState(0);

  const [addTeamDialog, setAddTeamDialog] = useState(false);
  const [selectedTeam, setSelectedTeam]   = useState('');
  const [scheduleDialog, setScheduleDialog] = useState({ open: false, match: null, date: '', location: '' });
  const [scoreDialog, setScoreDialog]       = useState({ open: false, match: null, home: '', away: '' });

  /* ── fetch ── */
  const fetchAll = async () => {
    setLoading(true);
    try {
      const [tRes, tmRes, allTmRes, mRes] = await Promise.all([
        fetch(`${API}/tournaments/${id}`, { headers: authHeaders() }),
        fetch(`${API}/teams?tournamentId=${id}`, { headers: authHeaders() }),
        fetch(`${API}/teams`, { headers: authHeaders() }),
        fetch(`${API}/matches?tournamentId=${id}`, { headers: authHeaders() }),
      ]);

      if (!tRes.ok) throw new Error('Tournoi non trouvé');
      const { tournament: t } = await tRes.json();
      setTournament(t);

      const tmData = await tmRes.json();
      const tournamentTeams = tmData.teams || tmData || [];
      setTeams(tournamentTeams);

      const allTmData = await allTmRes.json();
      const allTeams  = allTmData.teams || allTmData || [];
      setAvailableTeams(allTeams.filter(tm => tm.tournamentId !== parseInt(id)));

      if (mRes.ok) {
        const mData = await mRes.json();
        setMatches(mData.matches || []);
      }
    } catch (e) {
      setError(e.message || 'Erreur lors du chargement');
    } finally {
      setLoading(false);
    }
  };

  const fetchBracket = async () => {
    setBracketLoading(true);
    try {
      const res = await fetch(`${API}/tournaments/${id}/bracket`, { headers: authHeaders() });
      if (res.ok) {
        const data = await res.json();
        setBracketRounds(data.rounds || {});
      } else {
        setBracketRounds({});
      }
    } catch { setBracketRounds({}); }
    finally { setBracketLoading(false); }
  };

  // Toujours garder les refs à jour pour éviter les stale closures dans le listener socket
  fetchBracketRef.current = fetchBracket;
  fetchAllRef.current = fetchAll;

  useEffect(() => {
    fetchAll();
    fetchBracket();

    const token = localStorage.getItem('token');
    const socket = io(WS, { auth: { token } });
    socketRef.current = socket;
    socket.emit('join-tournament', id);
    socket.on('bracket-updated', () => { fetchBracketRef.current(); fetchAllRef.current(); });
    return () => socket.disconnect();
  }, [id]); // eslint-disable-line react-hooks/exhaustive-deps

  /* ── derived data ── */
  const standings = useMemo(() => computeStandings(matches, teams), [matches, teams]);
  const scorers   = useMemo(() => computeScorers(matches), [matches]);

  const completedMatches = matches.filter(m => m.status === 'completed').length;
  const totalGoals = matches.reduce((s, m) =>
    s + (m.status === 'completed' ? (m.homeTeamScore ?? 0) + (m.awayTeamScore ?? 0) : 0), 0);
  const avgGoals = completedMatches ? (totalGoals / completedMatches).toFixed(1) : 0;

  /* ── bracket actions ── */
  const handleGenerateBracket = async () => {
    try {
      const res = await fetch(`${API}/tournaments/${id}/bracket/generate`, {
        method: 'POST', headers: authHeaders(),
      });
      if (!res.ok) { const e = await res.json().catch(() => ({})); throw new Error(e.message || 'Erreur'); }
      await fetchBracket();
    } catch (e) { setError(e.message); }
  };

  const openSchedule = (m) =>
    setScheduleDialog({ open: true, match: m, date: m.date ? new Date(m.date).toISOString().slice(0, 16) : '', location: m.location || '' });

  const saveSchedule = async () => {
    try {
      const { match, date, location } = scheduleDialog;
      const res = await fetch(`${API}/matches/${match.id}/schedule`, {
        method: 'PUT', headers: authHeaders(),
        body: JSON.stringify({ date: date ? new Date(date).toISOString() : undefined, location, status: 'scheduled' }),
      });
      if (!res.ok) throw new Error('Erreur lors de la planification');
      setScheduleDialog({ open: false, match: null, date: '', location: '' });
      await Promise.all([fetchBracket(), fetchAll()]);
    } catch (e) { setError(e.message); }
  };

  const openScore = (m) =>
    setScoreDialog({ open: true, match: m, home: m.homeTeamScore ?? '', away: m.awayTeamScore ?? '' });

  const saveScore = async () => {
    try {
      const { match, home, away } = scoreDialog;
      const res = await fetch(`${API}/matches/${match.id}/score`, {
        method: 'PUT', headers: authHeaders(),
        body: JSON.stringify({ homeTeamScore: Number(home), awayTeamScore: Number(away), status: 'completed' }),
      });
      if (!res.ok) throw new Error("Erreur lors de l'enregistrement du score");
      setScoreDialog({ open: false, match: null, home: '', away: '' });
      await Promise.all([fetchBracket(), fetchAll()]);
    } catch (e) { setError(e.message); }
  };

  /* ── team management ── */
  const handleAddTeam = async () => {
    if (!selectedTeam) return;
    try {
      const res = await fetch(`${API}/teams/${selectedTeam}`, {
        method: 'PUT', headers: authHeaders(),
        body: JSON.stringify({ tournamentId: parseInt(id) }),
      });
      if (!res.ok) { const e = await res.json(); throw new Error(e.message || 'Erreur'); }
      setAddTeamDialog(false); setSelectedTeam('');
      await fetchAll();
    } catch (e) { setError(e.message); }
  };

  const handleRemoveTeam = async (teamId) => {
    if (!window.confirm('Retirer cette équipe du tournoi ?')) return;
    try {
      const res = await fetch(`${API}/teams/${teamId}`, {
        method: 'PUT', headers: authHeaders(),
        body: JSON.stringify({ tournamentId: null }),
      });
      if (!res.ok) { const e = await res.json(); throw new Error(e.message || 'Erreur'); }
      await fetchAll();
    } catch (e) { setError(e.message); }
  };

  /* ── render ── */
  if (loading) return (
    <Box sx={{ p: 3 }}>
      <LinearProgress />
      <Typography sx={{ mt: 2, textAlign: 'center', color: 'text.secondary' }}>Chargement...</Typography>
    </Box>
  );

  if (error || !tournament) return (
    <Box sx={{ p: 3 }}>
      <Alert severity="error" sx={{ mb: 2 }}>{error || 'Tournoi non trouvé'}</Alert>
      <Button startIcon={<ArrowBackIcon />} onClick={() => navigate('/admin')} variant="contained">
        Retour à l'administration
      </Button>
    </Box>
  );

  const isKnockout = tournament.format === 'knockout';
  const isLeague   = tournament.format === 'league';

  return (
    <Box sx={{ p: { xs: 2, md: 3 } }}>

      {/* ── Hero Banner ── */}
      <Paper elevation={0} sx={{
        mb: 3, borderRadius: 4, overflow: 'hidden',
        background: 'linear-gradient(135deg, #0F172A 0%, #1E3A5F 50%, #0F172A 100%)',
        position: 'relative',
      }}>
        {/* decorative circles */}
        <Box sx={{ position: 'absolute', top: -40, right: -40, width: 200, height: 200,
          borderRadius: '50%', bgcolor: 'rgba(59,130,246,0.08)' }} />
        <Box sx={{ position: 'absolute', bottom: -30, left: -30, width: 150, height: 150,
          borderRadius: '50%', bgcolor: 'rgba(245,158,11,0.06)' }} />

        <Box sx={{ position: 'relative', p: { xs: 2.5, md: 3.5 } }}>
          <Button startIcon={<ArrowBackIcon />} onClick={() => navigate('/admin')}
            sx={{ color: 'rgba(255,255,255,0.7)', mb: 2, '&:hover': { color: 'white', bgcolor: 'rgba(255,255,255,0.08)' } }}>
            Retour
          </Button>

          <Box sx={{ display: 'flex', alignItems: 'flex-start', gap: 2.5 }}>
            {/* Trophy avatar */}
            <Box sx={{
              width: 72, height: 72, borderRadius: 3, flexShrink: 0,
              background: 'linear-gradient(135deg, #F59E0B, #D97706)',
              display: 'flex', alignItems: 'center', justifyContent: 'center',
              fontSize: 36, boxShadow: '0 8px 24px rgba(245,158,11,0.4)',
            }}>🏆</Box>

            <Box sx={{ flex: 1, minWidth: 0 }}>
              <Typography variant="h4" fontWeight={800} sx={{ color: 'white', lineHeight: 1.2, mb: 1 }}>
                {tournament.name}
              </Typography>
              <Box sx={{ display: 'flex', flexWrap: 'wrap', gap: 1 }}>
                <Chip
                  label={STATUS_LABEL[tournament.status] || tournament.status}
                  color={STATUS_COLOR[tournament.status] || 'default'}
                  size="small"
                  sx={{ fontWeight: 700 }}
                />
                <Chip
                  label={FORMAT_LABEL[tournament.format] || tournament.format}
                  size="small"
                  sx={{ bgcolor: 'rgba(59,130,246,0.25)', color: '#93C5FD', fontWeight: 600, border: '1px solid rgba(59,130,246,0.4)' }}
                />
                {tournament.location && (
                  <Chip
                    icon={<LocationIcon sx={{ fontSize: '14px !important', color: '#94A3B8 !important' }} />}
                    label={tournament.location}
                    size="small"
                    sx={{ bgcolor: 'rgba(255,255,255,0.08)', color: '#CBD5E1', border: '1px solid rgba(255,255,255,0.12)' }}
                  />
                )}
              </Box>
            </Box>
          </Box>

          {/* KPI strip */}
          <Grid container spacing={2} sx={{ mt: 2.5 }}>
            {[
              { icon: '👥', val: `${teams.length}`, sub: `/ ${tournament.maxTeams || 16}`, label: 'Équipes', color: '#3B82F6' },
              { icon: '📅', val: matches.length,    sub: '',                               label: 'Matchs',  color: '#22C55E' },
              { icon: '✅', val: completedMatches,  sub: '',                               label: 'Terminés',color: '#F59E0B' },
              { icon: '⚽', val: totalGoals,        sub: '',                               label: 'Buts',    color: '#8B5CF6' },
              { icon: '📈', val: avgGoals,          sub: '',                               label: 'Buts/match', color: '#EC4899' },
            ].map(({ icon, val, sub, label, color }) => (
              <Grid item xs={6} sm={4} md key={label}>
                <Box sx={{
                  bgcolor: 'rgba(255,255,255,0.06)', border: '1px solid rgba(255,255,255,0.1)',
                  borderRadius: 2.5, p: 1.5, textAlign: 'center',
                }}>
                  <Typography sx={{ fontSize: 22 }}>{icon}</Typography>
                  <Box sx={{ display: 'flex', alignItems: 'baseline', justifyContent: 'center', gap: 0.5 }}>
                    <Typography sx={{ fontSize: 26, fontWeight: 800, color, lineHeight: 1.1 }}>{val}</Typography>
                    {sub && <Typography sx={{ fontSize: 14, color: 'rgba(255,255,255,0.4)', fontWeight: 600 }}>{sub}</Typography>}
                  </Box>
                  <Typography sx={{ fontSize: 11, color: 'rgba(255,255,255,0.5)', mt: 0.25 }}>{label}</Typography>
                </Box>
              </Grid>
            ))}
          </Grid>
        </Box>
      </Paper>

      {/* ── Tabs ── */}
      <Card sx={{ borderRadius: 3, overflow: 'hidden' }}>
        <Tabs value={activeTab} onChange={(_, v) => setActiveTab(v)}
          sx={{ borderBottom: '1px solid #e2e8f0', px: 1, bgcolor: '#FAFAFA' }}
          variant="scrollable" scrollButtons="auto">
          <Tab label="📋 Informations" />
          <Tab label="👥 Équipes" />
          <Tab label={isLeague ? '📊 Classement' : '🏆 Tableau'} />
          <Tab label="⚽ Statistiques" />
        </Tabs>

        {/* ── Tab 0 : Informations ── */}
        <TabPanel value={activeTab} index={0}>
          <Grid container spacing={3}>

            {/* ── Left column ── */}
            <Grid item xs={12} md={7}>

              {/* Dates & lieu */}
              <Paper elevation={0} sx={{ border: '1.5px solid #E2E8F0', borderRadius: 3, p: 2.5, mb: 2.5 }}>
                <Box sx={{ display: 'flex', alignItems: 'center', gap: 1, mb: 2 }}>
                  <Box sx={{ bgcolor: '#EFF6FF', p: 0.75, borderRadius: 1.5, display: 'flex' }}>
                    <CalendarIcon sx={{ color: '#3B82F6', fontSize: 18 }} />
                  </Box>
                  <Typography fontWeight={700} fontSize={14} color="#1E293B">Calendrier & Lieu</Typography>
                </Box>
                <Grid container spacing={2}>
                  {[
                    { label: 'Date de début',  value: tournament.startDate ? fmt(tournament.startDate) : '—', icon: '📅' },
                    { label: 'Date de fin',    value: tournament.endDate   ? fmt(tournament.endDate)   : '—', icon: '🏁' },
                    { label: 'Lieu',           value: tournament.location  || '—',                           icon: '📍' },
                    { label: 'Durée',          value: (() => {
                        if (!tournament.startDate || !tournament.endDate) return '—';
                        const days = Math.round((new Date(tournament.endDate) - new Date(tournament.startDate)) / 86400000);
                        return days <= 0 ? '1 jour' : `${days} jour${days > 1 ? 's' : ''}`;
                      })(), icon: '⏱️' },
                  ].map(({ label, value, icon }) => (
                    <Grid item xs={6} key={label}>
                      <Box sx={{ bgcolor: '#F8FAFC', borderRadius: 2, p: 1.5 }}>
                        <Typography fontSize={11} color="text.secondary" fontWeight={600} sx={{ textTransform: 'uppercase', letterSpacing: 0.5, mb: 0.5 }}>
                          {icon} {label}
                        </Typography>
                        <Typography fontSize={14} fontWeight={700} color="#0F172A">{value}</Typography>
                      </Box>
                    </Grid>
                  ))}
                </Grid>
              </Paper>

              {/* Format & règles de compétition */}
              <Paper elevation={0} sx={{ border: '1.5px solid #E2E8F0', borderRadius: 3, p: 2.5, mb: 2.5 }}>
                <Box sx={{ display: 'flex', alignItems: 'center', gap: 1, mb: 2 }}>
                  <Box sx={{ bgcolor: '#F0FDF4', p: 0.75, borderRadius: 1.5, display: 'flex' }}>
                    <SportsIcon sx={{ color: '#22C55E', fontSize: 18 }} />
                  </Box>
                  <Typography fontWeight={700} fontSize={14} color="#1E293B">Format de compétition</Typography>
                </Box>
                <Grid container spacing={2}>
                  {[
                    { label: 'Format',         value: FORMAT_LABEL[tournament.format] || tournament.format || '—', icon: '🏆' },
                    { label: 'Max équipes',    value: tournament.maxTeams || 16,                                    icon: '👥' },
                    { label: 'Équipes inscrites', value: `${teams.length} / ${tournament.maxTeams || 16}`,         icon: '✅' },
                    { label: 'Joueurs total',  value: teams.reduce((s, t) => s + (t.players?.length || 0), 0),    icon: '⚽' },
                  ].map(({ label, value, icon }) => (
                    <Grid item xs={6} key={label}>
                      <Box sx={{ bgcolor: '#F8FAFC', borderRadius: 2, p: 1.5 }}>
                        <Typography fontSize={11} color="text.secondary" fontWeight={600} sx={{ textTransform: 'uppercase', letterSpacing: 0.5, mb: 0.5 }}>
                          {icon} {label}
                        </Typography>
                        <Typography fontSize={14} fontWeight={700} color="#0F172A">{value}</Typography>
                      </Box>
                    </Grid>
                  ))}
                </Grid>

                {/* Progression inscription */}
                <Box sx={{ mt: 2 }}>
                  <Box sx={{ display: 'flex', justifyContent: 'space-between', mb: 0.75 }}>
                    <Typography fontSize={12} color="text.secondary">Progression des inscriptions</Typography>
                    <Typography fontSize={12} fontWeight={700} color="#3B82F6">
                      {Math.round((teams.length / (tournament.maxTeams || 16)) * 100)}%
                    </Typography>
                  </Box>
                  <LinearProgress
                    variant="determinate"
                    value={Math.min(100, Math.round((teams.length / (tournament.maxTeams || 16)) * 100))}
                    sx={{
                      height: 8, borderRadius: 4, bgcolor: '#E2E8F0',
                      '& .MuiLinearProgress-bar': {
                        borderRadius: 4,
                        background: teams.length >= (tournament.maxTeams || 16)
                          ? 'linear-gradient(90deg, #22C55E, #16A34A)'
                          : 'linear-gradient(90deg, #3B82F6, #6366F1)',
                      },
                    }}
                  />
                  <Typography fontSize={11} color="text.secondary" mt={0.5}>
                    {(tournament.maxTeams || 16) - teams.length} place{(tournament.maxTeams || 16) - teams.length !== 1 ? 's' : ''} restante{(tournament.maxTeams || 16) - teams.length !== 1 ? 's' : ''}
                  </Typography>
                </Box>
              </Paper>

              {/* Avancement des matchs */}
              {matches.length > 0 && (
                <Paper elevation={0} sx={{ border: '1.5px solid #E2E8F0', borderRadius: 3, p: 2.5 }}>
                  <Box sx={{ display: 'flex', alignItems: 'center', gap: 1, mb: 2 }}>
                    <Box sx={{ bgcolor: '#FEF3C7', p: 0.75, borderRadius: 1.5, display: 'flex' }}>
                      <GoalIcon sx={{ color: '#F59E0B', fontSize: 18 }} />
                    </Box>
                    <Typography fontWeight={700} fontSize={14} color="#1E293B">Avancement des matchs</Typography>
                  </Box>
                  <Box sx={{ display: 'flex', justifyContent: 'space-between', mb: 0.75 }}>
                    <Typography fontSize={12} color="text.secondary">Matchs terminés</Typography>
                    <Typography fontSize={12} fontWeight={700} color="#F59E0B">
                      {completedMatches} / {matches.length}
                    </Typography>
                  </Box>
                  <LinearProgress
                    variant="determinate"
                    value={matches.length ? Math.round((completedMatches / matches.length) * 100) : 0}
                    sx={{
                      height: 8, borderRadius: 4, bgcolor: '#E2E8F0',
                      '& .MuiLinearProgress-bar': {
                        borderRadius: 4, background: 'linear-gradient(90deg, #F59E0B, #EF4444)',
                      },
                    }}
                  />
                  <Box sx={{ display: 'flex', gap: 2, mt: 1.5, flexWrap: 'wrap' }}>
                    {[
                      { label: 'Terminés', val: completedMatches, color: '#22C55E' },
                      { label: 'À jouer',  val: matches.filter(m => m.status !== 'completed').length, color: '#3B82F6' },
                      { label: 'Buts',     val: totalGoals, color: '#F59E0B' },
                      { label: 'Moy. buts', val: avgGoals, color: '#8B5CF6' },
                    ].map(({ label, val, color }) => (
                      <Box key={label} sx={{ textAlign: 'center', flex: 1 }}>
                        <Typography fontWeight={800} fontSize={18} color={color}>{val}</Typography>
                        <Typography fontSize={10} color="text.secondary">{label}</Typography>
                      </Box>
                    ))}
                  </Box>
                </Paper>
              )}
            </Grid>

            {/* ── Right column ── */}
            <Grid item xs={12} md={5}>

              {/* Description */}
              <Paper elevation={0} sx={{ border: '1.5px solid #E2E8F0', borderRadius: 3, p: 2.5, mb: 2.5 }}>
                <Box sx={{ display: 'flex', alignItems: 'center', gap: 1, mb: 1.5 }}>
                  <Box sx={{ bgcolor: '#FDF4FF', p: 0.75, borderRadius: 1.5, display: 'flex' }}>
                    <AssessmentIcon sx={{ color: '#8B5CF6', fontSize: 18 }} />
                  </Box>
                  <Typography fontWeight={700} fontSize={14} color="#1E293B">Description</Typography>
                </Box>
                {tournament.description ? (
                  <Typography fontSize={13} color="#475569" sx={{ lineHeight: 1.7 }}>
                    {tournament.description}
                  </Typography>
                ) : (
                  <Typography fontSize={13} color="text.disabled" fontStyle="italic">
                    Aucune description définie.
                  </Typography>
                )}
              </Paper>

              {/* Règles */}
              <Paper elevation={0} sx={{ border: '1.5px solid #E2E8F0', borderRadius: 3, p: 2.5, mb: 2.5 }}>
                <Box sx={{ display: 'flex', alignItems: 'center', gap: 1, mb: 1.5 }}>
                  <Box sx={{ bgcolor: '#FEF2F2', p: 0.75, borderRadius: 1.5, display: 'flex' }}>
                    <StarIcon sx={{ color: '#EF4444', fontSize: 18 }} />
                  </Box>
                  <Typography fontWeight={700} fontSize={14} color="#1E293B">Règles du tournoi</Typography>
                </Box>
                {tournament.rules ? (
                  <Typography fontSize={13} color="#475569" sx={{ whiteSpace: 'pre-line', lineHeight: 1.7 }}>
                    {tournament.rules}
                  </Typography>
                ) : (
                  <Typography fontSize={13} color="text.disabled" fontStyle="italic">
                    Aucune règle définie.
                  </Typography>
                )}
              </Paper>

              {/* Aperçu des équipes */}
              {teams.length > 0 && (
                <Paper elevation={0} sx={{ border: '1.5px solid #E2E8F0', borderRadius: 3, p: 2.5 }}>
                  <Box sx={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', mb: 1.5 }}>
                    <Box sx={{ display: 'flex', alignItems: 'center', gap: 1 }}>
                      <Box sx={{ bgcolor: '#EFF6FF', p: 0.75, borderRadius: 1.5, display: 'flex' }}>
                        <GroupIcon sx={{ color: '#3B82F6', fontSize: 18 }} />
                      </Box>
                      <Typography fontWeight={700} fontSize={14} color="#1E293B">Équipes participantes</Typography>
                    </Box>
                    <Chip label={teams.length} size="small"
                      sx={{ bgcolor: '#DBEAFE', color: '#1D4ED8', fontWeight: 700 }} />
                  </Box>
                  <Box sx={{ display: 'flex', flexDirection: 'column', gap: 1 }}>
                    {teams.slice(0, 6).map((team, i) => {
                      const colors = ['#3B82F6','#22C55E','#F59E0B','#EF4444','#8B5CF6','#06B6D4','#EC4899'];
                      const bg = colors[i % colors.length];
                      const captain = team.players?.find(p => p.isCaptain);
                      return (
                        <Box key={team.id} sx={{
                          display: 'flex', alignItems: 'center', gap: 1.5,
                          p: 1, borderRadius: 2, bgcolor: '#F8FAFC',
                          cursor: 'pointer', '&:hover': { bgcolor: '#F1F5F9' },
                        }} onClick={() => navigate(`/admin/teams/${team.id}`)}>
                          <Avatar sx={{ width: 34, height: 34, bgcolor: bg, fontSize: 13, fontWeight: 800 }}>
                            {team.name.charAt(0).toUpperCase()}
                          </Avatar>
                          <Box sx={{ flex: 1, minWidth: 0 }}>
                            <Typography fontSize={13} fontWeight={600} noWrap>{team.name}</Typography>
                            <Typography fontSize={11} color="text.secondary" noWrap>
                              {team.players?.length || 0} joueur{(team.players?.length || 0) !== 1 ? 's' : ''}
                              {captain ? ` · Cap. ${captain.name}` : ''}
                            </Typography>
                          </Box>
                          <Chip label={team.players?.length || 0} size="small"
                            sx={{ bgcolor: `${bg}18`, color: bg, fontWeight: 700, fontSize: 11 }} />
                        </Box>
                      );
                    })}
                    {teams.length > 6 && (
                      <Typography fontSize={12} color="text.secondary" textAlign="center" mt={0.5}>
                        +{teams.length - 6} autres équipes — voir l'onglet Équipes
                      </Typography>
                    )}
                  </Box>
                </Paper>
              )}
            </Grid>
          </Grid>
        </TabPanel>

        {/* ── Tab 1 : Équipes ── */}
        <TabPanel value={activeTab} index={1}>
          <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', mb: 2 }}>
            <Typography fontWeight={600}>
              Équipes participantes ({teams.length}/{tournament.maxTeams || 16})
            </Typography>
            <Button variant="contained" startIcon={<AddIcon />}
              onClick={() => setAddTeamDialog(true)}
              disabled={teams.length >= (tournament.maxTeams || 16)}>
              Ajouter
            </Button>
          </Box>

          {teams.length === 0 ? (
            <Paper sx={{ p: 4, textAlign: 'center' }}>
              <Typography color="text.secondary">Aucune équipe inscrite</Typography>
            </Paper>
          ) : (
            <Table size="small">
              <TableHead>
                <TableRow sx={{ bgcolor: '#f8fafc' }}>
                  <TableCell sx={{ fontWeight: 700 }}>Équipe</TableCell>
                  <TableCell sx={{ fontWeight: 700 }}>Joueurs</TableCell>
                  <TableCell sx={{ fontWeight: 700 }}>Capitaine</TableCell>
                  <TableCell sx={{ fontWeight: 700 }}>Actions</TableCell>
                </TableRow>
              </TableHead>
              <TableBody>
                {teams.map(team => (
                  <TableRow key={team.id} hover>
                    <TableCell>
                      <Button variant="text" color="primary"
                        sx={{ textTransform: 'none', p: 0, fontWeight: 600, fontSize: 13 }}
                        onClick={() => navigate(`/admin/teams/${team.id}`)}>
                        {team.name}
                      </Button>
                    </TableCell>
                    <TableCell>
                      <Chip label={team.players?.length || 0} color="info" size="small" />
                    </TableCell>
                    <TableCell fontSize={13}>
                      {team.players?.find(p => p.isCaptain)?.name || '—'}
                    </TableCell>
                    <TableCell>
                      <Tooltip title="Voir l'équipe">
                        <IconButton size="small" color="info" onClick={() => navigate(`/admin/teams/${team.id}`)}>
                          <VisibilityIcon fontSize="small" />
                        </IconButton>
                      </Tooltip>
                      <Tooltip title="Retirer du tournoi">
                        <IconButton size="small" color="error" onClick={() => handleRemoveTeam(team.id)}>
                          <RemoveIcon fontSize="small" />
                        </IconButton>
                      </Tooltip>
                    </TableCell>
                  </TableRow>
                ))}
              </TableBody>
            </Table>
          )}
        </TabPanel>

        {/* ── Tab 2 : Classement (league) or Bracket (knockout) ── */}
        <TabPanel value={activeTab} index={2}>

          {isLeague && (
            <Box>
              <Typography variant="h6" fontWeight={700} mb={2}>📊 Classement</Typography>
              <StandingsTable standings={standings} />

              {matches.length > 0 && (
                <Box mt={4}>
                  <Typography variant="h6" fontWeight={700} mb={2}>⚽ Résultats ({completedMatches}/{matches.length} matchs)</Typography>
                  {matches.map(m => {
                    const done = m.status === 'completed';
                    const hWin = done && m.homeTeamScore > m.awayTeamScore;
                    const aWin = done && m.awayTeamScore > m.homeTeamScore;
                    return (
                      <Paper key={m.id} variant="outlined" sx={{ p: 1.5, mb: 1, display: 'flex',
                        alignItems: 'center', gap: 1.5 }}>
                        {m.date && (
                          <Typography fontSize={11} color="text.secondary" sx={{ minWidth: 70 }}>
                            {fmt(m.date)}
                          </Typography>
                        )}
                        <Typography fontSize={13} fontWeight={hWin ? 700 : 400} sx={{ flex: 1, textAlign: 'right' }}>
                          {m.homeTeam?.name || '?'}
                        </Typography>
                        <Box sx={{ display: 'flex', alignItems: 'center', gap: 0.5,
                          bgcolor: done ? '#f1f5f9' : '#f8fafc', borderRadius: 1, px: 1.5, py: 0.5 }}>
                          {done ? (
                            <>
                              <Typography fontWeight={800} fontSize={15} color={hWin ? '#16a34a' : '#1e293b'}>
                                {m.homeTeamScore}
                              </Typography>
                              <Typography color="text.secondary" mx={0.5}>–</Typography>
                              <Typography fontWeight={800} fontSize={15} color={aWin ? '#16a34a' : '#1e293b'}>
                                {m.awayTeamScore}
                              </Typography>
                            </>
                          ) : (
                            <Typography color="text.secondary" fontSize={13}>vs</Typography>
                          )}
                        </Box>
                        <Typography fontSize={13} fontWeight={aWin ? 700 : 400} sx={{ flex: 1 }}>
                          {m.awayTeam?.name || '?'}
                        </Typography>
                        <Chip label={m.status === 'completed' ? 'Terminé' : m.status === 'scheduled' ? 'Planifié' : m.status}
                          size="small"
                          color={m.status === 'completed' ? 'success' : m.status === 'scheduled' ? 'info' : 'default'}
                          sx={{ fontSize: 10, minWidth: 64 }} />
                      </Paper>
                    );
                  })}
                </Box>
              )}
            </Box>
          )}

          {isKnockout && (
            <Box>
              <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', mb: 2 }}>
                <Typography variant="h6" fontWeight={700}>🏆 Tableau d'élimination</Typography>
                <Box sx={{ display: 'flex', gap: 1, alignItems: 'center' }}>
                  {bracketLoading && <Chip label="Actualisation…" size="small" />}
                  <Button variant="outlined" startIcon={<BracketIcon />} onClick={handleGenerateBracket}>
                    Générer / Réinitialiser
                  </Button>
                  <Button variant="outlined" startIcon={<AssessmentIcon />} onClick={() => window.print()}>
                    Imprimer
                  </Button>
                </Box>
              </Box>

              {teams.length < 2 ? (
                <Alert severity="warning">
                  Il faut au moins 2 équipes pour générer le tableau.
                </Alert>
              ) : (
                <VisualBracket bracketRounds={bracketRounds} openSchedule={openSchedule} openScore={openScore} />
              )}
            </Box>
          )}

          {!isLeague && !isKnockout && (
            <Alert severity="info">
              Format <strong>{FORMAT_LABEL[tournament.format] || tournament.format}</strong> —
              le classement de poules et le tableau seront disponibles prochainement.
            </Alert>
          )}
        </TabPanel>

        {/* ── Tab 3 : Statistiques ── */}
        <TabPanel value={activeTab} index={3}>
          {completedMatches === 0 ? (
            <Paper elevation={0} sx={{ p: 6, textAlign: 'center', border: '1.5px dashed #E2E8F0', borderRadius: 3 }}>
              <Typography fontSize={48} mb={1}>📊</Typography>
              <Typography fontWeight={700} fontSize={16} mb={0.5}>Aucune statistique disponible</Typography>
              <Typography color="text.secondary" fontSize={13}>
                Les statistiques apparaîtront dès que des matchs seront terminés.
              </Typography>
            </Paper>
          ) : (
            <Box>

              {/* ── KPI Banner ── */}
              <Paper elevation={0} sx={{
                mb: 3, borderRadius: 3, overflow: 'hidden',
                background: 'linear-gradient(135deg, #0F172A 0%, #1E293B 100%)',
                p: 2.5,
              }}>
                <Typography sx={{ color: 'rgba(255,255,255,0.5)', fontSize: 11, fontWeight: 700,
                  letterSpacing: 1.5, textTransform: 'uppercase', mb: 2 }}>
                  Vue d'ensemble du tournoi
                </Typography>
                <Grid container spacing={2}>
                  {[
                    { icon: '⚽', label: 'Buts marqués',    val: totalGoals,        color: '#3B82F6' },
                    { icon: '✅', label: 'Matchs terminés', val: completedMatches,  color: '#22C55E' },
                    { icon: '📅', label: 'Total matchs',    val: matches.length,    color: '#8B5CF6' },
                    { icon: '📈', label: 'Buts / match',    val: avgGoals,          color: '#F59E0B' },
                    { icon: '👥', label: 'Équipes',         val: teams.length,      color: '#EC4899' },
                    { icon: '🏃', label: 'Joueurs',         val: teams.reduce((s, t) => s + (t.players?.length || 0), 0), color: '#06B6D4' },
                  ].map(({ icon, label, val, color }) => (
                    <Grid item xs={6} sm={4} md={2} key={label}>
                      <Box sx={{
                        bgcolor: 'rgba(255,255,255,0.06)', border: `1px solid ${color}30`,
                        borderRadius: 2.5, p: 1.5, textAlign: 'center',
                        borderTop: `3px solid ${color}`,
                      }}>
                        <Typography fontSize={20}>{icon}</Typography>
                        <Typography sx={{ fontSize: 26, fontWeight: 800, color, lineHeight: 1.1, mt: 0.25 }}>{val}</Typography>
                        <Typography sx={{ fontSize: 10, color: 'rgba(255,255,255,0.45)', mt: 0.25 }}>{label}</Typography>
                      </Box>
                    </Grid>
                  ))}
                </Grid>
              </Paper>

              <Grid container spacing={3}>

                {/* ── Left: Meilleurs buteurs ── */}
                <Grid item xs={12} md={5}>
                  <Paper elevation={0} sx={{ border: '1.5px solid #E2E8F0', borderRadius: 3, overflow: 'hidden' }}>
                    {/* header */}
                    <Box sx={{
                      px: 2.5, py: 1.75,
                      background: 'linear-gradient(90deg, #FEF3C7, #FFF7ED)',
                      borderBottom: '1px solid #FDE68A',
                      display: 'flex', alignItems: 'center', gap: 1,
                    }}>
                      <Typography fontSize={20}>🏅</Typography>
                      <Typography fontWeight={800} fontSize={14} color="#92400E">Meilleurs buteurs</Typography>
                      {scorers.length > 0 && (
                        <Chip label={scorers.length} size="small"
                          sx={{ ml: 'auto', bgcolor: '#F59E0B', color: 'white', fontWeight: 700, fontSize: 11 }} />
                      )}
                    </Box>
                    <Box sx={{ p: 2 }}>
                      <TopScorers scorers={scorers} />
                    </Box>
                  </Paper>
                </Grid>

                {/* ── Right: Classement équipes + cartons ── */}
                <Grid item xs={12} md={7}>

                  {/* Classement offensif par équipe */}
                  <Paper elevation={0} sx={{ border: '1.5px solid #E2E8F0', borderRadius: 3, mb: 2.5, overflow: 'hidden' }}>
                    <Box sx={{
                      px: 2.5, py: 1.75,
                      background: 'linear-gradient(90deg, #EFF6FF, #F0F9FF)',
                      borderBottom: '1px solid #BFDBFE',
                      display: 'flex', alignItems: 'center', gap: 1,
                    }}>
                      <Typography fontSize={20}>⚽</Typography>
                      <Typography fontWeight={800} fontSize={14} color="#1D4ED8">Performance par équipe</Typography>
                    </Box>
                    <Box sx={{ overflowX: 'auto' }}>
                      <Table size="small">
                        <TableHead>
                          <TableRow sx={{ bgcolor: '#F8FAFC' }}>
                            {['#', 'Équipe', 'J', 'V', 'N', 'D', 'BP', 'BC', 'Pts'].map(h => (
                              <TableCell key={h} align={h === 'Équipe' ? 'left' : 'center'}
                                sx={{ fontWeight: 700, fontSize: 11, color: '#64748B', py: 1 }}>
                                {h}
                              </TableCell>
                            ))}
                          </TableRow>
                        </TableHead>
                        <TableBody>
                          {standings.length === 0 ? (
                            <TableRow>
                              <TableCell colSpan={9} sx={{ textAlign: 'center', py: 3, color: '#94A3B8', fontSize: 13 }}>
                                Aucun résultat disponible
                              </TableCell>
                            </TableRow>
                          ) : standings.map((row, i) => {
                            const medal = i === 0 ? '#F59E0B' : i === 1 ? '#94A3B8' : i === 2 ? '#B45309' : null;
                            return (
                              <TableRow key={row.id} hover
                                sx={{ bgcolor: medal ? `${medal}08` : undefined, cursor: 'pointer' }}
                                onClick={() => navigate(`/admin/teams/${row.id}`)}>
                                <TableCell align="center" sx={{ py: 1 }}>
                                  {medal ? (
                                    <Box sx={{ width: 22, height: 22, borderRadius: '50%', bgcolor: medal,
                                      display: 'flex', alignItems: 'center', justifyContent: 'center',
                                      color: 'white', fontSize: 11, fontWeight: 800, mx: 'auto' }}>
                                      {i + 1}
                                    </Box>
                                  ) : (
                                    <Typography fontSize={12} color="text.secondary">{i + 1}</Typography>
                                  )}
                                </TableCell>
                                <TableCell sx={{ fontWeight: medal ? 700 : 400, fontSize: 13 }}>{row.name}</TableCell>
                                <TableCell align="center" sx={{ fontSize: 13 }}>{row.P}</TableCell>
                                <TableCell align="center" sx={{ fontSize: 13, color: '#16A34A', fontWeight: 600 }}>{row.W}</TableCell>
                                <TableCell align="center" sx={{ fontSize: 13 }}>{row.D}</TableCell>
                                <TableCell align="center" sx={{ fontSize: 13, color: '#DC2626' }}>{row.L}</TableCell>
                                <TableCell align="center" sx={{ fontSize: 13 }}>{row.GF}</TableCell>
                                <TableCell align="center" sx={{ fontSize: 13 }}>{row.GA}</TableCell>
                                <TableCell align="center">
                                  <Box sx={{ bgcolor: '#3B82F6', color: 'white', borderRadius: 1,
                                    px: 1, py: 0.25, fontWeight: 800, fontSize: 13,
                                    display: 'inline-block', minWidth: 28, textAlign: 'center' }}>
                                    {row.Pts}
                                  </Box>
                                </TableCell>
                              </TableRow>
                            );
                          })}
                        </TableBody>
                      </Table>
                    </Box>
                  </Paper>

                  {/* Cartons & discipline */}
                  {(() => {
                    const cards = matches.reduce((acc, m) => {
                      (m.events || []).forEach(ev => {
                        const team = ev.isHomeTeam ? m.homeTeam?.name : m.awayTeam?.name;
                        if (!team) return;
                        if (!acc[team]) acc[team] = { yellow: 0, red: 0 };
                        if (ev.type === 'yellow_card') acc[team].yellow++;
                        if (ev.type === 'red_card')    acc[team].red++;
                      });
                      return acc;
                    }, {});
                    const cardList = Object.entries(cards)
                      .map(([name, c]) => ({ name, ...c, total: c.yellow + c.red * 2 }))
                      .filter(r => r.total > 0)
                      .sort((a, b) => b.total - a.total);

                    const totalYellow = cardList.reduce((s, r) => s + r.yellow, 0);
                    const totalRed    = cardList.reduce((s, r) => s + r.red,    0);

                    if (totalYellow + totalRed === 0) return null;

                    return (
                      <Paper elevation={0} sx={{ border: '1.5px solid #E2E8F0', borderRadius: 3, overflow: 'hidden' }}>
                        <Box sx={{
                          px: 2.5, py: 1.75,
                          background: 'linear-gradient(90deg, #FEF9C3, #FFFBEB)',
                          borderBottom: '1px solid #FDE047',
                          display: 'flex', alignItems: 'center', gap: 1,
                        }}>
                          <Typography fontSize={20}>🟨</Typography>
                          <Typography fontWeight={800} fontSize={14} color="#713F12">Discipline</Typography>
                          <Box sx={{ ml: 'auto', display: 'flex', gap: 1 }}>
                            <Chip label={`🟨 ${totalYellow}`} size="small"
                              sx={{ bgcolor: '#FEF08A', color: '#713F12', fontWeight: 700, fontSize: 11 }} />
                            <Chip label={`🟥 ${totalRed}`} size="small"
                              sx={{ bgcolor: '#FEE2E2', color: '#991B1B', fontWeight: 700, fontSize: 11 }} />
                          </Box>
                        </Box>
                        <Box sx={{ p: 2, display: 'flex', flexDirection: 'column', gap: 1 }}>
                          {cardList.slice(0, 5).map(({ name, yellow, red }) => (
                            <Box key={name} sx={{ display: 'flex', alignItems: 'center', gap: 1.5 }}>
                              <Typography fontSize={13} fontWeight={600} sx={{ flex: 1, minWidth: 0 }} noWrap>{name}</Typography>
                              <Box sx={{ display: 'flex', gap: 0.75 }}>
                                {yellow > 0 && (
                                  <Box sx={{ display: 'flex', alignItems: 'center', gap: 0.4,
                                    bgcolor: '#FEF9C3', border: '1px solid #FDE047',
                                    borderRadius: 1, px: 0.75, py: 0.25 }}>
                                    <Box sx={{ width: 10, height: 13, bgcolor: '#FACC15', borderRadius: 0.5, flexShrink: 0 }} />
                                    <Typography fontSize={12} fontWeight={700} color="#713F12">{yellow}</Typography>
                                  </Box>
                                )}
                                {red > 0 && (
                                  <Box sx={{ display: 'flex', alignItems: 'center', gap: 0.4,
                                    bgcolor: '#FEF2F2', border: '1px solid #FECACA',
                                    borderRadius: 1, px: 0.75, py: 0.25 }}>
                                    <Box sx={{ width: 10, height: 13, bgcolor: '#EF4444', borderRadius: 0.5, flexShrink: 0 }} />
                                    <Typography fontSize={12} fontWeight={700} color="#991B1B">{red}</Typography>
                                  </Box>
                                )}
                              </Box>
                            </Box>
                          ))}
                        </Box>
                      </Paper>
                    );
                  })()}
                </Grid>

                {/* ── Full width: derniers résultats ── */}
                {completedMatches > 0 && (
                  <Grid item xs={12}>
                    <Paper elevation={0} sx={{ border: '1.5px solid #E2E8F0', borderRadius: 3, overflow: 'hidden' }}>
                      <Box sx={{
                        px: 2.5, py: 1.75,
                        background: 'linear-gradient(90deg, #F0FDF4, #ECFDF5)',
                        borderBottom: '1px solid #BBF7D0',
                        display: 'flex', alignItems: 'center', gap: 1,
                      }}>
                        <Typography fontSize={20}>🏁</Typography>
                        <Typography fontWeight={800} fontSize={14} color="#166534">Derniers résultats</Typography>
                        <Chip label={completedMatches} size="small"
                          sx={{ ml: 'auto', bgcolor: '#22C55E', color: 'white', fontWeight: 700, fontSize: 11 }} />
                      </Box>
                      <Box sx={{ p: 2 }}>
                        <Grid container spacing={1.5}>
                          {matches.filter(m => m.status === 'completed').slice(-6).reverse().map(m => {
                            const hWin = m.homeTeamScore > m.awayTeamScore;
                            const aWin = m.awayTeamScore > m.homeTeamScore;
                            const draw = m.homeTeamScore === m.awayTeamScore;
                            return (
                              <Grid item xs={12} sm={6} md={4} key={m.id}>
                                <Box sx={{
                                  border: '1px solid #E2E8F0', borderRadius: 2, p: 1.5,
                                  bgcolor: '#FAFAFA',
                                }}>
                                  {m.date && (
                                    <Typography fontSize={10} color="text.disabled" textAlign="center" mb={0.75}>
                                      {fmt(m.date)}{m.location ? ` · ${m.location}` : ''}
                                    </Typography>
                                  )}
                                  <Box sx={{ display: 'flex', alignItems: 'center', gap: 1 }}>
                                    <Typography fontSize={12} fontWeight={hWin ? 700 : 400}
                                      sx={{ flex: 1, textAlign: 'right' }} noWrap>
                                      {m.homeTeam?.name || '?'}
                                    </Typography>
                                    <Box sx={{
                                      display: 'flex', alignItems: 'center', gap: 0.5,
                                      bgcolor: draw ? '#F1F5F9' : hWin ? '#DCFCE7' : '#FEE2E2',
                                      borderRadius: 1.5, px: 1.25, py: 0.5, flexShrink: 0,
                                    }}>
                                      <Typography fontWeight={800} fontSize={16}
                                        color={hWin ? '#16A34A' : draw ? '#475569' : '#DC2626'}>
                                        {m.homeTeamScore}
                                      </Typography>
                                      <Typography color="text.disabled" fontSize={12} mx={0.25}>–</Typography>
                                      <Typography fontWeight={800} fontSize={16}
                                        color={aWin ? '#16A34A' : draw ? '#475569' : '#DC2626'}>
                                        {m.awayTeamScore}
                                      </Typography>
                                    </Box>
                                    <Typography fontSize={12} fontWeight={aWin ? 700 : 400}
                                      sx={{ flex: 1 }} noWrap>
                                      {m.awayTeam?.name || '?'}
                                    </Typography>
                                  </Box>
                                </Box>
                              </Grid>
                            );
                          })}
                        </Grid>
                      </Box>
                    </Paper>
                  </Grid>
                )}

              </Grid>
            </Box>
          )}
        </TabPanel>
      </Card>

      {/* ── Add Team Dialog ── */}
      <Dialog open={addTeamDialog} onClose={() => setAddTeamDialog(false)} maxWidth="sm" fullWidth>
        <DialogTitle>Ajouter une équipe au tournoi</DialogTitle>
        <DialogContent>
          <FormControl fullWidth sx={{ mt: 2 }}>
            <InputLabel>Sélectionner une équipe</InputLabel>
            <Select value={selectedTeam} onChange={(e) => setSelectedTeam(e.target.value)}
              label="Sélectionner une équipe">
              {availableTeams.map(t => (
                <MenuItem key={t.id} value={t.id}>{t.name} ({t.players?.length || 0} joueurs)</MenuItem>
              ))}
            </Select>
          </FormControl>
          {availableTeams.length === 0 && (
            <Alert severity="warning" sx={{ mt: 2 }}>
              Aucune équipe disponible — toutes les équipes sont déjà assignées.
            </Alert>
          )}
        </DialogContent>
        <DialogActions>
          <Button onClick={() => setAddTeamDialog(false)}>Annuler</Button>
          <Button onClick={handleAddTeam} variant="contained" disabled={!selectedTeam}>Ajouter</Button>
        </DialogActions>
      </Dialog>

      {/* ── Schedule Dialog ── */}
      <Dialog open={scheduleDialog.open}
        onClose={() => setScheduleDialog({ open: false, match: null, date: '', location: '' })}
        maxWidth="xs" fullWidth>
        <DialogTitle>Planifier le match</DialogTitle>
        <DialogContent>
          <Box sx={{ display: 'flex', flexDirection: 'column', gap: 2, mt: 1 }}>
            <Typography variant="body2" color="text.secondary">
              {scheduleDialog.match?.homeTeam?.name} vs {scheduleDialog.match?.awayTeam?.name}
            </Typography>
            <input type="datetime-local" value={scheduleDialog.date}
              onChange={(e) => setScheduleDialog(s => ({ ...s, date: e.target.value }))}
              style={{ padding: 8, borderRadius: 4, border: '1px solid #cbd5e1', fontSize: 14 }} />
            <input type="text" placeholder="Lieu" value={scheduleDialog.location}
              onChange={(e) => setScheduleDialog(s => ({ ...s, location: e.target.value }))}
              style={{ padding: 8, borderRadius: 4, border: '1px solid #cbd5e1', fontSize: 14 }} />
          </Box>
        </DialogContent>
        <DialogActions>
          <Button onClick={() => setScheduleDialog({ open: false, match: null, date: '', location: '' })}>Annuler</Button>
          <Button variant="contained" onClick={saveSchedule}>Enregistrer</Button>
        </DialogActions>
      </Dialog>

      {/* ── Score Dialog ── */}
      <Dialog open={scoreDialog.open}
        onClose={() => setScoreDialog({ open: false, match: null, home: '', away: '' })}
        maxWidth="xs" fullWidth>
        <DialogTitle>Saisir le score</DialogTitle>
        <DialogContent>
          <Box sx={{ display: 'flex', flexDirection: 'column', gap: 2, mt: 1 }}>
            <Typography variant="body2" color="text.secondary">
              {scoreDialog.match?.homeTeam?.name} vs {scoreDialog.match?.awayTeam?.name}
            </Typography>
            <Box sx={{ display: 'flex', gap: 2, alignItems: 'center' }}>
              <input type="number" min="0" placeholder="Dom."
                value={scoreDialog.home}
                onChange={(e) => setScoreDialog(s => ({ ...s, home: e.target.value }))}
                style={{ flex: 1, padding: '10px 8px', borderRadius: 4, border: '1px solid #cbd5e1', fontSize: 22, fontWeight: 800, textAlign: 'center' }} />
              <Typography fontWeight={700} color="text.secondary">–</Typography>
              <input type="number" min="0" placeholder="Ext."
                value={scoreDialog.away}
                onChange={(e) => setScoreDialog(s => ({ ...s, away: e.target.value }))}
                style={{ flex: 1, padding: '10px 8px', borderRadius: 4, border: '1px solid #cbd5e1', fontSize: 22, fontWeight: 800, textAlign: 'center' }} />
            </Box>
          </Box>
        </DialogContent>
        <DialogActions>
          <Button onClick={() => setScoreDialog({ open: false, match: null, home: '', away: '' })}>Annuler</Button>
          <Button variant="contained" onClick={saveScore}>Enregistrer</Button>
        </DialogActions>
      </Dialog>
    </Box>
  );
};

export default TournamentDetails;
