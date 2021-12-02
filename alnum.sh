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
    echo -e "\nprints whether the string is alphanumeric and returns:"
    echo -e "\t0 if string is alphanumeric"
    echo -e "\t1 if string is not alphanumeric"
    echo -e "\t2 on usage error (like this one)"

    return 2
}

# determines whether $1 is an alphanumeric string
function alnum() {
    if [[ "${1}" =~ ^[[:alnum:]]+$ ]]
    then
        echo "alphanumeric"

        return 0
    else
        echo "not alphanumeric"

        return 1
    fi
}

if check_input "${@}"
then
    alnum "${1}"

    exit
else
    print_usage

    exit
fi

