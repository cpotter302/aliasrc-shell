#!/bin/bash

RED=$(tput setab 0; tput setaf 1)
NONE=$(tput sgr0)

if [ -f "$ALIAS_RC_ROOT" ]; then
    if [[ -z $(grep "$1" < "$ALIAS_RC_ROOT") ]]; then
        echo "could not find group : ${RED}$1${NONE} in alias file"
    else 
        sed -i "/$1/d" "$ALIAS_RC_ROOT" && echo \
            "deleted group: $1"
    fi
else
    echo "File does named $ALIAS_RC_ROOT does not exist"
fi
