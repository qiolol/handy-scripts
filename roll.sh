#!/usr/bin/env bash
# rolls X dice with Y sides, where $1 = "[Xd]Y"
# dedikated to Kate x3

# checks args and reads in number of dice and sides
function parse_input() {
    # correct number of args
    if [[ "${#}" = 1 ]]
    then
        # correct arg format
        if [[ "${1}" =~ ^([1-9][0-9]*)*([dD]{0,1}([1-9][0-9]*)){0,1}$ ]]
        then
            # parse input
            DICE=1
            SIDES=0

            if [[ "${BASH_REMATCH[1]}" && "${BASH_REMATCH[3]}" ]]
            then
                # "1d12"
                DICE="${BASH_REMATCH[1]}"
                SIDES="${BASH_REMATCH[3]}"
            elif [[ "${BASH_REMATCH[2]}" ]]
            then
                # "d12"
                SIDES="${BASH_REMATCH[3]}"
            else
                # "12"
                SIDES="${BASH_REMATCH[1]}"
            fi
            
            return 0
        fi
    fi
    
    return 1
}

function print_usage() {
    echo -e "usage: roll <[Xd]Y>"
    echo -e "\nrolls X dice with Y sides"
    echo "e.g., \"1d12\", \"d12\", and \"12\" all roll one 12-sided die"
}

# rolls dice
function roll() {
    local TOTAL=0

    for i in $(seq 1 "${DICE}")
    do
        local ROLL=$(shuf -i 1-"${SIDES}" -n 1)
        TOTAL=$(( TOTAL + ROLL ))

        # if many dice, print each one
        if [[ "${DICE}" -gt 1 ]]
        then
            echo "Die ${i}: ${ROLL}"
        fi
    done
    echo "${TOTAL}"
}

if parse_input "${@}"
then
    roll
    
    exit 0
else
    print_usage
    
    exit 1
fi
