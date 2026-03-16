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

# -n: don't follow existing symlinks or descend into directories
SOFTLINK := ln -snf

define install-config
$(SOFTLINK) $(CURDIR)/$@ $(CONFIG)/$@
endef

# -- profiles ------------------------------------------------------------------

.PHONY: minimal
minimal: packages config antidote bat bin git mise nvim ssh starship tmux vim zsh

.PHONY: full
full: minimal ghostty wireshark

# -- package installation ------------------------------------------------------

.PHONY: brew
brew:
	$(Q)which brew >/dev/null 2>&1 || /bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	$(Q)brew bundle --file $(CURDIR)/brew/Brewfile

UBI := $(HOME)/.local/bin/ubi
.PHONY: ubi
ubi:
	$(Q)mkdir -p $(HOME)/.local/bin
	$(Q)command -v ubi >/dev/null 2>&1 || \
		export TARGET="$(HOME)/.local/bin" && \
		curl --silent --location \
			https://raw.githubusercontent.com/houseabsolute/ubi/master/bootstrap/bootstrap-ubi.sh | sh
	$(Q)while IFS=: read -r repo exe; do \
		$(UBI) -p "$$repo" -i $(HOME)/.local/bin $${exe:+-e "$$exe"}; \
	done < $(CURDIR)/ubi/tools

# -- macOS ---------------------------------------------------------------------

ifeq ($(OS),Darwin)
.PHONY: all
all: full

.PHONY: packages
packages: brew

full: casks screenshots

.PHONY: casks
casks: brew
	$(Q)brew bundle --file $(CURDIR)/brew/Caskfile

.PHONY: screenshots
screenshots:
	$(Q)mkdir -p $(HOME)/screenshots
	$(Q)defaults write com.apple.screencapture location $(HOME)/screenshots
	$(Q)killall SystemUIServer

# -- Linux ---------------------------------------------------------------------

else
.PHONY: all
all: minimal

.PHONY: packages
packages: ubi
endif

# -- config targets ------------------------------------------------------------

.PHONY: config
config:
	$(Q)mkdir -p $(HOME)/.config

.PHONY: antidote
antidote:
	$(Q)git clone --depth=1 https://github.com/mattmc3/antidote.git $(HOME)/.antidote 2>/dev/null || true
	$(Q)$(SOFTLINK) $(CURDIR)/zsh/zsh_plugins.txt $(HOME)/.zsh_plugins.txt

.PHONY: bin
bin:
	$(Q)$(SOFTLINK) $(CURDIR)/bin $(HOME)/bin

.PHONY: nvim
nvim: config vim
	$(Q)$(install-config)
	$(Q)command -v nvim >/dev/null && nvim +PlugUpdate +qall || true

.PHONY: ssh
ssh:
	$(Q)mkdir -p $(HOME)/.ssh/
	$(Q)$(SOFTLINK) $(CURDIR)/ssh/config $(HOME)/.ssh/config
	$(Q)$(SOFTLINK) $(CURDIR)/ssh/config.d $(HOME)/.ssh/config.d

.PHONY: starship
starship: config
	$(Q)$(SOFTLINK) $(CURDIR)/starship/starship.toml $(CONFIG)/starship.toml

.PHONY: vim
vim:
	$(Q)$(SOFTLINK) $(CURDIR)/vim $(HOME)/.vim
	$(Q)command -v vim >/dev/null && vim +PlugInstall +qall || true

.PHONY: wireshark
wireshark: config
	$(Q)mkdir -p $(CONFIG)/$@
	$(Q)$(SOFTLINK) $(CURDIR)/$@/profiles $(CONFIG)/$@/profiles

.PHONY: zsh
zsh:
	$(Q)$(SOFTLINK) $(CURDIR)/zsh/zshrc $(HOME)/.zshrc

# -- clean targets -------------------------------------------------------------

TARGETS := bat bin ghostty git mise nvim antidote ssh starship tmux vim wireshark zsh

.PHONY: clean
clean: $(foreach target,$(TARGETS),clean-$(target))

.PHONY: clean-antidote
clean-antidote:
	$(Q)rm -f $(HOME)/.zsh_plugins.txt

.PHONY: clean-bin
clean-bin:
	$(Q)rm -f $(HOME)/bin

.PHONY: clean-ssh
clean-ssh:
	$(Q)rm -f $(HOME)/.ssh/config
	$(Q)rm -f $(HOME)/.ssh/config.d

.PHONY: clean-starship
clean-starship:
	$(Q)rm -f $(CONFIG)/starship.toml

.PHONY: clean-vim
clean-vim:
	$(Q)rm -rf $(HOME)/.vim

.PHONY: clean-wireshark
clean-wireshark:
	$(Q)rm -rf $(CONFIG)/wireshark/profiles

.PHONY: clean-zsh
clean-zsh:
	$(Q)rm -f $(HOME)/.zshrc

clean-%:
	$(Q)rm -f $(CONFIG)/$*

Makefile: ;

%:: config
	$(Q)$(install-config)
