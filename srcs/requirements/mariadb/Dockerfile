FROM debian

RUN apt update && apt full-upgrade -y

RUN apt install -y mariadb-server mariadb-client galera-4

EXPOSE 3306

CMD ["bash"]
