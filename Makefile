# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: Serge <serge.beldjaoui@learner.42.tech>    +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2026/07/28 23:57:27 by sbeldjao          #+#    #+#              #
#    Updated: 2026/07/29 17:41:27 by Serge            ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

DATA_DIR = /home/sbeldjao/data



all : 
	mkdir -p $(DATA_DIR)/db_data
	mkdir -p $(DATA_DIR)/wp_data
# 	curl -L https://wordpress.org/latest.tar.gz | tar -xz --strip-components=1 -C $(DATA_DIR)/wp_data
	sudo docker compose -f ./srcs/docker-compose.yml up

clean : 
	sudo docker ps -qa | xargs --no-run-if-empty sudo docker stop
	sudo docker ps -qa | xargs --no-run-if-empty sudo docker rm -f
	sudo docker images -qa | xargs --no-run-if-empty sudo docker rmi -f
	sudo docker volume ls -q | xargs --no-run-if-empty sudo docker volume rm
	sudo docker network ls -q | xargs --no-run-if-empty sudo docker network rm 2>/dev/null

fclean : clean
	rm -rf $(DATA_DIR)

re : fclean all



curl -L https://wordpress.org/latest.tar.gz | tar -xz --strip-components=1 -C $(DATA_DIR)/wp_data