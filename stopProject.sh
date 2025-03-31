#!/bin/bash

# Arrêt de l'API
echo "Arrêt de l'API..."
docker-compose down
if [ $? -eq 0 ]; then
    echo "API arrêtée avec succès."
else
    echo "Erreur lors de l'arrêt de l'API."
fi
