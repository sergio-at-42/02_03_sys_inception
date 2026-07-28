# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: sbeldjao <serge.beldjaoui@learner.42.te    +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2026/07/28 23:57:27 by sbeldjao          #+#    #+#              #
#    Updated: 2026/07/29 00:53:12 by sbeldjao         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

DATA_DIR = /home/sbeldjao/data



all : 
	mkdir -p $(DATA_DIR)/wp_data
	mkdir -p $(DATA_DIR)/db_data
	sudo docker compose -f ./srcs/docker-compose.yml up

clean : 
	sudo docker ps -qa | xargs --no-run-if-empty sudo docker stop
	sudo docker ps -qa | xargs --no-run-if-empty sudo docker rm -f
	sudo docker images -qa | xargs --no-run-if-empty sudo docker rmi -f
	sudo docker volume ls -q | xargs --no-run-if-empty sudo docker volume rm
	sudo docker network ls -q | xargs --no-run-if-empty sudo docker network rm

fclean : clean
	rm -rf $(DATA_DIR)

re : fclean all
