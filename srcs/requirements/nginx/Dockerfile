FROM debian:bookworm

RUN apt update && apt full-upgrade -y

RUN apt install -y nginx

COPY ./site-inception /etc/nginx/sites-available/site-inception

RUN ln -s /etc/nginx/sites-available/site-inception /etc/nginx/site-enabled/site-inception

RUN rm /etc/nginx/sites-available/site-enabled/default

EXPOSE 8000

CMD ["nginx", "-g", "daemon off;"]
