# vim: set noexpandtab:

function sw-brew-bin --description 'Switch default node version by linking it to ~/bin/'
	find /usr/local/opt/$argv[1]/bin -not -type d -perm +0111 |
		while read f
			link-home-bin $f
		end
end

complete \
	--command sw-brew-bin \
	--no-files \
	--arguments "(ls /usr/local/opt/ | grep @)"

