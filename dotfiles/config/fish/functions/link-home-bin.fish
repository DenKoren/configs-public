# vim: set noexpandtab:

function link-home-bin --description 'link any file to ~/bin'
	set --local orig_exec_path $argv[1]
	if not test -x $orig_exec_path
		echo "'$orig_exec_path' is not executable"
		return 1
	end
		
	ln -sf $orig_exec_path ~/bin/
end

complete \
	--command link-home-bin \
	--force-files

