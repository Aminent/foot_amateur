import React, { createContext, useContext, useState, useEffect, useCallback } from 'react';
import axios from 'axios';
import { API } from '../utils/api';

axios.defaults.baseURL = API;
axios.defaults.headers.common['ngrok-skip-browser-warning'] = 'true';

const AuthContext = createContext(null);

export const useAuth = () => {
  const ctx = useContext(AuthContext);
  if (!ctx) throw new Error('useAuth doit être dans AuthProvider');
  return ctx;
};

export const AuthProvider = ({ children }) => {
  const [user,  setUser]  = useState(null);
  const [token, setToken] = useState(() => localStorage.getItem('scout_token'));
  const [loading, setLoading] = useState(true);

  // Configurer axios dès qu'on a un token
  useEffect(() => {
    if (token) {
      axios.defaults.headers.common['Authorization'] = `Bearer ${token}`;
    } else {
      delete axios.defaults.headers.common['Authorization'];
    }
  }, [token]);

  const loadUser = useCallback(async () => {
    if (!token) { setLoading(false); return; }
    try {
      const { data } = await axios.get('/auth/profile');
      setUser(data.user);
    } catch (err) {
      // Ne déconnecter que sur 401/403 (token invalide/expiré)
      // Sur erreur réseau (pas de réponse), garder le token et finir le loading
      if (err.response?.status === 401 || err.response?.status === 403) {
        localStorage.removeItem('scout_token');
        setToken(null);
        setUser(null);
      }
    } finally {
      setLoading(false);
    }
  }, [token]);

  useEffect(() => { loadUser(); }, [loadUser]);

  const login = async (email, password) => {
    const { data } = await axios.post('/auth/login', { email, password });
    // Accepter admin et scout
    if (!['admin', 'scout'].includes(data.user?.role)) {
      throw new Error('Accès réservé aux scouts et administrateurs');
    }
    localStorage.setItem('scout_token', data.token);
    setToken(data.token);
    setUser(data.user);
    return data.user;
  };

  const logout = () => {
    localStorage.removeItem('scout_token');
    setToken(null);
    setUser(null);
  };

  return (
    <AuthContext.Provider value={{ user, token, loading, login, logout, isAuthenticated: !!user }}>
      {children}
    </AuthContext.Provider>
  );
};
