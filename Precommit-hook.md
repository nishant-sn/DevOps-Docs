1. Make a directory inside your git repo on your local machine . Say ".githook"

2. Now make a file named as "pre-commit" and enter the code below if you want to restrict commits to a specific branch :

_#!/bin/sh_

_branch="$(git rev-parse --abbrev-ref HEAD)"_

if [ "$branch" = "master" ]; then

echo "You can't commit directly to master branch"

  exit 1

fi







And Save it. In this case we are restricting commits to master branch .

3. Now make this file executable by this command 
   
    _chmod +x pre-commit_

4. Now go to the main git repo directory where your .git folder is located and run this command to make your ".githook" working :

   **git config core.hooksPath .githook**


Now your commit to master branch will be restricted . 
