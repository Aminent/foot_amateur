const sequelize = require('./config/database');
require('dotenv').config();

// Importer tous les modèles pour s'assurer qu'ils sont définis
require('./models/User');
require('./models/Tournament');
require('./models/Team');
require('./models/Player');
require('./models/Match');
require('./models/MatchEvent');

// Importer les associations
const models = require('./models/index');

async function syncDatabase() {
  try {
    console.log('🔌 Connexion à la base de données...');
    await sequelize.authenticate();
    console.log('✅ Connexion établie');

    console.log('🔄 Synchronisation des modèles...');
    
    // Forcer la synchronisation (attention: cela peut supprimer des données)
    await sequelize.sync({ force: true });
    

    console.log('✅ Base de données synchronisée avec succès !');
    
    // Vérifier les tables créées
    const tables = await sequelize.showAllSchemas();
    console.log('\n📋 Tables créées:');
    console.log(tables);

  } catch (error) {
    console.error('❌ Erreur lors de la synchronisation:', error);
  } finally {
    await sequelize.close();
  }
}

syncDatabase(); 