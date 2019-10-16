set -g PROJECT_HOME ~/work/personal
set -g VIRTUALFISH_HOME ~/work/personal/python

if python3 -c "import virtualfish" 2>/dev/null
    eval (python3 -m virtualfish projects)
end

