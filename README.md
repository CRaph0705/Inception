*This project has been created as part of the 42 curriculum by rcochran*

# Inception

## Description

Inception is a system administration project focused on containerization using Docker.

The goal is to build a small, secure qnd modular web infrastructure composed of multiple services running in
isolated Docker containers.
Each service is built from a custom Docker image and communiccates through a dedicated Docker network.

The infrastructure includes:
- NGINX with TLS (https only)
- WordPress with PHP-FPM
- MariaDB

Peristent data is handled using Docker volumes.
---

## Architecture

The infrastructure is orchestrated using Docker Compose and follows a service-oriented architecture.

### Services:

- **NGINX**  
  Acts as the only entry point of the infrastructure. It handles HTTPS connections using TLSv1.2 or TLSv1.3 and forwards requests to WordPress.

- **WordPress (PHP-FPM)**  
  Runs the application logic without a web server.

- **MariaDB**  
  Stores the WordPress database.


### Data Persistence
Two Docker named volumes are used:
- WordPress website files
- Database data

These volumes ensure that data persists even if containers are stopped or removed.

### Networking

All containers communicate through a dedicated Docker network, ensuring isolation and secure internal communication.
---

## Project Design

### Why Docker ?
Docker allows :
- Isolation of services
- Reproductible environments
- Lightweight deployment compared to virtual machines

###Design choices
- Separation of concerns: one service per container
- Custom Docker images for full control
- HTTPS enforces via NGINX
- No direct external access except through port 443

## Instructions

### Prerequisites

- git
- Docker
- Docker Compose
- Make

### Installation

Setup
Clone the repository :

```bash
git clone git@github.com:CRaph0705/Inception.git inception
cd inception
```

Configure domain
Add the following line to your etc/hosts file :

```bash
127.0.0.1 rcochran.42.fr
```

Launch the project :
```bash
make
```

Stop the project :
```bash
make down
```

Remove containers and volumes :
```bash
make fclean
```
---
## Usage
Access the website:
```
https://rcochran.42.fr
```

Access WordPress admin panel:
```
https://rcochran.42.fr/wp-admin
```
---
## Docker Concepts Used

### Virtual Machines vs Docker

Virtual machines emulate an entire operating system and require a hypervisor.
Docker containers share the host OS kernel and isolate applications in lightweight environments.

### Secrets vs Environment Variables

Environment variables are simple to use but can expose sensitive information.
Docker secrets allow storing sensitive data securely and prevent them from being visible in container configurations.

### Docker Network vs Host Network

Docker networks isolate containers and allow them to communicate using internal DNS (internal communication).
Host networking removes isolation and exposes services directly on the host network.
Docker networks improve security and modularity.

### Docker Volumes vs Bind Mounts

Volumes are managed by Docker and designed for persistent data storage.
Bind mounts map a host directory to a container directory, qnd depend on the host filesystem.

Volumes are preferred because they:
- are easier to manage
- improve portability
- reduce host dependency
They are more portable and reliable.

## Resources

Official documentation:
- https://docs.docker.com/
- https://nginx.org/en/docs/
- https://wordpress.org/documentation/
- https://mariadb.org/documentation/
- https://stackoverflow.com/
- *[Markdown Guide](https://www.markdownguide.org)*
- https://www.adminer.org/
- https://doc.ubuntu-fr.org/fail2ban
- https://doc.ubuntu-fr.org/vsftpd
- https://redis.io/docs/latest/
- https://dev.mysql.com/doc/
- https://sql.sh/




### AI Usage
ChatGPT has been used to:
- Understanding Docker best practices
- Structuring the project documentation
- Reviewing technical explanations
- Identifying potential issues before evaluation
- Simulating evaluation scenarios and defense questions to validate my understanding of the project requirements

---
