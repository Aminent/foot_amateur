# ⚽ Application de Gestion Football Amateur

Une application complète de gestion de tournois, équipes et matchs pour le football amateur, construite avec Express.js, React.js et PostgreSQL.

## 🚀 Fonctionnalités

### 👥 Gestion des utilisateurs
- **Authentification JWT** avec rôles (Admin, Coach, Joueur)
- **Inscription et connexion** sécurisées
- **Gestion des profils** utilisateurs
- **Permissions basées sur les rôles**

### 🏆 Gestion des tournois
- **Création et gestion** de tournois
- **Statuts multiples** : Brouillon, Actif, Terminé, Annulé
- **Dates de début et fin** configurables
- **Règles et descriptions** personnalisables
- **Statistiques détaillées** par tournoi

### 👥 Gestion des équipes
- **Création d'équipes** par tournoi
- **Gestion des joueurs** avec positions
- **Numéros de maillot** et informations détaillées
- **Capitaines d'équipe**

### ⚽ Gestion des matchs
- **Planification de matchs** entre équipes
- **Suivi des scores** en temps réel
- **Événements de match** (buts, cartons, substitutions)
- **Statuts de match** (Programmé, En cours, Terminé)

### 📊 Tableau de bord
- **Statistiques globales** en temps réel
- **Vue d'ensemble** des tournois actifs
- **Actions rapides** pour les administrateurs
- **Interface responsive** pour tous les appareils

## 🛠️ Technologies utilisées

### Backend
- **Node.js** avec Express.js
- **Sequelize ORM** pour la gestion de base de données
- **PostgreSQL** comme base de données relationnelle
- **JWT** pour l'authentification
- **bcryptjs** pour le hachage des mots de passe
- **express-validator** pour la validation des données

### Frontend
- **React.js** avec hooks et contexte
- **Material-UI** pour l'interface utilisateur
- **React Router** pour la navigation
- **Axios** pour les requêtes HTTP
- **Responsive design** pour mobile et desktop

## 📋 Prérequis

- **Node.js** (version 16 ou supérieure)
- **PostgreSQL** (version 12 ou supérieure)
- **npm** ou **yarn**

## 🚀 Installation

### 1. Cloner le repository
```bash
git clone <url-du-repo>
cd foot_amateur
```

### 2. Configuration de la base de données
```bash
# Créer une base de données PostgreSQL
createdb football_amateur
```

### 3. Configuration du backend
```bash
cd backend

# Installer les dépendances
npm install

# Copier le fichier d'environnement
cp env.example .env

# Configurer les variables d'environnement dans .env
DB_HOST=localhost
DB_PORT=5432
DB_NAME=football_amateur
DB_USER=postgres
DB_PASSWORD=votre_mot_de_passe
JWT_SECRET=votre_secret_jwt
```

### 4. Configuration du frontend
```bash
cd ../frontend

# Installer les dépendances
npm install
```

## 🏃‍♂️ Démarrage

### 1. Démarrer le backend
```bash
cd backend
npm run dev
```
Le serveur backend sera accessible sur `http://localhost:5000`

### 2. Démarrer le frontend
```bash
cd frontend
npm start
```
L'application frontend sera accessible sur `http://localhost:3000`

## 📁 Structure du projet

```
foot_amateur/
├── backend/
│   ├── config/
│   │   └── database.js
│   ├── controllers/
│   │   ├── authController.js
│   │   └── tournamentController.js
│   ├── middleware/
│   │   └── auth.js
│   ├── models/
│   │   ├── User.js
│   │   ├── Tournament.js
│   │   ├── Team.js
│   │   ├── Player.js
│   │   ├── Match.js
│   │   ├── MatchEvent.js
│   │   └── index.js
│   ├── routes/
│   │   ├── auth.js
│   │   └── tournaments.js
│   ├── server.js
│   └── package.json
├── frontend/
│   ├── public/
│   ├── src/
│   │   ├── components/
│   │   ├── contexts/
│   │   ├── pages/
│   │   ├── App.js
│   │   └── index.js
│   └── package.json
└── README.md
```

## 🔐 Rôles et permissions

### 👑 Administrateur
- **Accès complet** à toutes les fonctionnalités
- **Gestion des utilisateurs** et des rôles
- **Création et suppression** de tournois
- **Modération** de l'ensemble de l'application

### 🎯 Coach
- **Gestion des équipes** et des joueurs
- **Création et modification** de tournois
- **Suivi des matchs** et des statistiques
- **Gestion des événements** de match

### ⚽ Joueur
- **Consultation** des tournois et équipes
- **Profil personnel** et informations
- **Suivi des matchs** et résultats
- **Accès limité** aux fonctionnalités de gestion

## 🗄️ Modèle de données

### Tables principales
- **Users** : Utilisateurs avec rôles et authentification
- **Tournaments** : Tournois avec dates et statuts
- **Teams** : Équipes participant aux tournois
- **Players** : Joueurs avec positions et informations
- **Matches** : Matchs entre équipes
- **MatchEvents** : Événements de match (buts, cartons, etc.)

### Relations
- Un tournoi → plusieurs équipes
- Une équipe → plusieurs joueurs
- Un match → 2 équipes + événements
- Un joueur → relié à un utilisateur (optionnel)

## 🔧 API Endpoints

### Authentification
- `POST /api/auth/register` - Inscription
- `POST /api/auth/login` - Connexion
- `GET /api/auth/profile` - Profil utilisateur
- `PUT /api/auth/profile` - Mise à jour du profil
- `PUT /api/auth/change-password` - Changement de mot de passe

### Tournois
- `GET /api/tournaments` - Liste des tournois
- `GET /api/tournaments/:id` - Détails d'un tournoi
- `POST /api/tournaments` - Créer un tournoi
- `PUT /api/tournaments/:id` - Modifier un tournoi
- `DELETE /api/tournaments/:id` - Supprimer un tournoi
- `GET /api/tournaments/:id/stats` - Statistiques du tournoi

## 🎨 Interface utilisateur

L'application utilise Material-UI avec un thème personnalisé :
- **Couleurs** : Bleu football (#1976d2) et orange accent (#ff6f00)
- **Design responsive** pour mobile, tablette et desktop
- **Navigation intuitive** avec sidebar et menu utilisateur
- **Cartes et composants** modernes et accessibles

## 🚀 Déploiement

### Variables d'environnement de production
```bash
NODE_ENV=production
DB_HOST=votre_host_production
DB_PORT=5432
DB_NAME=football_amateur
DB_USER=votre_user
DB_PASSWORD=votre_password
JWT_SECRET=votre_secret_production
CORS_ORIGIN=https://votre-domaine.com
```

### Build de production
```bash
# Backend
cd backend
npm run build

# Frontend
cd frontend
npm run build
```

## 🤝 Contribution

1. Fork le projet
2. Créer une branche feature (`git checkout -b feature/AmazingFeature`)
3. Commit les changements (`git commit -m 'Add some AmazingFeature'`)
4. Push vers la branche (`git push origin feature/AmazingFeature`)
5. Ouvrir une Pull Request

## 📝 Licence

Ce projet est sous licence MIT. Voir le fichier `LICENSE` pour plus de détails.

## 📞 Support

Pour toute question ou problème :
- Ouvrir une issue sur GitHub
- Contacter l'équipe de développement

---

**Développé avec ❤️ pour la communauté football amateur** 