import React from 'react';
import { BrowserRouter, Routes, Route, Navigate } from 'react-router-dom';
import { ThemeProvider, CssBaseline, CircularProgress, Box } from '@mui/material';
import theme from './utils/theme';
import { AuthProvider, useAuth } from './contexts/AuthContext';
import ScoutLayout   from './components/Layout/ScoutLayout';
import Login         from './pages/Login';
import Dashboard     from './pages/Dashboard';
import PlayerSearch  from './pages/PlayerSearch';
import PlayerProfile from './pages/PlayerProfile';
import Watchlist     from './pages/Watchlist';
import Evaluations   from './pages/Evaluations';
import Compare       from './pages/Compare';
import LiveMatches   from './pages/LiveMatches';

const Spinner = () => (
  <Box sx={{ minHeight: '100vh', display: 'flex', alignItems: 'center', justifyContent: 'center', bgcolor: '#0f172a' }}>
    <CircularProgress sx={{ color: '#1d4ed8' }} />
  </Box>
);

const ProtectedRoute = ({ children }) => {
  const { isAuthenticated, loading } = useAuth();
  if (loading) return <Spinner />;
  return isAuthenticated ? children : <Navigate to="/login" replace />;
};

function AppRoutes() {
  const { isAuthenticated, loading } = useAuth();
  if (loading) return <Spinner />;

  return (
    <Routes>
      <Route path="/login" element={isAuthenticated ? <Navigate to="/" replace /> : <Login />} />
      <Route path="/" element={<ProtectedRoute><ScoutLayout /></ProtectedRoute>}>
        <Route index              element={<Dashboard />} />
        <Route path="players"     element={<PlayerSearch />} />
        <Route path="players/:id" element={<PlayerProfile />} />
        <Route path="watchlist"   element={<Watchlist />} />
        <Route path="evaluations" element={<Evaluations />} />
        <Route path="evaluations/new" element={<Evaluations />} />
        <Route path="compare"     element={<Compare />} />
        <Route path="live"        element={<LiveMatches />} />
      </Route>
      <Route path="*" element={<Navigate to="/" replace />} />
    </Routes>
  );
}

export default function App() {
  return (
    <ThemeProvider theme={theme}>
      <CssBaseline />
      <Box sx={{ minHeight: '100vh', background: 'linear-gradient(135deg, #ceeae5 0%, #daf0f5 50%, #e2eef7 100%)', backgroundAttachment: 'fixed' }}>
      <BrowserRouter basename="/scout">
        <AuthProvider>
          <AppRoutes />
        </AuthProvider>
      </BrowserRouter>
      </Box>
    </ThemeProvider>
  );
}
