# vim: set noexpandtab:

function mi.pl.commits --description 'Get transaction commit reports from logs'
	set --local txID $argv[1]

	if [ -z $txID ]
		jq --compact-output\
			'select(.msg == "Transaction commit")'
		return
	end

	jq --compact-output \
		--arg txID $txID \
		'select(.txID == $txID) | 
			select(.msg == "Transaction commit")'
end
