#!/usr/bin/env bash
source color_defs # color_defs.sh linked in $PATH

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
