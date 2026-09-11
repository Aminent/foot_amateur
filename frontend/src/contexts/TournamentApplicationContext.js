import React, { createContext, useContext, useReducer, useCallback, useMemo } from 'react';
import axios from 'axios';

// Initial state
const initialState = {
  applications: [],
  availableTournaments: [],
  loading: false,
  error: null
};

// Action types
const TOURNAMENT_APPLICATION_ACTIONS = {
  SET_LOADING: 'SET_LOADING',
  SET_ERROR: 'SET_ERROR',
  CLEAR_ERROR: 'CLEAR_ERROR',
  SET_APPLICATIONS: 'SET_APPLICATIONS',
  SET_AVAILABLE_TOURNAMENTS: 'SET_AVAILABLE_TOURNAMENTS',
  ADD_APPLICATION: 'ADD_APPLICATION',
  UPDATE_APPLICATION: 'UPDATE_APPLICATION'
};

// Reducer
const tournamentApplicationReducer = (state, action) => {
  switch (action.type) {
    case TOURNAMENT_APPLICATION_ACTIONS.SET_LOADING:
      return { ...state, loading: action.payload };
    case TOURNAMENT_APPLICATION_ACTIONS.SET_ERROR:
      return { ...state, error: action.payload, loading: false };
    case TOURNAMENT_APPLICATION_ACTIONS.CLEAR_ERROR:
      return { ...state, error: null };
    case TOURNAMENT_APPLICATION_ACTIONS.SET_APPLICATIONS:
      return { ...state, applications: action.payload, loading: false };
    case TOURNAMENT_APPLICATION_ACTIONS.SET_AVAILABLE_TOURNAMENTS:
      return { ...state, availableTournaments: action.payload, loading: false };
    case TOURNAMENT_APPLICATION_ACTIONS.ADD_APPLICATION:
      return { 
        ...state, 
        applications: [action.payload, ...state.applications],
        loading: false 
      };
    case TOURNAMENT_APPLICATION_ACTIONS.UPDATE_APPLICATION:
      return {
        ...state,
        applications: state.applications.map(app => 
          app.id === action.payload.id ? action.payload : app
        ),
        loading: false
      };
    default:
      return state;
  }
};

// Create context
const TournamentApplicationContext = createContext();

// Provider component
export const TournamentApplicationProvider = ({ children }) => {
  const [state, dispatch] = useReducer(tournamentApplicationReducer, initialState);

  // Set up axios interceptor for authentication
  axios.interceptors.request.use(
    config => {
      const token = localStorage.getItem('token');
      if (token && !config.headers.Authorization) {
        config.headers.Authorization = `Bearer ${token}`;
      }
      return config;
    },
    error => {
      return Promise.reject(error);
    }
  );

  // Fetch my applications
  const fetchMyApplications = useCallback(async () => {
    try {
      dispatch({ type: TOURNAMENT_APPLICATION_ACTIONS.SET_LOADING, payload: true });
      const response = await axios.get('/tournament-applications');
      dispatch({ 
        type: TOURNAMENT_APPLICATION_ACTIONS.SET_APPLICATIONS, 
        payload: response.data 
      });
    } catch (error) {
      console.error('Error fetching applications:', error);
      dispatch({ 
        type: TOURNAMENT_APPLICATION_ACTIONS.SET_ERROR, 
        payload: error.response?.data?.message || 'Erreur lors du chargement des candidatures' 
      });
    }
  }, []);

  // Fetch available tournaments for a team
  const fetchAvailableTournaments = useCallback(async (teamId) => {
    try {
      dispatch({ type: TOURNAMENT_APPLICATION_ACTIONS.SET_LOADING, payload: true });
      const response = await axios.get(`/tournament-applications/available-tournaments?teamId=${teamId}`);
      dispatch({ 
        type: TOURNAMENT_APPLICATION_ACTIONS.SET_AVAILABLE_TOURNAMENTS, 
        payload: response.data 
      });
    } catch (error) {
      console.error('Error fetching available tournaments:', error);
      dispatch({ 
        type: TOURNAMENT_APPLICATION_ACTIONS.SET_ERROR, 
        payload: error.response?.data?.message || 'Erreur lors du chargement des tournois disponibles' 
      });
    }
  }, []);

  // Apply for a tournament
  const applyForTournament = useCallback(async (teamId, tournamentId) => {
    try {
      dispatch({ type: TOURNAMENT_APPLICATION_ACTIONS.SET_LOADING, payload: true });
      const response = await axios.post('/tournament-applications', {
        teamId,
        tournamentId
      });
      dispatch({ 
        type: TOURNAMENT_APPLICATION_ACTIONS.ADD_APPLICATION, 
        payload: response.data 
      });
      return response.data;
    } catch (error) {
      console.error('Error applying for tournament:', error);
      dispatch({ 
        type: TOURNAMENT_APPLICATION_ACTIONS.SET_ERROR, 
        payload: error.response?.data?.message || 'Erreur lors de la candidature' 
      });
      throw error;
    }
  }, []);

  // Fetch all applications (admin only)
  const fetchAllApplications = useCallback(async () => {
    try {
      dispatch({ type: TOURNAMENT_APPLICATION_ACTIONS.SET_LOADING, payload: true });
      const response = await axios.get('/tournament-applications/admin');
      dispatch({ 
        type: TOURNAMENT_APPLICATION_ACTIONS.SET_APPLICATIONS, 
        payload: response.data 
      });
    } catch (error) {
      console.error('Error fetching all applications:', error);
      dispatch({ 
        type: TOURNAMENT_APPLICATION_ACTIONS.SET_ERROR, 
        payload: error.response?.data?.message || 'Erreur lors du chargement des candidatures' 
      });
    }
  }, []);

  // Review application (admin only)
  const reviewApplication = useCallback(async (applicationId, status, notes) => {
    try {
      dispatch({ type: TOURNAMENT_APPLICATION_ACTIONS.SET_LOADING, payload: true });
      const response = await axios.put(`/tournament-applications/${applicationId}/review`, {
        status,
        notes
      });
      dispatch({ 
        type: TOURNAMENT_APPLICATION_ACTIONS.UPDATE_APPLICATION, 
        payload: response.data 
      });
      return response.data;
    } catch (error) {
      console.error('Error reviewing application:', error);
      dispatch({ 
        type: TOURNAMENT_APPLICATION_ACTIONS.SET_ERROR, 
        payload: error.response?.data?.message || 'Erreur lors de la révision' 
      });
      throw error;
    }
  }, []);

  // Clear error
  const clearError = useCallback(() => {
    dispatch({ type: TOURNAMENT_APPLICATION_ACTIONS.CLEAR_ERROR });
  }, []);

  // Memoized value
  const value = useMemo(() => ({
    ...state,
    fetchMyApplications,
    fetchAvailableTournaments,
    applyForTournament,
    fetchAllApplications,
    reviewApplication,
    clearError
  }), [
    state,
    fetchMyApplications,
    fetchAvailableTournaments,
    applyForTournament,
    fetchAllApplications,
    reviewApplication,
    clearError
  ]);

  return (
    <TournamentApplicationContext.Provider value={value}>
      {children}
    </TournamentApplicationContext.Provider>
  );
};

// Hook to use the context
export const useTournamentApplication = () => {
  const context = useContext(TournamentApplicationContext);
  if (!context) {
    throw new Error('useTournamentApplication must be used within a TournamentApplicationProvider');
  }
  return context;
};
