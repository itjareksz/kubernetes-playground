#!/bin/bash

set -eu -o pipefail
# Uncomment for debug
# set -x

# ================================================================
# Functions to install Docker repository for various distributions
# ================================================================
install_docker_repo_debian() {
  # Docker install instruction from: https://docs.docker.com/engine/install/debian/

  # Add Docker's official GPG key:
  sudo apt update
  sudo apt install ca-certificates curl
  sudo install -m 0755 -d /etc/apt/keyrings
  sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
  sudo chmod a+r /etc/apt/keyrings/docker.asc

  # Add the repository to Apt sources:
  sudo tee /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/debian
Suites: $(. /etc/os-release && echo "$VERSION_CODENAME")
Components: stable
Architectures: $(dpkg --print-architecture)
Signed-By: /etc/apt/keyrings/docker.asc
EOF
}

install_docker_repo_ubuntu() {
  # Docker install instruction from: https://docs.docker.com/engine/install/ubuntu/

  # Add Docker's official GPG key:
  sudo apt update
  sudo apt install ca-certificates curl
  sudo install -m 0755 -d /etc/apt/keyrings
  sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
  sudo chmod a+r /etc/apt/keyrings/docker.asc

  # Add the repository to Apt sources:
  sudo tee /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")
Components: stable
Architectures: $(dpkg --print-architecture)
Signed-By: /etc/apt/keyrings/docker.asc
EOF
}

install_docker_repo_fedora() {
  # Docker install instruction from: https://docs.docker.com/engine/install/fedora/
  sudo dnf config-manager addrepo --from-repofile https://download.docker.com/linux/fedora/docker-ce.repo
}

install_docker_repo_almalinux() {
  # Docker on AlmaLinux should be installed like on CentOS.
  # Docker install instruction from: https://docs.docker.com/engine/install/centos/
  sudo dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
}

# ================================================================
# Detect Linux distribution, install Docker repository,
# and choose package manager
# ================================================================
if [ -f /etc/os-release ]; then
  distro=$(grep '\bID\b' /etc/os-release | cut -d'=' -f2 | tr -d '"')
  echo "Linux distribution is: ${distro}."
else
  echo "Cannot determine OS distribution."
  exit 1
fi

case ${distro} in
  debian)
    install_docker_repo_debian
    package_manager="apt"
    ;;
  ubuntu)
    install_docker_repo_ubuntu
    package_manager="apt"
    ;;
  fedora)
    install_docker_repo_fedora
    package_manager="dnf"
    ;;
  almalinux)
    install_docker_repo_almalinux
    package_manager="dnf"
    ;;
  *)
    echo "Unsupported distribution: ${distro}"
    exit 1
    ;;
esac

# ================================================================
# Install Docker
# ================================================================
sudo ${package_manager} update
sudo ${package_manager} install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

sudo systemctl enable --now docker

# ================================================================
# Add user to docker group
# ================================================================
echo
echo "Adding user to 'docker' group..."
docker_group="docker"
sudo usermod -aG ${docker_group} "$USER"
echo "User '$USER' was added to group '${docker_group}'."
echo "Login again to user account to reload user's groups."
