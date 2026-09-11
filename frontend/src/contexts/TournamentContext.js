import React, { createContext, useContext, useReducer, useCallback, useMemo } from 'react';
import axios from 'axios';

// Add these constants at the top of the file after imports
const MAX_RETRIES = 3;
const RETRY_DELAY = 1000;

// État initial
const initialState = {
  tournaments: [],
  pagination: { page: 1, limit: 20, total: 0, totalPages: 1 },
  currentTournament: null,
  loading: false,
  error: null
};

// Types d'actions
const TOURNAMENT_ACTIONS = {
  FETCH_START: 'FETCH_START',
  FETCH_SUCCESS: 'FETCH_SUCCESS',
  FETCH_FAILURE: 'FETCH_FAILURE',
  CREATE_SUCCESS: 'CREATE_SUCCESS',
  UPDATE_SUCCESS: 'UPDATE_SUCCESS',
  DELETE_SUCCESS: 'DELETE_SUCCESS',
  SET_CURRENT: 'SET_CURRENT',
  CLEAR_ERROR: 'CLEAR_ERROR'
};

// Reducer
const tournamentReducer = (state, action) => {
  switch (action.type) {
    case TOURNAMENT_ACTIONS.FETCH_START:
      return {
        ...state,
        loading: true,
        error: null
      };
    
    case TOURNAMENT_ACTIONS.FETCH_SUCCESS:
      return {
        ...state,
        tournaments: action.payload.tournaments,
        pagination:  action.payload.pagination ?? state.pagination,
        loading: false,
        error: null
      };
    
    case TOURNAMENT_ACTIONS.CREATE_SUCCESS:
      return {
        ...state,
        tournaments: [...state.tournaments, action.payload],
        loading: false,
        error: null
      };
    
    case TOURNAMENT_ACTIONS.UPDATE_SUCCESS:
      return {
        ...state,
        tournaments: state.tournaments.map(t => 
          t.id === action.payload.id ? action.payload : t
        ),
        currentTournament: state.currentTournament?.id === action.payload.id 
          ? action.payload 
          : state.currentTournament,
        loading: false,
        error: null
      };
    
    case TOURNAMENT_ACTIONS.DELETE_SUCCESS:
      return {
        ...state,
        tournaments: state.tournaments.filter(t => t.id !== action.payload),
        currentTournament: state.currentTournament?.id === action.payload 
          ? null 
          : state.currentTournament,
        loading: false,
        error: null
      };
    
    case TOURNAMENT_ACTIONS.SET_CURRENT:
      return {
        ...state,
        currentTournament: action.payload
      };
    
    case TOURNAMENT_ACTIONS.FETCH_FAILURE:
      return {
        ...state,
        loading: false,
        error: action.payload
      };
    
    case TOURNAMENT_ACTIONS.CLEAR_ERROR:
      return {
        ...state,
        error: null
      };
    
    default:
      return state;
  }
};

// Contexte
const TournamentContext = createContext();

// Hook personnalisé
export const useTournament = () => {
  const context = useContext(TournamentContext);
  if (!context) {
    throw new Error('useTournament doit être utilisé dans un TournamentProvider');
  }
  return context;
};

// Update axios default config
const API_BASE_URL = process.env.REACT_APP_API_URL || 'http://localhost:5000/api';
axios.defaults.baseURL = API_BASE_URL;
axios.defaults.timeout = 30000; // Increase timeout to 30 seconds
axios.defaults.maxContentLength = 10000000; // 10MB
axios.defaults.maxBodyLength = 10000000; // 10MB

// Add request interceptor to attach auth token
axios.interceptors.request.use(
  config => {
    // Ensure auth token is attached if available
    if (!config.headers?.Authorization) {
      const token = localStorage.getItem('token');
      if (token) {
        config.headers = config.headers || {};
        config.headers['Authorization'] = `Bearer ${token}`;
      }
    }
    return config;
  },
  error => Promise.reject(error)
);

// Provider
export const TournamentProvider = ({ children }) => {
  const [state, dispatch] = useReducer(tournamentReducer, initialState);

  // Récupérer tous les tournois
  const fetchTournaments = useCallback(async (params = {}, retryCount = 0) => {
    try {
      dispatch({ type: TOURNAMENT_ACTIONS.FETCH_START });
      const response = await axios.get('/tournaments', {
        params,
        timeout: 10000,
        headers: { 'Cache-Control': 'no-cache', 'Pragma': 'no-cache' },
      });

      dispatch({
        type: TOURNAMENT_ACTIONS.FETCH_SUCCESS,
        payload: {
          tournaments: response.data.tournaments,
          pagination:  response.data.pagination,
        },
      });
    } catch (error) {
      console.error(`Attempt ${retryCount + 1} failed:`, error.message);

      if (retryCount < MAX_RETRIES && error.code === 'ERR_INSUFFICIENT_RESOURCES') {
        await new Promise(resolve => setTimeout(resolve, RETRY_DELAY));
        return fetchTournaments(params, retryCount + 1);
      }

      dispatch({
        type: TOURNAMENT_ACTIONS.FETCH_FAILURE,
        payload: error.response?.data?.message || 'Erreur lors du chargement des tournois',
      });
    }
  }, [dispatch]);

  // Récupérer un tournoi par ID
  const fetchTournamentById = useCallback(async (id, retryCount = 0) => {
    try {
      dispatch({ type: TOURNAMENT_ACTIONS.FETCH_START });
      console.log(`🔄 Fetching tournament ${id} (attempt ${retryCount + 1}/${MAX_RETRIES + 1})`);
      
      const response = await axios.get(`/tournaments/${id}`, {
        timeout: 30000,
        headers: {
          'Cache-Control': 'no-cache',
          'Pragma': 'no-cache'
        },
        validateStatus: (status) => status < 500
      , params: { lite: true }
      });

      if (response.status === 404) {
        throw new Error(`Tournament with ID ${id} not found`);
      }

      if (!response.data.tournament) {
        throw new Error('Invalid server response format');
      }

      dispatch({
        type: TOURNAMENT_ACTIONS.SET_CURRENT,
        payload: response.data.tournament
      });
      
      return response.data.tournament;
    } catch (error) {
      console.error('Error fetching tournament:', {
        id,
        attempt: retryCount + 1,
        error: error.message,
        code: error.code,
        status: error.response?.status
      });

      // Only retry on network errors, timeouts, or 5xx server errors
      const isTimeout = error.code === 'ECONNABORTED' || /timeout/i.test(error.message || '');
      if (retryCount < MAX_RETRIES && 
         (error.code === 'ERR_NETWORK' || isTimeout ||
          (error.response?.status >= 500))) {
        const delay = RETRY_DELAY * Math.pow(2, retryCount); // Exponential backoff
        console.log(`⏳ Retrying in ${delay}ms...`);
        await new Promise(resolve => setTimeout(resolve, delay));
        return fetchTournamentById(id, retryCount + 1);
      }

      const errorMessage = error.response?.status === 404
        ? `Tournament with ID ${id} not found`
        : error.response?.status >= 500
          ? 'Server error. Please try again later.'
          : `Error loading tournament: ${error.message}`;

      dispatch({
        type: TOURNAMENT_ACTIONS.FETCH_FAILURE,
        payload: errorMessage
      });
      throw error;
    }
  }, [dispatch]);

  // Créer un tournoi
  const createTournament = useCallback(async (tournamentData) => {
    try {
      dispatch({ type: TOURNAMENT_ACTIONS.FETCH_START });
      const response = await axios.post('/tournaments', tournamentData);
      dispatch({
        type: TOURNAMENT_ACTIONS.CREATE_SUCCESS,
        payload: response.data.tournament
      });
      return { success: true, tournament: response.data.tournament };
    } catch (error) {
      const errorMessage = error.response?.data?.message || 'Erreur lors de la création du tournoi';
      dispatch({
        type: TOURNAMENT_ACTIONS.FETCH_FAILURE,
        payload: errorMessage
      });
      return { success: false, error: errorMessage };
    }
  }, []);

  // Mettre à jour un tournoi
  const updateTournament = useCallback(async (id, tournamentData) => {
    try {
      dispatch({ type: TOURNAMENT_ACTIONS.FETCH_START });
      const response = await axios.put(`/tournaments/${id}`, tournamentData);
      dispatch({
        type: TOURNAMENT_ACTIONS.UPDATE_SUCCESS,
        payload: response.data.tournament
      });
      return { success: true, tournament: response.data.tournament };
    } catch (error) {
      const errorMessage = error.response?.data?.message || 'Erreur lors de la mise à jour du tournoi';
      dispatch({
        type: TOURNAMENT_ACTIONS.FETCH_FAILURE,
        payload: errorMessage
      });
      return { success: false, error: errorMessage };
    }
  }, []);

  // Supprimer un tournoi
  const deleteTournament = useCallback(async (id) => {
    try {
      const response = await axios.delete(`/tournaments/${id}`);
      if (response.data.success) {
        dispatch({
          type: TOURNAMENT_ACTIONS.DELETE_SUCCESS,
          payload: id
        });
        return { success: true };
      }
      return { success: false, error: response.data.message };
    } catch (error) {
      console.error('Error deleting tournament:', error);
      return { success: false, error: error.message };
    }
  }, []);

  // Effacer les erreurs
  const clearError = () => {
    dispatch({ type: TOURNAMENT_ACTIONS.CLEAR_ERROR });
  };

  const value = useMemo(() => ({
    ...state,
    fetchTournaments,
    fetchTournamentById,
    createTournament,
    updateTournament,
    deleteTournament,
    clearError,
  }), [state, fetchTournaments, fetchTournamentById, createTournament, updateTournament, deleteTournament]);

  return (
    <TournamentContext.Provider value={value}>
      {children}
    </TournamentContext.Provider>
  );
};