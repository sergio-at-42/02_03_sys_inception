#!/bin/bash

echo ">>>>>>>>     Start of Initialisation Wordpress Database script    <<<<<<<<"

mariadbd -u mysql

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