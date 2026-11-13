#!/usr/bin/env bash
# Converts a video file to an MP3

function print_usage()
{
    echo -e "\
USAGE
\t${0} <video>...

EXAMPLE
\t${0} \"Rick Astley - Never Gonna Give You Up [dQw4w9WgXcQ].webm\"
\t${0} *.mp4 *.webm

DESCRIPTION
\tConverts the given video file(s) to MP3, output to the current working
\tdirectory.

\tCover art from the video and metadata tags from the filename get baked into
\tthe output. If the filename is in \"Artist - Title\" format, the artist and
\ttitle tags are encoded into the MP3's metadata. Otherwise, the filename is
\tused as the title tag.

\tFor example, \"Rick Astley - Never Gonna Give You Up [dQw4w9WgXcQ].webm\"
\twould generate an MP3 with the artist tag \"Rick Astley\" and the title tag
\t\"Never Gonna Give You Up\" (without the \"[dQw4w9WgXcQ]\"). Multiple '-'s are
\talso supported; \"Pink Floyd - Eclipse - Live\" would yield
\tartist \"Pink Floyd\" and title \"Eclipse - Live\"." >&2
}

# One temp folder for the cover images, deleted when the script exits.
TMP=$(mktemp -d)
readonly TMP
readonly COVER="${TMP}/cover.png"
trap 'rm -rf "${TMP}"' EXIT

function vid_to_mp3()
{
    local VIDEO="${1}"
    local OUT_MP3=""
    local -a ART
    local TITLE="${VIDEO##*/}"  # Strip any leading directories
    TITLE="${TITLE%.*}"         # Strip the extension
    # Strip video IDs like "dQw4w9WgXcQ" in "Country Roads [dQw4w9WgXcQ].webm".
    [[ $TITLE =~ ^(.*)\ \[[A-Za-z0-9_-]{11}\]$ ]] && TITLE="${BASH_REMATCH[1]}"
    # Split "Artist - Title" (only if there's a " - " in the name)
    local ARTIST=""
    if [[ $TITLE == *" - "* ]]
    then
        # Everything before the first " - "
        ARTIST="${TITLE%% - *}"

        # Everything after the first " - "
        TITLE="${TITLE#* - }"
    fi
    # Files without the "Artist - Title" format just get the title tag.
    if [[ -n "${ARTIST}" ]]
    then
        OUT_MP3="${ARTIST} - "
    fi
    OUT_MP3+="${TITLE}.mp3"

    # Skip files that were already converted so the script can be safely re-run.
    if [[ -e ${OUT_MP3} ]]
    then
        return 0
    fi

    # Find the stream index of an embedded cover image, if there is one.
    local PIC
    PIC=$(ffprobe -v error -select_streams v \
            -show_entries stream=index:stream_disposition=attached_pic \
            -of csv=p=0 "${VIDEO}" | awk -F, '$2==1 {print $1; exit}')

    # Step 1: Save the cover art to a temporary image.
    #
    # When downloaded via yt-dlp, MP4s downloaded with `--embed-thumbnail`
    # already contain the real thumbnail as an image stream. This uses that
    # thumbnail when it's there and falls back to grabbing a frame otherwise.
    #
    # To crop the picture to a square, add
    # ```
    # -vf "crop='min(iw,ih)':'min(iw,ih)',scale=500:500"
    # ```
    # before `-c:v png` in both commands below.
    rm -f "${COVER}"
    if [[ -n ${PIC} ]]
    then
        # Use the embedded thumbnail.
        ffmpeg -nostdin -hide_banner -loglevel error -y \
            -i "${VIDEO}" -map "0:${PIC}" \
            -frames:v 1 -c:v png -update 1 "${COVER}"
    else
        # Grab a frame from the video. Skipping 5 seconds in avoids a
        # black first frame.
        ffmpeg -nostdin -hide_banner -loglevel error -y \
            -ss 5 -i "${VIDEO}" -map 0:v:0 \
            -frames:v 1 -c:v png -update 1 "${COVER}"
    fi
    # If no cover could be made (no video stream, or a video shorter than
    # 5 seconds), convert the audio without album art instead of failing.
    if [[ -s ${COVER} ]]
    then
        ART=(-i "${COVER}" -map 1:0 -c:v copy -disposition:v attached_pic
             -metadata:s:v title="Album cover"
             -metadata:s:v comment="Cover (front)")
    else
        echo "NOTE: no cover art for ${VIDEO}" >&2
        ART=()
    fi

    # Step 2: Convert the full audio and attach the gathered metadata.
    if ffmpeg -nostdin -hide_banner -loglevel error -n \
        -i "${VIDEO}" "${ART[@]}" \
        -map 0:a:0 \
        -c:a libmp3lame -b:a 320k \
        -id3v2_version 3 \
        -metadata title="${TITLE}" \
        -metadata artist="${ARTIST}" \
        "${OUT_MP3}"
    then
        return 0
    else
        echo "FAILED: ${VIDEO}" >&2
        return 1
    fi
}

if [[ $# -lt 1 ]]
then
    print_usage
    exit 1
fi

STATUS=0
for VIDEO in "$@"
do
    vid_to_mp3 "${VIDEO}" || STATUS=1
done
exit "${STATUS}"
