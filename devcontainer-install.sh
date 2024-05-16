#!/usr/bin/env bash

set -e

make bash bat bin zsh

# install git-delta
sudo chown $USER $HOME/.local
export TARGET=$HOME/.local/bin/
mkdir $TARGET
curl --silent --location \
    https://raw.githubusercontent.com/houseabsolute/ubi/master/bootstrap/bootstrap-ubi.sh |
    sh
ubi -p dandavison/delta -i $TARGET
