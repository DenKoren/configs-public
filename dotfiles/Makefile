#!/usr/bin/env make --makefile

mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
mkfile_dir := $(shell dirname $(mkfile_path))

.DEFAULT_GOAL := laptop

ln-%:
	@echo "Linking '$(mkfile_dir)/$*' to '$(HOME)/.$*'"
	@rm -f "$(HOME)/.$*"
	@ln -fFs "$(mkfile_dir)/$*" "$(HOME)/.$*"

configurations: ln-config

bash: ln-profile \
      ln-bashrc \
      ln-bash_aliases \
      ln-bash_completion \
      ln-bash_completion.d \
      ln-bash_functions.d \
      ln-bash_environments.d

py: ln-pyrc

vim: ln-vimrc

unison: ln-unison

common: configurations \
        bash \
        py \
        vim

server: common

laptop: common \
        unison
