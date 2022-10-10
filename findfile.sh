#!/bin/bash
# (c) hacking y seguridad .com 2022
for n in `cat extension.txt`
do
sudo find / -name $n
done
