#!/usr/bin/env bash

# An ergonomic `find` wrapper for searching for files
#
# For example, to search for files with the extension `.txt` (case insensitive)
# recursively in the current directory tree, run:
# ```
# files "*.txt"
# ```
function files()
{
    find . -iname "*${*}*"
}

if [[ $# < 1 ]]
then
    echo "Usage: ${0} <filename_pattern>"

    exit 1
fi

files "${*}"
