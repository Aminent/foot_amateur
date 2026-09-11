import { useState, useEffect, useCallback } from 'react';
import {
  Box, Button, Dialog, DialogTitle, DialogContent, DialogActions,
  Table, TableBody, TableCell, TableHead, TableRow, TextField,
  Typography, Chip, Checkbox, Select, MenuItem, FormControl,
  InputLabel, IconButton, Menu, Alert, CircularProgress, Divider,
  Stack, Switch, FormControlLabel, InputAdornment, Avatar, Tooltip,
  Card, CardContent
} from '@mui/material';
import {
  Add, Close, EmojiEvents, MoreVert, Visibility, Edit, Delete,
  Person, SportsSoccer, FitnessCenter, Shield,
  Email, Lock, Phone, CalendarToday, Flag, Height
} from '@mui/icons-material';

const API = process.env.REACT_APP_API_URL || 'http://localhost:5000/api';

const tok = () => localStorage.getItem('token');
const authH = () => ({ Authorization: `Bearer ${tok()}`, 'Content-Type': 'application/json' });

const POSITIONS = [
  { value: 'gardien',   label: 'Gardien',    color: '#F59E0B' },
  { value: 'defenseur', label: 'Défenseur',  color: '#3B82F6' },
  { value: 'milieu',    label: 'Milieu',     color: '#10B981' },
  { value: 'attaquant', label: 'Attaquant',  color: '#EF4444' },
];
const FEET = [
  { value: 'droit',      label: 'Droit' },
  { value: 'gauche',     label: 'Gauche' },
  { value: 'ambidextre', label: 'Ambidextre' },
];

const posColor  = (pos) => POSITIONS.find(p => p.value === pos)?.color ?? '#64748B';
const posLabel  = (pos) => POSITIONS.find(p => p.value === pos)?.label ?? pos ?? '—';
const footLabel = (f)   => FEET.find(x => x.value === f)?.label ?? '—';

const initials = (name = '?') =>
  (name).split(' ').map(w => w[0]).join('').toUpperCase().slice(0, 2);

const PlayerAvatar = ({ name, size = 36 }) => {
  const colors = ['#667EEA','#10B981','#F59E0B','#EF4444','#8B5CF6','#06B6D4','#EC4899'];
  const bg = colors[(name?.charCodeAt(0) ?? 0) % colors.length];
  return (
    <Avatar sx={{ width: size, height: size, bgcolor: bg,
                  fontSize: size * 0.38, fontWeight: 700 }}>
      {initials(name)}
    </Avatar>
  );
};

const SectionHead = ({ icon: Icon, label }) => (
  <Box sx={{ display: 'flex', alignItems: 'center', gap: 1, mb: 1.5 }}>
    <Icon sx={{ fontSize: 17, color: 'primary.main' }} />
    <Typography variant="subtitle2" fontWeight={700} color="primary">{label}</Typography>
  </Box>
);

/* ── empty form ─────────────────────────────────────────────────────────── */
const EMPTY = {
  name: '', dateOfBirth: '', nationality: '', phone: '',
  position: 'milieu', jerseyNumber: '', preferredFoot: '',
  isCaptain: false, isActive: true, joinDate: '',
  height: '', weight: '',
  email: '', password: '',
  teamId: '',
};

/* ── shared form layout ─────────────────────────────────────────────────── */
const PlayerForm = ({ v, set, isCreate }) => (
  <Stack spacing={2.5} sx={{ mt: 1 }}>

    {/* Identité */}
    <Box>
      <SectionHead icon={Person} label="Identité" />
      <Stack spacing={2}>
        <TextField required fullWidth label="Nom complet" value={v.name}
          onChange={e => set('name', e.target.value)}
          InputProps={{ startAdornment: <InputAdornment position="start"><Person sx={{ fontSize: 18 }} /></InputAdornment> }} />
        <Stack direction="row" spacing={2}>
          <TextField fullWidth label="Date de naissance" type="date" value={v.dateOfBirth}
            onChange={e => set('dateOfBirth', e.target.value)}
            InputLabelProps={{ shrink: true }}
            InputProps={{ startAdornment: <InputAdornment position="start"><CalendarToday sx={{ fontSize: 18 }} /></InputAdornment> }} />
          <TextField fullWidth label="Nationalité" value={v.nationality}
            onChange={e => set('nationality', e.target.value)}
            InputProps={{ startAdornment: <InputAdornment position="start"><Flag sx={{ fontSize: 18 }} /></InputAdornment> }} />
        </Stack>
      </Stack>
    </Box>

    <Divider />

    {/* Infos sportives */}
    <Box>
      <SectionHead icon={SportsSoccer} label="Informations sportives" />
      <Stack spacing={2}>
        <Stack direction="row" spacing={2}>
          <FormControl fullWidth>
            <InputLabel>Poste *</InputLabel>
            <Select label="Poste *" value={v.position} onChange={e => set('position', e.target.value)}>
              {POSITIONS.map(p => (
                <MenuItem key={p.value} value={p.value}>
                  <Box sx={{ display: 'flex', alignItems: 'center', gap: 1 }}>
                    <Box sx={{ width: 10, height: 10, borderRadius: '50%', bgcolor: p.color }} />
                    {p.label}
                  </Box>
                </MenuItem>
              ))}
            </Select>
          </FormControl>
          <TextField fullWidth label="N° maillot" type="number"
            inputProps={{ min: 1, max: 99 }}
            value={v.jerseyNumber} onChange={e => set('jerseyNumber', e.target.value)} />
        </Stack>
        <Stack direction="row" spacing={2}>
          <FormControl fullWidth>
            <InputLabel>Pied préféré</InputLabel>
            <Select label="Pied préféré" value={v.preferredFoot} onChange={e => set('preferredFoot', e.target.value)}>
              <MenuItem value="">Non précisé</MenuItem>
              {FEET.map(f => <MenuItem key={f.value} value={f.value}>{f.label}</MenuItem>)}
            </Select>
          </FormControl>
          <TextField fullWidth label="Date d'arrivée" type="date" value={v.joinDate}
            onChange={e => set('joinDate', e.target.value)}
            InputLabelProps={{ shrink: true }} />
        </Stack>
        <Stack direction="row" spacing={3} alignItems="center">
          <FormControlLabel
            control={<Checkbox checked={v.isCaptain} onChange={e => set('isCaptain', e.target.checked)} />}
            label="Capitaine ⭐" />
          {!isCreate && (
            <FormControlLabel
              control={<Switch checked={v.isActive} onChange={e => set('isActive', e.target.checked)} color="success" />}
              label={v.isActive ? 'Actif' : 'Inactif'} />
          )}
        </Stack>
      </Stack>
    </Box>

    <Divider />

    {/* Physique */}
    <Box>
      <SectionHead icon={FitnessCenter} label="Données physiques" />
      <Stack direction="row" spacing={2}>
        <TextField fullWidth label="Taille" type="number" value={v.height}
          onChange={e => set('height', e.target.value)}
          InputProps={{
            startAdornment: <InputAdornment position="start"><Height sx={{ fontSize: 18 }} /></InputAdornment>,
            endAdornment: <InputAdornment position="end">cm</InputAdornment>
          }} />
        <TextField fullWidth label="Poids" type="number" value={v.weight}
          onChange={e => set('weight', e.target.value)}
          InputProps={{ endAdornment: <InputAdornment position="end">kg</InputAdornment> }} />
      </Stack>
    </Box>

    <Divider />

    {/* Compte mobile */}
    <Box>
      <SectionHead icon={Shield} label="Compte application mobile" />
      <Typography variant="caption" color="text.secondary" sx={{ display: 'block', mb: 1.5 }}>
        Ces informations permettent au joueur de se connecter à l'application mobile.
        Elles sont également visibles par le coach.
      </Typography>
      <Stack spacing={2}>
        <TextField fullWidth label="Téléphone" value={v.phone}
          onChange={e => set('phone', e.target.value)}
          InputProps={{ startAdornment: <InputAdornment position="start"><Phone sx={{ fontSize: 18 }} /></InputAdornment> }}
          helperText="Visible par le coach dans l'onglet Équipe" />
        <TextField fullWidth label="Adresse email" type="email" required={isCreate}
          value={v.email} onChange={e => set('email', e.target.value)}
          InputProps={{ startAdornment: <InputAdornment position="start"><Email sx={{ fontSize: 18 }} /></InputAdornment> }}
          helperText="Email de connexion · visible par le coach" />
        <TextField fullWidth label={isCreate ? 'Mot de passe *' : 'Nouveau mot de passe'} type="password"
          value={v.password} onChange={e => set('password', e.target.value)}
          InputProps={{ startAdornment: <InputAdornment position="start"><Lock sx={{ fontSize: 18 }} /></InputAdornment> }}
          helperText={isCreate ? 'Minimum 6 caractères' : 'Laisser vide pour ne pas modifier'} />
      </Stack>
    </Box>

  </Stack>
);

/* ════════════════════════════════════════════════════════════════════════════ */
const PlayersManagement = () => {
  const [players, setPlayers] = useState([]);
  const [teams,   setTeams]   = useState([]);
  const [loading, setLoading] = useState(false);
  const [saving,  setSaving]  = useState(false);
  const [error,   setError]   = useState('');
  const [success, setSuccess] = useState('');

  /* menu */
  const [menuAnchor, setMenuAnchor] = useState(null);
  const [menuPlayer, setMenuPlayer] = useState(null);

  /* dialogs */
  const [activePlayer, setActivePlayer] = useState(null);
  const [editOpen,    setEditOpen]    = useState(false);
  const [createOpen,  setCreateOpen]  = useState(false);
  const [detailsOpen, setDetailsOpen] = useState(false);
  const [deleteOpen,  setDeleteOpen]  = useState(false);
  const [rewardsOpen, setRewardsOpen] = useState(false);

  /* forms */
  const [form,       setForm]       = useState(EMPTY);
  const [createForm, setCreateForm] = useState({ ...EMPTY });

  /* rewards */
  const REWARDS = [
    { id: 'perf1',  name: 'Bonus de Performance',    description: 'Excellent sur les 5 derniers matchs', value: 100, icon: '🎁' },
    { id: 'train1', name: 'Récompense Entraînement', description: 'Tous les entraînements du mois',      value: 50,  icon: '🏋️' },
  ];
  const [selRewards, setSelRewards] = useState([]);

  /* ── fetch ─────────────────────────────────────────────────────────────── */
  const fetchPlayers = useCallback(async () => {
    setLoading(true);
    try {
      const res  = await fetch(`${API}/players`, { headers: authH() });
      const data = await res.json();
      setPlayers(data.players || []);
    } catch { setError('Erreur lors du chargement des joueurs'); }
    finally  { setLoading(false); }
  }, []);

  const fetchTeams = useCallback(async () => {
    try {
      const res  = await fetch(`${API}/teams`, { headers: authH() });
      const data = await res.json();
      setTeams(data.teams || []);
    } catch {}
  }, []);

  useEffect(() => { fetchPlayers(); fetchTeams(); }, [fetchPlayers, fetchTeams]);

  /* ── context menu ───────────────────────────────────────────────────────── */
  const openMenu  = (e, p) => { e.stopPropagation(); setMenuAnchor(e.currentTarget); setMenuPlayer(p); };
  const closeMenu = ()     => setMenuAnchor(null);

  /* ── build form from player object ────────────────────────────────────── */
  const playerToForm = (p) => ({
    name:          p.name                                        ?? '',
    dateOfBirth:   p.dateOfBirth  ? String(p.dateOfBirth).slice(0, 10) : '',
    nationality:   p.nationality                                 ?? '',
    phone:         p.phone        ?? p.user?.phone               ?? '',
    position:      p.position                                    ?? 'milieu',
    jerseyNumber:  p.jerseyNumber != null ? String(p.jerseyNumber) : '',
    preferredFoot: p.preferredFoot                               ?? '',
    isCaptain:     p.isCaptain                                   ?? false,
    isActive:      p.isActive                                    ?? true,
    joinDate:      p.joinDate     ? String(p.joinDate).slice(0, 10)    : '',
    height:        p.height       != null ? String(p.height)           : '',
    weight:        p.weight       != null ? String(p.weight)           : '',
    email:         p.email        ?? p.user?.email               ?? '',
    password:      '',
    teamId:        p.teamId       != null ? String(p.teamId)           : '',
  });

  /* ── open dialogs ───────────────────────────────────────────────────────── */
  const openEdit    = (p) => { const pl = p ?? menuPlayer; if (!pl) return; setActivePlayer(pl); setForm(playerToForm(pl)); setEditOpen(true); closeMenu(); };
  const openDetails = (p) => { const pl = p ?? menuPlayer; if (!pl) return; setActivePlayer(pl); setDetailsOpen(true); closeMenu(); };
  const openDelete  = ()  => { setActivePlayer(menuPlayer); setDeleteOpen(true); closeMenu(); };
  const openRewards = ()  => { setActivePlayer(menuPlayer); setSelRewards([]); setRewardsOpen(true); closeMenu(); };

  /* ── build API payload ──────────────────────────────────────────────────── */
  const buildPayload = (f) => {
    const p = {
      name:          f.name.trim(),
      position:      f.position,
      jerseyNumber:  f.jerseyNumber  !== '' ? parseInt(f.jerseyNumber,  10) : null,
      teamId:        f.teamId        !== '' ? parseInt(f.teamId,        10) : null,
      isCaptain:     f.isCaptain,
      isActive:      f.isActive,
      dateOfBirth:   f.dateOfBirth   || null,
      nationality:   f.nationality   || null,
      preferredFoot: f.preferredFoot || null,
      joinDate:      f.joinDate      || null,
      height:        f.height        !== '' ? parseInt(f.height,        10) : null,
      weight:        f.weight        !== '' ? parseInt(f.weight,        10) : null,
      phone:         f.phone.trim()  || null,
      email:         f.email.trim()  || null,
    };
    if (f.password) p.password = f.password;
    return p;
  };

  /* ── save edit ──────────────────────────────────────────────────────────── */
  const handleSave = async () => {
    if (!form.name.trim()) { setError('Le nom est obligatoire'); return; }
    setSaving(true); setError('');
    try {
      const res  = await fetch(`${API}/players/${activePlayer.id}`, {
        method: 'PUT', headers: authH(), body: JSON.stringify(buildPayload(form)),
      });
      const data = await res.json();
      if (!res.ok) { setError(data.message || data.error || 'Erreur lors de la mise à jour'); return; }
      setSuccess('Joueur mis à jour — synchronisé avec l\'application mobile');
      setEditOpen(false);
      fetchPlayers();
    } catch { setError('Erreur réseau'); }
    finally  { setSaving(false); }
  };

  /* ── create ─────────────────────────────────────────────────────────────── */
  const handleCreate = async () => {
    if (!createForm.name.trim())        { setError('Le nom est obligatoire');                                return; }
    if (!createForm.email.trim())       { setError("L'email est obligatoire");                              return; }
    if (createForm.password.length < 6) { setError('Le mot de passe doit faire au moins 6 caractères');    return; }
    setSaving(true); setError('');
    try {
      const payload = { ...buildPayload(createForm), password: createForm.password };
      const res  = await fetch(`${API}/players`, {
        method: 'POST', headers: authH(), body: JSON.stringify(payload),
      });
      const data = await res.json();
      if (!res.ok) { setError(data.message || 'Erreur lors de la création'); return; }
      setSuccess('Joueur créé avec succès');
      setCreateOpen(false);
      setCreateForm({ ...EMPTY });
      fetchPlayers();
    } catch { setError('Erreur réseau'); }
    finally  { setSaving(false); }
  };

  /* ── delete ─────────────────────────────────────────────────────────────── */
  const handleDelete = async () => {
    try {
      const res = await fetch(`${API}/players/${activePlayer.id}`, { method: 'DELETE', headers: authH() });
      if (res.ok) { setSuccess('Joueur supprimé'); setDeleteOpen(false); fetchPlayers(); }
      else        { setError('Erreur lors de la suppression'); }
    } catch { setError('Erreur réseau'); }
  };

  /* ── rewards ────────────────────────────────────────────────────────────── */
  const toggleReward = (r) =>
    setSelRewards(prev => prev.some(x => x.id === r.id) ? prev.filter(x => x.id !== r.id) : [...prev, r]);

  const handleAward = async () => {
    try {
      for (const r of selRewards) {
        await fetch(`${API}/rewards/award-reward`, {
          method: 'POST', headers: authH(),
          body: JSON.stringify({ playerId: activePlayer.id, rewardData: r }),
        });
      }
      setSuccess('Récompenses attribuées'); setRewardsOpen(false);
    } catch { setError("Erreur lors de l'attribution"); }
  };

  /* ════════════════════════════════════ RENDER ═══════════════════════════ */
  return (
    <Box>

      {/* header */}
      <Box sx={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', mb: 2 }}>
        <Typography variant="h5" fontWeight={700}>Gestion des Joueurs</Typography>
        <Button variant="contained" startIcon={<Add />}
          onClick={() => { setCreateForm({ ...EMPTY }); setCreateOpen(true); }}>
          Nouveau joueur
        </Button>
      </Box>

      {error   && <Alert severity="error"   sx={{ mb: 2 }} onClose={() => setError('')}>{error}</Alert>}
      {success && <Alert severity="success" sx={{ mb: 2 }} onClose={() => setSuccess('')}>{success}</Alert>}
      {loading && <CircularProgress size={24} sx={{ mb: 2 }} />}

      {/* table */}
      <Table size="small">
        <TableHead>
          <TableRow sx={{ bgcolor: 'grey.50' }}>
            <TableCell><strong>Joueur</strong></TableCell>
            <TableCell><strong>Contact</strong></TableCell>
            <TableCell><strong>Poste</strong></TableCell>
            <TableCell><strong>Équipe</strong></TableCell>
            <TableCell><strong>N°</strong></TableCell>
            <TableCell><strong>Statut</strong></TableCell>
            <TableCell align="center"><strong>Actions</strong></TableCell>
          </TableRow>
        </TableHead>
        <TableBody>
          {players.map(p => (
            <TableRow key={p.id} hover>
              <TableCell>
                <Box sx={{ display: 'flex', alignItems: 'center', gap: 1.5 }}>
                  <PlayerAvatar name={p.name} />
                  <Box>
                    <Typography variant="body2" fontWeight={600}>{p.name}</Typography>
                    {p.nationality && <Typography variant="caption" color="text.secondary">{p.nationality}</Typography>}
                  </Box>
                </Box>
              </TableCell>
              <TableCell sx={{ fontSize: 12 }}>
                <Box>{p.email ?? p.user?.email ?? '—'}</Box>
                {(p.phone ?? p.user?.phone) && (
                  <Box sx={{ color: 'text.secondary' }}>{p.phone ?? p.user?.phone}</Box>
                )}
              </TableCell>
              <TableCell>
                {p.position
                  ? <Chip size="small" label={posLabel(p.position)}
                      sx={{ bgcolor: posColor(p.position) + '22', color: posColor(p.position), fontWeight: 600, border: `1px solid ${posColor(p.position)}44` }} />
                  : '—'}
              </TableCell>
              <TableCell>
                {p.team?.name
                  ? <Chip size="small" label={p.team.name} variant="outlined" color="primary" />
                  : <Chip size="small" label="Sans équipe" color="warning" variant="outlined" />}
              </TableCell>
              <TableCell>
                {p.jerseyNumber != null ? <Chip size="small" label={`#${p.jerseyNumber}`} sx={{ fontWeight: 700 }} /> : '—'}
              </TableCell>
              <TableCell>
                <Chip size="small" variant="outlined"
                  label={p.isActive !== false ? 'Actif' : 'Inactif'}
                  color={p.isActive !== false ? 'success' : 'default'} />
              </TableCell>
              <TableCell align="center">
                <Tooltip title="Actions">
                  <IconButton size="small" onClick={e => openMenu(e, p)}><MoreVert fontSize="small" /></IconButton>
                </Tooltip>
              </TableCell>
            </TableRow>
          ))}
          {!loading && players.length === 0 && (
            <TableRow>
              <TableCell colSpan={7} align="center" sx={{ py: 6, color: 'text.secondary' }}>
                Aucun joueur enregistré
              </TableCell>
            </TableRow>
          )}
        </TableBody>
      </Table>

      {/* shared context menu */}
      <Menu anchorEl={menuAnchor} open={Boolean(menuAnchor)} onClose={closeMenu}>
        <MenuItem onClick={() => openDetails(menuPlayer)}><Visibility sx={{ mr: 1 }} fontSize="small" />Voir la fiche</MenuItem>
        <MenuItem onClick={() => openEdit(menuPlayer)}><Edit sx={{ mr: 1 }} fontSize="small" />Modifier</MenuItem>
        <MenuItem onClick={openRewards}><EmojiEvents sx={{ mr: 1 }} fontSize="small" />Récompenses</MenuItem>
        <Divider />
        <MenuItem onClick={openDelete} sx={{ color: 'error.main' }}><Delete sx={{ mr: 1 }} fontSize="small" />Supprimer</MenuItem>
      </Menu>

      {/* ── EDIT DIALOG ──────────────────────────────────────────────────── */}
      <Dialog open={editOpen} onClose={() => setEditOpen(false)} maxWidth="sm" fullWidth
        PaperProps={{ sx: { borderRadius: 3 } }}>
        <DialogTitle sx={{ pb: 1 }}>
          <Box sx={{ display: 'flex', alignItems: 'center', gap: 1.5 }}>
            {activePlayer && <PlayerAvatar name={activePlayer.name} size={42} />}
            <Box>
              <Typography variant="h6" fontWeight={700}>Modifier le joueur</Typography>
              <Typography variant="caption" color="text.secondary">{activePlayer?.name}</Typography>
            </Box>
          </Box>
          <IconButton sx={{ position: 'absolute', right: 10, top: 10 }} onClick={() => setEditOpen(false)}>
            <Close />
          </IconButton>
        </DialogTitle>
        <Divider />
        <DialogContent sx={{ maxHeight: '72vh', overflowY: 'auto', pb: 1 }}>
          <PlayerForm v={form} set={(k, v) => setForm(f => ({ ...f, [k]: v }))} isCreate={false} />
        </DialogContent>
        <Divider />
        <DialogActions sx={{ px: 3, py: 2 }}>
          <Button variant="outlined" color="inherit" onClick={() => setEditOpen(false)}>Annuler</Button>
          <Button variant="contained" onClick={handleSave} disabled={saving}
            startIcon={saving ? <CircularProgress size={16} /> : null}>
            {saving ? 'Enregistrement…' : 'Enregistrer'}
          </Button>
        </DialogActions>
      </Dialog>

      {/* ── CREATE DIALOG ────────────────────────────────────────────────── */}
      <Dialog open={createOpen} onClose={() => setCreateOpen(false)} maxWidth="sm" fullWidth
        PaperProps={{ sx: { borderRadius: 3 } }}>
        <DialogTitle sx={{ pb: 1 }}>
          <Box sx={{ display: 'flex', alignItems: 'center', gap: 1 }}>
            <Add color="primary" />
            <Typography variant="h6" fontWeight={700}>Nouveau joueur</Typography>
          </Box>
          <IconButton sx={{ position: 'absolute', right: 10, top: 10 }} onClick={() => setCreateOpen(false)}>
            <Close />
          </IconButton>
        </DialogTitle>
        <Divider />
        <DialogContent sx={{ maxHeight: '72vh', overflowY: 'auto', pb: 1 }}>
          <PlayerForm v={createForm} set={(k, v) => setCreateForm(f => ({ ...f, [k]: v }))} isCreate={true} />
        </DialogContent>
        <Divider />
        <DialogActions sx={{ px: 3, py: 2 }}>
          <Button variant="outlined" color="inherit" onClick={() => setCreateOpen(false)}>Annuler</Button>
          <Button variant="contained" startIcon={saving ? <CircularProgress size={16} /> : <Add />}
            onClick={handleCreate} disabled={saving}>
            {saving ? 'Création…' : 'Créer le joueur'}
          </Button>
        </DialogActions>
      </Dialog>

      {/* ── DETAILS DIALOG ───────────────────────────────────────────────── */}
      <Dialog open={detailsOpen} onClose={() => setDetailsOpen(false)} maxWidth="xs" fullWidth
        PaperProps={{ sx: { borderRadius: 3 } }}>
        <DialogTitle>
          <Box sx={{ display: 'flex', alignItems: 'center', gap: 1.5 }}>
            {activePlayer && <PlayerAvatar name={activePlayer.name} size={46} />}
            <Box>
              <Typography variant="h6" fontWeight={700}>{activePlayer?.name}</Typography>
              <Box sx={{ display: 'flex', gap: 0.5, mt: 0.3 }}>
                {activePlayer?.position && (
                  <Chip size="small" label={posLabel(activePlayer.position)}
                    sx={{ bgcolor: posColor(activePlayer.position) + '22', color: posColor(activePlayer.position), fontWeight: 600, fontSize: 11 }} />
                )}
                {activePlayer?.isCaptain && <Chip size="small" label="⭐ Capitaine" color="warning" />}
              </Box>
            </Box>
          </Box>
          <IconButton sx={{ position: 'absolute', right: 10, top: 10 }} onClick={() => setDetailsOpen(false)}>
            <Close />
          </IconButton>
        </DialogTitle>
        <Divider />
        <DialogContent>
          {activePlayer && (() => {
            const Row = ({ label, value }) => (
              <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', py: 0.6 }}>
                <Typography variant="body2" color="text.secondary">{label}</Typography>
                <Typography variant="body2" fontWeight={500}>{value || '—'}</Typography>
              </Box>
            );
            return (
              <Stack spacing={0} sx={{ mt: 1 }}>
                <Typography variant="caption" color="primary" fontWeight={700} sx={{ mb: 0.5 }}>IDENTITÉ</Typography>
                <Row label="Nationalité"      value={activePlayer.nationality} />
                <Row label="Date de naissance" value={activePlayer.dateOfBirth ? new Date(activePlayer.dateOfBirth).toLocaleDateString('fr-FR') : null} />
                <Divider sx={{ my: 1 }} />
                <Typography variant="caption" color="primary" fontWeight={700} sx={{ mb: 0.5 }}>SPORTIF</Typography>
                <Row label="Équipe"        value={activePlayer.team?.name ?? 'Sans équipe'} />
                <Row label="N° maillot"    value={activePlayer.jerseyNumber != null ? `#${activePlayer.jerseyNumber}` : null} />
                <Row label="Pied préféré"  value={footLabel(activePlayer.preferredFoot)} />
                <Row label="Date d'arrivée" value={activePlayer.joinDate ? new Date(activePlayer.joinDate).toLocaleDateString('fr-FR') : null} />
                <Row label="Statut"        value={activePlayer.isActive !== false ? 'Actif' : 'Inactif'} />
                <Divider sx={{ my: 1 }} />
                <Typography variant="caption" color="primary" fontWeight={700} sx={{ mb: 0.5 }}>PHYSIQUE</Typography>
                <Row label="Taille" value={activePlayer.height ? `${activePlayer.height} cm` : null} />
                <Row label="Poids"  value={activePlayer.weight ? `${activePlayer.weight} kg` : null} />
                <Divider sx={{ my: 1 }} />
                <Typography variant="caption" color="primary" fontWeight={700} sx={{ mb: 0.5 }}>COMPTE MOBILE</Typography>
                <Row label="Email"     value={activePlayer.email ?? activePlayer.user?.email} />
                <Row label="Téléphone" value={activePlayer.phone ?? activePlayer.user?.phone} />
              </Stack>
            );
          })()}
        </DialogContent>
        <DialogActions sx={{ px: 2, pb: 2 }}>
          <Button variant="outlined" color="inherit" onClick={() => setDetailsOpen(false)}>Fermer</Button>
          <Button variant="outlined" onClick={() => { setDetailsOpen(false); openEdit(activePlayer); }}>
            Modifier
          </Button>
        </DialogActions>
      </Dialog>

      {/* ── DELETE DIALOG ────────────────────────────────────────────────── */}
      <Dialog open={deleteOpen} onClose={() => setDeleteOpen(false)} maxWidth="xs" fullWidth
        PaperProps={{ sx: { borderRadius: 3 } }}>
        <DialogTitle>Confirmer la suppression</DialogTitle>
        <DialogContent>
          <Typography>
            Supprimer <strong>{activePlayer?.name}</strong> définitivement ?
          </Typography>
          <Typography variant="caption" color="error" sx={{ display: 'block', mt: 1 }}>
            Le compte mobile associé sera également supprimé.
          </Typography>
        </DialogContent>
        <DialogActions>
          <Button variant="outlined" color="inherit" onClick={() => setDeleteOpen(false)}>Annuler</Button>
          <Button variant="contained" color="error" onClick={handleDelete}>Supprimer</Button>
        </DialogActions>
      </Dialog>

      {/* ── REWARDS DIALOG ───────────────────────────────────────────────── */}
      <Dialog open={rewardsOpen} onClose={() => setRewardsOpen(false)} maxWidth="md" fullWidth
        PaperProps={{ sx: { borderRadius: 3 } }}>
        <DialogTitle>
          Récompenses — <strong>{activePlayer?.name}</strong>
          <IconButton sx={{ position: 'absolute', right: 10, top: 10 }} onClick={() => setRewardsOpen(false)}>
            <Close />
          </IconButton>
        </DialogTitle>
        <DialogContent>
          <Box sx={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fill, minmax(250px, 1fr))', gap: 2, mt: 1 }}>
            {REWARDS.map(r => {
              const sel = selRewards.some(x => x.id === r.id);
              return (
                <Card key={r.id} onClick={() => toggleReward(r)}
                  sx={{ cursor: 'pointer', border: sel ? 2 : 1,
                        borderColor: sel ? 'primary.main' : 'grey.300', transition: 'all .15s' }}>
                  <CardContent>
                    <Box sx={{ display: 'flex', alignItems: 'center', mb: 1 }}>
                      <Checkbox checked={sel} onClick={e => e.stopPropagation()} onChange={() => toggleReward(r)} />
                      <Typography variant="h5" sx={{ ml: 1 }}>{r.icon}</Typography>
                      <Chip label={`+${r.value} pts`} color="primary" size="small" sx={{ ml: 'auto' }} />
                    </Box>
                    <Typography fontWeight={700}>{r.name}</Typography>
                    <Typography variant="body2" color="text.secondary">{r.description}</Typography>
                  </CardContent>
                </Card>
              );
            })}
          </Box>
          {selRewards.length > 0 && (
            <Box sx={{ mt: 2, p: 2, bgcolor: 'primary.50', borderRadius: 2, border: '1px solid', borderColor: 'primary.100' }}>
              <Typography variant="subtitle2">
                {selRewards.length} sélectionnée(s) — Total : <strong>+{selRewards.reduce((s, r) => s + r.value, 0)} pts</strong>
              </Typography>
            </Box>
          )}
        </DialogContent>
        <DialogActions sx={{ px: 3, py: 2 }}>
          <Button variant="outlined" color="inherit" onClick={() => setRewardsOpen(false)}>Annuler</Button>
          <Button variant="contained" startIcon={<Add />} disabled={selRewards.length === 0} onClick={handleAward}>
            Attribuer {selRewards.length > 0 ? selRewards.length : ''} récompense{selRewards.length > 1 ? 's' : ''}
          </Button>
        </DialogActions>
      </Dialog>

    </Box>
  );
};

export default PlayersManagement;

