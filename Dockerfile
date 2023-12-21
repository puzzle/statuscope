#################################
#          Build Stage          #
#################################

FROM ruby:3.2 AS build

# Set build shell
SHELL ["/bin/bash", "-c"]

# Use root user
USER root

ARG BUNDLER_VERSION=2.5.1

ARG PRE_INSTALL_SCRIPT
ARG BUILD_PACKAGES="sqlite3 libsqlite3-dev build-essential"
ARG INSTALL_SCRIPT
ARG BUNDLE_WITHOUT='development:metrics:test'
ARG BUILD_SCRIPT

RUN bash -vxc "${PRE_INSTALL_SCRIPT:-"echo 'no PRE_INSTALL_SCRIPT provided'"}"

# Install dependencies
RUN    apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y ${BUILD_PACKAGES}

RUN bash -vxc "${INSTALL_SCRIPT:-"echo 'no INSTALL_SCRIPT provided'"}"

# Install specific versions of dependencies
RUN gem install bundler:${BUNDLER_VERSION} --no-document

# TODO: Load artifacts

# set up app-src directory
COPY . /app-src
WORKDIR /app-src

ENV RAILS_ENV=production \
    RACK_ENV=production \
    RAILS_HOST_NAME='unused.example.net' \
    SECRET_KEY_BASE="averylongbutunusedstringthatisneededforrailstobootandbuildassetsbutotherwisenotimportantduringthebuild" \
    TZ=Europe/Zurich \
    NODE_ENV=production

# install gems and build the app
RUN    bundle config set --local deployment 'true' \
    && bundle config set --local without ${BUNDLE_WITHOUT} \
    && bundle package \
    && bundle install \
    && bundle clean

RUN bash -vxc "${BUILD_SCRIPT:-"echo 'no BUILD_SCRIPT provided'"}"

# TODO: Save artifacts

RUN rm -rf vendor/cache/ .git spec/ node_modules/ tmp/ \
           db/*.sqlite3 \
           openshift/ \
           log/*.log


#################################
#           Run Stage           #
#################################

# This image will be replaced by Openshift
FROM ruby:3.2-slim AS app

# Set runtime shell
SHELL ["/bin/bash", "-c"]

# Add user
RUN adduser --disabled-password --uid 1001 --gid 0 --gecos "" app

ARG BUNDLE_WITHOUT='development:metrics:test'
ARG RUN_PACKAGES='sqlite3'

ENV RAILS_ENV=production \
    RAILS_DB_ADAPTER=sqlite3

# Install dependencies, remove apt!
RUN    apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y ${RUN_PACKAGES} \
       vim curl less

# Copy deployment ready source code from build
COPY --from=build /app-src /app-src
WORKDIR /app-src

# Set group permissions to app folder
RUN    chgrp -R 0 /app-src \
    && chmod -R u+w,g=u /app-src

ENV HOME=/app-src
ENV PATH=/app-src/bin:$PATH

# Use cached gems
RUN    bundle config set --local deployment 'true' \
    && bundle config set --local without ${BUNDLE_WITHOUT} \
    && bundle

USER 1001

CMD ["bundle", "exec", "puma", "-t", "8", "-p", "8080"]
