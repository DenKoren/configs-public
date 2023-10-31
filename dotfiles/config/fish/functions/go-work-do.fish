# vim: noexpandtab

function go-work-do --description "run command for each module listed in go.work"
	pushd (git rev-parse --show-toplevel)

	go-work-ls |
		while read module
			echo "Treating $module..."
			pushd "$module"
			$argv
			popd
		end

	popd
end
