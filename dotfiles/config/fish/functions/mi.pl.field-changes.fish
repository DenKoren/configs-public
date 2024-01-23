# vim: set noexpandtab:

function mi.pl.field-changes --description 'Get field changes from log records'
	set --local fieldID $argv[1]

	if [ -z $fieldID ]
		jq --compact-output \
			'select(.changesSummary.FieldChanges) |
			{ "txID": .txID, changes: .changesSummary.FieldChanges }'
		return
	end

	if [ (string sub --start=-1 $fieldID) = "*" ]
		set fieldID (string sub --start=1 --end=-1 $fieldID)

		jq --compact-output \
			--arg fID $fieldID \
			'( select(.changesSummary.FieldChanges[]?.fieldID | startswith($fID)) )' |
				uniq |
				jq --compact-output \
					--arg fID $fieldID \
			'{ "txID": .txID, "changes": (
				.changesSummary.FieldChanges |
					map(
						select(.fieldID | startswith($fID))
					) | INDEX(.fieldID)
			) }'

		return
	end

	jq --compact-output \
		--arg fID $fieldID \
		'select(.changesSummary.FieldChanges[$fID]) |
		{ "txID": .txID, "changes": { ($fID): .changesSummary.FieldChanges[$fID] } }'
end
