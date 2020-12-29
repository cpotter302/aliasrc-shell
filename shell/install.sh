#!/bin/bash

#[[ "$EUID" -eq 0 ]]
#test $? -eq 0 || echo "Run script with sudo rights" && exit 1

git clone https://github.com/cpotter302/aliasrc-shell.git

alias_path=~/.bash_aliases
bashrc_path="$HOME"/.bashrc

([ -f $alias_path ] && grep -q "ALIAS_RC_ROOT" "$bashrc_path" &&
  echo "export ALIAS_RC_ROOT=$alias_path" >>"$bashrc_path") ||
  (touch $alias_path && echo "export ALIAS_RC_ROOT=$alias_path" >>"$bashrc_path")
  
printf "🔎   checking dependencies\n"

declare -a commands=("python3" "python3-pip")
for package in "${commands[@]}"; do
  if ! command -v "$package" >/dev/null; then
    echo -e "💀 You must install $package on your system before setup can continue\n"
    echo -e "To install automatically by the script enter 'yes'\n"
    read -r prompt
    if [[ $prompt =~ [yes|y] ]]; then
      sudo apt-get update &&
        sudo apt install -y \
          "$package"
    else
      echo "install packages mannualy by running:"
      cat << EOF
      sudo apt-get update &&
      sudo apt install -y \
      python3 \
      python3-pip
EOF
      exit 1
    fi
  else
    sudo pip3 install -r aliasrc-shell/requirements.txt
  fi
done

[ -d /usr/lib/alirc ] && echo "Sources already found on target location /usr/lib/alirc" && exit 1

echo "Copying source files"
sudo -s -- <<EOF
  sed -i -e 's/\r$//' aliasrc-shell/shell/functions/*.sh &&
  mkdir -p /usr/lib/alirc &&
  mv "$PWD"/aliasrc-shell/shell/alias.sh /bin/alirc &&
  mv "$PWD"/aliasrc-shell/* /usr/lib/alirc
  chmod +x /bin/alirc
  echo "All done."
EOF

rm -rf aliasrc-shell &&
  cat <<EOF
-> Succesfully installed aliasrc-shell
-> removed cloned sources...
-> view man pages for further instructions
-- RUN source ~/.bashrc to activate changes --
EOF

#TODO: remove sources / envs script / create symlink to from /usr/bin/ to /bin | remove redundancy from multiple execution
