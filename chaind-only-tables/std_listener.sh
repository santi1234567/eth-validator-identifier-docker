#!/usr/bin/env bash

function show_help() {
    cat <<EOF
  usage: $0 ERROR_STR YOUR_PROGRAM

  This script watches the output of a long-running program for a specific error message.
  It will run YOUR_PROGRAM and exit immediately if it sees ERROR_STR in the output.

  Examples:
    $0 "out of memory" my_long_running_program
    $0 "file not found" another_long_running_program
EOF
    exit 1
}

if [ "$1" == "help" ]; then
    show_help
fi

if [ $# -lt 2 ]; then
    show_help
fi

ERR="$1"
echo "Watching for line with words: "$ERR""
shift
"$@" |& while IFS= read -r line; do
    echo "$line"
    if [[ "$line" == *"$ERR"* ]]; then
        echo "Found line with words \"$ERR\". Exiting the program..."
        kill -SIGTERM $$
        exit 0
    fi
    if [[ "$line" == *"error"* ]]; then
        echo "Error on chaind. Exiting the program..."
        kill -SIGTERM $$
        exit 1
    fi
done

exit 1
