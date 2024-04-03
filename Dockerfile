FROM ubuntu:18.04
# ubuntu:jammy

ARG DOCKER_VERSION=25.0.4
ARG DOCKER_COMPOSE_VERSION=2.26.0
ARG NODE_VERSION=18.7.0

# Install required packages
RUN apt-get update && \
    apt-get install -y curl libffi-dev openssl gcc g++ libc-dev make iptables util-linux sed grep coreutils iproute2 openjdk-11-jdk && \
    rm -rf /var/lib/apt/lists/*

# Install Node.js
RUN curl -sL https://deb.nodesource.com/setup_${NODE_VERSION} | bash - && \
    apt-get install -y nodejs

# Install Docker
RUN curl -fsSL https://download.docker.com/linux/static/stable/x86_64/docker-${DOCKER_VERSION}.tgz | tar -xzC /tmp \
    && mv /tmp/docker/* /bin/ \
    && chmod +x /bin/docker* \
    && rm -rf /tmp/docker*

RUN docker --version

# Install Docker Compose
RUN curl -L https://github.com/docker/compose/releases/download/v${DOCKER_COMPOSE_VERSION}/docker-compose-linux-x86_64 -o /bin/docker-compose \
    && chmod +x /bin/docker-compose

RUN docker-compose --version

# Clean up
RUN rm -rf /root/.cache

# Include functions to start/stop docker daemon
COPY docker-lib.sh /docker-lib.sh
COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/bin/bash"]
