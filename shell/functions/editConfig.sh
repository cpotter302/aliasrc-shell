#!/bin/bash
if [ -f "$ALIAS_RC_ROOT" ]; then
    "$1" "$2"
else
    echo "Target file: $ALIAS_RC_ROOT does not exist on local drive"
fi