#!/bin/bash

#
## 

export DIR="$(dirname "$(readlink -f "$0")")"

export USERNAME="Zeph53"
export REPONAME="Random-Scripts"
export GITURL="https://github.com/$USERNAME/$REPONAME.git"

cd $DIR ; 
git init ; 
git pull $GITURL main ; 
git add * ; 
git commit -m 'commit' ; 
git branch -M main ; 
git remote add origin $GITURL ; 
git push -u origin main ;
echo "DONE"
