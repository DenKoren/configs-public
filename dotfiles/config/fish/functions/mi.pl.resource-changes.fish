# vim: set noexpandtab:

function mi.pl.resource-changes --description 'Get resource changes from log records'
	set --local resourceID $argv[1]

	if [ -z $resourceID ]
		jq --compact-output \
			'select(.changesSummary.ResourceChanges) |
			{ "txID": .txID, changes: .changesSummary.ResourceChanges }'
		return
	end

	jq --compact-output \
		--arg fID $resourceID \
		'select(.changesSummary.ResourceChanges[$fID]) |
		{ "txID": .txID, "changes": { ($fID): .changesSummary.ResourceChanges[$fID] } }'
end
