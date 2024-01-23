# vim: set noexpandtab:

function mi.pl.notifications-generated --description 'get list of notifications generated by transactions'
	jq \
		'select(.changesSummary.NotificationsGenerated) |
		{
			"txID": .txID, "notifications": .changesSummary.NotificationsGenerated
		}'
end

