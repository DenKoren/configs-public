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

brew-%:
	brew install $*

galaxy-%:
	@ansible-galaxy install $*

# -------------------------------- #
# Applications configuration block #
# -------------------------------- #

ansible: \
         require-brew \
         brew-ansible \
         galaxy-geerlingguy.homebrew \
         galaxy-geerlingguy.mas

vim: powerline-fonts
	@mkdir -p ~/.vim/autoload ~/.vim/bundle
	@curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim

common: ansible
	ansible-playbook --ask-become-pass ansible/common.yaml

badoo: ansible
	ansible-playbook --ask-become-pass ansible/badoo.yaml

all: \
     common \
     badoo \
     vim
