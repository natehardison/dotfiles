INSTALLATION
============
1. Ensure macOS command line tools are installed:

        $ xcode-select --install

1. Ensure SSH keys generated and added to macOS SSH agent

        $ ssh-keygen -t ed25519 -C "email@example.com"
        $ ssh-add --apple-use-keychain ~/.ssh/<keyfile>

1. Clone this repo:

        $ git clone --recurse-submodules -j8 git@github.com:natehardison/dotfiles.git

1. Install [Homebrew](http://brew.sh/):

        $ /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

1. Set up links to the dot files:

        $ ln -s dotfiles/bash_aliases ~/.bash_aliases
        $ ln -s dotfiles/gitconfig ~/.gitconfig
        $ ln -s dotfiles/ssh/config ~/.ssh/config
        $ ln -s dotfiles/vim ~/.vim
        $ ln -s dotfiles/zsh/zpreztorc ~/.zpreztorc
        $ ln -s dotfiles/zsh/.zprezto ~/.zprezto
        $ ln -s dotfiles/zsh/.zprezto/runcoms/zlogin ~/.zlogin
        $ ln -s dotfiles/zsh/.zprezto/runcoms/zlogout ~/.zlogout
        $ ln -s dotfiles/zsh/.zprezto/runcoms/zprofile ~/.zprofile
        $ ln -s dotfiles/zsh/.zprezto/runcoms/zshenv ~/.zshenv
        $ ln -s dotfiles/zsh/.zprezto/runcoms/zshrc ~/.zshrc

1. Set up Inconsolata-dz as the font:

        $ cp dotfiles/fonts/Inconsolata-dz.otf ~/Library/Fonts

1. Install the following Homebrew packages:

    * `ag`
    * `autojump`
    * `gnupg`
    * `macvim`
    * `tree`
