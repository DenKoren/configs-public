#!/usr/bin/env make --makefile

mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
mkfile_dir := $(shell dirname $(mkfile_path))

.DEFAULT_GOAL := all

requireapp-%:
	@echo "Checking application: '$*'"
	@test -d "/Applications/$(*).app"

require-%:
	@echo "Checking requirement: '$*'"
	@which $*

install-powerline-fonts:
	@git clone https://github.com/powerline/fonts.git
	@./fonts/install.sh
	@echo "Removing fonts installation directory"
	@rm -rf ./fonts

install-vim: install-powerline-fonts
	brew install --override-system-vi vim

install-%:
	brew install $*

# -------------------------------- #
# Applications configuration block #
# -------------------------------- #

productivity: requireapp-Karabiner \
              requireapp-Seil \
              requireapp-BetterTouchTool \
              requireapp-Alfred\ 2

messangers: requireapp-Viber \
            requireapp-Skype \
            requireapp-Telegram

applications-requirements: productivity \
                           messangers \
                           requireapp-KeePassX \
                           requireapp-Dropbox \
                           requireapp-Yandex.Disk \
                           requireapp-VLC \
                           requireapp-Wunderlist \
                           requireapp-VirtualBox \
                           requireapp-XCode

karabiner: requireapp-Karabiner
	$(mkfile_dir)/applications/karabiner.sh

applications: applications-requirements \
              karabiner

packages: require-brew \
          install-bash-completion \
          install-git \
          install-vim

all: packages
