# vim: set noexpandtab:

function mi.pl.span --description 'Get all log records with given span path'
	set --local span $argv[1]

	jq --compact-output \
		--arg span $span \
		'select(.spanPath) | select(.spanPath | startswith($span))'
end
