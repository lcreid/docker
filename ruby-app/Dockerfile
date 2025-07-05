ARG RUBY_VERSION
ARG DISTRO

FROM ruby:$RUBY_VERSION-$DISTRO

RUN mkdir -p /app
ENV HOME /app
WORKDIR /app

ENV GEM_HOME $HOME/vendor/bundle
ENV BUNDLE_APP_CONFIG="$GEM_HOME"
ENV PATH ./bin:$GEM_HOME/bin:$PATH
# Make it so you can install packages in the image. For exploring and debugging, mostly.
RUN (echo 'docker'; echo 'docker') | passwd root

# This Dockerfile inherits the CMD from the Ruby image, which is `irb`.
