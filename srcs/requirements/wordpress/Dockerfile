FROM debian:bookworm

RUN apt update && apt full-upgrade -y

RUN apt install -y php-fpm php-mysql php-cli

COPY ./php-fpm-inception /etc/php/8.2/fpm/pool.d/www.conf

ADD --unpack=true https://wordpress.org/latest.tar.gz /temp

RUN cp -R /temp/wordpress/* /data

EXPOSE 9000

VOLUME /data
CMD ["php-fpm8.2", "-F"]
