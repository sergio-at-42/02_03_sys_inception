FROM debian:bookworm

RUN apt update && apt full-upgrade -y

RUN apt install -y nginx

EXPOSE 8000

CMD ["nginx", "-g", "daemon off;"]
