import React, { useState, useEffect, useCallback } from 'react';
import { useNavigate, useSearchParams } from 'react-router-dom';
import {
  Box, Card, CardContent, Typography, Grid, Slider, TextField,
  Button, MenuItem, CircularProgress, Alert, Divider, Chip, Avatar, IconButton, Tooltip,
} from '@mui/material';
import SaveIcon       from '@mui/icons-material/Save';
import AssessmentIcon from '@mui/icons-material/Assessment';
import DeleteIcon     from '@mui/icons-material/Delete';
import { apiFetch } from '../utils/api';
import { useAuth } from '../contexts/AuthContext';

const CRITERIA = [
  { key: 'technicalRating', apiKey: 'technicalScore', label: 'Technique', desc: 'Contrôle, passe, frappe, dribble', color: '#0c9e96' },
  { key: 'physicalRating',  apiKey: 'physicalScore',  label: 'Physique',  desc: 'Vitesse, endurance, puissance',   color: '#16a34a' },
  { key: 'mentalRating',    apiKey: 'mentalScore',    label: 'Mental',    desc: 'Leadership, décision, attitude',   color: '#7c3aed' },
  { key: 'tacticalRating',  apiKey: 'tacticalScore',  label: 'Tactique',  desc: 'Positionnement, lecture du jeu',  color: '#ca8a04' },
];

const RECOMMENDATIONS = [
  { value: 'sign',   label: '✅ Recruter',             color: '#16a34a', bg: '#f0fdf4' },
  { value: 'watch',  label: '👁 Continuer à suivre',   color: '#0c9e96', bg: '#eff6ff' },
  { value: 'reject', label: '❌ Ne pas retenir',        color: '#dc2626', bg: '#fef2f2' },
];

export default function Evaluations() {
  const { user } = useAuth();
  const navigate  = useNavigate();
  const [searchParams] = useSearchParams();
  const preselectedId = searchParams.get('playerId');

  const [view,    setView]    = useState(preselectedId ? 'new' : 'list');
  const [players, setPlayers] = useState([]);
  const [evals,   setEvals]   = useState([]);
  const [loading, setLoading] = useState(true);
  const [saving,  setSaving]  = useState(false);
  const [error,   setError]   = useState('');
  const [success, setSuccess] = useState('');

  const [form, setForm] = useState({
    playerId:       preselectedId || '',
    overallRating:  7,
    technicalRating:7,
    physicalRating: 7,
    mentalRating:   7,
    tacticalRating: 7,
    recommendation: 'watch',
    notes:          '',
  });

  const loadEvals = useCallback(async () => {
    try {
      const data = await apiFetch('/scouts/me/evaluations');
      setEvals(data.evaluations || []);
    } catch (e) {
      setError('Impossible de charger les évaluations.');
    } finally {
      setLoading(false);
    }
  }, []);

  useEffect(() => {
    loadEvals();
    apiFetch('/players').then(d => setPlayers(d.players || [])).catch(() => {});
  }, [loadEvals]);

  const selectedPlayer = players.find(p => String(p.id) === String(form.playerId));

  const overall = Math.round(
    (form.technicalRating + form.physicalRating + form.mentalRating + form.tacticalRating) / 4
  );

  const ratingColor = (v) => v >= 8 ? '#16a34a' : v >= 6 ? '#ca8a04' : '#dc2626';

  const submit = async () => {
    if (!form.playerId) return;
    setSaving(true);
    setError('');
    try {
      await apiFetch('/scouts/me/evaluations', {
        method: 'POST',
        body: JSON.stringify({
          playerId:      Number(form.playerId),
          overallRating: overall,
          technicalScore: form.technicalRating,
          physicalScore:  form.physicalRating,
          mentalScore:    form.mentalRating,
          tacticalScore:  form.tacticalRating,
          recommendation: form.recommendation,
          notes:          form.notes,
          position:       selectedPlayer?.position || null,
        }),
      });
      setSuccess('Évaluation enregistrée avec succès !');
      await loadEvals();
      setTimeout(() => { setSuccess(''); setView('list'); }, 1800);
    } catch (e) {
      setError(e.message || 'Erreur lors de l\'enregistrement.');
    } finally {
      setSaving(false);
    }
  };

  const deleteEval = async (id) => {
    try {
      await apiFetch(`/scouts/me/evaluations/${id}`, { method: 'DELETE' });
      setEvals(prev => prev.filter(e => e.id !== id));
    } catch (e) {
      setError('Impossible de supprimer l\'évaluation.');
    }
  };

  const playerName = (ev) =>
    ev.player?.name
    || (ev.player?.user ? `${ev.player.user.firstName} ${ev.player.user.lastName}` : '?');

  // ── Formulaire nouvelle évaluation ─────────────────────────────────────────
  if (view === 'new') return (
    <Box>
      <Box sx={{ display: 'flex', alignItems: 'flex-start', justifyContent: 'space-between', flexWrap: 'wrap', gap: 2, mb: 3 }}>
        <Box>
          <Typography sx={{ fontSize: '0.72rem', fontWeight: 600, textTransform: 'uppercase', letterSpacing: '0.06em', color: '#0c9e96', mb: 0.5 }}>
            Nouvelle évaluation
          </Typography>
          <Typography sx={{ fontWeight: 800, fontSize: '1.5rem', color: 'text.primary', lineHeight: 1.2 }}>
            Évaluation joueur
          </Typography>
        </Box>
        <Button variant="text" onClick={() => setView('list')} sx={{ color: 'text.secondary' }}>← Retour</Button>
      </Box>

      {error   && <Alert severity="error"   sx={{ mb: 2 }} onClose={() => setError('')}>{error}</Alert>}
      {success && <Alert severity="success" sx={{ mb: 2 }}>{success}</Alert>}

      <Grid container spacing={3}>
        <Grid item xs={12} md={7}>
          <Card sx={{ mb: 3 }}>
            <Box sx={{ px: 2.5, py: 2, borderBottom: '1px solid', borderColor: 'divider' }}>
              <Typography sx={{ fontWeight: 700 }}>Joueur évalué</Typography>
            </Box>
            <CardContent>
              <TextField select fullWidth label="Sélectionner un joueur" value={form.playerId}
                onChange={e => setForm(f => ({ ...f, playerId: e.target.value }))}>
                <MenuItem value="">— Choisir —</MenuItem>
                {players.map(p => (
                  <MenuItem key={p.id} value={p.id}>
                    {p.name} {p.team?.name ? `(${p.team.name})` : ''}
                  </MenuItem>
                ))}
              </TextField>
            </CardContent>
          </Card>

          <Card sx={{ mb: 3 }}>
            <Box sx={{ px: 2.5, py: 2, borderBottom: '1px solid', borderColor: 'divider' }}>
              <Typography sx={{ fontWeight: 700 }}>Critères d'évaluation</Typography>
            </Box>
            <CardContent sx={{ pt: 2 }}>
              {CRITERIA.map(({ key, label, desc, color }) => (
                <Box key={key} sx={{ mb: 3 }}>
                  <Box sx={{ display: 'flex', justifyContent: 'space-between', mb: 1 }}>
                    <Box>
                      <Typography sx={{ fontWeight: 600, fontSize: '0.9rem' }}>{label}</Typography>
                      <Typography sx={{ fontSize: '0.75rem', color: 'text.secondary' }}>{desc}</Typography>
                    </Box>
                    <Typography sx={{ fontWeight: 800, fontSize: '1.4rem', color: ratingColor(form[key]) }}>
                      {form[key]}
                    </Typography>
                  </Box>
                  <Slider
                    value={form[key]}
                    onChange={(_, v) => setForm(f => ({ ...f, [key]: v }))}
                    min={1} max={10} step={1} marks
                    sx={{ color, '& .MuiSlider-markLabel': { fontSize: '0.7rem' } }}
                  />
                </Box>
              ))}
            </CardContent>
          </Card>

          <Card>
            <Box sx={{ px: 2.5, py: 2, borderBottom: '1px solid', borderColor: 'divider' }}>
              <Typography sx={{ fontWeight: 700 }}>Recommandation & Notes</Typography>
            </Box>
            <CardContent>
              <TextField select fullWidth label="Recommandation" value={form.recommendation}
                onChange={e => setForm(f => ({ ...f, recommendation: e.target.value }))} sx={{ mb: 2 }}>
                {RECOMMENDATIONS.map(r => <MenuItem key={r.value} value={r.value}>{r.label}</MenuItem>)}
              </TextField>
              <TextField fullWidth multiline rows={4} label="Notes libres"
                placeholder="Observations, points forts, axes de progression…"
                value={form.notes} onChange={e => setForm(f => ({ ...f, notes: e.target.value }))} />
            </CardContent>
          </Card>
        </Grid>

        {/* Récapitulatif */}
        <Grid item xs={12} md={5}>
          <Card sx={{ position: 'sticky', top: 24 }}>
            <Box sx={{ px: 2.5, py: 2, borderBottom: '1px solid', borderColor: 'divider' }}>
              <Typography sx={{ fontWeight: 700 }}>Récapitulatif</Typography>
            </Box>
            <CardContent sx={{ textAlign: 'center' }}>
              {selectedPlayer && (
                <>
                  <Avatar sx={{ width: 60, height: 60, bgcolor: '#0c9e96', mx: 'auto', mb: 1, fontSize: '1.4rem', fontWeight: 800 }}>
                    {selectedPlayer.name[0].toUpperCase()}
                  </Avatar>
                  <Typography sx={{ fontWeight: 700 }}>{selectedPlayer.name}</Typography>
                  <Typography sx={{ fontSize: '0.8rem', color: 'text.secondary', mb: 2 }}>{selectedPlayer.team?.name || ''}</Typography>
                </>
              )}
              <Box sx={{ width: 90, height: 90, borderRadius: '50%', border: `4px solid ${ratingColor(overall)}`, display: 'flex', alignItems: 'center', justifyContent: 'center', mx: 'auto', mb: 2 }}>
                <Typography sx={{ fontSize: '2rem', fontWeight: 900, color: ratingColor(overall) }}>{overall}</Typography>
              </Box>
              <Typography sx={{ fontSize: '0.8rem', color: 'text.secondary', mb: 2 }}>Note globale / 10</Typography>

              <Divider sx={{ mb: 2 }} />

              {CRITERIA.map(({ key, label, color }) => (
                <Box key={key} sx={{ display: 'flex', justifyContent: 'space-between', mb: 1 }}>
                  <Typography sx={{ fontSize: '0.82rem', color: 'text.secondary' }}>{label}</Typography>
                  <Typography sx={{ fontSize: '0.82rem', fontWeight: 700, color }}>{form[key]}/10</Typography>
                </Box>
              ))}

              <Divider sx={{ my: 2 }} />

              {(() => {
                const rec = RECOMMENDATIONS.find(r => r.value === form.recommendation);
                return rec ? <Chip label={rec.label} sx={{ bgcolor: rec.bg, color: rec.color, fontWeight: 700, mb: 2 }} /> : null;
              })()}

              <Button fullWidth variant="contained" onClick={submit} disabled={!form.playerId || saving}
                startIcon={saving ? <CircularProgress size={16} color="inherit" /> : <SaveIcon />}
                sx={{ bgcolor: '#0c9e96', '&:hover': { bgcolor: '#0a8880' }, py: 1.25, fontWeight: 700 }}>
                {saving ? 'Enregistrement…' : 'Enregistrer l\'évaluation'}
              </Button>
            </CardContent>
          </Card>
        </Grid>
      </Grid>
    </Box>
  );

  // ── Liste des évaluations ──────────────────────────────────────────────────
  if (loading) return <Box sx={{ display: 'flex', justifyContent: 'center', pt: 8 }}><CircularProgress /></Box>;

  return (
    <Box>
      <Box sx={{ display: 'flex', alignItems: 'flex-start', justifyContent: 'space-between', flexWrap: 'wrap', gap: 2, mb: 3 }}>
        <Box>
          <Typography sx={{ fontSize: '0.72rem', fontWeight: 600, textTransform: 'uppercase', letterSpacing: '0.06em', color: '#0c9e96', mb: 0.5 }}>
            Scouting
          </Typography>
          <Typography sx={{ fontWeight: 800, fontSize: '1.5rem', color: 'text.primary', lineHeight: 1.2 }}>
            Évaluations
          </Typography>
          <Typography sx={{ fontSize: '0.875rem', color: 'text.secondary', mt: 0.5 }}>
            {evals.length} rapport{evals.length > 1 ? 's' : ''}
          </Typography>
        </Box>
        <Button variant="contained" onClick={() => setView('new')} sx={{ bgcolor: '#0c9e96' }}>
          + Nouvelle évaluation
        </Button>
      </Box>

      {error && <Alert severity="error" sx={{ mb: 2 }} onClose={() => setError('')}>{error}</Alert>}

      {evals.length === 0 ? (
        <Card sx={{ py: 8, textAlign: 'center' }}>
          <AssessmentIcon sx={{ fontSize: 48, color: '#e2e8f0', mb: 2 }} />
          <Typography color="text.secondary" sx={{ mb: 2 }}>Aucune évaluation pour le moment</Typography>
          <Button variant="contained" onClick={() => setView('new')} sx={{ bgcolor: '#0c9e96' }}>Créer la première</Button>
        </Card>
      ) : (
        <Grid container spacing={2}>
          {evals.map(ev => {
            const rec = RECOMMENDATIONS.find(r => r.value === ev.recommendation);
            return (
              <Grid item xs={12} sm={6} md={4} key={ev.id}>
                <Card sx={{ p: 2.5 }}>
                  <Box sx={{ display: 'flex', alignItems: 'center', gap: 1.5, mb: 1.5 }}>
                    <Avatar sx={{ width: 40, height: 40, bgcolor: '#0c9e96', fontWeight: 700 }}>
                      {playerName(ev)[0]?.toUpperCase() || '?'}
                    </Avatar>
                    <Box sx={{ flex: 1, minWidth: 0 }}>
                      <Typography sx={{ fontWeight: 700, fontSize: '0.9rem' }} noWrap>{playerName(ev)}</Typography>
                      <Typography sx={{ fontSize: '0.72rem', color: 'text.secondary' }}>
                        {new Date(ev.createdAt || ev.date).toLocaleDateString('fr-FR')}
                      </Typography>
                    </Box>
                    <Typography sx={{ fontSize: '1.6rem', fontWeight: 900, color: ratingColor(ev.overallRating) }}>
                      {ev.overallRating}
                    </Typography>
                    <Tooltip title="Supprimer">
                      <IconButton size="small" onClick={() => deleteEval(ev.id)} sx={{ color: 'text.disabled', '&:hover': { color: '#dc2626' } }}>
                        <DeleteIcon fontSize="small" />
                      </IconButton>
                    </Tooltip>
                  </Box>

                  {/* Scores par critère */}
                  <Box sx={{ display: 'flex', gap: 1, flexWrap: 'wrap', mb: 1.5 }}>
                    {CRITERIA.map(({ apiKey, label, color }) =>
                      ev[apiKey] != null ? (
                        <Box key={apiKey} sx={{ textAlign: 'center' }}>
                          <Typography sx={{ fontSize: '0.65rem', color: 'text.secondary' }}>{label}</Typography>
                          <Typography sx={{ fontSize: '0.8rem', fontWeight: 700, color }}>{ev[apiKey]}</Typography>
                        </Box>
                      ) : null
                    )}
                  </Box>

                  {rec && <Chip label={rec.label} size="small" sx={{ bgcolor: rec.bg, color: rec.color, fontWeight: 600, fontSize: '0.7rem' }} />}
                  {ev.notes && (
                    <Typography sx={{ mt: 1.5, fontSize: '0.78rem', color: 'text.secondary', display: '-webkit-box', WebkitLineClamp: 2, WebkitBoxOrient: 'vertical', overflow: 'hidden' }}>
                      {ev.notes}
                    </Typography>
                  )}
                </Card>
              </Grid>
            );
          })}
        </Grid>
      )}
    </Box>
  );
}
