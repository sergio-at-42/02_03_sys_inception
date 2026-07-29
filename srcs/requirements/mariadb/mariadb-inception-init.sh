#!/bin/bash

echo ">>>>>>>>     Start of Initialisation Wordpress Database script    <<<<<<<<"

mariadbd -u mysql

mariadb -u mysql <<EOF
CREATE DATABASE wp_db_inception";
CREATE USER "wp_user"@"%" IDENTIFIED BY "wp-pass";
GRANT ALL PRIVILEGES ON wp_db_inception.* TO "wp_user"@"%";
FLUSH PRIVILEGES;
EOF

echo ">>>>>>>>    End of script    <<<<<<<<"

echo ">>>>>>>>    Start od MariaDB Server    <<<<<<<<"

exec mariadbd -u mysql