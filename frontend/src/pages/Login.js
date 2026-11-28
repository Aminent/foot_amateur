import React, { useState, useEffect } from 'react';
import {
  Box, TextField, Button, Typography, Alert,
  CircularProgress, InputAdornment, IconButton, Chip,
} from '@mui/material';
import {
  Email as EmailIcon,
  Lock as LockIcon,
  Visibility as VisibilityIcon,
  VisibilityOff as VisibilityOffIcon,
  SportsSoccer as BallIcon,
  EmojiEvents as TrophyIcon,
  Group as GroupIcon,
  BarChart as ChartIcon,
  CalendarMonth as CalendarIcon,
  CheckCircle as CheckIcon,
  ArrowForward as ArrowIcon,
} from '@mui/icons-material';
import { useNavigate, useLocation, Link as RouterLink } from 'react-router-dom';
import { useAuth } from '../contexts/AuthContext';
import Lottie from 'lottie-react';
import animationData from '../assets/footballer.json';

/* ─── palette ────────────────────────────────────────────────────────────────*/
const P = {
  navy:     '#1d2320',
  navyMid:  '#1d2320',
  navyLt:   '#1d2320',
  blue:     '#c8410e',   // teal primary (was #c8410e)
  blueLt:   '#ff8a5c',   // teal light   (was #ff8a5c)
  blueGlow: 'rgba(255,90,31,0.18)',
  accent:   '#c8410e',   // teal primary (was #2f7d4a)
  gold:     '#F59E0B',
  white:    '#FFFFFF',
  offWhite: '#f6f4ee',
  border:   '#dcd8cc',
  gray:     '#6f6a5f',
  gray2:    '#3f3c36',
  gray3:    '#9d978a',
};

/* ─── stat pill ──────────────────────────────────────────────────────────────*/
const Stat = ({ value, label, color }) => (
  <Box sx={{ textAlign: 'center' }}>
    <Typography sx={{ fontSize: '1.75rem', fontWeight: 800, color, lineHeight: 1, mb: 0.25 }}>
      {value}
    </Typography>
    <Typography sx={{ fontSize: '0.72rem', color: 'rgba(255,255,255,0.45)', textTransform: 'uppercase', letterSpacing: '0.06em' }}>
      {label}
    </Typography>
  </Box>
);

/* ─── feature row ────────────────────────────────────────────────────────────*/
const Feature = ({ icon, title, desc }) => (
  <Box sx={{ display: 'flex', gap: 1.75, alignItems: 'flex-start' }}>
    <Box sx={{
      width: 38, height: 38, borderRadius: '10px', flexShrink: 0,
      background: 'rgba(255,90,31,0.12)',
      border: '1px solid rgba(255,90,31,0.2)',
      display: 'flex', alignItems: 'center', justifyContent: 'center',
    }}>
      {React.cloneElement(icon, { sx: { fontSize: 18, color: P.blueLt } })}
    </Box>
    <Box>
      <Typography sx={{ fontSize: '0.85rem', fontWeight: 600, color: 'rgba(255,255,255,0.9)', mb: 0.2 }}>
        {title}
      </Typography>
      <Typography sx={{ fontSize: '0.75rem', color: 'rgba(255,255,255,0.4)', lineHeight: 1.5 }}>
        {desc}
      </Typography>
    </Box>
  </Box>
);

/* ─── mini match card ────────────────────────────────────────────────────────*/
const MatchCard = ({ home, away, score, time, live }) => (
  <Box sx={{
    p: '10px 14px',
    borderRadius: '10px',
    background: 'rgba(255,255,255,0.04)',
    border: '1px solid rgba(255,255,255,0.07)',
    display: 'flex', alignItems: 'center', gap: 1.5,
  }}>
    {live && (
      <Box sx={{ display: 'flex', alignItems: 'center', gap: 0.5, mr: 0.5 }}>
        <Box sx={{ width: 6, height: 6, borderRadius: '50%', bgcolor: '#EF4444',
          animation: 'pulse 1.5s ease-in-out infinite',
          '@keyframes pulse': { '0%,100%': { opacity: 1 }, '50%': { opacity: 0.3 } },
        }} />
        <Typography sx={{ fontSize: '0.65rem', color: '#EF4444', fontWeight: 700, letterSpacing: '0.04em' }}>LIVE</Typography>
      </Box>
    )}
    <Typography sx={{ flex: 1, fontSize: '0.78rem', color: 'rgba(255,255,255,0.8)', fontWeight: 500 }}>{home}</Typography>
    <Box sx={{ px: 1.25, py: 0.25, borderRadius: '6px', bgcolor: 'rgba(255,255,255,0.08)', minWidth: 44, textAlign: 'center' }}>
      <Typography sx={{ fontSize: '0.78rem', fontWeight: 700, color: P.white, letterSpacing: '0.05em' }}>{score}</Typography>
    </Box>
    <Typography sx={{ flex: 1, fontSize: '0.78rem', color: 'rgba(255,255,255,0.8)', fontWeight: 500, textAlign: 'right' }}>{away}</Typography>
    {!live && <Typography sx={{ fontSize: '0.7rem', color: 'rgba(255,255,255,0.3)', ml: 0.5 }}>{time}</Typography>}
  </Box>
);

const API = process.env.REACT_APP_API_URL || 'http://localhost:5000/api';

/* ══════════════════════════════════════════════════════════════════════════════*/
const Login = () => {
  const [formData, setFormData] = useState({ email: '', password: '' });
  const [errors, setErrors]     = useState({});
  const [showPwd, setShowPwd]   = useState(false);
  const [loading, setLoading]   = useState(false);
  const [recentMatches, setRecentMatches] = useState([]);

  const { login, error, clearError, isAuthenticated, user } = useAuth();
  const navigate = useNavigate();
  const location = useLocation();
  const from     = location.state?.from?.pathname || null;

  const getRoleHome = (role) => {
    if (role === 'admin')  return '/admin';
    if (role === 'coach')  return '/coach';
    if (role === 'joueur') return '/player';
    return '/login';
  };

  useEffect(() => {
    if (isAuthenticated) navigate(from || getRoleHome(user?.role), { replace: true });
  }, [isAuthenticated, navigate, from, user]); // eslint-disable-line

  useEffect(() => { clearError(); }, [clearError]);

  useEffect(() => {
    fetch(`${API}/matches/public/recent`)
      .then(r => r.ok ? r.json() : null)
      .then(d => { if (d?.matches) setRecentMatches(d.matches.slice(0, 3)); })
      .catch(() => {});
  }, []);

  const handleChange = (e) => {
    const { name, value } = e.target;
    setFormData(p => ({ ...p, [name]: value }));
    if (errors[name]) setErrors(p => ({ ...p, [name]: '' }));
  };

  const validate = () => {
    const e = {};
    if (!formData.email)                            e.email    = 'Email requis';
    else if (!/\S+@\S+\.\S+/.test(formData.email)) e.email    = 'Email invalide';
    if (!formData.password)                          e.password = 'Mot de passe requis';
    setErrors(e);
    return !Object.keys(e).length;
  };

  const handleSubmit = async (ev) => {
    ev.preventDefault();
    if (!validate()) return;
    setLoading(true);
    setTimeout(async () => {
      try {
        const res = await login(formData.email, formData.password);
        if (!res.success) setErrors({ submit: res.error });
      } catch { /* handled */ }
      finally { setLoading(false); }
    }, 1800);
  };

  const fieldSx = (err) => ({
    '& .MuiOutlinedInput-root': {
      height: 46, borderRadius: '10px',
      bgcolor: err ? '#FEF3F2' : P.offWhite,
      '& fieldset': { borderColor: err ? '#b91c1c' : P.border },
      '&:hover fieldset': { borderColor: err ? '#b91c1c' : '#9d978a' },
      '&.Mui-focused fieldset': {
        borderColor: err ? '#b91c1c' : P.blue,
        boxShadow: err ? '0 0 0 4px rgba(217,45,32,0.1)' : '0 0 0 4px rgba(255,90,31,0.18)',
        borderWidth: '1px',
      },
      '& input': { fontSize: '0.875rem', color: P.gray2 },
      '& input::placeholder': { color: P.gray3, opacity: 1 },
    },
  });

  return (
    <Box sx={{ display: 'flex', minHeight: '100vh', bgcolor: P.navy }}>

      {/* ══ PANNEAU GAUCHE ══════════════════════════════════════════════════════*/}
      <Box sx={{
        display: { xs: 'none', lg: 'flex' },
        flexDirection: 'column',
        width: '58%',
        position: 'relative',
        overflow: 'hidden',
        p: 5,
        background: P.navy,
      }}>

        {/* ── Brand ───────────────────────────────────────────────────────────*/}
        <Box sx={{ position: 'relative', zIndex: 1 }}>
          <Box sx={{ display: 'flex', alignItems: 'center', gap: 1.5, mb: 8 }}>
            <Box sx={{
              width: 44, height: 44, borderRadius: '12px', bgcolor: P.blue,
              display: 'flex', alignItems: 'center', justifyContent: 'center',
              boxShadow: '0 4px 20px rgba(255,90,31,0.45)',
            }}>
              <BallIcon sx={{ color: P.white, fontSize: 24 }} />
            </Box>
            <Box>
              <Typography sx={{ color: P.white, fontWeight: 800, fontSize: '1.05rem', lineHeight: 1.1 }}>
                Foot Amateur
              </Typography>
              <Typography sx={{ color: 'rgba(255,255,255,0.35)', fontSize: '0.7rem', letterSpacing: '0.04em' }}>
                PANNEAU D'ADMINISTRATION
              </Typography>
            </Box>
            <Chip label="v2.0" size="small" sx={{
              ml: 1, height: 20, fontSize: '0.65rem', fontWeight: 700,
              bgcolor: 'rgba(255,90,31,0.15)', color: P.blueLt,
              border: '1px solid rgba(255,90,31,0.3)',
            }} />
          </Box>

          {/* Headline */}
          <Typography sx={{
            color: P.white, fontWeight: 700, fontFamily: '"Barlow Condensed", sans-serif',
            fontSize: { lg: '2.9rem', xl: '3.4rem' },
            lineHeight: 1.2, mb: 1.5, maxWidth: 460,
          }}>
            Gérez votre ligue de football en toute{' '}
            <Box component="span" sx={{ color: '#ff5a1f' }}>
              simplicité
            </Box>
          </Typography>
          <Typography sx={{ color: 'rgba(255,255,255,0.45)', fontSize: '0.9rem', lineHeight: 1.7, maxWidth: 400, mb: 5 }}>
            Tournois, équipes, joueurs, matchs et statistiques — tout centralisé dans une seule plateforme moderne.
          </Typography>

          {/* Stats */}
          <Box sx={{
            display: 'flex', gap: 4, mb: 5,
            pb: 4, borderBottom: '1px solid rgba(255,255,255,0.06)',
          }}>
            <Stat value="12+"  label="Équipes actives"  color={P.blueLt} />
            <Stat value="180+" label="Joueurs inscrits"  color={P.accent} />
            <Stat value="64+"  label="Matchs joués"      color={P.gold} />
            <Stat value="8+"   label="Tournois"           color="#ff8a5c" />
          </Box>

          {/* Features */}
          <Box sx={{ display: 'flex', flexDirection: 'column', gap: 2.5, mb: 5 }}>
            <Feature
              icon={<TrophyIcon />}
              title="Gestion des tournois"
              desc="Créez et suivez des compétitions, gérez les brackets et les classements en temps réel."
            />
            <Feature
              icon={<GroupIcon />}
              title="Équipes & Joueurs"
              desc="Fiches complètes, statistiques détaillées par poste, historique et performances."
            />
            <Feature
              icon={<CalendarIcon />}
              title="Planification des matchs"
              desc="Calendrier interactif, résultats, événements de match et arbitrage."
            />
            <Feature
              icon={<ChartIcon />}
              title="Statistiques avancées"
              desc="Tableaux de bord analytiques, radars de performance et comparaisons."
            />
          </Box>

          {/* Mini matchs réels */}
          {recentMatches.length > 0 && (
            <Box sx={{
              p: 2, borderRadius: '14px',
              background: 'rgba(255,255,255,0.02)',
              border: '1px solid rgba(255,255,255,0.06)',
            }}>
              <Box sx={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', mb: 1.5 }}>
                <Typography sx={{ fontSize: '0.7rem', fontWeight: 700, color: 'rgba(255,255,255,0.3)', textTransform: 'uppercase', letterSpacing: '0.08em' }}>
                  Matchs récents
                </Typography>
                <Box sx={{ display: 'flex', alignItems: 'center', gap: 0.5 }}>
                  {recentMatches.some(m => m.status === 'in_progress') && (
                    <>
                      <Box sx={{ width: 5, height: 5, borderRadius: '50%', bgcolor: P.accent,
                        animation: 'pulse 1.5s ease-in-out infinite',
                        '@keyframes pulse': { '0%,100%': { opacity: 1 }, '50%': { opacity: 0.3 } },
                      }} />
                      <Typography sx={{ fontSize: '0.65rem', color: P.accent, fontWeight: 600 }}>EN DIRECT</Typography>
                    </>
                  )}
                </Box>
              </Box>
              <Box sx={{ display: 'flex', flexDirection: 'column', gap: 1 }}>
                {recentMatches.map(m => {
                  const isLive = m.status === 'in_progress';
                  const isDone = m.status === 'completed';
                  const score  = isDone || isLive
                    ? `${m.homeTeamScore ?? 0} - ${m.awayTeamScore ?? 0}`
                    : 'vs';
                  const time   = isDone ? 'Terminé'
                    : m.date ? new Date(m.date).toLocaleTimeString('fr-FR', { hour: '2-digit', minute: '2-digit' })
                    : '';
                  return (
                    <MatchCard
                      key={m.id}
                      home={m.homeTeam?.name || '—'}
                      away={m.awayTeam?.name || '—'}
                      score={score}
                      time={time}
                      live={isLive}
                    />
                  );
                })}
              </Box>
            </Box>
          )}
        </Box>

        {/* Footer gauche */}
        <Box sx={{ position: 'relative', zIndex: 1, mt: 4 }}>
          <Box sx={{ display: 'flex', alignItems: 'center', gap: 2 }}>
            {[
              'Résultats en direct',
              'Stats avancées',
              'Multi-tournois',
            ].map((t) => (
              <Box key={t} sx={{ display: 'flex', alignItems: 'center', gap: 0.6 }}>
                <CheckIcon sx={{ fontSize: 13, color: P.accent }} />
                <Typography sx={{ fontSize: '0.72rem', color: 'rgba(255,255,255,0.35)' }}>{t}</Typography>
              </Box>
            ))}
          </Box>
        </Box>
      </Box>

      {/* ══ PANNEAU DROIT (formulaire) ══════════════════════════════════════════*/}
      <Box sx={{
        flex: 1,
        display: 'flex',
        flexDirection: 'column',
        alignItems: 'center',
        justifyContent: 'center',
        bgcolor: P.white,
        px: { xs: 3, sm: 5, md: 7 },
        py: 6,
        position: 'relative',
      }}>

        {/* Logo mobile */}
        <Box sx={{ display: { xs: 'flex', lg: 'none' }, alignItems: 'center', gap: 1.5, mb: 5 }}>
          <Box sx={{ width: 38, height: 38, borderRadius: '10px', bgcolor: P.blue, display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
            <BallIcon sx={{ color: P.white, fontSize: 20 }} />
          </Box>
          <Typography sx={{ fontWeight: 800, color: P.navy, fontSize: '1rem' }}>Foot Amateur</Typography>
        </Box>

        <Box sx={{ width: '100%', maxWidth: 400 }}>

          {/* En-tête formulaire */}
          <Box sx={{ mb: 4 }}>
            <Typography sx={{ fontSize: '1.6rem', fontWeight: 800, color: P.navy, mb: 0.5, lineHeight: 1.25 }}>
              Bienvenue
            </Typography>
            <Typography sx={{ fontSize: '0.875rem', color: P.gray, lineHeight: 1.6 }}>
              Connectez-vous à votre espace administrateur pour gérer votre ligue.
            </Typography>
          </Box>

          {/* Badge rôle */}
          <Box sx={{
            display: 'inline-flex', alignItems: 'center', gap: 0.75,
            px: 1.5, py: 0.6, borderRadius: '8px', mb: 3.5,
            bgcolor: '#fdeee6', border: '1px solid #f6b89a',
          }}>
            <Box sx={{ width: 7, height: 7, borderRadius: '50%', bgcolor: P.blue }} />
            <Typography sx={{ fontSize: '0.75rem', fontWeight: 600, color: '#a3330a' }}>
              Accès Administrateur
            </Typography>
          </Box>

          {/* Erreur */}
          {(error || errors.submit) && (
            <Alert severity="error" sx={{ mb: 3, borderRadius: '10px', fontSize: '0.85rem' }}>
              {error || errors.submit}
            </Alert>
          )}

          {/* Formulaire */}
          <Box component="form" onSubmit={handleSubmit} noValidate>

            {/* Email */}
            <Box sx={{ mb: 2.5 }}>
              <Typography sx={{ fontSize: '0.875rem', fontWeight: 600, color: P.gray2, mb: 0.75 }}>
                Adresse email
              </Typography>
              <TextField fullWidth name="email" type="email"
                placeholder="vous@exemple.com"
                autoComplete="email" autoFocus
                value={formData.email} onChange={handleChange}
                error={!!errors.email} helperText={errors.email}
                InputProps={{ startAdornment: (
                  <InputAdornment position="start">
                    <EmailIcon sx={{ fontSize: 18, color: errors.email ? '#b91c1c' : P.gray3 }} />
                  </InputAdornment>
                )}}
                sx={fieldSx(!!errors.email)}
              />
            </Box>

            {/* Mot de passe */}
            <Box sx={{ mb: 4 }}>
              <Typography sx={{ fontSize: '0.875rem', fontWeight: 600, color: P.gray2, mb: 0.75 }}>
                Mot de passe
              </Typography>
              <TextField fullWidth name="password"
                type={showPwd ? 'text' : 'password'}
                placeholder="••••••••"
                autoComplete="current-password"
                value={formData.password} onChange={handleChange}
                error={!!errors.password} helperText={errors.password}
                InputProps={{
                  startAdornment: (
                    <InputAdornment position="start">
                      <LockIcon sx={{ fontSize: 18, color: errors.password ? '#b91c1c' : P.gray3 }} />
                    </InputAdornment>
                  ),
                  endAdornment: (
                    <InputAdornment position="end">
                      <IconButton size="small" onClick={() => setShowPwd(v => !v)} edge="end"
                        sx={{ color: P.gray3, '&:hover': { bgcolor: 'transparent', color: P.gray2 } }}>
                        {showPwd
                          ? <VisibilityOffIcon sx={{ fontSize: 18 }} />
                          : <VisibilityIcon   sx={{ fontSize: 18 }} />}
                      </IconButton>
                    </InputAdornment>
                  ),
                }}
                sx={fieldSx(!!errors.password)}
              />
            </Box>

            {/* Bouton */}
            <Button type="submit" fullWidth variant="contained"
              disabled={!formData.email || !formData.password || loading}
              endIcon={!loading && <ArrowIcon sx={{ fontSize: '18px !important' }} />}
              sx={{
                height: 50, borderRadius: '12px',
                fontSize: '0.925rem', fontWeight: 700, textTransform: 'none',
                bgcolor: P.blue, color: P.white,
                boxShadow: '0 4px 14px rgba(255,90,31,0.35)',
                '&:hover': {
                  bgcolor: '#a3330a',
                  boxShadow: '0 6px 20px rgba(255,90,31,0.45)',
                  transform: 'translateY(-1px)',
                },
                '&:active': { transform: 'translateY(0)' },
                '&.Mui-disabled': { bgcolor: '#ff8a5c', color: P.white, opacity: 1, boxShadow: 'none' },
                transition: 'all 0.18s ease',
              }}
            >
              {loading
                ? <Box sx={{ display: 'flex', alignItems: 'center', gap: 1.25 }}>
                    <CircularProgress size={16} sx={{ color: P.white }} />
                    <span>Connexion en cours…</span>
                  </Box>
                : 'Se connecter'
              }
            </Button>
          </Box>

          {/* Séparateur */}
          <Box sx={{ display: 'flex', alignItems: 'center', gap: 2, my: 3 }}>
            <Box sx={{ flex: 1, height: '1px', bgcolor: P.border }} />
            <Typography sx={{ fontSize: '0.75rem', color: P.gray3 }}>ou</Typography>
            <Box sx={{ flex: 1, height: '1px', bgcolor: P.border }} />
          </Box>

          {/* Bouton inscription */}
          <Button
            component={RouterLink}
            to="/register"
            fullWidth
            variant="outlined"
            color="inherit"
            sx={{
              height: 48, borderRadius: '12px',
              fontSize: '0.9rem', fontWeight: 600, textTransform: 'none',
              color: P.gray2, borderColor: P.border,
              bgcolor: P.offWhite,
              '&:hover': {
                bgcolor: '#ecebe4',
                borderColor: '#9d978a',
                boxShadow: 'none',
              },
              mb: 3,
            }}
          >
            Créer un compte
          </Button>

          {/* Badges de confiance */}
          <Box sx={{ display: 'flex', flexWrap: 'wrap', gap: 1, justifyContent: 'center' }}>
            {[
              { icon: null, label: 'SSL chiffré' },
              { icon: null, label: 'Temps réel' },
              { icon: null, label: 'Multi-plateforme' },
            ].map(b => (
              <Box key={b.label} sx={{
                display: 'flex', alignItems: 'center', gap: 0.6,
                px: 1.25, py: 0.6, borderRadius: '8px',
                bgcolor: P.offWhite, border: `1px solid ${P.border}`,
              }}>
                <Typography sx={{ fontSize: '0.72rem' }}>{b.icon}</Typography>
                <Typography sx={{ fontSize: '0.72rem', color: P.gray, fontWeight: 500 }}>{b.label}</Typography>
              </Box>
            ))}
          </Box>
        </Box>

        {/* Copyright */}
        <Typography sx={{
          position: 'absolute', bottom: 24,
          fontSize: '0.72rem', color: P.gray3,
        }}>
          © 2025 Foot Amateur · Tous droits réservés
        </Typography>
      </Box>

      {/* ══ Overlay chargement ══════════════════════════════════════════════════*/}
      {loading && (
        <Box sx={{
          position: 'fixed', inset: 0, zIndex: 9999,
          display: 'flex', alignItems: 'center', justifyContent: 'center',
          bgcolor: 'rgba(10,22,40,0.7)', backdropFilter: 'blur(6px)',
        }}>
          <Box sx={{
            bgcolor: P.white, borderRadius: '20px', p: '32px 40px',
            display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 2,
            boxShadow: '0 32px 64px rgba(0,0,0,0.35)',
          }}>
            <Box sx={{ width: 120, height: 120 }}>
              <Lottie animationData={animationData} loop />
            </Box>
            <Typography sx={{ fontWeight: 700, color: P.navy, fontSize: '0.95rem' }}>
              Vérification en cours…
            </Typography>
            <Typography sx={{ color: P.gray, fontSize: '0.8rem' }}>
              Connexion à votre espace admin
            </Typography>
          </Box>
        </Box>
      )}
    </Box>
  );
};

export default Login;
