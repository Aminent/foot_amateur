import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import {
  AppBar,
  Box,
  CssBaseline,
  Drawer,
  Divider,
  IconButton,
  List,
  ListItem,
  ListItemIcon,
  ListItemText,
  Toolbar,
  Typography,
  Button
} from '@mui/material';
import {
  Menu as MenuIcon,
  EmojiEvents as TournamentIcon,
  AdminPanelSettings as AdminIcon,
  Dashboard as DashboardIcon,
  People,
  SportsSoccer,
  Person
} from '@mui/icons-material';
import { useAuth } from '../../contexts/AuthContext';
import { Link as RouterLink, Outlet } from 'react-router-dom';

const drawerWidth = 240;

const Layout = () => {
  const navigate = useNavigate();
  const [mobileOpen, setMobileOpen] = useState(false);
  const [anchorEl, setAnchorEl] = useState(null);
  const { user, isAuthenticated, logout } = useAuth();

  const handleDrawerToggle = () => {
    setMobileOpen(!mobileOpen);
  };

  const handleProfileMenuOpen = (event) => {
    setAnchorEl(event.currentTarget);
  };

  const handleProfileMenuClose = () => {
    setAnchorEl(null);
  };

  const handleLogout = () => {
    logout();
    handleProfileMenuClose();
    navigate('/login');
  };


  const drawer = (
    <div>
      <Toolbar sx={{ 
        background: 'linear-gradient(135deg, #1a73e8 0%, #4285f4 100%)',
        color: 'white',
        minHeight: 70
      }}>
        <Box sx={{ display: 'flex', alignItems: 'center', gap: 1.5 }}>
          <Box
            sx={{
              width: 40,
              height: 40,
              borderRadius: '50%',
              background: 'rgba(255, 255, 255, 0.2)',
              display: 'flex',
              alignItems: 'center',
              justifyContent: 'center',
              fontSize: '1.5rem',
            }}
          >
            ⚽
          </Box>
          <Typography variant="h6" noWrap component="div" sx={{ fontWeight: 700 }}>
            Football Amateur
          </Typography>
        </Box>
      </Toolbar>
      <Divider />
      <List sx={{ px: 1.5, py: 2 }}>
        <ListItem 
          button 
          component={RouterLink} 
          to="/tournaments"
          sx={{
            borderRadius: 2,
            mb: 0.5,
            '&:hover': {
              backgroundColor: 'rgba(26, 115, 232, 0.08)',
            }
          }}
        >
          <ListItemIcon sx={{ color: 'primary.main' }}><TournamentIcon /></ListItemIcon>
          <ListItemText 
            primary="Tournois" 
            primaryTypographyProps={{ fontWeight: 500 }}
          />
        </ListItem>
        {isAuthenticated && (
          <>
            {/* Admin-only navigation */}
            {user?.role === 'admin' && (
              <>
                <ListItem 
                  button 
                  component={RouterLink} 
                  to="/admin"
                  sx={{
                    borderRadius: 2,
                    mb: 0.5,
                    '&:hover': {
                      backgroundColor: 'rgba(26, 115, 232, 0.08)',
                    }
                  }}
                >
                  <ListItemIcon sx={{ color: 'primary.main' }}><AdminIcon /></ListItemIcon>
                  <ListItemText 
                    primary="Administration" 
                    primaryTypographyProps={{ fontWeight: 500 }}
                  />
                </ListItem>
              </>
            )}
            
            {/* Coach-only navigation */}
            {user?.role === 'coach' && (
              <ListItem 
                button 
                component={RouterLink} 
                to="/coach"
                sx={{
                  borderRadius: 2,
                  mb: 0.5,
                  '&:hover': {
                    backgroundColor: 'rgba(26, 115, 232, 0.08)',
                  }
                }}
              >
                <ListItemIcon sx={{ color: 'primary.main' }}><People /></ListItemIcon>
                <ListItemText 
                  primary="Mon Espace Coach" 
                  primaryTypographyProps={{ fontWeight: 500 }}
                />
              </ListItem>
            )}
            
            {/* Player-only navigation */}
            {user?.role === 'joueur' && (
              <ListItem 
                button 
                component={RouterLink} 
                to="/player"
                sx={{
                  borderRadius: 2,
                  mb: 0.5,
                  '&:hover': {
                    backgroundColor: 'rgba(26, 115, 232, 0.08)',
                  }
                }}
              >
                <ListItemIcon sx={{ color: 'primary.main' }}><SportsSoccer /></ListItemIcon>
                <ListItemText 
                  primary="Mon Espace Joueur" 
                  primaryTypographyProps={{ fontWeight: 500 }}
                />
              </ListItem>
            )}
            
            <Divider sx={{ my: 1.5 }} />
            
            {/* Profile available to all authenticated users */}
            <ListItem 
              button 
              component={RouterLink} 
              to="/profile"
              sx={{
                borderRadius: 2,
                mb: 0.5,
                '&:hover': {
                  backgroundColor: 'rgba(26, 115, 232, 0.08)',
                }
              }}
            >
              <ListItemIcon sx={{ color: 'primary.main' }}><Person /></ListItemIcon>
              <ListItemText 
                primary="Profil" 
                primaryTypographyProps={{ fontWeight: 500 }}
              />
            </ListItem>
          </>
        )}
      </List>
    </div>
  );

  return (
    <Box sx={{ display: 'flex' }}>
      <CssBaseline />
      <AppBar 
        position="fixed" 
        sx={{ 
          zIndex: (theme) => theme.zIndex.drawer + 1,
          background: 'linear-gradient(135deg, #1a73e8 0%, #4285f4 100%)',
          boxShadow: '0 2px 12px rgba(26, 115, 232, 0.2)'
        }}
      >
        <Toolbar sx={{ minHeight: 70 }}>
          <IconButton
            color="inherit"
            aria-label="open drawer"
            edge="start"
            onClick={handleDrawerToggle}
            sx={{ 
              mr: 2, 
              display: { sm: 'none' },
              '&:hover': {
                backgroundColor: 'rgba(255, 255, 255, 0.1)'
              }
            }}
          >
            <MenuIcon />
          </IconButton>
          <Box sx={{ display: 'flex', alignItems: 'center', gap: 1.5, flexGrow: 1 }}>
            <Box
              sx={{
                width: 36,
                height: 36,
                borderRadius: '50%',
                background: 'rgba(255, 255, 255, 0.2)',
                display: { xs: 'none', sm: 'flex' },
                alignItems: 'center',
                justifyContent: 'center',
                fontSize: '1.3rem',
              }}
            >
              ⚽
            </Box>
            <Typography 
              variant="h6" 
              component={RouterLink} 
              to="/" 
              sx={{ 
                textDecoration: 'none', 
                color: 'white',
                fontWeight: 700,
                letterSpacing: '-0.5px'
              }}
            >
              Football Amateur
            </Typography>
          </Box>
          {isAuthenticated ? (
            <Box sx={{ display: 'flex', alignItems: 'center', gap: 2 }}>
              <Typography 
                variant="body2" 
                sx={{ 
                  display: { xs: 'none', md: 'block' },
                  color: 'rgba(255, 255, 255, 0.9)',
                  fontWeight: 500
                }}
              >
                {user?.name}
              </Typography>
              <Button 
                color="inherit" 
                onClick={logout}
                sx={{
                  borderRadius: 2,
                  px: 2.5,
                  fontWeight: 600,
                  '&:hover': {
                    backgroundColor: 'rgba(255, 255, 255, 0.15)'
                  }
                }}
              >
                Déconnexion
              </Button>
            </Box>
          ) : (
            <Box sx={{ display: 'flex', gap: 1.5 }}>
              <Button 
                color="inherit" 
                component={RouterLink} 
                to="/login"
                sx={{
                  borderRadius: 2,
                  px: 2.5,
                  fontWeight: 600,
                  '&:hover': {
                    backgroundColor: 'rgba(255, 255, 255, 0.15)'
                  }
                }}
              >
                Connexion
              </Button>
              <Button 
                variant="contained"
                component={RouterLink} 
                to="/register"
                sx={{
                  borderRadius: 2,
                  px: 2.5,
                  fontWeight: 600,
                  backgroundColor: 'white',
                  color: 'primary.main',
                  '&:hover': {
                    backgroundColor: 'rgba(255, 255, 255, 0.9)',
                    transform: 'translateY(-2px)',
                    boxShadow: '0 4px 12px rgba(0, 0, 0, 0.2)'
                  },
                  transition: 'all 0.2s ease-in-out'
                }}
              >
                Inscription
              </Button>
            </Box>
          )}
        </Toolbar>
      </AppBar>
      <Box
        component="nav"
        sx={{ width: { sm: drawerWidth }, flexShrink: { sm: 0 } }}
      >
        <Drawer
          variant="temporary"
          open={mobileOpen}
          onClose={handleDrawerToggle}
          ModalProps={{ keepMounted: true }}
          sx={{
            display: { xs: 'block', sm: 'none' },
            '& .MuiDrawer-paper': { boxSizing: 'border-box', width: drawerWidth },
          }}
        >
          {drawer}
        </Drawer>
        <Drawer
          variant="permanent"
          sx={{
            display: { xs: 'none', sm: 'block' },
            '& .MuiDrawer-paper': { boxSizing: 'border-box', width: drawerWidth },
          }}
          open
        >
          {drawer}
        </Drawer>
      </Box>
      <Box
        component="main"
        sx={{ flexGrow: 1, p: 3, width: { sm: `calc(100% - ${drawerWidth}px)` } }}
      >
        <Toolbar />
        <Outlet />
      </Box>
    </Box>
  );
};

export default Layout;