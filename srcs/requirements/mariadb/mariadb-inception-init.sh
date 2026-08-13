#!/bin/bash

# MariaDB password
DB_ROOT_PASSWORD=$(cat /run/secrets/db_root_password)
DB_WP_PASSWORD=$(cat /run/secrets/db_wp_password)

# Starting MariaDB temporarily
mariadbd -u mysql &

#Wait 5 secondes for MariaDB starting
until mariadb-admin ping --silent; do
    sleep 1
done

# Create Wordpress database
mariadb -u mysql <<EOF
CREATE DATABASE IF NOT EXISTS $DP_WP_NAME;
EOF

mariadb -u mysql <<EOF
ALTER USER 'root'@'localhost' IDENTIFIED BY '$DB_ROOT_PASSWORD';
EOF

# # Create Wordpress admin user
# mariadb -u mysql <<EOF
# CREATE USER IF NOT EXISTS "toto"@"%" IDENTIFIED BY "$DB_ROOT_PASSWORD";
# GRANT ALL PRIVILEGES ON wp_db_inception.* TO "toto"@"%";
# EOF

# Create Wordpress user
mariadb -u mysql <<EOF
CREATE USER IF NOT EXISTS "$DB_WP_USER"@"%" IDENTIFIED BY "$DB_WP_PASSWORD";
GRANT ALL PRIVILEGES ON wp_db_inception.* TO "$DB_WP_USER"@"%";
EOF

# Remove_test_database
mariadb -u mysql <<EOF
DROP DATABASE IF EXISTS test;
DELETE FROM mysql.db WHERE Db="test" OR Db="test\\_%";
FLUSH PRIVILEGES;
EOF

# Stopping temporary MariaDB
mariadb-admin -u mysql shutdown


exec mariadbd -u mysql