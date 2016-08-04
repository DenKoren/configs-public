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

source ~/.config/fish/iterm2_integration.fish
