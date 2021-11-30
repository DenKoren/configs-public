#!/usr/bin/env make --makefile

mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
mkfile_dir := $(shell dirname $(mkfile_path))

.DEFAULT_GOAL := all

require-%:
	@echo "Checking requirement: '$*'"
	@which $*

powerline-fonts:
	@git clone https://github.com/powerline/fonts.git
	@./fonts/install.sh
	@echo "Removing fonts installation directory"
	@rm -rf ./fonts

brewtaps:
	brew tap homebrew/cask-versions

brew-%:
	brew install $*

galaxy-%:
	@ansible-galaxy collection install $*

# -------------------------------- #
# Applications configuration block #
# -------------------------------- #

ansible: \
         require-brew \
         brewtaps \
         brew-ansible \
         brew-mas \
         galaxy-geerlingguy.mac

vim: powerline-fonts
	@mkdir -p ~/.vim/autoload ~/.vim/bundle
	@curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
	@echo "To download spell files, you always can use :verbose set spell command in VIM"

common: ansible
	ansible-playbook --ask-become-pass ansible/common.yaml

3d: ansible
	ansible-playbook --ask-become-pass ansible/3d-printing.yaml

ansible-%: ansible
	ansible-playbook --ask-become-pass ansible/$*.yaml

all: \
     common \
     vim \
     ansible-common
