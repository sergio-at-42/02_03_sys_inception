# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: Serge <serge.beldjaoui@learner.42.tech>    +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2026/07/28 23:57:27 by sbeldjao          #+#    #+#              #
#    Updated: 2026/08/18 13:43:33 by Serge            ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

DATA_DIR = /home/sbeldjao/data
DATA_DIR_DB = /home/sbeldjao/data/db_data
DATA_DIR_WP = /home/sbeldjao/data/wp_data

all : 
	mkdir --parents $(DATA_DIR_DB)
	mkdir --parents $(DATA_DIR_WP)
	sudo docker compose -f ./srcs/docker-compose.yml up

down :
	sudo docker compose -f srcs/docker-compose.yml down

clean : 
	sudo docker ps -qa | xargs --no-run-if-empty sudo docker stop
	sudo docker ps -qa | xargs --no-run-if-empty sudo docker rm -f
	sudo docker images -qa | xargs --no-run-if-empty sudo docker rmi -f
	sudo docker volume ls -q | xargs --no-run-if-empty sudo docker volume rm
	sudo docker network ls -q | xargs --no-run-if-empty sudo docker network rm -f

clean-data :
	sudo rm -rf $(DATA_DIR)

clean-cache :
	sudo docker builder prune -af

fclean : clean-data clean

re : clean all

