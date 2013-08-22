INSTALLATION
============
1. Clone this repo:

        $ git clone git@github.com:natehardison/dotfiles.git

1. Initialize submodules:

        $ git submodule init
        $ git submodule update

1. Install [Janus](https://github.com/carlhuda/janus):

        $ curl -Lo- https://bit.ly/janus-bootstrap | bash

1. Install [oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh):

        $ curl -L https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh | sh

1. Set up links to the dot files:

        $ ln -s dotfiles/.bash_aliases ~/.bash_aliases
        $ ln -s dotfiles/.gitconfig ~/.gitconfig
        $ ln -s dotfiles/.janus ~/.janus
        $ ln -s dotfiles/.janus/.vimrc.before ~/.vimrc.before
        $ ln -s dotfiles/.janus/.vimrc.after ~/.vimrc.after
        $ ln -s dotfiles/.zshrc ~/.zshrc

1. Set up Inconsolata-dz as the font:

        $ cp dotfiles/.janus/Inconsolata-dz.otf ~/Library/Fonts

PACKAGES
========
* Homebrew
* tree
* autojump
* ack
* git
* gpg
