#!/bin/bash
if [ -f /home/carlo/.bash_aliasrc ]; then
    echo "Are you sure to delete the file? Type yes"
    read prompt
    if [[ $prompt =~ [yes|y] ]]; then
        true > /home/carlo/.bash_aliasrc
        cat /home/carlo/.bash_aliasrc
    else 
        exit 1
    fi
else 
    echo "File /home/carlo/.bash_aliasrc does not exist"
fi
