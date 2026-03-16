# User Documentation

## Overview

This project deploys a website infrastructure composed of:

- NGINX (web server with HTTPS)
- WordPress (CMS)
- MariaDB (database)

These services run inside Docker containers and are managed with Docker Compose.

## Starting the Project

To start the infrastructure:

    make

This command will:
- build the Docker images
- start the containers
- create the volumes

## Stopping the Project

Stop containers:

    make down

Stop and remove containers and volumes:

    make fclean

## Accessing the Website

Open a browser and go to:

    https://localhost

## Accessing the WordPress Admin Panel

    https://localhost/wp-admin

Login with the administrator credentials defined in the environment variables.

## Credentials

Credentials are defined in:

    .env

This includes:
- database name
- database user
- database password
- WordPress admin user
- WordPress admin password

## Checking Services

Check running containers:

    docker ps

Check logs:

    docker logs <container_name>