const { Client } = require('pg');
require('dotenv').config();

async function createDatabase() {
  // Connexion à PostgreSQL sans spécifier de base de données
  const client = new Client({
    host: process.env.DB_HOST,
    port: process.env.DB_PORT,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    database: 'postgres' // Base de données par défaut
  });

  try {
    console.log('🔌 Connexion à PostgreSQL...');
    await client.connect();
    console.log('✅ Connexion établie avec succès');

    // Vérifier si la base de données existe déjà
    const checkDbQuery = `
      SELECT 1 FROM pg_database WHERE datname = '${process.env.DB_NAME}'
    `;
    const dbExists = await client.query(checkDbQuery);

    if (dbExists.rows.length > 0) {
      console.log(`✅ La base de données '${process.env.DB_NAME}' existe déjà`);
    } else {
      // Créer la base de données
      const createDbQuery = `CREATE DATABASE ${process.env.DB_NAME}`;
      await client.query(createDbQuery);
      console.log(`✅ Base de données '${process.env.DB_NAME}' créée avec succès`);
    }

  } catch (error) {
    console.error('❌ Erreur lors de la création de la base de données:', error.message);
    
    if (error.code === 'ECONNREFUSED') {
      console.log('\n🔧 Solutions possibles :');
      console.log('1. Vérifiez que PostgreSQL est démarré');
      console.log('2. Vérifiez les paramètres de connexion dans .env');
      console.log('3. Vérifiez que le port 5432 est accessible');
    }
    
    process.exit(1);
  } finally {
    await client.end();
  }
}

createDatabase();