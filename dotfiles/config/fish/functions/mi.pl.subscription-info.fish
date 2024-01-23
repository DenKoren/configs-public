# vim: set noexpandtab:

function mi.pl.subscription-info --description 'Get subscription info'
	set --local subscription_id $argv[1]

	if [ -z $subscription_id ]
		jq \
			--compact-output \
			'select(.changesSummary.SubscriptionChanges)'
		return
	end

	jq \
		--compact-output \
		'select(.changesSummary.SubscriptionChanges)' |
		grep $subscription_id
end
