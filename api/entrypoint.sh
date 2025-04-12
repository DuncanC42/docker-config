#!/bin/bash
set -e

echo "🚀 Starting API service..."

# Récupérer les informations de connexion à la BDD depuis DATABASE_URL
if [ -n "$DATABASE_URL" ]; then
    echo "🔍 Parsing database connection from DATABASE_URL..."

    # Extraire l'hôte et le port de DATABASE_URL
    DB_HOST=$(echo $DATABASE_URL | sed -E 's/.*@([^:]+):.*/\1/')
    DB_PORT=$(echo $DATABASE_URL | sed -E 's/.*:([0-9]+).*/\1/')

    # Utiliser des valeurs par défaut si l'extraction échoue
    DB_HOST=${DB_HOST:-database}
    DB_PORT=${DB_PORT:-5432}

    echo "📡 Waiting for database at ${DB_HOST}:${DB_PORT}..."

    # Attendre que la base de données soit disponible
    until nc -z -v -w30 $DB_HOST $DB_PORT; do
        echo "⏳ Database not ready yet... waiting 2 seconds..."
        sleep 2
    done

    echo "✅ Database is up and running!"
fi

# Définir le répertoire de travail (désormais à la racine)
if [ -d "/var/www/html/apiCodeine" ]; then
    cd /var/www/html/apiCodeine
    echo "📂 Working in directory: /var/www/html/apiCodeine"
else
    echo "📂 Working in directory: /var/www/html"
fi

# Installer les dépendances Composer si composer.json existe
if [ -f "composer.json" ]; then
    echo "🔧 Installing Composer dependencies..."
    composer install --no-interaction
    echo "✅ Dependencies installed successfully!"
fi

# Exécuter les migrations si bin/console existe
if [ -f "bin/console" ]; then
    echo "🔄 Running database migrations..."
    php bin/console doctrine:migrations:migrate --no-interaction || echo "⚠️ Migration failed (this might be normal on first run)"
    echo "✅ Migrations completed!"

    # Mettre à jour le schéma de la base de données
    echo "🔄 Updating database schema..."
    php bin/console doctrine:schema:update --force || echo "⚠️ Schema update failed"
    echo "✅ Schema update completed!"

    # Charger les fixtures uniquement si SYMFONY_ENV n'est pas 'prod'
    if [ "$SYMFONY_ENV" != "prod" ]; then
        echo "🔄 Loading fixtures data..."
        php bin/console doctrine:fixtures:load --no-interaction || echo "⚠️ Fixtures loading failed"
        echo "✅ Fixtures loaded successfully!"
    fi
fi

# Vider le cache Symfony en environnement de développement
if [ "$SYMFONY_ENV" = "dev" ]; then
    echo "🧹 Clearing Symfony cache..."
    php bin/console cache:clear --no-interaction || echo "⚠️ Cache clear failed"
    echo "✅ Cache cleared!"
fi

# Définir les permissions pour les répertoires var/ et public/
echo "🔒 Setting appropriate permissions..."
mkdir -p var public/uploads
chmod -R 777 var public/uploads || echo "⚠️ Permission setting failed"
echo "✅ Permissions set!"

echo "🚀 Starting Symfony server and websocket..."
symfony serve --allow-all-ip &
php bin/console app:websocket:server


# Démarrer Apache en cas d'échec de Symfony
echo "⚠️ Symfony server failed, falling back to Apache..."
exec apache2-foreground