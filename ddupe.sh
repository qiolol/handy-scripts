#!/usr/bin/env bash
# dd wrapper that provides a progress bar
# copies the blocks of device $1 to device $2

# checks number of args
function check_input() {
    if [[ "${#}" = 2 ]]
    then
        return 0
    fi
    
    return 1
}

function print_usage() {
    echo "usage: ddupe </source/device> </destination/device>"
    echo -e "\ncopies the blocks of /source/device to /destination/device"
}

function ddupe() {
    pv "${1}" | sudo dd of="${2}"
}

if check_input "${@}"
then
    ddupe "${1}" "${2}"
    
    exit 0
else
    print_usage
    
    exit 1
fi
