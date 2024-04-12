#!/bin/bash
# (R) hacking y seguridad .com 2024
# lista los ficheros en carpeta local modificados recientemente

find /home/antonio/scan -type f -printf "%T+ %f\n" | sort | tail
