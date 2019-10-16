#!/usr/bin/env make --makefile

mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
mkfile_dir := $(shell dirname $(mkfile_path))

.DEFAULT_GOAL := laptop

ln-%:
	@echo "Linking '$(mkfile_dir)/$*' to '$(HOME)/.$*'"
	@rm -f "$(HOME)/.$*"
	@ln -fFs "$(mkfile_dir)/$*" "$(HOME)/.$*"

ln-karabiner.d:
	@echo "Linking '$(mkfile_dir)/karabiner.d/configuration' to '$(HOME)/.karabiner.d/configuration'"
	@rm -rf "$(HOME)/.karabiner.d/configuration"
	@mkdir -p "$(HOME)/.karabiner.d"
	@ln -fFs "$(mkfile_dir)/karabiner.d/configuration" "$(HOME)/.karabiner.d/configuration"

configurations: ln-config

bash: ln-profile \
      ln-bashrc \
      ln-bash_aliases \
      ln-bash_completion \
      ln-bash_completion.d \
      ln-bash_functions.d \
      ln-bash_environments.d

karabiner: ln-karabiner.d

py: ln-pyrc

vim: ln-vimrc

mysql: ln-my.cnf

unison: ln-unison

common: configurations \
        bash \
        py \
        mysql \
        vim

server: common

laptop: common \
        unison
