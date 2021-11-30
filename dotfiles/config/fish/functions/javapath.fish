# vim: set noexpandtab:

function javapath --description 'Add brew package\'s bin/sbin to current PATH'
# /Library/Java/JavaVirtualMachines/temurin-11.jdk/Contents/Home/bin/
	set --local java_path_prefix '/Library/Java/JavaVirtualMachines'
	set --local java_to_add $argv[1]
	set --local java_name (string split - -f 1 $java_to_add)

	if set --show PATH | grep --quiet $java_to_add
		echo "$java_path_prefix/$java_to_add already is in the PATH"
		return 0
	end

	set --show PATH |
		awk -F ':' "/$java_name/{print \$1}" |
		string split '$' -f 2 |
		while read old_version
			set --erase $old_version
		end

	set PATH $java_path_prefix/$java_to_add/Contents/Home/bin $PATH
end

complete \
	--command javapath \
	--no-files \
	--arguments "(ls /Library/Java/JavaVirtualMachines)"
