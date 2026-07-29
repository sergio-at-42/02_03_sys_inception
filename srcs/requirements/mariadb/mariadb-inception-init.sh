mariadb -u mysql <<EOF
CREATE DATABASE wp_db_inception";
CREATE USER "wp_user"@"%" IDENTIFIED BY "wp-pass";
GRANT ALL PRIVILEGES ON wp_db_inception.* TO "wp_user"@"%";
FLUSH PRIVILEGES;
EOF

exec mariadbd -u mysql