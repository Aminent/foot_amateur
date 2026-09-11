import React, { createContext, useContext, useReducer, useEffect } from 'react';

import axios from 'axios';



// Configuration axios
axios.defaults.baseURL = process.env.REACT_APP_API_URL || 'http://localhost:5000/api';
// Nécessaire pour les appels API via ngrok (évite la page d'avertissement ngrok)
axios.defaults.headers.common['ngrok-skip-browser-warning'] = 'true';



// État initial

const initialState = {

  user: null,

  token: localStorage.getItem('token'),

  isAuthenticated: false,

  loading: true,

  error: null

};



// Types d'actions

const AUTH_ACTIONS = {

  LOGIN_START: 'LOGIN_START',

  LOGIN_SUCCESS: 'LOGIN_SUCCESS',

  LOGIN_FAILURE: 'LOGIN_FAILURE',

  LOGOUT: 'LOGOUT',

  REGISTER_START: 'REGISTER_START',

  REGISTER_SUCCESS: 'REGISTER_SUCCESS',

  REGISTER_FAILURE: 'REGISTER_FAILURE',

  LOAD_USER_START: 'LOAD_USER_START',

  LOAD_USER_SUCCESS: 'LOAD_USER_SUCCESS',

  LOAD_USER_FAILURE: 'LOAD_USER_FAILURE',

  UPDATE_PROFILE: 'UPDATE_PROFILE',

  CLEAR_ERROR: 'CLEAR_ERROR',

  TOKEN_REFRESHED: 'TOKEN_REFRESHED'

};



// Reducer

const authReducer = (state, action) => {

  switch (action.type) {

    case AUTH_ACTIONS.LOGIN_START:

    case AUTH_ACTIONS.REGISTER_START:

    case AUTH_ACTIONS.LOAD_USER_START:

      return {

        ...state,

        loading: true,

        error: null

      };

    

    case AUTH_ACTIONS.LOGIN_SUCCESS:

    case AUTH_ACTIONS.REGISTER_SUCCESS:

      localStorage.setItem('token', action.payload.token);

      axios.defaults.headers.common['Authorization'] = `Bearer ${action.payload.token}`;

      return {

        ...state,

        user: action.payload.user,

        token: action.payload.token,

        isAuthenticated: true,

        loading: false,

        error: null

      };

    

    case AUTH_ACTIONS.LOAD_USER_SUCCESS:

      return {

        ...state,

        user: action.payload,

        isAuthenticated: true,

        loading: false,

        error: null

      };

    

    case AUTH_ACTIONS.UPDATE_PROFILE:

      return {

        ...state,

        user: { ...state.user, ...action.payload },

        loading: false

      };

    

    case AUTH_ACTIONS.LOGIN_FAILURE:

    case AUTH_ACTIONS.REGISTER_FAILURE:

    case AUTH_ACTIONS.LOAD_USER_FAILURE:

      localStorage.removeItem('token');

      delete axios.defaults.headers.common['Authorization'];

      return {

        ...state,

        user: null,

        token: null,

        isAuthenticated: false,

        loading: false,

        error: action.payload

      };

    

    case AUTH_ACTIONS.LOGOUT:

      localStorage.removeItem('token');

      delete axios.defaults.headers.common['Authorization'];

      return {

        ...state,

        user: null,

        token: null,

        isAuthenticated: false,

        loading: false,

        error: null

      };

    

    case AUTH_ACTIONS.CLEAR_ERROR:

      return {

        ...state,

        error: null

      };



    case AUTH_ACTIONS.TOKEN_REFRESHED:

      localStorage.setItem('token', action.payload);

      axios.defaults.headers.common['Authorization'] = `Bearer ${action.payload}`;

      return {

        ...state,

        token: action.payload

      };



    default:

      return state;

  }

};



// Contexte

const AuthContext = createContext();



// Hook personnalisé pour utiliser le contexte

export const useAuth = () => {

  const context = useContext(AuthContext);

  if (!context) {

    throw new Error('useAuth doit être utilisé dans un AuthProvider');

  }

  return context;

};



// Provider

export const AuthProvider = ({ children }) => {

  const [state, dispatch] = useReducer(authReducer, initialState);



  // ── Axios 401 interceptor: silent token refresh ───────────────────────────
  // Runs once. Uses closure variables so concurrent 401s are queued, not
  // each triggering their own refresh race.
  useEffect(() => {
    let isRefreshing = false;
    let pendingQueue = []; // [{ resolve, reject }]

    const flushQueue = (newToken) =>
      pendingQueue.splice(0).forEach(({ resolve }) => resolve(newToken));

    const rejectQueue = (err) =>
      pendingQueue.splice(0).forEach(({ reject }) => reject(err));

    const interceptorId = axios.interceptors.response.use(
      (response) => response,
      async (error) => {
        const original = error.config;

        // Only act on 401s that haven't been retried yet, and skip
        // the auth endpoints themselves to prevent infinite loops.
        if (
          error.response?.status !== 401 ||
          original._retried ||
          original.url?.includes('/auth/refresh') ||
          original.url?.includes('/auth/login')
        ) {
          return Promise.reject(error);
        }

        original._retried = true;

        // If a refresh is already running, queue this request.
        if (isRefreshing) {
          return new Promise((resolve, reject) => {
            pendingQueue.push({ resolve, reject });
          }).then((newToken) => {
            original.headers['Authorization'] = `Bearer ${newToken}`;
            return axios(original);
          });
        }

        isRefreshing = true;

        try {
          const expiredToken = localStorage.getItem('token');
          const { data } = await axios.post(
            '/auth/refresh',
            null,
            { headers: { Authorization: `Bearer ${expiredToken}` } }
          );
          const newToken = data.token;

          // Persist and broadcast the new token.
          localStorage.setItem('token', newToken);
          axios.defaults.headers.common['Authorization'] = `Bearer ${newToken}`;
          dispatch({ type: AUTH_ACTIONS.TOKEN_REFRESHED, payload: newToken });

          // Unblock any requests that arrived while we were refreshing.
          flushQueue(newToken);

          // Retry the original request with the fresh token.
          original.headers['Authorization'] = `Bearer ${newToken}`;
          return axios(original);
        } catch (refreshError) {
          rejectQueue(refreshError);
          // Refresh failed — the session is truly dead, force logout.
          dispatch({ type: AUTH_ACTIONS.LOGOUT });
          return Promise.reject(refreshError);
        } finally {
          isRefreshing = false;
        }
      }
    );

    // Clean up the interceptor if the AuthProvider ever unmounts.
    return () => axios.interceptors.response.eject(interceptorId);
  }, [dispatch]);

  // Charger l'utilisateur au démarrage si un token existe

  useEffect(() => {

    if (state.token) {

      loadUser();

    } else {

      dispatch({ type: AUTH_ACTIONS.LOAD_USER_FAILURE });

    }

  }, []);



  // Configurer axios avec le token

  useEffect(() => {

    if (state.token) {

      axios.defaults.headers.common['Authorization'] = `Bearer ${state.token}`;

    }

  }, [state.token]);



  // Charger les informations de l'utilisateur

  const loadUser = async () => {

    try {

      dispatch({ type: AUTH_ACTIONS.LOAD_USER_START });

      const response = await axios.get('/auth/profile');

      dispatch({

        type: AUTH_ACTIONS.LOAD_USER_SUCCESS,

        payload: response.data.user

      });

    } catch (error) {

      dispatch({

        type: AUTH_ACTIONS.LOAD_USER_FAILURE,

        payload: error.response?.data?.message || 'Erreur lors du chargement du profil'

      });

    }

  };



  // Connexion

  const login = async (email, password) => {

    try {

      dispatch({ type: AUTH_ACTIONS.LOGIN_START });

      const response = await axios.post('/auth/login', { email, password });

      dispatch({

        type: AUTH_ACTIONS.LOGIN_SUCCESS,

        payload: response.data

      });

      return { success: true };

    } catch (error) {

      const errorMessage = error.response?.data?.message || 'Erreur de connexion';

      dispatch({

        type: AUTH_ACTIONS.LOGIN_FAILURE,

        payload: errorMessage

      });

      return { success: false, error: errorMessage };

    }

  };



  // Inscription

  const register = async (userData) => {

    try {

      dispatch({ type: AUTH_ACTIONS.REGISTER_START });

      const response = await axios.post('/auth/register', userData);

      dispatch({

        type: AUTH_ACTIONS.REGISTER_SUCCESS,

        payload: response.data

      });

      return { success: true };

    } catch (error) {

      const errorMessage = error.response?.data?.message || 'Erreur d\'inscription';

      dispatch({

        type: AUTH_ACTIONS.REGISTER_FAILURE,

        payload: errorMessage

      });

      return { success: false, error: errorMessage };

    }

  };



  // Déconnexion

  const logout = () => {

    dispatch({ type: AUTH_ACTIONS.LOGOUT });

  };



  // Mettre à jour le profil

  const updateProfile = async (profileData) => {

    try {

      const response = await axios.put('/auth/profile', profileData);

      dispatch({

        type: AUTH_ACTIONS.UPDATE_PROFILE,

        payload: response.data.user

      });

      return { success: true };

    } catch (error) {

      const errorMessage = error.response?.data?.message || 'Erreur lors de la mise à jour';

      return { success: false, error: errorMessage };

    }

  };



  // Changer le mot de passe

  const changePassword = async (currentPassword, newPassword) => {

    try {

      await axios.put('/auth/change-password', { currentPassword, newPassword });

      return { success: true };

    } catch (error) {

      const errorMessage = error.response?.data?.message || 'Erreur lors du changement de mot de passe';

      return { success: false, error: errorMessage };

    }

  };



  // Effacer les erreurs

  const clearError = () => {

    dispatch({ type: AUTH_ACTIONS.CLEAR_ERROR });

  };



  const value = {

    ...state,

    login,

    register,

    logout,

    updateProfile,

    changePassword,

    clearError,

    loadUser

  };



  return (

    <AuthContext.Provider value={value}>

      {children}

    </AuthContext.Provider>

  );

};