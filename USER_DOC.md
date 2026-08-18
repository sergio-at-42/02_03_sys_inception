# User documentation

## Understand what services are provided by the stack

The Inception stack consists of three main services, each running in its own Docker container:

* **Nginx**: acts as the web server and reverse proxy. It handles incoming HTTPS connections and forwards PHP requests to WordPress.
* **WordPress + PHP-FPM**: provides the content management system used to run the website. PHP-FPM executes the PHP code required by WordPress.
* **MariaDB**: provides the relational database used by WordPress to store posts, users, settings, and other website data.

The services communicate through a dedicated Docker network:

```text
                         HTTPS :443
                             │
                             ▼
                       ┌──────────┐
                       │  Nginx   │
                       └────┬─────┘
                            │
                       FastCGI
                            │
                            ▼
                  ┌──────────────────┐
                  │ WordPress/PHP-FPM│
                  └────────┬─────────┘
                           │
                           │ MariaDB
                           ▼
                     ┌──────────┐
                     │ MariaDB  │
                     └──────────┘
```

Only Nginx is exposed to the outside of the Docker network. WordPress/PHP-FPM and MariaDB are internal services.

## Start and stop the activity

The stack can be started from the root directory of the project using the Makefile:

```bash
make
```

This builds the required Docker images and starts the containers using Docker Compose.

To check the containers after starting the stack:

```bash
docker compose -f srcs/docker-compose.yml ps
```

To stop the stack:

```bash
make down
```
Alternatively:

```bash
docker compose -f srcs/docker-compose.yml down
```
Stopping the containers does not normally delete the persistent Docker volumes containing the WordPress and MariaDB data.

To completely remove the containers, images, networks, and volumes (not the data):

```bash
make clean
```

To completely remove the containers, images, networks, volumes and **persistent data**:

```bash
make fclean
```

> **Warning:** removing the volumes permanently deletes the stored WordPress and MariaDB data.

## Access the website and the administration panel

### Access the website

Once the stack is running, the WordPress website is available through the configured domain name using HTTPS:

```text
https://sbeldjao.42.fr
```

For a local installation, the domain name must resolve to the machine running Docker.

If necessary, add an entry to `/etc/hosts`:

```text
127.0.0.1 sbeldjao.42.fr
```

The browser display a security warning, because the project uses a self-signed TLS certificate. This is expected in a local development environment.

### Access the administration panel

The WordPress administration interface is available at:

```text
https://sbeldjao.42.fr/wp-admin/
```

Log in using the WordPress administrator credentials configured during the installation.

The administration panel allows the user to:

* Create and edit posts and pages.
* Manage media.
* Manage WordPress users.
* Configure the website.
* Install and manage themes and plugins, when permitted.
* Access the WordPress dashboard and site settings.

## Locate and manage credentials

The project uses several different types of credentials. They should not be confused with one another.  

3 passwords are needed for this application : 

All this 3 passwords must be provid in 3 text files in the */secrets* directory :  
- MariaDB root password ==> db_root_password.txt  
- MariaDB Wordpress user password ==> db_wp_password.txt  
- Wordpress administrator password ==> db_wp_password.txt  

### WordPress administrator credentials

The WordPress administrator username, password, and email address are defined during the WordPress installation.

They are used to access:

```text
https://sbeldjao.42.fr/wp-admin/
```

### MariaDB credentials

MariaDB uses separate credentials for the database administrator and the WordPress database user.

Typical variables include:

```env
# MariaDB
DB_WP_HOST = MariaDB server url or host address for Wordpress
DP_WP_NAME = Database name for Wordpress
DB_WP_USER = MariaDB user for Wordpress

# Wordpress
WP_ADMIN = Admin Wordpress
```

The WordPress database user is used by WordPress to connect to MariaDB. The MariaDB root password is intended for database administration and should not be used by WordPress.

### Where credentials are stored

Project-specific configuration values are normally defined through the `.env` file and Docker secrets, depending on the implementation.

```text
srcs/.env
```

The `.env` file must **not be committed to the Git repository** if it contains real passwords or other sensitive information.

Check the project's `.gitignore` configuration to ensure that sensitive files are excluded.

If credentials need to be changed, update the appropriate configuration and recreate the affected services when necessary.
```bash
make re
```

Changing a database password after the database has already been initialized may require additional database administration because changing an environment variable does not necessarily change an already existing MariaDB account.

## Check that the services are running correctly

The first step is to check the status of all containers:

```bash
docker compose -f srcs/docker-compose.yml ps
```

The expected result should show the Nginx, WordPress/PHP-FPM, and MariaDB containers as running.

### Check the logs

To inspect all service logs:

```bash
docker compose -f srcs/docker-compose.yml logs
```

To inspect a specific service:

```bash
docker compose -f srcs/docker-compose.yml logs 42-nginx
docker compose -f srcs/docker-compose.yml logs 42-wordpress
docker compose -f srcs/docker-compose.yml logs 42-mariadb
```

Follow the logs in real time with:

```bash
docker compose -f srcs/docker-compose.yml logs -f
```

### Check the individual containers

The running containers can also be inspected with:

```bash
docker ps
```

The expected architecture should contain one container for each main service:

```text
nginx
wordpress
mariadb
```

### Check the network

The Docker network can be inspected with:

```bash
docker network ls
```

and:

```bash
docker network inspect <network-name>
```

The Nginx, WordPress, and MariaDB containers should be connected to the project's dedicated Docker network.

### Check Nginx and HTTPS

From the host, verify that the HTTPS port is listening:

```bash
ss -lntp | grep :443
```

The website can then be tested with:

```bash
curl -k https://sbeldjao.42.fr
```

The `-k` option allows `curl` to connect when the project uses a self-signed certificate.

A successful response indicates that the request reached Nginx and that Nginx was able to return a response from the WordPress stack.

### Check WordPress and MariaDB connectivity

If the containers are running but the website is unavailable, inspect the WordPress and MariaDB logs first.

For MariaDB:

```bash
docker compose -f srcs/docker-compose.yml logs mariadb
```

For WordPress:

```bash
docker compose -f srcs/docker-compose.yml logs wordpress
```

A common problem is that WordPress starts before MariaDB is ready to accept connections. The container initialization scripts should therefore ensure that MariaDB is ready before WordPress attempts to use the database.

A healthy stack should ultimately provide the following communication path:

```text
Browser
   │
   │ HTTPS
   ▼
Nginx
   │
   │ FastCGI
   ▼
PHP-FPM / WordPress
   │
   │ MySQL/MariaDB
   ▼
MariaDB
```

If each service is running, the Docker network is operational, HTTPS is accessible, and WordPress can communicate with MariaDB, the Inception stack is functioning correctly.
