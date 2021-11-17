# vim: set noexpandtab:

function brewpath --description 'Add brew package\'s bin/sbin to current PATH'
	set --local pkg_path_prefix '/usr/local/opt'
	set --local pkg_to_add $argv[1]
	set --local pkg_name (string split @ -f 1 $pkg_to_add)

	if set --show PATH | grep --quiet $pkg_to_add
		echo "$pkg_path_prefix/$pkg_to_add already is in the PATH"
		return 0
	end

	set --show PATH |
		awk -F ':' "/$pkg_name/{print \$1}" |
		string split '$' -f 2 |
		while read old_version
			set --erase $old_version
		end

	if test -d $pkg_path_prefix/$pkg_to_add/bin
		set PATH $pkg_path_prefix/$pkg_to_add/bin $PATH
	end

	if test -d $pkg_path_prefix/$pkg_to_add/sbin
		set PATH $pkg_path_prefix/$pkg_to_add/sbin $PATH
	end
end

complete \
	--command brewpath \
	--no-files \
	--arguments "(ls /usr/local/opt/ | grep '@')"
