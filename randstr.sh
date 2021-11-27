#!/usr/bin/env bash
# prints random Base64 ASCII chars (how many specified in $1)

# checks number and format of args
function check_input() {
    # correct number of args
    if [[ "${#}" = 1 ]]
    then
        # correct arg format
        if [[ "${1}" =~ ^[0-9]+$ ]]
        then
            return 0
        fi
    fi
    
    return 1
}

function print_usage() {
    echo "usage: randstr <number_of_chars>"
}

# prints random strings
function randstr() {
    echo "$(base64 -w 0 /dev/urandom | head -c "${1}")"
}

if check_input "${@}"
then
    randstr "${1}"
    
    exit 0
else
    print_usage
    
    exit 1
fi
