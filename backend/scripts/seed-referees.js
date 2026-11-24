/**
 * Ajoute des arbitres et leurs missions à une base déjà remplie par seed-full.js.
 * Usage : node backend/scripts/seed-referees.js   (mot de passe de tous les arbitres : 123456)
 */
require('dotenv').config({ path: require('path').join(__dirname, '../.env') });
const bcrypt = require('bcryptjs');
const { sequelize, User, Match, RefereeMission } = require('../models');

const REFS = [
  ['Karim Arbitre', 'arbitre.test@footpro.com'],
  ['Redouane Jiyed', 'redouane.jiyed@footpro.ma'],
  ['Samir Guezzaz', 'samir.guezzaz@footpro.ma'],
  ['Noureddine El Jaafari', 'noureddine.eljaafari@footpro.ma'],
  ['Bouchra Karboubi', 'bouchra.karboubi@footpro.ma'],
  ['Mustapha Kechchaf', 'mustapha.kechchaf@footpro.ma'],
];
const ROLES = ['main', 'assistant', 'assistant', 'fourth'];

(async () => {
  await sequelize.authenticate();
  await sequelize.sync();
  if (await User.count({ where: { role: 'arbitre' } })) { console.log('Des arbitres existent déjà — rien à faire.'); return sequelize.close(); }
  const hash = await bcrypt.hash('123456', 10);
  const refs = [];
  for (const [i, [name, email]] of REFS.entries()) refs.push(await User.create({ name, email, password: hash, role: 'arbitre', phone: `+21266100000${i}` }));
  const admin = await User.findOne({ where: { role: 'admin' } });

  const matches = await Match.findAll({ where: { homeTeamId: { [require('sequelize').Op.ne]: null } }, order: [['date', 'ASC']] });
  const now = Date.now();
  let n = 0;
  for (const [mi, match] of matches.entries()) {
    // 4 arbitres par match, en rotation
    for (let r = 0; r < 4; r++) {
      const ref = refs[(mi + r) % refs.length];
      const past = new Date(match.date).getTime() < now;
      let status = 'accepted';
      if (!past) status = (mi + r) % 3 === 0 ? 'pending' : (mi + r) % 7 === 0 ? 'declined' : 'accepted';
      else if ((mi + r) % 9 === 0) status = 'declined';
      await RefereeMission.create({ matchId: match.id, refereeId: ref.id, role: ROLES[r], status, respondedAt: status === 'pending' ? null : new Date(new Date(match.date).getTime() - 3 * 86400000), declineReason: status === 'declined' ? 'Indisponible à cette date' : null, assignedById: admin?.id });
      if (r === 0 && status === 'accepted') await match.update({ referee: ref.name });
      n++;
    }
  }
  const karim = refs[0];
  console.log(`✅ ${refs.length} arbitres, ${n} missions. Karim : ${await RefereeMission.count({ where: { refereeId: karim.id } })} missions.`);
  await sequelize.close();
})().catch((e) => { console.error('❌', e.message); process.exit(1); });
