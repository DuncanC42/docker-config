FROM --platform=linux/amd64 php:7.2-apache

# Combinez toutes les installations de packages dans une seule commande RUN
RUN apt-get update && apt-get install -y --no-install-recommends \
    apt-utils git libicu-dev g++ libpng-dev libxml2-dev libzip-dev libonig-dev libxslt-dev \
    unzip wget apt-transport-https lsb-release ca-certificates libpq-dev netcat-openbsd \
    && docker-php-ext-configure intl \
    && docker-php-ext-install pdo pdo_mysql pdo_pgsql mbstring zip dom gd xsl intl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Installation de Composer
RUN curl -sS https://getcomposer.org/installer | php -- \
    && mv composer.phar /usr/local/bin/composer

# Installation de Symfony CLI
RUN curl -sS https://get.symfony.com/cli/installer | bash \
    && mv /root/.symfony5/bin/symfony /usr/local/bin

WORKDIR /var/www/html/

# Copier le script d'entrée et le rendre exécutable
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Définir le script comme point d'entrée
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]