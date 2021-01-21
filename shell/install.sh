#!/bin/bash

#[[ "$EUID" -eq 0 ]]
#test $? -eq 0 || echo "Run script with sudo rights" && exit 1

red=$(tput setaf 1)
green=$(tput setaf 2)
reset=$(tput sgr0)
empty_line=$(echo -e "\n")
root=aliasrc-shell

git clone https://github.com/cpotter302/"$root".git

echo "$empty_line"

alias_path=~/.bash_aliases
bashrc_path="$HOME"/.bashrc


cat <<EOF
---------------------------------
-- 1/4 🔎 ${green}checking dependencies"${reset} --
---------------------------------
EOF

declare -a commands=("python3" "python3-pip")
for package in "${commands[@]}"; do

  if [ "$package" == "python3-pip" ]; then
    apt_package="pip3"
  else
    apt_package="python3"
  fi

  if ! command -v "$apt_package" >/dev/null; then
    echo -e "💀 You must install ${red}$apt_package${reset} on your system before setup can continue\n"
    echo -e "To install automatically by the script enter 'yes'\n"
    read -r prompt
    if [[ $prompt =~ [yes|y] ]]; then
      sudo apt-get update &&
        sudo apt install -y \
      "$package"
    else
      echo -e "install packages manually by running:\n"
      cat <<EOF
      sudo apt-get update &&
      sudo apt install -y \
      python3 \
      python3-pip
EOF
      exit 1
    fi
  else
    printf "apt-package %s already installed \xE2\x9C\x94 \n" "$package"
  fi
done

cat <<EOF
---------------------------------
-- 2/4  🔎 ${green}Installing Python packages"${reset} --
---------------------------------
EOF
sudo pip3 install -r "$root"/requirements.txt

[ -d /usr/lib/alirc ] && echo -e "${red}ERROR${reset}: Sources already found on target location /usr/lib/alirc" && rm -rf "$root" && exit 1

([ -f $alias_path ] && grep -q "ALIAS_RC_ROOT" "$bashrc_path" &&
  echo "export ALIAS_RC_ROOT=$alias_path" >>"$bashrc_path") ||
  (touch $alias_path && echo "export ALIAS_RC_ROOT=$alias_path" >>"$bashrc_path")

cat <<EOF
---------------------------------
-- 3/4  🔎 ${green}Installing manual page"${reset} --
---------------------------------
EOF
sudo -s -- <<EOF
  cp -v $root/alirc.man /usr/share/man/man8/alirc.8 &&
  gzip /usr/share/man/man8/alirc.8
  echo -e "\nSuccessfully installed man pages."
EOF

cat <<EOF
---------------------------------
-- 4/4  🔎 ${green}Copying sources"${reset} --
---------------------------------
EOF
sudo -s -- <<EOF
  sed -i -e 's/\r$//' "$root"/shell/functions/*.sh &&
  mkdir -p /usr/lib/alirc &&
  mv -v "$PWD"/"$root"/shell/alias.sh /bin/alirc &&
  mv "$PWD"/"$root"/* /usr/lib/alirc
  chmod +x /bin/alirc
  echo -e "\nAll done."
EOF

rm -rf "$root"

cat <<EOF
-> Succesfully installed "$root"
-> removed cloned sources...
!! view the ${green}manual pages${reset} ('man alirc') for further instructions !!
$empty_line
----------------------------------------------
-- RUN ${red}source ~/.bashrc${reset} to activate changes --
----------------------------------------------
EOF

#TODO: remove sources / envs script / create symlink to from /usr/bin/ to /bin | remove redundancy from multiple execution
