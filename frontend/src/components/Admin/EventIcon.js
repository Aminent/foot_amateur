import React from 'react';
import { Box } from '@mui/material';
import {
  SportsSoccer as GoalIcon,
  SwapHoriz as SubIcon,
  LocalHospital as InjuryIcon,
  GpsFixed as PenaltyIcon,
  AssistantDirection as AssistIcon,
} from '@mui/icons-material';

// Icône d'un fait de match : pictogrammes MUI, cartons dessinés comme de vrais cartons
const Card = ({ color }) => (
  <Box component="span" aria-hidden="true" sx={{ display: 'inline-block', width: 11, height: 15, borderRadius: '2px', bgcolor: color, boxShadow: 'inset 0 0 0 1px rgba(29,35,32,0.18)', verticalAlign: 'middle' }} />
);

const EventIcon = ({ type, size = 17 }) => {
  const sx = { fontSize: size, verticalAlign: 'middle' };
  switch (type) {
    case 'goal':         return <GoalIcon sx={{ ...sx, color: '#1d2320' }} />;
    case 'penalty_goal': return <PenaltyIcon sx={{ ...sx, color: '#1d2320' }} />;
    case 'own_goal':     return <GoalIcon sx={{ ...sx, color: '#b91c1c' }} />;
    case 'assist':       return <AssistIcon sx={{ ...sx, color: '#57534a' }} />;
    case 'yellow_card':  return <Card color="#f5c518" />;
    case 'red_card':     return <Card color="#d32f2f" />;
    case 'substitution': return <SubIcon sx={{ ...sx, color: '#57534a' }} />;
    case 'injury':       return <InjuryIcon sx={{ ...sx, color: '#b91c1c' }} />;
    default:             return <Box component="span" sx={{ display: 'inline-block', width: size, height: size }} />;
  }
};

export default EventIcon;
