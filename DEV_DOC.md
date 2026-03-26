# Developer Documentation

## Overview


This document provides technical details for developers who want to understand, build, maintain, or extend the project.

The infrastructure is based on Docker and Docker Compose. Each service runs in its own container and is built from a custom Dockerfile, in compliance with the project requirements.
---
## Prerequisites

Required tools:

- Docker
- Docker Compose
- Make
- Git

Check installation:

    docker --version
    docker compose version
A Linux environment (or virtual machine) is recommended, as required by the subject.
---
## Project Structure

    .
    ├── srcs/
    │   ├── requirements/
    │   │   ├── bonus/
    │   │   │   ├── adminer/
    │   │   │   ├── fail2ban/
    │   │   │   ├── ftp/
    │   │   │   ├── redis/
    │   │   │   └── static-site/
    │   │   ├── nginx/
    │   │   ├── wordpress/
    │   │   └── mariadb/
    │   ├── docker-compose.yml
    │   └── .env
    ├── USER_DOC.md
    ├── DEV_DOC.md
    ├── Makefile
    └── README.md

### Services 

Each mandatory service includes :
- a Dockerfile
- configuration files
- startup scripts

Each bonus service contains:
- a dedicated Dockerfile
- additional configuration if required

### Environment Setup
Before launching the project :
Configure the env file :
- Database (mariadb)
- Wordpress
- Domain name
- Redis
- FTP

Configure local DNS resolution in /etc/hosts
```
    127.0.0.1 rcochran.42.fr
```

## Building the Project

Build images and start containers:

    make

This command will
- Create required directories on the host:
    - /home/rcochran/data/mariadb
    - /home/rcochran/data/wordpress
    - /home/rcochran/data/nginx_logs
    - /home/rcochran/data/ftp_logs
- Start all containers in detached mode using Docker Compose

## Other Useful Commands

Build images only :
```
make build
```

Rebuild and restart containers :
```
make rebuild
```

Start existing containers :
```
make start
```

Stop running containers :
```
make stop
```

Stop and remove containers :
```
make down
```
## Cleaning

Remove containers, networks, and volumes :
```
make clean
```

Full cleanup (including Docker images) :
```
make fclean
```

## Docker Services
### Mandatory services
- NGINX
Reverse proxy and HTTPS entrypoint (TLSv1.2 / TLSv1.3 only)
- WordPress (PHP-FPM)
Application service without web server
- MariaDB
Database service

### Bonus services
- Redis
Improves performance by caching WordPress data
- FTP Server
Provides access to WordPress files
- Adminer
Web interface for database management
- Static Website
Additional lightweight web service
- Fail2ban
Monitors logs and blocks suspicious IPs
---
## Networking

A dedicated Docker network is defined in docker-compose.yml.

It allows:

- Communication between containers via service names
- Isolation from the host system

Using host networking is avoided to comply with project constraints.
---
## Volumes and Data Persistence

Docker named volumes are used for persistent storage:

- WordPress data
- MariaDB data

Volumes are stored on the host at:

/home/rcochran/data

This ensures data persistence across container restarts or recreation.
--- 

## Managing Containers

List running containers:
```
docker ps
```

List all containers:
```
docker ps -a
```

Restart containers:
```
docker compose restart
```
---
## Managing Volumes

List volumes:
```
docker volume ls
```

Inspect a volume:
```
docker volume inspect <volume_name>
```

Remove a volume:
```
docker volume rm <volume_name>
```
---
## Logs and Debugging

View all logs:
```
docker compose logs
```

View logs for a specific service:
```
docker compose logs <service name>
```

Common debugging steps:

- Check container status
- Inspect logs
- Verify environment variables
- Check volume mounts
- Rebuilding the project

If you modify Dockerfiles or configurations:
```
make fclean
make
```

This ensures a clean rebuild of all images and containers.
---
## Security Considerations
- No credentials are stored in Dockerfiles
- Sensitive data is managed through environment variables
- HTTPS is enforced via NGINX
- Fail2ban provides protection against brute-force attacks
---
## Notes
- Each container runs a single main process (no infinite loops or hacks)
-  Images are built from Debian (as required)
- No pre-built service images are used (except base images)
- Only port 443 is exposed to the outside