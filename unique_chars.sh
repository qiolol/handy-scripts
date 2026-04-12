#!/usr/bin/env bash
# Prints the set of unique characters that compose the input, which can be fed
# either as arguments or a piped/redirected file:
# ```
# unique_chars.sh foo "bar baz"
# unique_chars.sh "$(input.txt)"
# unique_chars.sh < input.txt
# cat input.txt | unique_chars.sh
# ```
declare -a UNIQUE_CHARS

function gather_unique_chars()
{
    STR="${1}"

    for (( i = 0; i < ${#STR}; ++i ))
    do
        CURR_CHAR="${STR:i:1}" # `i`th char
        NEW_CHAR=true

        for STORED_CHR in "${UNIQUE_CHARS[@]}"
        do
            if [[ "${STORED_CHR}" == "${CURR_CHAR}" ]]
            then
                NEW_CHAR=false
                continue
            fi
        done

        if "${NEW_CHAR}"
        then
            UNIQUE_CHARS+=("${CURR_CHAR}")
        fi
    done
}

if (( $# > 0 ))
then
    # Read input from arguments.
    gather_unique_chars "${*}"
else
    # Read input from stdin.
    if [[ -t 0 ]]
    then
        # Interactive (the user's typing or pasting stuff in): read one line...
        read -r LINE
        gather_unique_chars "${LINE}"

        # ...then read any additional lines that are available (for example,
        # when the user pasted clipboard content that contains newlines) using a
        # timeout sufficiently tiny that it won't wait for further typing.
        GOT_PASTED_CONTENT=false
        while read -r -t 0.05 LINE
        do
            GOT_PASTED_CONTENT=true
            gather_unique_chars "${LINE}"
        done
        if "${GOT_PASTED_CONTENT}"
        then
            echo # Leading newline to separate output from pasted input
        fi
    else
        # Non-interactive (the input was piped or redirected): read all lines.
        while read -r LINE
        do
            gather_unique_chars "${LINE}"
        done
    fi
fi

# Print the set of unique characters.
set -f
for UNIQUE_CHR in "${UNIQUE_CHARS[@]}"
do
    printf '%s' "$UNIQUE_CHR"
done
set +f
echo # Trailing newline

exit 0
