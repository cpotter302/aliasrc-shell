#!/bin/bash
helpFunction()
{
   echo ""
   echo "Usage: $0 -a <your Alias> -c <base Command>"
   echo -e "\t-a your alias for the specific command"
   echo -e "\t-c the command to execute with your alias"
   exit 1
}

while getopts "a:c:l" opt
do
   case "$opt" in
      a ) alias="$OPTARG" ;;
      c ) command="$OPTARG" ;;
      l ) printAliases ;;
      ? ) helpFunction ;;
   esac
done

# Print helpFunction in case parameters are empty
if [ -z "$alias" ] || [ -z "$command" ]
then
   echo "Some or all of the parameters are empty";
   helpFunction
fi

# Begin script in case all parameters are correct
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NO_COLOR='\033[0m'
CLEAR_LINE='\r\033[K'

#actual script begins here

python3 ./helpers/listFileContent.py $alias "$command"