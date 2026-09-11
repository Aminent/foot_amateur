import React, { useState, useEffect } from 'react';
import { authHeaders } from '../utils/api';
import { POSITION_CONFIG } from '../utils/positionConfig';
import { useNavigate, useLocation } from 'react-router-dom';
import dayjs from 'dayjs';
import Lottie from 'lottie-react';
import {
  Box, Grid, Card, CardContent, Typography, Button,
  Dialog, DialogTitle, DialogContent, DialogActions,
  TextField, FormControl, InputLabel, Select, MenuItem,
  Table, TableBody, TableCell, TableHead, TableRow, TableContainer,
  IconButton, Chip, Snackbar, Alert, Avatar, InputAdornment, Tooltip,
} from '@mui/material';
import { LocalizationProvider, DateCalendar } from '@mui/x-date-pickers';
import { PickersDay } from '@mui/x-date-pickers/PickersDay';
import { AdapterDayjs } from '@mui/x-date-pickers/AdapterDayjs';
import calendarAnimation from '../assets/Calendar.json';
import {
  Add as AddIcon,
  Edit as EditIcon,
  Delete as DeleteIcon,
  EmojiEvents as TrophyIcon,
  Group as GroupIcon,
  Person as PersonIcon,
  Visibility as VisibilityIcon,
  Assessment as AssessmentIcon,
  Search as SearchIcon,
  Refresh as RefreshIcon,
  SportsSoccer as SportsSoccerIcon,
  CheckCircle as CheckCircleIcon,
  WarningAmber as WarningIcon,
  SportsScore as ScoreIcon,
  Timeline as TimelineIcon,
  AssignmentTurnedIn as ApplicationsIcon,
  CheckCircleOutline as ApproveIcon,
  Cancel as RejectIcon,
  HourglassEmpty as PendingIcon,
  FiberManualRecord as FiberManualRecordIcon,
} from '@mui/icons-material';

const API = process.env.REACT_APP_API_URL || 'http://localhost:5000/api';

// POSITION_MAP replaced by shared POSITION_CONFIG (imported above)

const STATUS_MAP = {
  draft:     { label: 'Brouillon', color: 'default' },
  active:    { label: 'Actif',     color: 'success' },
  completed: { label: 'Terminé',   color: 'info' },
  cancelled: { label: 'Annulé',    color: 'error' },
};

const FORMAT_MAP = {
  league:               'Championnat',
  knockout:             'Élimination',
  group_then_knockout:  'Poules + Élim.',
};

const getInitials = (name = '') =>
  name.split(' ').map(n => n[0]).join('').toUpperCase().slice(0, 2) || '?';

// ── tiny shared components ────────────────────────────────────────────────────

const PositionChip = ({ position }) => {
  const cfg = POSITION_CONFIG[position];
  if (!cfg) return <Typography variant="body2" color="text.secondary">—</Typography>;
  return (
    <Chip
      label={cfg.label} size="small"
      sx={{ bgcolor: cfg.bg, color: cfg.color, fontWeight: 600, borderRadius: 1, fontSize: '0.72rem' }}
    />
  );
};

const StatusChip = ({ status }) => {
  const cfg = STATUS_MAP[status] || { label: status, color: 'default' };
  return <Chip label={cfg.label} color={cfg.color} size="small" sx={{ borderRadius: 1, fontWeight: 600, fontSize: '0.72rem' }} />;
};

const RowActions = ({ onView, onEdit, onDelete }) => (
  <Box sx={{ display: 'flex', gap: 0.25, justifyContent: 'flex-end' }}>
    {onView && (
      <Tooltip title="Voir"><IconButton size="small" onClick={onView} sx={{ color: 'text.secondary', '&:hover': { color: '#3b82f6' } }}><VisibilityIcon sx={{ fontSize: 16 }} /></IconButton></Tooltip>
    )}
    <Tooltip title="Modifier"><IconButton size="small" onClick={onEdit} sx={{ color: 'text.secondary', '&:hover': { color: '#f59e0b' } }}><EditIcon sx={{ fontSize: 16 }} /></IconButton></Tooltip>
    <Tooltip title="Supprimer"><IconButton size="small" onClick={onDelete} sx={{ color: 'text.secondary', '&:hover': { color: '#ef4444' } }}><DeleteIcon sx={{ fontSize: 16 }} /></IconButton></Tooltip>
  </Box>
);

const EmptyRow = ({ colSpan, message }) => (
  <TableRow>
    <TableCell colSpan={colSpan} sx={{ border: 0, py: 8, textAlign: 'center' }}>
      <Typography color="text.secondary" fontSize="0.875rem">{message}</Typography>
    </TableCell>
  </TableRow>
);

const SectionCard = ({ title, action, children }) => (
  <Card sx={{ bgcolor: 'background.paper', borderRadius: 3 }}>
    <Box sx={{ px: 3, py: 2, borderBottom: '1px solid', borderBottomColor: 'divider', display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
      <Typography sx={{ fontWeight: 700, color: 'text.primary', fontSize: '0.9rem' }}>{title}</Typography>
      {action}
    </Box>
    {children}
  </Card>
);

const TableHead2 = ({ cols }) => (
  <TableHead>
    <TableRow sx={{ '& .MuiTableCell-head': { bgcolor: 'action.hover', fontWeight: 600, fontSize: '0.72rem', color: 'text.secondary', textTransform: 'uppercase', letterSpacing: '0.05em', py: 1.25, borderBottom: '1px solid', borderBottomColor: 'divider' } }}>
      {cols.map((c, i) => <TableCell key={i} align={c.align}>{c.label}</TableCell>)}
    </TableRow>
  </TableHead>
);

// ── useCountUp hook ───────────────────────────────────────────────────────────

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

const KpiValue = ({ value }) => {
  const animated = useCountUp(typeof value === 'number' ? value : 0);
  return <>{typeof value === 'number' ? animated : value}</>;
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
    handlers: {
      onMouseMove:  (e) => move(e.clientX, e.clientY, e.currentTarget),
      onMouseEnter: () => setHovered(true),
      onMouseLeave: () => setHovered(false),
      onClick:      () => setColorIdx(i => (i + 1) % CARD_GLOW_COLORS.length),
      onTouchStart: (e) => { const t = e.touches[0]; move(t.clientX, t.clientY, e.currentTarget); setHovered(true); },
      onTouchMove:  (e) => { const t = e.touches[0]; move(t.clientX, t.clientY, e.currentTarget); },
      onTouchEnd:   () => setHovered(false),
    },
  };
};

const KpiCardItem = ({ card, index }) => {
  const { mouse, hovered, glow, handlers } = useCardInteraction();
  return (
    <Box sx={{
      animation: 'fadeInUp 0.35s ease both',
      animationDelay: `${index * 0.08}s`,
      '@keyframes fadeInUp': { from: { opacity: 0, transform: 'translateY(18px)' }, to: { opacity: 1, transform: 'translateY(0)' } },
    }}>
      <Card
        {...handlers}
        sx={{
          border: '1px solid',
          borderColor: hovered ? 'rgba(12,158,150,0.30)' : 'divider',
          boxShadow: hovered ? '0 20px 40px rgba(12,158,150,0.18)' : '0 1px 4px rgba(0,0,0,0.05)',
          borderRadius: 3,
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
        <CardContent sx={{ p: 2.5, '&:last-child': { pb: 2.5 }, position: 'relative', zIndex: 2 }}>
          <Box sx={{ display: 'flex', alignItems: 'flex-start', justifyContent: 'space-between', mb: 2 }}>
            <Typography sx={{ color: 'text.secondary', fontSize: '0.72rem', fontWeight: 600, textTransform: 'uppercase', letterSpacing: '0.05em' }}>
              {card.label}
            </Typography>
            <Box sx={{ width: 36, height: 36, borderRadius: 2, bgcolor: hovered ? glow : 'rgba(12,158,150,0.08)', display: 'flex', alignItems: 'center', justifyContent: 'center', color: '#0c9e96', transition: 'background 0.3s', '& svg': { fontSize: 18 } }}>
              {card.icon}
            </Box>
          </Box>
          <Typography sx={{ fontSize: '2rem', fontWeight: 800, color: 'text.primary', lineHeight: 1 }}>
            <KpiValue value={card.value} />
          </Typography>
        </CardContent>
      </Card>
    </Box>
  );
};

// ── main component ────────────────────────────────────────────────────────────

const AdminDashboard = () => {
  const navigate = useNavigate();
  const location = useLocation();

  // Derive active section from ?s= URL param so AdminLayout sidebar stays in sync
  const getUrlSection = () => parseInt(new URLSearchParams(location.search).get('s') || '0');
  const [activeSection, setActiveSection] = useState(getUrlSection);
  const [searchQuery, setSearchQuery] = useState('');
  const [loading, setLoading] = useState(true);

  // Keep activeSection in sync when URL changes (e.g. sidebar nav click)
  useEffect(() => {
    setActiveSection(getUrlSection());
    setSearchQuery('');
  }, [location.search]); // eslint-disable-line react-hooks/exhaustive-deps

  // data
  const [tournaments, setTournaments] = useState([]);
  const [teams, setTeams] = useState([]);
  const [players, setPlayers] = useState([]);
  const [coaches, setCoaches] = useState([]);
  const [applications, setApplications] = useState([]);
  const [appFilter, setAppFilter] = useState('all'); // 'all' | 'pending' | 'approved' | 'rejected'
  const [reviewDialog, setReviewDialog] = useState({ open: false, app: null, status: '', notes: '' });

  // feedback
  const [snackbar, setSnackbar] = useState({ open: false, message: '', severity: 'success' });
  const [confirmDlg, setConfirmDlg] = useState({ open: false, title: '', message: '', onConfirm: null });

  // dialogs open flags
  const [tournamentDialog, setTournamentDialog] = useState(false);
  const [teamDialog, setTeamDialog] = useState(false);
  const [playerDialog, setPlayerDialog] = useState(false);
  const [coachDialog, setCoachDialog] = useState(false);
  const [statsDialog, setStatsDialog] = useState(false);

  // editing targets
  const [editingTournament, setEditingTournament] = useState(null);
  const [editingTeam, setEditingTeam] = useState(null);
  const [editingPlayer, setEditingPlayer] = useState(null);
  const [editingCoach, setEditingCoach] = useState(null);
  const [editingPlayerStats, setEditingPlayerStats] = useState(null);

  // forms
  const emptyTournamentForm = { name: '', description: '', rules: '', startDate: '', endDate: '', status: 'draft', format: 'knockout', maxTeams: 16, location: '' };
  const emptyTeamForm = { name: '', description: '', tournamentId: '' };
  const emptyPlayerForm = { name: '', position: '', jerseyNumber: '', teamId: '', isCaptain: false, email: '', password: '', phone: '', dateOfBirth: '', height: '', weight: '', nationality: '', preferredFoot: '', joinDate: '', isActive: true };
  const emptyStatsForm = { goals: 0, assists: 0, shots: 0, shotsOnTarget: 0, passes: 0, keyPasses: 0, tackles: 0, interceptions: 0, clearances: 0, dribbles: 0, foulsCommitted: 0, foulsSuffered: 0, offsides: 0, saves: 0, cleanSheets: 0, goalsConceded: 0, penaltiesSaved: 0, duelsWon: 0, aerialDuelsWon: 0, minutesPlayed: 0, yellowCards: 0, redCards: 0 };
  const emptyCoachForm = { name: '', email: '', password: '', phone: '', teamId: '' };

  const [tournamentForm, setTournamentForm] = useState(emptyTournamentForm);
  const [teamForm, setTeamForm] = useState(emptyTeamForm);
  const [playerForm, setPlayerForm] = useState(emptyPlayerForm);
  const [statsForm, setStatsForm] = useState(emptyStatsForm);
  const [coachForm, setCoachForm] = useState(emptyCoachForm);

  // calendar
  const [selectedDate, setSelectedDate] = useState(dayjs());

  // ── match state ──────────────────────────────────────────────────────────────
  const [matches, setMatches] = useState([]);
  const [matchTournamentFilter, setMatchTournamentFilter] = useState('');
  const [matchFormDialog, setMatchFormDialog] = useState(false);
  const [editingMatch, setEditingMatch] = useState(null);
  const emptyMatchForm = { tournamentId: '', homeTeamId: '', awayTeamId: '', date: '', time: '15:00', location: '', roundNumber: '', referee: '', notes: '' };
  const [matchForm, setMatchForm] = useState(emptyMatchForm);

  const [resultsDialog, setResultsDialog] = useState(false);
  const [resultsTarget, setResultsTarget] = useState(null);
  const emptyResultsForm = { homeTeamScore: 0, awayTeamScore: 0, halfTimeHomeScore: 0, halfTimeAwayScore: 0, status: 'completed', referee: '', attendance: '', notes: '' };
  const [resultsForm, setResultsForm] = useState(emptyResultsForm);

  const [eventsDialog, setEventsDialog] = useState(false);
  const [eventsTarget, setEventsTarget] = useState(null);
  const [matchEvents, setMatchEvents] = useState([]);
  const emptyEventForm = { type: 'goal', minute: '', extraMinute: '', isHomeTeam: true, relatedPlayerName: '', description: '' };
  const [eventForm, setEventForm] = useState(emptyEventForm);

  // ── helpers ─────────────────────────────────────────────────────────────────

  const showSuccess = (msg) => setSnackbar({ open: true, message: msg, severity: 'success' });
  const showError   = (msg) => setSnackbar({ open: true, message: msg, severity: 'error' });
  const openConfirm = (title, message, onConfirm) => setConfirmDlg({ open: true, title, message, onConfirm });
  const closeConfirm = () => setConfirmDlg(d => ({ ...d, open: false }));

  // ── data fetching ────────────────────────────────────────────────────────────

  useEffect(() => { fetchData(); }, []);  // eslint-disable-line react-hooks/exhaustive-deps

  const fetchData = async () => {
    setLoading(true);
    try { await Promise.all([fetchTournaments(), fetchTeams(), fetchPlayers(), fetchCoaches(), fetchMatches(), fetchApplications()]); }
    catch { showError('Erreur lors du chargement des données'); }
    finally { setLoading(false); }
  };

  const fetchTournaments = async () => {
    const r = await fetch(`${API}/tournaments`, { headers: authHeaders() });
    if (!r.ok) throw new Error(`HTTP ${r.status}`);
    const d = await r.json();
    setTournaments(d.tournaments || d || []);
  };
  const fetchTeams = async () => {
    const r = await fetch(`${API}/teams`, { headers: authHeaders() });
    if (!r.ok) throw new Error(`HTTP ${r.status}`);
    const d = await r.json();
    setTeams(d.teams || d || []);
  };
  const fetchPlayers = async () => {
    const r = await fetch(`${API}/players`, { headers: authHeaders() });
    if (!r.ok) throw new Error(`HTTP ${r.status}`);
    const d = await r.json();
    setPlayers(d.players || d || []);
  };
  const fetchCoaches = async () => {
    const r = await fetch(`${API}/coaches`, { headers: authHeaders() });
    if (!r.ok) throw new Error(`HTTP ${r.status}`);
    const d = await r.json();
    setCoaches(d.coaches || d || []);
  };
  const fetchMatches = async () => {
    try {
      const r = await fetch(`${API}/matches`, { headers: authHeaders() });
      if (!r.ok) throw new Error(`HTTP ${r.status}`);
      const d = await r.json();
      setMatches(d.matches || []);
    } catch { setMatches([]); }
  };

  const fetchApplications = async () => {
    try {
      const r = await fetch(`${API}/tournament-applications/admin`, { headers: authHeaders() });
      if (r.ok) {
        const d = await r.json();
        setApplications(Array.isArray(d) ? d : []);
      }
    } catch { setApplications([]); }
  };

  const handleReviewApplication = async () => {
    const { app, status, notes } = reviewDialog;
    if (!status) return;
    try {
      const r = await fetch(`${API}/tournament-applications/${app.id}/review`, {
        method: 'PUT',
        headers: authHeaders(),
        body: JSON.stringify({ status, notes }),
      });
      if (!r.ok) { const e = await r.json(); throw new Error(e.message || 'Erreur'); }
      setReviewDialog({ open: false, app: null, status: '', notes: '' });
      await fetchApplications();
      showSuccess(status === 'approved' ? 'Candidature approuvée ✓' : 'Candidature rejetée');
    } catch (e) { showError(e.message); }
  };

  // ── CRUD: Tournaments ────────────────────────────────────────────────────────

  const handleCreateTournament = async () => {
    try {
      const r = await fetch(`${API}/tournaments`, { method: 'POST', headers: authHeaders(), body: JSON.stringify(tournamentForm) });
      if (r.ok) { setTournamentDialog(false); setEditingTournament(null); setTournamentForm(emptyTournamentForm); await fetchData(); showSuccess('Tournoi créé avec succès'); }
      else { const e = await r.json(); showError(e.message || 'Erreur création tournoi'); }
    } catch { showError('Erreur création tournoi'); }
  };

  const handleEditTournament = (t) => {
    setEditingTournament(t);
    setTournamentForm({ name: t.name || '', description: t.description || '', rules: t.rules || '', startDate: t.startDate ? t.startDate.split('T')[0] : '', endDate: t.endDate ? t.endDate.split('T')[0] : '', status: t.status || 'draft', format: t.format || 'knockout', maxTeams: t.maxTeams || 16, location: t.location || '' });
    setTournamentDialog(true);
  };

  const handleUpdateTournament = async () => {
    try {
      const r = await fetch(`${API}/tournaments/${editingTournament.id}`, { method: 'PUT', headers: authHeaders(), body: JSON.stringify(tournamentForm) });
      if (r.ok) { setTournamentDialog(false); setEditingTournament(null); setTournamentForm(emptyTournamentForm); await fetchData(); showSuccess('Tournoi modifié'); }
      else { const e = await r.json(); showError(e.message || 'Erreur mise à jour'); }
    } catch { showError('Erreur mise à jour tournoi'); }
  };

  const handleDeleteTournament = async (t) => {
    try {
      const r = await fetch(`${API}/tournaments/${t.id}`, { method: 'DELETE', headers: authHeaders() });
      if (r.ok) { await fetchData(); showSuccess('Tournoi supprimé'); }
      else { const e = await r.json(); showError(e.message || 'Erreur suppression'); }
    } catch { showError('Erreur suppression tournoi'); }
  };

  // ── CRUD: Teams ──────────────────────────────────────────────────────────────

  const handleCreateTeam = async () => {
    if (!teamForm.name.trim()) return showError("Le nom de l'équipe est requis");
    if (!teamForm.tournamentId) return showError('Veuillez sélectionner un tournoi');
    try {
      const r = await fetch(`${API}/teams`, { method: 'POST', headers: authHeaders(), body: JSON.stringify(teamForm) });
      if (r.ok) { setTeamDialog(false); setEditingTeam(null); setTeamForm(emptyTeamForm); await fetchData(); showSuccess('Équipe créée'); }
      else { const e = await r.json(); showError(e.message || 'Erreur création équipe'); }
    } catch { showError("Erreur création équipe"); }
  };

  const handleEditTeam = (t) => {
    setEditingTeam(t);
    setTeamForm({ name: t.name || '', description: t.description || '', tournamentId: t.tournamentId || '' });
    setTeamDialog(true);
  };

  const handleUpdateTeam = async () => {
    try {
      const r = await fetch(`${API}/teams/${editingTeam.id}`, { method: 'PUT', headers: authHeaders(), body: JSON.stringify(teamForm) });
      if (r.ok) { setTeamDialog(false); setEditingTeam(null); setTeamForm(emptyTeamForm); await fetchData(); showSuccess('Équipe modifiée'); }
      else { const e = await r.json(); showError(e.message || 'Erreur mise à jour'); }
    } catch { showError("Erreur mise à jour équipe"); }
  };

  const handleDeleteTeam = async (t) => {
    try {
      const r = await fetch(`${API}/teams/${t.id}`, { method: 'DELETE', headers: authHeaders() });
      if (r.ok) { await fetchData(); showSuccess('Équipe supprimée'); }
      else { const e = await r.json(); showError(e.message || 'Erreur suppression'); }
    } catch { showError("Erreur suppression équipe"); }
  };

  // ── CRUD: Players ────────────────────────────────────────────────────────────

  const cleanPlayer = (f) => ({
    ...f,
    dateOfBirth: f.dateOfBirth?.trim() || null,
    joinDate: f.joinDate?.trim() || null,
    height: f.height && !isNaN(parseInt(f.height)) ? parseInt(f.height) : null,
    weight: f.weight && !isNaN(parseInt(f.weight)) ? parseInt(f.weight) : null,
    jerseyNumber: f.jerseyNumber && !isNaN(parseInt(f.jerseyNumber)) ? parseInt(f.jerseyNumber) : null,
    nationality: f.nationality?.trim() || null,
    preferredFoot: f.preferredFoot || null,
    email: f.email?.trim() || null,
    phone: f.phone?.trim() || null,
  });

  const handleCreatePlayer = async () => {
    if (!playerForm.name.trim()) return showError('Le nom du joueur est requis');
    if (!playerForm.position)    return showError('La position du joueur est requise');
    try {
      const r = await fetch(`${API}/players`, { method: 'POST', headers: authHeaders(), body: JSON.stringify(cleanPlayer(playerForm)) });
      if (r.ok) { setPlayerDialog(false); setEditingPlayer(null); setPlayerForm(emptyPlayerForm); await fetchData(); showSuccess('Joueur créé'); }
      else { const e = await r.json(); showError(e.message || 'Erreur création joueur'); }
    } catch { showError('Erreur création joueur'); }
  };

  const handleEditPlayer = (p) => {
    setEditingPlayer(p);
    setPlayerForm({ name: p.name || '', position: p.position || '', jerseyNumber: p.jerseyNumber?.toString() || '', teamId: p.teamId || '', isCaptain: p.isCaptain || false, email: p.email || '', password: '', phone: p.phone || '', dateOfBirth: p.dateOfBirth ? p.dateOfBirth.split('T')[0] : '', height: p.height?.toString() || '', weight: p.weight?.toString() || '', nationality: p.nationality || '', preferredFoot: p.preferredFoot || '', joinDate: p.joinDate ? p.joinDate.split('T')[0] : '', isActive: p.isActive !== undefined ? p.isActive : true });
    setPlayerDialog(true);
  };

  const handleUpdatePlayer = async () => {
    try {
      const r = await fetch(`${API}/players/${editingPlayer.id}`, { method: 'PUT', headers: authHeaders(), body: JSON.stringify(cleanPlayer(playerForm)) });
      if (r.ok) { setPlayerDialog(false); setEditingPlayer(null); setPlayerForm(emptyPlayerForm); await fetchData(); showSuccess('Joueur modifié'); }
      else {
        const e = await r.json();
        if (e.errors?.length) showError('Validation: ' + e.errors.map(x => x.msg).join(', '));
        else showError(e.message || e.error || 'Erreur mise à jour joueur');
      }
    } catch (err) { showError('Erreur mise à jour joueur: ' + err.message); }
  };

  const handleDeletePlayer = async (p) => {
    try {
      const r = await fetch(`${API}/players/${p.id}`, { method: 'DELETE', headers: authHeaders() });
      if (r.ok) { await fetchData(); showSuccess('Joueur supprimé'); }
      else { const e = await r.json(); showError(e.message || 'Erreur suppression'); }
    } catch { showError('Erreur suppression joueur'); }
  };

  // ── CRUD: Coaches ────────────────────────────────────────────────────────────

  const handleCreateCoach = async () => {
    if (!coachForm.name.trim()) return showError('Le nom du coach est requis');
    if (!coachForm.email.trim()) return showError("L'email du coach est requis");
    if (!coachForm.password.trim()) return showError('Le mot de passe est requis');
    try {
      const r = await fetch(`${API}/coaches`, { method: 'POST', headers: authHeaders(), body: JSON.stringify(coachForm) });
      if (r.ok) { setCoachDialog(false); setEditingCoach(null); setCoachForm(emptyCoachForm); await fetchData(); showSuccess('Coach créé'); }
      else { const e = await r.json(); showError(e.message || 'Erreur création coach'); }
    } catch { showError('Erreur création coach'); }
  };

  const handleEditCoach = (c) => {
    setEditingCoach(c);
    setCoachForm({ name: c.name || '', email: c.email || '', password: '', phone: c.phone || '', teamId: c.teamId || '' });
    setCoachDialog(true);
  };

  const handleUpdateCoach = async () => {
    try {
      const data = { ...coachForm };
      if (!data.password.trim()) delete data.password;
      const r = await fetch(`${API}/coaches/${editingCoach.id}`, { method: 'PUT', headers: authHeaders(), body: JSON.stringify(data) });
      if (r.ok) { setCoachDialog(false); setEditingCoach(null); setCoachForm(emptyCoachForm); await fetchData(); showSuccess('Coach modifié'); }
      else { const e = await r.json(); showError(e.message || 'Erreur mise à jour'); }
    } catch { showError('Erreur mise à jour coach'); }
  };

  const handleDeleteCoach = async (c) => {
    try {
      const r = await fetch(`${API}/coaches/${c.id}`, { method: 'DELETE', headers: authHeaders() });
      if (r.ok) { await fetchData(); showSuccess('Coach supprimé'); }
      else { const e = await r.json(); showError(e.message || 'Erreur suppression'); }
    } catch { showError('Erreur suppression coach'); }
  };

  // ── Stats ────────────────────────────────────────────────────────────────────

  const handleEditPlayerStats = async (player) => {
    try {
      const r = await fetch(`${API}/player-stats/${player.id}`, { headers: authHeaders() });
      if (r.ok) {
        const d = await r.json();
        setEditingPlayerStats(player);
        const s = d.stats || {};
        setStatsForm({ goals: s.goals||0, assists: s.assists||0, shots: s.shots||0, shotsOnTarget: s.shotsOnTarget||0, passes: s.passes||0, keyPasses: s.keyPasses||0, tackles: s.tackles||0, interceptions: s.interceptions||0, clearances: s.clearances||0, dribbles: s.dribbles||0, foulsCommitted: s.foulsCommitted||0, foulsSuffered: s.foulsSuffered||0, offsides: s.offsides||0, saves: s.saves||0, cleanSheets: s.cleanSheets||0, goalsConceded: s.goalsConceded||0, penaltiesSaved: s.penaltiesSaved||0, duelsWon: s.duelsWon||0, aerialDuelsWon: s.aerialDuelsWon||0, minutesPlayed: s.minutesPlayed||0, yellowCards: s.yellowCards||0, redCards: s.redCards||0 });
        setStatsDialog(true);
      } else { const e = await r.json(); showError(e.message || 'Erreur chargement stats'); }
    } catch { showError('Erreur chargement statistiques'); }
  };

  const handleUpdatePlayerStats = async () => {
    try {
      const r = await fetch(`${API}/player-stats/${editingPlayerStats.id}`, { method: 'PUT', headers: authHeaders(), body: JSON.stringify(statsForm) });
      if (r.ok) { setStatsDialog(false); setEditingPlayerStats(null); setStatsForm(emptyStatsForm); await fetchData(); showSuccess('Statistiques mises à jour'); }
      else { const e = await r.json(); showError(e.message || 'Erreur mise à jour stats'); }
    } catch { showError('Erreur mise à jour statistiques'); }
  };

  // ── CRUD: Matches ────────────────────────────────────────────────────────────

  const buildMatchDatetime = (date, time) => {
    if (!date) return null;
    return `${date}T${time || '15:00'}:00`;
  };

  const handleCreateMatch = async () => {
    if (!matchForm.homeTeamId || !matchForm.awayTeamId) return showError('Les deux équipes sont requises');
    if (!matchForm.date) return showError('La date est requise');
    if (matchForm.homeTeamId === matchForm.awayTeamId) return showError('Les équipes domicile et visiteur doivent être différentes');
    try {
      const body = { ...matchForm, date: buildMatchDatetime(matchForm.date, matchForm.time), roundNumber: matchForm.roundNumber || undefined };
      delete body.time;
      const r = await fetch(`${API}/matches`, { method: 'POST', headers: authHeaders(), body: JSON.stringify(body) });
      if (r.ok) { setMatchFormDialog(false); setMatchForm(emptyMatchForm); await fetchMatches(); showSuccess('Match planifié'); }
      else { const e = await r.json(); showError(e.message || 'Erreur création match'); }
    } catch { showError('Erreur création match'); }
  };

  const handleEditMatch = (m) => {
    setEditingMatch(m);
    const dt = m.date ? new Date(m.date) : null;
    const dateStr = dt ? dt.toISOString().split('T')[0] : '';
    const timeStr = dt ? dt.toTimeString().slice(0, 5) : '15:00';
    setMatchForm({ tournamentId: m.tournamentId || '', homeTeamId: m.homeTeamId || '', awayTeamId: m.awayTeamId || '', date: dateStr, time: timeStr, location: m.location || '', roundNumber: m.roundNumber?.toString() || '', referee: m.referee || '', notes: m.notes || '' });
    setMatchFormDialog(true);
  };

  const handleUpdateMatch = async () => {
    try {
      const body = { ...matchForm, date: buildMatchDatetime(matchForm.date, matchForm.time), roundNumber: matchForm.roundNumber || undefined };
      delete body.time;
      const r = await fetch(`${API}/matches/${editingMatch.id}`, { method: 'PUT', headers: authHeaders(), body: JSON.stringify(body) });
      if (r.ok) { setMatchFormDialog(false); setEditingMatch(null); setMatchForm(emptyMatchForm); await fetchMatches(); showSuccess('Match modifié'); }
      else { const e = await r.json(); showError(e.message || 'Erreur mise à jour'); }
    } catch { showError('Erreur mise à jour match'); }
  };

  const handleDeleteMatch = async (m) => {
    try {
      const r = await fetch(`${API}/matches/${m.id}`, { method: 'DELETE', headers: authHeaders() });
      if (r.ok) { await fetchMatches(); showSuccess('Match supprimé'); }
      else { const e = await r.json(); showError(e.message || 'Erreur suppression'); }
    } catch { showError('Erreur suppression match'); }
  };

  const openResultsDialog = (m) => {
    setResultsTarget(m);
    setResultsForm({ homeTeamScore: m.homeTeamScore ?? 0, awayTeamScore: m.awayTeamScore ?? 0, halfTimeHomeScore: m.halfTimeHomeScore ?? 0, halfTimeAwayScore: m.halfTimeAwayScore ?? 0, status: m.status, referee: m.referee || '', attendance: m.attendance?.toString() || '', notes: m.notes || '' });
    setResultsDialog(true);
  };

  const handleSaveResults = async () => {
    try {
      const r = await fetch(`${API}/matches/${resultsTarget.id}`, { method: 'PUT', headers: authHeaders(), body: JSON.stringify({ ...resultsForm, homeTeamScore: Number(resultsForm.homeTeamScore), awayTeamScore: Number(resultsForm.awayTeamScore), halfTimeHomeScore: Number(resultsForm.halfTimeHomeScore), halfTimeAwayScore: Number(resultsForm.halfTimeAwayScore), attendance: resultsForm.attendance ? parseInt(resultsForm.attendance) : null }) });
      if (r.ok) { setResultsDialog(false); setResultsTarget(null); await fetchMatches(); showSuccess('Résultats enregistrés'); }
      else { const e = await r.json(); showError(e.message || 'Erreur enregistrement résultats'); }
    } catch { showError('Erreur enregistrement résultats'); }
  };

  const openEventsDialog = async (m) => {
    setEventsTarget(m);
    setMatchEvents(m.events || []);
    setEventForm(emptyEventForm);
    setEventsDialog(true);
  };

  const handleAddEvent = async () => {
    if (!eventForm.minute) return showError('La minute est requise');
    try {
      const r = await fetch(`${API}/matches/${eventsTarget.id}/events`, { method: 'POST', headers: authHeaders(), body: JSON.stringify({ ...eventForm, minute: parseInt(eventForm.minute), extraMinute: eventForm.extraMinute ? parseInt(eventForm.extraMinute) : undefined, isHomeTeam: Boolean(eventForm.isHomeTeam) }) });
      if (r.ok) {
        const d = await r.json();
        setMatchEvents(d.match?.events || []);
        setEventsTarget(d.match || eventsTarget);
        setEventForm(emptyEventForm);
        await fetchMatches();
        showSuccess('Événement ajouté');
      } else { const e = await r.json(); showError(e.message || 'Erreur ajout événement'); }
    } catch { showError('Erreur ajout événement'); }
  };

  const handleDeleteEvent = async (eventId) => {
    try {
      const r = await fetch(`${API}/matches/${eventsTarget.id}/events/${eventId}`, { method: 'DELETE', headers: authHeaders() });
      if (r.ok) {
        const d = await r.json();
        setMatchEvents(d.match?.events || matchEvents.filter(e => e.id !== eventId));
        setEventsTarget(d.match || eventsTarget);
        await fetchMatches();
        showSuccess('Événement supprimé');
      } else { const e = await r.json(); showError(e.message || 'Erreur suppression événement'); }
    } catch { showError('Erreur suppression événement'); }
  };

  // ── Calendar helpers ─────────────────────────────────────────────────────────

  const getTournamentCategory = (t) => {
    if (!t.startDate && !t.endDate) return 'unknown';
    const now = dayjs();
    const start = t.startDate ? dayjs(t.startDate) : null;
    const end = t.endDate ? dayjs(t.endDate) : start;
    if (end && end.isBefore(now, 'day')) return 'past';
    if (start && start.isAfter(now, 'day')) return 'upcoming';
    return 'ongoing';
  };

  const tournamentsOnDay = (day) => tournaments.filter(t => {
    if (!t.startDate) return false;
    const s = dayjs(t.startDate), e = t.endDate ? dayjs(t.endDate) : s;
    return !day.isBefore(s, 'day') && !day.isAfter(e, 'day');
  });

  const matchesOnDay = (day) => matches.filter(m => m.date && dayjs(m.date).isSame(day, 'day'));

  const tournamentsOnSelected = tournamentsOnDay(selectedDate);
  const matchesOnSelected = matchesOnDay(selectedDate);

  // ── filtered lists ───────────────────────────────────────────────────────────

  const q = searchQuery.toLowerCase();
  const filteredTournaments = tournaments.filter(t => t.name?.toLowerCase().includes(q));
  const filteredTeams       = teams.filter(t => t.name?.toLowerCase().includes(q));
  const filteredPlayers     = players.filter(p => p.name?.toLowerCase().includes(q));
  const filteredCoaches     = coaches.filter(c => c.name?.toLowerCase().includes(q) || c.email?.toLowerCase().includes(q));

  // ── nav config ───────────────────────────────────────────────────────────────

  // Section labels (used by TopBar) — icons live in AdminLayout
  const navItems = [
    { id: 0, label: 'Tournois' },
    { id: 1, label: 'Équipes' },
    { id: 2, label: 'Joueurs' },
    { id: 3, label: 'Coaches' },
    { id: 4, label: 'Statistiques' },
    { id: 5, label: 'Calendrier' },
    { id: 6, label: 'Matchs' },
    { id: 7, label: 'Candidatures' },
  ];

  const kpiCards = [
    { label: 'Tournois',        value: tournaments.length,                                     icon: <TrophyIcon />,      color: '#3b82f6', bg: '#eff6ff' },
    { label: 'Équipes',         value: teams.length,                                           icon: <GroupIcon />,       color: '#10b981', bg: '#ecfdf5' },
    { label: 'Joueurs',         value: players.length,                                         icon: <PersonIcon />,      color: '#f59e0b', bg: '#fffbeb' },
    { label: 'Matchs joués',    value: matches.filter(m => m.status === 'completed').length,   icon: <CheckCircleIcon />,  color: '#8b5cf6', bg: '#f5f3ff' },
    { label: 'Candidatures',    value: applications.filter(a => a.status === 'pending').length, icon: <PendingIcon />,      color: '#f43f5e', bg: '#fff1f2' },
  ];

  // TopBar inliné dans le render (évite la perte de focus du champ de recherche)

  // ── render: KPI cards ────────────────────────────────────────────────────────

  const KpiCards = () => (
    <Grid container spacing={2} sx={{ mb: 3 }}>
      {kpiCards.map((card, i) => (
        <Grid item xs={6} md={3} key={i}>
          <KpiCardItem card={card} index={i} />
        </Grid>
      ))}
    </Grid>
  );

  // ── render: sections ─────────────────────────────────────────────────────────

  const TournamentsSection = () => (
    <SectionCard
      title={`${filteredTournaments.length} tournoi${filteredTournaments.length !== 1 ? 's' : ''}`}
      action={<Button variant="contained" size="small" startIcon={<AddIcon />} onClick={() => { setEditingTournament(null); setTournamentForm(emptyTournamentForm); setTournamentDialog(true); }}>Nouveau</Button>}
    >
      <TableContainer>
        <Table>
          <TableHead2 cols={[{ label: 'Nom' }, { label: 'Statut' }, { label: 'Format' }, { label: 'Début' }, { label: 'Fin' }, { label: 'Équipes' }, { label: 'Actions', align: 'right' }]} />
          <TableBody>
            {filteredTournaments.length === 0
              ? <EmptyRow colSpan={7} message={searchQuery ? 'Aucun tournoi trouvé pour cette recherche' : 'Aucun tournoi créé'} />
              : filteredTournaments.map(t => {
                const teamCount = teams.filter(tm => tm.tournamentId === t.id).length;
                return (
                  <TableRow key={t.id} sx={{ '&:hover': { bgcolor: 'action.hover' }, '& td': { py: 1.5, fontSize: '0.875rem' } }}>
                    <TableCell>
                      <Typography sx={{ fontWeight: 600, color: 'text.primary', fontSize: '0.875rem', cursor: 'pointer', '&:hover': { color: '#3b82f6' } }} onClick={() => navigate(`/admin/tournaments/${t.id}`)}>{t.name}</Typography>
                    </TableCell>
                    <TableCell><StatusChip status={t.status} /></TableCell>
                    <TableCell><Chip label={FORMAT_MAP[t.format] || t.format} size="small" variant="outlined" sx={{ borderRadius: 1, fontSize: '0.72rem' }} /></TableCell>
                    <TableCell sx={{ color: 'text.secondary' }}>{t.startDate ? new Date(t.startDate).toLocaleDateString('fr-FR') : '—'}</TableCell>
                    <TableCell sx={{ color: 'text.secondary' }}>{t.endDate ? new Date(t.endDate).toLocaleDateString('fr-FR') : '—'}</TableCell>
                    <TableCell><Typography sx={{ fontWeight: 700, color: teamCount > 0 ? '#10b981' : '#94a3b8', fontSize: '0.875rem' }}>{teamCount}</Typography></TableCell>
                    <TableCell>
                      <RowActions
                        onView={() => navigate(`/admin/tournaments/${t.id}`)}
                        onEdit={() => handleEditTournament(t)}
                        onDelete={() => openConfirm('Supprimer le tournoi', `Supprimer "${t.name}" ? Cette action est irréversible.`, () => handleDeleteTournament(t))}
                      />
                    </TableCell>
                  </TableRow>
                );
              })}
          </TableBody>
        </Table>
      </TableContainer>
    </SectionCard>
  );

  const TeamsSection = () => (
    <SectionCard
      title={`${filteredTeams.length} équipe${filteredTeams.length !== 1 ? 's' : ''}`}
      action={<Button variant="contained" size="small" startIcon={<AddIcon />} onClick={() => { setEditingTeam(null); setTeamForm(emptyTeamForm); setTeamDialog(true); }}>Nouvelle</Button>}
    >
      <TableContainer>
        <Table>
          <TableHead2 cols={[{ label: 'Équipe' }, { label: 'Tournoi' }, { label: 'Joueurs' }, { label: 'Capitaine' }, { label: 'Actions', align: 'right' }]} />
          <TableBody>
            {filteredTeams.length === 0
              ? <EmptyRow colSpan={5} message={searchQuery ? 'Aucune équipe trouvée' : 'Aucune équipe créée'} />
              : filteredTeams.map(t => {
                const teamPlayers = players.filter(p => p.teamId === t.id);
                const captain = teamPlayers.find(p => p.isCaptain);
                const tournament = tournaments.find(tr => tr.id === t.tournamentId);
                return (
                  <TableRow key={t.id} sx={{ '&:hover': { bgcolor: 'action.hover' }, '& td': { py: 1.5 } }}>
                    <TableCell>
                      <Box sx={{ display: 'flex', alignItems: 'center', gap: 1.5 }}>
                        <Avatar sx={{ width: 32, height: 32, bgcolor: '#dbeafe', color: '#1e40af', fontSize: '0.75rem', fontWeight: 700 }}>{getInitials(t.name)}</Avatar>
                        <Typography sx={{ fontWeight: 600, fontSize: '0.875rem', cursor: 'pointer', '&:hover': { color: '#3b82f6' } }} onClick={() => navigate(`/admin/teams/${t.id}`)}>{t.name}</Typography>
                      </Box>
                    </TableCell>
                    <TableCell sx={{ color: 'text.secondary', fontSize: '0.875rem' }}>{tournament?.name || <Typography fontSize="0.875rem" color="text.secondary" fontStyle="italic">Non assigné</Typography>}</TableCell>
                    <TableCell><Typography sx={{ fontWeight: 700, color: teamPlayers.length > 0 ? '#10b981' : '#94a3b8', fontSize: '0.875rem' }}>{teamPlayers.length}</Typography></TableCell>
                    <TableCell sx={{ color: 'text.secondary', fontSize: '0.875rem' }}>{captain?.name || '—'}</TableCell>
                    <TableCell>
                      <RowActions
                        onView={() => navigate(`/admin/teams/${t.id}`)}
                        onEdit={() => handleEditTeam(t)}
                        onDelete={() => openConfirm('Supprimer l\'équipe', `Supprimer "${t.name}" ?`, () => handleDeleteTeam(t))}
                      />
                    </TableCell>
                  </TableRow>
                );
              })}
          </TableBody>
        </Table>
      </TableContainer>
    </SectionCard>
  );

  const PlayersSection = () => (
    <SectionCard
      title={`${filteredPlayers.length} joueur${filteredPlayers.length !== 1 ? 's' : ''}`}
      action={<Button variant="contained" size="small" startIcon={<AddIcon />} onClick={() => { setEditingPlayer(null); setPlayerForm(emptyPlayerForm); setPlayerDialog(true); }}>Nouveau</Button>}
    >
      <TableContainer>
        <Table>
          <TableHead2 cols={[{ label: 'Joueur' }, { label: 'Position' }, { label: 'N°' }, { label: 'Équipe' }, { label: 'Statut' }, { label: 'Actions', align: 'right' }]} />
          <TableBody>
            {filteredPlayers.length === 0
              ? <EmptyRow colSpan={6} message={searchQuery ? 'Aucun joueur trouvé' : 'Aucun joueur créé'} />
              : filteredPlayers.map(p => {
                const team = teams.find(t => t.id === p.teamId);
                return (
                  <TableRow key={p.id} sx={{ '&:hover': { bgcolor: 'action.hover' }, '& td': { py: 1.25 } }}>
                    <TableCell>
                      <Box sx={{ display: 'flex', alignItems: 'center', gap: 1.5 }}>
                        <Avatar sx={{ width: 32, height: 32, bgcolor: '#f0fdf4', color: '#166534', fontSize: '0.75rem', fontWeight: 700 }}>{getInitials(p.name)}</Avatar>
                        <Box>
                          <Typography sx={{ fontWeight: 600, fontSize: '0.875rem', cursor: 'pointer', '&:hover': { color: '#3b82f6' } }} onClick={() => navigate(`/admin/players/${p.id}`)}>{p.name}</Typography>
                          {p.isCaptain && <Typography sx={{ fontSize: '0.68rem', color: '#f59e0b', fontWeight: 600 }}>Capitaine</Typography>}
                        </Box>
                      </Box>
                    </TableCell>
                    <TableCell><PositionChip position={p.position} /></TableCell>
                    <TableCell sx={{ color: 'text.secondary', fontSize: '0.875rem', fontWeight: 600 }}>{p.jerseyNumber ? `#${p.jerseyNumber}` : '—'}</TableCell>
                    <TableCell sx={{ color: 'text.secondary', fontSize: '0.875rem' }}>{team?.name || '—'}</TableCell>
                    <TableCell>
                      <Box sx={{ width: 8, height: 8, borderRadius: '50%', bgcolor: p.isActive !== false ? '#10b981' : '#ef4444', display: 'inline-block', mr: 0.75 }} />
                      <Typography component="span" sx={{ fontSize: '0.8rem', color: 'text.secondary' }}>{p.isActive !== false ? 'Actif' : 'Inactif'}</Typography>
                    </TableCell>
                    <TableCell>
                      <RowActions
                        onView={() => navigate(`/admin/players/${p.id}`)}
                        onEdit={() => handleEditPlayer(p)}
                        onDelete={() => openConfirm('Supprimer le joueur', `Supprimer "${p.name}" ?`, () => handleDeletePlayer(p))}
                      />
                    </TableCell>
                  </TableRow>
                );
              })}
          </TableBody>
        </Table>
      </TableContainer>
    </SectionCard>
  );

  const CoachesSection = () => (
    <SectionCard
      title={`${filteredCoaches.length} coach${filteredCoaches.length !== 1 ? 'es' : ''}`}
      action={<Button variant="contained" size="small" startIcon={<AddIcon />} onClick={() => { setEditingCoach(null); setCoachForm(emptyCoachForm); setCoachDialog(true); }}>Nouveau</Button>}
    >
      <TableContainer>
        <Table>
          <TableHead2 cols={[{ label: 'Coach' }, { label: 'Email' }, { label: 'Téléphone' }, { label: 'Équipe' }, { label: 'Actions', align: 'right' }]} />
          <TableBody>
            {filteredCoaches.length === 0
              ? <EmptyRow colSpan={5} message={searchQuery ? 'Aucun coach trouvé' : 'Aucun coach créé'} />
              : filteredCoaches.map(c => {
                const team = teams.find(t => t.id === c.teamId);
                return (
                  <TableRow key={c.id} sx={{ '&:hover': { bgcolor: 'action.hover' }, '& td': { py: 1.5 } }}>
                    <TableCell>
                      <Box sx={{ display: 'flex', alignItems: 'center', gap: 1.5 }}>
                        <Avatar sx={{ width: 32, height: 32, bgcolor: '#fdf4ff', color: '#7e22ce', fontSize: '0.75rem', fontWeight: 700 }}>{getInitials(c.name)}</Avatar>
                        <Typography sx={{ fontWeight: 600, fontSize: '0.875rem' }}>{c.name}</Typography>
                      </Box>
                    </TableCell>
                    <TableCell sx={{ color: 'text.secondary', fontSize: '0.875rem' }}>{c.email}</TableCell>
                    <TableCell sx={{ color: 'text.secondary', fontSize: '0.875rem' }}>{c.phone || '—'}</TableCell>
                    <TableCell sx={{ color: 'text.secondary', fontSize: '0.875rem' }}>{team?.name || c.team?.name || <Typography fontStyle="italic" fontSize="0.875rem" color="text.secondary">Non assigné</Typography>}</TableCell>
                    <TableCell>
                      <RowActions
                        onEdit={() => handleEditCoach(c)}
                        onDelete={() => openConfirm('Supprimer le coach', `Supprimer "${c.name}" ?`, () => handleDeleteCoach(c))}
                      />
                    </TableCell>
                  </TableRow>
                );
              })}
          </TableBody>
        </Table>
      </TableContainer>
    </SectionCard>
  );

  const StatsSection = () => (
    <SectionCard title={`Statistiques — ${players.length} joueur${players.length !== 1 ? 's' : ''}`}>
      <TableContainer>
        <Table>
          <TableHead2 cols={[{ label: 'Joueur' }, { label: 'Équipe' }, { label: 'Position' }, { label: 'Buts' }, { label: 'Passes D.' }, { label: 'Minutes' }, { label: 'Stats', align: 'right' }]} />
          <TableBody>
            {players.length === 0
              ? <EmptyRow colSpan={7} message="Aucun joueur" />
              : players.map(p => (
                <TableRow key={p.id} sx={{ '&:hover': { bgcolor: 'action.hover' }, '& td': { py: 1.25 } }}>
                  <TableCell>
                    <Box sx={{ display: 'flex', alignItems: 'center', gap: 1.5 }}>
                      <Avatar sx={{ width: 30, height: 30, bgcolor: '#f0fdf4', color: '#166534', fontSize: '0.7rem', fontWeight: 700 }}>{getInitials(p.name)}</Avatar>
                      <Typography sx={{ fontWeight: 600, fontSize: '0.875rem' }}>{p.name}</Typography>
                    </Box>
                  </TableCell>
                  <TableCell sx={{ color: 'text.secondary', fontSize: '0.875rem' }}>{p.team?.name || teams.find(t => t.id === p.teamId)?.name || '—'}</TableCell>
                  <TableCell><PositionChip position={p.position} /></TableCell>
                  <TableCell sx={{ fontWeight: 700, fontSize: '0.875rem' }}>{p.stats?.goals ?? 0}</TableCell>
                  <TableCell sx={{ fontWeight: 700, fontSize: '0.875rem' }}>{p.stats?.assists ?? 0}</TableCell>
                  <TableCell sx={{ color: 'text.secondary', fontSize: '0.875rem' }}>{p.stats?.minutesPlayed ?? 0} min</TableCell>
                  <TableCell align="right">
                    <Tooltip title="Modifier les statistiques">
                      <IconButton size="small" onClick={() => handleEditPlayerStats(p)} sx={{ color: 'text.secondary', '&:hover': { color: '#3b82f6' } }}>
                        <AssessmentIcon sx={{ fontSize: 16 }} />
                      </IconButton>
                    </Tooltip>
                  </TableCell>
                </TableRow>
              ))}
          </TableBody>
        </Table>
      </TableContainer>
    </SectionCard>
  );

  const CalendarSection = () => (
    <Grid container spacing={3}>
      <Grid item xs={12} md={5}>
        <Card sx={{ border: '1px solid', borderColor: 'divider', boxShadow: 'none', borderRadius: 2 }}>
          <CardContent sx={{ p: 2.5 }}>
            <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start' }}>
              <Box sx={{ flex: 1 }}>
                <Typography sx={{ fontWeight: 600, color: 'text.primary', mb: 1.5 }}>Calendrier des tournois</Typography>
                <LocalizationProvider dateAdapter={AdapterDayjs}>
                  <DateCalendar
                    value={selectedDate}
                    onChange={v => v && setSelectedDate(v)}
                    slots={{ day: (props) => {
                      const { day, ...other } = props;
                      const onDay = tournamentsOnDay(day);
                      const mOnDay = matchesOnDay(day);
                      const hasTournament = onDay.length > 0;
                      const hasMatch = mOnDay.length > 0;

                      if (!hasTournament && !hasMatch) return <PickersDay day={day} {...other} />;

                      if (hasTournament) {
                        const hasActive = onDay.some(t => { const e = t.endDate ? dayjs(t.endDate) : dayjs(t.startDate); return !e.isBefore(dayjs(), 'day') && t.status !== 'completed'; });
                        const color = hasActive ? '#3b82f6' : '#64748b';
                        return (
                          <Box sx={{ position: 'relative', display: 'inline-flex', flexDirection: 'column', alignItems: 'center' }}>
                            <PickersDay day={day} {...other} sx={{ bgcolor: color, color: 'white', fontWeight: 700, '&:hover': { bgcolor: color, opacity: 0.85 }, '&.Mui-selected': { bgcolor: color, color: 'white' } }} />
                            {hasMatch && <Box sx={{ position: 'absolute', bottom: -3, width: 5, height: 5, borderRadius: '50%', bgcolor: '#f59e0b' }} />}
                          </Box>
                        );
                      }

                      // only match(es) on this day
                      return (
                        <Box sx={{ position: 'relative', display: 'inline-flex', flexDirection: 'column', alignItems: 'center' }}>
                          <PickersDay day={day} {...other} />
                          <Box sx={{ position: 'absolute', bottom: -3, width: 5, height: 5, borderRadius: '50%', bgcolor: '#f59e0b' }} />
                        </Box>
                      );
                    }}}
                  />
                </LocalizationProvider>
              </Box>
              <Box sx={{ ml: 1, width: 100, height: 80, flexShrink: 0 }}>
                <Lottie animationData={calendarAnimation} loop autoplay style={{ width: '100%', height: '100%' }} />
              </Box>
            </Box>
          </CardContent>
        </Card>
      </Grid>

      <Grid item xs={12} md={7}>
        <Grid container spacing={2} sx={{ mb: 2 }}>
          {[
            { label: 'À venir',  cat: 'upcoming', color: '#3b82f6', bg: '#eff6ff' },
            { label: 'En cours', cat: 'ongoing',  color: '#10b981', bg: '#ecfdf5' },
            { label: 'Terminés', cat: 'past',     color: '#64748b', bg: '#f8fafc' },
          ].map(({ label, cat, color, bg }) => (
            <Grid item xs={4} key={cat}>
              <Card sx={{ border: '1px solid', borderColor: 'divider', borderLeft: `3px solid ${color}`, boxShadow: 'none', borderRadius: 2 }}>
                <CardContent sx={{ p: 2, '&:last-child': { pb: 2 } }}>
                  <Typography sx={{ color: 'text.secondary', fontSize: '0.75rem', fontWeight: 600 }}>{label}</Typography>
                  <Typography sx={{ fontSize: '1.5rem', fontWeight: 700, color, mt: 0.5 }}>{tournaments.filter(t => getTournamentCategory(t) === cat).length}</Typography>
                </CardContent>
              </Card>
            </Grid>
          ))}
        </Grid>

        <Card sx={{ border: '1px solid', borderColor: 'divider', boxShadow: 'none', borderRadius: 2 }}>
          <Box sx={{ px: 2.5, py: 2, borderBottom: '1px solid', borderColor: 'divider' }}>
            <Typography sx={{ fontWeight: 600, color: 'text.primary', fontSize: '0.9rem' }}>Tournois — {selectedDate.format('DD/MM/YYYY')}</Typography>
          </Box>
          {tournamentsOnSelected.length === 0
            ? <Box sx={{ py: 3, textAlign: 'center' }}><Typography fontSize="0.875rem" color="text.secondary">Aucun tournoi ce jour</Typography></Box>
            : (
              <TableContainer>
                <Table size="small">
                  <TableHead2 cols={[{ label: 'Nom' }, { label: 'Période' }, { label: 'Catégorie' }]} />
                  <TableBody>
                    {tournamentsOnSelected.map(t => {
                      const cat = getTournamentCategory(t);
                      const catCfg = { upcoming: { label: 'À venir', color: 'primary' }, ongoing: { label: 'En cours', color: 'success' }, past: { label: 'Terminé', color: 'default' } }[cat] || { label: 'N/A', color: 'default' };
                      return (
                        <TableRow key={t.id} sx={{ '& td': { py: 1.25, fontSize: '0.875rem' } }}>
                          <TableCell sx={{ fontWeight: 600 }}>{t.name}</TableCell>
                          <TableCell sx={{ color: 'text.secondary' }}>{(t.startDate ? dayjs(t.startDate).format('DD/MM/YY') : '?')} – {(t.endDate ? dayjs(t.endDate).format('DD/MM/YY') : '?')}</TableCell>
                          <TableCell><Chip label={catCfg.label} color={catCfg.color} size="small" sx={{ borderRadius: 1, fontWeight: 600, fontSize: '0.72rem' }} /></TableCell>
                        </TableRow>
                      );
                    })}
                  </TableBody>
                </Table>
              </TableContainer>
            )}

          {/* ── Matchs du jour ── */}
          <Box sx={{ px: 2.5, py: 1.5, borderTop: '1px solid', borderColor: 'divider', bgcolor: 'background.default' }}>
            <Typography sx={{ fontWeight: 600, color: 'text.primary', fontSize: '0.9rem' }}>
              Matchs — {selectedDate.format('DD/MM/YYYY')}
              {matchesOnSelected.length > 0 && (
                <Chip label={matchesOnSelected.length} size="small" sx={{ ml: 1, fontWeight: 700, fontSize: '0.7rem', height: 18, bgcolor: '#f59e0b', color: 'white' }} />
              )}
            </Typography>
          </Box>
          {matchesOnSelected.length === 0
            ? <Box sx={{ py: 3, textAlign: 'center' }}><Typography fontSize="0.875rem" color="text.secondary">Aucun match ce jour</Typography></Box>
            : (
              <TableContainer>
                <Table size="small">
                  <TableHead2 cols={[{ label: 'Match' }, { label: 'Heure' }, { label: 'Statut' }]} />
                  <TableBody>
                    {matchesOnSelected.map(m => {
                      const st = MATCH_STATUS[m.status] || { label: m.status, color: '#64748b' };
                      const homeTeam = m.homeTeam?.name || m.homeTeamId || '?';
                      const awayTeam = m.awayTeam?.name || m.awayTeamId || '?';
                      const score = m.status === 'completed'
                        ? `${m.homeTeamScore ?? 0} – ${m.awayTeamScore ?? 0}`
                        : 'vs';
                      return (
                        <TableRow key={m.id} sx={{ '& td': { py: 1.25, fontSize: '0.875rem' } }}>
                          <TableCell sx={{ fontWeight: 600 }}>{homeTeam} <Box component="span" sx={{ color: 'text.secondary', fontWeight: 400 }}>{score}</Box> {awayTeam}</TableCell>
                          <TableCell sx={{ color: 'text.secondary', whiteSpace: 'nowrap' }}>{m.date ? dayjs(m.date).format('HH:mm') : '—'}</TableCell>
                          <TableCell><Chip label={st.label} size="small" sx={{ borderRadius: 1, fontWeight: 600, fontSize: '0.72rem', bgcolor: st.bg, color: st.color }} /></TableCell>
                        </TableRow>
                      );
                    })}
                  </TableBody>
                </Table>
              </TableContainer>
            )}
        </Card>
      </Grid>
    </Grid>
  );

  // ── match helpers ─────────────────────────────────────────────────────────────

  const MATCH_STATUS = {
    scheduled:   { label: 'Planifié',    color: '#3b82f6', bg: '#eff6ff' },
    in_progress: { label: 'En cours',    color: '#f59e0b', bg: '#fffbeb' },
    completed:   { label: 'Terminé',     color: '#10b981', bg: '#ecfdf5' },
    postponed:   { label: 'Reporté',     color: '#8b5cf6', bg: '#f5f3ff' },
    cancelled:   { label: 'Annulé',      color: '#ef4444', bg: '#fef2f2' },
  };

  const EVENT_CFG = {
    goal:          { label: '⚽ But',             color: '#10b981' },
    penalty_goal:  { label: '⚽ But (péna.)',      color: '#059669' },
    own_goal:      { label: '⚽ CSC',              color: '#ef4444' },
    assist:        { label: '🎯 Passe D.',          color: '#3b82f6' },
    yellow_card:   { label: '🟨 Carton jaune',     color: '#f59e0b' },
    red_card:      { label: '🟥 Carton rouge',     color: '#ef4444' },
    substitution:  { label: '↕ Remplacement',      color: '#8b5cf6' },
    injury:        { label: '🤕 Blessure',          color: '#f97316' },
  };

  const MatchStatusBadge = ({ status }) => {
    const cfg = MATCH_STATUS[status] || { label: status, color: '#64748b', bg: '#f8fafc' };
    return <Chip label={cfg.label} size="small" sx={{ borderRadius: 1, fontWeight: 600, fontSize: '0.72rem', bgcolor: cfg.bg, color: cfg.color, border: `1px solid ${cfg.color}30` }} />;
  };

  const MatchScoreBox = ({ m }) => {
    if (m.status === 'scheduled' || m.status === 'postponed' || m.status === 'cancelled') {
      return <Typography sx={{ color: '#94a3b8', fontSize: '0.875rem' }}>vs</Typography>;
    }
    return (
      <Box sx={{ display: 'flex', alignItems: 'center', gap: 1 }}>
        <Typography sx={{ fontWeight: 800, fontSize: '1.1rem', color: m.homeTeamScore > m.awayTeamScore ? '#10b981' : m.homeTeamScore < m.awayTeamScore ? '#ef4444' : '#64748b' }}>{m.homeTeamScore ?? 0}</Typography>
        <Typography sx={{ color: '#94a3b8', fontWeight: 600 }}>–</Typography>
        <Typography sx={{ fontWeight: 800, fontSize: '1.1rem', color: m.awayTeamScore > m.homeTeamScore ? '#10b981' : m.awayTeamScore < m.homeTeamScore ? '#ef4444' : '#64748b' }}>{m.awayTeamScore ?? 0}</Typography>
      </Box>
    );
  };

  const filteredMatches = matches.filter(m => {
    if (matchTournamentFilter && m.tournamentId !== parseInt(matchTournamentFilter)) return false;
    return true;
  });

  // group by tournament then by round
  const matchGroups = filteredMatches.reduce((acc, m) => {
    const key = m.tournament?.name || 'Sans tournoi';
    if (!acc[key]) acc[key] = {};
    const round = m.roundNumber ? `Tour ${m.roundNumber}` : 'Non groupé';
    if (!acc[key][round]) acc[key][round] = [];
    acc[key][round].push(m);
    return acc;
  }, {});

  const MatchesSection = () => (
    <Box>
      {/* toolbar */}
      <Box sx={{ display: 'flex', gap: 2, mb: 2, alignItems: 'center', flexWrap: 'wrap' }}>
        <FormControl size="small" sx={{ minWidth: 220 }}>
          <InputLabel>Filtrer par tournoi</InputLabel>
          <Select value={matchTournamentFilter} onChange={e => setMatchTournamentFilter(e.target.value)} label="Filtrer par tournoi" sx={{ borderRadius: 2 }}>
            <MenuItem value="">Tous les tournois</MenuItem>
            {tournaments.map(t => <MenuItem key={t.id} value={t.id}>{t.name}</MenuItem>)}
          </Select>
        </FormControl>
        <Box sx={{ flex: 1 }} />
        <Button variant="contained" startIcon={<AddIcon />} size="small"
          onClick={() => { setEditingMatch(null); setMatchForm(emptyMatchForm); setMatchFormDialog(true); }}
         >
          Planifier un match
        </Button>
      </Box>

      {filteredMatches.length === 0 ? (
        <Card sx={{ border: '1px solid', borderColor: 'divider', boxShadow: 'none', borderRadius: 2, py: 8, textAlign: 'center' }}>
          <SportsSoccerIcon sx={{ fontSize: 40, color: 'action.disabledBackground', mb: 1 }} />
          <Typography color="text.secondary" fontSize="0.9rem">
            {matchTournamentFilter ? 'Aucun match pour ce tournoi' : 'Aucun match planifié'}
          </Typography>
        </Card>
      ) : (
        Object.entries(matchGroups).map(([tournamentName, rounds]) => (
          <Box key={tournamentName} sx={{ mb: 3 }}>
            <Typography sx={{ fontWeight: 700, fontSize: '0.8rem', color: 'text.secondary', textTransform: 'uppercase', letterSpacing: '0.06em', mb: 1.5, display: 'flex', alignItems: 'center', gap: 1 }}>
              <TrophyIcon sx={{ fontSize: 14 }} /> {tournamentName}
            </Typography>
            {Object.entries(rounds).map(([round, roundMatches]) => (
              <Box key={round} sx={{ mb: 2 }}>
                {Object.keys(rounds).length > 1 && (
                  <Typography sx={{ fontSize: '0.75rem', color: '#94a3b8', fontWeight: 600, mb: 1, pl: 0.5 }}>{round}</Typography>
                )}
                <Card sx={{ border: '1px solid', borderColor: 'divider', boxShadow: 'none', borderRadius: 2 }}>
                  <TableContainer>
                    <Table>
                      <TableHead2 cols={[{ label: 'Date' }, { label: 'Domicile' }, { label: 'Score' }, { label: 'Visiteur' }, { label: 'Lieu' }, { label: 'Statut' }, { label: 'Actions', align: 'right' }]} />
                      <TableBody>
                        {roundMatches.map(m => (
                          <TableRow key={m.id} sx={{ '&:hover': { bgcolor: 'action.hover' }, '& td': { py: 1.5 } }}>
                            <TableCell>
                              <Typography sx={{ fontSize: '0.8rem', fontWeight: 600, color: 'text.primary' }}>
                                {m.date ? new Date(m.date).toLocaleDateString('fr-FR', { day: '2-digit', month: 'short' }) : '—'}
                              </Typography>
                              <Typography sx={{ fontSize: '0.72rem', color: '#94a3b8' }}>
                                {m.date ? new Date(m.date).toLocaleTimeString('fr-FR', { hour: '2-digit', minute: '2-digit' }) : ''}
                              </Typography>
                            </TableCell>
                            <TableCell>
                              <Box sx={{ display: 'flex', alignItems: 'center', gap: 1 }}>
                                <Avatar sx={{ width: 26, height: 26, bgcolor: '#dbeafe', color: '#1e40af', fontSize: '0.65rem', fontWeight: 700 }}>{getInitials(m.homeTeam?.name)}</Avatar>
                                <Typography sx={{ fontWeight: m.winnerTeamId === m.homeTeamId ? 700 : 400, fontSize: '0.875rem', color: m.winnerTeamId === m.homeTeamId ? '#10b981' : 'text.primary' }}>
                                  {m.homeTeam?.name || '?'}
                                </Typography>
                              </Box>
                            </TableCell>
                            <TableCell align="center"><MatchScoreBox m={m} /></TableCell>
                            <TableCell>
                              <Box sx={{ display: 'flex', alignItems: 'center', gap: 1 }}>
                                <Avatar sx={{ width: 26, height: 26, bgcolor: '#fee2e2', color: '#991b1b', fontSize: '0.65rem', fontWeight: 700 }}>{getInitials(m.awayTeam?.name)}</Avatar>
                                <Typography sx={{ fontWeight: m.winnerTeamId === m.awayTeamId ? 700 : 400, fontSize: '0.875rem', color: m.winnerTeamId === m.awayTeamId ? '#10b981' : 'text.primary' }}>
                                  {m.awayTeam?.name || '?'}
                                </Typography>
                              </Box>
                            </TableCell>
                            <TableCell sx={{ color: 'text.secondary', fontSize: '0.8rem', maxWidth: 120 }}>
                              <Typography noWrap sx={{ fontSize: '0.8rem', color: 'text.secondary' }}>{m.location || '—'}</Typography>
                            </TableCell>
                            <TableCell><MatchStatusBadge status={m.status} /></TableCell>
                            <TableCell align="right">
                              <Box sx={{ display: 'flex', gap: 0.25, justifyContent: 'flex-end', alignItems: 'center' }}>
                                {(m.status === 'scheduled' || m.status === 'in_progress' || m.status === 'half_time') && (
                                  <Tooltip title="Mode Live">
                                    <IconButton size="small" onClick={() => navigate(`/admin/matches/${m.id}/live`)} sx={{ color: m.status === 'in_progress' ? '#10b981' : 'text.secondary', '&:hover': { color: '#10b981' } }}>
                                      <FiberManualRecordIcon sx={{ fontSize: 13, ...(m.status === 'in_progress' && { animation: 'livePulse 1.5s infinite' }) }} />
                                    </IconButton>
                                  </Tooltip>
                                )}
                                <Tooltip title="Modifier le match">
                                  <IconButton size="small" onClick={() => handleEditMatch(m)} sx={{ color: 'text.secondary', '&:hover': { color: '#f59e0b' } }}><EditIcon sx={{ fontSize: 15 }} /></IconButton>
                                </Tooltip>
                                <Tooltip title="Saisir le résultat">
                                  <IconButton size="small" onClick={() => openResultsDialog(m)} sx={{ color: 'text.secondary', '&:hover': { color: '#10b981' } }}><ScoreIcon sx={{ fontSize: 15 }} /></IconButton>
                                </Tooltip>
                                <Tooltip title="Événements du match">
                                  <IconButton size="small" onClick={() => openEventsDialog(m)} sx={{ color: 'text.secondary', '&:hover': { color: '#3b82f6' } }}><TimelineIcon sx={{ fontSize: 15 }} /></IconButton>
                                </Tooltip>
                                <Tooltip title="Supprimer">
                                  <IconButton size="small" onClick={() => openConfirm('Supprimer le match', `Supprimer ce match entre "${m.homeTeam?.name}" et "${m.awayTeam?.name}" ?`, () => handleDeleteMatch(m))} sx={{ color: 'text.secondary', '&:hover': { color: '#ef4444' } }}><DeleteIcon sx={{ fontSize: 15 }} /></IconButton>
                                </Tooltip>
                              </Box>
                            </TableCell>
                          </TableRow>
                        ))}
                      </TableBody>
                    </Table>
                  </TableContainer>
                </Card>
              </Box>
            ))}
          </Box>
        ))
      )}
    </Box>
  );

  // ── render: Applications ─────────────────────────────────────────────────────

  const APP_STATUS = {
    pending:  { label: 'En attente',  color: '#f59e0b', bg: '#fffbeb', icon: <PendingIcon sx={{ fontSize: 14 }} /> },
    approved: { label: 'Approuvée',   color: '#16a34a', bg: '#f0fdf4', icon: <ApproveIcon sx={{ fontSize: 14 }} /> },
    rejected: { label: 'Rejetée',     color: '#dc2626', bg: '#fef2f2', icon: <RejectIcon  sx={{ fontSize: 14 }} /> },
  };

  const AppStatusBadge = ({ status }) => {
    const cfg = APP_STATUS[status] || { label: status, color: '#64748b', bg: '#f1f5f9', icon: null };
    return (
      <Box sx={{ display: 'inline-flex', alignItems: 'center', gap: 0.5, bgcolor: cfg.bg,
        color: cfg.color, borderRadius: 1, px: 1, py: 0.3, fontWeight: 600, fontSize: '0.72rem' }}>
        {cfg.icon}{cfg.label}
      </Box>
    );
  };

  const filteredApps = applications.filter(a => appFilter === 'all' || a.status === appFilter);
  const pendingCount  = applications.filter(a => a.status === 'pending').length;
  const approvedCount = applications.filter(a => a.status === 'approved').length;
  const rejectedCount = applications.filter(a => a.status === 'rejected').length;

  const ApplicationsSection = () => (
    <Box>
      {/* Summary chips */}
      <Box sx={{ display: 'flex', gap: 1.5, mb: 2, flexWrap: 'wrap' }}>
        {[
          { key: 'all',      label: `Toutes (${applications.length})`,   color: 'default' },
          { key: 'pending',  label: `En attente (${pendingCount})`,       color: 'warning' },
          { key: 'approved', label: `Approuvées (${approvedCount})`,      color: 'success' },
          { key: 'rejected', label: `Rejetées (${rejectedCount})`,        color: 'error'   },
        ].map(f => (
          <Chip key={f.key} label={f.label} color={f.color}
            variant={appFilter === f.key ? 'filled' : 'outlined'}
            onClick={() => setAppFilter(f.key)}
            sx={{ fontWeight: 600, fontSize: '0.78rem', cursor: 'pointer', borderRadius: 1.5 }}
          />
        ))}
      </Box>

      <SectionCard title={`Candidatures (${filteredApps.length})`}>
        <TableContainer>
          <Table size="small">
            <TableHead2 cols={[
              { label: 'Équipe' },
              { label: 'Coach' },
              { label: 'Tournoi' },
              { label: 'Soumise le' },
              { label: 'Statut', align: 'center' },
              { label: 'Notes' },
              { label: 'Actions', align: 'right' },
            ]} />
            <TableBody>
              {filteredApps.length === 0
                ? <EmptyRow colSpan={7} message="Aucune candidature dans cette catégorie" />
                : filteredApps.map(app => (
                  <TableRow key={app.id} hover>
                    <TableCell>
                      <Box sx={{ display: 'flex', alignItems: 'center', gap: 1 }}>
                        <Avatar sx={{ width: 28, height: 28, bgcolor: '#3b82f6', fontSize: '0.65rem', fontWeight: 700 }}>
                          {getInitials(app.team?.name)}
                        </Avatar>
                        <Typography fontSize="0.85rem" fontWeight={600}>{app.team?.name || '—'}</Typography>
                      </Box>
                    </TableCell>
                    <TableCell>
                      <Typography fontSize="0.82rem">{app.team?.coach?.name || '—'}</Typography>
                      <Typography fontSize="0.72rem" color="text.secondary">{app.team?.coach?.email || ''}</Typography>
                    </TableCell>
                    <TableCell>
                      <Typography fontSize="0.82rem" fontWeight={500}>{app.tournament?.name || '—'}</Typography>
                    </TableCell>
                    <TableCell>
                      <Typography fontSize="0.78rem" color="text.secondary">
                        {app.appliedAt ? new Date(app.appliedAt).toLocaleDateString('fr-FR') : '—'}
                      </Typography>
                    </TableCell>
                    <TableCell align="center">
                      <AppStatusBadge status={app.status} />
                    </TableCell>
                    <TableCell sx={{ maxWidth: 180 }}>
                      <Typography fontSize="0.78rem" color="text.secondary" noWrap title={app.notes || ''}>
                        {app.notes || '—'}
                      </Typography>
                    </TableCell>
                    <TableCell align="right">
                      {app.status === 'pending' ? (
                        <Box sx={{ display: 'flex', gap: 0.5, justifyContent: 'flex-end' }}>
                          <Tooltip title="Approuver">
                            <IconButton size="small"
                              onClick={() => setReviewDialog({ open: true, app, status: 'approved', notes: '' })}
                              sx={{ color: '#16a34a', '&:hover': { bgcolor: '#f0fdf4' } }}>
                              <ApproveIcon sx={{ fontSize: 17 }} />
                            </IconButton>
                          </Tooltip>
                          <Tooltip title="Rejeter">
                            <IconButton size="small"
                              onClick={() => setReviewDialog({ open: true, app, status: 'rejected', notes: '' })}
                              sx={{ color: '#dc2626', '&:hover': { bgcolor: '#fef2f2' } }}>
                              <RejectIcon sx={{ fontSize: 17 }} />
                            </IconButton>
                          </Tooltip>
                        </Box>
                      ) : (
                        <Typography fontSize="0.72rem" color="text.secondary">
                          {app.reviewedAt ? new Date(app.reviewedAt).toLocaleDateString('fr-FR') : '—'}
                        </Typography>
                      )}
                    </TableCell>
                  </TableRow>
                ))
              }
            </TableBody>
          </Table>
        </TableContainer>
      </SectionCard>
    </Box>
  );

  const sectionComponents = [TournamentsSection, TeamsSection, PlayersSection, CoachesSection, StatsSection, CalendarSection, MatchesSection, ApplicationsSection];
  const ActiveSection = sectionComponents[activeSection];

  // ── dialogs shared style ─────────────────────────────────────────────────────

  const statsFieldsByPosition = (pos) => {
    const p = (pos || '').toLowerCase();
    if (p.includes('gardien')) return [
      { label: 'Arrêts', color: '#1e40af', fields: [['Arrêts', 'saves'], ['Clean sheets', 'cleanSheets'], ['Buts encaissés', 'goalsConceded'], ['Penalties arrêtés', 'penaltiesSaved']] },
      { label: 'Jeu au pied', color: '#065f46', fields: [['Passes', 'passes'], ['Passes clés', 'keyPasses']] },
      { label: 'Défense', color: '#92400e', fields: [['Dégagements', 'clearances'], ['Duels aériens gagnés', 'aerialDuelsWon']] },
      { label: 'Discipline & Temps', color: '#6b21a8', fields: [['Cartons jaunes', 'yellowCards'], ['Cartons rouges', 'redCards'], ['Minutes jouées', 'minutesPlayed']] },
    ];
    if (p.includes('defenseur')) return [
      { label: 'Défense', color: '#1e40af', fields: [['Tacles', 'tackles'], ['Interceptions', 'interceptions'], ['Dégagements', 'clearances'], ['Duels gagnés', 'duelsWon'], ['Duels aériens gagnés', 'aerialDuelsWon']] },
      { label: 'Passes', color: '#065f46', fields: [['Passes', 'passes'], ['Passes clés', 'keyPasses'], ['Passes décisives', 'assists']] },
      { label: 'Attaque', color: '#991b1b', fields: [['Buts', 'goals']] },
      { label: 'Fautes', color: '#92400e', fields: [['Fautes commises', 'foulsCommitted'], ['Fautes subies', 'foulsSuffered']] },
      { label: 'Discipline & Temps', color: '#6b21a8', fields: [['Cartons jaunes', 'yellowCards'], ['Cartons rouges', 'redCards'], ['Minutes jouées', 'minutesPlayed']] },
    ];
    if (p.includes('milieu')) return [
      { label: 'Passes', color: '#065f46', fields: [['Passes', 'passes'], ['Passes clés', 'keyPasses'], ['Passes décisives', 'assists']] },
      { label: 'Attaque', color: '#991b1b', fields: [['Buts', 'goals'], ['Tirs', 'shots'], ['Tirs cadrés', 'shotsOnTarget'], ['Dribbles', 'dribbles']] },
      { label: 'Défense', color: '#1e40af', fields: [['Tacles', 'tackles'], ['Interceptions', 'interceptions']] },
      { label: 'Fautes', color: '#92400e', fields: [['Fautes commises', 'foulsCommitted'], ['Fautes subies', 'foulsSuffered']] },
      { label: 'Discipline & Temps', color: '#6b21a8', fields: [['Cartons jaunes', 'yellowCards'], ['Cartons rouges', 'redCards'], ['Minutes jouées', 'minutesPlayed']] },
    ];
    // attaquant (default)
    return [
      { label: 'Attaque', color: '#991b1b', fields: [['Buts', 'goals'], ['Passes décisives', 'assists'], ['Tirs', 'shots'], ['Tirs cadrés', 'shotsOnTarget'], ['Dribbles', 'dribbles'], ['Hors-jeu', 'offsides']] },
      { label: 'Passes', color: '#065f46', fields: [['Passes', 'passes'], ['Passes clés', 'keyPasses']] },
      { label: 'Fautes', color: '#92400e', fields: [['Fautes commises', 'foulsCommitted'], ['Fautes subies', 'foulsSuffered']] },
      { label: 'Discipline & Temps', color: '#6b21a8', fields: [['Cartons jaunes', 'yellowCards'], ['Cartons rouges', 'redCards'], ['Minutes jouées', 'minutesPlayed']] },
    ];
  };

  const dlgSx = { '& .MuiDialog-paper': { borderRadius: 2.5 } };
  const dlgTitleSx = { fontWeight: 700, fontSize: '1rem', pb: 1 };
  const closeDlg = (setter, setEditing) => { setter(false); setEditing && setEditing(null); };

  const numField = (label, key, form, setForm, extra = {}) => (
    <TextField fullWidth type="number" label={label} value={form[key]}
      onChange={e => setForm(f => ({ ...f, [key]: parseInt(e.target.value) || 0 }))}
      inputProps={{ min: 0, ...extra }} size="small" />
  );

  // ── main render ──────────────────────────────────────────────────────────────

  return (
    <Box sx={{ display: 'flex', flexDirection: 'column', minHeight: '100vh', bgcolor: 'background.default' }}>

      {/* ── TopBar inline — ne pas extraire en composant pour éviter la perte de focus ── */}
      <Box sx={{ height: 60, bgcolor: 'background.paper', borderBottom: '1px solid', borderColor: 'divider', display: 'flex', alignItems: 'center', px: 3, gap: 2, position: 'sticky', top: 0, zIndex: 100 }}>
        <Typography sx={{ fontWeight: 700, color: 'text.primary', fontSize: '1rem' }}>{navItems[activeSection]?.label}</Typography>
        <Box sx={{ flex: 1 }} />
        {activeSection < 4 && activeSection !== 7 && (
          <TextField size="small" placeholder="Rechercher…" value={searchQuery} onChange={e => setSearchQuery(e.target.value)}
            InputProps={{ startAdornment: <InputAdornment position="start"><SearchIcon sx={{ fontSize: 16, color: '#94a3b8' }} /></InputAdornment> }}
            sx={{ width: 200, '& .MuiOutlinedInput-root': { borderRadius: 2, fontSize: '0.875rem' } }}
          />
        )}
        <Tooltip title="Rafraîchir">
          <IconButton size="small" onClick={fetchData} disabled={loading} sx={{ color: 'text.secondary' }}>
            <RefreshIcon sx={{ fontSize: 18 }} />
          </IconButton>
        </Tooltip>
      </Box>

      <Box sx={{ p: 3, flex: 1 }}>
        <KpiCards />
        <ActiveSection />
      </Box>

      <style>{`@keyframes livePulse { 0%,100%{opacity:1} 50%{opacity:0.2} }`}</style>

      {/* ── Snackbar ─────────────────────────────────────────────────────────── */}
      <Snackbar open={snackbar.open} autoHideDuration={4000} onClose={() => setSnackbar(s => ({ ...s, open: false }))} anchorOrigin={{ vertical: 'bottom', horizontal: 'right' }}>
        <Alert severity={snackbar.severity} onClose={() => setSnackbar(s => ({ ...s, open: false }))} sx={{ borderRadius: 2 }}>{snackbar.message}</Alert>
      </Snackbar>

      {/* ── Confirm dialog ───────────────────────────────────────────────────── */}
      <Dialog open={confirmDlg.open} maxWidth="xs" fullWidth sx={dlgSx}>
        <DialogTitle sx={dlgTitleSx}>
          <Box sx={{ display: 'flex', alignItems: 'center', gap: 1 }}>
            <Box sx={{ width: 32, height: 32, borderRadius: '50%', bgcolor: '#fef2f2', display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
              <WarningIcon sx={{ fontSize: 16, color: '#ef4444' }} />
            </Box>
            {confirmDlg.title}
          </Box>
        </DialogTitle>
        <DialogContent><Typography sx={{ color: 'text.secondary', fontSize: '0.9rem' }}>{confirmDlg.message}</Typography></DialogContent>
        <DialogActions>
          <Button variant="outlined" color="inherit" onClick={closeConfirm}>Annuler</Button>
          <Button variant="contained" color="error"
            onClick={() => { confirmDlg.onConfirm?.(); closeConfirm(); }}>
            Supprimer
          </Button>
        </DialogActions>
      </Dialog>

      {/* ── Tournament dialog ────────────────────────────────────────────────── */}
      <Dialog open={tournamentDialog} onClose={() => closeDlg(setTournamentDialog, setEditingTournament)} maxWidth="md" fullWidth sx={dlgSx}>
        <DialogTitle sx={dlgTitleSx}>{editingTournament ? 'Modifier le tournoi' : 'Nouveau tournoi'}</DialogTitle>
        <DialogContent>
          <Grid container spacing={2} sx={{ mt: 0.5 }}>
            <Grid item xs={12}>
              <TextField fullWidth label="Nom du tournoi" value={tournamentForm.name} onChange={e => setTournamentForm(f => ({ ...f, name: e.target.value }))} />
            </Grid>
            <Grid item xs={12}>
              <TextField fullWidth multiline rows={2} label="Description" value={tournamentForm.description} onChange={e => setTournamentForm(f => ({ ...f, description: e.target.value }))} />
            </Grid>
            <Grid item xs={12}>
              <TextField fullWidth multiline rows={2} label="Règles" value={tournamentForm.rules} onChange={e => setTournamentForm(f => ({ ...f, rules: e.target.value }))} />
            </Grid>
            <Grid item xs={6}>
              <TextField fullWidth type="date" label="Date de début" InputLabelProps={{ shrink: true }} value={tournamentForm.startDate} onChange={e => setTournamentForm(f => ({ ...f, startDate: e.target.value }))} />
            </Grid>
            <Grid item xs={6}>
              <TextField fullWidth type="date" label="Date de fin" InputLabelProps={{ shrink: true }} value={tournamentForm.endDate} onChange={e => setTournamentForm(f => ({ ...f, endDate: e.target.value }))} />
            </Grid>
            <Grid item xs={6}>
              <FormControl fullWidth>
                <InputLabel>Statut</InputLabel>
                <Select value={tournamentForm.status} onChange={e => setTournamentForm(f => ({ ...f, status: e.target.value }))}>
                  <MenuItem value="draft">Brouillon</MenuItem>
                  <MenuItem value="active">Actif</MenuItem>
                  <MenuItem value="completed">Terminé</MenuItem>
                  <MenuItem value="cancelled">Annulé</MenuItem>
                </Select>
              </FormControl>
            </Grid>
            <Grid item xs={6}>
              <FormControl fullWidth>
                <InputLabel>Format</InputLabel>
                <Select value={tournamentForm.format} onChange={e => setTournamentForm(f => ({ ...f, format: e.target.value }))}>
                  <MenuItem value="league">Championnat</MenuItem>
                  <MenuItem value="knockout">Élimination directe</MenuItem>
                  <MenuItem value="group_then_knockout">Poules puis élimination</MenuItem>
                </Select>
              </FormControl>
            </Grid>
            <Grid item xs={6}>
              <TextField fullWidth type="number" label="Max équipes" value={tournamentForm.maxTeams} onChange={e => setTournamentForm(f => ({ ...f, maxTeams: parseInt(e.target.value) }))} inputProps={{ min: 2, max: 64 }} />
            </Grid>
            <Grid item xs={6}>
              <TextField fullWidth label="Lieu" value={tournamentForm.location} onChange={e => setTournamentForm(f => ({ ...f, location: e.target.value }))} />
            </Grid>
          </Grid>
        </DialogContent>
        <DialogActions>
          <Button variant="outlined" color="inherit" onClick={() => closeDlg(setTournamentDialog, setEditingTournament)}>Annuler</Button>
          <Button variant="contained" onClick={editingTournament ? handleUpdateTournament : handleCreateTournament}>
            {editingTournament ? 'Enregistrer' : 'Créer'}
          </Button>
        </DialogActions>
      </Dialog>

      {/* ── Team dialog ──────────────────────────────────────────────────────── */}
      <Dialog open={teamDialog} onClose={() => closeDlg(setTeamDialog, setEditingTeam)} maxWidth="sm" fullWidth sx={dlgSx}>
        <DialogTitle sx={dlgTitleSx}>{editingTeam ? "Modifier l'équipe" : 'Nouvelle équipe'}</DialogTitle>
        <DialogContent>
          <Grid container spacing={2} sx={{ mt: 0.5 }}>
            <Grid item xs={12}>
              <TextField fullWidth required label="Nom de l'équipe" value={teamForm.name} onChange={e => setTeamForm(f => ({ ...f, name: e.target.value }))} />
            </Grid>
            <Grid item xs={12}>
              <TextField fullWidth multiline rows={2} label="Description" value={teamForm.description} onChange={e => setTeamForm(f => ({ ...f, description: e.target.value }))} />
            </Grid>
            <Grid item xs={12}>
              <FormControl fullWidth required>
                <InputLabel>Tournoi</InputLabel>
                <Select value={teamForm.tournamentId} onChange={e => setTeamForm(f => ({ ...f, tournamentId: e.target.value }))}>
                  {tournaments.map(t => <MenuItem key={t.id} value={t.id}>{t.name} ({FORMAT_MAP[t.format] || t.format})</MenuItem>)}
                </Select>
              </FormControl>
            </Grid>
          </Grid>
        </DialogContent>
        <DialogActions>
          <Button variant="outlined" color="inherit" onClick={() => closeDlg(setTeamDialog, setEditingTeam)}>Annuler</Button>
          <Button variant="contained" onClick={editingTeam ? handleUpdateTeam : handleCreateTeam}>
            {editingTeam ? 'Enregistrer' : 'Créer'}
          </Button>
        </DialogActions>
      </Dialog>

      {/* ── Player dialog ────────────────────────────────────────────────────── */}
      <Dialog open={playerDialog} onClose={() => closeDlg(setPlayerDialog, setEditingPlayer)} maxWidth="md" fullWidth sx={dlgSx}>
        <DialogTitle sx={dlgTitleSx}>{editingPlayer ? 'Modifier le joueur' : 'Nouveau joueur'}</DialogTitle>
        <DialogContent>
          <Grid container spacing={2} sx={{ mt: 0.5 }}>
            <Grid item xs={12} sm={6}><TextField fullWidth required label="Nom" value={playerForm.name} onChange={e => setPlayerForm(f => ({ ...f, name: e.target.value }))} /></Grid>
            <Grid item xs={12} sm={6}>
              <FormControl fullWidth>
                <InputLabel>Position</InputLabel>
                <Select value={playerForm.position} onChange={e => setPlayerForm(f => ({ ...f, position: e.target.value }))}>
                  <MenuItem value="gardien">Gardien</MenuItem>
                  <MenuItem value="defenseur">Défenseur</MenuItem>
                  <MenuItem value="milieu">Milieu</MenuItem>
                  <MenuItem value="attaquant">Attaquant</MenuItem>
                </Select>
              </FormControl>
            </Grid>
            <Grid item xs={12} sm={6}><TextField fullWidth type="number" label="N° maillot" value={playerForm.jerseyNumber} onChange={e => setPlayerForm(f => ({ ...f, jerseyNumber: e.target.value }))} inputProps={{ min: 1, max: 99 }} /></Grid>
            <Grid item xs={12} sm={6}>
              <FormControl fullWidth>
                <InputLabel>Équipe</InputLabel>
                <Select value={playerForm.teamId} onChange={e => setPlayerForm(f => ({ ...f, teamId: e.target.value }))}>
                  <MenuItem value="">Aucune équipe</MenuItem>
                  {teams.map(t => <MenuItem key={t.id} value={t.id}>{t.name}</MenuItem>)}
                </Select>
              </FormControl>
            </Grid>
            <Grid item xs={12} sm={6}><TextField fullWidth type="email" label="Email (connexion mobile)" value={playerForm.email} onChange={e => setPlayerForm(f => ({ ...f, email: e.target.value }))} /></Grid>
            <Grid item xs={12} sm={6}><TextField fullWidth type="password" label={editingPlayer ? 'Nouveau mot de passe (optionnel)' : 'Mot de passe'} value={playerForm.password} onChange={e => setPlayerForm(f => ({ ...f, password: e.target.value }))} /></Grid>
            <Grid item xs={12} sm={6}><TextField fullWidth label="Téléphone" value={playerForm.phone} onChange={e => setPlayerForm(f => ({ ...f, phone: e.target.value }))} /></Grid>
            <Grid item xs={12} sm={6}><TextField fullWidth type="date" label="Date de naissance" InputLabelProps={{ shrink: true }} value={playerForm.dateOfBirth} onChange={e => setPlayerForm(f => ({ ...f, dateOfBirth: e.target.value }))} /></Grid>
            <Grid item xs={12} sm={6}><TextField fullWidth type="number" label="Taille (cm)" value={playerForm.height} onChange={e => setPlayerForm(f => ({ ...f, height: e.target.value }))} inputProps={{ min: 100, max: 250 }} /></Grid>
            <Grid item xs={12} sm={6}><TextField fullWidth type="number" label="Poids (kg)" value={playerForm.weight} onChange={e => setPlayerForm(f => ({ ...f, weight: e.target.value }))} inputProps={{ min: 30, max: 150 }} /></Grid>
            <Grid item xs={12} sm={6}><TextField fullWidth label="Nationalité" value={playerForm.nationality} onChange={e => setPlayerForm(f => ({ ...f, nationality: e.target.value }))} /></Grid>
            <Grid item xs={12} sm={6}>
              <FormControl fullWidth>
                <InputLabel>Pied préféré</InputLabel>
                <Select value={playerForm.preferredFoot} onChange={e => setPlayerForm(f => ({ ...f, preferredFoot: e.target.value }))}>
                  <MenuItem value="">Non renseigné</MenuItem>
                  <MenuItem value="gauche">Gauche</MenuItem>
                  <MenuItem value="droit">Droit</MenuItem>
                  <MenuItem value="ambidextre">Ambidextre</MenuItem>
                </Select>
              </FormControl>
            </Grid>
            <Grid item xs={12} sm={6}><TextField fullWidth type="date" label="Date d'arrivée" InputLabelProps={{ shrink: true }} value={playerForm.joinDate} onChange={e => setPlayerForm(f => ({ ...f, joinDate: e.target.value }))} /></Grid>
            <Grid item xs={12} sm={6}>
              <FormControl fullWidth>
                <InputLabel>Capitaine</InputLabel>
                <Select value={playerForm.isCaptain} onChange={e => setPlayerForm(f => ({ ...f, isCaptain: e.target.value }))}>
                  <MenuItem value={false}>Non</MenuItem>
                  <MenuItem value={true}>Oui</MenuItem>
                </Select>
              </FormControl>
            </Grid>
            <Grid item xs={12} sm={6}>
              <FormControl fullWidth>
                <InputLabel>Statut</InputLabel>
                <Select value={playerForm.isActive} onChange={e => setPlayerForm(f => ({ ...f, isActive: e.target.value }))}>
                  <MenuItem value={true}>Actif</MenuItem>
                  <MenuItem value={false}>Inactif</MenuItem>
                </Select>
              </FormControl>
            </Grid>
          </Grid>
        </DialogContent>
        <DialogActions>
          <Button variant="outlined" color="inherit" onClick={() => closeDlg(setPlayerDialog, setEditingPlayer)}>Annuler</Button>
          <Button variant="contained" onClick={editingPlayer ? handleUpdatePlayer : handleCreatePlayer}>
            {editingPlayer ? 'Enregistrer' : 'Créer'}
          </Button>
        </DialogActions>
      </Dialog>

      {/* ── Coach dialog ─────────────────────────────────────────────────────── */}
      <Dialog open={coachDialog} onClose={() => closeDlg(setCoachDialog, setEditingCoach)} maxWidth="sm" fullWidth sx={dlgSx}>
        <DialogTitle sx={dlgTitleSx}>{editingCoach ? 'Modifier le coach' : 'Nouveau coach'}</DialogTitle>
        <DialogContent>
          <Grid container spacing={2} sx={{ mt: 0.5 }}>
            <Grid item xs={12}><TextField fullWidth required label="Nom" value={coachForm.name} onChange={e => setCoachForm(f => ({ ...f, name: e.target.value }))} /></Grid>
            <Grid item xs={12}><TextField fullWidth required type="email" label="Email" value={coachForm.email} onChange={e => setCoachForm(f => ({ ...f, email: e.target.value }))} /></Grid>
            <Grid item xs={12}><TextField fullWidth required={!editingCoach} type="password" label={editingCoach ? 'Nouveau mot de passe (optionnel)' : 'Mot de passe'} value={coachForm.password} onChange={e => setCoachForm(f => ({ ...f, password: e.target.value }))} /></Grid>
            <Grid item xs={12}><TextField fullWidth label="Téléphone" value={coachForm.phone} onChange={e => setCoachForm(f => ({ ...f, phone: e.target.value }))} /></Grid>
            <Grid item xs={12}>
              <FormControl fullWidth>
                <InputLabel>Équipe</InputLabel>
                <Select value={coachForm.teamId} onChange={e => setCoachForm(f => ({ ...f, teamId: e.target.value }))}>
                  <MenuItem value="">Aucune équipe</MenuItem>
                  {teams.filter(t => !coaches.some(c => c.teamId === t.id && c.id !== editingCoach?.id)).map(t => <MenuItem key={t.id} value={t.id}>{t.name}</MenuItem>)}
                </Select>
              </FormControl>
            </Grid>
          </Grid>
        </DialogContent>
        <DialogActions>
          <Button variant="outlined" color="inherit" onClick={() => closeDlg(setCoachDialog, setEditingCoach)}>Annuler</Button>
          <Button variant="contained" onClick={editingCoach ? handleUpdateCoach : handleCreateCoach}>
            {editingCoach ? 'Enregistrer' : 'Créer'}
          </Button>
        </DialogActions>
      </Dialog>

      {/* ── Stats dialog ─────────────────────────────────────────────────────── */}
      <Dialog open={statsDialog} onClose={() => closeDlg(setStatsDialog, setEditingPlayerStats)} maxWidth="md" fullWidth sx={dlgSx}>
        <DialogTitle sx={dlgTitleSx}>
          <Box sx={{ display: 'flex', alignItems: 'center', gap: 1.5 }}>
            <AssessmentIcon sx={{ color: '#3b82f6' }} />
            <Box>
              <Typography fontWeight={700} fontSize="1rem">Statistiques — {editingPlayerStats?.name}</Typography>
              {editingPlayerStats?.position && (
                <PositionChip position={editingPlayerStats.position} />
              )}
            </Box>
          </Box>
        </DialogTitle>
        <DialogContent sx={{ pt: 1 }}>
          {statsFieldsByPosition(editingPlayerStats?.position).map((section) => (
            <Box key={section.label} sx={{ mb: 3 }}>
              <Typography
                variant="subtitle2"
                sx={{ fontWeight: 700, color: section.color, mb: 1.5, pb: 0.5,
                      borderBottom: `2px solid ${section.color}`, display: 'inline-block' }}
              >
                {section.label}
              </Typography>
              <Grid container spacing={2}>
                {section.fields.map(([label, key]) => (
                  <Grid item xs={12} sm={6} md={4} key={key}>
                    {numField(label, key, statsForm, setStatsForm)}
                  </Grid>
                ))}
              </Grid>
            </Box>
          ))}
        </DialogContent>
        <DialogActions>
          <Button variant="outlined" color="inherit" onClick={() => closeDlg(setStatsDialog, setEditingPlayerStats)}>Annuler</Button>
          <Button variant="contained" onClick={handleUpdatePlayerStats}>Enregistrer</Button>
        </DialogActions>
      </Dialog>

      {/* ── Match Form Dialog (schedule / edit) ──────────────────────────────── */}
      <Dialog open={matchFormDialog} onClose={() => { setMatchFormDialog(false); setEditingMatch(null); }} maxWidth="sm" fullWidth sx={dlgSx}>
        <DialogTitle sx={dlgTitleSx}>{editingMatch ? 'Modifier le match' : 'Planifier un match'}</DialogTitle>
        <DialogContent>
          <Grid container spacing={2} sx={{ mt: 0.5 }}>
            <Grid item xs={12}>
              <FormControl fullWidth>
                <InputLabel>Tournoi</InputLabel>
                <Select value={matchForm.tournamentId} onChange={e => setMatchForm(f => ({ ...f, tournamentId: e.target.value }))}>
                  <MenuItem value="">Sans tournoi</MenuItem>
                  {tournaments.map(t => <MenuItem key={t.id} value={t.id}>{t.name}</MenuItem>)}
                </Select>
              </FormControl>
            </Grid>
            <Grid item xs={6}>
              <FormControl fullWidth required>
                <InputLabel>Équipe domicile</InputLabel>
                <Select value={matchForm.homeTeamId} onChange={e => setMatchForm(f => ({ ...f, homeTeamId: e.target.value }))}>
                  <MenuItem value="">Sélectionner…</MenuItem>
                  {(matchForm.tournamentId ? teams.filter(t => t.tournamentId === parseInt(matchForm.tournamentId)) : teams).map(t => (
                    <MenuItem key={t.id} value={t.id} disabled={t.id === parseInt(matchForm.awayTeamId)}>{t.name}</MenuItem>
                  ))}
                </Select>
              </FormControl>
            </Grid>
            <Grid item xs={6}>
              <FormControl fullWidth required>
                <InputLabel>Équipe visiteur</InputLabel>
                <Select value={matchForm.awayTeamId} onChange={e => setMatchForm(f => ({ ...f, awayTeamId: e.target.value }))}>
                  <MenuItem value="">Sélectionner…</MenuItem>
                  {(matchForm.tournamentId ? teams.filter(t => t.tournamentId === parseInt(matchForm.tournamentId)) : teams).map(t => (
                    <MenuItem key={t.id} value={t.id} disabled={t.id === parseInt(matchForm.homeTeamId)}>{t.name}</MenuItem>
                  ))}
                </Select>
              </FormControl>
            </Grid>
            <Grid item xs={7}>
              <TextField fullWidth required type="date" label="Date" InputLabelProps={{ shrink: true }} value={matchForm.date} onChange={e => setMatchForm(f => ({ ...f, date: e.target.value }))} />
            </Grid>
            <Grid item xs={5}>
              <TextField fullWidth type="time" label="Heure" InputLabelProps={{ shrink: true }} value={matchForm.time} onChange={e => setMatchForm(f => ({ ...f, time: e.target.value }))} />
            </Grid>
            <Grid item xs={8}>
              <TextField fullWidth label="Lieu" placeholder="Stade, terrain…" value={matchForm.location} onChange={e => setMatchForm(f => ({ ...f, location: e.target.value }))} />
            </Grid>
            <Grid item xs={4}>
              <TextField fullWidth type="number" label="Tour n°" value={matchForm.roundNumber} onChange={e => setMatchForm(f => ({ ...f, roundNumber: e.target.value }))} inputProps={{ min: 1 }} />
            </Grid>
            <Grid item xs={12}>
              <TextField fullWidth label="Arbitre" value={matchForm.referee} onChange={e => setMatchForm(f => ({ ...f, referee: e.target.value }))} />
            </Grid>
            <Grid item xs={12}>
              <TextField fullWidth multiline rows={2} label="Notes" value={matchForm.notes} onChange={e => setMatchForm(f => ({ ...f, notes: e.target.value }))} />
            </Grid>
          </Grid>
        </DialogContent>
        <DialogActions>
          <Button variant="outlined" color="inherit" onClick={() => { setMatchFormDialog(false); setEditingMatch(null); }}>Annuler</Button>
          <Button variant="contained" onClick={editingMatch ? handleUpdateMatch : handleCreateMatch}>
            {editingMatch ? 'Enregistrer' : 'Planifier'}
          </Button>
        </DialogActions>
      </Dialog>

      {/* ── Results Dialog ───────────────────────────────────────────────────── */}
      <Dialog open={resultsDialog} onClose={() => { setResultsDialog(false); setResultsTarget(null); }} maxWidth="sm" fullWidth sx={dlgSx}>
        <DialogTitle sx={dlgTitleSx}>
          <Box>
            <Typography sx={{ fontWeight: 700, fontSize: '1rem' }}>Résultat du match</Typography>
            {resultsTarget && (
              <Typography sx={{ fontSize: '0.8rem', color: 'text.secondary', mt: 0.25 }}>
                {resultsTarget.homeTeam?.name} vs {resultsTarget.awayTeam?.name}
              </Typography>
            )}
          </Box>
        </DialogTitle>
        <DialogContent>
          <Grid container spacing={2} sx={{ mt: 0.5 }}>
            {/* Score row */}
            <Grid item xs={12}>
              <Box sx={{ display: 'flex', alignItems: 'center', gap: 2, bgcolor: 'background.default', borderRadius: 2, p: 2 }}>
                <Box sx={{ flex: 1, textAlign: 'center' }}>
                  <Typography sx={{ fontSize: '0.75rem', color: 'text.secondary', mb: 1, fontWeight: 600 }}>{resultsTarget?.homeTeam?.name}</Typography>
                  <TextField type="number" value={resultsForm.homeTeamScore} onChange={e => setResultsForm(f => ({ ...f, homeTeamScore: e.target.value }))} inputProps={{ min: 0, style: { textAlign: 'center', fontSize: '2rem', fontWeight: 800, padding: '8px' } }} sx={{ width: 90 }} />
                </Box>
                <Typography sx={{ fontSize: '1.5rem', color: '#94a3b8', fontWeight: 700, flexShrink: 0 }}>–</Typography>
                <Box sx={{ flex: 1, textAlign: 'center' }}>
                  <Typography sx={{ fontSize: '0.75rem', color: 'text.secondary', mb: 1, fontWeight: 600 }}>{resultsTarget?.awayTeam?.name}</Typography>
                  <TextField type="number" value={resultsForm.awayTeamScore} onChange={e => setResultsForm(f => ({ ...f, awayTeamScore: e.target.value }))} inputProps={{ min: 0, style: { textAlign: 'center', fontSize: '2rem', fontWeight: 800, padding: '8px' } }} sx={{ width: 90 }} />
                </Box>
              </Box>
            </Grid>
            {/* Half-time */}
            <Grid item xs={12}>
              <Typography sx={{ fontSize: '0.75rem', color: 'text.secondary', fontWeight: 600, mb: 1 }}>Score à la mi-temps</Typography>
              <Box sx={{ display: 'flex', gap: 2, alignItems: 'center' }}>
                <TextField size="small" type="number" label="Dom." value={resultsForm.halfTimeHomeScore} onChange={e => setResultsForm(f => ({ ...f, halfTimeHomeScore: e.target.value }))} inputProps={{ min: 0 }} sx={{ width: 80 }} />
                <Typography sx={{ color: '#94a3b8' }}>–</Typography>
                <TextField size="small" type="number" label="Vis." value={resultsForm.halfTimeAwayScore} onChange={e => setResultsForm(f => ({ ...f, halfTimeAwayScore: e.target.value }))} inputProps={{ min: 0 }} sx={{ width: 80 }} />
              </Box>
            </Grid>
            <Grid item xs={6}>
              <FormControl fullWidth size="small">
                <InputLabel>Statut</InputLabel>
                <Select value={resultsForm.status} onChange={e => setResultsForm(f => ({ ...f, status: e.target.value }))}>
                  <MenuItem value="completed">Terminé</MenuItem>
                  <MenuItem value="in_progress">En cours</MenuItem>
                  <MenuItem value="postponed">Reporté</MenuItem>
                  <MenuItem value="cancelled">Annulé</MenuItem>
                </Select>
              </FormControl>
            </Grid>
            <Grid item xs={6}>
              <TextField fullWidth size="small" type="number" label="Spectateurs" value={resultsForm.attendance} onChange={e => setResultsForm(f => ({ ...f, attendance: e.target.value }))} inputProps={{ min: 0 }} />
            </Grid>
            <Grid item xs={12}>
              <TextField fullWidth size="small" label="Arbitre" value={resultsForm.referee} onChange={e => setResultsForm(f => ({ ...f, referee: e.target.value }))} />
            </Grid>
            <Grid item xs={12}>
              <TextField fullWidth size="small" multiline rows={2} label="Notes" value={resultsForm.notes} onChange={e => setResultsForm(f => ({ ...f, notes: e.target.value }))} />
            </Grid>
          </Grid>
        </DialogContent>
        <DialogActions>
          <Button variant="outlined" color="inherit" onClick={() => { setResultsDialog(false); setResultsTarget(null); }}>Annuler</Button>
          <Button variant="contained" color="success" onClick={handleSaveResults}>Enregistrer</Button>
        </DialogActions>
      </Dialog>

      {/* ── Events Dialog ────────────────────────────────────────────────────── */}
      <Dialog open={eventsDialog} onClose={() => { setEventsDialog(false); setEventsTarget(null); }} maxWidth="md" fullWidth sx={dlgSx}>
        <DialogTitle sx={{ ...dlgTitleSx, borderBottom: '1px solid', borderColor: 'divider', pb: 2 }}>
          <Box sx={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
            <Box>
              <Typography sx={{ fontWeight: 700 }}>Événements du match</Typography>
              {eventsTarget && (
                <Box sx={{ display: 'flex', alignItems: 'center', gap: 1, mt: 0.5 }}>
                  <Typography sx={{ fontSize: '0.85rem', color: 'text.secondary' }}>{eventsTarget.homeTeam?.name}</Typography>
                  <Box sx={{ display: 'flex', alignItems: 'center', gap: 0.5, px: 1.5, py: 0.25, bgcolor: 'background.default', borderRadius: 1, border: '1px solid', borderColor: 'divider' }}>
                    <Typography sx={{ fontWeight: 800, fontSize: '1rem' }}>{eventsTarget.homeTeamScore ?? 0}</Typography>
                    <Typography sx={{ color: '#94a3b8', fontWeight: 600 }}>–</Typography>
                    <Typography sx={{ fontWeight: 800, fontSize: '1rem' }}>{eventsTarget.awayTeamScore ?? 0}</Typography>
                  </Box>
                  <Typography sx={{ fontSize: '0.85rem', color: 'text.secondary' }}>{eventsTarget.awayTeam?.name}</Typography>
                </Box>
              )}
            </Box>
          </Box>
        </DialogTitle>
        <DialogContent sx={{ p: 0 }}>
          <Grid container sx={{ height: '100%', minHeight: 400 }}>
            {/* Left: timeline */}
            <Grid item xs={12} md={6} sx={{ borderRight: { md: '1px solid' }, borderColor: { md: 'divider' }, p: 2.5, maxHeight: 500, overflowY: 'auto' }}>
              <Typography sx={{ fontSize: '0.75rem', fontWeight: 700, color: 'text.secondary', textTransform: 'uppercase', letterSpacing: '0.06em', mb: 1.5 }}>
                Chronologie
              </Typography>
              {matchEvents.length === 0 ? (
                <Box sx={{ py: 4, textAlign: 'center' }}>
                  <Typography fontSize="0.875rem" color="text.secondary">Aucun événement enregistré</Typography>
                </Box>
              ) : (
                <Box sx={{ display: 'flex', flexDirection: 'column', gap: 0.75 }}>
                  {[...matchEvents].sort((a, b) => a.minute - b.minute || (a.extraMinute || 0) - (b.extraMinute || 0)).map(ev => {
                    const cfg = EVENT_CFG[ev.type] || { label: ev.type, color: '#64748b' };
                    const team = ev.isHomeTeam ? eventsTarget?.homeTeam?.name : eventsTarget?.awayTeam?.name;
                    return (
                      <Box key={ev.id} sx={{ display: 'flex', alignItems: 'center', gap: 1.5, p: 1.25, borderRadius: 1.5, bgcolor: 'background.default', border: '1px solid', borderColor: 'divider', '&:hover': { bgcolor: 'action.hover' } }}>
                        <Box sx={{ minWidth: 36, textAlign: 'center' }}>
                          <Typography sx={{ fontWeight: 800, fontSize: '0.85rem', color: 'text.primary' }}>
                            {ev.minute}{ev.extraMinute ? `+${ev.extraMinute}` : ''}'
                          </Typography>
                        </Box>
                        <Box sx={{ flex: 1, minWidth: 0 }}>
                          <Typography sx={{ fontSize: '0.8rem', fontWeight: 600, color: cfg.color }}>{cfg.label}</Typography>
                          <Typography noWrap sx={{ fontSize: '0.75rem', color: 'text.secondary' }}>
                            {ev.relatedPlayerName || '—'} · {team}
                          </Typography>
                          {ev.type === 'substitution' && ev.substitutionPlayerOutName && (
                            <Typography sx={{ fontSize: '0.72rem', color: '#94a3b8' }}>↕ {ev.substitutionPlayerOutName} → {ev.substitutionPlayerInName}</Typography>
                          )}
                          {ev.description && <Typography noWrap sx={{ fontSize: '0.72rem', color: '#94a3b8' }}>{ev.description}</Typography>}
                        </Box>
                        <IconButton size="small" onClick={() => openConfirm('Supprimer l\'événement', `Supprimer cet événement (${ev.minute}') ?`, () => handleDeleteEvent(ev.id))} sx={{ color: '#cbd5e1', '&:hover': { color: '#ef4444' }, flexShrink: 0 }}>
                          <DeleteIcon sx={{ fontSize: 14 }} />
                        </IconButton>
                      </Box>
                    );
                  })}
                </Box>
              )}
            </Grid>

            {/* Right: add event form */}
            <Grid item xs={12} md={6} sx={{ p: 2.5 }}>
              <Typography sx={{ fontSize: '0.75rem', fontWeight: 700, color: 'text.secondary', textTransform: 'uppercase', letterSpacing: '0.06em', mb: 1.5 }}>
                Ajouter un événement
              </Typography>
              <Grid container spacing={1.5}>
                <Grid item xs={12}>
                  <FormControl fullWidth size="small">
                    <InputLabel>Type</InputLabel>
                    <Select value={eventForm.type} onChange={e => setEventForm(f => ({ ...f, type: e.target.value }))}>
                      {Object.entries(EVENT_CFG).map(([k, v]) => <MenuItem key={k} value={k}>{v.label}</MenuItem>)}
                    </Select>
                  </FormControl>
                </Grid>
                <Grid item xs={6}>
                  <TextField fullWidth size="small" type="number" label="Minute" value={eventForm.minute} onChange={e => setEventForm(f => ({ ...f, minute: e.target.value }))} inputProps={{ min: 1, max: 120 }} />
                </Grid>
                <Grid item xs={6}>
                  <TextField fullWidth size="small" type="number" label="Temps additionnel" value={eventForm.extraMinute} onChange={e => setEventForm(f => ({ ...f, extraMinute: e.target.value }))} inputProps={{ min: 0, max: 10 }} placeholder="0" />
                </Grid>
                <Grid item xs={12}>
                  <FormControl fullWidth size="small">
                    <InputLabel>Équipe</InputLabel>
                    <Select value={eventForm.isHomeTeam} onChange={e => setEventForm(f => ({ ...f, isHomeTeam: e.target.value }))}>
                      <MenuItem value={true}>{eventsTarget?.homeTeam?.name || 'Domicile'}</MenuItem>
                      <MenuItem value={false}>{eventsTarget?.awayTeam?.name || 'Visiteur'}</MenuItem>
                    </Select>
                  </FormControl>
                </Grid>
                <Grid item xs={12}>
                  <TextField fullWidth size="small" label="Joueur" placeholder="Nom du joueur" value={eventForm.relatedPlayerName} onChange={e => setEventForm(f => ({ ...f, relatedPlayerName: e.target.value }))} />
                </Grid>
                {eventForm.type === 'substitution' && (
                  <>
                    <Grid item xs={12}>
                      <TextField fullWidth size="small" label="Joueur sortant" value={eventForm.substitutionPlayerOutName || ''} onChange={e => setEventForm(f => ({ ...f, substitutionPlayerOutName: e.target.value }))} />
                    </Grid>
                    <Grid item xs={12}>
                      <TextField fullWidth size="small" label="Joueur entrant" value={eventForm.substitutionPlayerInName || ''} onChange={e => setEventForm(f => ({ ...f, substitutionPlayerInName: e.target.value }))} />
                    </Grid>
                  </>
                )}
                <Grid item xs={12}>
                  <TextField fullWidth size="small" label="Note (optionnel)" value={eventForm.description} onChange={e => setEventForm(f => ({ ...f, description: e.target.value }))} />
                </Grid>
                <Grid item xs={12}>
                  <Button fullWidth variant="contained" onClick={handleAddEvent} sx={{ mt: 0.5 }}>
                    Ajouter
                  </Button>
                </Grid>
              </Grid>
            </Grid>
          </Grid>
        </DialogContent>
        <DialogActions sx={{ px: 3, pb: 2.5, borderTop: '1px solid', borderColor: 'divider' }}>
          <Button variant="outlined" color="inherit" onClick={() => { setEventsDialog(false); setEventsTarget(null); }}>Fermer</Button>
        </DialogActions>
      </Dialog>

      {/* ── Review Application Dialog ──────────────────────────────────────────── */}
      <Dialog open={reviewDialog.open} onClose={() => setReviewDialog({ open: false, app: null, status: '', notes: '' })} maxWidth="sm" fullWidth sx={dlgSx}>
        <DialogTitle sx={dlgTitleSx}>
          <Box sx={{ display: 'flex', alignItems: 'center', gap: 1 }}>
            <Box sx={{ width: 32, height: 32, borderRadius: '50%', display: 'flex', alignItems: 'center', justifyContent: 'center',
              bgcolor: reviewDialog.status === 'approved' ? '#f0fdf4' : '#fef2f2' }}>
              {reviewDialog.status === 'approved'
                ? <ApproveIcon sx={{ fontSize: 17, color: '#16a34a' }} />
                : <RejectIcon  sx={{ fontSize: 17, color: '#dc2626' }} />}
            </Box>
            {reviewDialog.status === 'approved' ? 'Approuver la candidature' : 'Rejeter la candidature'}
          </Box>
        </DialogTitle>
        <DialogContent>
          {reviewDialog.app && (
            <Box sx={{ mb: 2, p: 2, bgcolor: 'background.default', borderRadius: 1.5, border: '1px solid', borderColor: 'divider' }}>
              <Typography fontSize="0.82rem" fontWeight={700} mb={0.5}>Résumé</Typography>
              <Typography fontSize="0.82rem" color="text.secondary">
                Équipe : <strong>{reviewDialog.app.team?.name}</strong>
              </Typography>
              <Typography fontSize="0.82rem" color="text.secondary">
                Tournoi : <strong>{reviewDialog.app.tournament?.name}</strong>
              </Typography>
              <Typography fontSize="0.82rem" color="text.secondary">
                Coach : {reviewDialog.app.team?.coach?.name || '—'}
              </Typography>
            </Box>
          )}
          <TextField
            fullWidth multiline rows={3}
            label="Notes (optionnel)"
            placeholder={reviewDialog.status === 'approved'
              ? 'Ex : Bienvenue dans le tournoi !'
              : 'Ex : Le nombre maximum d\'équipes est atteint.'}
            value={reviewDialog.notes}
            onChange={e => setReviewDialog(d => ({ ...d, notes: e.target.value }))}
            sx={{ mt: 1 }}
          />
          {reviewDialog.status === 'approved' && (
            <Alert severity="info" sx={{ mt: 1.5, fontSize: '0.8rem' }}>
              Approuver cette candidature assignera automatiquement l'équipe au tournoi.
            </Alert>
          )}
        </DialogContent>
        <DialogActions>
          <Button variant="outlined" color="inherit" onClick={() => setReviewDialog({ open: false, app: null, status: '', notes: '' })}>
            Annuler
          </Button>
          <Button variant="contained"
            color={reviewDialog.status === 'approved' ? 'success' : 'error'}
           
            onClick={handleReviewApplication}>
            {reviewDialog.status === 'approved' ? 'Approuver' : 'Rejeter'}
          </Button>
        </DialogActions>
      </Dialog>
    </Box>
  );
};

export default AdminDashboard;



