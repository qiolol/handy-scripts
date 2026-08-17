#!/usr/bin/env bash
# Echoes a "█"
#
# Shaded blocks can be used by specifying arg `1` as:
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
