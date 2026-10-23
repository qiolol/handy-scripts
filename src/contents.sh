#!/usr/bin/env bash

# An ergonomic `grep`/`rg` wrapper for searching file contents
#
# NOTE: `rg` treats input as regex by default. So, if the pattern string
# contains characters like '$', use SINGLE-QUOTES and ESCAPE them: `'\$'`
# (Otherwise, '$' will be treated as a regex anchor AND Bash will try expanding
# it to make matters worse.)
function contents()
{
    if [[ $# > 1 ]]
    then
        rg "${1}" -i --iglob "*${2}*"
    else
        rg -i "${1}"
    fi
}

if [[ $# < 1 || $# > 2 ]]
then
    echo "Usage: ${0} <pattern> [filename_pattern]"

    exit 1
fi

contents "${@}"
