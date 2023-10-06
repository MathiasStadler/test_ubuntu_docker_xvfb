# from here
# https://thesoftwarehouse.github.io/Kakunin/docs/docker
# Downloading selenium image and setting privileges
FROM selenium/standalone-chrome:3.14.0
USER root
# Setting test directory
WORKDIR /app
# Install openjdk-8-jdk-headless
RUN apt-get update -qqy \
  && apt-get -qqy --no-install-recommends install \
    xvfb \
    openjdk-8-jdk-headless \
    curl \
    make \
  && rm -rf /var/lib/apt/lists/* /var/cache/apt/*
# Installing node 8 globally and setting paths
RUN set -x \
    && curl -sL https://deb.nodesource.com/setup_8.x | bash - \
    && apt-get install -y \
        nodejs \
    && npm install -g npm@latest
RUN PATH=/usr/bin/node:$PATH
# Copy tests directory with ignored files from .dockerignore
COPY --chown=seluser:seluser . .
# Removing node_modules in case of existence or lack of .dockerignore and installing from package.json
RUN rm -rf ./node_modules \
    && npm install
# Setting Xvfb
RUN export DISPLAY=:99.0
USER seluser