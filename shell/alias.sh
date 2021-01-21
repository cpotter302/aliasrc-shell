#!/bin/bash
helpFunction() {
  echo "Unknown flag -$1"
  echo "View man pages for further instructions"
  exit 1
}

bash_sources=/usr/lib/alirc/shell/functions
python_sources=/usr/lib/alirc/python

while getopts ":a:c:g:pde:vo" opt; do
  case "$opt" in
  a) alias="$OPTARG" ;; #alias
  c) command="$OPTARG" ;; # command
  g) group="$OPTARG" ;; # print group with -g -c kubectl
  p) print=true ;; # print
  d) delete=true ;; # delete file content
  e) editor=$OPTARG ;; # edit .bash_aliasrc with given editor
  v) verify=true ;;
  o) overwrite=true ;;
  ?) helpFunction "$OPTARG" ;;
  esac
done
shift $((OPTIND - 1))

function light_setup() {
  python3 $python_sources/clean_setup.py "$ALIAS_RC_ROOT" "$1"
  sed -i "1s/.*/#generated by the aliasrc-shell/" "$ALIAS_RC_ROOT"
}
#sort file in every cases, type determined by config file
CONF_FILE=aliasrc.conf
SORT_TYPE=$( (grep SORT_TYPE | cut -d'=' -f 2) <"/usr/lib/alirc/$CONF_FILE")



if [ -f "/usr/lib/alirc/$CONF_FILE" ]; then
  if [[ "$SORT_TYPE" == "alph" ]]; then
    sed -i "/\[*\]/d" "$ALIAS_RC_ROOT"
    ( cat <"$ALIAS_RC_ROOT" | sort ) >tmp && mv tmp "$ALIAS_RC_ROOT"
  elif [[ "$SORT_TYPE" == "group-based" ]]; then
    light_setup "light-setup"
  else
    echo "env SORT_TYPE unknown or not specified in config file => using default group-based sort"
    light_setup "light-setup"
  fi
else
  echo "no config file, using default configuration"
fi

#Check parameters
if [ "$alias" ] && [ "$command" ]; then
  $bash_sources/insertAlias.sh "$alias" "$command" "$overwrite"

elif [ "$verify" == true ]; then
  light_setup "verify"

elif [ "$group" ] && [ "$print" == true ]; then
  $bash_sources/printCommandGroup.sh "$group"

elif [ "$print" == true ]; then
  $bash_sources/printBashAliases.sh

elif [ "$delete" == true ] && [ "$alias" ]; then
  $bash_sources/deleteAlias.sh "$alias"

elif [ "$delete" == true ] && [ "$group" ]; then
  $bash_sources/deleteGroup.sh "$group"

elif [ "$delete" == true ]; then
  $bash_sources/pruneAliasFile.sh

elif [ "$editor" ]; then
  $bash_sources/editAliases.sh "$editor"

else
  helpFunction
fi

