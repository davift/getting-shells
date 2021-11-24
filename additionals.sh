#!/bin/bash

#
# version 1
# date 2021-11-22
# https://github.com/davift/getting-shells
#

clear

function box_out() {
  input_char=$(echo "$@" | wc -c)
  line=$(for i in `seq 0 $input_char`; do printf "─"; done)
  tput bold
  tput setaf 7
  space=${line//─/ }
  echo "┌${line}┐"
  printf '│ ' ; echo -n "$@"; printf "%s\n" ' │';
  echo "└${line}┘"
  tput sgr 0
}

function box_title() {
  tput bold
  tput setaf 6
  echo "┌────────────────────────────────┐"
  echo "│                                │"
  echo "│  GETTING SHELLS - ADDITIONALS  │"
  echo "│                                │"
  echo "└────────────────────────────────┘"
  tput sgr0
}

function box_exited() {
  tput bold
  tput setaf 6
  echo "┌────────┐"
  echo "│ EXITED │"
  echo "└────────┘"
  tput sgr0
  exit 0
}

function box_red() {
#  tput bold
  tput setaf 1
  echo "$@"
  tput sgr0
}

function box_green() {
#  tput bold
  tput setaf 2
  echo "$@"
  tput sgr0
}

####

box_title;

box_out "Testing..."

which nc > /dev/null && box_green "Original NetCat - OK" || sudo apt install netcat -y"
which bash > /dev/null && box_green "Bash - OK" || sudo apt install bash -y"
which sh > /dev/null && box_green "Shell - OK" || box_red "Shell NOT installed!"
which ncat > /dev/null && box_green "NMAP's NetCat - OK" || sudo apt install ncat -y
which pwncat > /dev/null && box_green "PwnCat - OK" || pip install pwncat
which rustcat > /dev/null && box_green "RustCat - OK" || curl -s https://raw.githubusercontent.com/robiot/rustcat/main/pkg/debian-install.sh | sudo bash
which zsh > /dev/null && box_green "Zsh - OK" || sudo apt install zsh -y
which perl > /dev/null && box_green "Perl - OK" || sudo apt install perl -y
which python3 > /dev/null && box_green "Python3 - OK" || sudo apt install python3 -y
which php > /dev/null && box_green "PHP - OK" || sudo apt install php -y

box_exited;

exit 0
