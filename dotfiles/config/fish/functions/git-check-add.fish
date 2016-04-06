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


	for _file in (__get_modified_files)
		__announce_section "File $_file"
		git diff $_file
		read -l -p __get_confirmation_prompt correct

		if [ $correct = 'y' ]
			git add $_file
		end
	end

	__announce_section "Final git status"
	git status
end
