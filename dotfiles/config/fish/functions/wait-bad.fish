# vim: noexpandtab

function wait-bad --description "run command every second until it exits with non-zero"
	while $argv
		sleep 1
	end
end

