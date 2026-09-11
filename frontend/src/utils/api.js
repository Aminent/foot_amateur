/**
 * Centralize API base URL and common headers.
 * All fetch() calls should use these helpers so ngrok tunnels work correctly.
 */

export const API = process.env.REACT_APP_API_URL || 'http://localhost:5000/api';

export const BASE = API.replace('/api', '');

/**
 * Returns headers with Authorization + Content-Type + ngrok bypass.
 * Pass { json: false } for multipart/form-data requests.
 */
export const authHeaders = (opts = {}) => {
  const token = localStorage.getItem('token');
  const headers = {
    Authorization: `Bearer ${token}`,
    'ngrok-skip-browser-warning': 'true',
  };
  if (opts.json !== false) {
    headers['Content-Type'] = 'application/json';
  }
  return headers;
};
