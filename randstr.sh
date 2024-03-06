#!/usr/bin/env bash

# Prints a random string

function print_usage()
{
    echo -e "Usage: ${0} [OPTIONS] <length>\n\n\
DESCRIPTION
\tPrints a random alphanumeric string
PARAMETERS
\tlength
\t\tThe number of characters in the string
OPTIONS
\t-a
\t\tUse only alphabetic characters (upper- and lowercase letters)
\t-d
\t\tUse only numeric characters
\t-n
\t\tDon't print a newline after the string"
}

function parse_options()
{
    while getopts "adn" NAME
    do
        case "${NAME}" in
            a) readonly "${MODE_ALPHABETIC:=true}" ;;
            d) readonly "${MODE_NUMERIC:=true}" ;;
            n) readonly "${NO_NEWLINE:=true}" ;;
            ?) return 1 ;;
        esac
    done

    # Since they're mutually exclusive, only one of the optional modes should
    # have been chosen.
    if [[ -v MODE_ALPHABETIC &&
          -v MODE_NUMERIC ]]
    then
        return 1
    fi

    return 0
}

function parse_parameters()
{
    local -r REQUIRED_PARAMS=1
    local -r MAX_PARAMS=1

    if (( ${#} < REQUIRED_PARAMS ||
          ${#} > MAX_PARAMS ))
    then
        return 1
    fi

    if [[ "${1}" =~ ^[[:digit:]]+$ ]]
    then
        readonly LENGTH="${1}"
    fi

    # Check for required parameter.
    if [[ ! -v LENGTH ]]
    then
        return 1
    fi

    return 0
}

function parse_arguments()
{
    if ! parse_options "${@}"
    then
        return 1
    fi

    shift $((OPTIND-1))

    if ! parse_parameters "${@}"
    then
        return 1
    fi

    return 0
}

function randstr()
{
    local MODE="[:alnum:]" # Alphanumeric by default

    # Apply optional mode
    if [[ -v MODE_ALPHABETIC ]]
    then
        MODE="[:alpha:]"
    elif [[ -v MODE_NUMERIC ]]
    then
        MODE="[:digit:]"
    fi

    head -c "${LENGTH}" <(tr -dc "${MODE}" < /dev/urandom)

    if [[ ! -v NO_NEWLINE ]]
    then
        echo
    fi
}

if ! parse_arguments "${@}"
then
    print_usage

    exit 1
fi

randstr

exit 0
