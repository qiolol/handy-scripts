#!/usr/bin/env bash
# ensures that input consists only of alphanumeric chars

# checks number of args
function check_input() {
    if [[ "${#}" = 1 ]]
    then
        return 0
    fi
    
    return 1
}

function print_usage() {
    echo "usage: alphnum <string>"
    echo -e "\nreturns whether given string consists only of alphanumeric chars"
}

# prints whether, and returns 0 if, $1 is an alphanumeric string
function alphnum() {
    if [[ "${1}" =~ ^[[:alnum:]]+$ ]]
    then
        echo "alphanumeric string"
        
        return 0
    else
        echo "not alphanumeric string"
    
        return 1
    fi
}

if check_input "${@}"
then
    alphnum "${1}"
    
    exit
else
    print_usage
    
    exit 1
fi

