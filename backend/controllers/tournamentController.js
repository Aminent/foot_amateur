const { Tournament, Team, Match, Player } = require('../models');
const { validationResult } = require('express-validator');
const { Op } = require('sequelize');

// GET /tournaments?search=&status=&page=1&limit=20
const getAllTournaments = async (req, res) => {
  try {
    const { search, status, page = 1, limit = 20 } = req.query;

    const parsedPage  = Math.max(1, parseInt(page)  || 1);
    const parsedLimit = Math.min(100, Math.max(1, parseInt(limit) || 20));
    const offset      = (parsedPage - 1) * parsedLimit;

    const where = {};
    if (search) where.name   = { [Op.iLike]: `%${search.trim()}%` };
    if (status) where.status = status;

    const { count, rows: tournaments } = await Tournament.findAndCountAll({
      where,
      include: [
        // Only basic team info in list view — full match data lives in getTournamentById
        { model: Team, as: 'teams', attributes: ['id', 'name', 'shortName'] },
      ],
      order: [['startDate', 'DESC']],
      limit: parsedLimit,
      offset,
      distinct: true,
    });

    res.json({
      tournaments,
      pagination: {
        page:       parsedPage,
        limit:      parsedLimit,
        total:      count,
        totalPages: Math.ceil(count / parsedLimit),
      },
    });
  } catch (error) {
    console.error('Tournament fetch error:', error);
    res.status(500).json({ message: error.message });
  }
};

// Obtenir un tournoi par ID
const getTournamentById = async (req, res) => {
  try {
    const { id } = req.params;
    const { lite } = req.query;
    console.log(`Fetching tournament with ID: ${id}`);

    if (!id || isNaN(id)) {
      return res.status(400).json({ 
        message: 'Invalid tournament ID' 
      });
    }

    const include = lite === 'true'
      ? []
      : [
          {
            model: Team,
            as: 'teams',
            include: [{
              model: Player,
              as: 'players'
            }]
          }
        ];

    const tournament = await Tournament.findByPk(id, { include });

    if (!tournament) {
      console.log(`Tournament with ID ${id} not found`);
      return res.status(404).json({ 
        message: `Tournament with ID ${id} not found` 
      });
    }

    console.log(`Successfully found tournament: ${tournament.name}`);
    res.json({ tournament });
  } catch (error) {
    console.error('Error in getTournamentById:', error);
    res.status(500).json({ 
      message: 'Internal server error',
      error: process.env.NODE_ENV === 'development' ? error.message : undefined
    });
  }
};

// Créer un nouveau tournoi
const createTournament = async (req, res) => {
  try {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }

    const {
      name,
      description,
      startDate,
      endDate,
      maxTeams,
      location,
      rules,
      format,
      entryFee,
      prizePool,
      registrationDeadline,
      isPublic
    } = req.body;

    const tournament = await Tournament.create({
      name,
      description,
      startDate,
      endDate,
      maxTeams,
      location,
      rules,
      format,
      entryFee,
      prizePool,
      registrationDeadline,
      isPublic,
      status: 'draft'
    });

    res.status(201).json({
      message: 'Tournoi créé avec succès',
      tournament
    });
  } catch (error) {
    console.error('Erreur lors de la création du tournoi:', error);
    res.status(500).json({ message: 'Erreur lors de la création du tournoi' });
  }
};

// Mettre à jour un tournoi
const updateTournament = async (req, res) => {
  try {
    const { id } = req.params;
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }

    const tournament = await Tournament.findByPk(id);
    if (!tournament) {
      return res.status(404).json({ message: 'Tournoi non trouvé' });
    }

    const {
      name,
      description,
      startDate,
      endDate,
      status,
      maxTeams,
      location,
      rules,
      format,
      entryFee,
      prizePool,
      registrationDeadline,
      isPublic
    } = req.body;

    // ── #19 : Utiliser ?? au lieu de || pour permettre de vider un champ ─────
    // Avec ||, une valeur "" ou 0 serait ignorée et l'ancienne valeur conservée.
    // Avec ??, seul `undefined` (champ absent du body) conserve l'ancienne valeur.
    await tournament.update({
      name:                 name                 !== undefined ? name                 : tournament.name,
      description:          description          !== undefined ? description          : tournament.description,
      startDate:            startDate            !== undefined ? startDate            : tournament.startDate,
      endDate:              endDate              !== undefined ? endDate              : tournament.endDate,
      status:               status               !== undefined ? status               : tournament.status,
      maxTeams:             maxTeams             !== undefined ? maxTeams             : tournament.maxTeams,
      location:             location             !== undefined ? location             : tournament.location,
      rules:                rules                !== undefined ? rules                : tournament.rules,
      format:               format               !== undefined ? format               : tournament.format,
      entryFee:             entryFee             !== undefined ? entryFee             : tournament.entryFee,
      prizePool:            prizePool            !== undefined ? prizePool            : tournament.prizePool,
      registrationDeadline: registrationDeadline !== undefined ? registrationDeadline : tournament.registrationDeadline,
      isPublic:             typeof isPublic === 'boolean'      ? isPublic             : tournament.isPublic,
    });

    res.json({
      message: 'Tournoi mis à jour avec succès',
      tournament
    });
  } catch (error) {
    console.error('Erreur lors de la mise à jour du tournoi:', error);
    res.status(500).json({ message: 'Erreur lors de la mise à jour du tournoi' });
  }
};

// Supprimer un tournoi
const deleteTournament = async (req, res) => {
  try {
    const { id } = req.params;

    const tournament = await Tournament.findByPk(id);
    if (!tournament) {
      return res.status(404).json({ message: 'Tournoi non trouvé' });
    }

    // Vérifier s'il y a des équipes ou des matchs associés
    const teamCount = await tournament.countTeams();
    const matchCount = await tournament.countMatches();

    if (teamCount > 0 || matchCount > 0) {
      return res.status(400).json({
        message: 'Impossible de supprimer le tournoi car il contient des équipes ou des matchs'
      });
    }

    await tournament.destroy();

    res.json({ message: 'Tournoi supprimé avec succès' });
  } catch (error) {
    console.error('Erreur lors de la suppression du tournoi:', error);
    res.status(500).json({ message: 'Erreur lors de la suppression du tournoi' });
  }
};

// Obtenir les statistiques d'un tournoi
const getTournamentStats = async (req, res) => {
  try {
    const { id } = req.params;

    const tournament = await Tournament.findByPk(id, {
      include: [
        {
          model: Team,
          as: 'teams',
          include: [{
            model: require('../models/Player'),
            as: 'players'
          }]
        },
        {
          model: Match,
          as: 'matches',
          include: [{
            model: require('../models/MatchEvent'),
            as: 'events'
          }]
        }
      ]
    });

    if (!tournament) {
      return res.status(404).json({ message: 'Tournoi non trouvé' });
    }

    // Calculer les statistiques
    const stats = {
      totalTeams: tournament.teams.length,
      totalPlayers: tournament.teams.reduce((acc, team) => acc + team.players.length, 0),
      totalMatches: tournament.matches.length,
      completedMatches: tournament.matches.filter(match => match.status === 'completed').length,
      totalGoals: tournament.matches.reduce((acc, match) => {
        return acc + (match.homeTeamScore || 0) + (match.awayTeamScore || 0);
      }, 0)
    };

    res.json({ stats });
  } catch (error) {
    console.error('Erreur lors de la récupération des statistiques:', error);
    res.status(500).json({ message: 'Erreur lors de la récupération des statistiques' });
  }
};

module.exports = {
  getAllTournaments,
  getTournamentById,
  createTournament,
  updateTournament,
  deleteTournament,
  getTournamentStats
};