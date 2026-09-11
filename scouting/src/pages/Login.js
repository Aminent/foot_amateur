import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import {
  Box, TextField, Button, Typography, Alert,
  CircularProgress, InputAdornment, IconButton,
} from '@mui/material';
import SportsSoccerIcon from '@mui/icons-material/SportsSoccer';
import Visibility        from '@mui/icons-material/Visibility';
import VisibilityOff     from '@mui/icons-material/VisibilityOff';
import EmailOutlinedIcon from '@mui/icons-material/EmailOutlined';
import LockOutlinedIcon  from '@mui/icons-material/LockOutlined';
import { useAuth } from '../contexts/AuthContext';

const TEAL      = '#0c9e96';
const TEAL_DARK = '#0a8880';

/* ── decorative blurred blobs ── */
const Blob = ({ sx }) => (
  <Box sx={{
    position: 'absolute', borderRadius: '50%',
    filter: 'blur(60px)', opacity: 0.55, pointerEvents: 'none',
    ...sx,
  }} />
);

export default function Login() {
  const { login }    = useAuth();
  const navigate     = useNavigate();
  const [form, setForm]       = useState({ email: '', password: '' });
  const [showPwd, setShowPwd] = useState(false);
  const [loading, setLoading] = useState(false);
  const [error, setError]     = useState('');
  const [focused, setFocused] = useState('');

  const submit = async (e) => {
    e.preventDefault();
    setLoading(true); setError('');
    try {
      await login(form.email, form.password);
      navigate('/');
    } catch (err) {
      setError(err.message || 'Identifiants incorrects');
    } finally {
      setLoading(false);
    }
  };

  const fieldSx = (name) => ({
    mb: 2.5,
    '& .MuiOutlinedInput-root': {
      borderRadius: '14px',
      background: 'rgba(255,255,255,0.70)',
      backdropFilter: 'blur(8px)',
      transition: 'box-shadow 0.2s, border-color 0.2s',
      '& fieldset': {
        borderColor: focused === name
          ? TEAL
          : 'rgba(255,255,255,0.80)',
        borderWidth: focused === name ? 2 : 1,
      },
      '&:hover fieldset': { borderColor: `rgba(12,158,150,0.50)` },
      '&.Mui-focused fieldset': { borderColor: TEAL, borderWidth: 2 },
      ...(focused === name && {
        boxShadow: `0 0 0 4px rgba(12,158,150,0.12)`,
      }),
    },
    '& .MuiInputLabel-root.Mui-focused': { color: TEAL },
    '& .MuiInputAdornment-root svg': {
      color: focused === name ? TEAL : '#9ab',
      transition: 'color 0.2s',
    },
  });

  return (
    <Box sx={{
      minHeight: '100vh',
      display: 'flex', alignItems: 'center', justifyContent: 'center',
      background: 'linear-gradient(135deg, #ceeae5 0%, #daf0f5 50%, #e2eef7 100%)',
      backgroundAttachment: 'fixed',
      p: 2,
      position: 'relative',
      overflow: 'hidden',
    }}>

      {/* decorative blobs */}
      <Blob sx={{ width: 420, height: 420, background: `radial-gradient(circle, rgba(12,158,150,0.30), transparent 70%)`, top: '-120px', left: '-100px' }} />
      <Blob sx={{ width: 320, height: 320, background: `radial-gradient(circle, rgba(14,165,233,0.25), transparent 70%)`, bottom: '-80px', right: '-60px' }} />
      <Blob sx={{ width: 200, height: 200, background: `radial-gradient(circle, rgba(167,243,208,0.45), transparent 70%)`, bottom: '20%', left: '10%' }} />

      {/* ── Card ── */}
      <Box sx={{
        position: 'relative', zIndex: 1,
        width: '100%', maxWidth: 440,
        borderRadius: '28px',
        background: 'rgba(255,255,255,0.62)',
        backdropFilter: 'blur(24px)',
        WebkitBackdropFilter: 'blur(24px)',
        border: '1px solid rgba(255,255,255,0.85)',
        boxShadow: '0 24px 64px rgba(12,158,150,0.18), 0 4px 16px rgba(0,0,0,0.06)',
        overflow: 'hidden',
      }}>

        {/* ── teal header strip ── */}
        <Box sx={{
          background: `linear-gradient(135deg, ${TEAL} 0%, ${TEAL_DARK} 100%)`,
          pt: 4.5, pb: 3.5,
          display: 'flex', flexDirection: 'column', alignItems: 'center',
          position: 'relative',
          overflow: 'hidden',
        }}>
          {/* subtle pattern overlay */}
          <Box sx={{
            position: 'absolute', inset: 0,
            backgroundImage: `radial-gradient(circle at 20% 30%, rgba(255,255,255,0.12) 0%, transparent 50%),
                              radial-gradient(circle at 80% 70%, rgba(0,0,0,0.08) 0%, transparent 50%)`,
          }} />

          {/* icon circle */}
          <Box sx={{
            width: 72, height: 72, borderRadius: '50%',
            background: 'rgba(255,255,255,0.20)',
            border: '2px solid rgba(255,255,255,0.40)',
            display: 'flex', alignItems: 'center', justifyContent: 'center',
            mb: 2, zIndex: 1,
            boxShadow: '0 8px 24px rgba(0,0,0,0.12)',
          }}>
            <SportsSoccerIcon sx={{ fontSize: 38, color: 'white' }} />
          </Box>

          <Typography sx={{
            color: 'white', fontWeight: 800, fontSize: '1.45rem',
            letterSpacing: '-0.02em', zIndex: 1,
          }}>
            Scout<span style={{ opacity: 0.75, fontWeight: 500 }}>Pro</span>
          </Typography>
          <Typography sx={{
            color: 'rgba(255,255,255,0.70)', fontSize: '0.82rem',
            fontWeight: 500, letterSpacing: '0.06em', textTransform: 'uppercase',
            zIndex: 1, mt: 0.5,
          }}>
            Plateforme de Scouting
          </Typography>
        </Box>

        {/* ── form body ── */}
        <Box sx={{ p: 4, pt: 3.5 }}>

          <Typography sx={{
            fontWeight: 700, fontSize: '1.05rem', color: 'text.primary',
            mb: 0.5,
          }}>
            Connexion
          </Typography>
          <Typography sx={{ fontSize: '0.82rem', color: '#7a8fa6', mb: 3 }}>
            Entrez vos identifiants pour accéder au tableau de bord
          </Typography>

          {error && (
            <Alert severity="error" sx={{
              mb: 2.5, borderRadius: '12px',
              background: 'rgba(239,68,68,0.10)',
              border: '1px solid rgba(239,68,68,0.25)',
              color: '#b91c1c',
              '& .MuiAlert-icon': { color: '#ef4444' },
            }}>
              {error}
            </Alert>
          )}

          <form onSubmit={submit}>
            <TextField
              fullWidth label="Adresse email" type="email"
              value={form.email}
              onChange={e => setForm(f => ({ ...f, email: e.target.value }))}
              onFocus={() => setFocused('email')}
              onBlur={() => setFocused('')}
              required
              sx={fieldSx('email')}
              InputProps={{
                startAdornment: (
                  <InputAdornment position="start">
                    <EmailOutlinedIcon fontSize="small" />
                  </InputAdornment>
                ),
              }}
            />

            <TextField
              fullWidth label="Mot de passe"
              type={showPwd ? 'text' : 'password'}
              value={form.password}
              onChange={e => setForm(f => ({ ...f, password: e.target.value }))}
              onFocus={() => setFocused('password')}
              onBlur={() => setFocused('')}
              required
              sx={{ ...fieldSx('password'), mb: 3.5 }}
              InputProps={{
                startAdornment: (
                  <InputAdornment position="start">
                    <LockOutlinedIcon fontSize="small" />
                  </InputAdornment>
                ),
                endAdornment: (
                  <InputAdornment position="end">
                    <IconButton onClick={() => setShowPwd(v => !v)} edge="end" size="small"
                      sx={{ color: '#9ab', '&:hover': { color: TEAL } }}>
                      {showPwd ? <VisibilityOff fontSize="small" /> : <Visibility fontSize="small" />}
                    </IconButton>
                  </InputAdornment>
                ),
              }}
            />

            <Button
              fullWidth variant="contained" type="submit"
              disabled={loading}
              sx={{
                py: 1.5,
                borderRadius: '14px',
                fontWeight: 700, fontSize: '0.95rem',
                background: `linear-gradient(135deg, ${TEAL} 0%, ${TEAL_DARK} 100%)`,
                boxShadow: `0 6px 20px rgba(12,158,150,0.40)`,
                letterSpacing: '0.02em',
                transition: 'all 0.2s',
                '&:hover': {
                  background: `linear-gradient(135deg, ${TEAL_DARK} 0%, #087a72 100%)`,
                  boxShadow: `0 8px 28px rgba(12,158,150,0.50)`,
                  transform: 'translateY(-1px)',
                },
                '&:active': { transform: 'translateY(0)' },
                '&.Mui-disabled': { background: 'rgba(12,158,150,0.30)', boxShadow: 'none' },
              }}>
              {loading
                ? <CircularProgress size={22} sx={{ color: 'white' }} />
                : 'Se connecter →'}
            </Button>
          </form>

          {/* footer note */}
          <Box sx={{
            mt: 3, pt: 2.5,
            borderTop: '1px solid rgba(12,158,150,0.12)',
            display: 'flex', alignItems: 'center', justifyContent: 'center', gap: 1,
          }}>
            <Box sx={{
              width: 6, height: 6, borderRadius: '50%',
              background: TEAL, boxShadow: `0 0 6px ${TEAL}`,
            }} />
            <Typography sx={{ fontSize: '0.75rem', color: '#7a8fa6', fontWeight: 500 }}>
              Accès réservé aux scouts autorisés
            </Typography>
          </Box>
        </Box>
      </Box>
    </Box>
  );
}
