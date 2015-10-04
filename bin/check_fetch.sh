#!/usr/local/bin/bash

## Check if fetchmail is running

IS_ALIVE=`ps auxwww | grep fetchmail | grep -v grep`

if [ -n "$IS_ALIVE" ]; then
    echo "" > /dev/null
#    echo "fetchmail is running..." | wall
else
    echo "fetchmail is NOT running..." | wall
fi
