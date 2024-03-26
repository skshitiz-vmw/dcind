FROM ubuntu:jammy

ARG DOCKER_VERSION=25.0.4
ARG DOCKER_COMPOSE_VERSION=2.26.0

# Install required packages
RUN apt-get update && \
    apt-get install -y \
    curl \
    ca-certificates \
    libssl-dev \
    libffi-dev \
    python3 \
    python3-pip \
    python3-dev \
    gcc \
    make \
    rustc \
    cargo \
    iptables \
    iproute2 \
    nodejs \
    npm \
    && rm -rf /var/lib/apt/lists/*

# Install Docker
RUN curl -fsSL https://download.docker.com/linux/static/stable/x86_64/docker-${DOCKER_VERSION}.tgz | tar -xzC /tmp \
    && mv /tmp/docker/* /bin/ \
    && chmod +x /bin/docker* \
    && rm -rf /tmp/docker*

RUN docker --version

# Install Docker Compose
RUN curl -L https://github.com/docker/compose/releases/download/v${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m) -o /bin/docker-compose \
    && chmod +x /bin/docker-compose

RUN docker-compose --version

# Clean up
RUN rm -rf /root/.cache

# Include functions to start/stop docker daemon
COPY docker-lib.sh /docker-lib.sh
COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/bin/bash"]
