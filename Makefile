all: fonts links

clean:
	@rm -f $(HOME)/Library/Fonts/Inconsolata-dz.otf
	@rm -f $(HOME)/bin
	@rm -f $(HOME)/.bash_aliases
	@rm -f $(HOME)/.gitconfig
	@rm -f $(HOME)/.janus
	@rm -f $(HOME)/.vimrc.before
	@rm -f $(HOME)/.vimrc.after
	@rm -f $(HOME)/.ssh/config
	@rm -f $(HOME)/.zshrc

fonts:
	@cp janus/Inconsolata-dz.otf $(HOME)/Library/Fonts

links:
	@ln -s $(CURDIR)/bash_aliases $(HOME)/.bash_aliases
	@ln -s $(CURDIR)/bin $(HOME)/bin
	@ln -s $(CURDIR)/gitconfig $(HOME)/.gitconfig
	@ln -s $(CURDIR)/janus $(HOME)/.janus
	@ln -s $(CURDIR)/janus/vimrc.before $(HOME)/.vimrc.before
	@ln -s $(CURDIR)/janus/vimrc.after $(HOME)/.vimrc.after
	@ln -s $(CURDIR)/ssh/config $(HOME)/.ssh/config
	@ln -s $(CURDIR)/zshrc $(HOME)/.zshrc

update:
	git submodule update
	brew update && brew doctor
	cd $(HOME)/.vim && rake && cd -

.PHONY: all clean fonts links update
