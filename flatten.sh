#!/usr/bin/env bash
# This script "flattens" a directory, moving (or, optionally, copying) all of
# its files, and all of its subdirectories' files, to a destination directory.
#
# In the destination, files that had the same name also get renamed in a way
# that doesn't break extensions and program associations. For example, three
# "foo.png" files that existed throughout the source hierarchy will be
# "foo_2.png", "foo_1.png", and "foo.png" in the destination.

# Checks args, resolving the absolute paths of the input directories via
# `realpath` and taking into account the optional copy flag
function check_input()
{
    # Correct number of args
    if [[ $# == 2 ]]
    then
        readonly COPYING=false
        readonly SOURCE_DIR=$(realpath "${1}")
        readonly DESTINATION_DIR=$(realpath "${2}")

        return 0
    elif [[ $# == 3 && "${1}" == "-c" ]]
    then
        readonly COPYING=true
        readonly SOURCE_DIR=$(realpath "${2}")
        readonly DESTINATION_DIR=$(realpath "${3}")

        return 0
    fi

    return 1
}

# Checks whether the given directories are valid
function check_dirs()
{
    if [[ -d "${1}" && -d "${2}" ]]
    then
        if [[ "${1}" != "${2}" ]]
        then
            return 0
        else
            echo "Input and output directories are the same!"
        fi
    else
        echo -n "Invalid directory: "
        if [[ ! -d "${1}" ]]
        then
            echo "${1}"
        elif [[ ! -d "${2}" ]]
        then
            echo "${2}"
        fi
    fi

    return 1
}

function print_usage()
{
    echo "Usage: flatten [-c] <source> <destination>"
    echo -e "\n\t[-c] Copy, instead of move, files from source to destination"
    echo -e "\t<source> Directory to move or copy files from"
    echo -e "\t<destination> Directory to move or copy files to"
    echo -e "\nMoves or copies all files from <source> and its subdirectories \
to <destination>"
}

# Returns 0 if $1 and $2 are the same directory (regardless of missing trailing
# '/' or extra trailing/leading '/'s) and 1 otherwise
function is_same_dir()
{
    if [[ $(realpath --relative-base="${1}" "${2}")  == "." ]]
    then
        return 0
    fi

    return 1
}

# Moves or copies the $1 directory's files to the $2 directory
function flatten()
{
    if is_same_dir "${1}" "${2}"
    then
        # If $2 was a subdir of $1, we'll eventually have $1 == $2 as we recurse
        # through $1's subdirs. We don't want to copy $1's files into itself, so
        # do nothing.
        return
    fi

    for THING in "${1}"/*
    do
        if [[ -d "${THING}" ]]
        then
            # For subdirectories, recurse, using the stack for a DFS traversal.
            flatten "${THING}" "${2}"
        elif [[ -f "${THING}" ]]
        then
            # For files, move or copy them.
            if [[ $COPYING == true ]]
            then
                # `--backup=numbered` renames destination files whose names
                # would collide with files we're transferring, appending ".~1~"
                # to their filename to disambiguate them from the
                # newly-transferred files.
                cp --preserve=all --backup=numbered "${THING}" "${2}"
            else
                mv --backup=numbered "${THING}" "${2}"
            fi
        fi
    done
}

# Renames the $1 directory's backup files (produced by `cp` or `mv` with the
# option `--backup=numbered`) such that:
#     - "foo.png.~17~" becomes "foo_17.png"
#     - "bar.~17~" becomes "bar_17"
function rename_backups()
{
    for THING in "${1}"/*
    do
        # We'll either have a file like "foo.png.~17~" or "bar.~17~".
        if [[ -f "${THING}" && "${THING}" =~ ^.+~([0-9]+)~$ ]]
        then
            # Get the "17".
            local BACKUP_NUMBER=${BASH_REMATCH[1]}

            # Remove the "~17~", leaving, e.g., "foo.png".
            local SANS_BACKUP_NUMBER="${THING%.*}"

            # Get the filename, "foo", and the extension, "png".
            local FILENAME="${SANS_BACKUP_NUMBER%.*}"
            local EXT="${SANS_BACKUP_NUMBER##*.}"

            if [[ "${FILENAME}" == "${SANS_BACKUP_NUMBER}" ]]
            then
                # This is a "bar.~17~" case, so rename to "bar_17".
                local NEW_NAME="${FILENAME}_${BACKUP_NUMBER}"

                while [[ -f "${NEW_NAME}" ]]
                do
                    # If "bar_17" already exists for some reason, keep
                    # increasing the number until we find an unused one.
                    ((++BACKUP_NUMBER))
                    NEW_NAME="${FILENAME}_${BACKUP_NUMBER}"
                done
            else
                # This is a "foo.png.~17~" case, so rename to "foo_17.png".
                local NEW_NAME="${FILENAME}_${BACKUP_NUMBER}.${EXT}"

                while [[ -f "${NEW_NAME}" ]]
                do
                    ((++BACKUP_NUMBER))
                    NEW_NAME="${FILENAME}_${BACKUP_NUMBER}.${EXT}"
                done
            fi

            mv --no-clobber "${THING}" "${NEW_NAME}"
        fi
    done
}

# Makes sure all files were moved from $2 to $1 (assuming we're moving files and
# $COPYING is false), returning 1 if any files remain in the $1 and 0 otherwise
function look_for_leftovers()
{
    if [[ $COPYING == true ]]
    then
        return 0
    fi

    if is_same_dir "${1}" "${2}"
    then
        # If $2 was a subdir of $1, we'll eventually have $1 == $2 as we recurse
        # through $1's subdirs. We don't care if files are "left over" to where
        # we were transferring them, so do nothing.
        return
    fi

    for THING in "${1}"/*
    do
        if [[ -d "${THING}" ]]
        then
            look_for_leftovers "${THING}"
        elif [[ -f "${THING}" ]]
        then
            echo "WARNING: Files were left over after flattening!"
            echo "Found: ${THING}"

            return 1
        fi
    done

    return 0
}

if check_input "${@}"
then
    if check_dirs "${SOURCE_DIR}" "${DESTINATION_DIR}"
    then
        flatten "${SOURCE_DIR}" "${DESTINATION_DIR}"
        rename_backups "${DESTINATION_DIR}"

        if [[ $COPYING == false ]]
        then
            look_for_leftovers "${SOURCE_DIR}" "${DESTINATION_DIR}"

            exit $? # Exit with `look_for_leftovers()`'s status code.
        else
            exit 0
        fi
    fi

    exit 1
else
    print_usage

    exit 1
fi
