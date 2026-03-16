# Developer Documentation

## Prerequisites

Required tools:

- Docker
- Docker Compose
- Make

Check installation:

    docker --version
    docker compose version

## Project Structure

Example structure:

    .
    ├── Makefile
    ├── docker-compose.yml
    ├── srcs/
    │   ├── requirements/
    │   │   ├── nginx/
    │   │   ├── wordpress/
    │   │   └── mariadb/
    │   └── .env

Each service contains:
- a Dockerfile
- configuration files
- startup scripts

## Building the Project

Build images and start containers:

    make

This command runs:

    docker compose up --build

## Managing Containers

List containers:

    docker ps

Stop containers:

    docker compose down

Restart containers:

    docker compose restart

## Managing Volumes

List volumes:

    docker volume ls

Remove volumes:

    docker volume rm <volume_name>

## Data Persistence

Data is stored in Docker volumes:

- MariaDB database files
- WordPress website files

Volumes ensure that data remains even if containers are removed.

Without volumes, all data would be lost when containers are deleted.