OS := $(shell uname -s)
CONFIG := $(HOME)/.config

# -n: don't follow existing symlinks or descend into directories
SOFTLINK := ln -snf

define install-config
$(SOFTLINK) $(CURDIR)/$@ $(CONFIG)/$@
endef

# -- profiles ------------------------------------------------------------------

.PHONY: minimal
minimal: packages config antidote bat bin git mise ssh starship tmux vim zsh

.PHONY: full
full: minimal ghostty nvim wireshark

# -- package installation ------------------------------------------------------

.PHONY: brew
brew:
	which brew >/dev/null 2>&1 || /bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	brew bundle --file $(CURDIR)/brew/Brewfile

UBI := $(HOME)/.local/bin/ubi
.PHONY: ubi
ubi:
	mkdir -p $(HOME)/.local/bin
	command -v ubi >/dev/null 2>&1 || \
		export TARGET="$(HOME)/.local/bin" && \
		curl --silent --location \
			https://raw.githubusercontent.com/houseabsolute/ubi/master/bootstrap/bootstrap-ubi.sh | sh
	while IFS=: read -r repo exe; do \
		case "$$repo" in ''|\#*) continue;; esac; \
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
	brew bundle --file $(CURDIR)/brew/Caskfile

.PHONY: screenshots
screenshots:
	mkdir -p $(HOME)/screenshots
	defaults write com.apple.screencapture location $(HOME)/screenshots
	killall SystemUIServer

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
	mkdir -p $(HOME)/.config

.PHONY: antidote
antidote:
	git clone --depth=1 https://github.com/mattmc3/antidote.git $(HOME)/.antidote 2>/dev/null || true
	$(SOFTLINK) $(CURDIR)/zsh/zsh_plugins.txt $(HOME)/.zsh_plugins.txt

.PHONY: bin
bin:
	$(SOFTLINK) $(CURDIR)/bin $(HOME)/bin

.PHONY: nvim
nvim: config vim
	$(install-config)
	command -v nvim >/dev/null && nvim +PlugUpdate +qall || true

.PHONY: ssh
ssh:
	mkdir -p $(HOME)/.ssh/
	$(SOFTLINK) $(CURDIR)/ssh/config $(HOME)/.ssh/config
	$(SOFTLINK) $(CURDIR)/ssh/config.d $(HOME)/.ssh/config.d

.PHONY: starship
starship: config
	$(SOFTLINK) $(CURDIR)/starship/starship.toml $(CONFIG)/starship.toml

.PHONY: vim
vim:
	$(SOFTLINK) $(CURDIR)/vim $(HOME)/.vim
	command -v vim >/dev/null && vim +PlugInstall +qall || true

.PHONY: wireshark
wireshark: config
	mkdir -p $(CONFIG)/$@
	$(SOFTLINK) $(CURDIR)/$@/profiles $(CONFIG)/$@/profiles

.PHONY: zsh
zsh:
	$(SOFTLINK) $(CURDIR)/zsh/zshrc $(HOME)/.zshrc

# -- clean targets -------------------------------------------------------------

TARGETS := bat bin ghostty git mise nvim antidote ssh starship tmux vim wireshark zsh

.PHONY: clean
clean: $(foreach target,$(TARGETS),clean-$(target))

.PHONY: clean-antidote
clean-antidote:
	rm -f $(HOME)/.zsh_plugins.txt

.PHONY: clean-bin
clean-bin:
	rm -f $(HOME)/bin

.PHONY: clean-ssh
clean-ssh:
	rm -f $(HOME)/.ssh/config
	rm -f $(HOME)/.ssh/config.d

.PHONY: clean-starship
clean-starship:
	rm -f $(CONFIG)/starship.toml

.PHONY: clean-vim
clean-vim:
	rm -rf $(HOME)/.vim

.PHONY: clean-wireshark
clean-wireshark:
	rm -rf $(CONFIG)/wireshark/profiles

.PHONY: clean-zsh
clean-zsh:
	rm -f $(HOME)/.zshrc

clean-%:
	rm -f $(CONFIG)/$*

Makefile: ;

%:: config
	$(install-config)
