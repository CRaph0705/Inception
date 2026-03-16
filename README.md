*This project has been created as part of the 42 curriculum by rcochran*

# Inception

## Description

Inception is a system administration project focused on containerization using Docker.

The goal is to build a small infrastructure composed of multiple services running in
separate Docker containers. These services communicate through a Docker network
and persist data using Docker volumes.

The stack includes:
- NGINX with TLS
- WordPress with PHP-FPM
- MariaDB

Each service is built from a custom Docker image using a Dockerfile.

## Architecture

The infrastructure is composed of several containers orchestrated using Docker Compose.

Services:
- **NGINX** – reverse proxy serving the website over HTTPS
- **WordPress** – PHP application running the CMS
- **MariaDB** – database used by WordPress

Volumes are used to persist :
- WordPress website data
- Database files

Containers communicate through a Docker network.

## Instructions

### Prerequisites

- git
- Docker
- Docker Compose
- Make

### Installation

Clone the repository :

```bash
git clone <repo> inception
cd inception
```

Build qnd start the infrastructure :
```bash
make
```

Stop the infrastructure :
```bash
make down
```

Remove containers and volumes :
```bash
make fclean
```
## Docker Concepts Used
### Virtual Machines vs Docker
Virtual machines emulate an entire operating system and require a hypervisor.
Docker containers share the host OS kernel and isolate applications in lightweight environments.

Advantages of Docker:
- Faster startup
- Lower resource usage
- Easier deployment

### Secrets vs Environment Variables

Environment variables are simple to use but can expose sensitive information.

Docker secrets allow storing sensitive data securely and prevent them from being visible in container configurations.

### Docker Network vs Host Network

Docker networks isolate containers and allow them to communicate using internal DNS.

Host networking removes isolation and exposes services directly on the host network.

Docker networks improve security and modularity.

### Docker Volumes vs Bind Mounts

Volumes are managed by Docker and designed for persistent data storage.

Bind mounts map a host directory to a container directory.

Volumes are preferred because they:
- are easier to manage
- improve portability
- reduce host dependency

## Resources

Official documentation:
- Docker documentation
- NGINX documentation
- WordPress documentation
- MariaDB documentation
- stackoverflow


### AI Usage
AI tools were used to:
- clarify Docker concepts
- help structure documentation
- review explanations and technical descriptions

*[Markdown Guide](https://www.markdownguide.org)*.
---

## Additional content
Additional sections may be required depending on the project (e.g., usage
examples, feature list, technical choices, etc.).
Any required additions will be explicitly listed below.

TODO: voir pour la partie bonus, adminer, php interdit donc doc offi pour 
---

