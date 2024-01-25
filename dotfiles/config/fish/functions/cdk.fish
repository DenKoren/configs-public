# vim: noexpandtab:

function cdk --description "Wrapper of 'cdk' command with aws-vault usage"
	aws-vault exec default -- command cdk $argv
end
