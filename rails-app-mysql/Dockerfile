ARG RUBY_VERSION=3.3
ARG DISTRO=bookworm
ARG IMAGE=rails-app
ARG REPOSITORY=lenchoreyes/jade

FROM $REPOSITORY:$IMAGE-$RUBY_VERSION-$DISTRO

RUN apt update -y -q && DEBIAN_FRONTEND=noninteractive apt install -yq --no-install-recommends \
    default-mysql-client \
    default-libmysqlclient-dev

# This Dockerfile inherits the CMD from the Ruby image, which is `irb`.
