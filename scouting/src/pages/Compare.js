import React, { useState, useEffect } from 'react';
import { useSearchParams } from 'react-router-dom';
import {
  Box, Card, CardContent, Typography, Grid,
  Select, MenuItem, FormControl, InputLabel,
  Avatar, Chip, CircularProgress, Button, Divider,
  Tooltip as MuiTooltip, Paper,
} from '@mui/material';
import CompareIcon from '@mui/icons-material/CompareArrows';
import {
  RadarChart, Radar, PolarGrid, PolarAngleAxis, PolarRadiusAxis,
  LineChart, Line, CartesianGrid, XAxis, YAxis,
  ResponsiveContainer, Legend, Tooltip,
} from 'recharts';
import { apiFetch } from '../utils/api';
import { POSITION_CONFIG } from '../utils/positionConfig';

const COLORS = ['#0c9e96', '#dc2626', '#16a34a'];

const PlayerTooltipContent = ({ player }) => {
  const pos = POSITION_CONFIG[player?.position];
  return (
    <Paper elevation={0} sx={{ p: 1.5, minWidth: 190, bgcolor: 'background.paper', border: '1px solid', borderColor: 'divider', borderRadius: 2 }}>
      <Box sx={{ display: 'flex', alignItems: 'center', gap: 1.5, mb: 1 }}>
        <Avatar sx={{ width: 36, height: 36, bgcolor: '#0c9e96', fontWeight: 700 }}>
          {player?.name?.[0]?.toUpperCase()}
        </Avatar>
        <Box>
          <Typography sx={{ color: 'text.primary', fontWeight: 700, fontSize: '0.85rem' }}>{player?.name}</Typography>
          <Typography sx={{ color: 'text.secondary', fontSize: '0.72rem' }}>{player?.team?.name || 'Sans équipe'}</Typography>
        </Box>
      </Box>
      <Box sx={{ display: 'flex', flexWrap: 'wrap', gap: 0.5 }}>
        {pos && <Chip label={pos.label} size="small" sx={{ bgcolor: pos.bg, color: pos.color, fontWeight: 600, height: 20, fontSize: '0.68rem' }} />}
        {player?.jerseyNumber && <Chip label={`#${player.jerseyNumber}`} size="small" sx={{ bgcolor: 'action.selected', color: 'text.primary', height: 20, fontSize: '0.68rem' }} />}
        {player?.age && <Chip label={`${player.age} ans`} size="small" sx={{ bgcolor: 'action.selected', color: 'text.primary', height: 20, fontSize: '0.68rem' }} />}
      </Box>
    </Paper>
  );
};

const StatBar = ({ label, vals, colors }) => {
  const max = Math.max(...vals.map(v => v || 0), 1);
  return (
    <Box>
      {vals.map((v, i) => (
        <Box key={i} sx={{ display: 'flex', alignItems: 'center', gap: 1, mb: 0.4 }}>
          <Box sx={{ flex: 1, height: 6, borderRadius: 4, bgcolor: 'background.default' }}>
            <Box sx={{
              width: `${((v || 0) / max) * 100}%`, height: '100%', borderRadius: 4,
              background: `linear-gradient(90deg, ${colors[i]}, ${colors[i]}bb)`,
              boxShadow: `0 0 6px ${colors[i]}66`,
              transition: 'width 0.8s cubic-bezier(0.4,0,0.2,1)',
            }} />
          </Box>
        </Box>
      ))}
    </Box>
  );
};

export default function Compare() {
  const [searchParams, setSearchParams] = useSearchParams();
  const [players,  setPlayers]  = useState([]);
  const [statsMap, setStatsMap] = useState({});
  const [loading,  setLoading]  = useState(true);

  // Lire depuis l'URL d'abord, sinon depuis localStorage
  const getSaved = () => {
    try { return JSON.parse(localStorage.getItem('scout_compare') || 'null'); } catch { return null; }
  };

  const urlIds = searchParams.getAll('p');
  const urlCompare = searchParams.get('compare') === '1';
  const saved = getSaved();

  const initIds     = urlIds.length > 0 ? urlIds : (saved?.ids || ['', '']);
  const initCompare = urlIds.length > 0 ? urlCompare : (saved?.comparing || false);

  const selected  = initIds.length >= 2 ? initIds : [...initIds, ...Array(2 - initIds.length).fill('')];
  const comparing = initCompare;

  // Persister dans l'URL ET localStorage
  const setSelected = (ids, cmp = false) => {
    const params = new URLSearchParams();
    ids.filter(Boolean).forEach(id => params.append('p', id));
    if (cmp) params.set('compare', '1');
    setSearchParams(params, { replace: true });
    localStorage.setItem('scout_compare', JSON.stringify({ ids, comparing: cmp }));
  };

  useEffect(() => {
    apiFetch('/players').then(d => setPlayers(d.players || [])).catch(err => console.error('Erreur Compare:', err)).finally(() => setLoading(false));
  }, []);

  // Charger stats des joueurs dans l'URL
  useEffect(() => {
    selected.forEach(id => {
      if (id && statsMap[id] === undefined) {
        apiFetch(`/player-stats/${id}`)
          .then(d => setStatsMap(prev => ({ ...prev, [id]: d.stats || {} })))
          .catch(()  => setStatsMap(prev => ({ ...prev, [id]: {} })));
      }
    });
  // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [selected.join(',')]);

  const setSlot = (i, val) => {
    const next = selected.map((v, idx) => idx === i ? val : v);
    setSelected(next, false);
  };
  const addSlot    = () => selected.length < 3 && setSelected([...selected, ''], false);
  const removeSlot = (i) => setSelected(selected.filter((_, idx) => idx !== i), false);

  const handleCompare = () => {
    const ids = selected.filter(Boolean);
    if (ids.length < 2) return;
    Promise.all(ids.map(id =>
      statsMap[id] !== undefined
        ? Promise.resolve()
        : apiFetch(`/player-stats/${id}`)
            .then(d => setStatsMap(prev => ({ ...prev, [id]: d.stats || {} })))
            .catch(()  => setStatsMap(prev => ({ ...prev, [id]: {} })))
    )).then(() => setSelected(ids, true));
  };

  const activeIds     = comparing ? selected.filter(Boolean) : [];
  const activePlayers = activeIds.map(id => players.find(p => String(p.id) === String(id)));

  const cap = (v, m = 10) => Math.min((v || 0) * m, 100);
  const radarData = activeIds.length >= 2 ? [
    { subject: 'Buts',       ...Object.fromEntries(activeIds.map((id, i) => [activePlayers[i]?.name || id, cap(statsMap[id]?.goals)])) },
    { subject: 'Passes D.',  ...Object.fromEntries(activeIds.map((id, i) => [activePlayers[i]?.name || id, cap(statsMap[id]?.assists)])) },
    { subject: 'Minutes',    ...Object.fromEntries(activeIds.map((id, i) => [activePlayers[i]?.name || id, Math.min(Math.round((statsMap[id]?.minutesPlayed || 0) / 10), 100)])) },
    { subject: 'Tirs',       ...Object.fromEntries(activeIds.map((id, i) => [activePlayers[i]?.name || id, cap(statsMap[id]?.shots, 5)])) },
    { subject: 'Tacles',     ...Object.fromEntries(activeIds.map((id, i) => [activePlayers[i]?.name || id, cap(statsMap[id]?.tackles, 5)])) },
    { subject: 'Discipline', ...Object.fromEntries(activeIds.map((id, i) => [activePlayers[i]?.name || id, Math.max(100 - ((statsMap[id]?.yellowCards || 0) + (statsMap[id]?.redCards || 0)) * 20, 0)])) },
  ] : [];

  if (loading) return <Box sx={{ display: 'flex', justifyContent: 'center', pt: 8 }}><CircularProgress /></Box>;

  return (
    <Box>
      <Box sx={{ mb: 3 }}>
        <Typography sx={{ fontSize: '0.72rem', fontWeight: 600, textTransform: 'uppercase', letterSpacing: '0.06em', color: '#0c9e96', mb: 0.5 }}>
          Scouting
        </Typography>
        <Typography sx={{ fontWeight: 800, fontSize: '1.5rem', color: 'text.primary', lineHeight: 1.2 }}>
          Comparateur de joueurs
        </Typography>
        <Typography sx={{ fontSize: '0.875rem', color: 'text.secondary', mt: 0.5 }}>
          Sélectionnez deux joueurs pour comparer leurs profils
        </Typography>
      </Box>

      {/* Sélecteurs — Select direct pour éviter le size:small du thème */}
      <Card sx={{ mb: 3, p: 2.5 }}>
        <Grid container spacing={2} alignItems="center">
          {selected.map((val, i) => (
            <Grid item xs={12} sm key={i}>
              <Box sx={{ display: 'flex', gap: 1, alignItems: 'center' }}>
                <FormControl fullWidth>
                  <InputLabel sx={{ fontSize: '0.95rem' }}>Joueur {i + 1}</InputLabel>
                  <Select
                    value={val}
                    label={`Joueur ${i + 1}`}
                    onChange={e => setSlot(i, e.target.value)}
                    sx={{
                      minHeight: 56,
                      '& .MuiOutlinedInput-notchedOutline': { borderColor: val ? COLORS[i] + '99' : undefined },
                      '&:hover .MuiOutlinedInput-notchedOutline': { borderColor: COLORS[i] },
                      '&.Mui-focused .MuiOutlinedInput-notchedOutline': { borderColor: COLORS[i], borderWidth: 2 },
                    }}
                  >
                    <MenuItem value=""><em>— Choisir un joueur —</em></MenuItem>
                    {players
                      .filter(p => !selected.filter((_, idx) => idx !== i).includes(String(p.id)))
                      .map(p => (
                        <MenuItem key={p.id} value={String(p.id)} sx={{ py: 1.25 }}>
                          <MuiTooltip
                            title={<PlayerTooltipContent player={p} />}
                            placement="right"
                            arrow
                            componentsProps={{
                              tooltip: { sx: { bgcolor: 'transparent', p: 0, maxWidth: 'none', boxShadow: '0 8px 24px rgba(0,0,0,0.12)' } },
                              arrow:   { sx: { color: '#e2e8f0' } },
                            }}
                          >
                            <Box sx={{ display: 'flex', alignItems: 'center', gap: 1.5, width: '100%' }}>
                              <Avatar sx={{ width: 30, height: 30, bgcolor: '#dbeafe', color: '#0a8880', fontSize: '0.72rem', fontWeight: 700 }}>
                                {p.name[0].toUpperCase()}
                              </Avatar>
                              <Box sx={{ flex: 1 }}>
                                <Typography sx={{ fontWeight: 600, fontSize: '0.875rem' }}>{p.name}</Typography>
                                <Typography sx={{ fontSize: '0.72rem', color: 'text.secondary' }}>{p.team?.name || '—'}</Typography>
                              </Box>
                              {POSITION_CONFIG[p.position] && (
                                <Chip label={POSITION_CONFIG[p.position].label} size="small"
                                  sx={{ bgcolor: POSITION_CONFIG[p.position].bg, color: POSITION_CONFIG[p.position].color, fontWeight: 600, height: 20, fontSize: '0.65rem' }} />
                              )}
                            </Box>
                          </MuiTooltip>
                        </MenuItem>
                      ))}
                  </Select>
                </FormControl>
                {selected.length > 2 && (
                  <Button size="small" onClick={() => removeSlot(i)} sx={{ color: '#dc2626', minWidth: 0 }}>✕</Button>
                )}
              </Box>
            </Grid>
          ))}
          {selected.length < 3 && (
            <Grid item xs="auto">
              <Button variant="outlined" onClick={addSlot} sx={{ height: 56, whiteSpace: 'nowrap', borderStyle: 'dashed' }}>
                + Ajouter
              </Button>
            </Grid>
          )}
          <Grid item xs={12}>
            <Button
              variant="contained"
              size="large"
              fullWidth
              disabled={selected.filter(Boolean).length < 2}
              onClick={handleCompare}
              startIcon={<CompareIcon />}
              sx={{ py: 1.5, fontWeight: 700, fontSize: '1rem', bgcolor: '#0c9e96', '&:hover': { bgcolor: '#0a8880' }, borderRadius: 2 }}
            >
              Comparer {selected.filter(Boolean).length >= 2 ? `(${selected.filter(Boolean).length} joueurs)` : ''}
            </Button>
          </Grid>
        </Grid>
      </Card>

      {/* Résultats */}
      {activeIds.length < 2 ? (
        <Card sx={{ py: 10, textAlign: 'center' }}>
          <CompareIcon sx={{ fontSize: 56, color: '#e2e8f0', mb: 2 }} />
          <Typography color="text.secondary">Sélectionne au moins <strong>2 joueurs</strong> pour comparer</Typography>
        </Card>
      ) : (
        <Box sx={{ display: 'flex', flexDirection: 'column', gap: 4 }}>

          {/* Une seule ligne — flexbox responsive */}
          <Box sx={{ display: 'flex', flexDirection: { xs: 'column', md: 'row' }, gap: 2, alignItems: 'stretch', width: '100%' }}>

            {/* Cards joueurs — light design */}
            {activeIds.map((id, i) => {
              const p   = activePlayers[i];
              const s   = statsMap[id] || {};
              const pos = POSITION_CONFIG[p?.position];
              const color = COLORS[i];
              return (
                <Box key={id} sx={{ flex: '0 0 170px', minWidth: 0 }}>
                  <Card sx={{
                    height: '100%', overflow: 'hidden', position: 'relative',
                    bgcolor: 'background.paper',
                    border: '1px solid',
                    borderColor: 'divider',
                    boxShadow: '0 1px 4px rgba(0,0,0,0.05)',
                    '&:hover': { borderColor: 'rgba(12,158,150,0.25)', boxShadow: '0 4px 16px rgba(12,158,150,0.10)' },
                    '&::before': {
                      content: '""', position: 'absolute', top: 0, left: 0, right: 0, height: '3px',
                      background: `linear-gradient(90deg, ${color}, ${color}88)`,
                    },
                  }}>
                    <CardContent sx={{ textAlign: 'center', p: 2, '&:last-child': { pb: 2 } }}>
                      {/* Avatar */}
                      <Box sx={{ position: 'relative', width: 64, height: 64, mx: 'auto', mb: 1.5 }}>
                        <Avatar sx={{
                          width: 64, height: 64, bgcolor: '#dbeafe', color: '#0a8880', fontWeight: 800, fontSize: '1.5rem',
                          border: `2px solid ${color}44`,
                        }}>
                          {p?.name?.[0]?.toUpperCase() || '?'}
                        </Avatar>
                      </Box>

                      <Typography sx={{ fontWeight: 800, fontSize: '0.95rem', color: 'text.primary' }}>{p?.name || '?'}</Typography>
                      <Typography sx={{ fontSize: '0.72rem', color: 'text.secondary', mt: 0.3 }}>{p?.team?.name || '—'}</Typography>
                      {pos && (
                        <Chip label={pos.label} size="small" sx={{
                          mt: 0.75, fontWeight: 700, fontSize: '0.65rem',
                          bgcolor: `${color}22`, color: color,
                          border: `1px solid ${color}44`,
                        }} />
                      )}

                      <Box sx={{ mt: 2, borderTop: '1px solid', borderColor: 'divider', pt: 1.5 }}>
                        {[
                          { l: 'Buts',      v: s.goals,        icon: '⚽' },
                          { l: 'Passes D.', v: s.assists,      icon: '🎯' },
                          { l: 'Minutes',   v: s.minutesPlayed, icon: '⏱' },
                          { l: 'Tirs',      v: s.shots,        icon: '🔥' },
                          { l: 'Tacles',    v: s.tackles,      icon: '🛡' },
                          { l: 'C.Jaunes',  v: s.yellowCards,  icon: '🟨' },
                          { l: 'C.Rouges',  v: s.redCards,     icon: '🟥' },
                        ].map(({ l, v, icon }) => (
                          <Box key={l} sx={{
                            display: 'flex', justifyContent: 'space-between', alignItems: 'center',
                            py: 0.4, borderBottom: '1px solid', borderColor: 'divider',
                          }}>
                            <Typography sx={{ fontSize: '0.72rem', color: 'text.secondary' }}>{icon} {l}</Typography>
                            <Typography sx={{
                              fontSize: '0.82rem', fontWeight: 800, color: color,
                              background: `${color}18`, px: 0.8, borderRadius: 1,
                            }}>{v ?? 0}</Typography>
                          </Box>
                        ))}
                      </Box>
                    </CardContent>
                  </Card>
                </Box>
              );
            })}

            {/* Radar — light card */}
            <Box sx={{ flex: '1 1 0', minWidth: 0 }}>
              <Card sx={{
                height: '100%',
                bgcolor: 'background.paper',
                border: '1px solid',
                borderColor: 'divider',
                boxShadow: '0 1px 4px rgba(0,0,0,0.05)',
              }}>
                <Box sx={{ px: 2, py: 1.5, borderBottom: '1px solid', borderColor: 'divider', display: 'flex', alignItems: 'center', gap: 1 }}>
                  <Box sx={{ width: 6, height: 6, borderRadius: '50%', bgcolor: '#0c9e96' }} />
                  <Box>
                    <Typography sx={{ fontWeight: 700, fontSize: '0.9rem', color: 'text.primary' }}>Radar</Typography>
                    <Typography sx={{ fontSize: '0.68rem', color: 'text.secondary' }}>Profil normalisé / 100</Typography>
                  </Box>
                </Box>
                <CardContent sx={{ p: 1.5, '&:last-child': { pb: 1.5 } }}>
                  <ResponsiveContainer width="100%" height={360}>
                    <RadarChart data={radarData}>
                      <PolarGrid stroke="#e2e8f0" />
                      <PolarAngleAxis dataKey="subject" tick={{ fontSize: 11, fill: '#64748b' }} />
                      <PolarRadiusAxis angle={90} domain={[0, 100]} tick={false} axisLine={false} />
                      {activeIds.map((id, i) => (
                        <Radar key={id} name={activePlayers[i]?.name || id}
                          dataKey={activePlayers[i]?.name || id}
                          stroke={COLORS[i]} fill={COLORS[i]} fillOpacity={0.25} strokeWidth={2} />
                      ))}
                      <Legend wrapperStyle={{ color: '#64748b', fontSize: '0.78rem' }} />
                      <Tooltip contentStyle={{ borderRadius: 8 }} />
                    </RadarChart>
                  </ResponsiveContainer>
                </CardContent>
              </Card>
            </Box>

            {/* LineChart — light card */}
            <Box sx={{ flex: '2 1 0', minWidth: 0 }}>
              <Card sx={{
                height: '100%',
                bgcolor: 'background.paper',
                border: '1px solid',
                borderColor: 'divider',
                boxShadow: '0 1px 4px rgba(0,0,0,0.05)',
              }}>
                <Box sx={{ px: 2, py: 1.5, borderBottom: '1px solid', borderColor: 'divider', display: 'flex', alignItems: 'center', gap: 1 }}>
                  <Box sx={{ width: 6, height: 6, borderRadius: '50%', bgcolor: '#22c55e' }} />
                  <Box>
                    <Typography sx={{ fontWeight: 700, fontSize: '0.9rem', color: 'text.primary' }}>Statistiques réelles</Typography>
                    <Typography sx={{ fontSize: '0.68rem', color: 'text.secondary' }}>Valeurs brutes par catégorie</Typography>
                  </Box>
                </Box>
                <CardContent sx={{ p: 1, '&:last-child': { pb: 1 } }}>
                  <ResponsiveContainer width="100%" height={360}>
                    <LineChart
                      data={[
                        { stat: 'Buts',       ...Object.fromEntries(activeIds.map((id, i) => [activePlayers[i]?.name || `J${i+1}`, statsMap[id]?.goals || 0])) },
                        { stat: 'Passes D.',  ...Object.fromEntries(activeIds.map((id, i) => [activePlayers[i]?.name || `J${i+1}`, statsMap[id]?.assists || 0])) },
                        { stat: 'Tirs',       ...Object.fromEntries(activeIds.map((id, i) => [activePlayers[i]?.name || `J${i+1}`, statsMap[id]?.shots || 0])) },
                        { stat: 'Tacles',     ...Object.fromEntries(activeIds.map((id, i) => [activePlayers[i]?.name || `J${i+1}`, statsMap[id]?.tackles || 0])) },
                        { stat: 'C. Jaunes',  ...Object.fromEntries(activeIds.map((id, i) => [activePlayers[i]?.name || `J${i+1}`, statsMap[id]?.yellowCards || 0])) },
                        { stat: 'C. Rouges',  ...Object.fromEntries(activeIds.map((id, i) => [activePlayers[i]?.name || `J${i+1}`, statsMap[id]?.redCards || 0])) },
                      ]}
                      margin={{ top: 10, right: 20, left: 0, bottom: 5 }}
                    >
                      <CartesianGrid stroke="#f1f5f9" strokeDasharray="5 5" />
                      <XAxis dataKey="stat" tick={{ fontSize: 11, fill: '#94a3b8' }} axisLine={{ stroke: '#e2e8f0' }} tickLine={false} />
                      <YAxis width={35} tick={{ fontSize: 11, fill: '#94a3b8' }} axisLine={false} tickLine={false} allowDecimals={false} />
                      <Tooltip
                        contentStyle={{ borderRadius: 8, fontSize: '0.82rem' }}
                        formatter={(value, name) => [value, name]}
                      />
                      <Legend wrapperStyle={{ color: '#64748b', fontSize: '0.78rem' }} />
                      {activeIds.map((id, i) => (
                        <Line key={id} type="monotone"
                          dataKey={activePlayers[i]?.name || `J${i+1}`}
                          stroke={COLORS[i]} strokeWidth={2.5}
                          dot={{ fill: 'white', stroke: COLORS[i], strokeWidth: 2.5, r: 5 }}
                          activeDot={{ stroke: 'white', strokeWidth: 2, r: 7, fill: COLORS[i] }}
                        />
                      ))}
                    </LineChart>
                  </ResponsiveContainer>
                </CardContent>
              </Card>
            </Box>

            {/* Statistiques comparées — light card */}
            <Box sx={{ flex: '1 1 0', minWidth: 0 }}>
              <Card sx={{
                height: '100%',
                bgcolor: 'background.paper',
                border: '1px solid',
                borderColor: 'divider',
                boxShadow: '0 1px 4px rgba(0,0,0,0.05)',
              }}>
                <Box sx={{ px: 2, py: 1.5, borderBottom: '1px solid', borderColor: 'divider', display: 'flex', alignItems: 'center', gap: 1 }}>
                  <Box sx={{ width: 6, height: 6, borderRadius: '50%', bgcolor: '#f59e0b' }} />
                  <Typography sx={{ fontWeight: 700, fontSize: '0.9rem', color: 'text.primary' }}>Stats comparées</Typography>
                </Box>
                <CardContent sx={{ p: 2, '&:last-child': { pb: 2 } }}>
                  {[
                    { label: 'Buts',            key: 'goals',         icon: '⚽' },
                    { label: 'Passes déc.',      key: 'assists',       icon: '🎯' },
                    { label: 'Minutes',          key: 'minutesPlayed', icon: '⏱' },
                    { label: 'Tirs',             key: 'shots',         icon: '🔥' },
                    { label: 'Tacles',           key: 'tackles',       icon: '🛡' },
                    { label: 'C. Jaunes',        key: 'yellowCards',   icon: '🟨' },
                  ].map(({ label, key, icon }) => (
                    <Box key={key} sx={{ mb: 1.5 }}>
                      <Box sx={{ display: 'flex', justifyContent: 'space-between', mb: 0.5 }}>
                        <Typography sx={{ fontSize: '0.72rem', color: 'text.secondary' }}>{icon} {label}</Typography>
                        <Box sx={{ display: 'flex', gap: 1 }}>
                          {activeIds.map((id, i) => (
                            <Typography key={id} sx={{ fontSize: '0.72rem', fontWeight: 700, color: COLORS[i] }}>
                              {statsMap[id]?.[key] ?? 0}
                            </Typography>
                          ))}
                        </Box>
                      </Box>
                      <StatBar label="" vals={activeIds.map(id => statsMap[id]?.[key] || 0)} colors={COLORS} />
                    </Box>
                  ))}
                </CardContent>
              </Card>
            </Box>

          </Box>

        </Box>
      )}
    </Box>
  );
}
