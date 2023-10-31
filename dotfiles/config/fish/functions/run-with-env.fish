# vim: noexpandtab

function run-with-env --description "run command with given environment. Usage: run-with-env <env file> <cmd with args>"
	for line in ( cat $argv[1] | grep -E -v '^[[:space:]]*(#|[[:space:]]*$)' )
		set item (string split -m 1 '=' $line)
		set -x $item[1] $item[2]
	end

	$argv[2..-1]
end
