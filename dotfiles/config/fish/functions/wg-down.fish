# vim: set noexpandtab:

function wg-down --description 'Stop wireguard VPN connection'
	set --local interface $argv[1]

	sudo wg-quick down $interface
end

complete \
	--command wg-reconnect \
	--exclusive \
	--arguments "( _list_wg_interfaces )"

