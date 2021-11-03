# vim: set noexpandtab:

function unlink-brew-bin --description 'Remove brew version override from ~/bin/'
	find ~/bin -type l |
		while read candidate
			if readlink $candidate |
				grep --quiet "/usr/local/opt/$argv[1]"
					rm $candidate
			end
		end
end

function _home_bin_brew_candidates
	find ~/bin -type l |
		xargs readlink |
		awk -F'/' '/\/usr\/local\/opt\//{print $5}' |
		sort -u
end

complete \
	--command unlink-brew-bin \
	--no-files \
	--arguments "(_home_bin_brew_candidates)"

