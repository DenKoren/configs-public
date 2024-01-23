# vim: set noexpandtab:

function mi.pl.db-keys --description 'Get list of keys affected by transaction'
	jq --raw-output '.keysWritten[], .keysRead[]'
end
