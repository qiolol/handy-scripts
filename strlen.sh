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
    local -r MIN_ARGS=1

    if (( ${#} < MIN_ARGS ))
    then
        return 1
    fi

    return 0
}

function strlen()
{
    echo -n "${*}" | wc -c
}

if ! parse_arguments "${@}"
then
    print_usage

    exit 1
fi

# To avoid requiring quoting the input string, just take all arguments in as a
# single string.
strlen "${*}"

exit 0
