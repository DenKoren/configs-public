# vim: set noexpandtab:

function _yc-prompt --description 'Write active Yandex.Cloud profile name for addition to prompt'
	function __fish_yc_current_profile
		set -l profile (command yc config profile list | awk '/ACTIVE/{print $1}')
		printf '%s' $profile
	end

	if yc version >/dev/null 2>&1
		set_color blue
		printf '(%s)' (__fish_yc_current_profile)
		set_color normal
	end
end
