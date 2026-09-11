import React, { createContext, useContext, useReducer, useCallback, useMemo } from 'react';
import axios from 'axios';

const initialState = {
  coaches: [],
  loading: false,
  error: null
};

const ACTIONS = {
  FETCH_START: 'FETCH_START',
  FETCH_SUCCESS: 'FETCH_SUCCESS',
  FETCH_FAILURE: 'FETCH_FAILURE',
  CREATE_SUCCESS: 'CREATE_SUCCESS'
};

const reducer = (state, action) => {
  switch (action.type) {
    case ACTIONS.FETCH_START:
      return { ...state, loading: true, error: null };
    case ACTIONS.FETCH_SUCCESS:
      return { ...state, loading: false, coaches: action.payload, error: null };
    case ACTIONS.FETCH_FAILURE:
      return { ...state, loading: false, error: action.payload };
    case ACTIONS.CREATE_SUCCESS:
      return { ...state, loading: false, coaches: [...state.coaches, action.payload] };
    default:
      return state;
  }
};

const CoachContext = createContext();

export const useCoaches = () => {
  const ctx = useContext(CoachContext);
  if (!ctx) throw new Error('useCoaches must be used within CoachProvider');
  return ctx;
};

export const CoachProvider = ({ children }) => {
  const [state, dispatch] = useReducer(reducer, initialState);

  const fetchCoaches = useCallback(async () => {
    try {
      dispatch({ type: ACTIONS.FETCH_START });
      const response = await axios.get('/coaches');
      dispatch({ type: ACTIONS.FETCH_SUCCESS, payload: response.data.coaches });
    } catch (error) {
      dispatch({ type: ACTIONS.FETCH_FAILURE, payload: error.response?.data?.message || 'Erreur lors du chargement des coaches' });
    }
  }, []);

  const createCoach = useCallback(async (data) => {
    try {
      dispatch({ type: ACTIONS.FETCH_START });
      const response = await axios.post('/coaches', data);
      dispatch({ type: ACTIONS.CREATE_SUCCESS, payload: response.data.coach });
      return { success: true };
    } catch (error) {
      const message = error.response?.data?.message || 'Erreur lors de la création du coach';
      dispatch({ type: ACTIONS.FETCH_FAILURE, payload: message });
      return { success: false, error: message };
    }
  }, []);

  const value = useMemo(() => ({
    ...state,
    fetchCoaches,
    createCoach
  }), [state, fetchCoaches, createCoach]);

  return (
    <CoachContext.Provider value={value}>
      {children}
    </CoachContext.Provider>
  );
};
