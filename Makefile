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

TARGETS := bat bin ghostty git mise nvim antidote ssh starship tmux vim wireshark zsh

.PHONY: all
all:: $(TARGETS)

.PHONY: clean
clean:: $(foreach target,$(TARGETS),clean-$(target))

.PHONY: install-minimal
install-minimal: bat bin git mise ssh zsh

.PHONY: install-dev
install-dev: install-minimal nvim antidote tmux

.PHONY: config
config:
	$(Q)mkdir -p $(HOME)/.config

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

.PHONY: bin
bin:
	$(Q)$(SOFTLINK) $(CURDIR)/bin $(HOME)/bin

.PHONY: clean-bin
clean-bin:
	$(Q)rm -f $(HOME)/bin

.PHONY: nvim
nvim: config vim
	$(Q)$(install-config)
	nvim +PlugUpdate +qall

.PHONY: antidote
antidote:
	$(Q)git clone --depth=1 https://github.com/mattmc3/antidote.git $(HOME)/.antidote 2>/dev/null || true
	$(Q)$(SOFTLINK) $(CURDIR)/zsh/zsh_plugins.txt $(HOME)/.zsh_plugins.txt

.PHONY: clean-antidote
clean-antidote:
	$(Q)rm -f $(HOME)/.zsh_plugins.txt

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

.PHONY: starship
starship: config
	$(Q)$(SOFTLINK) $(CURDIR)/starship/starship.toml $(CONFIG)/starship.toml

.PHONY: clean-starship
clean-starship:
	$(Q)rm -f $(CONFIG)/starship.toml

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
