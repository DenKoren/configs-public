# vim: set noexpandtab:

function wg-restart --description 'Restart WireGuard tunnel'
	set --local interface $argv[1]

	sudo wg-quick down $interface
	sudo wg-quick up $interface

end

complete \
	--command wg-restart \
	--exclusive \
	--arguments "( _list_wg_interfaces )"

