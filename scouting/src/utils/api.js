// En production (servi depuis Express/ngrok) → URL relative
// En développement local → localhost:5000
const isDev = window.location.hostname === 'localhost' || window.location.hostname === '127.0.0.1';
export const API  = isDev ? 'http://localhost:5000/api' : '/api';
export const BASE = isDev ? 'http://localhost:5000'     : '';

export const authHeaders = (opts = {}) => {
  const token = localStorage.getItem('scout_token');
  const headers = {
    Authorization: `Bearer ${token}`,
    'ngrok-skip-browser-warning': 'true',
  };
  if (opts.json !== false) headers['Content-Type'] = 'application/json';
  return headers;
};

// Wrapper fetch avec gestion d'erreur centralisée
export const apiFetch = async (path, opts = {}) => {
  const res = await fetch(`${API}${path}`, {
    headers: authHeaders(opts),
    ...opts,
  });
  const data = await res.json().catch(() => ({}));
  if (res.status === 401 || res.status === 403) {
    localStorage.removeItem('scout_token');
    window.location.href = '/login';
    return Promise.reject(new Error(data.message || 'Non autorisé'));
  }
  if (!res.ok) throw new Error(data.message || `Erreur ${res.status}`);
  return data;
};
