#!/bin/bash
set -e

# Se déplacer dans le répertoire du projet
cd /var/www/html/apiCodeine

# Attendre que la base de données soit prête (optionnel, mais recommandé)
if [ -n "$DATABASE_URL" ]; then
    echo "Waiting for database connection..."

    # Extraire les informations de connexion de DATABASE_URL
    DB_HOST=$(echo $DATABASE_URL | awk -F[@/:] '{print $4}')
    DB_PORT=$(echo $DATABASE_URL | awk -F[@/:] '{print $5}')

    # Si l'extraction échoue, utiliser les valeurs par défaut
    DB_HOST=${DB_HOST:-db}
    DB_PORT=${DB_PORT:-5432}

    until nc -z -v -w30 $DB_HOST $DB_PORT; do
        echo "Waiting for database connection..."
        sleep 2
    done

    echo "Database is up and running!"
fi

# Vérifier si composer.json existe et installer les dépendances
if [ -f "composer.json" ]; then
    composer install --no-interaction
fi

# Exécuter les migrations (si nécessaire)
if [ -f "bin/console" ]; then
    php bin/console doctrine:migrations:migrate --no-interaction || true
fi

# Démarrer le serveur Symfony
symfony serve --allow-all-ip

# Exécuter la commande Apache standard (au cas où le serveur Symfony échoue)
exec apache2-foreground