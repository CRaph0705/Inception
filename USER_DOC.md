# User Documentation

## Overview

This project deploys a website infrastructure using Docker.

### Mandatory services :
- NGINX (web server with HTTPS)
- WordPress (CMS)
- MariaDB (database)

### Bonus services :
- Redis (cache system for WordPress)
- FTP server (access to WordPress files)
- Adminer (database management interface)
- Static website (additional simple website)
- Fail2ban (securitu service to protect against brute force attacks)

All services run inside Docker containers and are managed with Docker Compose.

## Starting the Project

Before starting, make sure you have added your domain to your /etc/hosts file:
```
127.0.0.1 rcochran.42.fr
```
You can uncomment the check-hosts rule if needed.

To start the infrastructure, run :
```
make
```

It will:
- build the Docker images
- create and start the containers
- create the network and volumes

## Stopping the Project

To stop the running containers, use :
```
    make down
```
---
## Cleaning the Project
To remove containers and volumes, use :
```
    make fclean
```
Warning : this will delete all website and database data.
---
## Accessing the Website

Open a browser and go to:
```
    https://rcochran.42.fr
```
The connection is secured using https, but some browsers like Firefox will warn you, because of the use of an auto-signed certificate.
In this case, you'll have ton confirm before reaching the site.

## Accessing the WordPress Admin Panel

    https://rcochran.42.fr/wp-admin

Login with the administrator credentials defined in the environment variables (stored in the .env file).

## Acessing Additional Services

### Adminer (database management)
Adminer allows you to manage the database through a web interface.
Access it via your browser (http://rcochran.42.fr:8080).

### FTP Server
The FTP server provides direct access to WordPress files.
You can connect using an FTP client (e.g. FileZilla) with the credentials defined in the .env file.

### Static Website
An additional static website is available as a bonus service.
Access it via your browser (https://rcochran.42.fr/portfolio).


## Credentials

Credentials are defined in the .env file.
Make sure that this file is not shared publicly, and that values are properly set before launching the project.



## Checking Services

Check running containers:
```
    docker ps
```
You can see all services (nginx, wordpress, mariadb, and the bonus) listed as "Up".
---
## Checking logs:
If something is not working, you can inspect logs using :
```
    docker compose logs # general
```

Or for a specific service :
```
    docker compose logs <container_name>
```

---
## Data Persistence

Project data is stored using Docker volumes.

Even if containers are stopped or restarted, the following data is preserved:
- Website files
- Database content

To completely reset the data, use :
```
    make fclean
```

## Security
This project includes basic security features :
- HTTPS enforced via NGINX
- Fail2ban to protect against repeated malicious login attempts
