#!/usr/bin/env zsh

# https://github.com/h-matsuo/macOS-trash/blob/master/trash

# 1st arg is current working directory.
# 2.. args are file/directory which you want to send trash.
if [ "${#}" -lt 2 ]; then
    echo -e "Send files/directories to ~/.Trash"
    exit 1
fi

# Move to cwd.
cd "${1}"
shift

# Move specified files / directories to the trash box
for NAME in "${@}"; do
    # Don't remove "." and ".."
    if [ "${NAME: -1}" = "." ] || [ "${NAME: -1}" = ".." ]; then
        echo "trash: \".\" and \"..\" may not be removed." 1>&2
        continue
    fi

    # Check whether specified file / directory exists
    if [ ! -e "${NAME}" ]; then
        echo "trash: ${NAME}: No such file or directory." 1>&2
        continue
    fi

    # Calculate the absolute path
    TARGET=$(cd `dirname "${NAME}"` && pwd)"/"`basename "${NAME}"`

    # Remove specified file / directory
    osascript -e """
    tell application \"Finder\"
        move POSIX file \"${TARGET}\" to trash
    end tell
    """ > /dev/null
done
