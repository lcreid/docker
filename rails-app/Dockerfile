ARG RUBY_VERSION=3.2
ARG DISTRO=bullseye
ARG REPOSITORY=lenchoreyes/jade
ARG IMAGE=ruby-app

FROM $REPOSITORY:$IMAGE-$RUBY_VERSION-$DISTRO

ARG NODE_MAJOR=20

# Rails wants a newer version of node that we get with the Debian distro.
RUN apt-get install -y ca-certificates curl gnupg
RUN mkdir -p /etc/apt/keyrings
RUN curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
RUN echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list
RUN apt-get update
RUN apt-get install nodejs -y -q
RUN corepack enable

EXPOSE 3000

# This Dockerfile inherits the CMD from the Ruby image, which is `irb`.
