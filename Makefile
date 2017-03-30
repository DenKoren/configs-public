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

install-mas:
	brew install argon/mas/mas

install-%:
	brew install $*

app-install-%:
	brew cask install $*

# -------------------------------- #
# Applications configuration block #
# -------------------------------- #

productivity: \
              app-install-karabiner-elements \
              app-install-bettertouchtool \
              app-install-alfred

messangers: \
            app-install-skype \
            app-install-telegram

applications-requirements: \
                           requireapp-Yandex.Disk \
                           requireapp-Wunderlist \
                           requireapp-XCode

applications: \
              applications-requirements \
              require-brew \
              productivity \
              messangers \
              app-install-keepassx \
              app-install-dropbox \
              app-install-vlc \
              app-install-virtualbox

packages: require-brew \
          install-bash-completion \
          install-bash-git-prompt \
          install-git \
          install-vim \
          install-jq \
          install-mas

all: packages
