#!/bin/bash
if [ -f /home/carlo/.bash_aliasrc ]; then
    cat /dev/null > /home/carlo/.bash_aliasrc
else 
    echo "File /home/carlo/.bash_aliasrc does not exist"
fi
