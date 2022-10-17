INSTALLATION
============
1. Ensure macOS command line tools are installed:

        $ xcode-select --install

1. Ensure SSH keys generated and added to macOS SSH agent

        $ ssh-keygen -t ed25519 -C "email@example.com"
        $ ssh-add --apple-use-keychain ~/.ssh/<keyfile>

1. Clone this repo:

        $ git clone --recurse-submodules -j8 git@github.com:natehardison/dotfiles.git

1. Use `make` to install and set up system

        $ cd dotfiles
        $ make

1. Install the Homebrew packages listed in
   [`brew/leaves.txt`](./brew/leaves.txt)

        $ cat brew/leaves.txt | xargs brew install

1. Use `volta` to install `node` (required for `vim` command / code completion)

    $ volta install node
