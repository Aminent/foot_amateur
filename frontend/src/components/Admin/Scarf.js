import React from 'react';
import { Box } from '@mui/material';

// Couleurs d'un club (champ Team.colors : tableau JSON ou chaîne JSON)
export const clubColors = (team) => {
  let c = team?.colors;
  if (typeof c === 'string') {
    try { c = JSON.parse(c); } catch { c = [c]; }
  }
  const list = Array.isArray(c) ? c.filter(Boolean) : [];
  return [list[0] || '#9d978a', list[1] || list[0] || '#dcd8cc'];
};

// Bande « écharpe » : les deux couleurs du club tricotées en rayures
const Scarf = ({ team, size = 'md', sx }) => {
  const [a, b] = clubColors(team);
  const w = size === 'sm' ? 18 : size === 'lg' ? 34 : 24;
  const h = size === 'sm' ? 10 : size === 'lg' ? 18 : 13;
  return (
    <Box
      component="span"
      aria-hidden="true"
      sx={{
        display: 'inline-block', flexShrink: 0, width: w, height: h, borderRadius: '2px',
        background: `repeating-linear-gradient(90deg, ${a} 0 ${Math.round(w / 4)}px, ${b} ${Math.round(w / 4)}px ${Math.round(w / 4) + Math.round(w / 8)}px)`,
        boxShadow: 'inset 0 0 0 1px rgba(29,35,32,0.14)',
        verticalAlign: 'middle',
        ...sx,
      }}
    />
  );
};

export default Scarf;
