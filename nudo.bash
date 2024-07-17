#!/bin/bash
#
## A script to launch a program as a normal user
#
## Run command as a normal user instead of root, while still using root's files
if [[ $@ ]]; then
    if [ "`id -u`" -eq 0 ]; then 
        adduser --no-create-home --home /$USER --gecos --disabled-password --disabled-login --ingroup "users" "nudo"
    else
        printf "Why bother running as a normal user when you are one?\n" 
    fi 
        sudo --user "nudo" $@
        userdel --force "nudo" ; printf "Deleted nudo\n"
else
    printf "ADD A PROGRAM AS ARGUMENT\nFor example: $ nudo.bash /home/user/scripts/a-script.sh\n"
fi
