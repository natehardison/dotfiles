OS := $(shell uname -s)

ifeq ($(OS),Darwin)
FONTS := $(HOME)/Library/Fonts
PKG_INSTALLER := brew
else
FONTS := $(HOME)/.fonts
PKG_INSTALLER := sudo apt-get
endif

all: fonts links

clean:
	@rm -f $(FONTS)/Inconsolata-dz.otf
	@rm -f $(HOME)/bin
	@rm -f $(HOME)/.bash_aliases
	@rm -f $(HOME)/.gitconfig
	@rm -f $(HOME)/.janus
	@rm -f $(HOME)/.vimrc.before
	@rm -f $(HOME)/.vimrc.after
	@rm -f $(HOME)/.ssh/config
	@rm -f $(HOME)/.zshrc

distclean: clean


fonts:
	@mkdir -p $(FONTS)
	@cp janus/Inconsolata-dz.otf $(FONTS)

ifeq ($(OS),Darwin)
homebrew:
	@ruby -e "$$(curl -fsSL https://raw.github.com/mxcl/homebrew/go)"
endif

links:
	@ln -s $(CURDIR)/bash_aliases $(HOME)/.bash_aliases
	@ln -s $(CURDIR)/bin $(HOME)/bin
	@ln -s $(CURDIR)/gitconfig $(HOME)/.gitconfig
	@ln -s $(CURDIR)/janus $(HOME)/.janus
	@ln -s $(CURDIR)/janus/vimrc.before $(HOME)/.vimrc.before
	@ln -s $(CURDIR)/janus/vimrc.after $(HOME)/.vimrc.after
	@ln -s $(CURDIR)/ssh/config $(HOME)/.ssh/config
	@ln -s $(CURDIR)/zshrc $(HOME)/.zshrc

packages:
	@PKG_INSTALLER packages.txt

update:
	git submodule update
	brew update && brew doctor
	cd $(HOME)/.vim && rake && cd -

.PHONY: all clean fonts links update
