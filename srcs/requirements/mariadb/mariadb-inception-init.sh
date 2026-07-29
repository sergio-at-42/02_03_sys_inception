mariadb <<EOF
CREATE DATABASE "wp-db-inception";
CREATE USER "wp-user"@"42-mariadb" IDENTIFIED BY "wp-pass";
GRANT ALL PRIVILEGES ON wp-db-inception.* TO "wp-user"@"42-mariadb";
FLUSH PRIVILEGES;
EXIT
EOF

exec mariadbd -u mysql