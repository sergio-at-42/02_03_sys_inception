FROM debian:bookworm

RUN apt update && apt full-upgrade -y

RUN apt install -y mariadb-server

EXPOSE 3306

CMD ["mariadbd"]
