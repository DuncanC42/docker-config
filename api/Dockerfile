FROM --platform=linux/amd64 php:7.2-apache

# S'assurer que nous sommes root
USER root

# IMPORTANT: Debian Buster est archivé, on doit pointer vers archive.debian.org
RUN sed -i 's/deb.debian.org/archive.debian.org/g' /etc/apt/sources.list && \
    sed -i 's|security.debian.org/debian-security|archive.debian.org/debian-security|g' /etc/apt/sources.list && \
    sed -i '/buster-updates/d' /etc/apt/sources.list && \
    echo "Acquire::Check-Valid-Until false;" > /etc/apt/apt.conf.d/99no-check-valid-until

# Combinez toutes les installations de packages dans une seule commande RUN
RUN apt-get update && apt-get install -y --no-install-recommends \
    apt-utils git libicu-dev g++ libpng-dev libxml2-dev libzip-dev libonig-dev libxslt-dev \
    unzip wget apt-transport-https lsb-release ca-certificates libpq-dev netcat-openbsd \
    && docker-php-ext-configure intl \
    && docker-php-ext-install pdo pdo_mysql pdo_pgsql mbstring zip dom gd xsl intl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Configurer Git pour accepter le répertoire (résout le warning git)
RUN git config --global --add safe.directory /var/www/html

# Installation de Composer
RUN curl -sS https://getcomposer.org/installer | php -- \
    && mv composer.phar /usr/local/bin/composer

# Installation de Symfony CLI
RUN curl -sS https://get.symfony.com/cli/installer | bash \
    && mv /root/.symfony5/bin/symfony /usr/local/bin

WORKDIR /var/www/html/

# Copier le script d'entrée et le rendre exécutable
COPY api/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Définir le script comme point d'entrée
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]