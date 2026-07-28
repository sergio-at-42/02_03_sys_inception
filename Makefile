# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: sbeldjao <serge.beldjaoui@learner.42.te    +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2026/07/28 23:57:27 by sbeldjao          #+#    #+#              #
#    Updated: 2026/07/29 00:15:57 by sbeldjao         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

DATA_DIR = /home/sbeldjao/data



all : 
	mkdir -p $(DATA_DIR)/wp_data
	mkdir -p $(DATA_DIR)/db_data
	docker compose -f ./srcs/docker-compose.yml

clean : 
	docker stop $(docker ps -qa)
	docker rm $(docker ps -qa)
	docker rmi -f $(docker images -qa)
	docker volume rm $(docker volume ls -q)
	docker network rm $(docker network ls -q) 2>/dev/null

fclean : clean
	rm -rf $(DATA_DIR)

re : fclean all
