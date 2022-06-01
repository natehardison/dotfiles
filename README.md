INSTALLATION
============
1. Ensure macOS command line tools are installed:

        $ xcode-select --install

1. Ensure SSH keys generated and added to macOS SSH agent

        $ ssh-keygen -t ed25519 -C "email@example.com"
        $ ssh-add --apple-use-keychain ~/.ssh/<keyfile>

1. Clone this repo:

        $ git clone git@github.com:natehardison/dotfiles.git

1. Initialize submodules:

        $ git submodule init
        $ git submodule update

1. Install [Homebrew](http://brew.sh/):

        $ /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

1. Install [Prezto](https://github.com/sorin-ionescu/prezto):

        $ git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
        $ setopt EXTENDED_GLOB
        $ for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
            ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
          done

1. Set up links to the dot files:

        $ ln -s dotfiles/bash_aliases ~/.bash_aliases
        $ ln -s dotfiles/gitconfig ~/.gitconfig
        $ ln -s dotfiles/ssh/config ~/.ssh/config
        $ ln -s dotfiles/vimrc ~/.vimrc
        $ ln -s dotfiles/zpreztorc ~/.zpreztorc

1. Set up Inconsolata-dz as the font:

        $ cp dotfiles/Inconsolata-dz.otf ~/Library/Fonts

1. Install the following Homebrew packages:

    * `ag`
    * `autojump`
    * `gnupg`
    * `macvim`
    * `tree`
