#!/bin/bash

# Charger les variables d'environnement
set -a
source .env
set +a

# Exécuter le script SQL dans le conteneur de la base de données
docker exec -i ${PROJECT_NAME:-app}_db psql -U $POSTGRES_USER -d $POSTGRES_DB -f /app/insert_base_data.sql
