#!/bin/bash

RED=$(tput setab 0; tput setaf 1)
NONE=$(tput sgr0)
if [ -f "$ALIAS_RC_ROOT" ]; then
    if [[ -z $(grep $1 < "$ALIAS_RC_ROOT") ]] && ! command -v $1 &> /dev/null
    then
        echo "alias $1='$2'" >> $ALIAS_RC_ROOT
    else 
        echo "${RED}Encountered problems when trying to add alias '$1'${NONE}"
        echo "Alias already exist"; echo "or"; echo "is a valid system command that can not be reserved as an alias"
    fi
else
    echo "File does named $ALIAS_RC_ROOT does not exist"
fi