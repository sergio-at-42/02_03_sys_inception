FROM debian:bookworm

RUN apt update && apt full-upgrade -y

RUN apt install -y curl

RUN apt install -y php-fpm php-mysql php-cli

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar

COPY ./php-fpm-inception.conf /etc/php/8.2/fpm/pool.d/www.conf

# COPY ./wp-config.php /

COPY ./shapely.1.2.21.zip /

COPY ./wp-php-inception-init.sh /

EXPOSE 9000

ENTRYPOINT ["bash", "/wp-php-inception-init.sh"]

