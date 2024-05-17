#!/usr/bin/env bash

set -e

# install ubi for installing from GitHub
sudo chown $USER $HOME/.local
export TARGET=$HOME/.local/bin/
mkdir $TARGET
curl --silent --location \
    https://raw.githubusercontent.com/houseabsolute/ubi/master/bootstrap/bootstrap-ubi.sh |
    sh

# install utilities
ubi -p sharkdp/bat -i $TARGET
ubi -p dandavison/delta -i $TARGET
ubi -p eza-community/eza -i $TARGET
ubi -p sharkdp/fd -i $TARGET
ubi -p junegunn/fzf -i $TARGET
ubi -p jesseduffield/lazygit -i $TARGET
ubi -p BurntSushi/ripgrep -i $TARGET
ubi -p ajeetdsouza/zoxide -i $TARGET

make bash bat bin zsh
