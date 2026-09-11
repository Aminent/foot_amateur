import { useState, useEffect } from 'react';
import {
  Box, Button, Dialog, DialogTitle, DialogContent, DialogActions,
  Table, TableBody, TableCell, TableHead, TableRow, TextField,
  Typography, Alert
} from '@mui/material';
import { useTournament } from '../../contexts/TournamentContext';

const TournamentsManagement = () => {
  const { tournaments, loading, error, fetchTournaments, createTournament, deleteTournament } = useTournament();
  const [openDialog, setOpenDialog] = useState(false);
  const [newTournament, setNewTournament] = useState({
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

  useEffect(() => {
    fetchTournaments();
  }, [fetchTournaments]);

  const handleCreateTournament = async () => {
    const payload = {
      ...newTournament,
      maxTeams: newTournament.maxTeams ? parseInt(newTournament.maxTeams) : null,
      entryFee: newTournament.entryFee !== '' ? parseFloat(newTournament.entryFee) : null,
      prizePool: newTournament.prizePool !== '' ? parseFloat(newTournament.prizePool) : null
    };
    const result = await createTournament(payload);
    if (result.success) {
      setOpenDialog(false);
      setNewTournament({
        name: '', description: '', startDate: '', endDate: '', maxTeams: '', location: '', rules: '',
        format: 'league', entryFee: '', prizePool: '', registrationDeadline: '', isPublic: true
      });
    }
  };

  const handleDeleteTournament = async (tournamentId) => {
    if (window.confirm('Êtes-vous sûr de vouloir supprimer ce tournoi ?')) {
      await deleteTournament(tournamentId);
    }
  };

  return (
    <Box>
      <Box sx={{ display: 'flex', justifyContent: 'space-between', mb: 2 }}>
        <Typography variant="h5">Gestion des Tournois</Typography>
        <Button variant="contained" onClick={() => setOpenDialog(true)}>
          Créer un tournoi
        </Button>
      </Box>

      {error && (
        <Alert severity="error" sx={{ mb: 2 }}>{error}</Alert>
      )}

      <Table>
        <TableHead>
          <TableRow>
            <TableCell>Nom</TableCell>
            <TableCell>Date début</TableCell>
            <TableCell>Date fin</TableCell>
            <TableCell>Lieu</TableCell>
            <TableCell>Équipes</TableCell>
            <TableCell>Actions</TableCell>
          </TableRow>
        </TableHead>
        <TableBody>
          {(tournaments || []).map((tournament) => (
            <TableRow key={tournament.id}>
              <TableCell>{tournament.name}</TableCell>
              <TableCell>{tournament.startDate ? new Date(tournament.startDate).toLocaleDateString() : '-'}</TableCell>
              <TableCell>{tournament.endDate ? new Date(tournament.endDate).toLocaleDateString() : '-'}</TableCell>
              <TableCell>{tournament.location || '-'}</TableCell>
              <TableCell>{tournament.teams?.length || 0}</TableCell>
              <TableCell>
                <Button 
                  variant="contained" 
                  color="error" 
                  onClick={() => handleDeleteTournament(tournament.id)}
                >
                  Supprimer
                </Button>
              </TableCell>
            </TableRow>
          ))}
        </TableBody>
      </Table>

      <Dialog open={openDialog} onClose={() => setOpenDialog(false)}>
        <DialogTitle>Nouveau Tournoi</DialogTitle>
        <DialogContent>
          <TextField fullWidth label="Nom" value={newTournament.name} onChange={(e) => setNewTournament({ ...newTournament, name: e.target.value })} sx={{ mt: 2 }} />
          <TextField fullWidth label="Description" value={newTournament.description} onChange={(e) => setNewTournament({ ...newTournament, description: e.target.value })} sx={{ mt: 2 }} />
          <TextField fullWidth label="Date de début" type="date" value={newTournament.startDate} onChange={(e) => setNewTournament({ ...newTournament, startDate: e.target.value })} sx={{ mt: 2 }} InputLabelProps={{ shrink: true }} />
          <TextField fullWidth label="Date de fin" type="date" value={newTournament.endDate} onChange={(e) => setNewTournament({ ...newTournament, endDate: e.target.value })} sx={{ mt: 2 }} InputLabelProps={{ shrink: true }} />
          <TextField fullWidth label="Lieu" value={newTournament.location} onChange={(e) => setNewTournament({ ...newTournament, location: e.target.value })} sx={{ mt: 2 }} />
        </DialogContent>
        <DialogActions>
          <Button onClick={() => setOpenDialog(false)}>Annuler</Button>
          <Button onClick={handleCreateTournament} variant="contained">Créer</Button>
        </DialogActions>
      </Dialog>
    </Box>
  );
};

export default TournamentsManagement;