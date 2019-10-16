#
# Verbose and explicit information about git repository.
#
# Latest options documentation: https://github.com/fish-shell/fish-shell/blob/master/share/functions/__fish_git_prompt.fish
#

function __prepend-to-path
    set PATH $argv $PATH
end

# Configure environment
find ~/.config/fish/environments.d -type f -name '*.fish' | while read file
    source $file
end

