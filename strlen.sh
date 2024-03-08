#!/usr/bin/env bash

# Prints a string's length

function print_usage()
{
    echo -e "Usage: ${0} <string>\n\n\
DESCRIPTION
\tPrints the length of the given string
PARAMETERS
\tstring\tThe string to count the length of"
}

function parse_arguments()
{
    local -r REQUIRED_ARGS=1
    local -r MAX_ARGS=1

    if (( ${#} < REQUIRED_ARGS ||
          ${#} > MAX_ARGS ))
    then
        return 1
    fi

    return 0
}

function strlen()
{
    echo -n "${1}" | wc -c
}

if ! parse_arguments "${@}"
then
    print_usage

    exit 1
fi

strlen "${1}"

exit 0
