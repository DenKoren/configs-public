# vim: set noexpandtab:

function mi.pl.tx --description 'Get full log of one single transaction'
	set --local txID $argv[1]

	if [ -z $txID ]
		echo "Transaction ID is required"
		return 1
	end

	jq --compact-output \
		--arg txID $txID \
		'select(.txID == $txID)'
end

