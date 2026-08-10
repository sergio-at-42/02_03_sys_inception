#!/bin/bash

echo ">>>>>>>>     Start of Initialisation Wordpress Database script    <<<<<<<<"

# Starting MariaDB temporarily
mariadbd -u mysql &

#Wait 5 secondes for MariaDB starting
until mariadb-admin ping --silent; do
    sleep 1
done

# Create Wordpress database
mariadb -u root -p "42" <<EOF
CREATE DATABASE IF NOT EXISTS wp_db_inception;
EOF
# Create Wordpress admin user
mariadb -u root -p "42" <<EOF
CREATE USER IF NOT EXISTS "toto"@"%" IDENTIFIED BY "wp-admin-pass";
GRANT ALL PRIVILEGES ON wp_db_inception.* TO "toto"@"%";
EOF
# Create Wordpress user
mariadb -u root -p "42" <<EOF
CREATE USER IF NOT EXISTS "wp_user"@"%" IDENTIFIED BY "wp-pass";
GRANT ALL PRIVILEGES ON wp_db_inception.* TO "wp_user"@"%";
EOF

# Stopping temporary MariaDB
mariadb-admin -u mysql shutdown

echo ">>>>>>>>    End of script    <<<<<<<<"

echo ">>>>>>>>    Start of MariaDB Server    <<<<<<<<"

exec mariadbd -u mysql