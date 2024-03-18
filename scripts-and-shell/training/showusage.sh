#!/bin/sh

show_usage() {
    echo "Usage: $0 source_dir dest_dir" 1>&2
    if [ $# -eq 0 ]; then
        exit 99
    else
        exit $1
    fi
}

if [ $# -ne 2 ]; then
    show_usage
else # There are two arguments
    if [ -d "$1" ]; then
        source_dir="$1"
    else
        echo "Error: $1 is not a directory." 1>&2
        show_usage
    fi
    if [ -d "$2" ]; then
        dest_dir="$2"
    else
        echo "Error: $2 is not a directory." 1>&2
        show_usage
    fi
fi

printf "Copying files from %s to %s\n" "$source_dir" "$dest_dir"
