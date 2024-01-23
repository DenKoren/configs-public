# vim: noexpandtab

function wait-good --description "run command every second until it exits with zero"
	while ! $argv
		sleep 1
	end
end
