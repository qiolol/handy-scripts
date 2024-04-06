#!/usr/bin/env bash
# converts $3, a positive number as a string, from base $1 to base $2 and prints
# the converted form
#
# NOTE:
# This doesn't support conversion FROM "unusual" bases.
# "Unusual" means anything other than decimal, binary, or hexadecimal.
# This only supports conversion TO "unusual" bases from decimal, binary,
# or hexadecimal.
#
# This is because numeric representation in unusual bases is
# non-standard and the `bc` command won't recognize it. Plus,
# it'd be difficult to parse as valid input; a base 128 number
# system might use the whole ASCII table as valid digits.
#
# As an example, a base 60 numeral convention might use 0-9, A-Z,
# and a-x for its 60 digits (10 + 26 + 24 = 60). In this convention,
# the base 10 number "1,460" is written "OK" in base 60.
# `bc` writes "1,460" as "24 20" in base 60, which is equivalent:
#     - "O" is the base 60 digit for base 10 "24"
#     - "K" is the base 60 digit for base 10 "20"
#     - and 24(60^1) + 20(60^0) = 1440 + 20 = 1460
#
# Handy aliases you can put in your ~/.bashrc, assuming this script is
# somewhere in your $PATH:
# alias dec2bin="num_convert 10 2"
# alias dec2hex="num_convert 10 16"
# alias bin2dec="num_convert 2 10"
# alias bin2hex="num_convert 2 16"
# alias hex2dec="num_convert 16 10"
# alias hex2bin="num_convert 16 2"

# checks number and format of args
function check_input() {
    # correct number of args
    if [[ "${#}" = 3 ]]
    then
        local -r FROM="${1}"
        local -r TO="${2}"
        local -r NUM="${3}"

        # correct arg format
        if [[ "${FROM}" =~ ^2|10|16$ &&
            "${TO}" =~ ^[0-9]+$ &&
            "${NUM}" =~ ^[0-9a-fA-F]+$ ]]
        then
            return 0
        fi
    fi

    return 1
}

function print_usage() {
    echo "Usage: ${0} <from_base> <to_base> <number>"
    echo -e "\tfrom_base can only be 2, 10, or 16"
    echo -e "\tto_base can be anything"
    echo -e "\nconverts a number from one base to another"
    echo "e.g., \"num_convert 10 2 42\" converts \"42\" from decimalt to binary"
}

# converts $3 from base $1 to base $2
function num_convert() {
    local -r FROM="${1}"
    local -r TO="${2}"
    local NUM="${3}"

    if [[ "${FROM}" == "${TO}" ]]
    then
        echo "${NUM}"
    else
        # a priori convert to decimal with Bash built-in
        NUM=$(("${FROM}"#"${NUM}"))

        # if converting to decimal, we're done
        if [[ "${TO}" == "10" ]]
        then
            echo "${NUM}"
        else
            # otherwise, convert from decimal to whatever with `bc`
            NUM="$(echo "obase = ${TO}; ${NUM}" | bc)"

            echo "${NUM}" | tr "[:upper:]" "[:lower:]" # echo hex in lowercase
        fi
    fi
}

if check_input "${@}"
then
    num_convert "${1}" "${2}" "${3}"

    exit 0
else
    print_usage

    exit 1
fi
