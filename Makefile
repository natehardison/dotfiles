OS := $(shell uname -s)
CONFIG := $(HOME)/.config

# Wire up Homebrew so brew-installed tools are visible to all targets.
# /bin/sh on macOS runs path_helper which clobbers PATH on fresh installs.
ifeq ($(OS),Darwin)
HOMEBREW_PREFIX := /opt/homebrew
SHELL := /bin/bash
.SHELLFLAGS := --norc --noprofile -c
export PATH := $(HOMEBREW_PREFIX)/bin:$(PATH)
endif

# Suppress command echo by default; use V=1 to see raw commands.
ifeq ($(V),1)
Q :=
else
Q := @
endif

# -n: don't follow existing symlinks or descend into directories
SOFTLINK := ln -snf

define install-config
$(SOFTLINK) $(CURDIR)/$@ $(CONFIG)/$@
endef

.DEFAULT_GOAL := all

# -- profiles ------------------------------------------------------------------

# Default target is set per-OS below (full on macOS, minimal on Linux).
.PHONY: minimal
minimal: packages config antidote bat bin git kiro mise ssh starship tmux vim zsh

.PHONY: full
full: minimal ghostty nvim wireshark

# -- package installation ------------------------------------------------------

.PHONY: brew
brew:
	$(Q)echo "==> Installing packages via brew..."
	$(Q)which brew >/dev/null 2>&1 || /bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	$(Q)$(HOMEBREW_PREFIX)/bin/brew bundle --file $(CURDIR)/brew/Brewfile

UBI := $(HOME)/.local/bin/ubi
.PHONY: ubi
ubi:
	$(Q)mkdir -p $(HOME)/.local/bin
	$(Q)echo "==> Installing ubi..."
	$(Q)command -v ubi >/dev/null 2>&1 || \
		export TARGET="$(HOME)/.local/bin" && \
		curl --silent --location \
			https://raw.githubusercontent.com/houseabsolute/ubi/master/bootstrap/bootstrap-ubi.sh | sh
	$(Q)echo "==> Installing packages via ubi..."
	$(Q)while IFS=: read -r repo exe; do \
		case "$$repo" in ''|\#*) continue;; esac; \
		echo "    $$repo"; \
		$(UBI) -p "$$repo" -i $(HOME)/.local/bin $${exe:+-e "$$exe"} 2>&1; \
	done < $(CURDIR)/ubi/tools

# -- macOS ---------------------------------------------------------------------

ifeq ($(OS),Darwin)
.PHONY: all
all: full

.PHONY: packages
packages: brew

full: casks chrome macos touchid-sudo declutter

.PHONY: casks
casks: brew
	$(Q)echo "==> Installing casks..."
	$(Q)$(HOMEBREW_PREFIX)/bin/brew bundle --file $(CURDIR)/brew/Caskfile

.PHONY: macos
macos:
	$(Q)echo "==> Configuring macOS defaults..."
	$(Q)bash $(CURDIR)/macos/defaults.sh

.PHONY: touchid-sudo
touchid-sudo:
	$(Q)echo "==> Enabling Touch ID for sudo..."
	$(Q)sudo cp $(CURDIR)/touchid-sudo/sudo_local /etc/pam.d/sudo_local

.PHONY: chrome
chrome:
	$(Q)echo "==> Configuring Chrome..."
	$(Q)bash $(CURDIR)/chrome/setup.sh || echo "    (skipped — Chrome may be running or not installed)"

.PHONY: declutter
declutter:
	$(Q)echo "==> Removing unwanted apps..."
	$(Q)for app in GarageBand iMovie; do \
		[ -d "/Applications/$$app.app" ] || continue; \
		echo "    $$app"; \
		sudo rm -rf "/Applications/$$app.app"; \
	done

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
	$(Q)echo "==> antidote"
	$(Q)git clone --depth=1 https://github.com/mattmc3/antidote.git $(HOME)/.antidote 2>/dev/null || true
	$(Q)$(SOFTLINK) $(CURDIR)/zsh/zsh_plugins.txt $(HOME)/.zsh_plugins.txt
	$(Q)zsh -c 'source $(HOME)/.antidote/antidote.zsh && antidote load'

.PHONY: bin
bin:
	$(Q)echo "==> bin"
	$(Q)$(SOFTLINK) $(CURDIR)/bin $(HOME)/bin

.PHONY: nvim
nvim: config vim
	$(Q)echo "==> nvim"
	$(Q)$(install-config)
	$(Q)command -v nvim >/dev/null && nvim --headless +'PlugUpdate --sync' +qall 2>/dev/null || true

.PHONY: ssh
ssh:
	$(Q)echo "==> ssh"
	$(Q)mkdir -p $(HOME)/.ssh/
	$(Q)$(SOFTLINK) $(CURDIR)/ssh/config $(HOME)/.ssh/config
	$(Q)$(SOFTLINK) $(CURDIR)/ssh/config.d $(HOME)/.ssh/config.d

.PHONY: starship
starship: config
	$(Q)echo "==> starship"
	$(Q)$(SOFTLINK) $(CURDIR)/starship/starship.toml $(CONFIG)/starship.toml

.PHONY: vim
vim:
	$(Q)echo "==> vim"
	$(Q)$(SOFTLINK) $(CURDIR)/vim $(HOME)/.vim
	$(Q)command -v vim >/dev/null && vim -Es +'PlugInstall --sync' +qall 2>/dev/null || true

.PHONY: wireshark
wireshark: config
	$(Q)echo "==> wireshark"
	$(Q)mkdir -p $(CONFIG)/$@
	$(Q)$(SOFTLINK) $(CURDIR)/$@/profiles $(CONFIG)/$@/profiles

.PHONY: kiro
kiro:
	$(Q)echo "==> kiro"
	$(Q)mkdir -p $(HOME)/.kiro/skills $(HOME)/.kiro/steering $(HOME)/.kiro/settings
	$(Q)$(SOFTLINK) $(CURDIR)/kiro/settings/cli.json $(HOME)/.kiro/settings/cli.json
	$(Q)$(SOFTLINK) $(CURDIR)/kiro/steering/defaults.md $(HOME)/.kiro/steering/defaults.md
	$(Q)$(SOFTLINK) $(CURDIR)/kiro/skills/git-worktree $(HOME)/.kiro/skills/git-worktree

# Create a wrapper ~/.zshrc that sources the dotfiles version. Machine-local
# config lives below the source line, so tools that auto-append PATH entries
# write to the local file instead of dirtying the repo. Skip if ~/.zshrc
# already exists as a regular file to avoid clobbering local config.
.PHONY: zsh
zsh:
	$(Q)echo "==> zsh"
	$(Q)if [ -L $(HOME)/.zshrc ]; then rm $(HOME)/.zshrc; fi
	$(Q)if [ ! -f $(HOME)/.zshrc ]; then echo 'source $(CURDIR)/zsh/zshrc' > $(HOME)/.zshrc; fi

# -- update --------------------------------------------------------------------

.PHONY: update
update: packages
	$(Q)echo "==> Updating antidote plugins..."
	$(Q)zsh -c 'source $(HOME)/.antidote/antidote.zsh && antidote update'
	$(Q)echo "==> Updating vim plugins..."
	$(Q)command -v vim >/dev/null && vim -Es +'PlugUpdate --sync' +qall 2>/dev/null || true
	$(Q)command -v nvim >/dev/null && nvim --headless +'PlugUpdate --sync' +qall 2>/dev/null || true

# -- clean targets -------------------------------------------------------------

TARGETS := bat bin ghostty git kiro macos mise nvim antidote ssh starship tmux touchid-sudo vim wireshark zsh

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

.PHONY: clean-touchid-sudo
clean-touchid-sudo:
	$(Q)sudo rm -f /etc/pam.d/sudo_local

clean-%:
	$(Q)rm -f $(CONFIG)/$*

Makefile: ;

%:: config
	$(Q)echo "==> $@"
	$(Q)$(install-config)
