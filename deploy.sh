#!/bin/bash

echo -e "\033[0;32mBuilding updates through hugo...\033[0m"

# Build the project.
hugo # if using a theme, replace with `hugo -t <YOURTHEME>`

echo -e "\033[0;32mDeploying updates to Github...\033[0m"

# Go To Public folder
cd public
# Add changes to git.
git add .

# Commit changes.
msg="rebuilding site `date`"
if [ $# -eq 1 ]
  then msg="$1"
fi
git commit -m "$msg"

echo -e "\033[0;32mPushing to master...\033[0m"

# Push source and build repos.
git push origin master

# Come Back up to the Project Root
cd ..
