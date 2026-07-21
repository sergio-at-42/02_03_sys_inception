FROM debian:bookworm

RUN apt update && apt full-upgrade -y

RUN apt install -y mariadb-server

COPY ./mariadb-inception.cnf /etc/mysql/mariadb.conf.d/mariadb-inception.cnf

EXPOSE 3306

USER mysql

CMD ["mariadbd"]
