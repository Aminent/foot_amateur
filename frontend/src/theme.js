import { createTheme } from '@mui/material/styles';

// ─── Design tokens ────────────────────────────────────────────────────────────
const ui = {
  // Brand / Primary (navy #092A43)
  brand600:  '#092A43',
  brand700:  '#061C2C',
  brand50:   '#E8EFF5',
  brand100:  '#C7D8E6',
  brand200:  '#95B5CE',
  brand300:  '#5B8FB5',

  // Teal (new primary — #092A43 navy stays for sidebar bg only)
  teal600:  '#0c9e96',
  teal700:  '#0a8880',
  teal500:  '#5ecbc7',
  teal50:   '#e6faf9',
  teal100:  '#ccf0ee',
  teal200:  '#99e2de',
  teal300:  '#5ecbc7',

  // Grays (light mode)
  gray25:  '#FCFCFD',
  gray50:  '#F9FAFB',
  gray100: '#F2F4F7',
  gray200: '#EAECF0',
  gray300: '#D0D5DD',
  gray400: '#98A2B3',
  gray500: '#667085',
  gray600: '#475467',
  gray700: '#344054',
  gray800: '#1D2939',
  gray900: '#101828',

  // Dark mode surfaces
  dark900: '#0a0f1a',   // deepest bg
  dark800: '#0f172a',   // page background
  dark700: '#1e293b',   // paper / card
  dark600: '#293548',   // elevated surface
  dark500: '#334155',   // border / divider
  dark400: '#475569',   // subtle text
  dark300: '#64748b',   // muted text
  dark200: '#94a3b8',   // secondary text
  dark100: '#cbd5e1',   // primary text (subdued)
  dark50:  '#f1f5f9',   // primary text

  // Error / Destructive
  error600: '#dc2626',
  error700: '#991b1b',
  error50:  '#FEF3F2',
  error100: '#FEE4E2',
  error200: '#FECDCA',
  error300: '#fca5a5',

  // Success
  success600: '#16a34a',
  success700: '#15803d',
  success50:  '#ECFDF3',
  success300: '#86efac',

  // Warning
  warning600: '#d97706',
  warning700: '#b45309',
  warning50:  '#fcd34d',

  // Shadows
  shadowXs:        '0px 1px 2px rgba(16, 24, 40, 0.05)',
  shadowSm:        '0px 1px 3px rgba(16, 24, 40, 0.10), 0px 1px 2px rgba(16, 24, 40, 0.06)',
  shadowMd:        '0px 4px 8px -2px rgba(16, 24, 40, 0.10), 0px 2px 4px -2px rgba(16, 24, 40, 0.06)',
  shadowLg:        '0px 12px 16px -4px rgba(16, 24, 40, 0.08), 0px 4px 6px -2px rgba(16, 24, 40, 0.03)',
  shadowFocusBrand:'0px 0px 0px 4px #C7D8E6',
  shadowFocusError:'0px 0px 0px 4px #FEE4E2',
  shadowFocusGray: '0px 0px 0px 4px #F2F4F7',

  // Dark shadow
  shadowXsDark: '0px 1px 2px rgba(0,0,0,0.4)',
  shadowFocusBrandDark: '0px 0px 0px 4px rgba(91,143,181,0.35)',
};

// ─── Theme factory ────────────────────────────────────────────────────────────
export default function createAppTheme(mode = 'light') {
  const isDark = mode === 'dark';

  return createTheme({
    palette: {
      mode,
      primary: {
        main:         ui.teal600,
        light:        ui.teal500,
        dark:         ui.teal700,
        contrastText: '#ffffff',
      },
      secondary: {
        main:         isDark ? ui.dark200 : ui.gray700,
        light:        isDark ? ui.dark300 : ui.gray500,
        dark:         isDark ? ui.dark100 : ui.gray800,
        contrastText: isDark ? ui.dark50   : ui.gray700,
      },
      success: {
        main:         ui.success600,
        dark:         ui.success700,
        light:        ui.success300,
        contrastText: '#ffffff',
      },
      error: {
        main:         ui.error600,
        dark:         ui.error700,
        light:        ui.error300,
        contrastText: '#ffffff',
      },
      warning: {
        main:  ui.warning600,
        light: ui.warning50,
        dark:  ui.warning700,
      },
      info: {
        main:  '#2563eb',
        light: '#93c5fd',
        dark:  '#1d4ed8',
      },
      background: {
        default: isDark ? ui.dark800 : ui.gray50,
        paper:   isDark ? ui.dark700 : '#ffffff',
      },
      text: {
        primary:   isDark ? ui.dark50  : ui.gray900,
        secondary: isDark ? ui.dark200 : ui.gray600,
        disabled:  isDark ? ui.dark400 : ui.gray400,
      },
      divider: isDark ? ui.dark500 : ui.gray200,
    },

    typography: {
      fontFamily: '"Inter", "Roboto", "Helvetica", "Arial", sans-serif',
      button: {
        fontSize:      '0.875rem',
        fontWeight:    600,
        lineHeight:    '1.25rem',
        textTransform: 'none',
        letterSpacing: 0,
      },
    },

    shape: { borderRadius: 10 },

    shadows: [
      'none',
      isDark ? ui.shadowXsDark : ui.shadowXs,
      ui.shadowSm,
      ui.shadowMd,
      ui.shadowLg,
      ui.shadowLg,
      ui.shadowLg,
      ui.shadowLg,
      isDark ? ui.shadowXsDark : ui.shadowXs,
      isDark ? ui.shadowXsDark : ui.shadowXs,
      isDark ? ui.shadowXsDark : ui.shadowXs,
      isDark ? ui.shadowXsDark : ui.shadowXs,
      isDark ? ui.shadowXsDark : ui.shadowXs,
      isDark ? ui.shadowXsDark : ui.shadowXs,
      isDark ? ui.shadowXsDark : ui.shadowXs,
      isDark ? ui.shadowXsDark : ui.shadowXs,
      isDark ? ui.shadowXsDark : ui.shadowXs,
      isDark ? ui.shadowXsDark : ui.shadowXs,
      isDark ? ui.shadowXsDark : ui.shadowXs,
      isDark ? ui.shadowXsDark : ui.shadowXs,
      isDark ? ui.shadowXsDark : ui.shadowXs,
      isDark ? ui.shadowXsDark : ui.shadowXs,
      isDark ? ui.shadowXsDark : ui.shadowXs,
      isDark ? ui.shadowXsDark : ui.shadowXs,
      isDark ? ui.shadowXsDark : ui.shadowXs,
    ],

    components: {
      // ── MuiButton ─────────────────────────────────────────────────────────
      MuiButton: {
        defaultProps: { disableElevation: true },
        styleOverrides: {
          root: {
            borderRadius: '10px',
            fontWeight: 600,
            fontSize: '0.875rem',
            lineHeight: '1.25rem',
            textTransform: 'none',
            letterSpacing: 0,
            transition: 'all 0.15s ease',
            '&.Mui-disabled': {
              opacity: 0.5,
              cursor: 'not-allowed',
              pointerEvents: 'auto',
            },
          },
          sizeSmall:  { height: '36px', padding: '8px 14px',  fontSize: '0.875rem', gap: '6px' },
          sizeMedium: { height: '40px', padding: '10px 16px', fontSize: '0.875rem', gap: '6px' },
          sizeLarge:  { height: '44px', padding: '10px 18px', fontSize: '1rem',     gap: '8px' },

          // CONTAINED primary
          contained: {
            boxShadow: isDark ? ui.shadowXsDark : ui.shadowXs,
            '&.MuiButton-containedPrimary': {
              backgroundColor: ui.teal600,
              color:           '#ffffff',
              border:          `1px solid ${ui.teal600}`,
              '&:hover': {
                backgroundColor: ui.teal700,
                borderColor:     ui.teal700,
              },
              '&:focus-visible': {
                backgroundColor: ui.teal600,
                boxShadow: `${ui.shadowXs}, 0px 0px 0px 4px rgba(12,158,150,0.25)`,
                outline: 'none',
              },
              '&.Mui-disabled': {
                backgroundColor: isDark ? ui.teal700 : ui.teal200,
                borderColor:     isDark ? ui.teal700 : ui.teal200,
                color:           isDark ? 'rgba(255,255,255,0.4)' : '#ffffff',
                opacity: 1,
              },
            },
            '&.MuiButton-containedError': {
              backgroundColor: ui.error600,
              color:           '#ffffff',
              border:          `1px solid ${ui.error600}`,
              '&:hover': { backgroundColor: ui.error700, borderColor: ui.error700 },
              '&:focus-visible': {
                boxShadow: `${ui.shadowXs}, ${ui.shadowFocusError}`,
                outline: 'none',
              },
              '&.Mui-disabled': {
                backgroundColor: ui.error200,
                borderColor:     ui.error200,
                color:           '#ffffff',
                opacity: 1,
              },
            },
            '&.MuiButton-containedSuccess': {
              backgroundColor: ui.success600,
              color:           '#ffffff',
              border:          `1px solid ${ui.success600}`,
              '&:hover': { backgroundColor: ui.success700, borderColor: ui.success700 },
            },
          },

          // OUTLINED
          outlined: {
            boxShadow: isDark ? ui.shadowXsDark : ui.shadowXs,
            '&.MuiButton-outlinedPrimary': {
              backgroundColor: isDark ? 'rgba(12,158,150,0.08)' : ui.teal50,
              color:           isDark ? ui.teal300 : ui.teal700,
              border:          `1px solid ${isDark ? ui.teal300 : ui.teal300}`,
              '&:hover': {
                backgroundColor: isDark ? 'rgba(12,158,150,0.15)' : ui.teal100,
                borderColor:     ui.teal300,
              },
              '&:focus-visible': {
                boxShadow: `${ui.shadowXs}, 0px 0px 0px 4px rgba(12,158,150,0.25)`,
                outline: 'none',
              },
              '&.Mui-disabled': {
                backgroundColor: 'transparent',
                borderColor:     isDark ? ui.dark500 : ui.teal200,
                color:           isDark ? ui.dark400  : ui.teal300,
                opacity: 1,
              },
            },
            '&.MuiButton-outlinedInherit, &.MuiButton-outlinedSecondary': {
              backgroundColor: isDark ? 'transparent'  : '#ffffff',
              color:           isDark ? ui.dark200      : ui.gray700,
              border:          `1px solid ${isDark ? ui.dark500 : ui.gray300}`,
              '&:hover': {
                backgroundColor: isDark ? ui.dark600    : ui.gray50,
                borderColor:     isDark ? ui.dark400    : ui.gray300,
              },
              '&:focus-visible': {
                boxShadow: `${ui.shadowXs}, ${isDark ? '0px 0px 0px 4px rgba(71,85,105,0.5)' : ui.shadowFocusGray}`,
                outline: 'none',
              },
              '&.Mui-disabled': {
                backgroundColor: 'transparent',
                borderColor:     isDark ? ui.dark500 : ui.gray200,
                color:           isDark ? ui.dark400  : ui.gray300,
                opacity: 1,
              },
            },
            '&.MuiButton-outlinedError': {
              backgroundColor: isDark ? 'transparent' : '#ffffff',
              color:           ui.error700,
              border:          `1px solid ${ui.error300}`,
              '&:hover': { backgroundColor: isDark ? 'rgba(217,45,32,0.1)' : ui.error50, borderColor: ui.error300 },
            },
          },

          // TEXT
          text: {
            boxShadow: 'none',
            '&.MuiButton-textPrimary': {
              color: isDark ? ui.teal300 : ui.teal700,
              '&:hover': { backgroundColor: isDark ? 'rgba(12,158,150,0.10)' : ui.teal50 },
            },
            '&.MuiButton-textInherit, &.MuiButton-textSecondary': {
              color: isDark ? ui.dark200 : ui.gray600,
              '&:hover': { backgroundColor: isDark ? ui.dark600 : ui.gray50, color: isDark ? ui.dark50 : ui.gray700 },
            },
            '&.MuiButton-textError': {
              color: ui.error700,
              '&:hover': { backgroundColor: isDark ? 'rgba(217,45,32,0.1)' : ui.error50 },
            },
          },

          startIcon: { margin: 0 },
          endIcon:   { margin: 0 },
        },
      },

      // ── IconButton ────────────────────────────────────────────────────────
      MuiIconButton: {
        styleOverrides: {
          root: {
            borderRadius: '8px',
            transition: 'all 0.15s ease',
            '&:hover': { backgroundColor: isDark ? ui.dark600 : ui.gray100 },
            '&:focus-visible': {
              boxShadow: isDark ? '0px 0px 0px 4px rgba(71,85,105,0.5)' : ui.shadowFocusGray,
              outline: 'none',
            },
          },
          sizeSmall:  { padding: '6px' },
          sizeMedium: { padding: '8px' },
          sizeLarge:  { padding: '10px' },
        },
      },

      // ── TextField ─────────────────────────────────────────────────────────
      MuiTextField: {
        defaultProps: { size: 'small' },
        styleOverrides: {
          root: {
            '& .MuiOutlinedInput-root': {
              borderRadius: '10px',
              backgroundColor: isDark ? ui.dark600 : '#ffffff',
              fontSize: '0.875rem',
              color: isDark ? ui.dark50 : ui.gray900,
              '& fieldset': {
                borderColor: isDark ? ui.dark500 : ui.gray300,
                transition: 'border-color 0.15s ease, box-shadow 0.15s ease',
              },
              '&:hover fieldset':  { borderColor: isDark ? ui.dark400 : ui.gray400 },
              '&.Mui-focused fieldset': {
                borderColor: ui.teal600,
                boxShadow: '0px 0px 0px 4px rgba(12,158,150,0.20)',
                borderWidth: '1px',
              },
              '&.Mui-error fieldset': { borderColor: ui.error600 },
              '&.Mui-disabled': { backgroundColor: isDark ? ui.dark700 : ui.gray50 },
            },
            '& .MuiInputLabel-root': {
              fontSize: '0.875rem',
              color:    isDark ? ui.dark300 : ui.gray600,
              '&.Mui-focused': { color: isDark ? ui.teal300 : ui.teal700 },
              '&.Mui-error':   { color: ui.error600 },
            },
            '& .MuiFormHelperText-root': {
              fontSize: '0.75rem',
              marginTop: '6px',
              color: isDark ? ui.dark300 : ui.gray500,
              '&.Mui-error': { color: ui.error600 },
            },
          },
        },
      },

      // ── Select / OutlinedInput ────────────────────────────────────────────
      MuiSelect: {
        styleOverrides: {
          root: { borderRadius: '10px', fontSize: '0.875rem' },
        },
      },
      MuiOutlinedInput: {
        styleOverrides: {
          root: {
            borderRadius: '10px',
            backgroundColor: isDark ? ui.dark600 : 'transparent',
          },
          notchedOutline: { borderColor: isDark ? ui.dark500 : ui.gray300 },
        },
      },
      MuiInputLabel: {
        styleOverrides: {
          root: {
            fontSize: '0.875rem',
            color: isDark ? ui.dark300 : ui.gray600,
            '&.Mui-focused': { color: isDark ? ui.teal300 : ui.teal700 },
          },
        },
      },

      // ── MenuItem ──────────────────────────────────────────────────────────
      MuiMenuItem: {
        styleOverrides: {
          root: {
            fontSize: '0.875rem',
            color: isDark ? ui.dark100 : ui.gray700,
            borderRadius: '6px',
            margin: '2px 6px',
            padding: '8px 10px',
            '&:hover': { backgroundColor: isDark ? ui.dark600 : ui.gray50 },
            '&.Mui-selected': {
              backgroundColor: isDark ? 'rgba(12,158,150,0.15)' : ui.teal50,
              color:           isDark ? ui.teal300 : ui.teal700,
              fontWeight: 600,
              '&:hover': { backgroundColor: isDark ? 'rgba(12,158,150,0.22)' : ui.teal100 },
            },
          },
        },
      },

      // ── Card ──────────────────────────────────────────────────────────────
      MuiCard: {
        styleOverrides: {
          root: {
            borderRadius: '12px',
            border: isDark ? `1px solid ${ui.dark500}` : `1px solid ${ui.gray200}`,
            boxShadow: isDark ? ui.shadowXsDark : ui.shadowSm,
            backgroundColor: isDark ? ui.dark700 : '#ffffff',
            backdropFilter: 'none',
            WebkitBackdropFilter: 'none',
            transition: 'box-shadow 0.2s ease, transform 0.15s ease',
            '&:hover': {
              boxShadow: isDark ? '0px 4px 12px rgba(0,0,0,0.4)' : ui.shadowMd,
            },
          },
        },
      },

      // ── Paper ─────────────────────────────────────────────────────────────
      MuiPaper: {
        styleOverrides: {
          root: {
            borderRadius: '12px',
            backgroundColor: isDark ? ui.dark700 : '#ffffff',
            backdropFilter: 'none',
            WebkitBackdropFilter: 'none',
            border: isDark ? `1px solid ${ui.dark500}` : `1px solid ${ui.gray200}`,
          },
          elevation1: { boxShadow: isDark ? ui.shadowXsDark : ui.shadowSm },
          elevation2: { boxShadow: isDark ? '0px 4px 12px rgba(0,0,0,0.4)' : ui.shadowMd },
          elevation3: { boxShadow: isDark ? '0px 8px 24px rgba(0,0,0,0.5)' : ui.shadowLg },
        },
      },

      // ── Dialog ────────────────────────────────────────────────────────────
      MuiDialog: {
        styleOverrides: {
          root: {
            '& .MuiBackdrop-root': {
              backgroundColor: 'rgba(12,158,150,0.12)',
              backdropFilter: 'blur(6px)',
              WebkitBackdropFilter: 'blur(6px)',
            },
          },
          paper: {
            borderRadius: '20px',
            background: isDark
              ? 'rgba(15,23,42,0.90)'
              : 'rgba(255,255,255,0.80)',
            backdropFilter: 'blur(24px)',
            WebkitBackdropFilter: 'blur(24px)',
            border: isDark
              ? '1px solid rgba(255,255,255,0.08)'
              : '1px solid rgba(255,255,255,0.90)',
            boxShadow: '0 20px 60px rgba(12,158,150,0.20)',
          },
        },
      },
      MuiDialogTitle: {
        styleOverrides: {
          root: {
            fontSize: '1.1rem', fontWeight: 800,
            color: isDark ? ui.dark50 : '#1a2d3d',
            padding: '22px 28px 12px',
            borderBottom: isDark ? '1px solid rgba(255,255,255,0.08)' : '1px solid rgba(12,158,150,0.10)',
          },
        },
      },
      MuiDialogContent: {
        styleOverrides: { root: { padding: '16px 28px' } },
      },
      MuiDialogActions: {
        styleOverrides: {
          root: {
            padding: '12px 28px 22px', gap: '12px',
            borderTop: isDark ? '1px solid rgba(255,255,255,0.08)' : '1px solid rgba(12,158,150,0.10)',
            '& > :not(:first-of-type)': { marginLeft: 0 },
          },
        },
      },

      // ── Chip ──────────────────────────────────────────────────────────────
      MuiChip: {
        styleOverrides: {
          root: { borderRadius: '6px', fontWeight: 500, fontSize: '0.75rem', height: '22px' },
          label: { padding: '0 8px' },
        },
      },

      // ── Table ─────────────────────────────────────────────────────────────
      MuiTableCell: {
        styleOverrides: {
          head: {
            fontWeight: 600, fontSize: '0.72rem',
            color:           isDark ? ui.dark300 : ui.gray500,
            textTransform:   'uppercase',
            letterSpacing:   '0.04em',
            backgroundColor: isDark ? ui.dark800 : ui.gray50,
            backdropFilter:  'none',
            borderBottom:    `1px solid ${isDark ? ui.dark500 : ui.gray200}`,
          },
          body: {
            fontSize:    '0.875rem',
            color:       isDark ? ui.dark100 : ui.gray700,
            borderBottom:`1px solid ${isDark ? ui.dark500 : ui.gray100}`,
          },
        },
      },
      MuiTableRow: {
        styleOverrides: {
          root: {
            '&:hover td': { backgroundColor: isDark ? ui.dark600 : ui.gray25 },
            '&:last-child td': { borderBottom: 0 },
          },
        },
      },

      // ── Tooltip ───────────────────────────────────────────────────────────
      MuiTooltip: {
        styleOverrides: {
          tooltip: {
            backgroundColor: isDark ? ui.dark600 : ui.gray900,
            color:           '#ffffff',
            fontSize:        '0.75rem',
            fontWeight:      500,
            borderRadius:    '6px',
            padding:         '6px 10px',
            border:          isDark ? `1px solid ${ui.dark500}` : 'none',
          },
          arrow: { color: isDark ? ui.dark600 : ui.gray900 },
        },
      },

      // ── Alert ─────────────────────────────────────────────────────────────
      MuiAlert: {
        styleOverrides: {
          root: { borderRadius: '8px', fontSize: '0.875rem' },
        },
      },

      // ── Tab ───────────────────────────────────────────────────────────────
      MuiTab: {
        styleOverrides: {
          root: {
            textTransform: 'none',
            fontSize:      '0.875rem',
            fontWeight:    500,
            color:         isDark ? ui.dark300 : ui.gray500,
            '&.Mui-selected': { color: isDark ? ui.teal300 : ui.teal700, fontWeight: 600 },
          },
        },
      },

      // ── AppBar / Drawer ───────────────────────────────────────────────────
      MuiAppBar: {
        styleOverrides: {
          root: {
            boxShadow:       `0px 1px 0px ${isDark ? ui.dark500 : ui.gray200}`,
            backgroundColor: isDark ? ui.dark700 : '#ffffff',
            color:           isDark ? ui.dark50  : ui.gray900,
          },
        },
      },
      MuiDrawer: {
        styleOverrides: {
          paper: { borderRight: `1px solid ${isDark ? ui.dark500 : ui.gray200}` },
        },
      },

      // ── CssBaseline ───────────────────────────────────────────────────────
      MuiCssBaseline: {
        styleOverrides: {
          '*': { boxSizing: 'border-box' },
          body: {
            fontFamily: '"Inter", "Roboto", "Helvetica", "Arial", sans-serif',
            color:      isDark ? ui.dark50  : ui.gray900,
            backgroundColor: isDark ? ui.dark800 : ui.gray50,
            '-webkit-font-smoothing':  'antialiased',
            '-moz-osx-font-smoothing': 'grayscale',
          },
          '*:focus-visible': { outline: 'none' },
          // Dark mode scrollbar
          ...(isDark && {
            '*::-webkit-scrollbar':       { width: '6px', height: '6px' },
            '*::-webkit-scrollbar-track': { background: ui.dark700 },
            '*::-webkit-scrollbar-thumb': { background: ui.dark500, borderRadius: '3px' },
            '*::-webkit-scrollbar-thumb:hover': { background: ui.dark400 },
          }),
        },
      },
    },
  });
}
