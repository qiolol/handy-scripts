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

# Echo random-colored blocks "███████" with `$1` shading
#
# Shading can be used by specifying `$1` as:
#     "dark" = ▓
#     "medium" = ▒
#     "light" = ░
#
# Each of the seven blocks is randomly colored one of seven rainbow colors:
#     1. Red
#     2. Orange
#     3. Yellow
#     4. Green
#     5. Cyan
#     6. Blue
#     7. Violet
# This means that getting all 7 of the same color is a 7/7^7 (~0.00085%) chance!
#
# On special occasions, other colors are used instead.
function echo_randbow() {
    local RET=""

    # Pick the colors.
    local -a COLORS
    local -r MONTH=$(date +%m)
    case "${MONTH}" in
        10) # October: halloweenbow
            COLORS=(
                "${RGB_ORANGE}"
                "${RGB_YELLOW}"
                "${RGB_VIOLET}"
                "${RGB_GREEN}"
                "${RGB_DARK_GRAY}"
            )
            ;;
        12) # December: xmasbow
            COLORS=(
                "${RGB_RED}"
                "${RGB_GREEN}"
                "${RGB_WHITE}"
            )
            ;;
        *) # Every other month: rainbow
            COLORS=(
                "${RGB_RED}"
                "${RGB_ORANGE}"
                "${RGB_YELLOW}"
                "${RGB_GREEN}"
                "${RGB_CYAN}"
                "${RGB_BLUE}"
                "${RGB_VIOLET}"
            )
            ;;
    esac

    # Draw the blocks.
    local -r NUM_BLOCKS=7
    local RANDOM_COLOR=""
    local BLOCK="$(echo_block "${1}")"
    for (( i = 0; i < $NUM_BLOCKS; ++i ))
    do
        RANDOM_COLOR="${COLORS[${RANDOM} % ${#COLORS[@]}]}"
        RET+="\[${ANSI_BOLD}\]\[${RANDOM_COLOR}\]${BLOCK}\[${ANSI_RESET}\]"
    done

    echo "${RET}"
}

echo_randbow "${@}"
