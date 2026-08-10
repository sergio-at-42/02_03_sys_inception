#!/bin/bash

# Download and unzip Wordpress
curl -L https://wordpress.org/latest.tar.gz | tar -xz --strip-components=1 -C /data

# Move Wordpress configuration file
mv /wp-config.php /data/

exec php-fpm8.2 -F