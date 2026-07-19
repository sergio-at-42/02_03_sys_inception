FROM debian:bookworm

RUN apt update && apt full-upgrade -y

RUN apt install -y 

EXPOSE 9000

CMD ["nginx", "-g", "daemon off;"]
