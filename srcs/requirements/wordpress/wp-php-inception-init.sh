#!/bin/bash

# Download and unzip Wordpress
curl -L https://wordpress.org/latest.tar.gz | tar -xz --strip-components=1 -C /data

# Move Wordpress configuration file
mv /wp-config.php /data/

# Wordpress site installation
php wp-cli.phar core install \
    --allow-root \
    --path="/data" \
    --url="https://sbeldjao.42.fr" \
    --title="Benny Hill Show" \
    --admin_user="toto" \
    --admin_password="42" \
    --admin_email="serge.beldjaoui@learner.42.tech"

php wp-cli.phar option update blog_public 0 \
    --allow-root \
    --path="/data"

# Update privileges for "Wordpress Content"
chown -R www-data:www-data /data/wp-content
chmod -R 755 /data/wp-content

# Install Wordpress theme
mv /shapely.1.2.21.zip /data/wp-content/themes/
php wp-cli.phar theme install shapely \
    --activate \
    --allow-root \
    --path="/data"

exec php-fpm8.2 -F
