const { Op } = require('sequelize');
const { Team, Player, Tournament, User, Match } = require('../models');
const { validationResult } = require('express-validator');

// Returns an error message if the team cannot move from its tournament to `targetId` (null = leave).
const tournamentMoveError = async (team, targetId) => {
  if (String(targetId ?? '') === String(team.tournamentId ?? '')) return null;
  if (team.tournamentId) {
    const current = await Tournament.findByPk(team.tournamentId);
    if (current?.status === 'active') {
      return `L'équipe joue le tournoi « ${current.name} » en cours : elle ne peut pas le quitter avant la fin`;
    }
  }
  if (targetId) {
    const target = await Tournament.findByPk(targetId);
    if (!target) return 'Tournoi introuvable';
    if (target.status !== 'draft') return `Les inscriptions au tournoi « ${target.name} » sont closes`;
    const count = await Team.count({ where: { tournamentId: target.id } });
    if (target.maxTeams && count >= target.maxTeams) return `Le tournoi « ${target.name} » est complet (${target.maxTeams} équipes)`;
  }
  return null;
};

// GET /teams? tournamentId=
const getAllTeams = async (req, res) => {
  try {
    const { tournamentId } = req.query;
    const where = {};
    if (tournamentId) {
      where.tournamentId = tournamentId;
    }
    const teams = await Team.findAll({
      where,
      order: [['name', 'ASC']],
      include: [
        {
          model: Player,
          as: 'players',
          attributes: ['id', 'name', 'position', 'jerseyNumber', 'isCaptain', 'isActive'],
          required: false,
        },
        {
          model: User,
          as: 'coach',
          attributes: ['id', 'name', 'email'],
          required: false,
        },
      ],
    });
    res.json({ teams });
  } catch (error) {
    console.error('Error fetching teams:', error);
    res.status(500).json({ message: 'Erreur lors du chargement des équipes' });
  }
};

// GET /teams/:id
const getTeamById = async (req, res) => {
  try {
    const { id } = req.params;
    const team = await Team.findByPk(id, {
      include: [
        { model: Player, as: 'players' }, 
        { model: Tournament, as: 'tournament' }, 
        { model: User, as: 'coach', attributes: ['id', 'name', 'email'] }
      ]
    });
    if (!team) {
      return res.status(404).json({ message: 'Équipe non trouvée' });
    }
    res.json({ team });
  } catch (error) {
    console.error('Error fetching team:', error);
    res.status(500).json({ message: 'Erreur lors du chargement de l\'équipe' });
  }
};

// POST /teams
const createTeam = async (req, res) => {
  try {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }

    const { name, shortName, description, logo, colors, foundedYear, homeGround, tournamentId } = req.body;
    if (!tournamentId) {
      return res.status(400).json({ message: 'tournamentId requis' });
    }
    const moveError = await tournamentMoveError({ tournamentId: null }, tournamentId);
    if (moveError) return res.status(400).json({ message: moveError });

    const team = await Team.create({
      name,
      shortName,
      description,
      logo,
      colors,
      foundedYear,
      homeGround,
      tournamentId
    });

    res.status(201).json({ message: 'Équipe créée avec succès', team });
  } catch (error) {
    console.error('Error creating team:', error);
    res.status(500).json({ message: 'Erreur lors de la création de l\'équipe' });
  }
};

// PUT /teams/:id
const updateTeam = async (req, res) => {
  try {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }

    const { id } = req.params;
    const team = await Team.findByPk(id);
    if (!team) {
      return res.status(404).json({ message: 'Équipe non trouvée' });
    }

    const { name, shortName, description, logo, colors, foundedYear, homeGround, tournamentId } = req.body;
    const nextTournamentId = tournamentId !== undefined ? (tournamentId || null) : team.tournamentId;
    const moveError = await tournamentMoveError(team, nextTournamentId);
    if (moveError) return res.status(400).json({ message: moveError });

    await team.update({
      name: name ?? team.name,
      shortName: shortName ?? team.shortName,
      description: description ?? team.description,
      logo: logo ?? team.logo,
      colors: colors ?? team.colors,
      foundedYear: foundedYear ?? team.foundedYear,
      homeGround: homeGround ?? team.homeGround,
      tournamentId: nextTournamentId,
    });

    res.json({ message: 'Équipe mise à jour avec succès', team });
  } catch (error) {
    console.error('Error updating team:', error);
    res.status(500).json({ message: 'Erreur lors de la mise à jour de l\'équipe' });
  }
};

// DELETE /teams/:id
const deleteTeam = async (req, res) => {
  try {
    const { id } = req.params;
    const team = await Team.findByPk(id);
    if (!team) {
      return res.status(404).json({ message: 'Équipe non trouvée' });
    }

    const matchCount = await Match.count({ where: { [Op.or]: [{ homeTeamId: team.id }, { awayTeamId: team.id }] } });
    if (matchCount > 0) {
      return res.status(400).json({ message: `Impossible de supprimer l'équipe : elle a ${matchCount} match(s) enregistré(s)` });
    }
    await Player.update({ teamId: null }, { where: { teamId: team.id } });
    await User.update({ teamId: null }, { where: { teamId: team.id } });
    await team.destroy();
    res.json({ message: 'Équipe supprimée avec succès' });
  } catch (error) {
    console.error('Error deleting team:', error);
    res.status(500).json({ message: 'Erreur lors de la suppression de l\'équipe' });
  }
};

module.exports = {
  getAllTeams,
  getTeamById,
  createTeam,
  updateTeam,
  deleteTeam
};


