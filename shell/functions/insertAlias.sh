#!/bin/bash

if [ -f "$ALIAS_RC_ROOT" ]; then
  if ! grep -q "$1" <"$ALIAS_RC_ROOT"; then
    echo "alias $1='$2'" >>"$ALIAS_RC_ROOT"
  elif grep -q "$1" <"$ALIAS_RC_ROOT" && [ -n "$3" ]; then
    functions/deleteAlias.sh "$1"
    echo "alias $1='$2'" >>"$ALIAS_RC_ROOT"
  else
    echo "Encountered problems when trying to add alias '$1'"
    [ $? == 1 ] && exit 1
  fi
else
  echo "File named $ALIAS_RC_ROOT does not exist"
fi

