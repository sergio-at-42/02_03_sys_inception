# User documentation

## Understand what services are provided by the stack
Inception provid Nginx acts as the web server, handling HTTPS connections and forwarding PHP requests to PHP-FPM.  
WordPress provides the content management system and runs on top of PHP.  
MariaDB is used as the relational database to store WordPress data, users, settings, and content.
Each service runs in its own Docker container, communicating through a dedicated Docker network.  

## Start and stop the activity
- **make** : Create differents images and start the corresponding containers  
- **make clean** : Stop and delete all the docker containers and images  
- **make clean-data** : Delete all data  
- **make fclean** : *make clean* + *clean-data*  
- **make clean-cache** : Delete the docker's cache  
- **make re** : *make fclean* + *make*  

## Access the website and the administration panel
### Access the website
From the computer or the VM with the containers :  
https://localhost:443  

Outside the computer or the VM with the containers with a NAT 8443=>443 :  
https://localhost:8443  

### Access the administration panel
https://localhost:443/wp-admin/  

## Locate and manage credentials
3 passwords are needed for this application : 

All this 3 passwords must be provid in 3 text files in the */secrets* directory :  
- MariaDB root password ==> db_root_password.txt  
- MariaDB Wordpress user password ==> db_wp_password.txt  
- Wordpress administrator password ==> db_wp_password.txt  

## Check that the services are running correctly

