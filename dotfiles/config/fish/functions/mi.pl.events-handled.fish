# vim: set noexpandtab:

function mi.pl.events-handled --description 'Get flat list of events handled by transactions'

	set --local eventID $argv[1]

	if [ -z $eventID ]
		jq --compact-output \
			'select(.changesSummary.EventsHandled) |
				{"txID": .txID, "events": .changesSummary.EventsHandled}'

		return
	end

	jq --compact-output \
		--arg eID $eventID \
		'select(.changesSummary.EventsHandled) |
			{"txID": .txID, "events": .changesSummary.EventsHandled} |
			select(.events[] | contains($eID))'

end

