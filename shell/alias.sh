#!/bin/bash
helpFunction()
{
   echo "Argument unknown"
   echo "Usage: $0 view man pages for further instructions"
   exit 1
}

while getopts "a:c:g:pde:" opt
do
   case "$opt" in
      a ) alias="$OPTARG" ;; #alias
      c ) command="$OPTARG" ;; # command
      g ) group="$OPTARG";; # print group with -g -c kubectl
      p ) print=true ;; # print
      d ) delete=true ;; # delete file content
      e ) editor=$OPTARG ;;# edit .bash_aliasrc with given editor
      ? ) helpFunction ;;
   esac
done
shift $((OPTIND -1))

export ALIAS_RC_ROOT=~/.bash_aliasrc
#Check parameters
if [ "$alias" ] && [ "$command" ]; then
   python3 ../python/switcher.py "insert" "$alias" "$command"
elif [ "$group" ] && [ "$print" == true ]; then
   functions/printCommandGroup.sh $group
elif [ "$print" == true ]; then
   functions/printBashAliases.sh
elif [ "$delete" == true ] && [ "$alias" ]; then
   python3 ../python/switcher.py "deleteA" "$alias"
elif [ "$delete" == true ] && [ "$group" ]; then 
   python3 ../python/switcher.py "deleteG" "$group"
elif [ "$delete" == true ] && [ $( whoami ) == "root" ]; then
   functions/pruneAliasFile.sh
elif [ "$delete" == true ] && [ ! $( whoami ) == "root" ]; then
   echo "run command as sudo user" && exit 1
elif [ "$editor" ]; then
   functions/editAliases.sh "$editor"
else 
   helpFunction
fi