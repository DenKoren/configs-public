# vim: set noexpandtab:

function bell --description 'Ring the bell!'
	printf \a
end

complete \
	--command bell \
	--no-files
