# vim: set noexpandtab:

function wg-reconnect --description 'Restart WireGuard tunnel'
	set --local interface $argv[1]

	sudo wg-quick down $interface
	sudo wg-quick up $interface

end

function _list_wg_interfaces
	ls /usr/local/etc/wireguard/ | 
		tr '[:upper:]' '[:lower:]' | 
		sed 's/\.conf$//'
end

complete \
	--command wg-reconnect \
	--exclusive \
	--arguments "( _list_wg_interfaces )"

