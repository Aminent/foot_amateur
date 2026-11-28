# Base de données FootPro

`football_amateur.sql` : export complet de la base PostgreSQL (schéma + données de test).

Contenu : 1 admin, 16 coachs, 288 joueurs, 6 arbitres, 16 équipes, 3 tournois, matchs,
statistiques, entraînements, chat, badges, récompenses et missions d'arbitrage.
Tous les comptes ont le mot de passe `123456` (données de test uniquement).

Comptes principaux :

| Rôle    | Email                   |
|---------|-------------------------|
| Admin   | admin@gmail.com         |
| Coach   | coach@gmail.com         |
| Joueur  | player@gmail.com        |
| Délégué | delegue@gmail.com       |

## Restaurer

Avec le conteneur Docker du projet (`foot-amateur-postgres`, port 5433) :

```powershell
docker run -d --name foot-amateur-postgres -e POSTGRES_PASSWORD=<mot_de_passe> -e POSTGRES_DB=football_amateur -p 5433:5432 -v foot-amateur-pgdata:/var/lib/postgresql/data postgres:16-alpine
Get-Content database\football_amateur.sql | docker exec -i foot-amateur-postgres psql -U postgres -d football_amateur
```

Le fichier commence par des `DROP ... IF EXISTS` : le restaurer **remplace** la base existante.
