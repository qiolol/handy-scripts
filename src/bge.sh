#!/usr/bin/env bash
# bge
# └┼┼ack
#  └┼─round
#   └──xecute
# just an alias to background execute something with output piped to /dev/null
function bge() {
    $("${@}" &>/dev/null &)
}

bge "${@}"
