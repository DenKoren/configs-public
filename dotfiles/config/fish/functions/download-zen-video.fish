# vim: set noexpandtab:

function download-zen-video --description 'Download video from Yandex.Zen'
	set --local video_url $argv[1]
	set --local out_file $argv[2]
	set --local debug false

	set --local user_agent 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0) Gecko/20100101 Firefox/102.0'

	function _grep_media_url
		set --local pattern 'https://[^"]+\.m3u8'

		grep \
			--extended-regexp \
			--only-matching \
			$pattern \
			| head -n 1
	end

	function _get_media_url
		set --local url $argv[1]
		set --local user_agent $argv[2]
		curl \
			--silent \
			--header "User-Agent: $user_agent" \
			$url \
			| _grep_media_url
	end

	if [ -z $video_url ]
		echo "Usage: download-zen-video <video URL>"
		return 1
	end

	set --local media_url (_get_media_url $video_url $user_agent)

	echo "Media URL: $media_url"
	echo "Out file: $out_file"

	ffmpeg \
		-user_agent $user_agent \
		-loglevel warning \
		-i $media_url \
		$out_file
end
