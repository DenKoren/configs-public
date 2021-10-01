#
# Verbose and explicit information about git repository.
#
# Latest options documentation: https://github.com/fish-shell/fish-shell/blob/master/share/functions/__fish_git_prompt.fish
#

function __prepend-to-path
    if [ -e $argv ]
        set PATH $argv $PATH
    end
end

# Configure environment
find ~/.config/fish/environments.d -type f -name '*' | while read file
    source $file
end
