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
        $ ln -s dotfiles/tmux/tmux.conf ~/.tmux.conf
        $ ln -s dotfiles/vim ~/.vim
        $ ln -s dotfiles/zsh/zshrc ~/.zshrc
        $ ln -s dotfiles/zsh/.zprezto ~/.zprezto
        $ ln -s dotfiles/zsh/zpreztorc ~/.zpreztorc
        $ ln -s dotfiles/zsh/.zprezto/runcoms/zlogin ~/.zlogin
        $ ln -s dotfiles/zsh/.zprezto/runcoms/zlogout ~/.zlogout
        $ ln -s dotfiles/zsh/.zprezto/runcoms/zprofile ~/.zprofile
        $ ln -s dotfiles/zsh/.zprezto/runcoms/zshenv ~/.zshenv

1. Set up fonts

        $ ./dotfiles/fonts/install.sh

1. Store screenshots in `~/screenshots/`, not ~/Desktop

        $ mkdir $HOME/screenshots
        $ defaults write com.apple.screencapture location $HOME/screenshots/ && killall SystemUIServer

1. Install the following Homebrew packages:

    * `bat`
    * `fzf`
    * `gh`
    * `git-delta`
    * `gnupg`
    * `macvim`
    * `--cask rectangle`
    * `ripgrep`
    * `telnet`
    * `tmux`
    * `tree`
    * `universal-ctags`
    * `volta`

1. Use `volta` to install `node` (required for `vim` command / code completion)

    $ volta install node
