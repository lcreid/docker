ARG RUBY_VERSION
ARG DISTRO
ARG IMAGE=rails-app
ARG REPOSITORY=lenchoreyes/jade

FROM $REPOSITORY:$IMAGE-$RUBY_VERSION-$DISTRO

RUN apt update -y -q && apt install -y -q sqlite3

# This Dockerfile inherits the CMD from the Ruby image, which is `irb`.
