#!/usr/bin/env bash

start_block=$1
start_block_arg="--eth1deposits.start-block="+"$start_block"

set -- "$@" "$start_block_arg"

echo "Watching for line with words: \"eth1deposits\" and \"Caught\""
shift
"$@" |& while IFS= read -r line; do
    echo "$line"
    if [[ "$line" == *"eth1deposits"* && "$line" == *"Caught"* ]]; then
        echo "Found line with words \"eth1deposits\" and \"Caught\". Exiting the program..."
        kill -SIGTERM $$
        exit 0
    fi
    if [[ "$line" == *'"level":"error"'* ]]; then
        echo "Error on chaind. Exiting the program..."
        kill -SIGTERM $$
        exit 1
    fi
done
