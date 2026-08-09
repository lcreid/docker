ARG RUBY_VERSION=4.0
ARG DISTRO=trixie
ARG REPOSITORY=lenchoreyes/jade
ARG IMAGE=ruby-app

FROM $REPOSITORY:$IMAGE-$RUBY_VERSION-$DISTRO

ARG NODE_MAJOR=24

# Rails wants a newer version of node that we get with the Debian distro.
RUN apt-get install -y ca-certificates curl gnupg
RUN mkdir -p /etc/apt/keyrings

RUN curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --batch --yes --dearmor -o /etc/apt/keyrings/nodesource.gpg && \
    echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list && \
    apt-get update && \
    apt-get install -y -q --no-install-recommends nodejs && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    corepack enable

RUN apt-get update && apt-get install libvips-dev -y -q --no-install-recommends && apt-get clean && rm -rf /var/lib/apt/lists/*

# The following is so part of what we need to run `kamal deploy` inside the container. Rafael says running
# Kamal inside the container is the intended use.
# You need to have the Docker executables in the container, plus the right volume mounts and permissions
# in `compose.yml` or `compose.override.yml` so the executables can use the Docker engine running on the host.
# All this sounds like it's very *nix-specific.
RUN apt-get update && \
    curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc && \
    chmod a+r /etc/apt/keyrings/docker.asc && \
    echo \
        "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
        $(. /etc/os-release && echo "$VERSION_CODENAME") stable" > /etc/apt/sources.list.d/docker.list && \
    apt-get update && \
    apt-get install docker-buildx-plugin -y -q --no-install-recommends && \
    apt-get update && \
    apt-get install docker-ce-cli -y -q --no-install-recommends && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# `rails-app` is useful for other things, like Jekyll, so let's install foreman as well.
# Rails needs it anyway, at least in some configurations, so this saves an install on-the-fly.
USER dev
RUN gem install foreman
USER root

EXPOSE 3000

# This Dockerfile inherits the CMD from the Ruby image, which is `irb`.
