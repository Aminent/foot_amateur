import { createTheme } from '@mui/material/styles';

const TEAL      = '#0c9e96';
const TEAL_DARK = '#0a8880';

const sharedComponents = {
  MuiButton: {
    styleOverrides: {
      root: { textTransform: 'none', fontWeight: 600, borderRadius: 10 },
      containedPrimary: {
        background: `linear-gradient(135deg, ${TEAL} 0%, ${TEAL_DARK} 100%)`,
        boxShadow: `0 4px 14px rgba(12,158,150,0.35)`,
        '&:hover': { background: `linear-gradient(135deg, ${TEAL_DARK} 0%, #087a72 100%)` },
      },
    },
  },
  MuiChip: { styleOverrides: { root: { fontWeight: 600, borderRadius: 6 } } },
  MuiInputBase: { styleOverrides: { root: { borderRadius: 10 } } },
  MuiOutlinedInput: { styleOverrides: { root: { borderRadius: 10 } } },
  MuiAlert: { styleOverrides: { root: { borderRadius: 10 } } },
  MuiTooltip: { styleOverrides: { tooltip: { borderRadius: 6, fontSize: '0.75rem' } } },
  MuiTextField: {
    defaultProps: { size: 'small' },
  },
};

export const lightTheme = createTheme({
  palette: {
    mode: 'light',
    primary:    { main: TEAL, light: '#5ecbc7', dark: TEAL_DARK, contrastText: '#ffffff' },
    secondary:  { main: '#1a2d3d' },
    error:      { main: '#dc2626', light: '#fca5a5', dark: '#991b1b' },
    success:    { main: '#16a34a', light: '#86efac', dark: '#15803d' },
    warning:    { main: '#d97706', light: '#fcd34d', dark: '#b45309' },
    info:       { main: '#2563eb', light: '#93c5fd', dark: '#1d4ed8' },
    background: { default: '#f1f5f9', paper: '#ffffff' },
    text:       { primary: '#0f172a', secondary: '#64748b' },
    divider:    '#e2e8f0',
  },
  typography: {
    fontFamily: '"Inter", "Segoe UI", system-ui, sans-serif',
    h1: { fontWeight: 800 }, h2: { fontWeight: 700 },
    h3: { fontWeight: 700 }, h4: { fontWeight: 700 },
    h5: { fontWeight: 600 }, h6: { fontWeight: 600 },
  },
  shape: { borderRadius: 10 },
  components: {
    ...sharedComponents,
    MuiCard: {
      styleOverrides: {
        root: {
          borderRadius: 12,
          background: '#ffffff',
          border: '1px solid #e2e8f0',
          boxShadow: '0 1px 4px rgba(0,0,0,0.05)',
          transition: 'box-shadow 0.2s ease, border-color 0.2s ease',
          '&:hover': { boxShadow: '0 4px 16px rgba(12,158,150,0.12)' },
        },
      },
    },
    MuiPaper: {
      styleOverrides: {
        root: { borderRadius: 12, background: '#ffffff', border: '1px solid #e2e8f0' },
      },
    },
    MuiTableCell: {
      styleOverrides: {
        head: {
          fontWeight: 600, fontSize: '0.72rem',
          color: '#64748b', textTransform: 'uppercase', letterSpacing: '0.04em',
          background: 'rgba(0,0,0,0.02)',
          borderBottom: '1px solid #e2e8f0',
        },
        body: { fontSize: '0.875rem', borderBottom: '1px solid #f1f5f9' },
      },
    },
    MuiDialog: {
      styleOverrides: {
        paper: { borderRadius: 16, boxShadow: '0 20px 60px rgba(12,158,150,0.20)' },
      },
    },
  },
});

export const darkTheme = createTheme({
  palette: {
    mode: 'dark',
    primary:    { main: TEAL, light: '#5ecbc7', dark: TEAL_DARK, contrastText: '#ffffff' },
    secondary:  { main: '#94a3b8' },
    error:      { main: '#dc2626', light: '#fca5a5', dark: '#991b1b' },
    success:    { main: '#16a34a', light: '#86efac', dark: '#15803d' },
    warning:    { main: '#d97706', light: '#fcd34d', dark: '#b45309' },
    info:       { main: '#2563eb', light: '#93c5fd', dark: '#1d4ed8' },
    background: { default: '#0f172a', paper: '#1e293b' },
    text:       { primary: '#f1f5f9', secondary: '#94a3b8' },
    divider:    'rgba(255,255,255,0.10)',
  },
  typography: {
    fontFamily: '"Inter", "Segoe UI", system-ui, sans-serif',
    h1: { fontWeight: 800 }, h2: { fontWeight: 700 },
    h3: { fontWeight: 700 }, h4: { fontWeight: 700 },
    h5: { fontWeight: 600 }, h6: { fontWeight: 600 },
  },
  shape: { borderRadius: 10 },
  components: {
    ...sharedComponents,
    MuiCard: {
      styleOverrides: {
        root: {
          borderRadius: 12,
          background: '#1e293b',
          border: '1px solid rgba(255,255,255,0.10)',
          boxShadow: '0 4px 24px rgba(0,0,0,0.40)',
          '&:hover': { boxShadow: '0 8px 32px rgba(0,0,0,0.55)' },
        },
      },
    },
    MuiPaper: {
      styleOverrides: {
        root: { borderRadius: 12, background: '#1e293b', border: '1px solid rgba(255,255,255,0.10)' },
      },
    },
    MuiTableCell: {
      styleOverrides: {
        head: {
          fontWeight: 600, fontSize: '0.72rem',
          color: '#94a3b8', textTransform: 'uppercase', letterSpacing: '0.04em',
          background: 'rgba(255,255,255,0.03)',
          borderBottom: '1px solid rgba(255,255,255,0.08)',
        },
        body: { fontSize: '0.875rem', borderBottom: '1px solid rgba(255,255,255,0.05)' },
      },
    },
    MuiDialog: {
      styleOverrides: {
        paper: { borderRadius: 16, background: '#1e293b', border: '1px solid rgba(255,255,255,0.12)' },
      },
    },
  },
});

export default lightTheme;
