import React, { useState, useEffect, useRef } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import { authHeaders } from '../utils/api';
import {
  Box,
  Grid,
  Card,
  CardContent,
  Typography,
  Button,
  Chip,
  Alert,
  Avatar,
  Divider,
  Paper,
  List,
  ListItem,
  ListItemText,
  ListItemIcon,
  Dialog,
  DialogTitle,
  DialogContent,
  DialogActions,
  CircularProgress,
  IconButton,
  LinearProgress,
  Tooltip,
  TextField,
  Stack,
  InputAdornment
} from '@mui/material';
import {
  ArrowBack as ArrowBackIcon,
  Person as PersonIcon,
  EmojiEvents as TrophyIcon,
  Group as GroupIcon,
  Star as StarIcon,
  Sports as SportsIcon,
  Phone as PhoneIcon,
  Email as EmailIcon,
  PhotoCamera as PhotoCameraIcon,
  CloudUpload as CloudUploadIcon,
  Height as HeightIcon,
  FitnessCenter as WeightIcon,
  Cake as CakeIcon,
  Flag as FlagIcon,
  Shield as ShieldIcon,
  Security as SecurityIcon,
  SwapHoriz as SwapHorizIcon,
  TrendingUp as TrendingUpIcon,
  GpsFixed as GpsFixedIcon,
  DirectionsRun as RunIcon,
  Timer as TimerIcon,
  Gavel as GavelIcon,
  ReportProblem as FoulIcon,
  PanTool as PanToolIcon,
  Verified as VerifiedIcon,
  FlightTakeoff as FlightIcon,
  BarChart as ChartIcon,
  Edit as EditIcon,
  Save as SaveIcon,
  Add as AddIcon,
  WorkspacePremium as BadgeIcon,
} from '@mui/icons-material';

// ─── helpers ──────────────────────────────────────────────────────────────────
const toInt = (v) => {
  if (v == null) return 0;
  if (typeof v === 'number') return Math.round(v);
  return parseInt(v, 10) || 0;
};

// ─── position logic ───────────────────────────────────────────────────────────
const detectPosition = (pos) => {
  if (!pos) return 'autre';
  const p = pos.toLowerCase();
  if (p.includes('gard') || p === 'gk' || p === 'goalkeeper') return 'gardien';
  if (p.includes('def') || ['cb','lb','rb','rwb','lwb'].includes(p)) return 'defenseur';
  if (p.includes('mil') || ['cm','cdm','cam','lm','rm','dm'].includes(p)) return 'milieu';
  if (p.includes('att') || p.includes('avant') || ['st','cf','lw','rw','ss'].includes(p)) return 'attaquant';
  return 'autre';
};

const positionMeta = {
  gardien:   { label: 'Gardien de but',     color: '#c8410e', bg: '#fdeee6', icon: <ShieldIcon /> },
  defenseur: { label: 'Défenseur',           color: '#2f7d4a', bg: '#e6efe7', icon: <SecurityIcon /> },
  milieu:    { label: 'Milieu de terrain',   color: '#c8410e', bg: '#fdeee6', icon: <SwapHorizIcon /> },
  attaquant: { label: 'Attaquant',           color: '#EF4444', bg: '#FEF2F2', icon: <TrendingUpIcon /> },
  autre:     { label: 'Joueur',              color: '#6f6a5f', bg: '#f6f4ee', icon: <PersonIcon /> },
};

// ─── KPI cards per position ───────────────────────────────────────────────────
const headerKpis = (pos, stats) => {
  switch (pos) {
    case 'gardien': return [
      { label: 'Arrêts',          value: toInt(stats.saves),          color: '#c8410e', icon: <PanToolIcon /> },
      { label: 'Clean sheets',    value: toInt(stats.cleanSheets),    color: '#2f7d4a', icon: <VerifiedIcon /> },
      { label: 'Matchs joués',    value: toInt(stats.matchesPlayed),  color: '#F59E0B', icon: <SportsIcon /> },
      { label: 'Pénaltys arrêtés',value: toInt(stats.penaltiesSaved), color: '#c8410e', icon: <SecurityIcon /> },
    ];
    case 'defenseur': return [
      { label: 'Tacles',          value: toInt(stats.tackles),        color: '#c8410e', icon: <SportsIcon /> },
      { label: 'Interceptions',   value: toInt(stats.interceptions),  color: '#2f7d4a', icon: <PanToolIcon /> },
      { label: 'Matchs joués',    value: toInt(stats.matchesPlayed),  color: '#F59E0B', icon: <SportsIcon /> },
      { label: 'Duels gagnés',    value: toInt(stats.duelsWon),       color: '#c8410e', icon: <TrophyIcon /> },
    ];
    case 'milieu': return [
      { label: 'Passes',          value: toInt(stats.passes),         color: '#c8410e', icon: <SwapHorizIcon /> },
      { label: 'Passes déc.',     value: toInt(stats.assists),        color: '#2f7d4a', icon: <TrendingUpIcon /> },
      { label: 'Buts',            value: toInt(stats.goals),          color: '#c8410e', icon: <SportsIcon /> },
      { label: 'Matchs joués',    value: toInt(stats.matchesPlayed),  color: '#F59E0B', icon: <SportsIcon /> },
    ];
    default: return [ // attaquant + autre
      { label: 'Buts',            value: toInt(stats.goals),          color: '#2f7d4a', icon: <SportsIcon /> },
      { label: 'Passes déc.',     value: toInt(stats.assists),        color: '#c8410e', icon: <TrendingUpIcon /> },
      { label: 'Matchs joués',    value: toInt(stats.matchesPlayed),  color: '#F59E0B', icon: <SportsIcon /> },
      { label: 'Tirs cadrés',     value: toInt(stats.shotsOnTarget),  color: '#EF4444', icon: <GpsFixedIcon /> },
    ];
  }
};

// ─── Sections per position ────────────────────────────────────────────────────
const sectionsForPosition = (pos, stats) => {
  switch (pos) {
    case 'gardien': return [
      {
        title: 'Gardiennage', color: '#c8410e', icon: <ShieldIcon />,
        rows: [
          { label: 'Arrêts',                key: 'saves',          icon: <PanToolIcon /> },
          { label: 'Clean sheets',          key: 'cleanSheets',    icon: <VerifiedIcon /> },
          { label: 'Buts encaissés',        key: 'goalsConceded',  icon: <SportsIcon /> },
          { label: 'Pénaltys arrêtés',      key: 'penaltiesSaved', icon: <SecurityIcon /> },
        ],
      },
      {
        title: 'Jeu au pied', color: '#2f7d4a', icon: <SwapHorizIcon />,
        rows: [
          { label: 'Passes',        key: 'passes',     icon: <SwapHorizIcon /> },
          { label: 'Passes clés',   key: 'keyPasses',  icon: <StarIcon /> },
          { label: 'Dégagements',   key: 'clearances', icon: <RunIcon /> },
        ],
      },
      {
        title: 'Jeu aérien', color: '#c8410e', icon: <FlightIcon />,
        rows: [
          { label: 'Duels aériens gagnés', key: 'aerialDuelsWon', icon: <FlightIcon /> },
        ],
      },
      {
        title: 'Discipline', color: '#F59E0B', icon: <GavelIcon />,
        rows: [
          { label: 'Cartons jaunes', key: 'yellowCards', icon: <GavelIcon /> },
          { label: 'Cartons rouges', key: 'redCards',    icon: <GavelIcon /> },
        ],
      },
    ];

    case 'defenseur': return [
      {
        title: 'Défense', color: '#c8410e', icon: <ShieldIcon />,
        rows: [
          { label: 'Tacles',        key: 'tackles',        icon: <SportsIcon /> },
          { label: 'Interceptions', key: 'interceptions',  icon: <PanToolIcon /> },
          { label: 'Dégagements',   key: 'clearances',     icon: <RunIcon /> },
          { label: 'Duels gagnés',  key: 'duelsWon',       icon: <TrophyIcon /> },
        ],
      },
      {
        title: 'Jeu aérien', color: '#c8410e', icon: <FlightIcon />,
        rows: [
          { label: 'Duels aériens gagnés', key: 'aerialDuelsWon', icon: <FlightIcon /> },
        ],
      },
      {
        title: 'Passes', color: '#2f7d4a', icon: <SwapHorizIcon />,
        rows: [
          { label: 'Passes',       key: 'passes',    icon: <SwapHorizIcon /> },
          { label: 'Passes clés',  key: 'keyPasses', icon: <StarIcon /> },
        ],
      },
      {
        title: 'Attaque', color: '#EF4444', icon: <TrendingUpIcon />,
        rows: [
          { label: 'Buts',         key: 'goals',   icon: <SportsIcon /> },
          { label: 'Passes déc.',  key: 'assists', icon: <TrendingUpIcon /> },
        ],
      },
      {
        title: 'Fautes', color: '#F87171', icon: <FoulIcon />,
        rows: [
          { label: 'Fautes commises', key: 'foulsCommitted', icon: <FoulIcon /> },
          { label: 'Fautes subies',   key: 'foulsSuffered',  icon: <PersonIcon /> },
        ],
      },
      {
        title: 'Discipline', color: '#F59E0B', icon: <GavelIcon />,
        rows: [
          { label: 'Cartons jaunes', key: 'yellowCards', icon: <GavelIcon /> },
          { label: 'Cartons rouges', key: 'redCards',    icon: <GavelIcon /> },
        ],
      },
    ];

    case 'milieu': return [
      {
        title: 'Passes', color: '#c8410e', icon: <SwapHorizIcon />,
        rows: [
          { label: 'Passes',       key: 'passes',    icon: <SwapHorizIcon /> },
          { label: 'Passes clés',  key: 'keyPasses', icon: <StarIcon /> },
          { label: 'Passes déc.',  key: 'assists',   icon: <TrendingUpIcon /> },
        ],
      },
      {
        title: 'Attaque', color: '#2f7d4a', icon: <TrendingUpIcon />,
        rows: [
          { label: 'Buts',          key: 'goals',          icon: <SportsIcon /> },
          { label: 'Tirs',          key: 'shots',          icon: <GpsFixedIcon /> },
          { label: 'Tirs cadrés',   key: 'shotsOnTarget',  icon: <GpsFixedIcon /> },
          { label: 'Dribbles',      key: 'dribbles',       icon: <RunIcon /> },
        ],
      },
      {
        title: 'Défense', color: '#c8410e', icon: <ShieldIcon />,
        rows: [
          { label: 'Tacles',        key: 'tackles',       icon: <SportsIcon /> },
          { label: 'Interceptions', key: 'interceptions', icon: <PanToolIcon /> },
        ],
      },
      {
        title: 'Fautes', color: '#F87171', icon: <FoulIcon />,
        rows: [
          { label: 'Fautes commises', key: 'foulsCommitted', icon: <FoulIcon /> },
          { label: 'Fautes subies',   key: 'foulsSuffered',  icon: <PersonIcon /> },
        ],
      },
      {
        title: 'Discipline', color: '#F59E0B', icon: <GavelIcon />,
        rows: [
          { label: 'Cartons jaunes', key: 'yellowCards', icon: <GavelIcon /> },
          { label: 'Cartons rouges', key: 'redCards',    icon: <GavelIcon /> },
        ],
      },
    ];

    default: // attaquant + autre
      return [
        {
          title: 'Attaque', color: '#EF4444', icon: <TrendingUpIcon />,
          rows: [
            { label: 'Buts',          key: 'goals',          icon: <SportsIcon /> },
            { label: 'Passes déc.',   key: 'assists',        icon: <TrendingUpIcon /> },
            { label: 'Tirs',          key: 'shots',          icon: <GpsFixedIcon /> },
            { label: 'Tirs cadrés',   key: 'shotsOnTarget',  icon: <GpsFixedIcon /> },
            { label: 'Dribbles',      key: 'dribbles',       icon: <RunIcon /> },
            { label: 'Hors-jeu',      key: 'offsides',       icon: <FlagIcon /> },
          ],
        },
        {
          title: 'Passes', color: '#c8410e', icon: <SwapHorizIcon />,
          rows: [
            { label: 'Passes',       key: 'passes',    icon: <SwapHorizIcon /> },
            { label: 'Passes clés',  key: 'keyPasses', icon: <StarIcon /> },
          ],
        },
        {
          title: 'Fautes', color: '#F87171', icon: <FoulIcon />,
          rows: [
            { label: 'Fautes commises', key: 'foulsCommitted', icon: <FoulIcon /> },
            { label: 'Fautes subies',   key: 'foulsSuffered',  icon: <PersonIcon /> },
          ],
        },
        {
          title: 'Discipline', color: '#F59E0B', icon: <GavelIcon />,
          rows: [
            { label: 'Cartons jaunes', key: 'yellowCards', icon: <GavelIcon /> },
            { label: 'Cartons rouges', key: 'redCards',    icon: <GavelIcon /> },
          ],
        },
      ];
  }
};

// ─── Radar values per position ────────────────────────────────────────────────
const radarAxes = (pos, stats) => {
  switch (pos) {
    case 'gardien': return [
      { label: 'ARRÊTS',     value: Math.min(toInt(stats.saves) * 8, 99) },
      { label: 'CLEAN SH.', value: Math.min(toInt(stats.cleanSheets) * 20, 99) },
      { label: 'PASSES',    value: Math.min(toInt(stats.passes) * 0.8, 99) },
      { label: 'RÉFLEXES',  value: Math.min(toInt(stats.saves) * 6 + toInt(stats.penaltiesSaved) * 15, 99) },
      { label: 'POSITION',  value: Math.min(toInt(stats.saves) * 4 + toInt(stats.cleanSheets) * 10, 99) },
      { label: 'AÉRIEN',    value: Math.min(toInt(stats.aerialDuelsWon) * 8 + toInt(stats.clearances) * 5, 99) },
    ];
    case 'defenseur': return [
      { label: 'TACLES',   value: Math.min(toInt(stats.tackles) * 8, 99) },
      { label: 'INTERC.',  value: Math.min(toInt(stats.interceptions) * 8, 99) },
      { label: 'DÉGAG.',   value: Math.min(toInt(stats.clearances) * 6, 99) },
      { label: 'PASSES',   value: Math.min(toInt(stats.passes) * 0.5, 99) },
      { label: 'DUELS',    value: Math.min(toInt(stats.duelsWon) * 5, 99) },
      { label: 'AÉRIEN',   value: Math.min(toInt(stats.aerialDuelsWon) * 8, 99) },
    ];
    case 'milieu': return [
      { label: 'PASSES',    value: Math.min(toInt(stats.passes) * 0.5, 99) },
      { label: 'PASSES D.', value: Math.min(toInt(stats.assists) * 15 + toInt(stats.keyPasses) * 8, 99) },
      { label: 'BUTS',      value: Math.min(toInt(stats.goals) * 20, 99) },
      { label: 'TACLES',    value: Math.min(toInt(stats.tackles) * 8, 99) },
      { label: 'DRIBBLES',  value: Math.min(toInt(stats.dribbles) * 10, 99) },
      { label: 'PHYSIQUE',  value: Math.min(toInt(stats.minutesPlayed) / 10, 99) },
    ];
    default: return [
      { label: 'BUTS',      value: Math.min(toInt(stats.goals) * 20, 99) },
      { label: 'PASSES D.', value: Math.min(toInt(stats.assists) * 15, 99) },
      { label: 'TIRS',      value: Math.min(toInt(stats.shots) * 5 + toInt(stats.shotsOnTarget) * 8, 99) },
      { label: 'DRIBBLES',  value: Math.min(toInt(stats.dribbles) * 10, 99) },
      { label: 'VITESSE',   value: Math.min(toInt(stats.dribbles) * 8 + toInt(stats.offsides) * 3, 99) },
      { label: 'PHYSIQUE',  value: Math.min(toInt(stats.minutesPlayed) / 10, 99) },
    ];
  }
};

// ─── Sub-components ───────────────────────────────────────────────────────────
const KpiCard = ({ label, value, color, icon }) => (
  <Paper elevation={0} sx={{
    p: 2, borderRadius: '10px', border: '1px solid rgba(241,239,232,0.14)',
    background: 'rgba(241,239,232,0.05)',
    display: 'flex', alignItems: 'center', gap: 1.5,
  }}>
    <Box sx={{ color, display: 'flex' }}>{icon}</Box>
    <Box>
      <Typography sx={{ fontFamily: '"Barlow Condensed", sans-serif', fontSize: 32, fontWeight: 700, color: '#f1efe8', lineHeight: 1 }}>{value}</Typography>
      <Typography sx={{ fontSize: 13, color: '#bdb9ad', fontWeight: 500 }}>{label}</Typography>
    </Box>
  </Paper>
);

const StatRow = ({ label, value, icon, color }) => (
  <Box sx={{ display: 'flex', alignItems: 'center', py: 1, borderBottom: '1px solid #ecebe4' }}>
    <Box sx={{ color: color || 'text.secondary', display: 'flex', mr: 1.5, '& svg': { fontSize: 18 } }}>{icon}</Box>
    <Typography sx={{ flexGrow: 1, fontSize: 13, color: 'text.secondary' }}>{label}</Typography>
    <Chip label={value} size="small" sx={{
      fontWeight: 700, fontSize: 13,
      bgcolor: value === 0 ? '#f6f4ee' : `${color}18`,
      color: value === 0 ? 'text.disabled' : color || 'text.primary',
      border: `1px solid ${value === 0 ? '#dcd8cc' : `${color}40`}`,
      minWidth: 36,
    }} />
  </Box>
);

const RadarBar = ({ label, value }) => (
  <Box sx={{ mb: 1.5 }}>
    <Box sx={{ display: 'flex', justifyContent: 'space-between', mb: 0.5 }}>
      <Typography sx={{ fontSize: 11, fontWeight: 600, color: 'text.secondary' }}>{label}</Typography>
      <Typography sx={{ fontSize: 11, fontWeight: 700, color: 'primary.main' }}>{Math.round(value)}</Typography>
    </Box>
    <LinearProgress
      variant="determinate"
      value={value}
      sx={{
        height: 8, borderRadius: 4,
        bgcolor: '#fdeee6',
        '& .MuiLinearProgress-bar': {
          borderRadius: 4,
          background: `#c8410e`,
        },
      }}
    />
  </Box>
);

const SectionCard = ({ title, color, icon, children }) => (
  <Card elevation={0} sx={{ border: `1.5px solid ${color}20`, borderRadius: 3, mb: 2 }}>
    <CardContent sx={{ pb: '16px !important' }}>
      <Box sx={{ display: 'flex', alignItems: 'center', gap: 1, mb: 1.5 }}>
        <Box sx={{
          display: 'flex', alignItems: 'center', gap: 1,
          bgcolor: `${color}12`, px: 1.5, py: 0.5, borderRadius: 20,
        }}>
          <Box sx={{ color, display: 'flex', '& svg': { fontSize: 16 } }}>{icon}</Box>
          <Typography sx={{ fontSize: 12, fontWeight: 700, color, textTransform: 'uppercase', letterSpacing: 0.5 }}>
            {title}
          </Typography>
        </Box>
      </Box>
      {children}
    </CardContent>
  </Card>
);

// ─── Stats fields per position ────────────────────────────────────────────────
const statsFieldsByPosition = (pos) => {
  switch (pos) {
    case 'gardien': return [
      { section: 'Gardiennage', color: '#c8410e', fields: [
        { key: 'saves',          label: 'Arrêts' },
        { key: 'cleanSheets',    label: 'Clean sheets' },
        { key: 'goalsConceded',  label: 'Buts encaissés' },
        { key: 'penaltiesSaved', label: 'Pénaltys arrêtés' },
      ]},
      { section: 'Jeu au pied', color: '#2f7d4a', fields: [
        { key: 'passes',     label: 'Passes' },
        { key: 'keyPasses',  label: 'Passes clés' },
        { key: 'clearances', label: 'Dégagements' },
      ]},
      { section: 'Jeu aérien', color: '#c8410e', fields: [
        { key: 'aerialDuelsWon', label: 'Duels aériens gagnés' },
      ]},
      { section: 'Discipline', color: '#F59E0B', fields: [
        { key: 'yellowCards',   label: 'Cartons jaunes' },
        { key: 'redCards',      label: 'Cartons rouges' },
        { key: 'minutesPlayed', label: 'Minutes jouées' },
      ]},
    ];

    case 'defenseur': return [
      { section: 'Défense', color: '#c8410e', fields: [
        { key: 'tackles',       label: 'Tacles' },
        { key: 'interceptions', label: 'Interceptions' },
        { key: 'clearances',    label: 'Dégagements' },
        { key: 'duelsWon',      label: 'Duels gagnés' },
        { key: 'aerialDuelsWon',label: 'Duels aériens gagnés' },
      ]},
      { section: 'Passes', color: '#2f7d4a', fields: [
        { key: 'passes',    label: 'Passes' },
        { key: 'keyPasses', label: 'Passes clés' },
        { key: 'assists',   label: 'Passes décisives' },
      ]},
      { section: 'Attaque', color: '#EF4444', fields: [
        { key: 'goals', label: 'Buts' },
      ]},
      { section: 'Fautes & Discipline', color: '#F59E0B', fields: [
        { key: 'foulsCommitted', label: 'Fautes commises' },
        { key: 'foulsSuffered',  label: 'Fautes subies' },
        { key: 'yellowCards',    label: 'Cartons jaunes' },
        { key: 'redCards',       label: 'Cartons rouges' },
        { key: 'minutesPlayed',  label: 'Minutes jouées' },
      ]},
    ];

    case 'milieu': return [
      { section: 'Passes', color: '#c8410e', fields: [
        { key: 'passes',    label: 'Passes' },
        { key: 'keyPasses', label: 'Passes clés' },
        { key: 'assists',   label: 'Passes décisives' },
      ]},
      { section: 'Attaque', color: '#2f7d4a', fields: [
        { key: 'goals',         label: 'Buts' },
        { key: 'shots',         label: 'Tirs' },
        { key: 'shotsOnTarget', label: 'Tirs cadrés' },
        { key: 'dribbles',      label: 'Dribbles' },
      ]},
      { section: 'Défense', color: '#c8410e', fields: [
        { key: 'tackles',       label: 'Tacles' },
        { key: 'interceptions', label: 'Interceptions' },
      ]},
      { section: 'Fautes & Discipline', color: '#F59E0B', fields: [
        { key: 'foulsCommitted', label: 'Fautes commises' },
        { key: 'foulsSuffered',  label: 'Fautes subies' },
        { key: 'yellowCards',    label: 'Cartons jaunes' },
        { key: 'redCards',       label: 'Cartons rouges' },
        { key: 'minutesPlayed',  label: 'Minutes jouées' },
      ]},
    ];

    default: // attaquant
      return [
        { section: 'Attaque', color: '#EF4444', fields: [
          { key: 'goals',         label: 'Buts' },
          { key: 'assists',       label: 'Passes décisives' },
          { key: 'shots',         label: 'Tirs' },
          { key: 'shotsOnTarget', label: 'Tirs cadrés' },
          { key: 'dribbles',      label: 'Dribbles' },
          { key: 'offsides',      label: 'Hors-jeu' },
        ]},
        { section: 'Passes', color: '#c8410e', fields: [
          { key: 'passes',    label: 'Passes' },
          { key: 'keyPasses', label: 'Passes clés' },
        ]},
        { section: 'Fautes & Discipline', color: '#F59E0B', fields: [
          { key: 'foulsCommitted', label: 'Fautes commises' },
          { key: 'foulsSuffered',  label: 'Fautes subies' },
          { key: 'yellowCards',    label: 'Cartons jaunes' },
          { key: 'redCards',       label: 'Cartons rouges' },
          { key: 'minutesPlayed',  label: 'Minutes jouées' },
        ]},
      ];
  }
};

// ─── Badge constants ──────────────────────────────────────────────────────────
const BADGE_TYPES = [
  { value: 'tournament',    label: 'Tournoi',         emoji: '🏆' },
  { value: 'achievement',   label: 'Accomplissement', emoji: '⭐' },
  { value: 'match',         label: 'Match',           emoji: '⚽' },
  { value: 'training',      label: 'Entraînement',    emoji: '💪' },
  { value: 'participation', label: 'Participation',   emoji: '🎖️' },
  { value: 'excellence',    label: 'Excellence',      emoji: '👑' },
];

const BADGE_RARITIES = [
  { value: 'common',    label: 'Commun',     color: '#9d978a' },
  { value: 'uncommon',  label: 'Peu commun', color: '#2f7d4a' },
  { value: 'rare',      label: 'Rare',       color: '#c8410e' },
  { value: 'epic',      label: 'Épique',     color: '#c8410e' },
  { value: 'legendary', label: 'Légendaire', color: '#F59E0B' },
];

const BADGE_ICONS = ['🏆', '⭐', '⚽', '🥅', '🎯', '🔥', '💪', '🛡️', '👑', '💎', '🎖️', '🌟'];

const rarityColor = (r) => {
  const found = BADGE_RARITIES.find(x => x.value === r);
  return found ? found.color : '#9d978a';
};

// Small card to display an awarded badge
const BadgeDisplayCard = ({ badge }) => {
  const color = rarityColor(badge.rarity);
  const rarityLabel = BADGE_RARITIES.find(r => r.value === badge.rarity)?.label ?? badge.rarity;
  const typeLabel   = BADGE_TYPES.find(t => t.value === badge.type)?.label ?? badge.type;
  const fmtDate = (d) => { try { return new Date(d).toLocaleDateString('fr-FR'); } catch { return ''; } };

  return (
    <Paper elevation={0} sx={{
      p: 2, borderRadius: 2.5,
      border: `1.5px solid ${color}50`,
      background: `${color}0d`,
      height: '100%',
    }}>
      <Box sx={{ display: 'flex', alignItems: 'flex-start', gap: 1.5 }}>
        <Box sx={{
          fontSize: 26, lineHeight: 1,
          bgcolor: `${color}20`, p: 1, borderRadius: 1.5,
          flexShrink: 0,
        }}>
          {badge.icon || '🏅'}
        </Box>
        <Box sx={{ minWidth: 0 }}>
          <Typography sx={{ fontWeight: 700, fontSize: 13, lineHeight: 1.3, mb: 0.5 }}>
            {badge.name}
          </Typography>
          <Box sx={{ display: 'flex', gap: 0.5, flexWrap: 'wrap', mb: 0.5 }}>
            <Chip label={rarityLabel} size="small"
              sx={{ fontSize: 10, height: 18, bgcolor: `${color}20`, color, fontWeight: 700,
                    border: `1px solid ${color}40` }} />
            <Chip label={typeLabel} size="small"
              sx={{ fontSize: 10, height: 18, bgcolor: '#f6f4ee', color: '#6f6a5f' }} />
          </Box>
          {badge.description && (
            <Typography sx={{ fontSize: 11, color: 'text.secondary', mb: 0.5 }}>{badge.description}</Typography>
          )}
          <Typography sx={{ fontSize: 10, color: 'text.disabled' }}>
            Par {badge.awardedBy || 'Admin'} · {fmtDate(badge.createdAt || badge.date)}
          </Typography>
        </Box>
      </Box>
    </Paper>
  );
};

// ─── Main component ───────────────────────────────────────────────────────────
const PlayerDetails = () => {
  const { id } = useParams();
  const navigate = useNavigate();
  const fileInputRef = useRef(null);

  const [player, setPlayer]     = useState(null);
  const [team, setTeam]         = useState(null);
  const [stats, setStats]       = useState(null);
  const [loading, setLoading]   = useState(true);
  const [statsLoading, setStatsLoading] = useState(true);
  const [error, setError]       = useState('');

  // Photo upload
  const [uploadDialog, setUploadDialog]   = useState(false);
  const [uploading, setUploading]         = useState(false);
  const [selectedFile, setSelectedFile]   = useState(null);
  const [previewUrl, setPreviewUrl]       = useState(null);

  // Stats edit
  const [statsEditOpen, setStatsEditOpen] = useState(false);
  const [statsForm,     setStatsForm]     = useState({});
  const [savingStats,   setSavingStats]   = useState(false);
  const [statsSuccess,  setStatsSuccess]  = useState('');

  // Remove from team / club history
  const [removeTeamDialog, setRemoveTeamDialog] = useState(false);
  const [removingTeam,     setRemovingTeam]     = useState(false);
  const [removeTeamError,  setRemoveTeamError]  = useState('');
  const [clubHistory,      setClubHistory]      = useState([]);
  const [historyLoading,   setHistoryLoading]   = useState(true);

  // Badges
  const [badges,        setBadges]        = useState([]);
  const [badgesLoading, setBadgesLoading] = useState(true);
  const [badgeDialog,   setBadgeDialog]   = useState(false);
  const [badgeForm,     setBadgeForm]     = useState({ name: '', description: '', type: 'tournament', rarity: 'common', icon: '🏆' });
  const [awardingBadge, setAwardingBadge] = useState(false);
  const [badgeSuccess,  setBadgeSuccess]  = useState('');
  const [badgeError,    setBadgeError]    = useState(''); // error shown INSIDE the dialog

  const API = process.env.REACT_APP_API_URL || 'http://localhost:5000/api';
  const BASE = process.env.REACT_APP_API_URL ? process.env.REACT_APP_API_URL.replace('/api', '') : 'http://localhost:5000';

  useEffect(() => { fetchAll(); fetchBadges(); fetchClubHistory(); }, [id]);

  const fetchAll = async () => {
    setLoading(true);
    try {
      const [playerRes, statsRes] = await Promise.all([
        fetch(`${API}/players/${id}`, { headers: authHeaders() }),
        fetch(`${API}/player-stats/${id}`, { headers: authHeaders() }),
      ]);

      if (!playerRes.ok) throw new Error('Joueur non trouvé');
      const playerData = await playerRes.json();
      const playerInfo = playerData.player || playerData;
      setPlayer(playerInfo);

      // fetch team
      if (playerInfo.teamId) {
        try {
          const teamRes = await fetch(`${API}/teams/${playerInfo.teamId}`, { headers: authHeaders() });
          if (teamRes.ok) { const td = await teamRes.json(); setTeam(td.team || td); }
        } catch (_) {}
      }

      // stats
      if (statsRes.ok) {
        const sd = await statsRes.json();
        setStats(sd.stats || sd);
      } else {
        setStats({});
      }
    } catch (e) {
      setError(e.message || 'Erreur de chargement');
    } finally {
      setLoading(false);
      setStatsLoading(false);
    }
  };

  // ── stats edit ───────────────────────────────────────────────────────────────
  const openStatsEdit = () => {
    // Pre-fill form with current stats (all numeric fields as strings for TextField)
    const posKey = detectPosition(player?.position);
    const fields = statsFieldsByPosition(posKey).flatMap(s => s.fields);
    const form = {};
    fields.forEach(f => { form[f.key] = String(toInt((stats || {})[f.key])); });
    setStatsForm(form);
    setStatsEditOpen(true);
  };

  const handleSaveStats = async () => {
    setSavingStats(true);
    try {
      const payload = {};
      Object.entries(statsForm).forEach(([k, v]) => { payload[k] = parseInt(v, 10) || 0; });
      const res = await fetch(`${API}/player-stats/${id}`, {
        method: 'PUT',
        headers: authHeaders(),
        body: JSON.stringify(payload),
      });
      if (res.ok) {
        const data = await res.json();
        setStats(data.stats || payload);
        setStatsSuccess('Statistiques mises à jour avec succès');
        setStatsEditOpen(false);
      } else {
        const d = await res.json();
        setError(d.message || 'Erreur lors de la sauvegarde');
      }
    } catch { setError('Erreur réseau'); }
    finally { setSavingStats(false); }
  };

  // ── badges ───────────────────────────────────────────────────────────────────
  const fetchBadges = async () => {
    setBadgesLoading(true);
    try {
      const res = await fetch(`${API}/rewards/player/${id}/badges`, {
        headers: authHeaders({ json: false }),
      });
      if (res.ok) {
        const data = await res.json();
        setBadges(data.badges || []);
      }
    } catch (_) {}
    finally { setBadgesLoading(false); }
  };

  const handleAwardBadge = async () => {
    if (!badgeForm.name.trim()) {
      setBadgeError('Le nom du badge est requis');
      return;
    }
    setBadgeError('');
    setAwardingBadge(true);
    try {
      const res = await fetch(`${API}/rewards/award-badge`, {
        method: 'POST',
        headers: authHeaders(),
        body: JSON.stringify({ playerId: parseInt(id, 10), badgeData: badgeForm }),
      });
      if (res.ok) {
        setBadgeDialog(false);
        setBadgeError('');
        setBadgeForm({ name: '', description: '', type: 'tournament', rarity: 'common', icon: '🏆' });
        setBadgeSuccess(`Badge "${badgeForm.name}" attribué avec succès !`);
        fetchBadges();
      } else {
        const d = await res.json();
        setBadgeError(d.message || 'Erreur lors de l\'attribution');
      }
    } catch { setBadgeError('Erreur réseau — vérifiez votre connexion'); }
    finally { setAwardingBadge(false); }
  };

  // ── club history ─────────────────────────────────────────────────────────────
  const fetchClubHistory = async () => {
    setHistoryLoading(true);
    try {
      const res = await fetch(`${API}/players/${id}/club-history`, {
        headers: authHeaders({ json: false }),
      });
      if (res.ok) {
        const data = await res.json();
        setClubHistory(data.history || []);
      }
    } catch (_) {}
    finally { setHistoryLoading(false); }
  };

  const handleRemoveFromTeam = async () => {
    setRemovingTeam(true);
    setRemoveTeamError('');
    try {
      const res = await fetch(`${API}/players/${id}/team`, {
        method: 'DELETE',
        headers: authHeaders(),
      });
      console.log('[removeFromTeam] status:', res.status);
      if (res.ok) {
        setRemoveTeamDialog(false);
        setRemoveTeamError('');
        setTeam(null);
        setPlayer(p => ({ ...p, teamId: null }));
        fetchClubHistory();
      } else {
        let msg = 'Erreur lors du retrait';
        try { const d = await res.json(); msg = d.message || msg; } catch (_) {}
        console.error('[removeFromTeam] error:', res.status, msg);
        setRemoveTeamError(`Erreur ${res.status} : ${msg}`);
      }
    } catch (e) {
      console.error('[removeFromTeam] network error:', e);
      setRemoveTeamError('Erreur réseau — vérifiez votre connexion');
    }
    finally { setRemovingTeam(false); }
  };

  // ── photo upload ─────────────────────────────────────────────────────────────
  const handleFileSelect = (e) => {
    const file = e.target.files[0];
    if (!file) return;
    if (!file.type.startsWith('image/')) { setError('Veuillez sélectionner une image'); return; }
    if (file.size > 5 * 1024 * 1024) { setError('Taille max 5 MB'); return; }
    setSelectedFile(file);
    const reader = new FileReader();
    reader.onload = (ev) => setPreviewUrl(ev.target.result);
    reader.readAsDataURL(file);
    setUploadDialog(true);
  };

  const handlePhotoUpload = async () => {
    if (!selectedFile) return;
    setUploading(true);
    try {
      const formData = new FormData();
      formData.append('photo', selectedFile);
      const res = await fetch(`${BASE}/api/uploads/player/${id}/photo`, {
        method: 'POST',
        headers: authHeaders({ json: false }),
        body: formData,
      });
      if (res.ok) {
        const data = await res.json();
        setPlayer(p => ({ ...p, avatar: data.url }));
        setUploadDialog(false); setSelectedFile(null); setPreviewUrl(null);
        await fetchAll();
      } else {
        const d = await res.json();
        setError(d.message || 'Erreur upload');
      }
    } catch (e) { setError(e.message); }
    finally { setUploading(false); }
  };

  const handleUploadCancel = () => {
    setUploadDialog(false); setSelectedFile(null); setPreviewUrl(null);
    if (fileInputRef.current) fileInputRef.current.value = '';
  };

  // ── helpers ──────────────────────────────────────────────────────────────────
  const getPositionLabel = (p) => {
    switch (p) {
      case 'gardien': return 'Gardien'; case 'defenseur': return 'Défenseur';
      case 'milieu':  return 'Milieu';  case 'attaquant':  return 'Attaquant';
      default: return p || 'Non défini';
    }
  };
  const getPositionColor = (p) => {
    switch (p) {
      case 'gardien': return 'warning'; case 'defenseur': return 'primary';
      case 'milieu':  return 'success'; case 'attaquant':  return 'error';
      default: return 'default';
    }
  };
  const calculateAge = (dob) => {
    if (!dob) return null;
    const today = new Date();
    const b = new Date(dob);
    let age = today.getFullYear() - b.getFullYear();
    if (today.getMonth() < b.getMonth() || (today.getMonth() === b.getMonth() && today.getDate() < b.getDate())) age--;
    return age;
  };

  if (loading) return <Box sx={{ p: 3, textAlign: 'center' }}><CircularProgress /></Box>;
  if (error && !player) return (
    <Box sx={{ p: 3 }}>
      <Alert severity="error" sx={{ mb: 2 }}>{error}</Alert>
      <Button startIcon={<ArrowBackIcon />} onClick={() => navigate('/admin')} variant="contained">Retour</Button>
    </Box>
  );

  const age = calculateAge(player.dateOfBirth);
  const posKey = detectPosition(player.position);
  const meta   = positionMeta[posKey];
  const safeStats = stats || {};
  const kpis   = headerKpis(posKey, safeStats);
  const sections = sectionsForPosition(posKey, safeStats);
  const axes   = radarAxes(posKey, safeStats);

  return (
    <Box sx={{ p: 3 }}>
      {error && <Alert severity="warning" sx={{ mb: 2 }} onClose={() => setError('')}>{error}</Alert>}

      {/* ── Header ─────────────────────────────────────────────────────────────── */}
      <Box sx={{ display: 'flex', alignItems: 'center', mb: 3 }}>
        <Button startIcon={<ArrowBackIcon />} onClick={() => navigate('/admin')} sx={{ mr: 2 }}>
          Retour
        </Button>
        <Box sx={{ mr: 3, position: 'relative' }}>
          <Avatar
            src={player.avatar ? `${BASE}${player.avatar}` : undefined}
            sx={{ width: 80, height: 80, bgcolor: meta.color, fontSize: '2rem', border: `3px solid ${meta.color}40` }}
          >
            {!player.avatar && player.name?.charAt(0).toUpperCase()}
          </Avatar>
          <IconButton
            sx={{ position: 'absolute', bottom: -5, right: -5, bgcolor: meta.color, color: 'white', width: 30, height: 30, '&:hover': { bgcolor: meta.color } }}
            onClick={() => fileInputRef.current?.click()}
          >
            <PhotoCameraIcon sx={{ fontSize: 16 }} />
          </IconButton>
        </Box>
        <Box sx={{ flexGrow: 1 }}>
          <Typography variant="h4" sx={{ fontWeight: 'bold' }}>{player.name}</Typography>
          <Box sx={{ display: 'flex', alignItems: 'center', gap: 1, mt: 1 }}>
            <Chip label={getPositionLabel(player.position)} color={getPositionColor(player.position)} size="small" icon={<SportsIcon />} />
            {player.jerseyNumber && <Chip label={`#${player.jerseyNumber}`} variant="outlined" size="small" />}
            {player.isCaptain && <Chip label="Capitaine" color="warning" size="small" icon={<StarIcon />} />}
          </Box>
        </Box>
        <input ref={fileInputRef} type="file" accept="image/*" style={{ display: 'none' }} onChange={handleFileSelect} />
      </Box>

      {/* ── Position banner + KPI cards ─────────────────────────────────────── */}
      <Paper elevation={0} sx={{
        mb: 3, p: 2.5, borderRadius: 3,
        background: `#1d2320`,
        color: 'white',
      }}>
        <Box sx={{ display: 'flex', alignItems: 'center', gap: 1.5, mb: 2.5 }}>
          <Box sx={{
            display: 'flex', alignItems: 'center', gap: 1,
            bgcolor: `${meta.color}25`, px: 1.5, py: 0.75, borderRadius: 20,
            border: `1px solid ${meta.color}50`,
          }}>
            <Box sx={{ color: meta.color, display: 'flex', '& svg': { fontSize: 16 } }}>{meta.icon}</Box>
            <Typography sx={{ fontSize: 12, fontWeight: 700, color: meta.color }}>{meta.label.toUpperCase()}</Typography>
          </Box>
          <Box sx={{ ml: 'auto', textAlign: 'right' }}>
            <Typography sx={{ fontSize: 28, fontWeight: 800, color: 'white', lineHeight: 1 }}>
              {toInt(safeStats.matchesPlayed)}
            </Typography>
            <Typography sx={{ fontSize: 11, color: 'rgba(255,255,255,0.5)' }}>matchs joués</Typography>
          </Box>
        </Box>
        <Grid container spacing={2}>
          {kpis.map((k, i) => (
            <Grid item xs={6} sm={3} key={i}>
              <KpiCard {...k} />
            </Grid>
          ))}
        </Grid>
      </Paper>

      <Grid container spacing={3}>
        {/* ── Left column: info ─────────────────────────────────────────────── */}
        <Grid item xs={12} md={5}>
          <Card elevation={0} sx={{ border: '1.5px solid #dcd8cc', borderRadius: 3, mb: 2 }}>
            <CardContent>
              <Typography variant="h6" gutterBottom sx={{ fontWeight: 700 }}>Informations personnelles</Typography>
              <Divider sx={{ mb: 2 }} />
              {player.avatar && (
                <Box sx={{ textAlign: 'center', mb: 2 }}>
                  <img src={`${BASE}${player.avatar}`} alt={player.name}
                    style={{ maxWidth: '100%', maxHeight: 180, borderRadius: 8, border: '2px solid #dcd8cc', objectFit: 'contain' }} />
                </Box>
              )}
              <List dense>
                <ListItem><ListItemIcon><PersonIcon /></ListItemIcon>
                  <ListItemText primary="Nom complet" secondary={player.name} />
                </ListItem>
                {player.dateOfBirth && <ListItem><ListItemIcon><CakeIcon /></ListItemIcon>
                  <ListItemText primary="Date de naissance" secondary={`${new Date(player.dateOfBirth).toLocaleDateString()} (${age} ans)`} />
                </ListItem>}
                {player.nationality && <ListItem><ListItemIcon><FlagIcon /></ListItemIcon>
                  <ListItemText primary="Nationalité" secondary={player.nationality} />
                </ListItem>}
                {player.height && <ListItem><ListItemIcon><HeightIcon /></ListItemIcon>
                  <ListItemText primary="Taille" secondary={`${player.height} cm`} />
                </ListItem>}
                {player.weight && <ListItem><ListItemIcon><WeightIcon /></ListItemIcon>
                  <ListItemText primary="Poids" secondary={`${player.weight} kg`} />
                </ListItem>}
                {player.preferredFoot && <ListItem><ListItemIcon><SportsIcon /></ListItemIcon>
                  <ListItemText primary="Pied préféré" secondary={player.preferredFoot === 'gauche' ? 'Gauche' : player.preferredFoot === 'droit' ? 'Droit' : 'Ambidextre'} />
                </ListItem>}
                {player.email && <ListItem><ListItemIcon><EmailIcon /></ListItemIcon>
                  <ListItemText primary="Email" secondary={player.email} />
                </ListItem>}
                {player.phone && <ListItem><ListItemIcon><PhoneIcon /></ListItemIcon>
                  <ListItemText primary="Téléphone" secondary={player.phone} />
                </ListItem>}
              </List>
            </CardContent>
          </Card>

          <Card elevation={0} sx={{ border: '1.5px solid #dcd8cc', borderRadius: 3, mb: 2 }}>
            <CardContent>
              <Typography variant="h6" gutterBottom sx={{ fontWeight: 700 }}>Informations sportives</Typography>
              <Divider sx={{ mb: 2 }} />
              <List dense>
                <ListItem><ListItemIcon><SportsIcon /></ListItemIcon>
                  <ListItemText primary="Position" secondary={
                    <Chip label={getPositionLabel(player.position)} color={getPositionColor(player.position)} size="small" sx={{ mt: 0.5 }} />
                  } />
                </ListItem>
                {player.jerseyNumber && <ListItem>
                  <ListItemText primary="Numéro de maillot" secondary={<Chip label={`#${player.jerseyNumber}`} variant="outlined" size="small" sx={{ mt: 0.5 }} />} />
                </ListItem>}
                <ListItem><ListItemIcon><StarIcon /></ListItemIcon>
                  <ListItemText primary="Capitaine" secondary={player.isCaptain
                    ? <Chip label="Capitaine" color="warning" size="small" icon={<StarIcon />} sx={{ mt: 0.5 }} />
                    : 'Non'} />
                </ListItem>
                <ListItem>
                  <ListItemIcon><GroupIcon /></ListItemIcon>
                  <ListItemText primary="Équipe" secondary={team?.name || 'Sans équipe'} />
                  {team && (
                    <Button
                      size="small"
                      variant="outlined"
                      color="error"
                      onClick={() => setRemoveTeamDialog(true)}
                      sx={{ ml: 1, minWidth: 'auto', fontSize: 11, whiteSpace: 'nowrap' }}
                    >
                      Retirer
                    </Button>
                  )}
                </ListItem>
                {player.joinDate && <ListItem>
                  <ListItemText primary="Date d'arrivée" secondary={new Date(player.joinDate).toLocaleDateString()} />
                </ListItem>}
                <ListItem>
                  <ListItemText primary="Statut" secondary={
                    <Chip label={player.isActive ? 'Actif' : 'Inactif'} color={player.isActive ? 'success' : 'default'} size="small" sx={{ mt: 0.5 }} />
                  } />
                </ListItem>
              </List>
            </CardContent>
          </Card>

          {team && (
            <Card elevation={0} sx={{ border: '1.5px solid #dcd8cc', borderRadius: 3 }}>
              <CardContent>
                <Typography variant="h6" gutterBottom sx={{ fontWeight: 700 }}>Équipe : {team.name}</Typography>
                <Divider sx={{ mb: 2 }} />
                {team.description && <Typography variant="body2" color="text.secondary" sx={{ mb: 2 }}>{team.description}</Typography>}
                <Button variant="outlined" size="small" onClick={() => navigate(`/admin/teams/${team.id}`)}>
                  Voir l'équipe
                </Button>
              </CardContent>
            </Card>
          )}
        </Grid>

        {/* ── Right column: stats ───────────────────────────────────────────── */}
        <Grid item xs={12} md={7}>
          {statsSuccess && (
            <Alert severity="success" sx={{ mb: 2 }} onClose={() => setStatsSuccess('')}>{statsSuccess}</Alert>
          )}
          <Box sx={{ display: 'flex', justifyContent: 'flex-end', mb: 1 }}>
            <Button variant="outlined" size="small" startIcon={<EditIcon />}
              onClick={openStatsEdit} disabled={statsLoading}>
              Modifier les statistiques
            </Button>
          </Box>
          {statsLoading ? (
            <Box sx={{ textAlign: 'center', py: 6 }}>
              <CircularProgress />
              <Typography sx={{ mt: 2, color: 'text.secondary' }}>Chargement des statistiques…</Typography>
            </Box>
          ) : (
            <>
              {/* Radar / performance profile */}
              <Card elevation={0} sx={{ border: `1.5px solid ${meta.color}20`, borderRadius: 3, mb: 2 }}>
                <CardContent>
                  <Box sx={{ display: 'flex', alignItems: 'center', gap: 1, mb: 2 }}>
                    <Box sx={{ bgcolor: `${meta.color}12`, px: 1.5, py: 0.5, borderRadius: 20, display: 'flex', alignItems: 'center', gap: 1 }}>
                      <ChartIcon sx={{ fontSize: 16, color: meta.color }} />
                      <Typography sx={{ fontSize: 12, fontWeight: 700, color: meta.color, textTransform: 'uppercase' }}>
                        Profil {meta.label}
                      </Typography>
                    </Box>
                  </Box>
                  {axes.map((ax) => (
                    <RadarBar key={ax.label} label={ax.label} value={ax.value} />
                  ))}
                </CardContent>
              </Card>

              {/* Position-specific stat sections */}
              {sections.map((section) => (
                <SectionCard key={section.title} title={section.title} color={section.color} icon={section.icon}>
                  {section.rows.map((row) => (
                    <StatRow
                      key={row.key}
                      label={row.label}
                      value={toInt(safeStats[row.key])}
                      icon={row.icon}
                      color={section.color}
                    />
                  ))}
                </SectionCard>
              ))}

              {/* Playing time */}
              <Card elevation={0} sx={{ border: `1.5px solid ${meta.color}20`, borderRadius: 3, background: `${meta.color}08` }}>
                <CardContent>
                  <Box sx={{ display: 'flex', alignItems: 'center', gap: 1, mb: 1.5 }}>
                    <TimerIcon sx={{ color: meta.color, fontSize: 18 }} />
                    <Typography sx={{ fontSize: 12, fontWeight: 700, color: meta.color, textTransform: 'uppercase' }}>
                      Temps de jeu
                    </Typography>
                  </Box>
                  <Grid container spacing={2}>
                    <Grid item xs={6}>
                      <StatRow label="Minutes jouées" value={toInt(safeStats.minutesPlayed)} icon={<TimerIcon />} color={meta.color} />
                    </Grid>
                    <Grid item xs={6}>
                      <StatRow label="Matchs joués" value={toInt(safeStats.matchesPlayed)} icon={<SportsIcon />} color={meta.color} />
                    </Grid>
                  </Grid>
                </CardContent>
              </Card>
            </>
          )}
        </Grid>
      </Grid>

      {/* ── Badges Section ──────────────────────────────────────────────────── */}
      {badgeSuccess && (
        <Alert severity="success" sx={{ mt: 3 }} onClose={() => setBadgeSuccess('')}>{badgeSuccess}</Alert>
      )}
      <Box sx={{ mt: 3 }}>
        <Box sx={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', mb: 2 }}>
          <Box sx={{ display: 'flex', alignItems: 'center', gap: 1 }}>
            <TrophyIcon sx={{ color: '#F59E0B' }} />
            <Typography variant="h6" sx={{ fontWeight: 700 }}>Badges du joueur</Typography>
            {badges.length > 0 && (
              <Chip label={badges.length} size="small"
                sx={{ bgcolor: '#FEF3C7', color: '#D97706', fontWeight: 700 }} />
            )}
          </Box>
          <Button variant="contained" size="small" startIcon={<AddIcon />}
            onClick={() => setBadgeDialog(true)}
            sx={{ bgcolor: '#F59E0B', '&:hover': { bgcolor: '#D97706' }, fontWeight: 600 }}>
            Attribuer un badge
          </Button>
        </Box>

        {badgesLoading ? (
          <Box sx={{ textAlign: 'center', py: 3 }}><CircularProgress size={28} /></Box>
        ) : badges.length === 0 ? (
          <Paper elevation={0} sx={{
            p: 4, textAlign: 'center', borderRadius: 3,
            border: '1.5px dashed #dcd8cc',
          }}>
            <TrophyIcon sx={{ fontSize: 44, color: '#c8c3b5', mb: 1 }} />
            <Typography color="text.secondary" fontWeight={500}>Aucun badge attribué</Typography>
            <Typography variant="caption" color="text.disabled">
              Attribuez un badge de tournoi ou d'accomplissement à ce joueur
            </Typography>
          </Paper>
        ) : (
          <Grid container spacing={2}>
            {badges.map(badge => (
              <Grid item xs={12} sm={6} md={4} key={badge.id}>
                <BadgeDisplayCard badge={badge} />
              </Grid>
            ))}
          </Grid>
        )}
      </Box>

      {/* ── Club History ─────────────────────────────────────────────────────── */}
      <Box sx={{ mt: 4 }}>
        <Box sx={{ display: 'flex', alignItems: 'center', gap: 1, mb: 2.5 }}>
          <Box sx={{
            width: 4, height: 22, borderRadius: 2,
            background: '#1d2320',
          }} />
          <Typography variant="h6" sx={{ fontWeight: 800, letterSpacing: -0.3 }}>
            Historique des clubs
          </Typography>
        </Box>

        {historyLoading ? (
          <Box sx={{ textAlign: 'center', py: 3 }}><CircularProgress size={28} /></Box>
        ) : clubHistory.length === 0 ? (
          <Paper elevation={0} sx={{
            p: 3, textAlign: 'center', borderRadius: 3,
            border: '1.5px dashed #dcd8cc',
          }}>
            <Typography variant="body2" color="text.secondary">
              Aucun historique de club enregistré
            </Typography>
          </Paper>
        ) : (
          <Box sx={{ position: 'relative', pl: 2 }}>
            {/* vertical timeline line */}
            <Box sx={{
              position: 'absolute', left: 15, top: 0, bottom: 0, width: 2,
              bgcolor: '#dcd8cc', borderRadius: 1,
            }} />
            {clubHistory.map((entry, i) => {
              const isCurrent = !entry.endDate;
              const start = entry.startDate ? new Date(entry.startDate) : null;
              const end   = entry.endDate   ? new Date(entry.endDate)   : null;
              const durationMs = (end || new Date()) - (start || new Date());
              const months = Math.max(0, Math.round(durationMs / (1000 * 60 * 60 * 24 * 30.44)));
              const years  = Math.floor(months / 12);
              const remMonths = months % 12;
              const durationLabel = years > 0
                ? `${years} an${years > 1 ? 's' : ''}${remMonths > 0 ? ` ${remMonths} mois` : ''}`
                : months > 0 ? `${months} mois` : 'Moins d\'un mois';
              const fmtDate = (d) => d ? d.toLocaleDateString('fr-FR', { month: 'short', year: 'numeric' }) : '?';

              const keyStats = [
                { label: 'Matchs',   value: entry.matches || 0,       icon: null },
                { label: 'Buts',     value: entry.goals || 0,         icon: null },
                { label: 'Passes D.',value: entry.assists || 0,       icon: null },
                { label: 'Jaunes',   value: entry.yellowCards || 0,   icon: null },
                { label: 'Rouges',   value: entry.redCards || 0,      icon: null },
              ];
              if ((entry.cleanSheets || 0) > 0)
                keyStats.splice(3, 0, { label: 'Clean sh.', value: entry.cleanSheets, icon: null });
              if ((entry.saves || 0) > 0)
                keyStats.splice(3, 0, { label: 'Arrêts', value: entry.saves, icon: null });

              return (
                <Box key={entry.id} sx={{ display: 'flex', gap: 2, mb: 2.5, position: 'relative' }}>
                  {/* dot */}
                  <Box sx={{
                    width: 12, height: 12, borderRadius: '50%', flexShrink: 0,
                    bgcolor: isCurrent ? '#2f7d4a' : '#9d978a',
                    border: `2px solid white`,
                    boxShadow: isCurrent ? '0 0 0 3px #10B98133' : 'none',
                    mt: 1.5, ml: -0.5, position: 'relative', zIndex: 1,
                  }} />
                  {/* card */}
                  <Paper elevation={0} sx={{
                    flex: 1, p: 2, borderRadius: 3,
                    border: isCurrent ? '1.5px solid #10B98150' : '1.5px solid #dcd8cc',
                    background: isCurrent
                      ? '#e6efe7'
                      : 'background.paper',
                  }}>
                    <Box sx={{ display: 'flex', alignItems: 'center', gap: 1.5, mb: 1.5 }}>
                      {/* team initial avatar */}
                      <Avatar sx={{
                        width: 44, height: 44,
                        bgcolor: isCurrent ? '#1d2320' : '#6f6a5f',
                        fontSize: 18, fontWeight: 800,
                        border: `2px solid ${isCurrent ? '#2f7d4a' : '#c8c3b5'}`,
                      }}>
                        {entry.teamName.charAt(0).toUpperCase()}
                      </Avatar>
                      <Box sx={{ flex: 1 }}>
                        <Box sx={{ display: 'flex', alignItems: 'center', gap: 1 }}>
                          <Typography sx={{ fontWeight: 800, fontSize: 15 }}>{entry.teamName}</Typography>
                          {isCurrent && (
                            <Chip label="Actuel" size="small"
                              sx={{ height: 18, fontSize: 10, bgcolor: '#2f7d4a', color: 'white', fontWeight: 700 }} />
                          )}
                        </Box>
                        <Typography variant="caption" color="text.secondary">
                          {fmtDate(start)} — {isCurrent ? 'Présent' : fmtDate(end)}
                          {' · '}<strong>{durationLabel}</strong>
                        </Typography>
                      </Box>
                    </Box>

                    {/* stat pills */}
                    <Box sx={{ display: 'flex', flexWrap: 'wrap', gap: 0.75 }}>
                      {keyStats.map(s => (
                        <Box key={s.label} sx={{
                          display: 'flex', alignItems: 'center', gap: 0.5,
                          bgcolor: '#f6f4ee', border: '1px solid #dcd8cc',
                          borderRadius: 2, px: 1.25, py: 0.4,
                        }}>
                          <Typography sx={{ fontSize: 13 }}>{s.icon}</Typography>
                          <Typography sx={{ fontSize: 12, fontWeight: 700, color: '#1d2320' }}>{s.value}</Typography>
                          <Typography sx={{ fontSize: 10, color: '#6f6a5f' }}>{s.label}</Typography>
                        </Box>
                      ))}
                    </Box>
                  </Paper>
                </Box>
              );
            })}
          </Box>
        )}
      </Box>

      {/* ── Remove From Team Dialog ──────────────────────────────────────────── */}
      <Dialog open={removeTeamDialog} onClose={() => { setRemoveTeamDialog(false); setRemoveTeamError(''); }} maxWidth="xs" fullWidth
        PaperProps={{ sx: { borderRadius: 3 } }}>
        <DialogTitle>
          <Box sx={{ display: 'flex', alignItems: 'center', gap: 1 }}>
            <Box sx={{ bgcolor: '#FEF2F2', p: 0.8, borderRadius: 2, display: 'flex' }}>
              <GroupIcon sx={{ color: '#EF4444' }} />
            </Box>
            <Typography variant="h6" fontWeight={700}>Retirer de l'équipe</Typography>
          </Box>
        </DialogTitle>
        <Divider />
        <DialogContent sx={{ pt: 2 }}>
          <Typography>
            Retirer <strong>{player?.name}</strong> de <strong>{team?.name}</strong> ?
          </Typography>
          <Alert severity="info" sx={{ mt: 2, fontSize: 12 }}>
            Les statistiques actuelles seront enregistrées dans l'historique des clubs du joueur.
          </Alert>
          {removeTeamError && (
            <Alert severity="error" sx={{ mt: 1.5, fontSize: 12 }} onClose={() => setRemoveTeamError('')}>
              {removeTeamError}
            </Alert>
          )}
        </DialogContent>
        <Divider />
        <DialogActions sx={{ px: 3, py: 2 }}>
          <Button variant="outlined" color="inherit" onClick={() => { setRemoveTeamDialog(false); setRemoveTeamError(''); }}>
            Annuler
          </Button>
          <Button variant="contained" color="error" onClick={handleRemoveFromTeam}
            disabled={removingTeam}
            startIcon={removingTeam ? <CircularProgress size={16} /> : <GroupIcon />}>
            {removingTeam ? 'Retrait…' : 'Confirmer le retrait'}
          </Button>
        </DialogActions>
      </Dialog>

      {/* ── Award Badge Dialog ───────────────────────────────────────────────── */}
      <Dialog open={badgeDialog} onClose={() => setBadgeDialog(false)} maxWidth="sm" fullWidth
        PaperProps={{ sx: { borderRadius: 3 } }}>
        <DialogTitle>
          <Box sx={{ display: 'flex', alignItems: 'center', gap: 1 }}>
            <Box sx={{ bgcolor: '#FEF3C7', p: 0.8, borderRadius: 2, display: 'flex' }}>
              <TrophyIcon sx={{ color: '#F59E0B' }} />
            </Box>
            <Box>
              <Typography variant="h6" fontWeight={700}>Attribuer un badge</Typography>
              <Typography variant="caption" color="text.secondary">{player?.name}</Typography>
            </Box>
          </Box>
        </DialogTitle>
        <Divider />
        <DialogContent sx={{ pt: 2.5 }}>
          {/* Icon picker */}
          <Typography variant="caption" fontWeight={700} color="text.secondary" display="block" sx={{ mb: 1 }}>
            ICÔNE
          </Typography>
          <Box sx={{ display: 'flex', gap: 1, flexWrap: 'wrap', mb: 2.5 }}>
            {BADGE_ICONS.map(ic => (
              <Box key={ic} onClick={() => setBadgeForm(f => ({ ...f, icon: ic }))}
                sx={{
                  width: 40, height: 40, borderRadius: 1.5, display: 'flex',
                  alignItems: 'center', justifyContent: 'center', cursor: 'pointer',
                  fontSize: 20,
                  border: badgeForm.icon === ic ? '2px solid #F59E0B' : '1.5px solid #dcd8cc',
                  bgcolor: badgeForm.icon === ic ? '#FEF3C7' : 'background.paper',
                  transition: 'all 0.15s',
                }}>
                {ic}
              </Box>
            ))}
          </Box>

          {/* Name */}
          <TextField fullWidth label="Nom du badge *" size="small" sx={{ mb: 2 }}
            value={badgeForm.name}
            onChange={e => setBadgeForm(f => ({ ...f, name: e.target.value }))}
            placeholder="Ex: Champion du tournoi printemps 2025"
          />

          {/* Description */}
          <TextField fullWidth label="Description (optionnelle)" size="small" multiline rows={2} sx={{ mb: 2.5 }}
            value={badgeForm.description}
            onChange={e => setBadgeForm(f => ({ ...f, description: e.target.value }))}
            placeholder="Ex: A remporté le tournoi de printemps 2025"
          />

          {/* Type */}
          <Typography variant="caption" fontWeight={700} color="text.secondary" display="block" sx={{ mb: 1 }}>
            CATÉGORIE
          </Typography>
          <Box sx={{ display: 'flex', gap: 1, flexWrap: 'wrap', mb: 2.5 }}>
            {BADGE_TYPES.map(t => (
              <Chip key={t.value} label={`${t.emoji} ${t.label}`} clickable
                onClick={() => setBadgeForm(f => ({ ...f, type: t.value }))}
                variant={badgeForm.type === t.value ? 'filled' : 'outlined'}
                sx={{
                  fontWeight: 600,
                  bgcolor: badgeForm.type === t.value ? '#F59E0B' : 'transparent',
                  color: badgeForm.type === t.value ? 'white' : 'text.secondary',
                  borderColor: badgeForm.type === t.value ? '#F59E0B' : 'divider',
                }}
              />
            ))}
          </Box>

          {/* Rarity */}
          <Typography variant="caption" fontWeight={700} color="text.secondary" display="block" sx={{ mb: 1 }}>
            RARETÉ
          </Typography>
          <Box sx={{ display: 'flex', gap: 1, flexWrap: 'wrap' }}>
            {BADGE_RARITIES.map(r => (
              <Chip key={r.value} label={r.label} clickable
                onClick={() => setBadgeForm(f => ({ ...f, rarity: r.value }))}
                variant={badgeForm.rarity === r.value ? 'filled' : 'outlined'}
                sx={{
                  fontWeight: 600,
                  bgcolor: badgeForm.rarity === r.value ? r.color : 'transparent',
                  color: badgeForm.rarity === r.value ? 'white' : r.color,
                  borderColor: r.color,
                }}
              />
            ))}
          </Box>
        </DialogContent>
        <Divider />
        {badgeError && (
          <Alert severity="error" sx={{ mx: 3, mt: 2, mb: 0 }} onClose={() => setBadgeError('')}>
            {badgeError}
          </Alert>
        )}
        <DialogActions sx={{ px: 3, py: 2 }}>
          <Button variant="outlined" color="inherit" onClick={() => { setBadgeDialog(false); setBadgeError(''); }}>
            Annuler
          </Button>
          <Button variant="contained" onClick={handleAwardBadge} disabled={awardingBadge}
            startIcon={awardingBadge ? <CircularProgress size={16} /> : <TrophyIcon />}
            sx={{ bgcolor: '#F59E0B', '&:hover': { bgcolor: '#D97706' }, fontWeight: 700 }}>
            {awardingBadge ? 'Attribution…' : 'Attribuer le badge'}
          </Button>
        </DialogActions>
      </Dialog>

      {/* ── Stats Edit Dialog ────────────────────────────────────────────────── */}
      <Dialog open={statsEditOpen} onClose={() => setStatsEditOpen(false)} maxWidth="sm" fullWidth
        PaperProps={{ sx: { borderRadius: 3 } }}>
        <DialogTitle>
          <Box sx={{ display: 'flex', alignItems: 'center', gap: 1 }}>
            <Box sx={{ bgcolor: `${meta?.color}18`, p: 0.8, borderRadius: 2, display: 'flex' }}>
              {meta?.icon}
            </Box>
            <Box>
              <Typography variant="h6" fontWeight={700}>Modifier les statistiques</Typography>
              <Typography variant="caption" color="text.secondary">
                {player?.name} · {meta?.label}
              </Typography>
            </Box>
          </Box>
          <IconButton sx={{ position: 'absolute', right: 10, top: 12 }}
            onClick={() => setStatsEditOpen(false)}>
            <ArrowBackIcon />
          </IconButton>
        </DialogTitle>
        <Divider />
        <DialogContent sx={{ maxHeight: '65vh', overflowY: 'auto' }}>
          {player && statsFieldsByPosition(detectPosition(player.position)).map((section) => (
            <Box key={section.section} sx={{ mb: 3 }}>
              {/* Section header */}
              <Box sx={{
                display: 'flex', alignItems: 'center', gap: 1,
                bgcolor: `${section.color}10`, border: `1px solid ${section.color}25`,
                borderRadius: 2, px: 1.5, py: 0.75, mb: 1.5,
              }}>
                <Box sx={{ width: 10, height: 10, borderRadius: '50%', bgcolor: section.color, flexShrink: 0 }} />
                <Typography variant="subtitle2" fontWeight={700} sx={{ color: section.color }}>
                  {section.section}
                </Typography>
              </Box>
              {/* Fields */}
              <Grid container spacing={1.5}>
                {section.fields.map((field) => (
                  <Grid item xs={6} key={field.key}>
                    <TextField
                      fullWidth
                      size="small"
                      label={field.label}
                      type="number"
                      inputProps={{ min: 0 }}
                      value={statsForm[field.key] ?? '0'}
                      onChange={e => setStatsForm(f => ({ ...f, [field.key]: e.target.value }))}
                      InputProps={{
                        startAdornment: (
                          <InputAdornment position="start">
                            <Box sx={{ width: 8, height: 8, borderRadius: '50%', bgcolor: section.color }} />
                          </InputAdornment>
                        ),
                      }}
                    />
                  </Grid>
                ))}
              </Grid>
            </Box>
          ))}
        </DialogContent>
        <Divider />
        <DialogActions sx={{ px: 3, py: 2 }}>
          <Button variant="outlined" color="inherit" onClick={() => setStatsEditOpen(false)}>Annuler</Button>
          <Button variant="contained" onClick={handleSaveStats} disabled={savingStats}
            startIcon={savingStats ? <CircularProgress size={16} /> : <SaveIcon />}
            sx={{ bgcolor: meta?.color, '&:hover': { bgcolor: meta?.color, filter: 'brightness(0.9)' } }}>
            {savingStats ? 'Enregistrement…' : 'Enregistrer'}
          </Button>
        </DialogActions>
      </Dialog>

      {/* ── Photo Upload Dialog ──────────────────────────────────────────────── */}
      <Dialog open={uploadDialog} onClose={handleUploadCancel} maxWidth="sm" fullWidth>
        <DialogTitle>Télécharger une photo pour {player?.name}</DialogTitle>
        <DialogContent>
          {previewUrl && (
            <Box sx={{ textAlign: 'center', mb: 2 }}>
              <img src={previewUrl} alt="Aperçu"
                style={{ maxWidth: '100%', maxHeight: 300, borderRadius: 8, border: '2px solid #dcd8cc', objectFit: 'contain' }} />
              <Typography variant="caption" display="block" sx={{ mt: 1, color: 'text.secondary' }}>Aperçu</Typography>
            </Box>
          )}
          {selectedFile && (
            <Box sx={{ mb: 2 }}>
              <Typography variant="body2" color="text.secondary">{selectedFile.name}</Typography>
              <Typography variant="body2" color="text.secondary">{(selectedFile.size / 1024 / 1024).toFixed(2)} MB</Typography>
            </Box>
          )}
          <Typography variant="body2" color="text.secondary">Formats acceptés : JPEG, PNG, GIF, WebP (max 5 MB)</Typography>
        </DialogContent>
        <DialogActions>
          <Button onClick={handleUploadCancel} disabled={uploading}>Annuler</Button>
          <Button onClick={handlePhotoUpload} variant="contained" disabled={!selectedFile || uploading}
            startIcon={uploading ? <CircularProgress size={20} /> : <CloudUploadIcon />}>
            {uploading ? 'Envoi…' : 'Télécharger'}
          </Button>
        </DialogActions>
      </Dialog>
    </Box>
  );
};

export default PlayerDetails;

