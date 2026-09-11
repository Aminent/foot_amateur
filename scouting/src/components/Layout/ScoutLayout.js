import React, { useState } from 'react';
import { Outlet, useNavigate, useLocation } from 'react-router-dom';
import {
  Box, Typography, Avatar, Tooltip, IconButton, Divider,
} from '@mui/material';
import { ThemeProvider, CssBaseline } from '@mui/material';
import DashboardIcon      from '@mui/icons-material/Dashboard';
import SearchIcon         from '@mui/icons-material/Search';
import BookmarkIcon       from '@mui/icons-material/Bookmark';
import AssessmentIcon     from '@mui/icons-material/Assessment';
import CompareIcon        from '@mui/icons-material/CompareArrows';
import SportsSoccerIcon   from '@mui/icons-material/SportsSoccer';
import LogoutIcon         from '@mui/icons-material/Logout';
import MenuIcon           from '@mui/icons-material/Menu';
import ChevronLeftIcon    from '@mui/icons-material/ChevronLeft';
import ChevronRightIcon   from '@mui/icons-material/ChevronRight';
import DarkModeIcon       from '@mui/icons-material/DarkModeOutlined';
import LightModeIcon      from '@mui/icons-material/LightModeOutlined';
import { useAuth } from '../../contexts/AuthContext';
import { lightTheme, darkTheme } from '../../utils/theme';

const DRAWER_W   = 250;
const COLLAPSED  = 52;
const TEAL       = '#0c9e96';
const TEAL_DARK  = '#0a8880';
const TEAL_LIGHT = 'rgba(12,158,150,0.10)';

const PageTransition = ({ children }) => {
  const loc = useLocation();
  return (
    <Box key={loc.pathname} sx={{
      animation: 'pageEnter 0.28s cubic-bezier(0.22, 1, 0.36, 1) both',
      '@keyframes pageEnter': {
        from: { opacity: 0, transform: 'translateY(14px)' },
        to:   { opacity: 1, transform: 'translateY(0)' },
      },
    }}>
      {children}
    </Box>
  );
};

const NAV = [
  { label: 'Dashboard',   path: '/',            icon: <DashboardIcon /> },
  { label: 'Joueurs',     path: '/players',      icon: <SearchIcon /> },
  { label: 'Watchlist',   path: '/watchlist',    icon: <BookmarkIcon /> },
  { label: 'Évaluations', path: '/evaluations',  icon: <AssessmentIcon /> },
  { label: 'Comparateur', path: '/compare',      icon: <CompareIcon /> },
  { label: 'Matchs live', path: '/live',         icon: <SportsSoccerIcon /> },
];

const NavItem = ({ label, path, icon, active, collapsed, onClick }) => {
  const btn = (
    <Box
      role="button"
      tabIndex={0}
      onClick={onClick}
      onKeyDown={(e) => (e.key === 'Enter' || e.key === ' ') && onClick()}
      sx={{
        display: 'flex', alignItems: 'center', gap: 1.5,
        height: 44,
        px: collapsed ? 0 : 1.5,
        mx: collapsed ? 0 : 1,
        borderRadius: '12px',
        cursor: 'pointer', userSelect: 'none', outline: 'none',
        justifyContent: collapsed ? 'center' : 'flex-start',
        background: active
          ? `linear-gradient(135deg, ${TEAL} 0%, ${TEAL_DARK} 100%)`
          : 'transparent',
        boxShadow: active ? `0 6px 20px rgba(12,158,150,0.40)` : 'none',
        transition: 'all 0.2s ease',
        '&:hover': {
          background: active
            ? `linear-gradient(135deg, ${TEAL_DARK} 0%, #087a72 100%)`
            : TEAL_LIGHT,
        },
        overflow: 'hidden',
        width: collapsed ? '100%' : 'auto',
      }}
    >
      {/* Icon in colored circle */}
      <Box sx={{
        width: 32, height: 32, borderRadius: '10px', flexShrink: 0,
        display: 'flex', alignItems: 'center', justifyContent: 'center',
        bgcolor: active ? 'rgba(255,255,255,0.20)' : 'rgba(255,255,255,0.08)',
        transition: 'background 0.2s',
        '& svg': { fontSize: 17, color: active ? '#fff' : 'rgba(255,255,255,0.55)' },
      }}>
        {icon}
      </Box>

      {/* Label */}
      <Typography noWrap sx={{
        fontSize: '0.875rem',
        fontWeight: active ? 700 : 500,
        color: active ? '#ffffff' : 'rgba(255,255,255,0.70)',
        opacity: collapsed ? 0 : 1,
        width:   collapsed ? 0  : 'auto',
        transition: 'opacity 0.2s ease, width 0.2s ease',
        overflow: 'hidden', whiteSpace: 'nowrap', flexShrink: 0,
      }}>
        {label}
      </Typography>
    </Box>
  );

  return collapsed ? (
    <Tooltip title={label} placement="right" arrow>{btn}</Tooltip>
  ) : btn;
};

export default function ScoutLayout() {
  const { user, logout } = useAuth();
  const navigate  = useNavigate();
  const location  = useLocation();
  const [collapsed, setCollapsed] = useState(false);
  const [darkMode, setDarkMode]   = useState(() => localStorage.getItem('scout_dark_mode') === 'true');

  const toggleDark = () => {
    setDarkMode(d => {
      const next = !d;
      localStorage.setItem('scout_dark_mode', String(next));
      return next;
    });
  };

  const sidebarWidth = collapsed ? COLLAPSED : DRAWER_W;

  const sidebarContent = (
    <Box sx={{ display: 'flex', flexDirection: 'column', flex: 1, minHeight: 0 }}>

      {/* ── Header ─────────────────────────────────────────────────────── */}
      <Box sx={{
        display: 'flex', alignItems: 'center',
        justifyContent: collapsed ? 'center' : 'space-between',
        px: collapsed ? 0 : 2.5, py: 2.5, minHeight: 72, flexShrink: 0,
        transition: 'padding 0.2s ease',
      }}>
        <Box sx={{ display: 'flex', alignItems: 'center', gap: 1.25, overflow: 'hidden', minWidth: 0 }}>
          <Box sx={{
            width: 34, height: 34, borderRadius: '10px', flexShrink: 0,
            background: `linear-gradient(135deg, ${TEAL} 0%, ${TEAL_DARK} 100%)`,
            display: 'flex', alignItems: 'center', justifyContent: 'center',
            boxShadow: `0 4px 12px ${TEAL_LIGHT}`,
          }}>
            <SportsSoccerIcon sx={{ color: '#fff', fontSize: 18 }} />
          </Box>
          <Box sx={{
            opacity: collapsed ? 0 : 1, width: collapsed ? 0 : 'auto',
            transition: 'opacity 0.2s, width 0.2s', overflow: 'hidden', flexShrink: 0,
          }}>
            <Typography sx={{ color: '#ffffff', fontWeight: 800, fontSize: '1rem', lineHeight: 1.2, whiteSpace: 'nowrap' }}>
              Foot<span style={{ color: TEAL }}>Pro</span>
            </Typography>
            <Typography sx={{ color: 'rgba(255,255,255,0.40)', fontSize: '0.7rem', mt: 0.1, whiteSpace: 'nowrap' }}>
              Espace Scouting
            </Typography>
          </Box>
        </Box>

        {!collapsed && (
          <Tooltip title="Réduire">
            <IconButton size="small" onClick={() => setCollapsed(true)}
              sx={{ color: '#7a8fa6', '&:hover': { color: '#1a2d3d', bgcolor: TEAL_LIGHT } }}>
              <ChevronLeftIcon sx={{ fontSize: 18 }} />
            </IconButton>
          </Tooltip>
        )}
      </Box>

      {/* ── Nav items ──────────────────────────────────────────────────── */}
      <Box sx={{ flex: 1, minHeight: 0, overflowY: 'auto', overflowX: 'hidden', py: 1.5, '&::-webkit-scrollbar': { width: 0 } }}>
        {NAV.map(({ label, path, icon, color }) => {
          const active = location.pathname === path || (path !== '/' && location.pathname.startsWith(path));
          return (
            <Box key={path} sx={{ mb: 0.5 }}>
              <NavItem
                label={label} path={path} icon={icon}
                active={active} collapsed={collapsed}
                onClick={() => navigate(path)}
              />
            </Box>
          );
        })}
      </Box>

      {/* ── Footer ─────────────────────────────────────────────────────── */}
      <Box sx={{ flexShrink: 0, borderTop: '1px solid rgba(255,255,255,0.06)' }}>
        {/* Dark mode toggle */}
        <Box sx={{
          px: 2, py: 1, display: 'flex', alignItems: 'center',
          justifyContent: collapsed ? 'center' : 'space-between',
          borderBottom: '1px solid rgba(255,255,255,0.06)',
        }}>
          {!collapsed && (
            <Typography sx={{ color: 'rgba(255,255,255,0.55)', fontSize: '0.75rem', fontWeight: 500 }}>
              {darkMode ? 'Mode sombre' : 'Mode clair'}
            </Typography>
          )}
          <Tooltip title={darkMode ? 'Mode clair' : 'Mode sombre'} placement="right">
            <IconButton size="small" onClick={toggleDark} sx={{ color: TEAL }}>
              {darkMode ? <LightModeIcon fontSize="small" /> : <DarkModeIcon fontSize="small" />}
            </IconButton>
          </Tooltip>
        </Box>

        {/* User + logout */}
        <Box sx={{ px: collapsed ? 0 : 2, py: 1.5, display: 'flex', alignItems: 'center', gap: 1.5, justifyContent: collapsed ? 'center' : 'flex-start' }}>
          {!collapsed && (
            <Avatar sx={{ width: 34, height: 34, flexShrink: 0, bgcolor: TEAL, fontSize: '0.8rem', fontWeight: 700, color: '#fff' }}>
              {user?.name?.[0]?.toUpperCase() || 'S'}
            </Avatar>
          )}
          {!collapsed && (
            <Box sx={{ flex: 1, minWidth: 0 }}>
              <Typography noWrap sx={{ color: '#ffffff', fontWeight: 600, fontSize: '0.82rem' }}>
                {user?.name || 'Scout'}
              </Typography>
              <Typography noWrap sx={{ color: 'rgba(255,255,255,0.45)', fontSize: '0.7rem' }}>
                {user?.role || 'scout'}
              </Typography>
            </Box>
          )}
          <Tooltip title="Déconnexion" placement="right">
            <IconButton size="small" onClick={logout} sx={{ color: 'rgba(255,255,255,0.55)', '&:hover': { color: '#ef4444' } }}>
              <LogoutIcon fontSize="small" />
            </IconButton>
          </Tooltip>
        </Box>
      </Box>

    </Box>
  );

  return (
    <ThemeProvider theme={darkMode ? darkTheme : lightTheme}>
    <CssBaseline />
    <Box sx={{
      display: 'flex', minHeight: '100vh',
      bgcolor: 'background.default',
    }}>

      {/* ── Sidebar ──────────────────────────────────────────────────────────── */}
      <Box sx={{
        width: sidebarWidth, flexShrink: 0,
        background: '#092A43',
        display: 'flex', flexDirection: 'column',
        position: 'fixed', top: 0, left: 0, height: '100vh',
        zIndex: 1200,
        borderRight: '1px solid rgba(255,255,255,0.06)',
        boxShadow: '4px 0 24px rgba(0,0,0,0.12)',
        transition: 'width 0.2s cubic-bezier(0.4,0,0.2,1)',
        overflow: 'hidden',
      }}>
        {sidebarContent}
      </Box>

      {/* ── Floating expand button when collapsed ────────────────────────────── */}
      {collapsed && (
        <Box onClick={() => setCollapsed(false)} sx={{
          position: 'fixed', top: 14, left: COLLAPSED + 8, zIndex: 1201,
          display: 'flex', alignItems: 'center', justifyContent: 'center',
          width: 28, height: 28, borderRadius: '6px',
          bgcolor: '#ffffff', border: '1px solid rgba(12,158,150,0.20)',
          cursor: 'pointer', color: TEAL,
          boxShadow: '0 2px 12px rgba(12,158,150,0.15)',
          '&:hover': { bgcolor: TEAL_LIGHT },
          '& svg': { fontSize: 15 },
        }}>
          <ChevronRightIcon />
        </Box>
      )}

      {/* ── Main content ─────────────────────────────────────────────────────── */}
      <Box sx={{
        flex: 1, ml: `${sidebarWidth}px`,
        minHeight: '100vh', display: 'flex', flexDirection: 'column',
        bgcolor: 'background.default',
        transition: 'margin-left 0.2s cubic-bezier(0.4,0,0.2,1)',
      }}>
        <Box sx={{ flex: 1, p: 3, width: '100%' }}>
          <PageTransition>
            <Outlet />
          </PageTransition>
        </Box>
      </Box>
    </Box>
    </ThemeProvider>
  );
}
