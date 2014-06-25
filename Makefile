# yeah, this doesn't work for all dirs...
MAKEFILE_DIR := $(shell pwd)

all: fonts links

.PHONY: clean fonts links update

clean:
	@rm -f ~/Library/Fonts/Inconsolata-dz.otf
	@rm -f ~/.gitconfig
	@rm -f ~/.janus
	@rm -f ~/.vimrc.before
	@rm -f ~/.vimrc.after
	@rm -f ~/.ssh/config
	@rm -f ~/.zshrc

fonts:
	@cp .janus/Inconsolata-dz.otf ~/Library/Fonts

links:
	@ln -s $(MAKEFILE_DIR)/.gitconfig ~/.gitconfig
	@ln -s $(MAKEFILE_DIR)/.janus ~/.janus
	@ln -s $(MAKEFILE_DIR)/.janus/.vimrc.before ~/.vimrc.before
	@ln -s $(MAKEFILE_DIR)/.janus/.vimrc.after ~/.vimrc.after
	@ln -s $(MAKEFILE_DIR)/.ssh/config ~/.ssh/config
	@ln -s $(MAKEFILE_DIR)/.zshrc ~/.zshrc

update:
	git submodule update
	brew update && brew doctor
	cd ~/.vim && rake && cd -
