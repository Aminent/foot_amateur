import React, { useState, useEffect } from 'react';
import { authHeaders } from '../utils/api';
import {
  Box,
  Typography,
  Card,
  CardContent,
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableRow,
  IconButton,
  Dialog,
  DialogTitle,
  DialogContent,
  DialogActions,
  Button,
  TextField,
  FormControl,
  InputLabel,
  Select,
  MenuItem,
  Grid,
  Chip,
  Alert,
  Paper,
  Tabs,
  Tab,
  List,
  ListItem,
  ListItemText,
  ListItemIcon,
  Divider,
  LinearProgress,
  Avatar,
  Badge,
  Fab,
  Tooltip
} from '@mui/material';
import {
  Edit as EditIcon,
  Person as PersonIcon,
  EmojiEvents as TrophyIcon,
  Group as GroupIcon,
  SportsSoccer as MatchIcon,
  FitnessCenter as TrainingIcon,
  Assessment as StatsIcon,
  Schedule as ScheduleIcon,
  Add as AddIcon,
  TrendingUp as TrendingUpIcon,
  CalendarToday as CalendarIcon,
  LocationOn as LocationIcon,
  Timer as TimerIcon,
  CheckCircle as CheckCircleIcon,
  Warning as WarningIcon,
  Info as InfoIcon
} from '@mui/icons-material';
import LoadingSpinner from '../components/LoadingSpinner';

const CoachPage = () => {
  const [team, setTeam] = useState(null);
  const [players, setPlayers] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');
  const [activeTab, setActiveTab] = useState(0);
  
  // Player management
  const [editDialog, setEditDialog] = useState(false);
  const [editingPlayer, setEditingPlayer] = useState(null);
  const [playerForm, setPlayerForm] = useState({
    name: '',
    position: '',
    jerseyNumber: '',
    isCaptain: false
  });

  // Stats management
  const [statsDialog, setStatsDialog] = useState(false);
  const [editingPlayerStats, setEditingPlayerStats] = useState(null);
  const [statsForm, setStatsForm] = useState({
    goals: 0,
    assists: 0,
    shots: 0,
    shotsOnTarget: 0,
    passes: 0,
    keyPasses: 0,
    tackles: 0,
    interceptions: 0,
    clearances: 0,
    dribbles: 0,
    foulsCommitted: 0,
    foulsSuffered: 0,
    offsides: 0,
    saves: 0,
    cleanSheets: 0,
    minutesPlayed: 0,
    yellowCards: 0,
    redCards: 0
  });
  
  // Training sessions
  const [trainingSessions, setTrainingSessions] = useState([]);
  const [trainingDialog, setTrainingDialog] = useState(false);
  const [trainingForm, setTrainingForm] = useState({
    title: '',
    date: '',
    duration: '',
    type: '',
    description: '',
    objectives: ''
  });
  
  // Match history
  const [matches, setMatches] = useState([]);
  const [teamStats, setTeamStats] = useState({
    totalMatches: 0,
    wins: 0,
    draws: 0,
    losses: 0,
    goalsFor: 0,
    goalsAgainst: 0,
    winRate: 0
  });

  useEffect(() => {
    fetchMyTeam();
    fetchTrainingSessions();
    fetchMatchHistory();
  }, []);

  const fetchMyTeam = async () => {
    setLoading(true);
    try {
      const response = await fetch(`${process.env.REACT_APP_API_URL || 'http://localhost:5000/api'}/coaches/me/team`, {
        headers: authHeaders(),
      });

      if (response.ok) {
        const data = await response.json();
        setTeam(data.team);
        setPlayers(data.team.players || []);
        setError(''); // Clear any previous errors
      } else {
        const errorData = await response.json();
        setError(errorData.message || 'Erreur lors du chargement de l\'équipe');
        setTeam(null);
        setPlayers([]);
      }
    } catch (error) {
      console.error('Network error fetching team:', error);
      setError('Erreur lors du chargement de l\'équipe');
      setTeam(null);
      setPlayers([]);
    } finally {
      setLoading(false);
    }
  };

  const fetchTrainingSessions = async () => {
    try {
      const response = await fetch(`${process.env.REACT_APP_API_URL || 'http://localhost:5000/api'}/coaches/me/trainings`, {
        headers: authHeaders(),
      });
      if (!response.ok) throw new Error('Erreur lors du chargement des séances');
      const data = await response.json();
      setTrainingSessions(data.trainings || data || []);
    } catch (e) {
      console.error(e);
      setTrainingSessions([]);
    }
  };

  const fetchMatchHistory = async () => {
    try {
      const res = await fetch(`${process.env.REACT_APP_API_URL || 'http://localhost:5000/api'}/coaches/me/matches`, {
        headers: authHeaders(),
      });
      if (!res.ok) throw new Error('Erreur lors du chargement des matchs');
      const data = await res.json();
      const list = data.matches || [];
      setMatches(list);

      // Calculate stats from real matches
      const stats = {
        totalMatches: list.filter(m => m.status === 'completed').length,
        wins: list.filter(m => m.result === 'Victoire').length,
        draws: list.filter(m => m.result === 'Match nul').length,
        losses: list.filter(m => m.result === 'Défaite').length,
        goalsFor: list.reduce((sum, m) => sum + (m.goalsFor || 0), 0),
        goalsAgainst: list.reduce((sum, m) => sum + (m.goalsAgainst || 0), 0),
        winRate: 0
      };
      stats.winRate = stats.totalMatches > 0 ? Math.round((stats.wins / stats.totalMatches) * 100) : 0;
      setTeamStats(stats);
    } catch (e) {
      console.error(e);
      setError('Erreur lors du chargement de l\'historique des matchs');
    }
  };

  const handleCreateTraining = async () => {
    try {
      const response = await fetch(`${process.env.REACT_APP_API_URL || 'http://localhost:5000/api'}/coaches/me/trainings`, {
        method: 'POST',
        headers: authHeaders(),
        body: JSON.stringify({ ...trainingForm, status: 'scheduled' })
      });
      if (!response.ok) {
        const errorData = await response.json();
        setError(errorData.message || 'Erreur lors de la création de la séance');
        return;
      }
      setTrainingDialog(false);
      setTrainingForm({
        title: '',
        date: '',
        duration: '',
        type: '',
        description: '',
        objectives: ''
      });
      await fetchTrainingSessions();
    } catch (e) {
      console.error(e);
      setError('Erreur lors de la création de la séance');
    }
  };

  const handleEditPlayer = (player) => {
    setEditingPlayer(player);
    setPlayerForm({
      name: player.name || '',
      position: player.position || '',
      jerseyNumber: player.jerseyNumber || '',
      isCaptain: player.isCaptain || false
    });
    setEditDialog(true);
  };

  const handleUpdatePlayer = async () => {
    try {
      const response = await fetch(`${process.env.REACT_APP_API_URL || 'http://localhost:5000/api'}/players/${editingPlayer.id}`, {
        method: 'PUT',
        headers: authHeaders(),
        body: JSON.stringify(playerForm)
      });

      if (response.ok) {
        setEditDialog(false);
        setEditingPlayer(null);
        setPlayerForm({
          name: '',
          position: '',
          jerseyNumber: '',
          isCaptain: false
        });
        await fetchMyTeam();
      } else {
        const errorData = await response.json();
        console.error('Player update error:', errorData);
        setError(`Erreur lors de la mise à jour du joueur: ${errorData.message || 'Erreur inconnue'}`);
      }
    } catch (error) {
      console.error('Player update error:', error);
      setError('Erreur lors de la mise à jour du joueur');
    }
  };

  const handleEditPlayerStats = async (player) => {
    try {
      const response = await fetch(`${process.env.REACT_APP_API_URL || 'http://localhost:5000/api'}/player-stats/${player.id}`, {
        headers: authHeaders(),
      });

      if (response.ok) {
        const data = await response.json();
        setEditingPlayerStats(player);
        setStatsForm({
          goals: data.stats?.goals || 0,
          assists: data.stats?.assists || 0,
          shots: data.stats?.shots || 0,
          shotsOnTarget: data.stats?.shotsOnTarget || 0,
          passes: data.stats?.passes || 0,
          keyPasses: data.stats?.keyPasses || 0,
          tackles: data.stats?.tackles || 0,
          interceptions: data.stats?.interceptions || 0,
          clearances: data.stats?.clearances || 0,
          dribbles: data.stats?.dribbles || 0,
          foulsCommitted: data.stats?.foulsCommitted || 0,
          foulsSuffered: data.stats?.foulsSuffered || 0,
          offsides: data.stats?.offsides || 0,
          saves: data.stats?.saves || 0,
          cleanSheets: data.stats?.cleanSheets || 0,
          minutesPlayed: data.stats?.minutesPlayed || 0,
          yellowCards: data.stats?.yellowCards || 0,
          redCards: data.stats?.redCards || 0
        });
        setStatsDialog(true);
      } else {
        const errorData = await response.json();
        console.error('Error response:', errorData);
        setError(`Erreur: ${errorData.message || 'Impossible de charger les statistiques'}`);
      }
    } catch (error) {
      console.error('Error fetching player stats:', error);
      setError('Erreur lors du chargement des statistiques');
    }
  };

  const handleUpdatePlayerStats = async () => {
    try {
      const response = await fetch(`${process.env.REACT_APP_API_URL || 'http://localhost:5000/api'}/player-stats/${editingPlayerStats.id}`, {
        method: 'PUT',
        headers: authHeaders(),
        body: JSON.stringify(statsForm)
      });

      if (response.ok) {
        setStatsDialog(false);
        setEditingPlayerStats(null);
        setStatsForm({
          goals: 0,
          assists: 0,
          shots: 0,
          shotsOnTarget: 0,
          passes: 0,
          keyPasses: 0,
          tackles: 0,
          interceptions: 0,
          clearances: 0,
          dribbles: 0,
          foulsCommitted: 0,
          foulsSuffered: 0,
          offsides: 0,
          saves: 0,
          cleanSheets: 0,
          minutesPlayed: 0,
          yellowCards: 0,
          redCards: 0
        });
        await fetchMyTeam();
      } else {
        const errorData = await response.json();
        setError(`Erreur lors de la mise à jour des statistiques: ${errorData.message || 'Erreur inconnue'}`);
      }
    } catch (error) {
      console.error('Stats update error:', error);
      setError('Erreur lors de la mise à jour des statistiques');
    }
  };

  const getPositionLabel = (position) => {
    switch (position) {
      case 'gardien': return 'Gardien';
      case 'defenseur': return 'Défenseur';
      case 'milieu': return 'Milieu';
      case 'attaquant': return 'Attaquant';
      default: return position || '-';
    }
  };

  const getPositionColor = (position) => {
    switch (position) {
      case 'gardien': return 'warning';
      case 'defenseur': return 'info';
      case 'milieu': return 'success';
      case 'attaquant': return 'error';
      default: return 'default';
    }
  };

  if (loading) {
    return <LoadingSpinner message="Chargement de votre équipe..." />;
  }

  if (!team) {
    return (
      <Box sx={{ p: 3 }}>
        <Alert severity="info">
          Aucune équipe assignée. Contactez l'administrateur pour être assigné à une équipe.
        </Alert>
      </Box>
    );
  }

  const TabPanel = ({ children, value, index }) => (
    <div hidden={value !== index}>
      {value === index && <Box sx={{ p: 3 }}>{children}</Box>}
    </div>
  );

  const renderLineupField = () => {
    const uploadsBase = (process.env.REACT_APP_API_URL || 'http://localhost:5000/api').replace(/\/api$/, '');
    const fieldImageUrl = `${uploadsBase}/uploads/avatars/field.png`;
    const gks = players.filter(p => p.position === 'gardien');
    const defs = players.filter(p => p.position === 'defenseur');
    const mids = players.filter(p => p.position === 'milieu');
    const atts = players.filter(p => p.position === 'attaquant');

    const renderRow = (rowPlayers) => (
      <Box sx={{ display: 'flex', justifyContent: 'space-evenly', width: '100%', mb: 4 }}>
        {rowPlayers.map((p) => {
          const avatarUrl = p.avatar ? `${uploadsBase}${p.avatar.startsWith('/') ? '' : '/'}${p.avatar}` : null;
          return (
            <Box key={p.id} sx={{ display: 'flex', alignItems: 'center', gap: 1, bgcolor: 'rgba(0,0,0,0.35)', px: 1, py: 0.5, borderRadius: 2 }}>
              <Avatar src={avatarUrl || undefined} sx={{ width: 28, height: 28 }} />
              <Chip
                label={p.name}
                color={getPositionColor(p.position) || (p.isCaptain ? 'primary' : 'default')}
                size="small"
              />
            </Box>
          );
        })}
      </Box>
    );

    return (
      <Box
        sx={{
          position: 'relative',
          width: '100%',
          height: 500,
          borderRadius: 2,
          boxShadow: 3,
          p: 2,
          color: 'white',
          backgroundImage: `url(${fieldImageUrl})`,
          backgroundSize: 'cover',
          backgroundPosition: 'center',
          backgroundRepeat: 'no-repeat'
        }}
      >
        {/* Goal area */}
        <Box sx={{ position: 'absolute', top: 12, left: '25%', width: '50%', height: 80, border: '2px solid rgba(255,255,255,0.6)', borderRadius: 1 }} />
        {/* Penalty arc */}
        <Box sx={{ position: 'absolute', top: 92, left: '42.5%', width: '15%', height: 30, borderTop: '2px solid rgba(255,255,255,0.6)', borderLeft: '2px solid transparent', borderRight: '2px solid transparent', borderBottom: 'none', borderRadius: '0 0 80px 80px / 0 0 30px 30px' }} />

        {/* Rows: GK, DEF, MID, ATT */}
        <Box sx={{ position: 'absolute', top: 30, left: 0, right: 0, display: 'flex', justifyContent: 'center' }}>
          {renderRow(gks.length ? gks : [])}
        </Box>
        <Box sx={{ position: 'absolute', top: 160, left: 0, right: 0, display: 'flex', justifyContent: 'center' }}>
          {renderRow(defs)}
        </Box>
        <Box sx={{ position: 'absolute', top: 290, left: 0, right: 0, display: 'flex', justifyContent: 'center' }}>
          {renderRow(mids)}
        </Box>
        <Box sx={{ position: 'absolute', bottom: 30, left: 0, right: 0, display: 'flex', justifyContent: 'center' }}>
          {renderRow(atts)}
        </Box>
      </Box>
    );
  };

  return (
    <Box sx={{ p: 3 }} className="fade-in">
      <Box sx={{ mb: 5 }}>
        <Typography 
          variant="h3" 
          gutterBottom 
          sx={{ 
            fontWeight: 700,
            background: 'linear-gradient(135deg, #1a73e8 0%, #34a853 100%)',
            backgroundClip: 'text',
            WebkitBackgroundClip: 'text',
            WebkitTextFillColor: 'transparent',
            mb: 1
          }}
        >
          Espace Coach
        </Typography>
        <Typography variant="h6" color="text.secondary" sx={{ fontWeight: 400 }}>
          {team.name} - Gérez votre équipe et vos entraînements
        </Typography>
      </Box>

      {error && (
        <Alert 
          severity="error" 
          sx={{ 
            mb: 3,
            borderRadius: 2,
            '& .MuiAlert-icon': {
              fontSize: '1.5rem'
            }
          }} 
          onClose={() => setError('')}
        >
          {error}
        </Alert>
      )}

      {/* Overview Stats */}
      <Grid container spacing={3} sx={{ mb: 5 }}>
        <Grid item xs={12} sm={6} md={3}>
          <Card 
            className="hover-lift"
            sx={{ 
              background: 'linear-gradient(135deg, #1a73e8 0%, #4285f4 100%)',
              color: 'white',
              height: '100%'
            }}
          >
            <CardContent sx={{ p: 3 }}>
              <Box sx={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
                <Box>
                  <Typography variant="h3" component="div" sx={{ fontWeight: 700, mb: 0.5 }}>
                    {players.length}
                  </Typography>
                  <Typography variant="body1" sx={{ opacity: 0.9, fontWeight: 500 }}>
                    Joueurs
                  </Typography>
                </Box>
                <GroupIcon sx={{ fontSize: 48, opacity: 0.3 }} />
              </Box>
            </CardContent>
          </Card>
        </Grid>
        <Grid item xs={12} sm={6} md={3}>
          <Card 
            className="hover-lift"
            sx={{ 
              background: 'linear-gradient(135deg, #34a853 0%, #5bb974 100%)',
              color: 'white',
              height: '100%'
            }}
          >
            <CardContent sx={{ p: 3 }}>
              <Box sx={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
                <Box>
                  <Typography variant="h3" component="div" sx={{ fontWeight: 700, mb: 0.5 }}>
                    {teamStats.winRate}%
                  </Typography>
                  <Typography variant="body1" sx={{ opacity: 0.9, fontWeight: 500 }}>
                    Taux de victoire
                  </Typography>
                </Box>
                <TrophyIcon sx={{ fontSize: 48, opacity: 0.3 }} />
              </Box>
            </CardContent>
          </Card>
        </Grid>
        <Grid item xs={12} sm={6} md={3}>
          <Card 
            className="hover-lift"
            sx={{ 
              background: 'linear-gradient(135deg, #4285f4 0%, #669df6 100%)',
              color: 'white',
              height: '100%'
            }}
          >
            <CardContent sx={{ p: 3 }}>
              <Box sx={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
                <Box>
                  <Typography variant="h3" component="div" sx={{ fontWeight: 700, mb: 0.5 }}>
                    {teamStats.totalMatches}
                  </Typography>
                  <Typography variant="body1" sx={{ opacity: 0.9, fontWeight: 500 }}>
                    Matchs joués
                  </Typography>
                </Box>
                <MatchIcon sx={{ fontSize: 48, opacity: 0.3 }} />
              </Box>
            </CardContent>
          </Card>
        </Grid>
        <Grid item xs={12} sm={6} md={3}>
          <Card 
            className="hover-lift"
            sx={{ 
              background: 'linear-gradient(135deg, #fbbc04 0%, #fdd663 100%)',
              color: 'white',
              height: '100%'
            }}
          >
            <CardContent sx={{ p: 3 }}>
              <Box sx={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
                <Box>
                  <Typography variant="h3" component="div" sx={{ fontWeight: 700, mb: 0.5 }}>
                    {trainingSessions.length}
                  </Typography>
                  <Typography variant="body1" sx={{ opacity: 0.9, fontWeight: 500 }}>
                    Entraînements
                  </Typography>
                </Box>
                <TrainingIcon sx={{ fontSize: 48, opacity: 0.3 }} />
              </Box>
            </CardContent>
          </Card>
        </Grid>
      </Grid>

      {/* Tabs */}
      <Card sx={{ borderRadius: 3 }}>
        <Tabs 
          value={activeTab} 
          onChange={(e, newValue) => setActiveTab(newValue)}
          sx={{
            borderBottom: 1,
            borderColor: 'divider',
            px: 2,
            '& .MuiTab-root': {
              fontSize: '1rem',
              fontWeight: 600,
              minHeight: 64,
              textTransform: 'none',
            },
            '& .Mui-selected': {
              color: 'primary.main',
            }
          }}
        >
          <Tab icon={<StatsIcon />} iconPosition="start" label="Vue d'ensemble" />
          <Tab icon={<TrainingIcon />} iconPosition="start" label="Entraînements" />
          <Tab icon={<MatchIcon />} iconPosition="start" label="Matchs" />
          <Tab icon={<GroupIcon />} iconPosition="start" label="Joueurs" />
          <Tab icon={<TrendingUpIcon />} iconPosition="start" label="Statistiques" />
        </Tabs>

        {/* Statistics Tab */}
        <TabPanel value={activeTab} index={0}>
          <Grid container spacing={3}>
            <Grid item xs={12} md={6}>
              <Card>
                <CardContent>
                  <Typography variant="h6" gutterBottom>
                    📈 Statistiques de l'équipe
                  </Typography>
                  <List>
                    <ListItem>
                      <ListItemIcon><TrophyIcon /></ListItemIcon>
                      <ListItemText primary="Victoires" secondary={`${teamStats.wins} matchs`} />
                    </ListItem>
                    <ListItem>
                      <ListItemIcon><InfoIcon /></ListItemIcon>
                      <ListItemText primary="Matchs nuls" secondary={`${teamStats.draws} matchs`} />
                    </ListItem>
                    <ListItem>
                      <ListItemIcon><WarningIcon /></ListItemIcon>
                      <ListItemText primary="Défaites" secondary={`${teamStats.losses} matchs`} />
                    </ListItem>
                    <ListItem>
                      <ListItemIcon><TrendingUpIcon /></ListItemIcon>
                      <ListItemText primary="Buts marqués" secondary={`${teamStats.goalsFor} buts`} />
                    </ListItem>
                    <ListItem>
                      <ListItemIcon><WarningIcon /></ListItemIcon>
                      <ListItemText primary="Buts encaissés" secondary={`${teamStats.goalsAgainst} buts`} />
                    </ListItem>
                  </List>
                </CardContent>
              </Card>
            </Grid>
            <Grid item xs={12} md={6}>
              <Card>
                <CardContent>
                  <Typography variant="h6" gutterBottom>
                    🎯 Performance par position
                  </Typography>
                  <Box sx={{ mb: 2 }}>
                    <Typography variant="body2" gutterBottom>
                      Gardiens: {players.filter(p => p.position === 'gardien').length}
                    </Typography>
                    <LinearProgress variant="determinate" value={(players.filter(p => p.position === 'gardien').length / players.length) * 100} />
                  </Box>
                  <Box sx={{ mb: 2 }}>
                    <Typography variant="body2" gutterBottom>
                      Défenseurs: {players.filter(p => p.position === 'defenseur').length}
                    </Typography>
                    <LinearProgress variant="determinate" value={(players.filter(p => p.position === 'defenseur').length / players.length) * 100} />
                  </Box>
                  <Box sx={{ mb: 2 }}>
                    <Typography variant="body2" gutterBottom>
                      Milieux: {players.filter(p => p.position === 'milieu').length}
                    </Typography>
                    <LinearProgress variant="determinate" value={(players.filter(p => p.position === 'milieu').length / players.length) * 100} />
                  </Box>
                  <Box sx={{ mb: 2 }}>
                    <Typography variant="body2" gutterBottom>
                      Attaquants: {players.filter(p => p.position === 'attaquant').length}
                    </Typography>
                    <LinearProgress variant="determinate" value={(players.filter(p => p.position === 'attaquant').length / players.length) * 100} />
                  </Box>
                </CardContent>
              </Card>
            </Grid>
          </Grid>
        </TabPanel>

        {/* Training Sessions Tab */}
        <TabPanel value={activeTab} index={1}>
          <Box sx={{ display: 'flex', justifyContent: 'space-between', mb: 2 }}>
            <Typography variant="h6">Séances d'entraînement</Typography>
            <Button
              variant="contained"
              startIcon={<AddIcon />}
              onClick={() => setTrainingDialog(true)}
            >
              Nouvelle séance
            </Button>
          </Box>
          
          <Grid container spacing={2}>
            {trainingSessions.map((session) => (
              <Grid item xs={12} md={6} key={session.id}>
                <Card>
                  <CardContent>
                    <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'start', mb: 2 }}>
                      <Typography variant="h6">{session.title}</Typography>
                      <Chip 
                        label={session.status === 'completed' ? 'Terminée' : 'Programmée'} 
                        color={session.status === 'completed' ? 'success' : 'primary'}
                        size="small"
                      />
                    </Box>
                    <Typography variant="body2" color="text.secondary" sx={{ mb: 1 }}>
                      📅 {new Date(session.date).toLocaleDateString('fr-FR')} • ⏱️ {session.duration}
                    </Typography>
                    <Typography variant="body2" color="text.secondary" sx={{ mb: 1 }}>
                      🏷️ {session.type}
                    </Typography>
                    <Typography variant="body2" sx={{ mb: 1 }}>
                      {session.description}
                    </Typography>
                    <Typography variant="body2" color="text.secondary">
                      <strong>Objectifs:</strong> {session.objectives}
                    </Typography>
                  </CardContent>
                </Card>
              </Grid>
            ))}
          </Grid>
        </TabPanel>

        {/* Match History Tab */}
        <TabPanel value={activeTab} index={2}>
          <Typography variant="h6" gutterBottom>
            Historique des matchs
          </Typography>
          
          <Table>
            <TableHead>
              <TableRow>
                <TableCell>Date</TableCell>
                <TableCell>Adversaire</TableCell>
                <TableCell>Tournoi</TableCell>
                <TableCell>Score</TableCell>
                <TableCell>Résultat</TableCell>
              </TableRow>
            </TableHead>
            <TableBody>
              {matches.map((match) => (
                <TableRow key={match.id}>
                  <TableCell>{new Date(match.date).toLocaleDateString('fr-FR')}</TableCell>
                  <TableCell>{match.opponent}</TableCell>
                  <TableCell>{match.tournament}</TableCell>
                  <TableCell>{match.score}</TableCell>
                  <TableCell>
                    <Chip 
                      label={match.result} 
                      color={match.result === 'Victoire' ? 'success' : match.result === 'Match nul' ? 'warning' : 'error'}
                      size="small"
                    />
                  </TableCell>
                </TableRow>
              ))}
            </TableBody>
          </Table>
        </TabPanel>

        {/* Players Tab */}
        <TabPanel value={activeTab} index={3}>
          <Grid container spacing={3}>
            <Grid item xs={12} md={6}>
              <Typography variant="h6" gutterBottom>
                Disposition sur le terrain
              </Typography>
              {renderLineupField()}
            </Grid>
            <Grid item xs={12} md={6}>
              <Typography variant="h6" gutterBottom>
                Gestion des Joueurs
              </Typography>
              <Table>
                <TableHead>
                  <TableRow>
                    <TableCell>Nom</TableCell>
                    <TableCell>Position</TableCell>
                    <TableCell>N° Maillot</TableCell>
                    <TableCell>Capitaine</TableCell>
                    <TableCell>Actions</TableCell>
                  </TableRow>
                </TableHead>
                <TableBody>
                  {players.map((player) => (
                    <TableRow key={player.id}>
                      <TableCell>{player.name}</TableCell>
                      <TableCell>
                        {player.position ? (
                          <Chip 
                            label={getPositionLabel(player.position)} 
                            color={getPositionColor(player.position)}
                            size="small"
                          />
                        ) : '-'}
                      </TableCell>
                      <TableCell>{player.jerseyNumber || '-'}</TableCell>
                      <TableCell>
                        {player.isCaptain ? (
                          <Chip label="Capitaine" color="primary" size="small" />
                        ) : '-'}
                      </TableCell>
                      <TableCell>
                        <IconButton 
                          size="small" 
                          color="primary"
                          onClick={() => handleEditPlayer(player)}
                        >
                          <EditIcon />
                        </IconButton>
                      </TableCell>
                    </TableRow>
                  ))}
                </TableBody>
              </Table>
            </Grid>
          </Grid>
        </TabPanel>

        {/* Player Statistics Management Tab */}
        <TabPanel value={activeTab} index={4}>
          <Typography variant="h6" gutterBottom>
            Gestion des Statistiques des Joueurs
          </Typography>
          
          <Table>
            <TableHead>
              <TableRow>
                <TableCell>Joueur</TableCell>
                <TableCell>Position</TableCell>
                <TableCell>Buts</TableCell>
                <TableCell>Passes</TableCell>
                <TableCell>Minutes</TableCell>
                <TableCell>Cartons</TableCell>
                <TableCell>Actions</TableCell>
              </TableRow>
            </TableHead>
            <TableBody>
              {players.map((player) => (
                <TableRow key={player.id}>
                  <TableCell>{player.name}</TableCell>
                  <TableCell>
                    {player.position ? (
                      <Chip 
                        label={getPositionLabel(player.position)} 
                        color={getPositionColor(player.position)}
                        size="small"
                      />
                    ) : '-'}
                  </TableCell>
                  <TableCell>{player.stats?.goals || 0}</TableCell>
                  <TableCell>{player.stats?.assists || 0}</TableCell>
                  <TableCell>{player.stats?.minutesPlayed || 0}</TableCell>
                  <TableCell>
                    <Box sx={{ display: 'flex', gap: 0.5 }}>
                      {(player.stats?.yellowCards || 0) > 0 && (
                        <Chip 
                          label={player.stats.yellowCards} 
                          size="small" 
                          sx={{ bgcolor: 'warning.main', color: 'white' }}
                        />
                      )}
                      {(player.stats?.redCards || 0) > 0 && (
                        <Chip 
                          label={player.stats.redCards} 
                          size="small" 
                          sx={{ bgcolor: 'error.main', color: 'white' }}
                        />
                      )}
                      {!player.stats?.yellowCards && !player.stats?.redCards && '-'}
                    </Box>
                  </TableCell>
                  <TableCell>
                    <IconButton 
                      size="small" 
                      color="primary"
                      onClick={() => handleEditPlayerStats(player)}
                    >
                      <StatsIcon />
                    </IconButton>
                  </TableCell>
                </TableRow>
              ))}
            </TableBody>
          </Table>
        </TabPanel>
      </Card>

      <Dialog open={editDialog} onClose={() => setEditDialog(false)} maxWidth="sm" fullWidth>
        <DialogTitle>Modifier le Joueur</DialogTitle>
        <DialogContent>
          <Grid container spacing={2} sx={{ mt: 1 }}>
            <Grid item xs={12}>
              <TextField
                fullWidth
                label="Nom du joueur"
                value={playerForm.name}
                onChange={(e) => setPlayerForm({...playerForm, name: e.target.value})}
                disabled
                helperText="Le nom ne peut pas être modifié"
              />
            </Grid>
            <Grid item xs={12} sm={6}>
              <FormControl fullWidth>
                <InputLabel>Position</InputLabel>
                <Select
                  value={playerForm.position}
                  onChange={(e) => setPlayerForm({...playerForm, position: e.target.value})}
                >
                  <MenuItem value="">Aucune position</MenuItem>
                  <MenuItem value="gardien">Gardien</MenuItem>
                  <MenuItem value="defenseur">Défenseur</MenuItem>
                  <MenuItem value="milieu">Milieu</MenuItem>
                  <MenuItem value="attaquant">Attaquant</MenuItem>
                </Select>
              </FormControl>
            </Grid>
            <Grid item xs={12} sm={6}>
              <TextField
                fullWidth
                type="number"
                label="Numéro de maillot"
                value={playerForm.jerseyNumber}
                onChange={(e) => setPlayerForm({...playerForm, jerseyNumber: e.target.value})}
                inputProps={{ min: 1, max: 99 }}
              />
            </Grid>
            <Grid item xs={12}>
              <FormControl fullWidth>
                <InputLabel>Capitaine</InputLabel>
                <Select
                  value={playerForm.isCaptain}
                  onChange={(e) => setPlayerForm({...playerForm, isCaptain: e.target.value})}
                >                  
                  <MenuItem value={false}>Non</MenuItem>
                  <MenuItem value={true}>Oui</MenuItem>
                </Select>
              </FormControl>
            </Grid>
          </Grid>
        </DialogContent>
        <DialogActions>
          <Button onClick={() => {
            setEditDialog(false);
            setEditingPlayer(null);
          }}>Annuler</Button>
          <Button onClick={handleUpdatePlayer} variant="contained">
            Modifier
          </Button>
        </DialogActions>
      </Dialog>

      {/* Training Session Dialog */}
      <Dialog open={trainingDialog} onClose={() => setTrainingDialog(false)} maxWidth="md" fullWidth>
        <DialogTitle>Nouvelle séance d'entraînement</DialogTitle>
        <DialogContent>
          <Grid container spacing={2} sx={{ mt: 1 }}>
            <Grid item xs={12}>
              <TextField
                fullWidth
                label="Titre de la séance"
                value={trainingForm.title}
                onChange={(e) => setTrainingForm({...trainingForm, title: e.target.value})}
                required
              />
            </Grid>
            <Grid item xs={12} sm={6}>
              <TextField
                fullWidth
                label="Date"
                type="date"
                value={trainingForm.date}
                onChange={(e) => setTrainingForm({...trainingForm, date: e.target.value})}
                InputLabelProps={{ shrink: true }}
                required
              />
            </Grid>
            <Grid item xs={12} sm={6}>
              <TextField
                fullWidth
                label="Durée"
                value={trainingForm.duration}
                onChange={(e) => setTrainingForm({...trainingForm, duration: e.target.value})}
                placeholder="ex: 90 min"
                required
              />
            </Grid>
            <Grid item xs={12} sm={6}>
              <FormControl fullWidth>
                <InputLabel>Type de séance</InputLabel>
                <Select
                  value={trainingForm.type}
                  onChange={(e) => setTrainingForm({...trainingForm, type: e.target.value})}
                >
                  <MenuItem value="Technique">Technique</MenuItem>
                  <MenuItem value="Physique">Physique</MenuItem>
                  <MenuItem value="Tactique">Tactique</MenuItem>
                  <MenuItem value="Match">Match amical</MenuItem>
                  <MenuItem value="Récupération">Récupération</MenuItem>
                </Select>
              </FormControl>
            </Grid>
            <Grid item xs={12}>
              <TextField
                fullWidth
                label="Description de la séance"
                value={trainingForm.description}
                onChange={(e) => setTrainingForm({...trainingForm, description: e.target.value})}
                multiline
                rows={3}
                required
              />
            </Grid>
            <Grid item xs={12}>
              <TextField
                fullWidth
                label="Objectifs"
                value={trainingForm.objectives}
                onChange={(e) => setTrainingForm({...trainingForm, objectives: e.target.value})}
                multiline
                rows={2}
                placeholder="Quels sont les objectifs de cette séance ?"
                required
              />
            </Grid>
          </Grid>
        </DialogContent>
        <DialogActions>
          <Button onClick={() => setTrainingDialog(false)}>Annuler</Button>
          <Button onClick={handleCreateTraining} variant="contained">
            Créer la séance
          </Button>
        </DialogActions>
      </Dialog>

      {/* Player Stats Dialog */}
      <Dialog open={statsDialog} onClose={() => setStatsDialog(false)} maxWidth="md" fullWidth>
        <DialogTitle>
          Modifier les Statistiques - {editingPlayerStats?.name}
        </DialogTitle>
        <DialogContent>
          <Grid container spacing={2} sx={{ mt: 1 }}>
            <Grid item xs={12} sm={6} md={4}>
              <TextField
                fullWidth
                type="number"
                label="Buts"
                value={statsForm.goals}
                onChange={(e) => setStatsForm({...statsForm, goals: parseInt(e.target.value) || 0})}
                inputProps={{ min: 0 }}
              />
            </Grid>
            <Grid item xs={12} sm={6} md={4}>
              <TextField
                fullWidth
                type="number"
                label="Passes décisives"
                value={statsForm.assists}
                onChange={(e) => setStatsForm({...statsForm, assists: parseInt(e.target.value) || 0})}
                inputProps={{ min: 0 }}
              />
            </Grid>
            <Grid item xs={12} sm={6} md={4}>
              <TextField
                fullWidth
                type="number"
                label="Tirs"
                value={statsForm.shots}
                onChange={(e) => setStatsForm({...statsForm, shots: parseInt(e.target.value) || 0})}
                inputProps={{ min: 0 }}
              />
            </Grid>
            <Grid item xs={12} sm={6} md={4}>
              <TextField
                fullWidth
                type="number"
                label="Tirs cadrés"
                value={statsForm.shotsOnTarget}
                onChange={(e) => setStatsForm({...statsForm, shotsOnTarget: parseInt(e.target.value) || 0})}
                inputProps={{ min: 0 }}
              />
            </Grid>
            <Grid item xs={12} sm={6} md={4}>
              <TextField
                fullWidth
                type="number"
                label="Passes"
                value={statsForm.passes}
                onChange={(e) => setStatsForm({...statsForm, passes: parseInt(e.target.value) || 0})}
                inputProps={{ min: 0 }}
              />
            </Grid>
            <Grid item xs={12} sm={6} md={4}>
              <TextField
                fullWidth
                type="number"
                label="Passes clés"
                value={statsForm.keyPasses}
                onChange={(e) => setStatsForm({...statsForm, keyPasses: parseInt(e.target.value) || 0})}
                inputProps={{ min: 0 }}
              />
            </Grid>
            <Grid item xs={12} sm={6} md={4}>
              <TextField
                fullWidth
                type="number"
                label="Tacles"
                value={statsForm.tackles}
                onChange={(e) => setStatsForm({...statsForm, tackles: parseInt(e.target.value) || 0})}
                inputProps={{ min: 0 }}
              />
            </Grid>
            <Grid item xs={12} sm={6} md={4}>
              <TextField
                fullWidth
                type="number"
                label="Interceptions"
                value={statsForm.interceptions}
                onChange={(e) => setStatsForm({...statsForm, interceptions: parseInt(e.target.value) || 0})}
                inputProps={{ min: 0 }}
              />
            </Grid>
            <Grid item xs={12} sm={6} md={4}>
              <TextField
                fullWidth
                type="number"
                label="Dégagements"
                value={statsForm.clearances}
                onChange={(e) => setStatsForm({...statsForm, clearances: parseInt(e.target.value) || 0})}
                inputProps={{ min: 0 }}
              />
            </Grid>
            <Grid item xs={12} sm={6} md={4}>
              <TextField
                fullWidth
                type="number"
                label="Dribbles"
                value={statsForm.dribbles}
                onChange={(e) => setStatsForm({...statsForm, dribbles: parseInt(e.target.value) || 0})}
                inputProps={{ min: 0 }}
              />
            </Grid>
            <Grid item xs={12} sm={6} md={4}>
              <TextField
                fullWidth
                type="number"
                label="Fautes commises"
                value={statsForm.foulsCommitted}
                onChange={(e) => setStatsForm({...statsForm, foulsCommitted: parseInt(e.target.value) || 0})}
                inputProps={{ min: 0 }}
              />
            </Grid>
            <Grid item xs={12} sm={6} md={4}>
              <TextField
                fullWidth
                type="number"
                label="Fautes subies"
                value={statsForm.foulsSuffered}
                onChange={(e) => setStatsForm({...statsForm, foulsSuffered: parseInt(e.target.value) || 0})}
                inputProps={{ min: 0 }}
              />
            </Grid>
            <Grid item xs={12} sm={6} md={4}>
              <TextField
                fullWidth
                type="number"
                label="Hors-jeu"
                value={statsForm.offsides}
                onChange={(e) => setStatsForm({...statsForm, offsides: parseInt(e.target.value) || 0})}
                inputProps={{ min: 0 }}
              />
            </Grid>
            <Grid item xs={12} sm={6} md={4}>
              <TextField
                fullWidth
                type="number"
                label="Arrêts"
                value={statsForm.saves}
                onChange={(e) => setStatsForm({...statsForm, saves: parseInt(e.target.value) || 0})}
                inputProps={{ min: 0 }}
              />
            </Grid>
            <Grid item xs={12} sm={6} md={4}>
              <TextField
                fullWidth
                type="number"
                label="Clean sheets"
                value={statsForm.cleanSheets}
                onChange={(e) => setStatsForm({...statsForm, cleanSheets: parseInt(e.target.value) || 0})}
                inputProps={{ min: 0 }}
              />
            </Grid>
            <Grid item xs={12} sm={6} md={4}>
              <TextField
                fullWidth
                type="number"
                label="Minutes jouées"
                value={statsForm.minutesPlayed}
                onChange={(e) => setStatsForm({...statsForm, minutesPlayed: parseInt(e.target.value) || 0})}
                inputProps={{ min: 0 }}
              />
            </Grid>
            <Grid item xs={12} sm={6} md={4}>
              <TextField
                fullWidth
                type="number"
                label="Cartons jaunes"
                value={statsForm.yellowCards}
                onChange={(e) => setStatsForm({...statsForm, yellowCards: parseInt(e.target.value) || 0})}
                inputProps={{ min: 0 }}
              />
            </Grid>
            <Grid item xs={12} sm={6} md={4}>
              <TextField
                fullWidth
                type="number"
                label="Cartons rouges"
                value={statsForm.redCards}
                onChange={(e) => setStatsForm({...statsForm, redCards: parseInt(e.target.value) || 0})}
                inputProps={{ min: 0 }}
              />
            </Grid>
          </Grid>
        </DialogContent>
        <DialogActions>
          <Button onClick={() => {
            setStatsDialog(false);
            setEditingPlayerStats(null);
          }}>Annuler</Button>
          <Button 
            onClick={handleUpdatePlayerStats} 
            variant="contained"
          >
            Enregistrer
          </Button>
        </DialogActions>
      </Dialog>
    </Box>
  );
};

export default CoachPage;
