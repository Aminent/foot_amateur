import React, { createContext, useContext, useReducer, useCallback, useMemo } from 'react';
import axios from 'axios';

const initialState = {
  players: [],
  pagination: { page: 1, limit: 50, total: 0, totalPages: 1 },
  currentPlayer: null,
  loading: false,
  error: null
};

const ACTIONS = {
  FETCH_START: 'FETCH_START',
  FETCH_SUCCESS: 'FETCH_SUCCESS',
  FETCH_FAILURE: 'FETCH_FAILURE',
  SET_CURRENT: 'SET_CURRENT',
  CREATE_SUCCESS: 'CREATE_SUCCESS',
  UPDATE_SUCCESS: 'UPDATE_SUCCESS',
  DELETE_SUCCESS: 'DELETE_SUCCESS'
};

const reducer = (state, action) => {
  switch (action.type) {
    case ACTIONS.FETCH_START:
      return { ...state, loading: true, error: null };
    case ACTIONS.FETCH_SUCCESS:
      return {
        ...state,
        loading: false,
        error: null,
        players: action.payload.players,
        pagination: action.payload.pagination ?? state.pagination,
      };
    case ACTIONS.FETCH_FAILURE:
      return { ...state, loading: false, error: action.payload };
    case ACTIONS.SET_CURRENT:
      return { ...state, currentPlayer: action.payload, loading: false };
    case ACTIONS.CREATE_SUCCESS:
      return { ...state, loading: false, players: [...state.players, action.payload] };
    case ACTIONS.UPDATE_SUCCESS:
      return {
        ...state,
        loading: false,
        players: state.players.map(p => (p.id === action.payload.id ? action.payload : p)),
        currentPlayer: state.currentPlayer?.id === action.payload.id ? action.payload : state.currentPlayer
      };
    case ACTIONS.DELETE_SUCCESS:
      return {
        ...state,
        loading: false,
        players: state.players.filter(p => p.id !== action.payload),
        currentPlayer: state.currentPlayer?.id === action.payload ? null : state.currentPlayer
      };
    default:
      return state;
  }
};

const PlayerContext = createContext();

export const usePlayers = () => {
  const ctx = useContext(PlayerContext);
  if (!ctx) throw new Error('usePlayers must be used within PlayerProvider');
  return ctx;
};

export const PlayerProvider = ({ children }) => {
  const [state, dispatch] = useReducer(reducer, initialState);

  const fetchPlayers = useCallback(async (params = {}) => {
    try {
      dispatch({ type: ACTIONS.FETCH_START });
      const response = await axios.get('/players', { params });
      dispatch({
        type: ACTIONS.FETCH_SUCCESS,
        payload: {
          players:    response.data.players,
          pagination: response.data.pagination,
        },
      });
    } catch (error) {
      dispatch({ type: ACTIONS.FETCH_FAILURE, payload: error.response?.data?.message || 'Erreur lors du chargement des joueurs' });
    }
  }, []);

  const fetchPlayerById = useCallback(async (id) => {
    try {
      dispatch({ type: ACTIONS.FETCH_START });
      const response = await axios.get(`/players/${id}`);
      dispatch({ type: ACTIONS.SET_CURRENT, payload: response.data.player });
    } catch (error) {
      dispatch({ type: ACTIONS.FETCH_FAILURE, payload: error.response?.data?.message || 'Erreur lors du chargement du joueur' });
    }
  }, []);

  const createPlayer = useCallback(async (data) => {
    try {
      dispatch({ type: ACTIONS.FETCH_START });
      const response = await axios.post('/players', data);
      dispatch({ type: ACTIONS.CREATE_SUCCESS, payload: response.data.player });
      return { success: true };
    } catch (error) {
      const message = error.response?.data?.message || 'Erreur lors de la création du joueur';
      dispatch({ type: ACTIONS.FETCH_FAILURE, payload: message });
      return { success: false, error: message };
    }
  }, []);

  const updatePlayer = useCallback(async (id, data) => {
    try {
      dispatch({ type: ACTIONS.FETCH_START });
      const response = await axios.put(`/players/${id}`, data);
      dispatch({ type: ACTIONS.UPDATE_SUCCESS, payload: response.data.player });
      return { success: true };
    } catch (error) {
      const message = error.response?.data?.message || 'Erreur lors de la mise à jour du joueur';
      dispatch({ type: ACTIONS.FETCH_FAILURE, payload: message });
      return { success: false, error: message };
    }
  }, []);

  const deletePlayer = useCallback(async (id) => {
    try {
      dispatch({ type: ACTIONS.FETCH_START });
      await axios.delete(`/players/${id}`);
      dispatch({ type: ACTIONS.DELETE_SUCCESS, payload: id });
      return { success: true };
    } catch (error) {
      const message = error.response?.data?.message || 'Erreur lors de la suppression du joueur';
      dispatch({ type: ACTIONS.FETCH_FAILURE, payload: message });
      return { success: false, error: message };
    }
  }, []);

  const assignPlayerToTeam = useCallback(async (playerId, teamId) => {
    try {
      dispatch({ type: ACTIONS.FETCH_START });
      const response = await axios.post(`/players/assign/${playerId}/team/${teamId}`);
      dispatch({ type: ACTIONS.UPDATE_SUCCESS, payload: response.data.player });
      return { success: true };
    } catch (error) {
      const message = error.response?.data?.message || "Erreur lors de l'assignation du joueur";
      dispatch({ type: ACTIONS.FETCH_FAILURE, payload: message });
      return { success: false, error: message };
    }
  }, []);

  const getPlayerStats = useCallback(async (playerId) => {
    try {
      const res = await axios.get(`/player-stats/${playerId}`);
      return res.data.stats;
    } catch (error) {
      return null;
    }
  }, []);

  const setPlayerStats = useCallback(async (playerId, stats) => {
    try {
      await axios.put(`/player-stats/${playerId}`, stats);
      return { success: true };
    } catch (error) {
      return { success: false, error: error.response?.data?.message };
    }
  }, []);

  const incrementPlayerStat = useCallback(async (playerId, field, amount = 1) => {
    try {
      await axios.post(`/player-stats/${playerId}/increment`, { field, amount });
      return { success: true };
    } catch (error) {
      return { success: false, error: error.response?.data?.message };
    }
  }, []);

  const value = useMemo(() => ({
    ...state,
    fetchPlayers,
    fetchPlayerById,
    createPlayer,
    updatePlayer,
    deletePlayer,
    assignPlayerToTeam,
    getPlayerStats,
    setPlayerStats,
    incrementPlayerStat
  }), [state, fetchPlayers, fetchPlayerById, createPlayer, updatePlayer, deletePlayer, assignPlayerToTeam, getPlayerStats, setPlayerStats, incrementPlayerStat]);

  return (
    <PlayerContext.Provider value={value}>
      {children}
    </PlayerContext.Provider>
  );
};
