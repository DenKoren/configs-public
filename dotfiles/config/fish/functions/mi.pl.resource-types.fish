# vim: set noexpandtab:

function mi.pl.resource-types --description 'Match resource ID and type'
	set --local resourceType $argv[1]

	jq --compact-output \
		'select(.changesSummary.ResourceChanges) |
			.changesSummary.ResourceChanges[] | 
			{ "resourceID": .resourceID, "resourceType": .resourceType }
		' |
		if [ -n $resourceType ]
			jq --compact-output --arg rType $resourceType 'select(.resourceType | test($rType))'
		else
			jq --compact-output .
		end
end

