# vim: set noexpandtab:

function _list_wg_interfaces
	ls /usr/local/etc/wireguard/ | 
		tr '[:upper:]' '[:lower:]' | 
		sed 's/\.conf$//'
end
