#!/bin/bash

# Démarrage de l'API
echo "Démarrage de l'API..."
docker-compose up -d
if [ $? -eq 0 ]; then
    echo "API démarrée avec succès."
else
    echo "Erreur lors du démarrage de l'API."
fi