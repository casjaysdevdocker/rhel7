#!/usr/bin/env sh
# shellcheck shell=sh
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
##@Version           :
# @Author            :  Jason
# @Contact           :  jason@casjaysdev.com
# @License           :  WTFPL
# @ReadME            :  build --help
# @Copyright         :  Copyright (c) 2022, Casjays Developments
# @Created           :  Friday Oct 07, 2022 10:44:35 EDT
# @File              :  build
# @@Description      :  script to build docker images
# @@Changelog        :
# @@TODO             :
# @@Other            :
# @@Resource         :
# @@Terminal App     :  no
# @@sudo/root        :  no
# @@Template         :  shell/sh
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
HOME="${USER_HOME:-$HOME}"
USER="${SUDO_USER:-$USER}"
RUN_USER="${SUDO_USER:-$USER}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set variables
build_platforms="linux/amd64,linux/arm64"
hub_username="casjaysdevdocker"
release="7"
arguments="$@"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Main application
if docker buildx 2>&1 | grep -q 'docker buildx COMMAND'; then
  echo "Building docker image with buildx"
  sudo docker buildx build \
      --platform "$build_platforms" \
      --rm \
      --pull \
      --no-cache \
      --progress auto \
      --output=type=registry \
      -t $hub_username/rhel$release:latest \
      -t $hub_username/rpm-devel:$release $arguments \
      -f "$PWD/Dockerfile" "$PWD"
      exit $?
else
  echo "Building docker image with docker"
    sudo docker build \
      -f "$PWD/Dockerfile" \
      --pull \
      --force-rm \
      --no-cache \
      -t $hub_username/rhel$release:latest \
      -t $hub_username/rpm-devel:$release $arguments "$PWD"
      if [ "$?" = 0 ]; then
        sudo docker push $hub_username/rhel$release:latest
        sudo docker push $hub_username/rpm-devel:$release
        sudo docker rmi -f $hub_username/rhel$release:latest
        sudo docker rmi -f $hub_username/rpm-devel:$release
      fi
      exit $?
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# End application

