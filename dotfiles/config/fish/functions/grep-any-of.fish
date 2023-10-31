# vim: set noexpandtab:

function grep-any-of --description 'Generates "grep" command that matches any of lines specified in input'
	sed 's/|/\\\|/' | 
		paste -d '|' -s - |
		awk '{ printf "grep -E \'(%s)\'", $0 }' |
		pbcopy
	echo "Command was saved to buffer. Use CMD+V to insert it into command line"
end
