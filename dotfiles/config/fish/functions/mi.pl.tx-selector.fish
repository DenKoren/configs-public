# vim: set noexpandtab:

function mi.pl.tx-selector --description 'Generate grep selector for transactions given as input'
	begin
		printf 'grep -E \'"txID":"('
		jq --raw-output 'select(.txID) | .txID' |
			sort |
			paste -s -d '|' - |
			tr -d '\n'
		printf ')"\''
	end |
		pbcopy

	echo "Selector command was copied to the buffer. Use cmd+v"
end
