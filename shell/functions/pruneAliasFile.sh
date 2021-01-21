#!/bin/bash
if [ -f "$ALIAS_RC_ROOT" ]; then
    echo "Are you sure to delete the file? Type yes"
    read -r prompt
    if [[ $prompt =~ [yes|y] ]]; then
        true > "$HOME".bash_aliases
    else 
        exit 1
    fi
else 
    echo "File /home/carlo/.bash_aliases does not exist"
fi
