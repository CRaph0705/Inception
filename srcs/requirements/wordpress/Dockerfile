# ==========================
# Dockerfile WordPress
# ==========================
FROM debian:bookworm

# Installer les dépendances nécessaires
RUN apt-get update && apt-get install -y \
    wget \
    php8.2 \
    php8.2-fpm \
    php8.2-mysql \
    mariadb-client \
    unzip \
    curl \
    less \
    sudo \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Créer le répertoire pour WordPress
RUN mkdir -p /var/www/html

# Télécharger et extraire WordPress directement dans /var/www/html
RUN wget https://fr.wordpress.org/wordpress-6.0-fr_FR.tar.gz -O /tmp/wordpress.tar.gz \
    && tar -xzf /tmp/wordpress.tar.gz -C /tmp \
    && mv /tmp/wordpress/* /var/www/html/ \
    && rm -rf /tmp/wordpress /tmp/wordpress.tar.gz

# Donner les droits à www-data
RUN chown -R www-data:www-data /var/www/html

# Installer WP-CLI
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

# Configurer PHP-FPM pour écouter sur 0.0.0.0:9000
RUN sed -i 's|^listen = .*|listen = 0.0.0.0:9000|' /etc/php/*/fpm/pool.d/www.conf

# Copier le script d'initialisation et rendre exécutable
COPY tools/init.sh /init.sh
RUN chmod +x /init.sh

# Exposer le port PHP-FPM
EXPOSE 9000

# Lancer le script d'init en tant qu'entrypoint
ENTRYPOINT ["/init.sh"]