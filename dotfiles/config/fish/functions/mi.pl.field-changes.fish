# vim: set noexpandtab:

function mi.pl.field-changes --description 'Get field changes from log records'
	set --local fieldID $argv[1]

	jq --compact-output \
		'select(.changesSummary.FieldChanges) |
		{ "txID": .txID, changes: .changesSummary.FieldChanges }' |
		if [ -n $fieldID ]
			jq --compact-output \
				--arg fID $fieldID \
				'{ "txID": .txID, "changes": (
					.changes |
						map(
							select(.fieldID | test($fID))
						) | INDEX(.fieldID)
				) } | select(.changes != {})'
		else
			jq --compact-output .
		end
end
