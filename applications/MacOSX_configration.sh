# Turn of mouse speed scaling (acceleration)
defaults write GlobalPreferences com.apple.mouse.scaling -1

# Allow fish to be default shell for Mac OS X users
if ! grep -q /usr/local/bin/fish /etc/shells; then
    sudo tee -a /etc/shells <<<"/usr/local/bin/fish"
fi

# Change default shell of current user to fish installed by brew
chsh -s /usr/local/bin/fish
