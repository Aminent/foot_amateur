const { Tournament, Team, Match } = require('../models');

// ── Utilitaire : plus petite puissance de 2 >= n ─────────────────────────────
const nextPow2 = (n) => Math.pow(2, Math.ceil(Math.log2(Math.max(n, 2))));

// Generate knockout bracket matches if not already generated
const generateBracket = async (req, res) => {
  try {
    const { id } = req.params;
    const tournament = await Tournament.findByPk(id, { include: [{ model: Team, as: 'teams' }] });
    if (!tournament) return res.status(404).json({ message: 'Tournament not found' });
    if (tournament.format !== 'knockout') return res.status(400).json({ message: 'Bracket only for knockout format' });

    // ── FIX #7 : interdire la régénération si le tournoi est déjà actif ───────
    if (tournament.status === 'active') {
      return res.status(400).json({
        message: 'Impossible de régénérer le bracket : le tournoi est déjà en cours. Terminez ou annulez le tournoi avant de régénérer.',
      });
    }

    const teams = tournament.teams || [];
    if (teams.length < 2) return res.status(400).json({ message: 'Not enough teams' });

    // ── FIX #5 : arrondir à la prochaine puissance de 2 ──────────────────────
    const rawMax   = tournament.maxTeams || teams.length;
    const maxTeams = nextPow2(Math.max(rawMax, teams.length));
    const totalRounds = Math.log2(maxTeams); // maintenant toujours un entier

    // Clear existing matches for tournament
    await Match.destroy({ where: { tournamentId: tournament.id } });

    // Seed teams into slots (byes = null pour les slots sans équipe)
    const slots = Array.from({ length: maxTeams }, (_, i) => teams[i] ? teams[i].id : null);

    const createdMatches = [];

    // Pre-create all matches per round
    for (let round = 1; round <= totalRounds; round++) {
      const matchesInRound = maxTeams / Math.pow(2, round);
      for (let idx = 0; idx < matchesInRound; idx++) {
        const isFirstRound = round === 1;
        const homeTeamId = isFirstRound ? slots[idx * 2] : null;
        const awayTeamId = isFirstRound ? slots[idx * 2 + 1] : null;
        const match = await Match.create({
          tournamentId: tournament.id,
          roundNumber: round,
          matchIndex: idx,
          homeTeamId,
          awayTeamId,
          date: tournament.startDate || new Date(),
          status: 'scheduled'
        });
        createdMatches.push(match);
      }
    }

    // Link advancement: for each match in round r, determine next match in round r+1
    for (const match of createdMatches) {
      if (match.roundNumber >= totalRounds) continue; // final has no advance
      const nextRoundIndex = Math.floor(match.matchIndex / 2);
      const next = createdMatches.find(m => m.roundNumber === match.roundNumber + 1 && m.matchIndex === nextRoundIndex);
      if (next) {
        await match.update({ advancesToMatchId: next.id });
      }
    }

    const matches = await Match.findAll({ where: { tournamentId: tournament.id }, order: [['roundNumber', 'ASC'], ['matchIndex', 'ASC']] });
    
    // Emit live update
    if (global.io) {
      global.io.to(`tournament-${tournament.id}`).emit('bracket-updated', {
        type: 'bracket-generated',
        tournamentId: tournament.id
      });
    }
    
    res.json({ message: 'Bracket generated', matches });
  } catch (error) {
    console.error('generateBracket error:', error);
    res.status(500).json({ message: 'Error generating bracket' });
  }
};

// Get bracket grouped by rounds
const getBracket = async (req, res) => {
  try {
    const { id } = req.params;
    const tournament = await Tournament.findByPk(id);
    if (!tournament) return res.status(404).json({ message: 'Tournament not found' });

  const matches = await Match.findAll({
      where: { tournamentId: id },
      include: [
        { association: Match.associations.homeTeam, attributes: ['id', 'name'] },
        { association: Match.associations.awayTeam, attributes: ['id', 'name'] }
      ],
      order: [['roundNumber', 'ASC'], ['matchIndex', 'ASC']]
    });

    const rounds = {};
    for (const m of matches) {
      if (!rounds[m.roundNumber]) rounds[m.roundNumber] = [];
      rounds[m.roundNumber].push(m);
    }

    res.json({ rounds, matches });
  } catch (error) {
    console.error('getBracket error:', error);
    res.status(500).json({ message: 'Error fetching bracket' });
  }
};

module.exports = { generateBracket, getBracket };


