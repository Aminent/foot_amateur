const { TournamentApplication, Team, Tournament, User, Player } = require('../models');
const { validationResult } = require('express-validator');
const notificationService = require('../services/notificationService');

// The coach ↔ team link lives on User.teamId (Team.coachId is never set).
const coachTeamId = async (userId) => {
  const coach = await User.findByPk(userId, { attributes: ['teamId'] });
  return coach?.teamId ?? null;
};

// @route   GET /api/tournament-applications
// @desc    Get all tournament applications for a coach's teams
// @access  Private (Coach)
const getMyApplications = async (req, res) => {
  try {
    const myTeamId = await coachTeamId(req.user.id);
    if (!myTeamId) return res.json([]);
    const applications = await TournamentApplication.findAll({
      include: [
        {
          model: Team,
          as: 'team',
          where: { id: myTeamId },
          include: [
            {
              model: Player,
              as: 'players'
            }
          ]
        },
        {
          model: Tournament,
          as: 'tournament'
        },
        {
          model: User,
          as: 'reviewer',
          attributes: ['id', 'name', 'email']
        }
      ],
      order: [['appliedAt', 'DESC']]
    });

    res.json(applications);
  } catch (error) {
    console.error('Error fetching applications:', error);
    res.status(500).json({ message: 'Erreur serveur' });
  }
};

// @route   POST /api/tournament-applications
// @desc    Apply for a tournament
// @access  Private (Coach)
const applyForTournament = async (req, res) => {
  try {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }

    const { teamId, tournamentId } = req.body;

    // Check if team belongs to the coach
    const team = String(await coachTeamId(req.user.id)) === String(teamId)
      ? await Team.findByPk(teamId)
      : null;

    if (!team) {
      return res.status(404).json({ message: 'Équipe non trouvée ou non autorisée' });
    }

    // Check if tournament exists and is active
    const tournament = await Tournament.findByPk(tournamentId);
    if (!tournament) {
      return res.status(404).json({ message: 'Tournoi non trouvé' });
    }

    if (tournament.status !== 'draft') {
      return res.status(400).json({ message: 'Les inscriptions à ce tournoi sont closes' });
    }
    if (team.tournamentId && team.tournamentId !== tournament.id) {
      return res.status(400).json({ message: 'Votre équipe participe déjà à un autre tournoi' });
    }

    // Check if already applied
    const existingApplication = await TournamentApplication.findOne({
      where: { teamId, tournamentId }
    });

    if (existingApplication) {
      return res.status(400).json({ message: 'Candidature déjà soumise pour ce tournoi' });
    }

    const application = await TournamentApplication.create({
      teamId,
      tournamentId,
      status: 'pending'
    });

    const newApplication = await TournamentApplication.findByPk(application.id, {
      include: [
        {
          model: Team,
          as: 'team'
        },
        {
          model: Tournament,
          as: 'tournament'
        }
      ]
    });

    res.status(201).json(newApplication);
  } catch (error) {
    console.error('Error applying for tournament:', error);
    res.status(500).json({ message: 'Erreur serveur' });
  }
};

// @route   GET /api/tournament-applications/available-tournaments
// @desc    Get tournaments available for application
// @access  Private (Coach)
const getAvailableTournaments = async (req, res) => {
  try {
    const { teamId } = req.query;

    // Check if team belongs to the coach
    const team = String(await coachTeamId(req.user.id)) === String(teamId)
      ? await Team.findByPk(teamId)
      : null;

    if (!team) {
      return res.status(404).json({ message: 'Équipe non trouvée ou non autorisée' });
    }

    // Get active tournaments that the team hasn't applied for
    const appliedTournamentIds = await TournamentApplication.findAll({
      where: { teamId },
      attributes: ['tournamentId']
    });

    const appliedIds = appliedTournamentIds.map(app => app.tournamentId);

    const availableTournaments = await Tournament.findAll({
      where: {
        status: 'draft',
        id: { [require('sequelize').Op.notIn]: appliedIds }
      },
      order: [['startDate', 'ASC']]
    });

    res.json(availableTournaments);
  } catch (error) {
    console.error('Error fetching available tournaments:', error);
    res.status(500).json({ message: 'Erreur serveur' });
  }
};

// @route   GET /api/tournament-applications/admin
// @desc    Get all tournament applications (Admin only)
// @access  Private (Admin)
const getAllApplications = async (req, res) => {
  try {
    const applications = await TournamentApplication.findAll({
      include: [
        {
          model: Team,
          as: 'team',
          include: [
            {
              model: User,
              as: 'coach',
              attributes: ['id', 'name', 'email']
            }
          ]
        },
        {
          model: Tournament,
          as: 'tournament'
        },
        {
          model: User,
          as: 'reviewer',
          attributes: ['id', 'name', 'email']
        }
      ],
      order: [['appliedAt', 'DESC']]
    });

    res.json(applications);
  } catch (error) {
    console.error('Error fetching all applications:', error);
    res.status(500).json({ message: 'Erreur serveur' });
  }
};

// @route   PUT /api/tournament-applications/:id/review
// @desc    Review a tournament application (Admin only)
// @access  Private (Admin)
const reviewApplication = async (req, res) => {
  try {
    const { id } = req.params;
    const { status, notes } = req.body;

    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }

    const application = await TournamentApplication.findByPk(id, {
      include: [
        {
          model: Team,
          as: 'team'
        },
        {
          model: Tournament,
          as: 'tournament'
        }
      ]
    });

    if (!application) {
      return res.status(404).json({ message: 'Candidature non trouvée' });
    }

    if (application.status !== 'pending') {
      return res.status(400).json({ message: 'Cette candidature a déjà été traitée' });
    }

    if (status === 'approved') {
      const t = application.tournament;
      if (t.status !== 'draft') {
        return res.status(400).json({ message: 'Les inscriptions sont closes : le tableau de ce tournoi est déjà généré' });
      }
      if (application.team.tournamentId && application.team.tournamentId !== t.id) {
        return res.status(400).json({ message: 'Cette équipe participe déjà à un autre tournoi' });
      }
      const count = await Team.count({ where: { tournamentId: t.id } });
      if (t.maxTeams && count >= t.maxTeams) {
        return res.status(400).json({ message: `Le tournoi est complet (${t.maxTeams} équipes)` });
      }
    }

    await application.update({
      status,
      notes,
      reviewedAt: new Date(),
      reviewedBy: req.user.id
    });

    // If approved, add team to tournament
    if (status === 'approved') {
      await application.team.update({
        tournamentId: application.tournamentId
      });
    }

    const updatedApplication = await TournamentApplication.findByPk(id, {
      include: [
        {
          model: Team,
          as: 'team',
          include: [
            {
              model: User,
              as: 'coach',
              attributes: ['id', 'name', 'email']
            }
          ]
        },
        {
          model: Tournament,
          as: 'tournament'
        },
        {
          model: User,
          as: 'reviewer',
          attributes: ['id', 'name', 'email']
        }
      ]
    });

    res.json(updatedApplication);

    // Push notification to coach (fire-and-forget)
    try {
      const coachUser = updatedApplication.team?.coach;
      if (coachUser?.id) {
        const coach = await User.findByPk(coachUser.id, { attributes: ['fcmToken'] });
        if (coach?.fcmToken) {
          const tournamentName = updatedApplication.tournament?.name ?? 'un tournoi';
          if (status === 'approved') {
            await notificationService.sendToToken(
              coach.fcmToken,
              '✅ Candidature approuvée !',
              `Votre équipe a été acceptée dans ${tournamentName}.`,
              { type: 'application_approved', applicationId: String(id) }
            );
          } else if (status === 'rejected') {
            await notificationService.sendToToken(
              coach.fcmToken,
              '❌ Candidature refusée',
              `Votre candidature pour ${tournamentName} a été refusée.`,
              { type: 'application_rejected', applicationId: String(id) }
            );
          }
        }
      }
    } catch (notifErr) {
      console.warn('[FCM] reviewApplication notify error:', notifErr.message);
    }
  } catch (error) {
    console.error('Error reviewing application:', error);
    res.status(500).json({ message: 'Erreur serveur' });
  }
};

module.exports = {
  getMyApplications,
  applyForTournament,
  getAvailableTournaments,
  getAllApplications,
  reviewApplication
};
