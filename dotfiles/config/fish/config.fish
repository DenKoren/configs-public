#
# Verbose and explicit information about git repository.
#
# Latest options documentation: https://github.com/fish-shell/fish-shell/blob/master/share/functions/__fish_git_prompt.fish
#
set -g __fish_git_prompt_show_informative_status 1
set -g __fish_git_prompt_char_upstream_prefix " "
set -g __fish_git_prompt_color_branch yellow

set -g __fish_git_prompt_color_dirtystate cyan
set -g __fish_git_prompt_color_stagedstate yellow
set -g __fish_git_prompt_color_invalidstate red
set -g __fish_git_prompt_color_untrackedfiles $fish_color_normal
set -g __fish_git_prompt_color_cleanstate green

set -g PROJECT_HOME ~/work/personal
set -g VIRTUALFISH_HOME ~/work/personal/python

if python3 -c "import virtualfish" 2>/dev/null
    eval (python3 -m virtualfish projects)
end

# To download shell integration script:
#    curl -SsL https://iterm2.com/misc/fish_startup.in > ~/.config/fish/iterm2_integration.fish
source ~/.config/fish/iterm2_integration.fish
