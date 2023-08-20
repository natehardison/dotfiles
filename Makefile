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

CONFIG := $(HOME)/.config

define install-config
ln -sF $(CURDIR)/$@ $(CONFIG)/$@
endef

all:: bat fonts git links nvim s screen ssh tmux vim wireshark zsh

clean: clean-bat clean-fonts clean-git clean-links clean-nvim clean-s clean-screen clean-ssh clean-tmux clean-vim clean-wireshark clean-zsh

prepare:
	$(Q)git submodule update --init --recursive
	$(Q)mkdir -p $(CONFIG)

bat: prepare
	$(Q)$(install-config)

fonts: prepare homebrew
	$(Q)mkdir -p $(FONTS)
	$(Q)/bin/bash fonts/install.sh

clean-fonts:
	$(Q)/bin/bash fonts/uninstall.sh

git: prepare
	$(Q)$(install-config)

ifeq ($(OS),Darwin)
all:: homebrew screenshots

homebrew: prepare
	$(Q)/bin/bash -c "$$(which -s brew || curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	brew bundle --file $(CURDIR)/brew/Brewfile

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

iterm2: fonts
	@echo "Install $(CURDIR)/Default.json via iTerm2 Preferences"

node: homebrew
	$(Q)/bin/bash -c "$$(which -s node || volta install node)"

nvim: prepare vim
	$(Q)$(install-config)
	nvim +PlugUpdate +qall

prezto: prepare
	$(Q)ln -sF $(CURDIR)/zsh/zprezto $(HOME)/.zprezto
	$(Q)ln -sf $(CURDIR)/zsh/zpreztorc $(HOME)/.zpreztorc
	$(Q)ln -sf $(CURDIR)/zsh/zprezto/runcoms/zshenv $(HOME)/.zshenv
	$(Q)ln -sf $(CURDIR)/zsh/zprezto/runcoms/zprofile $(HOME)/.zprofile
	$(Q)ln -sf $(CURDIR)/zsh/zprezto/runcoms/zlogin $(HOME)/.zlogin
	$(Q)ln -sf $(CURDIR)/zsh/zprezto/runcoms/zlogout $(HOME)/.zlogout
	$(Q)git clone https://github.com/Aloxaf/fzf-tab $(CURDIR)/zsh/zprezto/contrib/fzf-tab || true

clean-prezto:
	$(Q)rm -f $(HOME)/.zprezto
	$(Q)rm -f $(HOME)/.zpreztorc
	$(Q)rm -f $(HOME)/.zshenv
	$(Q)rm -f $(HOME)/.zprofile
	$(Q)rm -f $(HOME)/.zlogin
	$(Q)rm -f $(HOME)/.zlogout

s: prepare
	$(Q)$(install-config)

screen:
	$(Q)ln -sf $(CURDIR)/screenrc $(HOME)/.screenrc

clean-screen:
	$(Q)rm -f $(HOME)/.screenrc

ssh:
	$(Q)mkdir -p $(HOME)/.ssh/
	$(Q)ln -sf $(CURDIR)/ssh/config $(HOME)/.ssh/config
	$(Q)ln -sF $(CURDIR)/ssh/config.d $(HOME)/.ssh/config.d

clean-ssh:
	$(Q)rm -f $(HOME)/.ssh/config
	$(Q)rm -f $(HOME)/.ssh/config.d

tmux: prepare
	$(Q)$(install-config)

vim: homebrew node
	$(Q)ln -sF $(CURDIR)/vim $(HOME)/.vim

clean-vim:
	$(Q)rm -rf $(HOME)/.vim

# just save profiles directory, not whole wireshark dir
wireshark:
	$(Q)mkdir -p $(CONFIG)/$@
	$(Q)ln -sF $(CURDIR)/$@/profiles $(CONFIG)/$@/profiles

clean-wireshark:
	$(Q)rm -rf $(CONFIG)/wireshark/profiles

zsh: prepare prezto
	$(Q)ln -sf $(CURDIR)/zsh/zshrc $(HOME)/.zshrc

clean-zsh: clean-prezto
	$(Q)rm -f $(HOME)/.zshrc

clean-%:
	$(Q)rm $(CONFIG)/$*

.PHONY: all bat clean clean-fonts clean-prezto fonts git links iterm2 node nvim prepare prezto s screen ssh tmux vim wireshark zsh
