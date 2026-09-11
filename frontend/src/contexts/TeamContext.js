import React, { createContext, useContext, useReducer, useCallback, useMemo } from 'react';
import axios from 'axios';

const initialState = {
  teams: [],
  currentTeam: null,
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
      return { ...state, loading: false, error: null, teams: action.payload };
    case ACTIONS.FETCH_FAILURE:
      return { ...state, loading: false, error: action.payload };
    case ACTIONS.SET_CURRENT:
      return { ...state, currentTeam: action.payload, loading: false };
    case ACTIONS.CREATE_SUCCESS:
      return { ...state, loading: false, teams: [...state.teams, action.payload] };
    case ACTIONS.UPDATE_SUCCESS:
      return {
        ...state,
        loading: false,
        teams: state.teams.map(t => (t.id === action.payload.id ? action.payload : t)),
        currentTeam: state.currentTeam?.id === action.payload.id ? action.payload : state.currentTeam
      };
    case ACTIONS.DELETE_SUCCESS:
      return {
        ...state,
        loading: false,
        teams: state.teams.filter(t => t.id !== action.payload),
        currentTeam: state.currentTeam?.id === action.payload ? null : state.currentTeam
      };
    default:
      return state;
  }
};

const TeamContext = createContext();

export const useTeams = () => {
  const ctx = useContext(TeamContext);
  if (!ctx) throw new Error('useTeams must be used within TeamProvider');
  return ctx;
};

export const TeamProvider = ({ children }) => {
  const [state, dispatch] = useReducer(reducer, initialState);

  const fetchTeams = useCallback(async (params = {}) => {
    try {
      dispatch({ type: ACTIONS.FETCH_START });
      const response = await axios.get('/teams', { params });
      dispatch({ type: ACTIONS.FETCH_SUCCESS, payload: response.data.teams });
    } catch (error) {
      dispatch({ type: ACTIONS.FETCH_FAILURE, payload: error.response?.data?.message || 'Erreur lors du chargement des équipes' });
    }
  }, []);

  const fetchTeamById = useCallback(async (id) => {
    try {
      dispatch({ type: ACTIONS.FETCH_START });
      const response = await axios.get(`/teams/${id}`);
      dispatch({ type: ACTIONS.SET_CURRENT, payload: response.data.team });
    } catch (error) {
      dispatch({ type: ACTIONS.FETCH_FAILURE, payload: error.response?.data?.message || "Erreur lors du chargement de l'équipe" });
    }
  }, []);

  const createTeam = useCallback(async (data) => {
    try {
      dispatch({ type: ACTIONS.FETCH_START });
      const response = await axios.post('/teams', data);
      dispatch({ type: ACTIONS.CREATE_SUCCESS, payload: response.data.team });
      return { success: true };
    } catch (error) {
      const message = error.response?.data?.message || "Erreur lors de la création de l'équipe";
      dispatch({ type: ACTIONS.FETCH_FAILURE, payload: message });
      return { success: false, error: message };
    }
  }, []);

  const updateTeam = useCallback(async (id, data) => {
    try {
      dispatch({ type: ACTIONS.FETCH_START });
      const response = await axios.put(`/teams/${id}`, data);
      dispatch({ type: ACTIONS.UPDATE_SUCCESS, payload: response.data.team });
      return { success: true };
    } catch (error) {
      const message = error.response?.data?.message || "Erreur lors de la mise à jour de l'équipe";
      dispatch({ type: ACTIONS.FETCH_FAILURE, payload: message });
      return { success: false, error: message };
    }
  }, []);

  const deleteTeam = useCallback(async (id) => {
    try {
      dispatch({ type: ACTIONS.FETCH_START });
      await axios.delete(`/teams/${id}`);
      dispatch({ type: ACTIONS.DELETE_SUCCESS, payload: id });
      return { success: true };
    } catch (error) {
      const message = error.response?.data?.message || "Erreur lors de la suppression de l'équipe";
      dispatch({ type: ACTIONS.FETCH_FAILURE, payload: message });
      return { success: false, error: message };
    }
  }, []);

  const value = useMemo(() => ({
    ...state,
    fetchTeams,
    fetchTeamById,
    createTeam,
    updateTeam,
    deleteTeam
  }), [state, fetchTeams, fetchTeamById, createTeam, updateTeam, deleteTeam]);

  return (
    <TeamContext.Provider value={value}>
      {children}
    </TeamContext.Provider>
  );
};
