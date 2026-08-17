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

# Echo a rainbow-colored "███████"
# Shaded blocks can be used by specifying args:
#     "dark" = ▓
#     "medium" = ▒
#     "light" = ░
# A nice thing about shaded blocks (░▒▓) is that they seem to preserve their
# color when highlighted in the shell (Konsole), but the full block (█) does not.
# In particular, the medium-shade (▒) block's color is identical when highlighted.
function echo_rainbow() {
    local BLOCK="$(echo_block "${1}")"

    echo -n "\[${ANSI_BOLD}\]"
    echo -n "\[${RGB_RED}\]${BLOCK}"
    echo -n "\[${RGB_ORANGE}\]${BLOCK}"
    echo -n "\[${RGB_YELLOW}\]${BLOCK}"
    echo -n "\[${RGB_GREEN}\]${BLOCK}"
    echo -n "\[${RGB_CYAN}\]${BLOCK}"
    echo -n "\[${RGB_BLUE}\]${BLOCK}"
    echo -n "\[${RGB_VIOLET}\]${BLOCK}"
    echo "\[${ANSI_RESET}\]"
}

echo_rainbow "${@}"
