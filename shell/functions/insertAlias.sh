#!/bin/bash

RED=$(tput setab 0; tput setaf 1)
NONE=$(tput sgr0)
if [ -f "$ALIAS_RC_ROOT" ]; then
    if [[ -z $(grep $1 < "$ALIAS_RC_ROOT") ]]; then
        echo "alias $1='$2'" >> $ALIAS_RC_ROOT
    else 
        echo "${RED}alias already exists, will be removed automatically to avoid conflicts...${NONE}"
    fi
else
    echo "File does named $ALIAS_RC_ROOT does not exist"
fi