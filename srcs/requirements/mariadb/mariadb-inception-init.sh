#!/bin/bash

echo ">>>>>>>>     Start of Initialisation Wordpress Database script    <<<<<<<<"

# Start MariaDB temporarily
mariadbd -u mysql
echo "wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww"
#Wait 5 secondes for MariaDB starting
until mariadb-admin ping --silent; do
    sleep 1
done

# Create Wordpress database
mariadb -u mysql <<EOF
CREATE DATABASE wp_db_inception;
EOF
# Create Wordpress admin user
mariadb -u mysql <<EOF
CREATE USER "toto"@"%" IDENTIFIED BY "wp-admin-pass";
GRANT ALL PRIVILEGES ON wp_db_inception.* TO "toto"@"%";
EOF
# Create Wordpress user
mariadb -u mysql <<EOF
CREATE USER "wp_user"@"%" IDENTIFIED BY "wp-pass";
GRANT ALL PRIVILEGES ON wp_db_inception.* TO "wp_user"@"%";
EOF

echo ">>>>>>>>    End of script    <<<<<<<<"

echo ">>>>>>>>    Start of MariaDB Server    <<<<<<<<"

exec mariadbd -u mysql