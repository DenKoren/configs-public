# vim: set noexpandtab:

function docker-ecr-login --description 'Login Docker CLI in AWS ECR repository'
	set --local vault_profile $argv[1]
	set --local image $argv[2] # "<ID>.dkr.ecr.eu-central-1.amazonaws.com/<image tag>"

	set --local ecr_addr ( string split '/' -f 1 $image )

	docker-ecr-token $vault_profile $image |
		docker login --username AWS --password-stdin $ecr_addr
end
