#!/usr/bin/env bash

set -e

# install ubi for installing from GitHub
INSTALL_DIR=$HOME/.local/bin
sudo mkdir -p $INSTALL_DIR
sudo chown $USER $INSTALL_DIR
export PATH="$INSTALL_DIR:$PATH"
export TARGET=$INSTALL_DIR
curl --silent --location \
    https://raw.githubusercontent.com/houseabsolute/ubi/master/bootstrap/bootstrap-ubi.sh |
    sh

# install utilities
ubi -p sharkdp/bat -i $INSTALL_DIR
ubi -p dandavison/delta -i $INSTALL_DIR
ubi -p eza-community/eza -i $INSTALL_DIR
ubi -p sharkdp/fd -i $INSTALL_DIR
ubi -p junegunn/fzf -i $INSTALL_DIR
ubi -p jesseduffield/lazygit -i $INSTALL_DIR
ubi -p BurntSushi/ripgrep -i $INSTALL_DIR
ubi -p ajeetdsouza/zoxide -i $INSTALL_DIR

make bash bat bin zsh
