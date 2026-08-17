#!/usr/bin/env bash
# Where the color library is depends on whether the scripts were installed.
__libdir="@LIBDIR@" # Replaced by `sed` during `make install`
if [[ -r "${__libdir}/color_defs.sh" ]]
then
    # When installed, get color library from the library directory.
    source "${__libdir}/color_defs.sh"
else
    # When not installed, assume the color library is next to this script.
    __selfdir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
    source "${__selfdir}/color_defs.sh"
fi
unset __libdir __selfdir

# Echo a rainbow-colored "░▒▓█▓▒░"
function echo_rainbow_edge_fade() {
    echo -n "\[${ANSI_BOLD}\]"
    echo -n "\[${RGB_RED}\]░"
    echo -n "\[${RGB_ORANGE}\]▒"
    echo -n "\[${RGB_YELLOW}\]▓"
    echo -n "\[${RGB_GREEN}\]█"
    echo -n "\[${RGB_CYAN}\]▓"
    echo -n "\[${RGB_BLUE}\]▒"
    echo -n "\[${RGB_VIOLET}\]░"
    echo "\[${ANSI_RESET}\]"
}

echo_rainbow_edge_fade "${@}"
