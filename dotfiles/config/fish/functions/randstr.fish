# vim: noexpandtab

function randstr --description "generate random string of given length"
    set length $argv[1]

    bash -c "
        shuf -er -n $length  {A..Z} {a..z} {0..9} | tr -d '\n'
    "
end

