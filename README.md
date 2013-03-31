INSTALLATION
============
1. Clone this repo:

        $ git clone git@github.com:natehardison/dotfiles.git

1. Install [Janus](https://github.com/carlhuda/janus):

        $ curl -Lo- https://bit.ly/janus-bootstrap | bash

1. Set up links to the dot files:

        $ ln -s dotfiles/.bash_aliases ~/.bash_aliases
        $ ln -s dotfiles/.gitconfig ~/.gitconfig
        $ ln -s dotfiles/.janus ~/.janus
        $ ln -s dotfiles/.janus/.vimrc.before ~/.vimrc.before
        $ ln -s dotfiles/.janus/.vimrc.after ~/.vimrc.after

1. Set up Inconsolata-dz as the font:

        $ cp dotfiles/.janus/Inconsolata-dz.otf ~/Library/Fonts
