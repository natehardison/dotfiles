OS := $(shell uname -s)

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

# BSD softlink requires -h to not follow existing links
SOFTLINK := ln -sf
ifeq ($(OS), Darwin)
SOFTLINK := ln -shf
endif

define install-config
$(SOFTLINK) $(CURDIR)/$@ $(CONFIG)/$@
endef

TARGETS := bash bat bin git lvim mise nvim prezto s screen ssh tmux vim wireshark zsh

.PHONY: all
all:: $(TARGETS)

.PHONY: clean
clean:: $(foreach target,$(TARGETS),clean-$(target))

.PHONY: config
config:
	$(Q)mkdir -p $(HOME)/.config

.PHONY: submodules
submodules:
	$(Q)git submodule update --init --recursive

ifeq ($(OS),Darwin)
all:: brew iterm2 screenshots

.PHONY: brew
brew:
	$(Q)/bin/bash -c "$$(which -s brew || curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	brew bundle --file $(CURDIR)/brew/Brewfile

.PHONY: iterm2
iterm2: brew
	@echo "Install $(CURDIR)/Default.json via iTerm2 Preferences"

.PHONY: screenshots
screenshots:
	$(Q)mkdir -p $(HOME)/screenshots
	$(Q)defaults write com.apple.screencapture location $(HOME)/screenshots
	$(Q)killall SystemUIServer
endif

.PHONY: bash
bash:
	$(Q)$(SOFTLINK) $(CURDIR)/bash/bash_aliases $(HOME)/.bash_aliases

.PHONY: clean-bash
clean-bash:
	$(Q)rm -f $(HOME)/.bash_aliases

.PHONY: bin
bin:
	$(Q)$(SOFTLINK) $(CURDIR)/bin $(HOME)/bin

.PHONY: clean-bin
clean-bin:
	$(Q)rm -f $(HOME)/bin

.PHONY: nvim
nvim: config submodules vim
	$(Q)$(install-config)
	nvim +PlugUpdate +qall

.PHONY: prezto
prezto: submodules
	$(Q)$(SOFTLINK) $(CURDIR)/zsh/zprezto $(HOME)/.zprezto
	$(Q)$(SOFTLINK) $(CURDIR)/zsh/zpreztorc $(HOME)/.zpreztorc
	$(Q)$(SOFTLINK) $(CURDIR)/zsh/zprezto/runcoms/zshenv $(HOME)/.zshenv
	$(Q)$(SOFTLINK) $(CURDIR)/zsh/zprezto/runcoms/zprofile $(HOME)/.zprofile
	$(Q)$(SOFTLINK) $(CURDIR)/zsh/zprezto/runcoms/zlogin $(HOME)/.zlogin
	$(Q)$(SOFTLINK) $(CURDIR)/zsh/zprezto/runcoms/zlogout $(HOME)/.zlogout
	$(Q)git clone https://github.com/Aloxaf/fzf-tab $(CURDIR)/zsh/zprezto/contrib/fzf-tab || true

.PHONY: clean-prezto
clean-prezto:
	$(Q)rm -f $(HOME)/.zprezto
	$(Q)rm -f $(HOME)/.zpreztorc
	$(Q)rm -f $(HOME)/.zshenv
	$(Q)rm -f $(HOME)/.zprofile
	$(Q)rm -f $(HOME)/.zlogin
	$(Q)rm -f $(HOME)/.zlogout

.PHONY: screen
screen:
	$(Q)$(SOFTLINK) $(CURDIR)/screen/screenrc $(HOME)/.screenrc

.PHONY: clean-screen
clean-screen:
	$(Q)rm -f $(HOME)/.screenrc

.PHONY: ssh
ssh:
	$(Q)mkdir -p $(HOME)/.ssh/
	$(Q)$(SOFTLINK) $(CURDIR)/ssh/config $(HOME)/.ssh/config
	$(Q)$(SOFTLINK) $(CURDIR)/ssh/config.d $(HOME)/.ssh/config.d

.PHONY: clean-ssh
clean-ssh:
	$(Q)rm -f $(HOME)/.ssh/config
	$(Q)rm -f $(HOME)/.ssh/config.d

.PHONY: vim
vim:
	$(Q)$(SOFTLINK) $(CURDIR)/vim $(HOME)/.vim

.PHONY: clean-vim
clean-vim:
	$(Q)rm -rf $(HOME)/.vim

# just save profiles directory, not whole wireshark dir
.PHONY: wireshark
wireshark: config
	$(Q)mkdir -p $(CONFIG)/$@
	$(Q)$(SOFTLINK) $(CURDIR)/$@/profiles $(CONFIG)/$@/profiles

.PHONY: clean-wireshark
clean-wireshark:
	$(Q)rm -rf $(CONFIG)/wireshark/profiles

.PHONY: zsh
zsh:
	$(Q)$(SOFTLINK) $(CURDIR)/zsh/zshrc $(HOME)/.zshrc

.PHONY: clean-zsh
clean-zsh:
	$(Q)rm -f $(HOME)/.zshrc

clean-%:
	$(Q)rm -f $(CONFIG)/$*

Makefile: ;

%:: config
	$(Q)$(install-config)
