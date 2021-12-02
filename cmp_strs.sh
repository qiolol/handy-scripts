#!/usr/bin/env bash

# checks number of args
function check_input() {
    if [[ "${#}" = 2 ]]
    then
        return 0
    fi
    
    return 1
}

function print_usage() {
    echo "usage: cmp_strs <str_one> <str_two>"
    echo -e "\nrprints whether str_one and str_two are identical and returns:"
    echo -e "\t0 if strings are identical"
    echo -e "\t1 if strings are not identical"
    echo -e "\t2 on usage error (like this one)"

    return 2
}

# prints whether (and returns 0 if) $1 and $2 are identical strings
function cmp_strs() {
    if [[ "${1}" == "${2}" ]]
    then
        echo "identical"

        return 0
    else
        echo "different"

        return 1
    fi
}

if check_input "${@}"
then
    cmp_strs "${1}" "${2}"
    
    exit
else
    print_usage
    
    exit
fi
