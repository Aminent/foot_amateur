const sequelize = require('../config/database');
const Tournament = require('./Tournament');
const User = require('./User');
const Team = require('./Team');
const Player = require('./Player');
const Match = require('./Match');
const MatchEvent = require('./MatchEvent');
const MatchLineup = require('./MatchLineup');
const PlayerStat = require('./PlayerStat');
const PlayerBadge = require('./PlayerBadge');
const PlayerReward = require('./PlayerReward');
const TournamentApplication = require('./TournamentApplication');
const Chat = require('./Chat');
const TrainingSession = require('./TrainingSession');
const TrainingAttendance = require('./TrainingAttendance');
const PlayerClubHistory = require('./PlayerClubHistory');
const ScoutEvaluation = require('./ScoutEvaluation');
const ScoutWatchlist = require('./ScoutWatchlist');
const RefereeMission = require('./RefereeMission');

// Define associations
// Tournament Team
Tournament.hasMany(Team, { as: 'teams', foreignKey: 'tournamentId' });
Team.belongsTo(Tournament, { as: 'tournament', foreignKey: 'tournamentId' });

// Tournament Match
Tournament.hasMany(Match, { as: 'matches', foreignKey: 'tournamentId' });
Match.belongsTo(Tournament, { as: 'tournament', foreignKey: 'tournamentId' });

// Team Coach (User) - Updated to use teamId in User model
User.belongsTo(Team, { as: 'team', foreignKey: 'teamId' });
Team.hasOne(User, { as: 'coach', foreignKey: 'teamId', scope: { role: 'coach' } });

// Team Player
Team.hasMany(Player, { as: 'players', foreignKey: 'teamId' });
Player.belongsTo(Team, { as: 'team', foreignKey: 'teamId' });

// Player User (account)
User.hasOne(Player, { as: 'playerProfile', foreignKey: 'userId' });
Player.belongsTo(User, { as: 'user', foreignKey: 'userId' });

// Match Team (home/away)
Match.belongsTo(Team, { as: 'homeTeam', foreignKey: 'homeTeamId' });
Match.belongsTo(Team, { as: 'awayTeam', foreignKey: 'awayTeamId' });

// Match MatchEvent
Match.hasMany(MatchEvent, { as: 'events', foreignKey: 'matchId' });
MatchEvent.belongsTo(Match, { as: 'match', foreignKey: 'matchId' });

// Match MatchLineup
Match.hasMany(MatchLineup, { as: 'lineups', foreignKey: 'matchId' });
MatchLineup.belongsTo(Match, { as: 'match', foreignKey: 'matchId' });
Team.hasMany(MatchLineup, { as: 'lineups', foreignKey: 'teamId' });
MatchLineup.belongsTo(Team, { as: 'team', foreignKey: 'teamId' });

// Player PlayerStat
Player.hasOne(PlayerStat, { as: 'stats', foreignKey: 'playerId' });
PlayerStat.belongsTo(Player, { as: 'player', foreignKey: 'playerId' });

// Player PlayerBadge
Player.hasMany(PlayerBadge, { as: 'badges', foreignKey: 'playerId' });
PlayerBadge.belongsTo(Player, { as: 'player', foreignKey: 'playerId' });
PlayerBadge.belongsTo(Player, { as: 'awardedBy', foreignKey: 'awardedById' });

// Player PlayerReward
Player.hasMany(PlayerReward, { as: 'rewards', foreignKey: 'playerId' });
PlayerReward.belongsTo(Player, { as: 'player', foreignKey: 'playerId' });
PlayerReward.belongsTo(Player, { as: 'awardedBy', foreignKey: 'awardedById' });

// Badge Tournament associations
PlayerBadge.belongsTo(Tournament, { as: 'tournament', foreignKey: 'tournamentId' });
PlayerReward.belongsTo(Tournament, { as: 'tournament', foreignKey: 'tournamentId' });

// TournamentApplication Team/Tournament/User
TournamentApplication.belongsTo(Team, { as: 'team', foreignKey: 'teamId' });
TournamentApplication.belongsTo(Tournament, { as: 'tournament', foreignKey: 'tournamentId' });
TournamentApplication.belongsTo(User, { as: 'reviewer', foreignKey: 'reviewedBy' });

// Chat associations
Chat.belongsTo(User, { foreignKey: 'senderId', as: 'sender' });
Chat.belongsTo(Team, { foreignKey: 'teamId', as: 'team' });

// TrainingSession associations
Team.hasMany(TrainingSession, { as: 'trainings', foreignKey: 'teamId' });
TrainingSession.belongsTo(Team, { as: 'team', foreignKey: 'teamId' });
User.hasMany(TrainingSession, { as: 'createdTrainings', foreignKey: 'coachId' });
TrainingSession.belongsTo(User, { as: 'coach', foreignKey: 'coachId' });

// TrainingAttendance associations
TrainingSession.hasMany(TrainingAttendance, { as: 'attendances', foreignKey: 'trainingSessionId' });
TrainingAttendance.belongsTo(TrainingSession, { as: 'session', foreignKey: 'trainingSessionId' });
Player.hasMany(TrainingAttendance, { as: 'attendances', foreignKey: 'playerId' });
TrainingAttendance.belongsTo(Player, { as: 'player', foreignKey: 'playerId' });

// PlayerClubHistory associations
Player.hasMany(PlayerClubHistory, { as: 'clubHistory', foreignKey: 'playerId' });
PlayerClubHistory.belongsTo(Player, { as: 'player', foreignKey: 'playerId' });
PlayerClubHistory.belongsTo(Team, { as: 'team', foreignKey: 'teamId' });

// ScoutEvaluation associations
ScoutEvaluation.belongsTo(User, { foreignKey: 'scoutId', as: 'scout' });
ScoutEvaluation.belongsTo(Player, { foreignKey: 'playerId', as: 'player' });

// ScoutWatchlist associations
ScoutWatchlist.belongsTo(User, { foreignKey: 'scoutId', as: 'scout' });
ScoutWatchlist.belongsTo(Player, { foreignKey: 'playerId', as: 'player' });

// RefereeMission associations
Match.hasMany(RefereeMission, { as: 'refereeMissions', foreignKey: 'matchId' });
RefereeMission.belongsTo(Match, { as: 'match', foreignKey: 'matchId' });
User.hasMany(RefereeMission, { as: 'refereeMissions', foreignKey: 'refereeId' });
RefereeMission.belongsTo(User, { as: 'referee', foreignKey: 'refereeId' });

// Make sure sequelize is properly exported
module.exports = {
  sequelize,
  User,
  Tournament,
  Team,
  Player,
  Match,
  MatchEvent,
  MatchLineup,
  PlayerStat,
  PlayerBadge,
  PlayerReward,
  TournamentApplication,
  Chat,
  TrainingSession,
  TrainingAttendance,
  PlayerClubHistory,
  ScoutEvaluation,
  ScoutWatchlist,
  RefereeMission,
};