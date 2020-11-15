#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NO_COLOR='\033[0m'
CLEAR_LINE='\r\033[K'

git clone https://github.com/cpotter302/aliasrc-shell.git ~

export ALIAS_RC_ROOT=~/.bash_aliasrc
mv "$PWD"/alias.sh /bin/aliasrc && \
mv "$HOME"/aliasrc-shell /usr/lib

touch $ALIAS_RC_ROOT &&
  echo "if [ -f ~/$ALIAS_RC_ROOT ]; then
        . ~/$ALIAS_RC_ROOT
      fi" >> ~/.bashrc &&
  source "$HOME"/.bashrc

printf "🔎   checking dependencies"

if ! command -v python3 >/dev/null; then
  printf "${CLEAR_LINE}💀${RED}   You must install python3 on your system before setup can continue${NO_COLOR}\n"
  printf "ℹ️   On Ubuntu-Linux🍎 you should 'sudo apt install python'\n"
  exit
fi


printf "Succesfully installes aliasrc-shell"
printf "view man pages for further instructions"
