# vim: set noexpandtab:

function mi.pl.level --description 'Get records with given logging level'
	set level $argv[1]

	if [ -z $level ]
		set level "error"
	end

	jq --compact-output \
		--arg lvl $level \
		'select(.level | contains($lvl))'
end
