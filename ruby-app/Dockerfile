# Only works with Debian derivatives. Specifically _not_ with Alpine.
ARG RUBY_VERSION=4.0
ARG DISTRO=trixie

FROM ruby:$RUBY_VERSION-$DISTRO

# Build arguments to match host user
ARG UID=1000
ARG GID=1000

# Create non-root user with home directory
RUN groupadd -g $GID dev && useradd -m -u $UID -g dev dev

# Set environment
# The image works when started manually from docker, without the bundler and gem environment variables,
# but I can't get it to work when run from docker compose. Go figure.
ENV HOME=/home/dev \
  APP_HOME=/home/dev/app \
  GEM_HOME=/usr/local/bundle \
  BUNDLE_PATH=/usr/local/bundle

# Create app directory
# Touch history so if the first run of the container is with the root user, we don't create a history file
# owned by root, which stops the dev user from saving any history.
RUN mkdir -p ${APP_HOME} \
  touch ${HOME}/.bash_history \
  && chown -R dev:dev ${HOME}

WORKDIR ${APP_HOME}
