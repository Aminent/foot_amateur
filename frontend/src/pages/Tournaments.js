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
  Fab,
  Dialog,
  DialogTitle,
  DialogContent,
  DialogActions,
  TextField,
  FormControl,
  InputLabel,
  Select,
  MenuItem,
  Alert,
  CircularProgress,
  FormControlLabel,
  Switch
} from '@mui/material';

import {
  Add as AddIcon,
  EmojiEvents as TournamentIcon,
  Group as TeamIcon,
  SportsSoccer as MatchIcon,
  Edit as EditIcon,
  Delete as DeleteIcon
} from '@mui/icons-material';
import { useNavigate } from 'react-router-dom';
import { useAuth } from '../contexts/AuthContext';
import { useTournament } from '../contexts/TournamentContext';

const Tournaments = () => {
  const { user } = useAuth();
  const { tournaments, loading, error, fetchTournaments, createTournament, deleteTournament } = useTournament();
  const navigate = useNavigate();
  const [openDialog, setOpenDialog] = useState(false);
  const [formData, setFormData] = useState({
    name: '',
    description: '',
    startDate: '',
    endDate: '',
    maxTeams: '',
    location: '',
    rules: '',
    format: 'league',
    entryFee: '',
    prizePool: '',
    registrationDeadline: '',
    isPublic: true
  });
  const [formErrors, setFormErrors] = useState({});

  useEffect(() => {
    fetchTournaments();
  }, [fetchTournaments]); // Add fetchTournaments to dependencies

  const handleOpenDialog = () => {
    setOpenDialog(true);
    setFormData({
      name: '',
      description: '',
      startDate: '',
      endDate: '',
      maxTeams: '',
      location: '',
      rules: '',
      format: 'league',
      entryFee: '',
      prizePool: '',
      registrationDeadline: '',
      isPublic: true
    });
    setFormErrors({});
  };

  const handleCloseDialog = () => {
    setOpenDialog(false);
  };

  const handleFormChange = (e) => {
    const { name, value } = e.target;
    setFormData(prev => ({
      ...prev,
      [name]: value
    }));
    if (formErrors[name]) {
      setFormErrors(prev => ({
        ...prev,
        [name]: ''
      }));
    }
  };

  const validateForm = () => {
    const errors = {};

    if (!formData.name.trim()) {
      errors.name = 'Nom requis';
    }

    if (!formData.startDate) {
      errors.startDate = 'Date de début requise';
    }

    if (!formData.endDate) {
      errors.endDate = 'Date de fin requise';
    } else if (formData.startDate && formData.endDate <= formData.startDate) {
      errors.endDate = 'La date de fin doit être postérieure à la date de début';
    }

    if (formData.maxTeams && (formData.maxTeams < 2 || formData.maxTeams > 100)) {
      errors.maxTeams = 'Le nombre d\'équipes doit être entre 2 et 100';
    }

    if (formData.entryFee !== '' && Number(formData.entryFee) < 0) {
      errors.entryFee = 'Les frais d\'inscription doivent être positifs';
    }

    if (formData.prizePool !== '' && Number(formData.prizePool) < 0) {
      errors.prizePool = 'La cagnotte doit être positive';
    }

    setFormErrors(errors);
    return Object.keys(errors).length === 0;
  };

  const handleSubmit = async () => {
    if (!validateForm()) {
      return;
    }

    const result = await createTournament({
      ...formData,
      maxTeams: formData.maxTeams ? parseInt(formData.maxTeams) : null,
      entryFee: formData.entryFee !== '' ? parseFloat(formData.entryFee) : null,
      prizePool: formData.prizePool !== '' ? parseFloat(formData.prizePool) : null
    });

    if (result.success) {
      handleCloseDialog();
    }
  };

  const handleDelete = async (tournamentId) => {
    if (window.confirm('Êtes-vous sûr de vouloir supprimer ce tournoi ?')) {
      await deleteTournament(tournamentId);
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
    return (
      <Box sx={{ display: 'flex', justifyContent: 'center', alignItems: 'center', minHeight: '50vh' }}>
        <CircularProgress />
      </Box>
    );
  }

  return (
    <Box>
      {/* En-tête */}
      <Box sx={{ mb: 4, display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
        <Box>
          <Typography variant="h4" component="h1" gutterBottom>
            Tournois
          </Typography>
          <Typography variant="body1" color="text.secondary">
            Gérez vos tournois de football amateur
          </Typography>
        </Box>
        {(user?.role === 'admin' || user?.role === 'coach') && (
          <Fab
            color="primary"
            aria-label="add"
            onClick={handleOpenDialog}
            sx={{ ml: 2 }}
          >
            <AddIcon />
          </Fab>
        )}
      </Box>

      {/* Message d'erreur */}
      {error && (
        <Alert severity="error" sx={{ mb: 3 }}>
          {error}
        </Alert>
      )}

      {/* Liste des tournois */}
      <Grid container spacing={3}>
        {tournaments.length > 0 ? (
          tournaments.map((tournament) => (
            <Grid item xs={12} sm={6} md={4} key={tournament.id}>
              <Card 
                sx={{ 
                  height: '100%', 
                  cursor: 'pointer',
                  '&:hover': {
                    boxShadow: 6,
                    transform: 'translateY(-2px)',
                    transition: 'all 0.3s ease'
                  }
                }}
                onClick={() => navigate(`/tournaments/${tournament.id}`)}
              >
                <CardContent>
                  <Box sx={{ display: 'flex', alignItems: 'center', mb: 2 }}>
                    <Avatar sx={{ bgcolor: 'primary.main', mr: 2 }}>
                      <TournamentIcon />
                    </Avatar>
                    <Box sx={{ flexGrow: 1 }}>
                      <Typography variant="h6" component="h2" noWrap>
                        {tournament.name}
                      </Typography>
                      <Chip
                        label={getStatusLabel(tournament.status)}
                        color={getStatusColor(tournament.status)}
                        size="small"
                      />
                    </Box>
                  </Box>

                  {tournament.description && (
                    <Typography variant="body2" color="text.secondary" sx={{ mb: 2 }}>
                      {tournament.description.length > 100
                        ? `${tournament.description.substring(0, 100)}...`
                        : tournament.description}
                    </Typography>
                  )}

                  <Box sx={{ mb: 2 }}>
                    <Typography variant="body2" color="text.secondary">
                      📅 {new Date(tournament.startDate).toLocaleDateString('fr-FR')} - {new Date(tournament.endDate).toLocaleDateString('fr-FR')}
                    </Typography>
                    {tournament.location && (
                      <Typography variant="body2" color="text.secondary">
                        📍 {tournament.location}
                      </Typography>
                    )}
                  </Box>

                  <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', mb: 2 }}>
                    <Box sx={{ display: 'flex', alignItems: 'center' }}>
                      <TeamIcon sx={{ fontSize: 16, mr: 0.5, color: 'text.secondary' }} />
                      <Typography variant="body2" color="text.secondary">
                        {tournament.teams?.length || 0} équipes
                      </Typography>
                    </Box>
                    <Box sx={{ display: 'flex', alignItems: 'center' }}>
                      <MatchIcon sx={{ fontSize: 16, mr: 0.5, color: 'text.secondary' }} />
                      <Typography variant="body2" color="text.secondary">
                        {tournament.matches?.length || 0} matchs
                      </Typography>
                    </Box>
                  </Box>

                  {/* Actions pour les administrateurs et coaches */}
                  {(user?.role === 'admin' || user?.role === 'coach') && (
                    <Box sx={{ display: 'flex', gap: 1 }}>
                      <Button
                        size="small"
                        startIcon={<EditIcon />}
                        onClick={(e) => {
                          e.stopPropagation();
                          // TODO: Implémenter l'édition
                        }}
                      >
                        Modifier
                      </Button>
                      {user?.role === 'admin' && (
                        <Button
                          size="small"
                          color="error"
                          startIcon={<DeleteIcon />}
                          onClick={(e) => {
                            e.stopPropagation();
                            handleDelete(tournament.id);
                          }}
                        >
                          Supprimer
                        </Button>
                      )}
                    </Box>
                  )}
                </CardContent>
              </Card>
            </Grid>
          ))
        ) : (
          <Grid item xs={12}>
            <Card>
              <CardContent sx={{ textAlign: 'center', py: 4 }}>
                <TournamentIcon sx={{ fontSize: 64, color: 'text.secondary', mb: 2 }} />
                <Typography variant="h6" color="text.secondary" gutterBottom>
                  Aucun tournoi
                </Typography>
                <Typography variant="body2" color="text.secondary">
                  Commencez par créer votre premier tournoi !
                </Typography>
                {(user?.role === 'admin' || user?.role === 'coach') && (
                  <Button
                    variant="contained"
                    startIcon={<AddIcon />}
                    onClick={handleOpenDialog}
                    sx={{ mt: 2 }}
                  >
                    Créer un tournoi
                  </Button>
                )}
              </CardContent>
            </Card>
          </Grid>
        )}
      </Grid>

      {/* Dialog de création */}
      <Dialog open={openDialog} onClose={handleCloseDialog} maxWidth="md" fullWidth>
        <DialogTitle>Créer un nouveau tournoi</DialogTitle>
        <DialogContent>
          <Grid container spacing={2} sx={{ mt: 1 }}>
            <Grid item xs={12}>
              <TextField
                fullWidth
                label="Nom du tournoi"
                name="name"
                value={formData.name}
                onChange={handleFormChange}
                error={!!formErrors.name}
                helperText={formErrors.name}
                required
              />
            </Grid>
            <Grid item xs={12}>
              <TextField
                fullWidth
                label="Description"
                name="description"
                value={formData.description}
                onChange={handleFormChange}
                multiline
                rows={3}
              />
            </Grid>
            <Grid item xs={12} sm={6}>
              <TextField
                fullWidth
                label="Date de début"
                name="startDate"
                type="date"
                value={formData.startDate}
                onChange={handleFormChange}
                error={!!formErrors.startDate}
                helperText={formErrors.startDate}
                InputLabelProps={{ shrink: true }}
                required
              />
            </Grid>
            <Grid item xs={12} sm={6}>
              <TextField
                fullWidth
                label="Date de fin"
                name="endDate"
                type="date"
                value={formData.endDate}
                onChange={handleFormChange}
                error={!!formErrors.endDate}
                helperText={formErrors.endDate}
                InputLabelProps={{ shrink: true }}
                required
              />
            </Grid>
            <Grid item xs={12} sm={6}>
              <TextField
                fullWidth
                label="Nombre maximum d'équipes"
                name="maxTeams"
                type="number"
                value={formData.maxTeams}
                onChange={handleFormChange}
                error={!!formErrors.maxTeams}
                helperText={formErrors.maxTeams}
                inputProps={{ min: 2, max: 100 }}
              />
            </Grid>
            <Grid item xs={12} sm={6}>
              <TextField
                fullWidth
                label="Lieu"
                name="location"
                value={formData.location}
                onChange={handleFormChange}
              />
            </Grid>
            <Grid item xs={12} sm={6}>
              <FormControl fullWidth>
                <InputLabel id="format-label">Format</InputLabel>
                <Select
                  labelId="format-label"
                  label="Format"
                  name="format"
                  value={formData.format}
                  onChange={handleFormChange}
                >
                  <MenuItem value="league">Championnat</MenuItem>
                  <MenuItem value="knockout">Élimination directe</MenuItem>
                  <MenuItem value="group_then_knockout">Poules puis élimination</MenuItem>
                </Select>
              </FormControl>
            </Grid>
            <Grid item xs={12} sm={6}>
              <TextField
                fullWidth
                label="Date limite d'inscription"
                name="registrationDeadline"
                type="date"
                value={formData.registrationDeadline}
                onChange={handleFormChange}
                InputLabelProps={{ shrink: true }}
              />
            </Grid>
            <Grid item xs={12} sm={6}>
              <TextField
                fullWidth
                label="Frais d'inscription (€)"
                name="entryFee"
                type="number"
                value={formData.entryFee}
                onChange={handleFormChange}
                error={!!formErrors.entryFee}
                helperText={formErrors.entryFee}
                inputProps={{ min: 0, step: 0.01 }}
              />
            </Grid>
            <Grid item xs={12} sm={6}>
              <TextField
                fullWidth
                label="Cagnotte (€)"
                name="prizePool"
                type="number"
                value={formData.prizePool}
                onChange={handleFormChange}
                error={!!formErrors.prizePool}
                helperText={formErrors.prizePool}
                inputProps={{ min: 0, step: 0.01 }}
              />
            </Grid>
            <Grid item xs={12}>
              <TextField
                fullWidth
                label="Règles (optionnel)"
                name="rules"
                value={formData.rules}
                onChange={handleFormChange}
                multiline
                rows={4}
              />
            </Grid>
            <Grid item xs={12}>
              <FormControlLabel
                control={
                  <Switch
                    checked={!!formData.isPublic}
                    onChange={(e) => setFormData(prev => ({ ...prev, isPublic: e.target.checked }))}
                    name="isPublic"
                  />
                }
                label="Tournoi public"
              />
            </Grid>
          </Grid>
        </DialogContent>
        <DialogActions>
          <Button onClick={handleCloseDialog}>Annuler</Button>
          <Button onClick={handleSubmit} variant="contained">
            Créer le tournoi
          </Button>
        </DialogActions>
      </Dialog>
    </Box>
  );
};

export default Tournaments;