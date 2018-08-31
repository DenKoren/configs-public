function git-check-add --description 'Check git diff before adding a file'

	function __announce_section
		echo ""
		set_color yellow
		echo "----------------------------------------------------"
		echo "	$argv"
		echo "----------------------------------------------------"
		set_color normal
		echo ""
	end

	function __repo_root
		 command git rev-parse --show-toplevel
	end

	function __format_file
		phpcf apply $argv
	end

	function __get_modified_files
		git status --porcelain | awk '/^[^R]M /{print substr($0, 4);}'
		git status --porcelain | awk -F ' -> ' '/^RM /{print $2;}'
	end

	function __get_confirmation_prompt
		echo -n "Is diff correct? ["
		set_color green
		echo -n 'y'
		set_color normal
		echo -n '/'
		set_color red
		echo -n 'N'
		set_color normal
		echo -n '] '
	end

	set _current_repo_root (__repo_root)

	for _file in (__get_modified_files)
		set _abs_path $_current_repo_root/$_file

		__announce_section "File $_file"
		__format_file $_abs_path
		git diff $_abs_path
		read -l -p __get_confirmation_prompt correct

		if [ $correct = 'y' ]
			git add $_abs_path
		end
	end

	__announce_section "Final git status"
	git status
end
