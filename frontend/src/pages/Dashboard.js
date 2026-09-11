import React, { useState, useEffect } from 'react';
import {
  Box,
  Grid,
  Card,
  CardContent,
  Typography,
  Button,
  Chip,
  Avatar,
  List,
  ListItem,
  ListItemText,
  ListItemAvatar,
  Divider
} from '@mui/material';
import {
  EmojiEvents as TournamentIcon,
  Group as TeamIcon,
  SportsSoccer as MatchIcon,
  Person as PlayerIcon,
  TrendingUp as StatsIcon
} from '@mui/icons-material';
import { useNavigate } from 'react-router-dom';
import { useAuth } from '../contexts/AuthContext';
import LoadingSpinner from '../components/LoadingSpinner';
import axios from 'axios';

const Dashboard = () => {
  const { user, isAuthenticated } = useAuth();
  const navigate = useNavigate();
  const [stats, setStats] = useState({
    totalTournaments: 0,
    activeTournaments: 0,
    totalTeams: 0,
    totalPlayers: 0,
    upcomingMatches: 0
  });
  const [recentTournaments, setRecentTournaments] = useState([]);
  const [loading, setLoading] = useState(true);

  // Redirect authenticated users to their role-specific dashboard
  useEffect(() => {
    if (isAuthenticated && user?.role) {
      switch (user.role) {
        case 'admin':
          navigate('/admin', { replace: true });
          return;
        case 'coach':
          navigate('/coach', { replace: true });
          return;
        case 'joueur':
          navigate('/player', { replace: true });
          return;
        default:
          break;
      }
    }
  }, [isAuthenticated, user, navigate]);

  useEffect(() => {
    fetchDashboardData();
  }, []);

  const fetchDashboardData = async () => {
    try {
      const [tournamentsResponse] = await Promise.all([
        axios.get('/tournaments')
      ]);

      const tournaments = tournamentsResponse.data.tournaments;
      
      // Calculer les statistiques
      const activeTournaments = tournaments.filter(t => t.status === 'active');
      const totalTeams = tournaments.reduce((acc, t) => acc + (t.teams?.length || 0), 0);
      const totalPlayers = tournaments.reduce((acc, t) => {
        return acc + t.teams?.reduce((teamAcc, team) => teamAcc + (team.players?.length || 0), 0) || 0;
      }, 0);
      const upcomingMatches = tournaments.reduce((acc, t) => {
        return acc + t.matches?.filter(m => m.status === 'scheduled').length || 0;
      }, 0);

      setStats({
        totalTournaments: tournaments.length,
        activeTournaments: activeTournaments.length,
        totalTeams,
        totalPlayers,
        upcomingMatches
      });

      // Tournois récents (limités à 5)
      setRecentTournaments(tournaments.slice(0, 5));
    } catch (error) {
      console.error('Erreur lors du chargement des données:', error);
    } finally {
      setLoading(false);
    }
  };

  const getStatusColor = (status) => {
    switch (status) {
      case 'active':
        return 'success';
      case 'draft':
        return 'warning';
      case 'completed':
        return 'info';
      case 'cancelled':
        return 'error';
      default:
        return 'default';
    }
  };

  const getStatusLabel = (status) => {
    switch (status) {
      case 'active':
        return 'Actif';
      case 'draft':
        return 'Brouillon';
      case 'completed':
        return 'Terminé';
      case 'cancelled':
        return 'Annulé';
      default:
        return status;
    }
  };

  if (loading) {
    return <LoadingSpinner message="Chargement du tableau de bord..." />;
  }

  return (
    <Box className="fade-in">
      {/* En-tête */}
      <Box sx={{ mb: 5 }}>
        <Typography 
          variant="h3" 
          component="h1" 
          gutterBottom
          sx={{ 
            fontWeight: 700,
            background: 'linear-gradient(135deg, #1a73e8 0%, #34a853 100%)',
            backgroundClip: 'text',
            WebkitBackgroundClip: 'text',
            WebkitTextFillColor: 'transparent',
          }}
        >
          Tableau de bord
        </Typography>
        <Typography variant="h6" color="text.secondary" sx={{ fontWeight: 400 }}>
          Bienvenue, {user?.name} ! Voici un aperçu de votre gestion football amateur.
        </Typography>
      </Box>

      {/* Statistiques */}
      <Grid container spacing={3} sx={{ mb: 5 }}>
        <Grid item xs={12} sm={6} md={2.4}>
          <Card 
            className="hover-lift"
            sx={{ 
              background: 'linear-gradient(135deg, #1a73e8 0%, #4285f4 100%)',
              color: 'white',
              height: '100%'
            }}
          >
            <CardContent sx={{ textAlign: 'center', py: 3 }}>
              <Avatar sx={{ bgcolor: 'rgba(255,255,255,0.2)', mx: 'auto', mb: 2, width: 56, height: 56 }}>
                <TournamentIcon sx={{ fontSize: 32 }} />
              </Avatar>
              <Typography variant="h3" component="div" sx={{ fontWeight: 700, mb: 0.5 }}>
                {stats.totalTournaments}
              </Typography>
              <Typography variant="body1" sx={{ opacity: 0.9, fontWeight: 500 }}>
                Tournois
              </Typography>
            </CardContent>
          </Card>
        </Grid>
        <Grid item xs={12} sm={6} md={2.4}>
          <Card 
            className="hover-lift"
            sx={{ 
              background: 'linear-gradient(135deg, #34a853 0%, #5bb974 100%)',
              color: 'white',
              height: '100%'
            }}
          >
            <CardContent sx={{ textAlign: 'center', py: 3 }}>
              <Avatar sx={{ bgcolor: 'rgba(255,255,255,0.2)', mx: 'auto', mb: 2, width: 56, height: 56 }}>
                <TournamentIcon sx={{ fontSize: 32 }} />
              </Avatar>
              <Typography variant="h3" component="div" sx={{ fontWeight: 700, mb: 0.5 }}>
                {stats.activeTournaments}
              </Typography>
              <Typography variant="body1" sx={{ opacity: 0.9, fontWeight: 500 }}>
                Actifs
              </Typography>
            </CardContent>
          </Card>
        </Grid>
        <Grid item xs={12} sm={6} md={2.4}>
          <Card 
            className="hover-lift"
            sx={{ 
              background: 'linear-gradient(135deg, #4285f4 0%, #669df6 100%)',
              color: 'white',
              height: '100%'
            }}
          >
            <CardContent sx={{ textAlign: 'center', py: 3 }}>
              <Avatar sx={{ bgcolor: 'rgba(255,255,255,0.2)', mx: 'auto', mb: 2, width: 56, height: 56 }}>
                <TeamIcon sx={{ fontSize: 32 }} />
              </Avatar>
              <Typography variant="h3" component="div" sx={{ fontWeight: 700, mb: 0.5 }}>
                {stats.totalTeams}
              </Typography>
              <Typography variant="body1" sx={{ opacity: 0.9, fontWeight: 500 }}>
                Équipes
              </Typography>
            </CardContent>
          </Card>
        </Grid>
        <Grid item xs={12} sm={6} md={2.4}>
          <Card 
            className="hover-lift"
            sx={{ 
              background: 'linear-gradient(135deg, #fbbc04 0%, #fdd663 100%)',
              color: 'white',
              height: '100%'
            }}
          >
            <CardContent sx={{ textAlign: 'center', py: 3 }}>
              <Avatar sx={{ bgcolor: 'rgba(255,255,255,0.2)', mx: 'auto', mb: 2, width: 56, height: 56 }}>
                <PlayerIcon sx={{ fontSize: 32 }} />
              </Avatar>
              <Typography variant="h3" component="div" sx={{ fontWeight: 700, mb: 0.5 }}>
                {stats.totalPlayers}
              </Typography>
              <Typography variant="body1" sx={{ opacity: 0.9, fontWeight: 500 }}>
                Joueurs
              </Typography>
            </CardContent>
          </Card>
        </Grid>
        <Grid item xs={12} sm={6} md={2.4}>
          <Card 
            className="hover-lift"
            sx={{ 
              background: 'linear-gradient(135deg, #ea4335 0%, #ef6c61 100%)',
              color: 'white',
              height: '100%'
            }}
          >
            <CardContent sx={{ textAlign: 'center', py: 3 }}>
              <Avatar sx={{ bgcolor: 'rgba(255,255,255,0.2)', mx: 'auto', mb: 2, width: 56, height: 56 }}>
                <MatchIcon sx={{ fontSize: 32 }} />
              </Avatar>
              <Typography variant="h3" component="div" sx={{ fontWeight: 700, mb: 0.5 }}>
                {stats.upcomingMatches}
              </Typography>
              <Typography variant="body1" sx={{ opacity: 0.9, fontWeight: 500 }}>
                Matchs à venir
              </Typography>
            </CardContent>
          </Card>
        </Grid>
      </Grid>

      {/* Actions rapides et tournois récents */}
      <Grid container spacing={3}>
        <Grid item xs={12} md={6}>
          <Card sx={{ height: '100%' }}>
            <CardContent sx={{ p: 3 }}>
              <Box sx={{ display: 'flex', alignItems: 'center', mb: 3 }}>
                <Box
                  sx={{
                    width: 48,
                    height: 48,
                    borderRadius: 2,
                    background: 'linear-gradient(135deg, #1a73e8 0%, #4285f4 100%)',
                    display: 'flex',
                    alignItems: 'center',
                    justifyContent: 'center',
                    mr: 2
                  }}
                >
                  <StatsIcon sx={{ color: 'white', fontSize: 28 }} />
                </Box>
                <Typography variant="h5" sx={{ fontWeight: 600 }}>
                  Actions rapides
                </Typography>
              </Box>
              <Box sx={{ display: 'flex', flexDirection: 'column', gap: 2 }}>
                <Button
                  variant="contained"
                  startIcon={<TournamentIcon />}
                  onClick={() => navigate('/tournaments')}
                  fullWidth
                  sx={{
                    py: 1.5,
                    fontSize: '1rem',
                    fontWeight: 600,
                    background: 'linear-gradient(135deg, #1a73e8 0%, #4285f4 100%)',
                    '&:hover': {
                      background: 'linear-gradient(135deg, #1557b0 0%, #1a73e8 100%)',
                      transform: 'translateY(-2px)',
                      boxShadow: '0 6px 20px rgba(26, 115, 232, 0.4)',
                    },
                    transition: 'all 0.2s ease-in-out'
                  }}
                >
                  Voir tous les tournois
                </Button>
                {(user?.role === 'admin' || user?.role === 'coach') && (
                  <Button
                    variant="outlined"
                    startIcon={<TournamentIcon />}
                    onClick={() => navigate('/tournaments')}
                    fullWidth
                    sx={{
                      py: 1.5,
                      fontSize: '1rem',
                      fontWeight: 600,
                      borderWidth: 2,
                      '&:hover': {
                        borderWidth: 2,
                        transform: 'translateY(-2px)',
                        boxShadow: '0 4px 12px rgba(26, 115, 232, 0.2)',
                      },
                      transition: 'all 0.2s ease-in-out'
                    }}
                  >
                    Créer un tournoi
                  </Button>
                )}
              </Box>
            </CardContent>
          </Card>
        </Grid>
        <Grid item xs={12} md={6}>
          <Card sx={{ height: '100%' }}>
            <CardContent sx={{ p: 3 }}>
              <Box sx={{ display: 'flex', alignItems: 'center', mb: 3 }}>
                <Box
                  sx={{
                    width: 48,
                    height: 48,
                    borderRadius: 2,
                    background: 'linear-gradient(135deg, #34a853 0%, #5bb974 100%)',
                    display: 'flex',
                    alignItems: 'center',
                    justifyContent: 'center',
                    mr: 2
                  }}
                >
                  <TournamentIcon sx={{ color: 'white', fontSize: 28 }} />
                </Box>
                <Typography variant="h5" sx={{ fontWeight: 600 }}>
                  Tournois récents
                </Typography>
              </Box>
              {recentTournaments.length > 0 ? (
                <List>
                  {recentTournaments.map((tournament, index) => (
                    <React.Fragment key={tournament.id}>
                      <ListItem
                        button
                        onClick={() => navigate(`/tournaments/${tournament.id}`)}
                      >
                        <ListItemAvatar>
                          <Avatar>
                            <TournamentIcon />
                          </Avatar>
                        </ListItemAvatar>
                        <ListItemText
                          primary={tournament.name}
                          secondary={
                            <Box>
                              <Typography variant="body2" color="text.secondary">
                                {new Date(tournament.startDate).toLocaleDateString('fr-FR')} - {new Date(tournament.endDate).toLocaleDateString('fr-FR')}
                              </Typography>
                              <Chip
                                label={getStatusLabel(tournament.status)}
                                color={getStatusColor(tournament.status)}
                                size="small"
                                sx={{ mt: 0.5 }}
                              />
                            </Box>
                          }
                        />
                      </ListItem>
                      {index < recentTournaments.length - 1 && <Divider />}
                    </React.Fragment>
                  ))}
                </List>
              ) : (
                <Typography color="text.secondary" sx={{ textAlign: 'center', py: 2 }}>
                  Aucun tournoi pour le moment
                </Typography>
              )}
            </CardContent>
          </Card>
        </Grid>
      </Grid>
    </Box>
  );
};

export default Dashboard; 