-- Création des tables pour les badges et récompenses

-- Table PlayerBadge
CREATE TABLE IF NOT EXISTS PlayerBadges (
  id INTEGER PRIMARY KEY AUTO_INCREMENT,
  playerId INTEGER NOT NULL,
  name VARCHAR(255) NOT NULL,
  type ENUM('tournament', 'training', 'match', 'achievement', 'participation', 'excellence') NOT NULL DEFAULT 'achievement',
  rarity ENUM('common', 'uncommon', 'rare', 'epic', 'legendary') NOT NULL DEFAULT 'common',
  description TEXT,
  count INTEGER DEFAULT 1,
  source ENUM('coach', 'admin', 'tournament', 'system') NOT NULL DEFAULT 'coach',
  icon VARCHAR(100),
  awardedById INTEGER,
  tournamentId INTEGER,
  createdAt DATETIME DEFAULT CURRENT_TIMESTAMP,
  updatedAt DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (playerId) REFERENCES Players(id),
  FOREIGN KEY (awardedById) REFERENCES Players(id),
  FOREIGN KEY (tournamentId) REFERENCES Tournaments(id)
);

-- Table PlayerReward
CREATE TABLE IF NOT EXISTS PlayerRewards (
  id INTEGER PRIMARY KEY AUTO_INCREMENT,
  playerId INTEGER NOT NULL,
  name VARCHAR(255) NOT NULL,
  description TEXT,
  type ENUM('tournament', 'training', 'special', 'milestone') NOT NULL DEFAULT 'special',
  category ENUM('tournament', 'training', 'special', 'milestone') NOT NULL DEFAULT 'special',
  value INTEGER DEFAULT 0,
  icon VARCHAR(100),
  awardedById INTEGER,
  tournamentId INTEGER,
  createdAt DATETIME DEFAULT CURRENT_TIMESTAMP,
  updatedAt DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (playerId) REFERENCES Players(id),
  FOREIGN KEY (awardedById) REFERENCES Players(id),
  FOREIGN KEY (tournamentId) REFERENCES Tournaments(id)
);

-- Insertion de badges d'exemple
INSERT INTO PlayerBadges (playerId, name, type, rarity, description, source, icon) VALUES
(1, 'Premier But', 'match', 'common', 'Marqué votre premier but en match', 'system', 'sports_soccer'),
(1, 'Joueur Assidu', 'training', 'uncommon', 'Participé à 10 entraînements', 'coach', 'fitness_center'),
(1, 'Vainqueur de Tournoi', 'tournament', 'rare', 'Gagné votre premier tournoi', 'tournament', 'emoji_events'),
(1, 'Meilleur Buteur', 'achievement', 'epic', 'Terminé la saison avec le plus de buts', 'admin', 'military_tech'),
(1, 'Légende du Club', 'excellence', 'legendary', 'Membre du club depuis plus de 2 ans', 'admin', 'workspace_premium');

-- Insertion de récompenses d'exemple
INSERT INTO PlayerRewards (playerId, name, description, type, category, value, icon) VALUES
(1, 'Bonus de Performance', 'Excellent performance dans les 5 derniers matchs', 'special', 'special', 100, 'card_giftcard'),
(1, 'Récompense d''Entraînement', 'Complété tous les entraînements du mois', 'training', 'training', 50, 'fitness_center'),
(1, 'Milestone 10 Matchs', 'Joué 10 matchs officiels', 'milestone', 'milestone', 75, 'flag'),
(1, 'Tournoi Participé', 'Participation active au tournoi mensuel', 'tournament', 'tournament', 150, 'emoji_events');
