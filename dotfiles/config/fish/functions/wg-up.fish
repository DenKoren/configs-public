# vim: set noexpandtab:

function wg-up --description 'Start wireguard VPN connection'
	set --local interface $argv[1]

	sudo wg-quick up $interface
end

complete \
	--command wg-reconnect \
	--exclusive \
	--arguments "( _list_wg_interfaces )"

