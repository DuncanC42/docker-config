FROM node:23-alpine

WORKDIR /app

# Utiliser une image Alpine pour réduire la taille
# Les dépendances seront installées via le volume monté

# Exposer le port
EXPOSE 8081

# L'application sera lancée via la commande dans docker-compose.yml
CMD ["npm", "run", "dev", "--", "--host", "0.0.0.0"]