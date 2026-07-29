FROM debian:bookworm

RUN apt update && apt full-upgrade -y

RUN apt install -y mariadb-server

RUN chown -R mysql:mysql /var/lib/mysql

RUN mkdir -p /run/mysqld && chown -R mysql:mysql /run/mysqld

# COPY ./mariadb-inception.cnf /etc/mysql/mariadb.conf.d/mariadb-inception.cnf

COPY ./mariadb-inception-init.sh /

EXPOSE 3306

USER mysql

# RUN mariadb <<EOF
# CREATE DATABASE wp-db-inception;
# CREATE USER "wp-user"@"42-mariadb" IDENTIFIED BY "wp-pass";
# GRANT ALL PRIVILEGES ON databasename.* TO "wp-user"@"42-mariadb";
# FLUSH PRIVILEGES;
# EXIT
# EOF

# RUN mariadb <<EOF
# ALTER USER 'root'@'localhost' IDENTIFIED BY '42';
# EOF

ENTRYPOINT ["bash", "/mariadb-inception-init.sh"]
