FROM debian:bookworm

RUN apt update && apt full-upgrade -y

RUN apt install -y php-fpm php-mysql php-cli

COPY ./php-fpm-inception /etc/php/8.2/fpm/pool.d/www.conf

EXPOSE 9000

CMD ["php-fpm8.2", "-F"]
