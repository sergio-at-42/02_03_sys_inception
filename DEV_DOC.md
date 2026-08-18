# Developer documentation

## Set up the environment from scratch

### Prerequisites

The Inception project requires a Linux environment with the following tools installed:

* Docker Engine
* Docker Compose
* GNU Make
* Git
* A text editor

On Debian-based systems, Docker and Git can be installed with:

```bash
sudo apt update
sudo apt install git make nano
sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

Check that the required tools are available:

```bash
docker --version
docker compose version
make --version
git --version
```

The current user must also have permission to communicate with the Docker daemon. Depending on the system configuration, Docker commands may need to be executed with `sudo`.

### Clone the repository

Clone the project repository and move into its root directory:

```bash
git clone <repository-url> inception
cd inception
```

The project is expected to contain this structure :

```text
inception/
├── Makefile
├── srcs/
│   ├── docker-compose.yml
│   ├── .env
│   └── requirements/
│       ├── nginx/
│       ├── wordpress/
│       └── mariadb/
└── secrets/
```

### Configuration files

The main Docker Compose configuration is located in:

```text
srcs/docker-compose.yml
```

It defines the services, networks, volumes, images, build contexts, and other Docker configuration required by the project.

Environment-specific configuration is stored in:

```text
srcs/.env
```
Rename .env.example to .env, and with a text editor (like nano) complete the differents environment variables.
Typical values include:

```env
# MariaDB
DB_WP_HOST = MariaDB server url or host address for Wordpress
DP_WP_NAME = Database name for Wordpress
DB_WP_USER = MariaDB user for Wordpress

# Wordpress
WP_ADMIN = Admin Wordpress
```

The `.env` file must not contain credentials that are committed to the repository. It should be excluded through `.gitignore` when it contains sensitive information.

### Secrets

Sensitive credentials should preferably be handled separately from general configuration.

Secret files are stored in a dedicated directory :

```text
secrets/
├── db_root_password.txt
├── db_wp_password.txt
└── wp_admin_password.txt
```

These files must not be committed to the repository.

Their permissions should also be restricted:

```bash
chmod 600 secrets/*
```

The application or initialization scripts must explicitly read the secret files when configuring the corresponding services.

## Build and launch the activity

### Using the Makefile

The recommended way to build and start the complete infrastructure is through the project's Makefile:

```bash
make
```

The Makefile typically invokes Docker Compose to build the required images and start the services.

### Using Docker Compose directly

The complete stack can be started with:

```bash
docker compose -f srcs/docker-compose.yml up -d --build
```

The `-d` option starts the containers in detached mode, while `--build` forces Docker to rebuild images when necessary.

Check the resulting containers with:

```bash
docker compose -f srcs/docker-compose.yml ps
```

### Stop the activity

Stop the containers while keeping the Docker resources:

```bash
make down
```

The persistent volumes are preserved.

## Manage containers and volumes

### List containers

List currently running containers:

```bash
docker ps
```

List all containers, including stopped ones:

```bash
docker ps -a
```

Using Docker Compose:

```bash
docker compose -f srcs/docker-compose.yml ps
```

### Start, stop and restart services

Individual services can be managed with Docker Compose:

```bash
docker compose -f srcs/docker-compose.yml start 42-nginx
docker compose -f srcs/docker-compose.yml stop 42-nginx
docker compose -f srcs/docker-compose.yml restart 42-nginx
```

The same commands can be applied to the `42-wordpress` and `42-mariadb` services.

### Inspect container logs

Display the logs of all services:

```bash
docker compose -f srcs/docker-compose.yml logs
```

Display logs for a specific service:

```bash
docker compose -f srcs/docker-compose.yml logs 42-nginx
docker compose -f srcs/docker-compose.yml logs 42-wordpress
docker compose -f srcs/docker-compose.yml logs 42-mariadb
```

Follow logs in real time:

```bash
docker compose -f srcs/docker-compose.yml logs -f
```

### Execute commands inside a container

An interactive shell can be opened inside a running container:

```bash
docker exec -it <container-name> /bin/bash
```

If Bash is not installed:

```bash
docker exec -it <container-name> /bin/sh
```

For example:

```bash
docker exec -it inception-42-mariadb-1 /bin/bash
```

### Inspect containers

Detailed information about a container can be obtained with:

```bash
docker inspect <container-name>
```

This is useful for checking:

* Network configuration
* Environment variables
* Mounted volumes
* Container state
* Port mappings
* Entrypoint and command

### Manage Docker volumes

List Docker volumes:

```bash
docker volume ls
```

Inspect a specific volume:

```bash
docker volume inspect <volume-name>
```

The Compose configuration can also be used to display the volumes associated with the project:

```bash
docker compose -f srcs/docker-compose.yml config
```

To remove unused Docker volumes:

```bash
docker volume prune
```

> **Warning:** Docker volume removal can permanently delete application data. Verify the volume before removing it.

To remove the complete Compose stack including its volumes and data:

```bash
make fclean
```

This should only be used when the persistent data is no longer required.

## Data storage and persistence

The Inception stack uses Docker volumes to keep application data independent from the lifecycle of individual containers.

The main persistent data consists of:

* **MariaDB data**: databases, tables, users, and WordPress data stored by MariaDB.
* **WordPress data**: WordPress core files, themes, plugins, uploads, and configuration files.

The Compose configuration defines two named volumes:

```yaml
volumes:
  wp_data:
  db_data:
```

They are then mounted into the appropriate containers:

```yaml
services:
  mariadb:
    volumes:
      - mariadb_data:/var/lib/mysql

  wordpress:
    volumes:
      - wordpress_data:/data
```

The important distinction is that these are **Docker volumes**, not directories belonging to the container filesystem.

The container filesystem is ephemeral: destroying and recreating a container does not preserve data that was stored only inside the container.

The persistent data is instead stored in the Docker volume:

```text
MariaDB container
      │
      │ /var/lib/mysql
      ▼
mariadb_data volume
      │
      ▼
Docker-managed storage

WordPress container
      │
      │ /data
      ▼
wordpress_data volume
      │
      ▼
Docker-managed storage
```

Consequently, the following operation preserves the database and WordPress data:

```bash
make re
or
make clean
make
```

Whereas:
```bash
make fclean
```
also removes the Compose-managed volumes and therefore **destroys the persistent application data**.

### Locate the physical storage

Docker manages the physical location of named volumes. Their exact location depends on the Docker installation and storage driver.

The location can be obtained with:

```bash
docker volume inspect <volume-name>
```

For a standard Linux Docker installation, the volume data is commonly stored below:

```text
/var/lib/docker/volumes/
```

However, applications should not rely on this path directly. Docker volumes should be accessed through Docker rather than by manipulating their underlying directories manually.

### Persistence model

The persistence model of the project can therefore be summarized as:

```text
                 Docker Compose
                      │
          ┌───────────┴───────────┐
          │                       │
     WordPress                  MariaDB
     container                  container
          │                       │
          ▼                       ▼
 wordpress_data             mariadb_data
     volume                     volume
          │                       │
          └───────────┬───────────┘
                      │
             Docker-managed
                persistent
                   data
```

As long as these volumes are preserved, the containers can be stopped, recreated, or rebuilt without losing the WordPress website or MariaDB database.
