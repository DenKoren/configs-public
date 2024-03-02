# Turn of mouse speed scaling (acceleration)
defaults write GlobalPreferences com.apple.mouse.scaling -1
defaults write -g ApplePressAndHoldEnabled -bool false
defaults write NSGlobalDomain AutomaticQuoteSubstitutionEnabled -bool false

# Allow fish to be default shell for Mac OS X users
if ! grep -q /usr/local/bin/fish /etc/shells; then
    sudo tee -a /etc/shells <<<"/usr/local/bin/fish"
fi

# Change default shell of current user to fish installed by brew
chsh -s /usr/local/bin/fish

cat <<EndOfTip
To setup Mozilla Firefox for Tree Style Tab extension:

* Open Firefox -> Help -> Troubleshooting information
* Copy profile path
* Create <firefox profile path>/chrome/userChrome.css file with contents:
  \`\`\`
  /* hides the native tabs */
  #TabsToolbar {
    visibility: collapse;
  }

  /* hides window title with close/expand buttons */
  #titlebar {
    visibility: collapse;
  }
  \`\`\`
* Open about:config
* Change toolkit.legacyUserProfileCustomizations.stylesheets to true
* Restart Firefox
EndOfTip
