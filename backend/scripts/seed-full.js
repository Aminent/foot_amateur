/**
 * Remplissage complet de la base de démo FootPro.
 * Usage : node backend/scripts/seed-full.js
 * Refuse de tourner si la table Users contient déjà des lignes.
 * Les identifiants générés sont écrits dans backend/SEED_ACCOUNTS.md (ignoré par git).
 */
require('dotenv').config({ path: require('path').join(__dirname, '../.env') });
const fs = require('fs');
const path = require('path');
const crypto = require('crypto');
const bcrypt = require('bcryptjs');
const m = require('../models');
const { sequelize, User, Tournament, Team, Player, Match, MatchEvent, MatchLineup, PlayerStat,
  PlayerBadge, PlayerReward, TournamentApplication, Chat, TrainingSession, TrainingAttendance,
  PlayerClubHistory, ScoutEvaluation, ScoutWatchlist } = m;

// ── RNG déterministe ────────────────────────────────────────────────────────
let seed = 20261123;
const rnd = () => ((seed = (seed * 1103515245 + 12345) % 2147483648) / 2147483648);
const int = (a, b) => a + Math.floor(rnd() * (b - a + 1));
const pick = (arr) => arr[Math.floor(rnd() * arr.length)];
const shuffle = (arr) => { const a = [...arr]; for (let i = a.length - 1; i > 0; i--) { const j = Math.floor(rnd() * (i + 1)); [a[i], a[j]] = [a[j], a[i]]; } return a; };
const days = (n) => new Date(Date.now() + n * 86400000);
const dateOnly = (d) => d.toISOString().slice(0, 10);
const slug = (s) => s.normalize('NFD').replace(/[̀-ͯ]/g, '').toLowerCase().replace(/[^a-z0-9]+/g, '.').replace(/^\.|\.$/g, '');

const FIRST = ['Youssef','Hamza','Ayoub','Anas','Mehdi','Omar','Ilyas','Zakaria','Soufiane','Achraf','Hakim','Amine','Reda','Karim','Nabil','Yassine','Adil','Bilal','Othmane','Walid','Ismail','Badr','Tarik','Hicham','Said','Rachid','Mohamed','Abdelali','Marouane','Khalid','Salah','Imad','Noureddine','Ayman','Taha','Nassim','Jawad','Fouad','Driss','Mounir'];
const LAST = ['El Amrani','Benali','Bennani','Tazi','Alaoui','Berrada','Chraibi','El Idrissi','Lahlou','Ouazzani','Fassi','Naciri','Kettani','Sqalli','Bouzidi','El Khattabi','Ziani','Amrabat','Hakimi','Saiss','Ezzalzouli','Boufal','Aguerd','Mazraoui','Ounahi','Amallah','Harit','El Kaabi','Rahimi','Benoun','Jabrane','Haddad','Mansouri','Rami','Ait Ali','Ouchen','Belhaj','Moutaouakil','Seddiki','Zerouali'];
const CLUBS = [
  ['Wydad Athletic Club','WAC'],['Raja Club Athletic','RCA'],['AS Lafarge Maroc','ASLM'],['Sporting Chabab Mohammadia','SCCM'],
  ['Union Sportive Mohammadia','USM'],['Tihad Athletic Sportif','TAS'],['Nadi Difaa Riadi Ain Sebaa','NDR'],['Rachad Bernoussi','RB'],
  ['Athletic Youssoufia Berrechid','CAYB'],['Etoile Jeunesse Sportive Casa','EJSC'],['Racing Athletic Sportif','RAC'],['Hayat Athletic','HAC'],
  ['Chabab Fida','CCF'],['Ennajjah Ryadi Mediouna','ERM'],['Al Ahram Riadi','AHRAM'],['Mejd Ancienne Medina','MCAM'],
];
const GROUNDS = ['Stade Mohammed V','Stade Père Jégo','Complexe Al Amal','Stade Larbi Zaouli','Terrain Sidi Moumen','Stade El Bachir','Complexe Oasis','Stade Ain Chock'];
const COLORS = [['#d32f2f','#ffffff'],['#2e7d32','#ffffff'],['#1565c0','#ffeb3b'],['#000000','#ffffff'],['#6a1b9a','#ffffff'],['#ef6c00','#000000'],['#00838f','#ffffff'],['#c62828','#000000']];
// 18 joueurs : 2 G, 6 D, 6 M, 4 A
const SQUAD = [...Array(2).fill('gardien'), ...Array(6).fill('defenseur'), ...Array(6).fill('milieu'), ...Array(4).fill('attaquant')];
const FORMATION_433 = { gardien: 1, defenseur: 4, milieu: 3, attaquant: 3 };

async function main() {
  await sequelize.authenticate();
  await sequelize.sync();
  if (await User.count()) {
    console.error('❌ La table Users n\'est pas vide — arrêt (aucune donnée modifiée).');
    process.exit(1);
  }

  const adminPassword = crypto.randomBytes(9).toString('base64url');
  const sharedPassword = '123456';
  const adminHash = await bcrypt.hash(adminPassword, 10);
  const sharedHash = await bcrypt.hash(sharedPassword, 10);

  const t = await sequelize.transaction();
  try {
    const o = { transaction: t };
    // ── Admin + scout (le scouting utilise n'importe quel compte authentifié) ─
    const admin = await User.create({ email: 'admin@footpro.ma', password: adminHash, name: 'Administrateur FootPro', role: 'admin', phone: '+212600000000' }, o);

    // ── Tournois ──────────────────────────────────────────────────────────────
    const league = await Tournament.create({
      name: 'Championnat Amateur Casablanca 2026', description: 'Championnat en matchs aller simple entre 8 clubs du Grand Casablanca.',
      startDate: days(-60), endDate: days(60), status: 'active', maxTeams: 8, location: 'Casablanca', format: 'league',
      rules: '3 points victoire, 1 point nul. Matchs de 90 minutes. 5 remplacements autorisés.', registrationDeadline: days(-70), prizePool: 50000, entryFee: 1500,
    }, o);
    const cup = await Tournament.create({
      name: 'Coupe Raja Academy U23', description: 'Tournoi à élimination directe pour 8 équipes.',
      startDate: days(-45), endDate: days(-10), status: 'completed', maxTeams: 8, location: 'Casablanca — Oasis', format: 'knockout',
      rules: 'Élimination directe. Tirs au but en cas d\'égalité.', registrationDeadline: days(-55), prizePool: 30000, entryFee: 1000,
    }, o);
    const upcoming = await Tournament.create({
      name: 'Tournoi Ramadan 2027', description: 'Tournoi de nuit, phase de groupes puis élimination directe.',
      startDate: days(90), endDate: days(120), status: 'draft', maxTeams: 16, location: 'Mohammedia', format: 'group_then_knockout',
      rules: 'Groupes de 4, les deux premiers qualifiés.', registrationDeadline: days(75), prizePool: 20000, entryFee: 800,
    }, o);

    // ── Équipes, coachs, joueurs ─────────────────────────────────────────────
    const teams = []; const coaches = []; const playersByTeam = {}; const allPlayers = [];
    const usedEmails = new Set();
    const uniqueEmail = (base) => { let e = `${base}@footpro.ma`, i = 2; while (usedEmails.has(e)) e = `${base}${i++}@footpro.ma`; usedEmails.add(e); return e; };
    let phoneN = 1;
    const phone = () => `+2126${String(10000000 + phoneN++).slice(-8)}`;

    for (let i = 0; i < CLUBS.length; i++) {
      const [name, short] = CLUBS[i];
      const tournamentId = i < 8 ? league.id : cup.id;
      const team = await Team.create({
        name, shortName: short, description: `${name}, club amateur affilié à la Ligue de Casablanca.`, tournamentId,
        colors: COLORS[i % COLORS.length], foundedYear: int(1940, 2015), homeGround: GROUNDS[i % GROUNDS.length], isActive: true,
      }, o);
      const cName = `${pick(FIRST)} ${pick(LAST)}`;
      const coach = await User.create({ email: uniqueEmail(`coach.${short.toLowerCase()}`), password: sharedHash, name: cName, role: 'coach', phone: phone(), teamId: team.id }, o);
      await team.update({ coachId: coach.id }, o);
      teams.push(team); coaches.push(coach);

      const numbers = shuffle([...Array(30).keys()].map((n) => n + 2)); numbers.unshift(1);
      playersByTeam[team.id] = [];
      for (let p = 0; p < SQUAD.length; p++) {
        const pName = `${pick(FIRST)} ${pick(LAST)}`;
        const email = uniqueEmail(slug(pName));
        const user = await User.create({ email, password: sharedHash, name: pName, role: 'joueur', phone: phone() }, o);
        const pos = SQUAD[p];
        const player = await Player.create({
          name: pName, position: pos, jerseyNumber: p === 0 ? 1 : numbers[p], teamId: team.id, userId: user.id,
          dateOfBirth: dateOnly(new Date(int(1995, 2007), int(0, 11), int(1, 28))), height: pos === 'gardien' ? int(183, 196) : int(168, 190),
          weight: int(64, 88), nationality: rnd() < 0.9 ? 'Marocaine' : pick(['Sénégalaise', 'Ivoirienne', 'Algérienne', 'Malienne']),
          preferredFoot: pick(['droit', 'droit', 'droit', 'gauche', 'ambidextre']), isCaptain: p === 8, isActive: true,
          joinDate: dateOnly(days(-int(60, 1500))), email, phone: user.phone,
        }, o);
        player._pos = pos;
        playersByTeam[team.id].push(player); allPlayers.push(player);
      }
    }

    // ── Candidatures aux tournois ────────────────────────────────────────────
    for (const team of teams) {
      await TournamentApplication.create({ teamId: team.id, tournamentId: team.tournamentId, status: 'approved', appliedAt: days(-75), reviewedAt: days(-72), reviewedBy: admin.id, notes: 'Dossier complet.' }, o);
    }
    for (const team of teams.slice(0, 6)) {
      await TournamentApplication.create({ teamId: team.id, tournamentId: upcoming.id, status: pick(['pending', 'pending', 'approved', 'rejected']), appliedAt: days(-int(1, 10)), notes: 'Candidature en attente de validation.' }, o);
    }

    // ── Stats agrégées (accumulées pendant la génération des matchs) ────────
    const stats = new Map(allPlayers.map((p) => [p.id, { goals: 0, assists: 0, yellowCards: 0, redCards: 0, minutesPlayed: 0, matches: 0, cleanSheets: 0, goalsConceded: 0, saves: 0 }]));

    const playMatch = async (match, home, away, status) => {
      const lineupOf = (team) => {
        const squad = playersByTeam[team.id];
        const starters = [];
        for (const [pos, n] of Object.entries(FORMATION_433)) starters.push(...shuffle(squad.filter((p) => p._pos === pos)).slice(0, n));
        const bench = squad.filter((p) => !starters.includes(p)).slice(0, 7);
        return { starters, bench };
      };
      const lineups = {};
      for (const team of [home, away]) {
        const { starters, bench } = lineupOf(team);
        lineups[team.id] = { starters, bench };
        await MatchLineup.create({
          matchId: match.id, teamId: team.id, formation: '4-3-3', status: 'published',
          players: [...starters.map((p) => ({ playerId: p.id, name: p.name, position: p._pos, jerseyNumber: p.jerseyNumber, isStarter: true })),
            ...bench.map((p) => ({ playerId: p.id, name: p.name, position: p._pos, jerseyNumber: p.jerseyNumber, isStarter: false }))],
        }, o);
      }
      if (status !== 'completed') return;

      const hs = int(0, 4), as = int(0, 3);
      const events = [];
      const addGoals = (n, team, isHome) => {
        const { starters } = lineups[team.id];
        const attackers = starters.filter((p) => p._pos !== 'gardien');
        for (let g = 0; g < n; g++) {
          const scorer = pick([...attackers.filter((p) => p._pos === 'attaquant'), ...attackers]);
          const assister = pick(attackers.filter((p) => p !== scorer));
          const minute = int(1, 90);
          events.push({ type: rnd() < 0.1 ? 'penalty_goal' : 'goal', minute, isHome, relatedPlayerId: scorer.id, relatedPlayerName: scorer.name, description: `But de ${scorer.name}` });
          stats.get(scorer.id).goals++;
          if (rnd() < 0.75) { events.push({ type: 'assist', minute, isHome, relatedPlayerId: assister.id, relatedPlayerName: assister.name, description: `Passe décisive de ${assister.name}` }); stats.get(assister.id).assists++; }
        }
      };
      addGoals(hs, home, true); addGoals(as, away, false);
      for (const [team, isHome] of [[home, true], [away, false]]) {
        const { starters, bench } = lineups[team.id];
        for (let c = 0; c < int(0, 3); c++) {
          const p = pick(starters.filter((x) => x._pos !== 'gardien'));
          const red = rnd() < 0.07;
          events.push({ type: red ? 'red_card' : 'yellow_card', minute: int(10, 90), isHome, relatedPlayerId: p.id, relatedPlayerName: p.name, description: red ? 'Carton rouge' : 'Carton jaune' });
          stats.get(p.id)[red ? 'redCards' : 'yellowCards']++;
        }
        const subs = int(2, 4);
        for (let s = 0; s < subs; s++) {
          const out = starters[1 + s * 2], inn = bench[s + 1];
          if (!out || !inn) break;
          const minute = int(55, 85);
          events.push({ type: 'substitution', minute, isHome, substitutionPlayerOutId: out.id, substitutionPlayerOutName: out.name, substitutionPlayerInId: inn.id, substitutionPlayerInName: inn.name, description: `${inn.name} remplace ${out.name}` });
          stats.get(out.id).minutesPlayed += minute - 90; stats.get(inn.id).minutesPlayed += 90 - minute; stats.get(inn.id).matches++;
        }
        for (const p of starters) { stats.get(p.id).minutesPlayed += 90; stats.get(p.id).matches++; }
        const gk = starters.find((p) => p._pos === 'gardien');
        const conceded = isHome ? as : hs;
        stats.get(gk.id).goalsConceded += conceded; stats.get(gk.id).saves += int(1, 7);
        if (!conceded) stats.get(gk.id).cleanSheets++;
      }
      for (const e of events.sort((a, b) => a.minute - b.minute)) await MatchEvent.create({ matchId: match.id, ...e, isHomeTeam: e.isHome }, o);

      let winner = hs > as ? home.id : as > hs ? away.id : null;
      if (!winner && match.roundNumber && match._knockout) winner = pick([home.id, away.id]);
      await match.update({ homeTeamScore: hs, awayTeamScore: as, halfTimeHomeScore: Math.min(hs, int(0, hs)), halfTimeAwayScore: Math.min(as, int(0, as)), winnerTeamId: winner, notes: winner || !match._knockout ? null : 'Qualification aux tirs au but', attendance: int(150, 3500) }, o);
      return winner;
    };

    const baseMatch = (extra) => ({ referee: `${pick(FIRST)} ${pick(LAST)}`, assistantReferee1: `${pick(FIRST)} ${pick(LAST)}`, assistantReferee2: `${pick(FIRST)} ${pick(LAST)}`, weather: pick(['Ensoleillé', 'Nuageux', 'Pluie légère', 'Venteux']), reminderSent: true, notifSoonSent: true, ...extra });

    // Championnat : aller simple (round-robin), 7 journées, 4 jouées, 1 en cours, 2 à venir
    const leagueTeams = teams.slice(0, 8);
    const rot = [...leagueTeams];
    for (let r = 0; r < 7; r++) {
      const status = r < 4 ? 'completed' : r === 4 ? 'in_progress' : 'scheduled';
      for (let k = 0; k < 4; k++) {
        const [home, away] = r % 2 ? [rot[7 - k], rot[k]] : [rot[k], rot[7 - k]];
        const date = status === 'in_progress' ? new Date(Date.now() - 50 * 60000) : days(-40 + r * 10);
        const match = await Match.create(baseMatch({ tournamentId: league.id, roundNumber: r + 1, matchIndex: k, homeTeamId: home.id, awayTeamId: away.id, date, location: home.homeGround, status: status === 'completed' ? 'completed' : status, reminderSent: status !== 'scheduled', notifSoonSent: status !== 'scheduled' }), o);
        await playMatch(match, home, away, status);
        if (status === 'in_progress') await match.update({ homeTeamScore: int(0, 2), awayTeamScore: int(0, 2) }, o);
      }
      rot.splice(1, 0, rot.pop());
    }

    // Coupe : quarts → demies → finale, terminée
    const cupTeams = shuffle(teams.slice(8));
    const final = await Match.create(baseMatch({ tournamentId: cup.id, roundNumber: 3, matchIndex: 0, date: days(-10), location: 'Complexe Oasis', status: 'completed' }), o);
    const semis = [];
    for (let k = 0; k < 2; k++) semis.push(await Match.create(baseMatch({ tournamentId: cup.id, roundNumber: 2, matchIndex: k, date: days(-20), location: 'Complexe Oasis', status: 'completed', advancesToMatchId: final.id }), o));
    const qWinners = [];
    for (let k = 0; k < 4; k++) {
      const [home, away] = [cupTeams[k * 2], cupTeams[k * 2 + 1]];
      const q = await Match.create(baseMatch({ tournamentId: cup.id, roundNumber: 1, matchIndex: k, homeTeamId: home.id, awayTeamId: away.id, date: days(-40 + k), location: GROUNDS[k], status: 'completed', advancesToMatchId: semis[k >> 1].id }), o);
      q._knockout = true;
      { const w = await playMatch(q, home, away, 'completed'); qWinners.push(teams.find((x) => x.id === w)); }
    }
    const sWinners = [];
    for (let k = 0; k < 2; k++) {
      const [home, away] = [qWinners[k * 2], qWinners[k * 2 + 1]];
      await semis[k].update({ homeTeamId: home.id, awayTeamId: away.id }, o); semis[k]._knockout = true;
      { const w = await playMatch(semis[k], home, away, 'completed'); sWinners.push(teams.find((x) => x.id === w)); }
    }
    await final.update({ homeTeamId: sWinners[0].id, awayTeamId: sWinners[1].id }, o); final._knockout = true;
    const fw = await playMatch(final, sWinners[0], sWinners[1], 'completed'); const champion = teams.find((x) => x.id === fw);

    // ── PlayerStat + historique club ─────────────────────────────────────────
    for (const p of allPlayers) {
      const s = stats.get(p.id); const mins = Math.max(0, s.minutesPlayed); const f = mins / 90;
      const gk = p._pos === 'gardien';
      await PlayerStat.create({
        playerId: p.id, goals: s.goals, assists: s.assists, yellowCards: s.yellowCards, redCards: s.redCards, minutesPlayed: mins,
        shots: s.goals + Math.round(f * int(0, 3)), shotsOnTarget: s.goals + Math.round(f * int(0, 1)), passes: Math.round(f * int(20, 55)), keyPasses: Math.round(f * int(0, 2)),
        tackles: Math.round(f * (p._pos === 'defenseur' ? int(2, 5) : int(0, 2))), interceptions: Math.round(f * int(0, 3)), clearances: Math.round(f * (p._pos === 'defenseur' ? int(2, 6) : 0)),
        dribbles: Math.round(f * (p._pos === 'attaquant' ? int(1, 4) : int(0, 1))), foulsCommitted: Math.round(f * int(0, 2)), foulsSuffered: Math.round(f * int(0, 2)), offsides: p._pos === 'attaquant' ? Math.round(f * int(0, 1)) : 0,
        saves: gk ? s.saves : 0, cleanSheets: gk ? s.cleanSheets : 0, goalsConceded: gk ? s.goalsConceded : 0, penaltiesSaved: gk ? int(0, 1) : 0,
        duelsWon: Math.round(f * int(2, 8)), aerialDuelsWon: Math.round(f * int(0, 4)),
      }, o);
      const team = teams.find((x) => x.id === p.teamId);
      if (rnd() < 0.5) {
        const prev = pick(teams.filter((x) => x.id !== team.id));
        await PlayerClubHistory.create({ playerId: p.id, teamId: prev.id, teamName: prev.name, startDate: dateOnly(days(-1400)), endDate: p.joinDate, goals: int(0, 12), assists: int(0, 8), matches: int(8, 40), minutesPlayed: int(600, 3200), yellowCards: int(0, 6), redCards: int(0, 1) }, o);
      }
      await PlayerClubHistory.create({ playerId: p.id, teamId: team.id, teamName: team.name, startDate: p.joinDate, endDate: null, goals: s.goals, assists: s.assists, matches: s.matches, minutesPlayed: mins, yellowCards: s.yellowCards, redCards: s.redCards, cleanSheets: gk ? s.cleanSheets : 0, saves: gk ? s.saves : 0 }, o);
    }

    // ── Entraînements + présences ────────────────────────────────────────────
    const TRAININGS = [['Conservation et jeu court', 'technique'], ['Pressing haut', 'tactique'], ['Endurance et fractionné', 'physique'], ['Match d\'application', 'match'], ['Coups de pied arrêtés', 'tactique'], ['Finition devant le but', 'technique']];
    for (let i = 0; i < teams.length; i++) {
      const team = teams[i];
      for (let s = 0; s < 10; s++) {
        const [title, type] = TRAININGS[s % TRAININGS.length];
        const past = s < 7;
        const ts = await TrainingSession.create({ teamId: team.id, coachId: coaches[i].id, title, type, description: `Séance ${type} — ${title.toLowerCase()}.`, date: days(past ? -3 * (7 - s) : 2 * (s - 6)), duration: pick([60, 75, 90, 105]), location: team.homeGround, status: past ? (rnd() < 0.08 ? 'cancelled' : 'completed') : 'scheduled' }, o);
        if (past && ts.status === 'completed') {
          await TrainingAttendance.bulkCreate(playersByTeam[team.id].map((p) => { const r = rnd(); return { trainingSessionId: ts.id, playerId: p.id, status: r < 0.82 ? 'present' : r < 0.92 ? 'excused' : 'absent', note: r >= 0.82 && r < 0.92 ? pick(['Blessure légère', 'Examen', 'Raison familiale']) : null }; }), o);
        }
      }
    }

    // ── Chat d'équipe ────────────────────────────────────────────────────────
    const MSGS_COACH = ['Rendez-vous 18h au stade, soyez à l\'heure.', 'Bravo pour le match d\'hier, belle mentalité !', 'Pensez à apporter vos protège-tibias.', 'La compo sera publiée demain matin.', 'Séance vidéo jeudi avant l\'entraînement.'];
    const MSGS_PLAYER = ['Bien reçu coach 👍', 'Je serai là.', 'Je suis un peu en retard, j\'arrive.', 'On lâche rien les gars 💪', 'Qui peut me déposer samedi ?', 'Merci coach !'];
    for (let i = 0; i < teams.length; i++) {
      const team = teams[i]; const squadUsers = playersByTeam[team.id].map((p) => p.userId);
      const rows = [];
      for (let k = 0; k < 14; k++) {
        const fromCoach = k % 4 === 0;
        const createdAt = new Date(Date.now() - (14 - k) * 3600000 * 5);
        rows.push({ teamId: team.id, senderId: fromCoach ? coaches[i].id : pick(squadUsers), message: fromCoach ? pick(MSGS_COACH) : pick(MSGS_PLAYER), messageType: 'text', isRead: k < 11, readBy: k < 11 ? squadUsers.slice(0, int(5, 18)) : [], createdAt, updatedAt: createdAt });
      }
      await Chat.bulkCreate(rows, o);
    }

    // ── Badges et récompenses ────────────────────────────────────────────────
    const scorers = [...allPlayers].sort((a, b) => stats.get(b.id).goals - stats.get(a.id).goals);
    for (const [idx, p] of scorers.slice(0, 10).entries()) {
      await PlayerBadge.create({ playerId: p.id, name: idx === 0 ? 'Meilleur buteur' : 'Buteur en série', type: 'excellence', rarity: idx === 0 ? 'legendary' : idx < 3 ? 'epic' : 'rare', description: `${stats.get(p.id).goals} buts cette saison`, source: 'system', icon: '⚽', tournamentId: league.id }, o);
    }
    for (const p of playersByTeam[champion.id]) {
      await PlayerBadge.create({ playerId: p.id, name: 'Vainqueur de la Coupe', type: 'tournament', rarity: 'epic', description: `Vainqueur de la ${cup.name}`, source: 'tournament', icon: '🏆', tournamentId: cup.id }, o);
      await PlayerReward.create({ playerId: p.id, name: 'Prime de victoire', description: 'Prime collective Coupe U23', type: 'tournament', category: 'tournament', value: 500, icon: '💰', tournamentId: cup.id }, o);
    }
    for (const p of allPlayers) {
      if (rnd() < 0.35) await PlayerBadge.create({ playerId: p.id, name: pick(['Assidu à l\'entraînement', 'Esprit d\'équipe', 'Progression du mois']), type: pick(['training', 'participation', 'achievement']), rarity: pick(['common', 'common', 'uncommon', 'rare']), description: 'Attribué par le coach', source: 'coach', icon: pick(['🔥', '🤝', '📈']), count: int(1, 3) }, o);
      if (rnd() < 0.2) await PlayerReward.create({ playerId: p.id, name: pick(['Joueur de la semaine', '10 entraînements consécutifs', 'Premier but']), description: 'Récompense attribuée par le staff', type: pick(['training', 'milestone', 'special']), category: pick(['training', 'milestone', 'special']), value: pick([50, 100, 150, 200]), icon: '🎖️' }, o);
    }

    // ── Scouting (évaluations par l'admin) ───────────────────────────────────
    for (const p of shuffle(allPlayers).slice(0, 40)) {
      const tech = int(50, 95) / 10, phys = int(50, 95) / 10, ment = int(50, 95) / 10, tact = int(50, 95) / 10;
      const overall = Math.round(((tech + phys + ment + tact) / 4) * 10) / 10;
      await ScoutEvaluation.create({ scoutId: admin.id, playerId: p.id, date: dateOnly(days(-int(1, 40))), overallRating: overall, technicalScore: tech, physicalScore: phys, mentalScore: ment, tacticalScore: tact, recommendation: overall >= 8 ? 'sign' : overall >= 6.5 ? 'watch' : 'reject', potential: overall >= 8.5 ? 'elite' : overall >= 7.5 ? 'high' : overall >= 6 ? 'medium' : 'low', position: p._pos, notes: pick(['Bonne lecture du jeu.', 'Très rapide, doit progresser dans les duels.', 'Leader naturel.', 'Technique au-dessus de la moyenne.', 'À revoir sur un match à enjeu.']) }, o);
      if (overall >= 7) await ScoutWatchlist.create({ scoutId: admin.id, playerId: p.id, notes: 'À suivre de près' }, o);
    }

    await t.commit();

    // ── Récap ────────────────────────────────────────────────────────────────
    const counts = {};
    for (const [k, model] of Object.entries(m)) if (k !== 'sequelize') counts[k] = await model.count();
    counts.coachs = await User.count({ where: { role: 'coach' } });
    counts.joueurs = await User.count({ where: { role: 'joueur' } });
    console.table(counts);

    const lines = ['# Comptes de démo FootPro (générés par scripts/seed-full.js)', '', '> Fichier local, ignoré par git. Ne pas commiter.', '',
      '## Admin (web)', `- Email : admin@footpro.ma`, `- Mot de passe : ${adminPassword}`, '',
      `## Coachs et joueurs — mot de passe commun : \`${sharedPassword}\``, '', '| Équipe | Coach | Exemple joueur |', '|---|---|---|',
      ...teams.map((tm, i) => `| ${tm.name} | ${coaches[i].email} | ${playersByTeam[tm.id][0].email} |`), ''];
    fs.writeFileSync(path.join(__dirname, '../SEED_ACCOUNTS.md'), lines.join('\n'));
    console.log('✅ Seed terminé. Identifiants dans backend/SEED_ACCOUNTS.md');
  } catch (err) {
    await t.rollback();
    console.error('❌ Seed annulé (rollback) :', err.message, err.errors?.map((e) => e.message));
    process.exit(1);
  } finally {
    await sequelize.close();
  }
}

main();
