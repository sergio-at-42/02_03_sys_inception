FROM debian:bookworm

RUN apt update && apt full-upgrade -y

RUN apt install -y php-fpm php-mysql php-cli

EXPOSE 9000

CMD ["php-fpm", "-F"]
