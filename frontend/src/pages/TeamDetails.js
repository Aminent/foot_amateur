import React, { useState, useEffect, useRef } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import {
  Box,
  Grid,
  Card,
  CardContent,
  Typography,
  Button,
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableRow,
  IconButton,
  Chip,
  Alert,
  Avatar,
  Divider,
  Paper,
  List,
  ListItem,
  ListItemText,
  ListItemIcon,
  Dialog,
  DialogTitle,
  DialogContent,
  DialogActions,
  CircularProgress
} from '@mui/material';
import {
  ArrowBack as ArrowBackIcon,
  Person as PersonIcon,
  EmojiEvents as TrophyIcon,
  Group as GroupIcon,
  Star as StarIcon,
  Sports as SportsIcon,
  Phone as PhoneIcon,
  Email as EmailIcon,
  PhotoCamera as PhotoCameraIcon,
  CloudUpload as CloudUploadIcon
} from '@mui/icons-material';

const TeamDetails = () => {
  const { id } = useParams();
  const navigate = useNavigate();
  const fileInputRef = useRef(null);
  const [team, setTeam] = useState(null);
  const [players, setPlayers] = useState([]);
  const [coach, setCoach] = useState(null);
  const [tournament, setTournament] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');
  const [uploadDialog, setUploadDialog] = useState(false);
  const [uploading, setUploading] = useState(false);
  const [selectedFile, setSelectedFile] = useState(null);
  const [previewUrl, setPreviewUrl] = useState(null);

  useEffect(() => {
    fetchTeamDetails();
  }, [id]);

  const fetchTeamDetails = async () => {
    setLoading(true);
    try {
      const token = localStorage.getItem('token');
      const headers = {
        'Authorization': `Bearer ${token}`,
        'Content-Type': 'application/json'
      };

      // Fetch team details with included players, tournament, and coach
      const teamResponse = await fetch(`${process.env.REACT_APP_API_URL || 'http://localhost:5000/api'}/teams/${id}`, {
        headers
      });
      
      if (!teamResponse.ok) {
        throw new Error('Équipe non trouvée');
      }
      
      const teamData = await teamResponse.json();
      
      const teamInfo = teamData.team || teamData;
      setTeam(teamInfo);

      // Set players from the team data (already included in the backend response)
      if (teamInfo.players && Array.isArray(teamInfo.players) && teamInfo.players.length > 0) {
        setPlayers(teamInfo.players);
      } else {
        // Fallback: fetch players separately if not included in team response
        try {
          const playersResponse = await fetch(`${process.env.REACT_APP_API_URL || 'http://localhost:5000/api'}/players`, {
            headers
          });
          
          if (playersResponse.ok) {
            const playersData = await playersResponse.json();
            const allPlayers = playersData.players || playersData || [];
            
            // Convert id to number for comparison since URL params are strings
            const teamIdNumber = parseInt(id, 10);
            const teamPlayers = allPlayers.filter(p => p.teamId === teamIdNumber);
            
            setPlayers(teamPlayers);
          }
        } catch (playerError) {
          console.error('Error fetching players separately:', playerError);
          setPlayers([]);
        }
      }

      // Set coach from the team data (already included in the backend response)
      if (teamInfo.coach) {
        setCoach(teamInfo.coach);
      } else {
        // Fallback: fetch coach separately if not included in team response
        try {
          const coachesResponse = await fetch(`${process.env.REACT_APP_API_URL || 'http://localhost:5000/api'}/coaches`, {
            headers
          });
          
          if (coachesResponse.ok) {
            const coachesData = await coachesResponse.json();
            const allCoaches = coachesData.coaches || coachesData || [];
            const teamIdNumber = parseInt(id, 10);
            const teamCoach = allCoaches.find(c => c.teamId === teamIdNumber);
            
            if (teamCoach) {
              setCoach(teamCoach);
            }
          }
        } catch (coachError) {
          console.error('Error fetching coach separately:', coachError);
        }
      }

      // Set tournament from the team data (already included in the backend response)
      if (teamInfo.tournament) {
        setTournament(teamInfo.tournament);
      }

    } catch (error) {
      console.error('Error fetching team details:', error);
      setError('Erreur lors du chargement des détails de l\'équipe');
    } finally {
      setLoading(false);
    }
  };

  const handleFileSelect = (event) => {
    const file = event.target.files[0];
    if (file) {
      // Validate file type
      if (!file.type.startsWith('image/')) {
        setError('Veuillez sélectionner un fichier image');
        return;
      }
      
      // Validate file size (5MB max)
      if (file.size > 5 * 1024 * 1024) {
        setError('La taille du fichier ne doit pas dépasser 5MB');
        return;
      }
      
      setSelectedFile(file);
      
      // Create preview URL
      const reader = new FileReader();
      reader.onload = (e) => {
        setPreviewUrl(e.target.result);
      };
      reader.readAsDataURL(file);
      
      setUploadDialog(true);
    }
  };

  const handlePhotoUpload = async () => {
    if (!selectedFile) return;
    
    setUploading(true);
    setError(''); // Clear previous errors
    
    try {
      const token = localStorage.getItem('token');

      const formData = new FormData();
      formData.append('photo', selectedFile);

      const uploadUrl = `${process.env.REACT_APP_API_URL || 'http://localhost:5000'}/api/uploads/team/${id}/photo`;

      const response = await fetch(uploadUrl, {
        method: 'POST',
        headers: {
          'Authorization': `Bearer ${token}`
        },
        body: formData
      });
      
      if (response.ok) {
        const data = await response.json();
        
        // Update team state with new photo
        setTeam(prev => ({ ...prev, logo: data.url }));
        
        // Close dialog and reset states
        setUploadDialog(false);
        setSelectedFile(null);
        setPreviewUrl(null);
        
        // Optionally refresh team details
        await fetchTeamDetails();
      } else {
        const errorData = await response.json();
        console.error('Upload error response:', errorData);
        setError(`Erreur lors du téléchargement: ${errorData.message || errorData.error || 'Erreur inconnue'}`);
      }
    } catch (error) {
      console.error('Photo upload network error:', error);
      setError(`Erreur réseau: ${error.message}`);
    } finally {
      setUploading(false);
    }
  };

  const handleUploadCancel = () => {
    setUploadDialog(false);
    setSelectedFile(null);
    setPreviewUrl(null);
    if (fileInputRef.current) {
      fileInputRef.current.value = '';
    }
  };

  const getPositionLabel = (position) => {
    switch (position) {
      case 'gardien': return 'Gardien';
      case 'defenseur': return 'Défenseur';
      case 'milieu': return 'Milieu';
      case 'attaquant': return 'Attaquant';
      default: return position || 'Non défini';
    }
  };

  const getPositionColor = (position) => {
    switch (position) {
      case 'gardien': return 'warning';
      case 'defenseur': return 'primary';
      case 'milieu': return 'success';
      case 'attaquant': return 'error';
      default: return 'default';
    }
  };

  const getStatusColor = (status) => {
    switch (status) {
      case 'draft': return 'default';
      case 'active': return 'success';
      case 'completed': return 'info';
      case 'cancelled': return 'error';
      default: return 'default';
    }
  };

  const getStatusLabel = (status) => {
    switch (status) {
      case 'draft': return 'Brouillon';
      case 'active': return 'Actif';
      case 'completed': return 'Terminé';
      case 'cancelled': return 'Annulé';
      default: return status;
    }
  };

  if (loading) {
    return (
      <Box sx={{ p: 3, textAlign: 'center' }}>
        <Typography>Chargement...</Typography>
      </Box>
    );
  }

  if (error || !team) {
    return (
      <Box sx={{ p: 3 }}>
        <Alert severity="error" sx={{ mb: 2 }}>
          {error || 'Équipe non trouvée'}
        </Alert>
        <Button
          startIcon={<ArrowBackIcon />}
          onClick={() => navigate('/admin')}
          variant="contained"
        >
          Retour à l'administration
        </Button>
      </Box>
    );
  }

  const captain = players.find(p => p.isCaptain);
  const playersByPosition = {
    gardien: players.filter(p => p.position === 'gardien'),
    defenseur: players.filter(p => p.position === 'defenseur'),
    milieu: players.filter(p => p.position === 'milieu'),
    attaquant: players.filter(p => p.position === 'attaquant'),
    undefined: players.filter(p => !p.position)
  };

  return (
    <Box sx={{ p: 3 }}>
      {/* Header */}
      <Box sx={{ display: 'flex', alignItems: 'center', mb: 3 }}>
        <Button
          startIcon={<ArrowBackIcon />}
          onClick={() => navigate('/admin')}
          sx={{ mr: 2 }}
        >
          Retour
        </Button>
        
        {/* Team Photo */}
        <Box sx={{ mr: 3, position: 'relative' }}>
          <Avatar
            src={team.logo ? `${process.env.REACT_APP_API_URL || 'http://localhost:5000'}${team.logo}` : undefined}
            sx={{ 
              width: 80, 
              height: 80, 
              bgcolor: 'primary.main',
              fontSize: '2rem',
              border: '3px solid',
              borderColor: 'primary.light',
              '& img': {
                objectFit: 'cover',
                width: '100%',
                height: '100%'
              }
            }}
          >
            {!team.logo && team.name.charAt(0).toUpperCase()}
          </Avatar>
          <IconButton
            sx={{
              position: 'absolute',
              bottom: -5,
              right: -5,
              bgcolor: 'primary.main',
              color: 'white',
              width: 30,
              height: 30,
              '&:hover': {
                bgcolor: 'primary.dark'
              }
            }}
            onClick={() => fileInputRef.current?.click()}
          >
            <PhotoCameraIcon sx={{ fontSize: 16 }} />
          </IconButton>
        </Box>
        
        <Typography variant="h4" sx={{ flexGrow: 1, fontWeight: 'bold' }}>
          ⚽ {team.name}
        </Typography>
        
        {/* Hidden file input */}
        <input
          ref={fileInputRef}
          type="file"
          accept="image/*"
          style={{ display: 'none' }}
          onChange={handleFileSelect}
        />
      </Box>

      {/* Team Overview Cards */}
      <Grid container spacing={3} sx={{ mb: 4 }}>
        <Grid item xs={12} md={3}>
          <Card>
            <CardContent>
              <Box sx={{ display: 'flex', alignItems: 'center' }}>
                <GroupIcon sx={{ fontSize: 40, color: 'primary.main', mr: 2 }} />
                <Box>
                  <Typography variant="h4" component="div">
                    {players.length}
                  </Typography>
                  <Typography color="text.secondary">
                    Joueurs
                  </Typography>
                </Box>
              </Box>
            </CardContent>
          </Card>
        </Grid>
        <Grid item xs={12} md={3}>
          <Card>
            <CardContent>
              <Box sx={{ display: 'flex', alignItems: 'center' }}>
                <StarIcon sx={{ fontSize: 40, color: 'warning.main', mr: 2 }} />
                <Box>
                  <Typography variant="h6" component="div">
                    {captain?.name || 'Aucun'}
                  </Typography>
                  <Typography color="text.secondary">
                    Capitaine
                  </Typography>
                </Box>
              </Box>
            </CardContent>
          </Card>
        </Grid>
        <Grid item xs={12} md={3}>
          <Card>
            <CardContent>
              <Box sx={{ display: 'flex', alignItems: 'center' }}>
                <PersonIcon sx={{ fontSize: 40, color: 'success.main', mr: 2 }} />
                <Box>
                  <Typography variant="h6" component="div">
                    {coach?.name || 'Non assigné'}
                  </Typography>
                  <Typography color="text.secondary">
                    Entraîneur
                  </Typography>
                </Box>
              </Box>
            </CardContent>
          </Card>
        </Grid>
        <Grid item xs={12} md={3}>
          <Card>
            <CardContent>
              <Box sx={{ display: 'flex', alignItems: 'center' }}>
                <TrophyIcon sx={{ fontSize: 40, color: 'info.main', mr: 2 }} />
                <Box>
                  <Typography variant="h6" component="div">
                    {tournament?.name || 'Aucun'}
                  </Typography>
                  <Typography color="text.secondary">
                    Tournoi
                  </Typography>
                </Box>
              </Box>
            </CardContent>
          </Card>
        </Grid>
      </Grid>

      <Grid container spacing={3}>
        {/* Team Information */}
        <Grid item xs={12} md={4}>
          <Card>
            <CardContent>
              <Typography variant="h6" gutterBottom>
                📋 Informations de l'équipe
              </Typography>
              <Divider sx={{ mb: 2 }} />
              
              {/* Team Photo Display */}
              {team.logo && (
                <Box sx={{ textAlign: 'center', mb: 3 }}>
                  <img
                    src={`${process.env.REACT_APP_API_URL || 'http://localhost:5000'}${team.logo}`}
                    alt={`Logo de ${team.name}`}
                    style={{
                      maxWidth: '100%',
                      maxHeight: '200px',
                      borderRadius: '8px',
                      border: '2px solid #e0e0e0',
                      objectFit: 'contain',
                      backgroundColor: '#f5f5f5'
                    }}
                  />
                  <Typography variant="caption" display="block" sx={{ mt: 1, color: 'text.secondary' }}>
                    Logo de l'équipe
                  </Typography>
                </Box>
              )}
              
              <List dense>
                <ListItem>
                  <ListItemIcon>
                    <GroupIcon />
                  </ListItemIcon>
                  <ListItemText
                    primary="Nom de l'équipe"
                    secondary={team.name}
                  />
                </ListItem>
                
                {team.description && (
                  <ListItem>
                    <ListItemText
                      primary="Description"
                      secondary={team.description}
                    />
                  </ListItem>
                )}
                
                {tournament && (
                  <>
                    <ListItem>
                      <ListItemIcon>
                        <TrophyIcon />
                      </ListItemIcon>
                      <ListItemText
                        primary="Tournoi"
                        secondary={tournament.name}
                      />
                    </ListItem>
                    
                    <ListItem>
                      <ListItemText
                        primary="Statut du tournoi"
                        secondary={
                          <Chip 
                            label={getStatusLabel(tournament.status)} 
                            color={getStatusColor(tournament.status)}
                            size="small"
                          />
                        }
                      />
                    </ListItem>
                  </>
                )}
                
                {coach && (
                  <>
                    <ListItem>
                      <ListItemIcon>
                        <PersonIcon />
                      </ListItemIcon>
                      <ListItemText
                        primary="Entraîneur"
                        secondary={coach.name}
                      />
                    </ListItem>
                    
                    {coach.email && (
                      <ListItem>
                        <ListItemIcon>
                          <EmailIcon />
                        </ListItemIcon>
                        <ListItemText
                          primary="Email de l'entraîneur"
                          secondary={coach.email}
                        />
                      </ListItem>
                    )}
                    
                    {coach.phone && (
                      <ListItem>
                        <ListItemIcon>
                          <PhoneIcon />
                        </ListItemIcon>
                        <ListItemText
                          primary="Téléphone de l'entraîneur"
                          secondary={coach.phone}
                        />
                      </ListItem>
                    )}
                  </>
                )}
              </List>
            </CardContent>
          </Card>
        </Grid>

        {/* Players List */}
        <Grid item xs={12} md={8}>
          <Card>
            <CardContent>
              <Typography variant="h6" gutterBottom>
                👥 Liste des joueurs ({players.length})
              </Typography>
              <Divider sx={{ mb: 2 }} />
              
              {players.length === 0 ? (
                <Typography color="text.secondary" sx={{ textAlign: 'center', py: 3 }}>
                  Aucun joueur dans cette équipe
                </Typography>
              ) : (
                <Table>
                  <TableHead>
                    <TableRow>
                      <TableCell>Nom</TableCell>
                      <TableCell>Position</TableCell>
                      <TableCell>N° Maillot</TableCell>
                      <TableCell>Capitaine</TableCell>
                      <TableCell>Contact</TableCell>
                    </TableRow>
                  </TableHead>
                  <TableBody>
                    {players.map((player) => (
                      <TableRow
                        key={player.id}
                        hover
                        onClick={() => navigate(`/admin/players/${player.id}`)}
                        sx={{ cursor: 'pointer' }}
                      >
                        <TableCell>
                          <Box sx={{ display: 'flex', alignItems: 'center' }}>
                            <Avatar sx={{ mr: 2, bgcolor: 'primary.main' }}>
                              {player.name.charAt(0).toUpperCase()}
                            </Avatar>
                            <Box>
                              <Typography sx={{ fontWeight: 600, fontSize: 14 }}>{player.name}</Typography>
                              <Typography variant="caption" color="text.secondary">Voir le profil →</Typography>
                            </Box>
                          </Box>
                        </TableCell>
                        <TableCell>
                          <Chip
                            label={getPositionLabel(player.position)}
                            color={getPositionColor(player.position)}
                            size="small"
                            icon={<SportsIcon />}
                          />
                        </TableCell>
                        <TableCell>
                          {player.jerseyNumber ? (
                            <Chip
                              label={`#${player.jerseyNumber}`}
                              variant="outlined"
                              size="small"
                            />
                          ) : '-'}
                        </TableCell>
                        <TableCell>
                          {player.isCaptain ? (
                            <Chip
                              label="Capitaine"
                              color="warning"
                              size="small"
                              icon={<StarIcon />}
                            />
                          ) : '-'}
                        </TableCell>
                        <TableCell>
                          <Box>
                            {player.email && (
                              <Typography variant="caption" display="block">
                                📧 {player.email}
                              </Typography>
                            )}
                            {player.phone && (
                              <Typography variant="caption" display="block">
                                📞 {player.phone}
                              </Typography>
                            )}
                            {!player.email && !player.phone && '-'}
                          </Box>
                        </TableCell>
                      </TableRow>
                    ))}
                  </TableBody>
                </Table>
              )}
            </CardContent>
          </Card>
        </Grid>

        {/* Players by Position */}
        {players.length > 0 && (
          <Grid item xs={12}>
            <Card>
              <CardContent>
                <Typography variant="h6" gutterBottom>
                  🏟️ Répartition par poste
                </Typography>
                <Divider sx={{ mb: 2 }} />
                
                <Grid container spacing={2}>
                  {Object.entries(playersByPosition).map(([position, positionPlayers]) => {
                    if (positionPlayers.length === 0 && position !== 'undefined') return null;
                    
                    return (
                      <Grid item xs={12} sm={6} md={3} key={position}>
                        <Paper sx={{ p: 2, textAlign: 'center' }}>
                          <Typography variant="subtitle1" gutterBottom>
                            {getPositionLabel(position)}
                          </Typography>
                          <Typography variant="h4" color="primary">
                            {positionPlayers.length}
                          </Typography>
                          <Typography variant="caption" color="text.secondary">
                            joueur{positionPlayers.length > 1 ? 's' : ''}
                          </Typography>
                        </Paper>
                      </Grid>
                    );
                  })}
                </Grid>
              </CardContent>
            </Card>
          </Grid>
        )}
      </Grid>

      {/* Photo Upload Dialog */}
      <Dialog open={uploadDialog} onClose={handleUploadCancel} maxWidth="sm" fullWidth>
        <DialogTitle>
          📸 Télécharger une photo pour {team.name}
        </DialogTitle>
        <DialogContent>
          {previewUrl && (
            <Box sx={{ textAlign: 'center', mb: 2 }}>
              <img
                src={previewUrl}
                alt="Aperçu"
                style={{
                  maxWidth: '100%',
                  maxHeight: '300px',
                  borderRadius: '8px',
                  border: '2px solid #e0e0e0',
                  objectFit: 'contain',
                  backgroundColor: '#f5f5f5'
                }}
              />
              <Typography variant="caption" display="block" sx={{ mt: 1, color: 'text.secondary' }}>
                Aperçu de la photo
              </Typography>
            </Box>
          )}
          
          {selectedFile && (
            <Box sx={{ mb: 2 }}>
              <Typography variant="body2" color="text.secondary">
                📁 Fichier sélectionné: {selectedFile.name}
              </Typography>
              <Typography variant="body2" color="text.secondary">
                📏 Taille: {(selectedFile.size / 1024 / 1024).toFixed(2)} MB
              </Typography>
            </Box>
          )}
          
          <Typography variant="body2" color="text.secondary" sx={{ mt: 2 }}>
            Formats acceptés: JPEG, PNG, GIF, WebP (max. 5MB)
          </Typography>
        </DialogContent>
        <DialogActions>
          <Button onClick={handleUploadCancel} disabled={uploading}>
            Annuler
          </Button>
          <Button
            onClick={handlePhotoUpload}
            variant="contained"
            disabled={!selectedFile || uploading}
            startIcon={uploading ? <CircularProgress size={20} /> : <CloudUploadIcon />}
          >
            {uploading ? 'Téléchargement...' : 'Télécharger'}
          </Button>
        </DialogActions>
      </Dialog>
    </Box>
  );
};

export default TeamDetails;
