#!/usr/bin/env bash

# Checks whether two strings are identical

function print_usage() {
    echo -e "Usage: ${0} <stringA> <stringB>\n\n\
DESCRIPTION
\tReports whether the given strings are identical
PARAMETERS
\tstringA\tThe first string
\tstringB\tThe second string"
}

function parse_arguments()
{
    local -r REQUIRED_PARAMS=2
    local -r MAX_PARAMS=2

    if (( ${#} < REQUIRED_PARAMS ||
          ${#} > MAX_PARAMS ))
    then
        return 1
    fi

    return 0
}

if ! parse_arguments "${@}"
then
    print_usage

    exit 1
fi

# Compare the strings.
if [[ "${1}" == "${2}" ]]
then
    echo "Identical strings"

    exit 0
else
    echo "Different strings"

    exit 1
fi
