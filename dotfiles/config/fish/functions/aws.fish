# vim: noexpandtab:

function aws --description "Wrapper of 'aws' command with aws-vault usage"
	aws-vault exec default -- command aws $argv
end
