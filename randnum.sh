#!/usr/bin/env bash
# prints a random number in [0, $1] (inclusive bounds)
# with no $1, the range is [0, 32767]

# checks number and format of args
function check_input() {
    # correct number of args
    if [[ "${#}" -le 1 ]]
    then
        # correct arg format
        if [[ "${#}" = 1 && "${1}" =~ ^[1-9][0-9]*$ || "${#}" = 0 ]]
        then
            return 0
        fi
    fi
    
    return 1
}

function print_usage() {
    echo "usage: randnum [max]"
    echo -e "\nprints a random number in [0, max] (if no max given, [0, 32767])"
}

# prints random number
function randnum() {
    if [[ "${1}" ]]
    then
        shuf -i 0-"${1}" -n1
    else
        echo "${RANDOM}" # [0, 32767]
    fi
}

if check_input "${@}"
then
    randnum "${1}"
    
    exit 0
else
    print_usage
    
    exit 1
fi
