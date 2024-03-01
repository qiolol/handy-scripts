#!/usr/bin/env bash
# Echo a "█". Shaded blocks can be used by specifying args:
#     "dark" = ▓
#     "medium" = ▒
#     "light" = ░
function echo_block() {
    if [ "${1}" = dark ] ; then
        echo "▓"
    elif [ "${1}" = "medium" ] ; then
        echo "▒"
    elif [ "${1}" = "light" ] ; then
        echo "░"
    else
        echo "█"
    fi
}

echo_block "${@}"
