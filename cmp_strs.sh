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
    echo -e "\nreturns whether str_one and str_two are identical"
}

# returns whether two strings are identical
function cmp_strs() {
    if [[ "${1}" == "${2}" ]]
    then
        echo "identical strings"
    else
        echo "different strings"
    fi
}

if check_input "${@}"
then
    cmp_strs "${1}" "${2}"
    
    exit 0
else
    print_usage
    
    exit 1
fi
