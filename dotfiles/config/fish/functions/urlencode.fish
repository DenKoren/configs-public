# vim: set noexpandtab:

function urlencode --description 'Encode input with urlencode'
	jq --raw-input --raw-output '@uri'
end
