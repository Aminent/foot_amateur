import React, { useState, useEffect, useCallback, useRef } from 'react';
import { Outlet, useNavigate, useLocation } from 'react-router-dom';
import {
  Box, Typography, Avatar, Tooltip, Divider,
  Badge, IconButton, Popover, List, ListItem,
  ListItemText, Snackbar, Alert, Chip,
} from '@mui/material';
import { useTheme } from '@mui/material/styles';
import {
  EmojiEvents as TrophyIcon,
  Group as GroupIcon,
  Person as PersonIcon,
  Sports as SportsIcon,
  BarChart as BarChartIcon,
  CalendarMonth as CalendarMonthIcon,
  SportsSoccer as SportsSoccerIcon,
  Logout as LogoutIcon,
  AssignmentTurnedIn as ApplicationsIcon,
  RecordVoiceOver as RefereeIcon,
  EditNote as DelegateIcon,
  ChevronLeft as ChevronLeftIcon,
  ChevronRight as ChevronRightIcon,
  DarkModeOutlined as DarkModeIcon,
  LightModeOutlined as LightModeIcon,
  NotificationsOutlined as BellIcon,
  FiberManualRecord as DotIcon,
  WarningAmberRounded as WarningIcon,
} from '@mui/icons-material';
import { io as socketIO } from 'socket.io-client';
import { useAuth } from '../../contexts/AuthContext';
import { useColorMode } from '../../contexts/ColorModeContext';

// ─── Layout constants ────────────────────────────────────────────────────────
const EXPANDED  = 260;
const COLLAPSED = 52;        // icon-only width (matches shadcn)

// ─── Design tokens — CoachPro light theme ───────────────────────────────────
const TEAL       = '#0c9e96';
const TEAL_DARK  = '#0a8880';
const TEAL_LIGHT = 'rgba(12,158,150,0.10)';

const C = {
  bg:         '#092A43',
  border:     'rgba(255,255,255,0.06)',
  text:       'rgba(255,255,255,0.55)',
  textStrong: '#ffffff',
  accent:     'rgba(12,158,150,0.12)',
  activeBg:   '#0c9e96',
  activeText: '#ffffff',
  label:      'rgba(255,255,255,0.30)',
  ring:       'rgba(12,158,150,0.30)',
  teal:       TEAL,
  tealDark:   TEAL_DARK,
  tealLight:  TEAL_LIGHT,
};

// ─── Route helpers ───────────────────────────────────────────────────────────
const sectionFromPath = (pathname) => {
  if (/\/admin\/tournaments\//.test(pathname)) return 0;
  if (/\/admin\/teams\//.test(pathname))       return 1;
  if (/\/admin\/players\//.test(pathname))     return 2;
  return null;
};

// ─── Nav definition ──────────────────────────────────────────────────────────
// Icon color system: inactive = rgba(0,0,0,0.40), active = TEAL (#0c9e96)
// Each item carries a single `color` key; NavItem renders active/inactive state.
const NAV_ITEMS = [
  { id: 0, label: 'Tournois',      icon: <TrophyIcon />       },
  { id: 1, label: 'Équipes',       icon: <GroupIcon />        },
  { id: 2, label: 'Joueurs',       icon: <PersonIcon />       },
  { id: 3, label: 'Coaches',       icon: <SportsIcon />       },
  { id: 4, label: 'Statistiques',  icon: <BarChartIcon />     },
  { id: 5, label: 'Calendrier',    icon: <CalendarMonthIcon />},
  { id: 6, label: 'Matchs',        icon: <SportsSoccerIcon />  },
  { id: 7, label: 'Candidatures',  icon: <ApplicationsIcon /> },
  { id: 8, label: 'Arbitres',      icon: <RefereeIcon />      },
  { id: 9, label: 'Délégués',      icon: <DelegateIcon />     },
];

// ─── NavItem ─────────────────────────────────────────────────────────────────
const NavItem = ({ item, active, collapsed, onClick }) => {
  const btn = (
    <Box
      role="button"
      tabIndex={0}
      onClick={onClick}
      onKeyDown={(e) => (e.key === 'Enter' || e.key === ' ') && onClick()}
      sx={{
        display: 'flex',
        alignItems: 'center',
        gap: 1.5,
        height: 44,
        px: collapsed ? 0 : 1.5,
        mx: collapsed ? 0 : 1,
        borderRadius: '12px',
        cursor: 'pointer',
        userSelect: 'none',
        outline: 'none',
        transition: 'all 0.2s ease',
        justifyContent: collapsed ? 'center' : 'flex-start',
        background:  active
          ? `linear-gradient(135deg, ${C.teal} 0%, ${C.tealDark} 100%)`
          : 'transparent',
        boxShadow: active ? `0 6px 20px rgba(12,158,150,0.40)` : 'none',
        '&:hover': {
          background: active
            ? `linear-gradient(135deg, ${C.tealDark} 0%, #087a72 100%)`
            : 'rgba(12,158,150,0.08)',
        },
        overflow: 'hidden',
        width: collapsed ? '100%' : 'auto',
      }}
    >
      {/* Icon — white when active, muted (#7a8fa6) when inactive */}
      <Box sx={{
        width: 32, height: 32, borderRadius: '10px', flexShrink: 0,
        display: 'flex', alignItems: 'center', justifyContent: 'center',
        bgcolor: active ? 'rgba(255,255,255,0.20)' : 'rgba(12,158,150,0.06)',
        transition: 'background 0.2s',
        '& svg': { fontSize: 17, color: active ? '#fff' : C.text },
      }}>
        {item.icon}
      </Box>

      {/* Label */}
      <Typography noWrap sx={{
        fontSize: '0.875rem',
        fontWeight: active ? 700 : 500,
        color: active ? '#ffffff' : C.textStrong,
        opacity: collapsed ? 0 : 1,
        width:   collapsed ? 0  : 'auto',
        transition: 'opacity 0.2s ease, width 0.2s ease',
        overflow: 'hidden',
        whiteSpace: 'nowrap',
        flexShrink: 0,
      }}>
        {item.label}
      </Typography>
    </Box>
  );

  return collapsed ? (
    <Tooltip title={item.label} placement="right" arrow>
      {btn}
    </Tooltip>
  ) : btn;
};

// ─── SidebarRail ──────────────────────────────────────────────────────────────
// The thin drag/click strip on the right edge — same as shadcn <SidebarRail>.
const SidebarRail = ({ onClick }) => (
  <Box
    onClick={onClick}
    aria-hidden
    sx={{
      position: 'absolute',
      top: 0, right: -3, bottom: 0,
      width: 6,
      cursor: 'col-resize',
      zIndex: 10,
      // Show a thin indicator line on hover
      '&:hover::after': {
        content: '""',
        position: 'absolute',
        top: 0, bottom: 0,
        left: '50%',
        width: 2,
        transform: 'translateX(-50%)',
        bgcolor: C.navy,
        borderRadius: 1,
        opacity: 0.25,
      },
    }}
  />
);

// ─── PageTransition ───────────────────────────────────────────────────────────
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

// ─── AdminLayout ──────────────────────────────────────────────────────────────
const AdminLayout = () => {
  const navigate  = useNavigate();
  const location  = useLocation();
  const { user, logout } = useAuth();
  const { mode, toggleColorMode } = useColorMode();
  const muiTheme = useTheme();

  const [collapsed, setCollapsed] = useState(false);

  // ── Notifications state ──────────────────────────────────────────────────
  const [notifications, setNotifications] = useState([]);
  const [unread, setUnread]               = useState(0);
  const [bellAnchor, setBellAnchor]       = useState(null);
  const [toast, setToast]                 = useState(null);       // match-starting-soon
  const [overdueToast, setOverdueToast]   = useState(null);       // matches-overdue (liste)
  const socketRef = useRef(null);

  useEffect(() => {
    const token = localStorage.getItem('token');
    if (!token) return;

    const wsBase = process.env.REACT_APP_API_URL
      ? process.env.REACT_APP_API_URL.replace('/api', '')
      : window.location.origin;
    const socket = socketIO(wsBase, {
      auth: { token },
      transports: ['websocket'],
    });
    socketRef.current = socket;

    socket.on('match-starting-soon', (data) => {
      const notif = { ...data, id: Date.now(), read: false, kind: 'soon' };
      setNotifications(prev => [notif, ...prev].slice(0, 20));
      setUnread(u => u + 1);
      setToast(notif);
    });

    // ── #6 : Match nul en tournoi sans vainqueur désigné ────────────────────
    socket.on('match-draw-no-advance', (data) => {
      const notif = {
        ...data, id: Date.now(), read: false, kind: 'draw',
        homeTeam: `Équipe #${data.homeTeam}`, awayTeam: `Équipe #${data.awayTeam}`,
      };
      setNotifications(prev => [notif, ...prev].slice(0, 20));
      setUnread(u => u + 1);
    });

    // ── Matchs périmés : scheduled mais date > 2h passée ─────────────────────
    socket.on('matches-overdue', (list) => {
      const notifs = list.map((m, i) => ({
        ...m, id: Date.now() + i, read: false, kind: 'overdue',
      }));
      setNotifications(prev => [...notifs, ...prev].slice(0, 20));
      setUnread(u => u + notifs.length);
      setOverdueToast(list); // affiche un seul toast groupé
    });

    return () => { socket.disconnect(); };
  }, []);

  const handleBellOpen  = (e) => { setBellAnchor(e.currentTarget); setUnread(0); setNotifications(prev => prev.map(n => ({ ...n, read: true }))); };
  const handleBellClose = ()  => setBellAnchor(null);

  // Ctrl+B / Cmd+B shortcut — matches shadcn default
  const toggle = useCallback(() => setCollapsed(c => !c), []);
  useEffect(() => {
    const handler = (e) => {
      if ((e.ctrlKey || e.metaKey) && e.key === 'b') {
        e.preventDefault();
        toggle();
      }
    };
    window.addEventListener('keydown', handler);
    return () => window.removeEventListener('keydown', handler);
  }, [toggle]);

  const pathSection   = sectionFromPath(location.pathname);
  const urlSection    = parseInt(new URLSearchParams(location.search).get('s') || '0');
  const activeSection = pathSection !== null ? pathSection : urlSection;

  const handleNavClick = (id) =>
    navigate(`/admin?s=${id}`, { replace: location.pathname === '/admin' });

  const handleLogout = () => { logout(); navigate('/login'); };

  const sidebarWidth = collapsed ? COLLAPSED : EXPANDED;

  return (
    <Box sx={{
      display: 'flex', minHeight: '100vh',
      bgcolor: 'background.default',
    }}>

      {/* ── Sidebar ─────────────────────────────────────────────────────────── */}
      <Box
        sx={{
          width:      sidebarWidth,
          flexShrink: 0,
          background: '#092A43',
          display:    'flex',
          flexDirection: 'column',
          position:   'fixed',
          top: 0, left: 0,
          height:     '100vh',
          zIndex:     1200,
          borderRight: '1px solid rgba(255,255,255,0.06)',
          boxShadow: '4px 0 24px rgba(0,0,0,0.12)',
          transition: 'width 0.2s cubic-bezier(0.4,0,0.2,1)',
          overflow: 'hidden',
        }}
      >
        {/* Inner wrapper — flex:1 fills the height inside the outer flex column */}
        <Box sx={{ display: 'flex', flexDirection: 'column', flex: 1, minHeight: 0 }}>

        {/* ── SidebarHeader ────────────────────────────────────────────────── */}
        <Box
          sx={{
            display:    'flex',
            alignItems: 'center',
            justifyContent: collapsed ? 'center' : 'space-between',
            px:  collapsed ? 0 : 2.5,
            py:  2.5,
            minHeight: 72,
            flexShrink: 0,
            transition: 'padding 0.2s ease',
          }}
        >
          {/* Brand logo — always shows icon; label fades when collapsed */}
          <Box sx={{ display: 'flex', alignItems: 'center', gap: 1.25, overflow: 'hidden', minWidth: 0 }}>
            <Box
              sx={{
                width: 34, height: 34,
                borderRadius: '10px',
                background: `linear-gradient(135deg, ${C.teal} 0%, ${C.tealDark} 100%)`,
                display: 'flex', alignItems: 'center', justifyContent: 'center',
                flexShrink: 0,
                boxShadow: `0 4px 12px ${C.tealLight}`,
              }}
            >
              <SportsSoccerIcon sx={{ color: '#fff', fontSize: 18 }} />
            </Box>
            <Box
              sx={{
                opacity:    collapsed ? 0 : 1,
                width:      collapsed ? 0 : 'auto',
                transition: 'opacity 0.2s ease, width 0.2s ease',
                overflow:   'hidden',
                flexShrink: 0,
              }}
            >
              <Typography sx={{ color: C.textStrong, fontWeight: 800, fontSize: '1rem', lineHeight: 1.2, whiteSpace: 'nowrap' }}>
                Foot<span style={{ color: C.teal }}>Pro</span>
              </Typography>
              <Typography sx={{ color: C.label, fontSize: '0.7rem', mt: 0.1, whiteSpace: 'nowrap' }}>
                Panneau Admin
              </Typography>
            </Box>
          </Box>

          {/* Notification bell + collapse toggle */}
          {!collapsed && (
            <Box sx={{ display: 'flex', alignItems: 'center', gap: 0.5 }}>
              <Tooltip title="Notifications matchs">
                <IconButton size="small" onClick={handleBellOpen} sx={{ color: C.text, '&:hover': { color: C.textStrong, bgcolor: C.accent } }}>
                  <Badge badgeContent={unread} color="error" max={9}>
                    <BellIcon sx={{ fontSize: 18 }} />
                  </Badge>
                </IconButton>
              </Tooltip>
              <Tooltip title="Réduire (Ctrl+B)">
                <IconButton size="small" onClick={toggle} sx={{ color: C.text, '&:hover': { color: C.textStrong, bgcolor: C.accent } }}>
                  <ChevronLeftIcon sx={{ fontSize: 18 }} />
                </IconButton>
              </Tooltip>
            </Box>
          )}
        </Box>

        {/* ── SidebarContent ───────────────────────────────────────────────── */}
        <Box
          sx={{
            flex: 1,
            minHeight: 0,
            overflowY: 'auto',
            overflowX: 'hidden',
            py: 1.5,
            '&::-webkit-scrollbar': { width: 0 },
          }}
        >
          {NAV_ITEMS.map(item => (
            <Box key={item.id} sx={{ mb: 0.5 }}>
              <NavItem
                item={item}
                active={activeSection === item.id}
                collapsed={collapsed}
                onClick={() => handleNavClick(item.id)}
              />
            </Box>
          ))}
        </Box>

        {/* ── SidebarFooter ── même pattern que ScoutLayout ────────────────── */}
        <Box sx={{ flexShrink: 0, borderTop: '1px solid rgba(255,255,255,0.06)' }}>

          {/* Dark mode toggle */}
          <Box sx={{ px: 2, py: 1, display: 'flex', alignItems: 'center', justifyContent: collapsed ? 'center' : 'space-between', borderBottom: '1px solid rgba(255,255,255,0.06)' }}>
            {!collapsed && (
              <Typography sx={{ color: C.text, fontSize: '0.75rem', fontWeight: 500 }}>
                {mode === 'dark' ? 'Mode sombre' : 'Mode clair'}
              </Typography>
            )}
            <Tooltip title={mode === 'dark' ? 'Mode clair' : 'Mode sombre'} placement="right">
              <IconButton size="small" onClick={toggleColorMode} sx={{ color: C.teal }}>
                {mode === 'dark' ? <LightModeIcon fontSize="small" /> : <DarkModeIcon fontSize="small" />}
              </IconButton>
            </Tooltip>
          </Box>

          {/* User + logout */}
          <Box sx={{ px: 2, py: 1.5, display: 'flex', alignItems: 'center', gap: 1.5 }}>
            <Avatar sx={{ width: 34, height: 34, flexShrink: 0, bgcolor: C.teal, fontSize: '0.8rem', fontWeight: 700, color: '#fff' }}>
              {user?.name ? user.name.slice(0, 2).toUpperCase() : 'AD'}
            </Avatar>
            {!collapsed && (
              <Box sx={{ flex: 1, minWidth: 0 }}>
                <Typography noWrap sx={{ color: C.textStrong, fontWeight: 600, fontSize: '0.82rem' }}>
                  {user?.name || 'Administrateur'}
                </Typography>
                <Typography noWrap sx={{ color: C.text, fontSize: '0.7rem' }}>
                  {user?.role || 'admin'}
                </Typography>
              </Box>
            )}
            {!collapsed && (
              <Tooltip title="Se déconnecter">
                <IconButton size="small" onClick={handleLogout} sx={{ color: C.text, '&:hover': { color: '#ef4444' } }}>
                  <LogoutIcon fontSize="small" />
                </IconButton>
              </Tooltip>
            )}
          </Box>

        </Box>

        </Box>{/* end inner wrapper */}

        {/* ── SidebarRail — thin click strip on the right edge ─────────────── */}
        <SidebarRail onClick={toggle} />
      </Box>

      {/* ── Floating re-open trigger when collapsed ──────────────────────── */}
      {collapsed && (
        <Box
          onClick={toggle}
          sx={{
            position: 'fixed',
            top: 14,
            left: COLLAPSED + 8,
            zIndex: 1201,
            display: 'flex', alignItems: 'center', justifyContent: 'center',
            width: 28, height: 28,
            borderRadius: '6px',
            bgcolor: '#ffffff',
            border: `1px solid ${C.border}`,
            cursor: 'pointer',
            color: C.teal,
            boxShadow: '0 2px 12px rgba(12,158,150,0.15)',
            transition: 'background 0.15s, color 0.15s',
            '&:hover': { bgcolor: C.tealLight, color: C.tealDark },
            '& svg': { fontSize: 15 },
          }}
        >
          <ChevronRightIcon />
        </Box>
      )}

      {/* ── Page content ────────────────────────────────────────────────────── */}
      <Box
        component="main"
        sx={{
          flex:       1,
          ml:         `${sidebarWidth}px`,
          minHeight:  '100vh',
          display:    'flex',
          flexDirection: 'column',
          bgcolor:    'background.default',
          transition: 'margin-left 0.2s cubic-bezier(0.4,0,0.2,1)',
        }}
      >
        <PageTransition>
          <Outlet />
        </PageTransition>
      </Box>

      {/* ── Notifications popover ─────────────────────────────────────────── */}
      <Popover
        open={Boolean(bellAnchor)}
        anchorEl={bellAnchor}
        onClose={handleBellClose}
        anchorOrigin={{ vertical: 'bottom', horizontal: 'right' }}
        transformOrigin={{ vertical: 'top', horizontal: 'right' }}
        PaperProps={{
          sx: {
            width: 320, mt: 1, borderRadius: 3,
            bgcolor: '#ffffff', border: `1px solid ${C.border}`,
            boxShadow: '0 8px 32px rgba(12,158,150,0.12)',
          }
        }}
      >
        <Box sx={{ px: 2, py: 1.5, borderBottom: `1px solid ${C.border}`, display: 'flex', alignItems: 'center', gap: 1 }}>
          <BellIcon sx={{ fontSize: 16, color: C.teal }} />
          <Typography sx={{ color: C.textStrong, fontWeight: 700, fontSize: '0.875rem' }}>Matchs à venir</Typography>
          <Box sx={{ flex: 1 }} />
          <Typography sx={{ color: C.text, fontSize: '0.72rem' }}>{notifications.length} alertes</Typography>
        </Box>
        {notifications.length === 0 ? (
          <Box sx={{ py: 4, textAlign: 'center' }}>
            <Typography sx={{ color: C.text, fontSize: '0.82rem' }}>Aucune notification</Typography>
          </Box>
        ) : (
          <List dense sx={{ maxHeight: 360, overflowY: 'auto', py: 0.5 }}>
            {notifications.map((n) => {
              const isOverdue = n.kind === 'overdue';
              const isDraw    = n.kind === 'draw';
              const accentColor = isOverdue ? '#ef4444' : isDraw ? '#f59e0b' : C.teal;
              const bgUnread    = isOverdue ? 'rgba(239,68,68,0.06)' : isDraw ? 'rgba(245,158,11,0.06)' : 'rgba(12,158,150,0.06)';
              const bgHover     = isOverdue ? 'rgba(239,68,68,0.10)' : isDraw ? 'rgba(245,158,11,0.10)' : C.accent;
              const icon        = isOverdue ? '⚠️' : isDraw ? '🔔' : '⚽';

              return (
                <ListItem
                  key={n.id}
                  sx={{
                    px: 2, py: 1, borderRadius: 2, mx: 0.5,
                    bgcolor: n.read ? 'transparent' : bgUnread,
                    '&:hover': { bgcolor: bgHover },
                    cursor: 'pointer',
                  }}
                  onClick={() => {
                    navigate(`/admin/matches/${n.matchId}/live`);
                    handleBellClose();
                  }}
                >
                  <Box sx={{ width: '100%' }}>
                    <Box sx={{ display: 'flex', alignItems: 'center', gap: 1, mb: 0.3 }}>
                      {!n.read && <DotIcon sx={{ fontSize: 8, color: accentColor }} />}
                      <Typography sx={{ color: C.textStrong, fontWeight: 600, fontSize: '0.82rem' }}>
                        {icon} {n.homeTeam} vs {n.awayTeam}
                      </Typography>
                      <Box sx={{ flex: 1 }} />
                      {isOverdue && (
                        <Chip label={`+${n.hoursAgo}h`} size="small"
                          sx={{ height: 18, fontSize: '0.65rem', bgcolor: 'rgba(239,68,68,0.12)', color: '#ef4444', fontWeight: 700 }} />
                      )}
                      {isDraw && (
                        <Chip label="Nul" size="small"
                          sx={{ height: 18, fontSize: '0.65rem', bgcolor: 'rgba(245,158,11,0.12)', color: '#f59e0b', fontWeight: 700 }} />
                      )}
                      {!isOverdue && !isDraw && (
                        <Chip label={`${n.minutesLeft} min`} size="small"
                          sx={{ height: 18, fontSize: '0.65rem', bgcolor: C.tealLight, color: C.teal, fontWeight: 700 }} />
                      )}
                    </Box>
                    <Typography sx={{ color: accentColor, fontSize: '0.72rem' }}>
                      {isOverdue && '⚠ Résultat non saisi — cliquer pour saisir →'}
                      {isDraw && `⚽ ${n.homeScore}-${n.awayScore} — Cliquer pour désigner un vainqueur →`}
                      {!isOverdue && !isDraw && `${n.location ? `📍 ${n.location} · ` : ''}${new Date(n.date).toLocaleTimeString('fr-FR', { hour: '2-digit', minute: '2-digit' })} — Suivre en direct →`}
                    </Typography>
                  </Box>
                </ListItem>
              );
            })}
          </List>
        )}
      </Popover>

      {/* ── Toast : match bientôt ─────────────────────────────────────────── */}
      <Snackbar
        open={Boolean(toast)}
        autoHideDuration={8000}
        onClose={() => setToast(null)}
        anchorOrigin={{ vertical: 'top', horizontal: 'right' }}
      >
        <Alert
          onClose={() => setToast(null)}
          severity="warning"
          variant="filled"
          icon={<SportsSoccerIcon sx={{ fontSize: 20 }} />}
          sx={{
            bgcolor: '#ffffff', border: `1px solid ${C.teal}`,
            color: C.textStrong, minWidth: 300,
            boxShadow: '0 8px 24px rgba(12,158,150,0.18)',
            borderRadius: 3,
            '& .MuiAlert-icon': { color: C.teal },
            cursor: 'pointer',
          }}
          onClick={() => { if (toast) navigate(`/admin/matches/${toast.matchId}/live`); setToast(null); }}
        >
          <Typography sx={{ fontWeight: 700, fontSize: '0.875rem', color: C.textStrong }}>
            Match dans {toast?.minutesLeft} min !
          </Typography>
          <Typography sx={{ fontSize: '0.78rem', color: C.text, mt: 0.3 }}>
            {toast?.homeTeam} vs {toast?.awayTeam}
            {toast?.location ? ` · ${toast.location}` : ''}
          </Typography>
          <Typography sx={{ fontSize: '0.7rem', color: C.teal, mt: 0.5, fontWeight: 700 }}>
            Cliquer pour suivre en direct →
          </Typography>
        </Alert>
      </Snackbar>

      {/* ── Toast : matchs périmés sans résultat ─────────────────────────── */}
      <Snackbar
        open={Boolean(overdueToast)}
        autoHideDuration={12000}
        onClose={() => setOverdueToast(null)}
        anchorOrigin={{ vertical: 'top', horizontal: 'right' }}
        sx={{ mt: toast ? 12 : 0 }}
      >
        <Alert
          onClose={() => setOverdueToast(null)}
          severity="error"
          variant="filled"
          icon={<WarningIcon sx={{ fontSize: 20 }} />}
          onClick={(e) => {
            if (overdueToast?.length === 1) {
              navigate(`/admin/matches/${overdueToast[0].matchId}/live`);
              setOverdueToast(null);
            }
          }}
          sx={{
            bgcolor: '#ffffff', border: '1px solid #ef4444',
            color: '#1a2d3d', minWidth: 320,
            boxShadow: '0 8px 24px rgba(239,68,68,0.18)',
            borderRadius: 3,
            '& .MuiAlert-icon': { color: '#ef4444' },
            cursor: overdueToast?.length === 1 ? 'pointer' : 'default',
          }}
        >
          <Typography sx={{ fontWeight: 700, fontSize: '0.875rem', color: '#b91c1c' }}>
            ⚠️ {overdueToast?.length} match{overdueToast?.length > 1 ? 's' : ''} sans résultat !
          </Typography>
          {overdueToast?.slice(0, 3).map((m, i) => (
            <Typography
              key={i}
              onClick={(e) => {
                e.stopPropagation();
                navigate(`/admin/matches/${m.matchId}/live`);
                setOverdueToast(null);
              }}
              sx={{
                fontSize: '0.75rem', color: '#374151', mt: 0.5,
                cursor: 'pointer', display: 'flex', alignItems: 'center', gap: 0.5,
                borderRadius: 1, px: 0.5, py: 0.25,
                '&:hover': { bgcolor: 'rgba(239,68,68,0.08)', color: '#b91c1c' },
              }}
            >
              ▶ {m.homeTeam} vs {m.awayTeam}
              <span style={{ color: '#ef4444', fontWeight: 700, marginLeft: 4 }}>(+{m.hoursAgo}h)</span>
            </Typography>
          ))}
          {overdueToast?.length > 3 && (
            <Typography
              onClick={(e) => { e.stopPropagation(); navigate('/admin?s=4'); setOverdueToast(null); }}
              sx={{ fontSize: '0.72rem', color: '#ef4444', mt: 0.5, cursor: 'pointer', fontWeight: 600,
                '&:hover': { textDecoration: 'underline' } }}
            >
              + {overdueToast.length - 3} autre(s) — voir tous →
            </Typography>
          )}
        </Alert>
      </Snackbar>
    </Box>
  );
};

export default AdminLayout;
