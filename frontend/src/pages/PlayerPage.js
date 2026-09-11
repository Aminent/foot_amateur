import React, { useEffect, useState } from 'react';
import { Box, Typography, Card, CardContent, Grid, TextField, Button, Tabs, Tab, Avatar, Chip, Alert, Stack } from '@mui/material';
import {
  SportsSoccer as GoalsIcon,
  EmojiEvents as AssistIcon,
  SportsHandball as ShotsIcon,
  MyLocation as OnTargetIcon,
  SwapHoriz as PassesIcon,
  VpnKey as KeyPassIcon,
  DirectionsRun as DribblesIcon,
  SportsKabaddi as TacklesIcon,
  PanToolAlt as InterceptionsIcon,
  CleaningServices as ClearancesIcon,
  ReportProblem as FoulsCommittedIcon,
  Healing as FoulsSufferedIcon,
  Block as OffsidesIcon,
  Shield as SavesIcon,
  CheckCircleOutline as CleanSheetsIcon,
  Schedule as MinutesIcon,
  WarningAmber as YellowIcon,
  Dangerous as RedIcon
} from '@mui/icons-material';
import { useAuth } from '../contexts/AuthContext';
import axios from 'axios';

const PlayerPage = () => {
  const { user, updateProfile, loadUser } = useAuth();
  const [overview, setOverview] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [tab, setTab] = useState(0);
  const [profileForm, setProfileForm] = useState({ name: user?.name || '', phone: user?.phone || '', dateOfBirth: user?.dateOfBirth || '', avatarUrl: user?.avatarUrl || '', nationality: '', height: '', weight: '' });

  useEffect(() => {
    const load = async () => {
      try {
        setLoading(true);
        console.log('PlayerPage: Current user:', user);
        
        // Ensure we have fresh profile with linked player
        if (user && user.role === 'joueur' && !user.playerProfile) {
          console.log('PlayerPage: Loading user profile...');
          await loadUser();
          return; // Let the next useEffect call handle the rest
        }
        
        // user may be a coach or admin; only fetch overview if player exists
        const playerId = (user?.playerProfile && user.playerProfile.id) ? user.playerProfile.id : null;
        console.log('PlayerPage: Player ID:', playerId);
        
        if (!playerId) {
          setOverview(null);
        } else {
          console.log('PlayerPage: Fetching player overview...');
          const res = await axios.get(`/players/${playerId}/overview`);
          setOverview(res.data);
        }
      } catch (e) {
        console.error('PlayerPage error:', e);
        setError(e.response?.data?.message || 'Erreur lors du chargement');
      } finally {
        setLoading(false);
      }
    };
    
    if (user) {
      load();
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [user]); // Intentionally excluding loadUser to prevent infinite loops

  const saveProfile = async () => {
    const r = await updateProfile(profileForm);
    if (!r?.success) setError(r.error || 'Erreur lors de la mise à jour du profil');
  };

  if (loading) return <Box sx={{ p: 3 }}><Typography>Chargement...</Typography></Box>;

  return (
    <Box>
      <Typography variant="h4" sx={{ mb: 2 }}>Espace Joueur</Typography>
      {error && <Alert severity="error" sx={{ mb: 2 }}>{error}</Alert>}
      <Tabs value={tab} onChange={(e, v) => setTab(v)} sx={{ mb: 3 }}>
        <Tab label="Mon profil" />
        <Tab label="Mon équipe" />
        <Tab label="Mes matchs" />
        <Tab label="Mes stats" />
      </Tabs>

      {tab === 0 && (
        <Card>
          <CardContent>
            <Grid container spacing={2}>
              <Grid item xs={12}>
                <Stack direction="row" spacing={3} alignItems="center">
                  <Avatar variant="square" src={user?.avatarUrl || profileForm.avatarUrl} sx={{ width: 128, height: 128 }} />
                  <Button variant="outlined" component="label">
                    Télécharger une photo
                    <input hidden accept="image/*" type="file" onChange={async (e) => {
                      const file = e.target.files?.[0];
                      if (!file) return;
                      const form = new FormData();
                      form.append('avatar', file);
                      try {
                        const res = await fetch(`${process.env.REACT_APP_API_URL || 'http://localhost:5000/api'}/uploads/avatar`, {
                          method: 'POST',
                          headers: { Authorization: `Bearer ${localStorage.getItem('token')}` },
                          body: form
                        });
                        const data = await res.json();
                        if (res.ok && data.url) {
                          setProfileForm({ ...profileForm, avatarUrl: data.url });
                          // Persist immediately so it remains after refresh
                          try { await updateProfile({ avatarUrl: data.url }); } catch {}
                        }
                      } catch {}
                    }} />
                  </Button>
                </Stack>
              </Grid>
              <Grid item xs={12} sm={6}>
                <TextField fullWidth label="Nom" value={profileForm.name} onChange={(e) => setProfileForm({ ...profileForm, name: e.target.value })} />
              </Grid>
              <Grid item xs={12} sm={6}>
                <TextField fullWidth label="Téléphone" value={profileForm.phone} onChange={(e) => setProfileForm({ ...profileForm, phone: e.target.value })} />
              </Grid>
              <Grid item xs={12} sm={6}>
                <TextField fullWidth type="date" label="Date de naissance" InputLabelProps={{ shrink: true }} value={profileForm.dateOfBirth} onChange={(e) => setProfileForm({ ...profileForm, dateOfBirth: e.target.value })} />
              </Grid>
              <Grid item xs={12} sm={4}>
                <TextField fullWidth label="Nationalité" value={profileForm.nationality} onChange={(e) => setProfileForm({ ...profileForm, nationality: e.target.value })} />
              </Grid>
              <Grid item xs={12} sm={4}>
                <TextField fullWidth type="number" label="Taille (cm)" value={profileForm.height} onChange={(e) => setProfileForm({ ...profileForm, height: e.target.value })} />
              </Grid>
              <Grid item xs={12} sm={4}>
                <TextField fullWidth type="number" label="Poids (kg)" value={profileForm.weight} onChange={(e) => setProfileForm({ ...profileForm, weight: e.target.value })} />
              </Grid>
              <Grid item xs={12}>
                <Button variant="contained" onClick={saveProfile}>Enregistrer</Button>
              </Grid>
            </Grid>
          </CardContent>
        </Card>
      )}

      {tab === 1 && (
        <Card>
          <CardContent>
            {overview?.team ? (
              <Box>
                <Typography variant="h6">{overview.team.name}</Typography>
                {overview.tournament && (
                  <Typography variant="body2" color="text.secondary">Tournoi: {overview.tournament.name}</Typography>
                )}
              </Box>
            ) : (
              <Typography color="text.secondary">Aucune équipe</Typography>
            )}
          </CardContent>
        </Card>
      )}

      {tab === 2 && (
        <Card>
          <CardContent>
            <Typography variant="h6" sx={{ mb: 1 }}>Derniers matchs</Typography>
            {overview?.matches?.length ? (
              <Grid container spacing={2}>
                {overview.matches.map(m => (
                  <Grid item xs={12} key={m.id}>
                    <Box sx={{ display: 'flex', alignItems: 'center', gap: 2 }}>
                      <Chip size="small" label={new Date(m.date).toLocaleDateString('fr-FR')} />
                      <Typography>{m.homeTeam?.name} vs {m.awayTeam?.name}</Typography>
                      <Chip size="small" label={m.status} />
                    </Box>
                  </Grid>
                ))}
              </Grid>
            ) : (
              <Typography color="text.secondary">Aucun match</Typography>
            )}
          </CardContent>
        </Card>
      )}

      {tab === 3 && (
        <Card>
          <CardContent>
            <Typography variant="h6" sx={{ mb: 1 }}>Statistiques</Typography>
            {overview?.stats ? (
              <Grid container spacing={2}>
                {[
                  { label: 'Buts', key: 'goals', Icon: GoalsIcon, color: 'primary.main' },
                  { label: 'Passes', key: 'assists', Icon: AssistIcon, color: 'secondary.main' },
                  { label: 'Tirs', key: 'shots', Icon: ShotsIcon, color: 'info.main' },
                  { label: 'Tirs cadrés', key: 'shotsOnTarget', Icon: OnTargetIcon, color: 'success.main' },
                  { label: 'Passes totales', key: 'passes', Icon: PassesIcon, color: 'primary.main' },
                  { label: 'Passes clés', key: 'keyPasses', Icon: KeyPassIcon, color: 'secondary.main' },
                  { label: 'Dribbles', key: 'dribbles', Icon: DribblesIcon, color: 'warning.main' },
                  { label: 'Tacles', key: 'tackles', Icon: TacklesIcon, color: 'info.main' },
                  { label: 'Interceptions', key: 'interceptions', Icon: InterceptionsIcon, color: 'success.main' },
                  { label: 'Dégagements', key: 'clearances', Icon: ClearancesIcon, color: 'primary.main' },
                  { label: 'Fautes commises', key: 'foulsCommitted', Icon: FoulsCommittedIcon, color: 'error.main' },
                  { label: 'Fautes subies', key: 'foulsSuffered', Icon: FoulsSufferedIcon, color: 'secondary.main' },
                  { label: 'Hors-jeu', key: 'offsides', Icon: OffsidesIcon, color: 'warning.main' },
                  { label: 'Arrêts', key: 'saves', Icon: SavesIcon, color: 'info.main' },
                  { label: 'Clean sheets', key: 'cleanSheets', Icon: CleanSheetsIcon, color: 'success.main' },
                  { label: 'Minutes', key: 'minutesPlayed', Icon: MinutesIcon, color: 'text.secondary' },
                  { label: 'Jaunes', key: 'yellowCards', Icon: YellowIcon, color: 'warning.main' },
                  { label: 'Rouges', key: 'redCards', Icon: RedIcon, color: 'error.main' }
                ].map(({ label, key, Icon, color }) => (
                  <Grid item xs={6} sm={3} key={key}>
                    <Card>
                      <CardContent>
                        <Box sx={{ display: 'flex', justifyContent: 'center', mb: 1 }}>
                          <Avatar sx={{ bgcolor: color }}>
                            <Icon />
                          </Avatar>
                        </Box>
                        <Typography align="center" variant="h4">{overview.stats[key] ?? 0}</Typography>
                        <Typography align="center" color="text.secondary">{label}</Typography>
                      </CardContent>
                    </Card>
                  </Grid>
                ))}
              </Grid>
            ) : (
              <Typography color="text.secondary">Aucune statistique</Typography>
            )}
          </CardContent>
        </Card>
      )}
    </Box>
  );
};

export default PlayerPage;
