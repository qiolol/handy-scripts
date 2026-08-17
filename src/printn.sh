#!/usr/bin/env bash
# prints char given in $1 the number of times given in $2 times

# checks args and reads in char and number of times to print it
function parse_input() {
    if [[ "${#}" = 2 ]]
    then
        if [[ "${2}" =~ ^([0-9])+$ ]]
        then
            return 0
        fi
    fi

    return 1
}

function print_usage() {
    echo "Usage: ${0} <char> <number>"
    echo -e "\nprints a char the given number of times"
}

# prints $1 $2 times
function printn() {
    for (( i = 0; i < "${2}"; ++i ))
    do
        echo -n "${1}"
    done
    echo # print \n
}

if parse_input "${@}"
then
    printn "${1}" "${2}"

    exit 0
else
    print_usage

    exit 1
fi
