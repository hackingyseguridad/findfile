#!/bin/bash
# (c) hacking y seguridad .com 2022
# lista los ficheros en local modificados recientemente
find / -type f -mtime -1 -print
#find / -type f -mtime -1 -exec ls -ld {} \;
#find . -type d -exec ls -ld {} \;
#ls -alR -lt
