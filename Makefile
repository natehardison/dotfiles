OS := $(shell uname -s)

ifeq ($(OS),Darwin)
FONTS := $(HOME)/Library/Fonts
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

all: fonts links

clean:
	$(Q)rm -f $(FONTS)/Inconsolata-dz.otf
	$(Q)rm -f $(HOME)/bin
	$(Q)rm -f $(HOME)/.bash_aliases
	$(Q)rm -f $(HOME)/.gitconfig
	$(Q)rm -rf $(HOME)/.vim
	$(Q)rm -f $(HOME)/.screenrc
	$(Q)rm -f $(HOME)/.ssh/config
	$(Q)rm -f $(HOME)/.zpreztorc

fonts: prepare
	$(Q)mkdir -p $(FONTS)
	$(Q)/bin/bash fonts/install.sh

ifeq ($(OS),Darwin)
homebrew: prepare
	$(Q)/bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

.PHONY: homebrew
endif

links: prepare
	$(Q)ln -s $(CURDIR)/bash_aliases $(HOME)/.bash_aliases
	$(Q)ln -s $(CURDIR)/bin $(HOME)/bin
	$(Q)ln -s $(CURDIR)/gitconfig $(HOME)/.gitconfig
	$(Q)ln -s $(CURDIR)/vim $(HOME)/.vim
	$(Q)ln -s $(CURDIR)/screenrc $(HOME)/.screenrc
	$(Q)ln -s $(CURDIR)/ssh/config $(HOME)/.ssh/config
	$(Q)ln -s $(CURDIR)/zpreztorc $(HOME)/.zpreztorc

prepare:
	$(Q)git submodule update --init

prezto: prepare
	$(Q)git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"

update:
ifeq ($(OS),Darwin)
	$(Q)brew update && brew doctor
endif

.PHONY: all clean fonts links prepare prezto update
