#!/usr/bin/env bash

# An ergonomic `find` wrapper for searching for files
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
