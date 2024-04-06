#!/usr/bin/env bash
# prints char $1 in the "W×H" dimensions specified in $2

# checks args and reads in char and dimensions in which to print it
function parse_input() {
    # correct number of args
    if [[ "${#}" = 2 ]]
    then
        # correct arg format
        if [[ "${2}" =~ ^([0-9]+)[xX]([0-9]+)$ ]]
        then
            readonly HORIZONTAL_CHARS="${BASH_REMATCH[1]}"
            readonly VERTICAL_CHARS="${BASH_REMATCH[2]}"

            return 0
        fi
    fi

    return 1
}

function print_usage() {
    echo "Usage: ${0} <char> <dimensions>"
    echo -e "\nprints a char in the given \"WxH\" dimensions (W across, H down)"
}

# prints $1 in $HORIZONTAL_CHARS × $VERTICAL_CHARS dimensions
function printnxn() {
    for (( i = 0; i < "${VERTICAL_CHARS}"; ++i ))
    do
        for (( j = 0; j < "${HORIZONTAL_CHARS}"; ++j ))
        do
            echo -n "${1}"
        done
        echo # print \n
    done
}

if parse_input "${@}"
then
    printnxn "${1}"

    exit 0
else
    print_usage

    exit 1
fi
