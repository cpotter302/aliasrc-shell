#!/bin/bash

if [ -f "$ALIAS_RC_ROOT" ]; then
  if grep -q "$1" <"$ALIAS_RC_ROOT" && [ -n "$3" ]; then
    functions/deleteAlias.sh "$1"
    echo "alias $1='$2'" >>"$ALIAS_RC_ROOT"
    echo "first"
    exit 1
  elif [ -n "$1" ] && [ "$(functions/printBashAliases.sh | grep "$1"| cut -d'=' -f 1 | awk '{print $2}')" != "$1" ]; then
    echo "alias $1='$2'" >>"$ALIAS_RC_ROOT"
    echo "fs"
    exit 1
  else
    echo "Encountered problems when trying to add alias '$1'"
    [ $? == 1 ] && exit 1
  fi
else
  echo "File named $ALIAS_RC_ROOT does not exist"
fi
