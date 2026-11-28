import { createTheme } from '@mui/material/styles';

// ─── Design tokens ────────────────────────────────────────────────────────────
const ui = {
  // Brand / Primary (navy #092A43)
  brand600:  '#1d2320',
  brand700:  '#141917',
  brand50:   '#ecebe4',
  brand100:  '#dcd8cc',
  brand200:  '#b8b3a5',
  brand300:  '#7d786c',

  // Teal (new primary — #092A43 navy stays for sidebar bg only)
  teal600:  '#c8410e',
  teal700:  '#a3330a',
  teal500:  '#ff5a1f',
  teal50:   '#fdeee6',
  teal100:  '#fbdccb',
  teal200:  '#f6b89a',
  teal300:  '#ff8a5c',

  // Grays (light mode)
  gray25:  '#fbfaf7',
  gray50:  '#f1efe8',
  gray100: '#e9e6dc',
  gray200: '#dcd8cc',
  gray300: '#c8c3b5',
  gray400: '#9d978a',
  gray500: '#6f6a5f',
  gray600: '#57534a',
  gray700: '#3f3c36',
  gray800: '#2a2925',
  gray900: '#1d2320',

  // Dark mode surfaces
  dark900: '#121614',   // deepest bg
  dark800: '#171c1a',   // page background
  dark700: '#1f2522',   // paper / card
  dark600: '#29302c',   // elevated surface
  dark500: '#39413c',   // border / divider
  dark400: '#59615b',   // subtle text
  dark300: '#7f877f',   // muted text
  dark200: '#a6ada4',   // secondary text
  dark100: '#cfd3cb',   // primary text (subdued)
  dark50:  '#f1efe8',   // primary text

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
  shadowXs:        '0px 1px 2px rgba(29, 35, 32, 0.05)',
  shadowSm:        '0px 1px 3px rgba(29, 35, 32, 0.10), 0px 1px 2px rgba(29, 35, 32, 0.06)',
  shadowMd:        '0px 4px 8px -2px rgba(29, 35, 32, 0.10), 0px 2px 4px -2px rgba(29, 35, 32, 0.06)',
  shadowLg:        '0px 12px 16px -4px rgba(29, 35, 32, 0.08), 0px 4px 6px -2px rgba(29, 35, 32, 0.03)',
  shadowFocusBrand:'0px 0px 0px 3px rgba(255,90,31,0.28)',
  shadowFocusError:'0px 0px 0px 4px #FEE4E2',
  shadowFocusGray: '0px 0px 0px 3px rgba(29,35,32,0.14)',

  // Dark shadow
  shadowXsDark: '0px 1px 2px rgba(0,0,0,0.4)',
  shadowFocusBrandDark: '0px 0px 0px 3px rgba(255,138,92,0.35)',
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
        main:  '#3f3c36',
        light: '#9d978a',
        dark:  '#1d2320',
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
      fontFamily: '"Barlow", "Segoe UI", system-ui, sans-serif',
      h1: { fontFamily: '"Barlow Condensed", "Barlow", sans-serif', fontWeight: 700, letterSpacing: '0.01em' },
      h2: { fontFamily: '"Barlow Condensed", "Barlow", sans-serif', fontWeight: 700, letterSpacing: '0.01em' },
      h3: { fontFamily: '"Barlow Condensed", "Barlow", sans-serif', fontWeight: 700, letterSpacing: '0.01em' },
      h4: { fontFamily: '"Barlow Condensed", "Barlow", sans-serif', fontWeight: 700, letterSpacing: '0.01em' },
      h5: { fontFamily: '"Barlow Condensed", "Barlow", sans-serif', fontWeight: 700, letterSpacing: '0.01em' },
      h6: { fontFamily: '"Barlow Condensed", "Barlow", sans-serif', fontWeight: 700, letterSpacing: '0.02em', fontSize: '1.15rem' },
      body1: { fontSize: '0.95rem' },
      body2: { fontSize: '0.875rem' },
      button: {
        fontSize:      '0.875rem',
        fontWeight:    600,
        lineHeight:    '1.25rem',
        textTransform: 'none',
        letterSpacing: 0,
      },
    },

    shape: { borderRadius: 8 },

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
                boxShadow: `${ui.shadowXs}, 0px 0px 0px 4px rgba(255,90,31,0.25)`,
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
              backgroundColor: isDark ? 'rgba(255,90,31,0.08)' : ui.teal50,
              color:           isDark ? ui.teal300 : ui.teal700,
              border:          `1px solid ${isDark ? ui.teal300 : ui.teal300}`,
              '&:hover': {
                backgroundColor: isDark ? 'rgba(255,90,31,0.15)' : ui.teal100,
                borderColor:     ui.teal300,
              },
              '&:focus-visible': {
                boxShadow: `${ui.shadowXs}, 0px 0px 0px 4px rgba(255,90,31,0.25)`,
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
              '&:hover': { backgroundColor: isDark ? 'rgba(255,90,31,0.10)' : ui.teal50 },
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
                boxShadow: '0px 0px 0px 4px rgba(255,90,31,0.20)',
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
              backgroundColor: isDark ? 'rgba(255,90,31,0.15)' : ui.teal50,
              color:           isDark ? ui.teal300 : ui.teal700,
              fontWeight: 600,
              '&:hover': { backgroundColor: isDark ? 'rgba(255,90,31,0.22)' : ui.teal100 },
            },
          },
        },
      },

      // ── Card ──────────────────────────────────────────────────────────────
      MuiCard: {
        styleOverrides: {
          root: {
            borderRadius: '10px',
            border: isDark ? `1px solid ${ui.dark500}` : `1px solid ${ui.gray200}`,
            boxShadow: 'none',
            backgroundColor: isDark ? ui.dark700 : '#ffffff',
            backdropFilter: 'none',
            WebkitBackdropFilter: 'none',
            
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
            '& .MuiBackdrop-root': { backgroundColor: 'rgba(29,35,32,0.45)' },
          },
          paper: {
            borderRadius: '12px',
            background: isDark ? ui.dark700 : '#ffffff',
            border: `1px solid ${isDark ? ui.dark500 : ui.gray200}`,
            boxShadow: '0 24px 48px -12px rgba(29,35,32,0.35)',
          },
        },
      },
      MuiDialogTitle: {
        styleOverrides: {
          root: {
            fontFamily: '"Barlow Condensed", "Barlow", sans-serif', fontSize: '1.35rem', fontWeight: 700,
            color: isDark ? ui.dark50 : ui.gray900,
            padding: '22px 28px 12px',
            borderBottom: isDark ? '1px solid rgba(255,255,255,0.08)' : `1px solid ${ui.gray200}`,
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
            borderTop: isDark ? '1px solid rgba(255,255,255,0.08)' : `1px solid ${ui.gray200}`,
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
            '&.Mui-selected': { color: isDark ? ui.teal300 : ui.gray900, fontWeight: 700 },
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
            fontFamily: '"Barlow", "Segoe UI", system-ui, sans-serif',
            fontVariantNumeric: 'tabular-nums',
            color:      isDark ? ui.dark50  : ui.gray900,
            backgroundColor: isDark ? ui.dark800 : ui.gray50,
            '-webkit-font-smoothing':  'antialiased',
            '-moz-osx-font-smoothing': 'grayscale',
          },
          '*:focus-visible': { outline: '2px solid #ff5a1f', outlineOffset: '2px' },
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
