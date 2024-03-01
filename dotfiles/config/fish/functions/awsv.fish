# vim: noexpandtab:

function awsv --description "Wrapper of 'aws' command with aws-vault usage"
	aws-vault exec mi-new -- command aws $argv
end
