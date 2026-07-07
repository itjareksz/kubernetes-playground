# Application and database secured with NetworkPolicy

## Architecture

- Database: MariaDB
- Application: Bookstack (Docker image) https://github.com/linuxserver/docker-bookstack

## Description

Bookstack application uses MariaDB database to store data. To make this connection private Kubernetes NetworkPolicy is used. External access is allowed only to Bookstack application.

**Kubernetes NetworkPolicy** is a resource that defines how Pods can communicate with each other and with external traffic.

## Usage

1. Create mariadb and bookstack deployments.
2. Add IP address and domain of Kubernetes Service/Ingress to your computer's `/etc/hosts` file. Find IP address using: `kubectl get service -owide`:

   ```
   # Example of line to add in /etc/hosts

   (...)
   172.18.255.201 bookstack.hands-on.k8s
   ```

3. Connect to Bookstack application using address: http://bookstack.hands-on.k8s:6875

4. Create ubuntu Pod to verify NetworkPolicy. This Pod will be allowed to communicate with mariadb. Use command such as `ping` or `curl` inside ubuntu container to perform the checks.
