# vim: noexpandtab

function go-work-ls --description "list modules from go.work in current directory"
	awk '
        BEGIN     { p = 0 }     # do not print anything until "use" block

        /\)/      { p = 0 }     # stop printing lines after ")" line
        p         { print $1 }  # cut leading and ending tab/space characters from each line before printing
        /use \(/  { p = 1 }     # start printing lines after "use (" line

        ' ./go.work
end

