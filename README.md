*This project has been created as part of the 42 curriculum by sbeldjao*

---

# Inception

## Description

**Inception** is a system administration project from focused on containerization and infrastructure management with Docker.

The goal is to build a small WordPress website using a complete multi-container architecture, where each service runs in its own Docker container. The project consists of three main services: **Nginx**, **WordPress with PHP-FPM**, and **MariaDB**.

Nginx acts as the web server and reverse proxy, handling HTTPS connections and forwarding PHP requests to the WordPress container. WordPress provides the content management system and uses MariaDB as its relational database.

The project aims to develop a practical understanding of Docker, container networking, persistent volumes, service configuration, TLS, and the interaction between different components of a web infrastructure.

### Architecture

```text
                         HTTPS
                           │
                           ▼
                    ┌─────────────┐
                    │    Nginx    │
                    │   :443      │
                    └──────┬──────┘
                           │
                           │ FastCGI
                           ▼
                    ┌─────────────┐
                    │  WordPress  │
                    │  PHP-FPM    │
                    └──────┬──────┘
                           │
                           │ MariaDB protocol
                           ▼
                    ┌─────────────┐
                    │   MariaDB   │
                    │   :3306     │
                    └─────────────┘

             Persistent Docker volumes
                 │              │
                 ▼              ▼
            WordPress         MariaDB
              data             data
```

All services are connected through a dedicated Docker network, while persistent data is stored in Docker volumes so that containers can be recreated without losing the website or database data.

---

## Technical Choices

### Virtual Machines vs Docker

Virtual Machines (VMs) emulate a complete computer system, including a guest operating system and its own kernel. Docker containers, on the other hand, share the host's kernel and isolate applications and their dependencies at the process level.

| Virtual Machines                      | Docker Containers                 |
| ------------------------------------- | --------------------------------- |
| Include a complete guest OS           | Share the host kernel             |
| Higher resource consumption           | Lightweight and fast              |
| Strong hardware and OS isolation      | Process-level isolation           |
| Slower startup time                   | Very fast startup                 |
| Suitable for complete OS environments | Well suited for isolated services |

For this project, **Docker was chosen** because Inception focuses on deploying individual services in isolated containers. Nginx, WordPress/PHP-FPM, and MariaDB can each have their own environment while communicating through a Docker network. This makes the architecture lightweight, reproducible, and easier to manage than using a separate virtual machine for each service.

### Secrets vs Environment Variables

Environment variables are commonly used to provide configuration values to containers. However, they are not designed to securely store sensitive information such as passwords or private keys.

Docker Secrets provide a mechanism specifically designed for handling sensitive data. Secrets can be mounted into a container as files and are not directly exposed as regular environment variables.

| Environment Variables                                 | Docker Secrets                                      |
| ----------------------------------------------------- | --------------------------------------------------- |
| Simple to configure                                   | Designed for sensitive information                  |
| Convenient for general configuration                  | Better suited for passwords and credentials         |
| Values can be visible through container configuration | Mounted as files inside containers                  |
| Widely supported by applications                      | Requires application support for file-based secrets |

For Inception, **environment variables are used for general configuration**, while sensitive credentials can be handled separately when required by the project. This distinction avoids unnecessarily exposing passwords as regular configuration parameters.

### Docker Network vs Host Network

Docker provides isolated network namespaces for containers. A custom Docker network allows containers to communicate with each other using container names while keeping their network environment isolated from the host.

With `host` networking, a container directly uses the host's network stack and does not have its own isolated network namespace.

| Docker Network                                    | Host Network                                   |
| ------------------------------------------------- | ---------------------------------------------- |
| Provides network isolation                        | Shares the host network stack                  |
| Containers communicate through the Docker network | Containers use host interfaces directly        |
| Container names can be used for service discovery | No Docker network isolation                    |
| Better suited to multi-container architectures    | Useful when direct host networking is required |

For Inception, a **dedicated Docker network** is used so that Nginx, WordPress, and MariaDB can communicate internally without exposing every service to the host.

Only the required entry point, **Nginx over HTTPS**, needs to be accessible from outside the Docker network. MariaDB and PHP-FPM therefore remain internal services.

### Docker Volumes vs Bind Mounts

Both Docker volumes and bind mounts allow data to persist beyond the lifetime of a container.

A bind mount maps a specific directory or file from the host filesystem into a container. A Docker volume is managed by Docker and is stored in Docker's own data directory.

| Docker Volumes                              | Bind Mounts                                    |
| ------------------------------------------- | ---------------------------------------------- |
| Managed by Docker                           | Managed directly by the host                   |
| Docker chooses the storage location         | Host path must be specified                    |
| Easier to manage and migrate                | Gives direct access to host files              |
| Well suited for persistent application data | Useful for development and configuration files |
| Less dependent on host filesystem layout    | Tightly coupled to host directory structure    |

For Inception, **Docker volumes are preferred for persistent WordPress and MariaDB data**. This keeps application data independent from the container lifecycle while allowing Docker to manage the underlying storage.

Bind mounts can still be useful when direct access to configuration files from the host is required, but they introduce a stronger dependency on the host's filesystem structure.

---

## Instructions

### Requirements

The project requires:

* Docker
* Docker Compose
* Git
* A Linux environment capable of running Docker

### Configuration

Clone the repository:

```bash
git clone <repository-url>
cd inception
```

Create the environment configuration file if required by the project:

```bash
cp srcs/.env.example srcs/.env
```

Edit the `.env` file and configure the required credentials and domain name.

For example:

```env
DOMAIN_NAME=example.com

MYSQL_DATABASE=wordpress
MYSQL_USER=wp_user
MYSQL_PASSWORD=********
MYSQL_ROOT_PASSWORD=********

WP_ADMIN_USER=admin
WP_ADMIN_PASSWORD=********
WP_ADMIN_EMAIL=admin@example.com
```

Passwords and other sensitive credentials should not be committed to the repository.

### Build and start the project

The complete infrastructure can be built and started with:

```bash
make
```

or, depending on the Makefile configuration:

```bash
docker compose -f srcs/docker-compose.yml up --build
```

The containers can be inspected with:

```bash
docker compose -f srcs/docker-compose.yml ps
```

To view the logs:

```bash
docker compose -f srcs/docker-compose.yml logs
```

### Stop the services

To stop the containers without removing them:

```bash
make down
```

or:

```bash
docker compose -f srcs/docker-compose.yml down
```

### Clean the project

To stop the containers and remove the associated Docker resources:

```bash
make clean
```

For a complete cleanup including persistent volumes, if supported by the project Makefile:

```bash
make fclean
```

**Warning:** removing Docker volumes permanently deletes the stored WordPress and MariaDB data.

### Accessing WordPress

Once the containers are running, the WordPress website can be accessed through the configured domain name using HTTPS:

```text
https://example.com
```

If the domain is only configured locally, an entry may need to be added to `/etc/hosts`:

```text
127.0.0.1 example.com
```

The exact hostname and network configuration depend on the local environment and the project's configuration.

---

## Resources

### Official documentation

* [Docker Documentation](https://docs.docker.com/)
* [Docker Compose Documentation](https://docs.docker.com/compose/)
* [Dockerfile Reference](https://docs.docker.com/reference/dockerfile/)
* [Nginx Documentation](https://nginx.org/en/docs/)
* [PHP Documentation](https://www.php.net/docs.php)
* [PHP-FPM Documentation](https://www.php.net/manual/en/install.fpm.php)
* [WordPress Developer Resources](https://developer.wordpress.org/)
* [MariaDB Documentation](https://mariadb.com/docs/)
* [OpenSSL Documentation](https://docs.openssl.org/)

### Main topics studied

The project required research and practical work on:

* Docker images and containers
* Dockerfiles and Docker Compose
* Container networking
* Docker volumes and persistent data
* Nginx configuration
* HTTPS and TLS certificates
* FastCGI and PHP-FPM
* WordPress installation and configuration
* MariaDB initialization and user management
* Environment variables and secrets
* Shell scripting and container entrypoints
* Service dependencies and startup order

### AI usage

AI tools were used as a technical assistance and learning resource during the project.

They were mainly used to:

* Clarify Docker, Linux, Nginx, PHP-FPM, WordPress, and MariaDB concepts.
* Explain error messages encountered during installation, configuration, and container execution.
* Help identify possible causes of networking, permissions, service startup, and dependency issues.
* Compare different configuration approaches and explain their consequences.
* Assist with debugging shell scripts and Docker configuration.
* Provide explanations and examples of Linux and MariaDB commands.
* Review configuration choices and improve understanding of the project's architecture.

AI was used primarily for **research, troubleshooting, explanations, and guidance**. The final configuration, commands, scripts, and project implementation were reviewed and adapted to the requirements of the Inception subject and the actual project environment.

