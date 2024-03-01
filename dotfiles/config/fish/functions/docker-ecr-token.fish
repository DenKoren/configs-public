# vim: set noexpandtab:

function docker-ecr-token --description 'Get AWS ECR repository login token'
	set --local vault_profile $argv[1]
	set --local image $argv[2] # "<ID>.dkr.ecr.eu-central-1.amazonaws.com/<image tag>"

	set --local region ( string split '.' -f 4 $image )

	aws-vault exec $vault_profile \
		aws ecr get-login-password --region $region
end

