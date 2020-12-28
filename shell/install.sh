#!/bin/bash

set -eu -o pipefail

sudo -n true

test $? -eq 0

[[ -z "$1" ]] > /dev/null || ( [[ "$1" == "ssh" ]] &&
git clone git@github.com:cpotter302/aliasrc-shell.git ) ||
git clone https://github.com/cpotter302/aliasrc-shell.git

alias_path=~/.bash_aliases
bashrc_path="$HOME"/.bashrc

( [ -f $alias_path ] && grep -q "ALIAS_RC_ROOT" "$bashrc_path" &&
echo "export ALIAS_RC_ROOT=$alias_path" >>"$bashrc_path" ) ||
( touch $alias_path && echo "export ALIAS_RC_ROOT=$alias_path" >>"$bashrc_path" )

echo "# autogenerated by aliasrc" >>"$alias_path"

printf "🔎   checking dependencies\n"

if ! command -v python3 > /dev/null; then

  printf "💀 You must install python3 and pip3 on your system before setup can continue\n"

  echo -e "To install automatically by the script enter 'yes'\n"

  read -r prompt
  if [[ $prompt =~ [yes|y] ]]; then
    sudo apt-get update &&
    sudo apt install -y \
    python3 \
    python3-pip
  else
    printf "ℹ️   On Ubuntu-Linux🍎 you should 'sudo apt install python'\n"
    printf "Run script again after finishing to install missing dependencies"
    exit 1
  fi
else
  sudo pip3 install -r aliasrc-shell/requirements.txt
fi


[ -d /usr/lib/alirc ] && echo "Sources already found on target location /usr/lib/alirc" && exit 1

echo "Copying source files"
sudo -s -- << EOF
  sed -i -e 's/\r$//' aliasrc-shell/shell/functions/*.sh &&
  mkdir -p /usr/lib/alirc &&
  mv "$PWD"/aliasrc-shell/shell/alias.sh /bin/alirc &&
  mv "$PWD"/aliasrc-shell/* /usr/lib/alirc
  chmod +x /bin/alirc
  echo "All done."
EOF

rm -rf aliasrc-shell &&
cat << EOF
-> Succesfully installed aliasrc-shell
-> removed cloned sources...
-> view man pages for further instructions
-- RUN source ~/.bashrc to activate changes --
EOF

#TODO: remove sources / envs script / create symlink to from /usr/bin/ to /bin | remove redundancy from multiple execution
