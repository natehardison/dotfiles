OS := $(shell uname -s)

ifeq ($(OS),Darwin)
FONTS := $(HOME)/Library/Fonts
SCREENSHOTS := $(HOME)/screenshots
else
FONTS := $(HOME)/.fonts
endif

ifeq ("$(origin V)", "command line")
VERBOSE := $(V)
endif
ifndef VERBOSE
VERBOSE := 0
endif
ifneq ($(VERBOSE),s)
Q := @
endif

all:: bat fonts git links screen ssh vim zsh

clean: clean-bat clean-fonts clean-links clean-prezto

prepare:
	$(Q)git submodule update --init
	$(Q)mkdir -p $(HOME)/.config

bat: prepare
	$(Q)ln -s $(CURDIR)/$@ $(HOME)/.config/$@

clean-bat:
	$(Q)rm -r $(HOME)/.config/bat

fonts: prepare homebrew
	$(Q)mkdir -p $(FONTS)
	$(Q)/bin/bash fonts/install.sh
	brew tap homebrew/cask-fonts && brew install --cask font-inconsolata-go-nerd-font

clean-fonts:
	$(Q)/bin/bash fonts/uninstall.sh

ifeq ($(OS),Darwin)
all:: homebrew screenshots

homebrew: prepare
	$(Q)/bin/bash -c "$$(which -s brew || curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	cat $(CURDIR)/brew/leaves.txt | xargs brew install

screenshots:
	$(Q)mkdir -p $(SCREENSHOTS)
	$(Q)defaults write com.apple.screencapture location $(SCREENSHOTS)
	$(Q)killall SystemUIServer

.PHONY: homebrew
endif

links: prepare
	$(Q)ln -s $(CURDIR)/bash_aliases $(HOME)/.bash_aliases
	$(Q)ln -s $(CURDIR)/bin $(HOME)/bin

clean-links:
	$(Q)rm -f $(HOME)/bin
	$(Q)rm -f $(HOME)/.bash_aliases
	$(Q)rm -f $(HOME)/.gitconfig
	$(Q)rm -f $(HOME)/.screenrc
	$(Q)rm -f $(HOME)/.ssh/config
	$(Q)rm -f $(HOME)/.ssh/config.d
	$(Q)rm -f $(HOME)/.tmux.conf
	$(Q)rm -rf $(HOME)/.vim
	$(Q)rm -f $(HOME)/.zshrc

clean-prezto:
	$(Q)rm -f $(HOME)/.zshenv
	$(Q)rm -f $(HOME)/.zprofile
	$(Q)rm -f $(HOME)/.zprezto
	$(Q)rm -f $(HOME)/.zpreztorc
	$(Q)rm -f $(HOME)/.zlogin
	$(Q)rm -f $(HOME)/.zlogout

git: prepare
	$(Q)mkdir -p $(HOME)/.config/git
	$(Q)ln -sf $(CURDIR)/gitconfig $(HOME)/.config/git/config

iterm2: fonts
	@echo "Install $(CURDIR)/Default.json via iTerm2 Preferences"

node: homebrew
	$(Q)/bin/bash -c "$$(which -s node || volta install node)"

nvim: prepare vim
	$(Q)ln -sF $(CURDIR)/$@ $(HOME)/.config/$@
	nvim +PlugUpdate +qall

oh-my-tmux: prepare
	$(Q)ln -sf $(CURDIR)/tmux/oh-my-tmux/.tmux.conf $(HOME)/.tmux.conf
	$(Q)ln -sf $(CURDIR)/tmux/tmux.conf.local $(HOME)/.tmux.conf.local

prezto: prepare
	$(Q)ln -sF $(CURDIR)/zsh/zprezto $(HOME)/.zprezto
	$(Q)ln -sf $(CURDIR)/zsh/zpreztorc $(HOME)/.zpreztorc
	$(Q)ln -sf $(CURDIR)/zsh/zprezto/runcoms/zshenv $(HOME)/.zshenv
	$(Q)ln -sf $(CURDIR)/zsh/zprezto/runcoms/zprofile $(HOME)/.zprofile
	$(Q)ln -sf $(CURDIR)/zsh/zprezto/runcoms/zlogin $(HOME)/.zlogin
	$(Q)ln -sf $(CURDIR)/zsh/zprezto/runcoms/zlogout $(HOME)/.zlogout

s: prepare
	$(Q)ln -sF $(CURDIR)/$@ $(HOME)/.config/$@

screen:
	$(Q)ln -sf $(CURDIR)/screenrc $(HOME)/.screenrc

ssh:
	$(Q)mkdir -p $(HOME)/.ssh/
	$(Q)ln -sf $(CURDIR)/ssh/config $(HOME)/.ssh/config
	$(Q)ln -sF $(CURDIR)/ssh/config.d $(HOME)/.ssh/config.d

tmux: oh-my-tmux

vim: homebrew node
	$(Q)ln -sF $(CURDIR)/vim $(HOME)/.vim

zsh: prepare prezto
	$(Q)ln -sf $(CURDIR)/zsh/zshrc $(HOME)/.zshrc

.PHONY: all bat clean clean-bat clean-fonts clean-prezto fonts git links iterm2 node nvim oh-my-tmux prepare prezto s screen ssh tmux vim zsh
