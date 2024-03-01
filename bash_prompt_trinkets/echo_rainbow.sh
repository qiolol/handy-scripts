#!/usr/bin/env bash
source color_defs # color_defs.sh linked in $PATH

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
