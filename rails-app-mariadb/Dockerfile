ARG RUBY_VERSION
ARG DISTRO
ARG IMAGE=rails-app
ARG REPOSITORY=lenchoreyes/jade

FROM $REPOSITORY:$IMAGE-$RUBY_VERSION-$DISTRO

RUN apt update -y -q && DEBIAN_FRONTEND=noninteractive apt install -yq --no-install-recommends \
    mariadb-client \
    libmariadb-dev-compat \
    libmariadb-dev

# This Dockerfile inherits the CMD from the Ruby image, which is `irb`.
