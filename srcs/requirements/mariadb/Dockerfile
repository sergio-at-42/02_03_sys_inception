FROM debian:bookworm

RUN apt update && apt full-upgrade -y

RUN apt install -y mariadb-server

RUN chown -R mysql:mysql /var/lib/mysql

RUN mkdir /run/mysqld && chown -R mysql:mysql /run/mysqld

# COPY ./mariadb-inception.cnf /etc/mysql/mariadb.conf.d/mariadb-inception.cnf

EXPOSE 3306

USER mysql

CMD ["mariadbd"]
