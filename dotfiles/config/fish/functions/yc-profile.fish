# vim: set noexpandtab:

function yc-profile --description 'Change current Yandex.Cloud profile'
	if test (count $argv) -lt 1
		yc config profile list
	else
		yc config profile activate $argv[1]
	end
end

complete \
	--command yc-profile \
	--description "Profile name" \
	--no-files \
	--arguments "(yc config profile list | awk '{print \$1}')"
