#!/bin/bash
helpFunction()
{
   echo "Unknown flag -$1"
   echo "View man pages for further instructions"
   exit 1
}

while getopts ":a:c:g:pde:" opt
do
   case "$opt" in
      a ) alias="$OPTARG" ;; #alias
      c ) command="$OPTARG" ;; # command
      g ) group="$OPTARG";; # print group with -g -c kubectl
      p ) print=true ;; # print
      d ) delete=true ;; # delete file content
      e ) editor=$OPTARG ;;# edit .bash_aliasrc with given editor
      ? ) helpFunction $OPTARG;;
   esac
done
shift $((OPTIND -1))

export ALIAS_RC_ROOT=~/.bash_aliasrc

#Check parameters
if [ "$alias" ] && [ "$command" ]; then
   functions/insertAlias.sh $alias "$command"

elif [ "$group" ] && [ "$print" == true ]; then
   functions/printCommandGroup.sh "$group"

elif [ "$print" == true ]; then
   functions/printBashAliases.sh

elif [ "$delete" == true ] && [ "$alias" ]; then
   functions/deleteAlias.sh "$alias"

elif [ "$delete" == true ] && [ "$group" ]; then 
   functions/deleteGroup.sh "$group"

elif [ "$delete" == true ] && [ $( whoami ) == "root" ]; then
   functions/pruneAliasFile.sh

elif [ "$delete" == true ] && [ ! $( whoami ) == "root" ]; then
   echo "run command as sudo user" && exit 1

elif [ "$editor" ]; then
   functions/editAliases.sh "$editor"

else 
   helpFunction
fi

# sort file in every cases

cat $ALIAS_RC_ROOT | sort > tmp && mv tmp $ALIAS_RC_ROOT

python3 ../python/clean_setup.py "$ALIAS_RC_ROOT" "light-setup"

#clean file from potential wrong patterns

#python3 ../python/clean_setup.py "$ALIAS_RC_ROOT" "setup"

#insert group names

#python3 ../python/clean_setup.py "$ALIAS_RC_ROOT" "insert"
