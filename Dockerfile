FROM jenkins/jenkins:lts
USER root

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Detect and Install Docker Compose
RUN arch=$(uname -m) && \
    case "$arch" in \
      x86_64)  curl -L https://github.com/docker/compose/releases/download/$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep tag_name | cut -d '"' -f4)/docker-compose-Linux-x86_64 -o /usr/local/bin/docker-compose ;; \
      aarch64) curl -L https://github.com/docker/compose/releases/download/$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep tag_name | cut -d '"' -f4)/docker-compose-Linux-aarch64 -o /usr/local/bin/docker-compose ;; \
      armv7l)  curl -L https://github.com/docker/compose/releases/download/$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep tag_name | cut -d '"' -f4)/docker-compose-Linux-armv7l -o /usr/local/bin/docker-compose ;; \
      i686|i386) curl -L https://github.com/docker/compose/releases/download/$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep tag_name | cut -d '"' -f4)/docker-compose-Linux-i386 -o /usr/local/bin/docker-compose ;; \
      *) echo "Unsupported architecture: $arch" && exit 1 ;; \
    esac && \
    chmod +x /usr/local/bin/docker-compose

USER jenkins

