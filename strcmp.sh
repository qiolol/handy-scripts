#!/usr/bin/env bash

# Checks whether two strings are identical

function print_usage() {
    echo -e "Usage: ${0} <stringA> <stringB>\n\n\
DESCRIPTION
\tReports whether the given strings are identical
PARAMETERS
\tstringA\tA string to compare
\tstringB\tA string to compare it to"
}

function parse_arguments()
{
    local -r REQUIRED_ARGS=2
    local -r MAX_ARGS=2

    if (( ${#} < REQUIRED_ARGS ||
          ${#} > MAX_ARGS ))
    then
        return 1
    fi

    return 0
}

function strcmp()
{
    if [[ "${1}" == "${2}" ]]
    then
        echo "Identical strings"

        return 0
    else
        echo "Different strings"

        return 1
    fi
}

if ! parse_arguments "${@}"
then
    print_usage

    exit 1
fi

strcmp "${1}" "${2}"
