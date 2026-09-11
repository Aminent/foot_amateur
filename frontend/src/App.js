import React from 'react';
import { Routes, Route, Navigate } from 'react-router-dom';
import { Box } from '@mui/material';
import { AuthProvider } from './contexts/AuthContext';
import { TournamentProvider } from './contexts/TournamentContext';
import { TeamProvider } from './contexts/TeamContext';
import { PlayerProvider } from './contexts/PlayerContext';
import { CoachProvider } from './contexts/CoachContext';
import { TournamentApplicationProvider } from './contexts/TournamentApplicationContext';
import ProtectedRoute from './components/Auth/ProtectedRoute';
import AdminLayout from './components/Layout/AdminLayout';
import Login from './pages/Login';
import Register from './pages/Register';
import AdminDashboard from './pages/AdminDashboard';
import TeamDetails from './pages/TeamDetails';
import PlayerDetails from './pages/PlayerDetails';
import TournamentDetails from './pages/TournamentDetails';
import PlayerPage from './pages/PlayerPage';
import CoachPage from './pages/CoachPage';
import LiveMatch from './pages/LiveMatch';

function App() {
  return (
    <AuthProvider>
      <PlayerProvider>
        <TeamProvider>
          <TournamentProvider>
            <CoachProvider>
              <TournamentApplicationProvider>
                <Box sx={{ minHeight: '100vh', backgroundColor: 'background.default' }}>
                  <Routes>

                    {/* ── Racine → Login ───────────────────────────────────────── */}
                    <Route path="/" element={<Navigate to="/login" replace />} />
                    <Route path="/login"    element={<Login />} />
                    <Route path="/register" element={<Register />} />

                    {/* ── Admin ────────────────────────────────────────────────── */}
                    <Route path="/admin" element={
                      <ProtectedRoute requiredRole="admin">
                        <AdminLayout />
                      </ProtectedRoute>
                    }>
                      <Route index element={<AdminDashboard />} />
                      <Route path="tournaments/:id" element={<TournamentDetails />} />
                      <Route path="teams/:id"       element={<TeamDetails />} />
                      <Route path="players/:id"     element={<PlayerDetails />} />
                      <Route path="matches/:id/live" element={<LiveMatch />} />
                    </Route>

                    {/* ── Joueur / Coach ───────────────────────────────────────── */}
                    <Route path="/player" element={
                      <ProtectedRoute requiredRole={['joueur', 'admin']}>
                        <PlayerPage />
                      </ProtectedRoute>
                    } />
                    <Route path="/coach" element={
                      <ProtectedRoute requiredRole={['coach', 'admin']}>
                        <CoachPage />
                      </ProtectedRoute>
                    } />

                    {/* ── Fallback ─────────────────────────────────────────────── */}
                    <Route path="*" element={<Navigate to="/login" replace />} />

                  </Routes>
                </Box>
              </TournamentApplicationProvider>
            </CoachProvider>
          </TournamentProvider>
        </TeamProvider>
      </PlayerProvider>
    </AuthProvider>
  );
}

export default App;
