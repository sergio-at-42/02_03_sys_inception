#!/bin/bash

# Starting MariaDB temporarily
mariadbd -u mysql &

#Wait 5 secondes for MariaDB starting
until mariadb-admin ping --silent; do
    sleep 1
done

# Create Wordpress database
mariadb -u mysql <<EOF
CREATE DATABASE IF NOT EXISTS wp_db_inception;
EOF
# Create Wordpress admin user
mariadb -u mysql <<EOF
CREATE USER IF NOT EXISTS "toto"@"%" IDENTIFIED BY "wp-admin-pass";
GRANT ALL PRIVILEGES ON wp_db_inception.* TO "toto"@"%";
EOF
# Create Wordpress user
mariadb -u mysql <<EOF
CREATE USER IF NOT EXISTS "wp_user"@"%" IDENTIFIED BY "wp-pass";
GRANT ALL PRIVILEGES ON wp_db_inception.* TO "wp_user"@"%";
EOF

# mariadb <<EOF
# ALTER USER 'root'@'localhost' IDENTIFIED BY '42';
# EOF

# Stopping temporary MariaDB
mariadb-admin -u mysql shutdown


exec mariadbd -u mysql