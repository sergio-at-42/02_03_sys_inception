#!/bin/bash

# MariaDB for Wordpress
# DB_WP_HOST
# DP_WP_NAME
# DB_WP_USER
DB_WP_PASSWORD="$(cat /run/secrets/db_wp_password)"

# Wordpress admin/password
# WP_ADMIN
WP_ADMIN_PASSWORD="$(cat /run/secrets/wp_admin_password)"

# Download and unzip Wordpress
curl -L https://wordpress.org/latest.tar.gz | tar -xz --strip-components=1 -C /data

# Move Wordpress configuration file
# mv /wp-config.php /data/

php wp-cli.phar config create \
    --dbhost="42-mariadb:3306" \
    --dbname="wp_db_inception" \
    --dbuser="wp_user" \
    --dbpass="$DB_WP_PASSWORD" \
    --allow-root \
    --path="/data"

# php wp-cli.phar config create \
#     --dbhost="$DB_WP_HOST" \
#     --dbname="$DP_WP_NAME" \
#     --dbuser="$DB_WP_USER" \
#     --dbpass="$DB_WP_PASSWORD" \
#     --allow-root \
#     --path="/data"

# Wordpress site installation
php wp-cli.phar core install \
    --url="https://sbeldjao.42.fr" \
    --title="Benny Hill Show" \
    --admin_user="$WP_ADMIN" \
    --admin_password="$WP_ADMIN_PASSWORD" \
    --admin_email="serge.beldjaoui@learner.42.tech" \
    --allow-root \
    --path="/data"

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
