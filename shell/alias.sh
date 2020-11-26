#!/bin/bash
helpFunction() {
  echo "Unknown flag -$1"
  echo "View man pages for further instructions"
  exit 1
}

while getopts ":a:c:g:pde:v" opt; do
  case "$opt" in
  a) alias="$OPTARG" ;; #alias
  c) command="$OPTARG" ;; # command
  g) group="$OPTARG" ;; # print group with -g -c kubectl
  p) print=true ;; # print
  d) delete=true ;; # delete file content
  e) editor=$OPTARG ;; # edit .bash_aliasrc with given editor
  v) verify=true ;;
  ?) helpFunction "$OPTARG" ;;
  esac
done
shift $((OPTIND - 1))


function light_setup() {
  python3 ../python/clean_setup.py "$ALIAS_RC_ROOT" "$1"
  sed -i "1s/.*/#generated by the aliasrc-shell/" "$ALIAS_RC_ROOT"
  exit 1
}

#Check parameters
if [ "$alias" ] && [ "$command" ]; then
  functions/insertAlias.sh "$alias" "$command"

elif [ "$verify" == true ]; then
  light_setup "verify"

elif [ "$group" ] && [ "$print" == true ]; then
  functions/printCommandGroup.sh "$group"

elif [ "$print" == true ]; then
  functions/printBashAliases.sh

elif [ "$delete" == true ] && [ "$alias" ]; then
  functions/deleteAlias.sh "$alias"

elif [ "$delete" == true ] && [ "$group" ]; then
  functions/deleteGroup.sh "$group"

elif [ "$delete" == true ]; then
  functions/pruneAliasFile.sh

elif [ "$editor" ]; then
  functions/editAliases.sh "$editor"

else
  helpFunction
fi

#sort file in every cases, type determined by config file

CONF_FILE=aliasrc.conf
SORT_TYPE=$(grep SORT_TYPE | cut -d'=' -f 2) <"$CONF_FILE"

if [ -f $CONF_FILE ]; then
  if [[ "$SORT_TYPE" == "alph" ]]; then
    sed -i "/\[*\]/d" "$ALIAS_RC_ROOT"
    (sort <"$ALIAS_RC_ROOT") >tmp && mv tmp "$ALIAS_RC_ROOT"
  elif [[ "$SORT_TYPE" == "group-based" ]]; then
    light_setup "light-setup"
  else
    echo "env SORT_TYPE not unknown or not specified in config file => using default group-based sort"
    light_setup "light-setup"
  fi
else
  echo "no config file, using default configuration"
fi

source "$HOME"/.bashrc
