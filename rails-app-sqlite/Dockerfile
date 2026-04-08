ARG RUBY_VERSION=4.0
ARG DISTRO=trixie
ARG IMAGE=rails-app
ARG REPOSITORY=lenchoreyes/jade

FROM $REPOSITORY:$IMAGE-$RUBY_VERSION-$DISTRO

RUN apt update -y -q && apt install -y -q sqlite3

# This Dockerfile inherits the CMD from the Ruby image, which is `irb`.
