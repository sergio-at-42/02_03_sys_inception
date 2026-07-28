FROM debian:bookworm

RUN apt update && apt full-upgrade -y

RUN apt install -y nginx openssl

RUN mkdir -p /etc/nginx/ssl && \
    openssl req \
        -x509 \
        -nodes \
        -days 365 \
        -newkey rsa:2048 \
        -keyout /etc/nginx/ssl/inception.key \
        -out /etc/nginx/ssl/inception.crt \
        -subj "/C=FR/ST=Bouches-du-Rhone/L=Marseille/O=42/OU=Inception/CN=sbeldjao.42.fr" 

COPY ./site-inception /etc/nginx/sites-available/site-inception

RUN ln -s /etc/nginx/sites-available/site-inception /etc/nginx/sites-enabled/site-inception

RUN rm /etc/nginx/sites-enabled/default

EXPOSE 443

ENTRYPOINT ["nginx", "-g", "daemon off;"]
