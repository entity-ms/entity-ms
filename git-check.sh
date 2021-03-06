#!/bin/bash

## gitcheck:
##   Check all git repositories in subdirectories, and list the ones with changes
##   30/07/2011, AstroFloyd, bzrcheck
##   18/01/2013, Astrofloyd, gitcheck

# Initialise counters:
let count_all=0
let count_changed=0
let count_unchanged=0

# Set to 1 for more verbose output:
let verbose=0

# Find git repos and loop over them:
for repo in `find . -type d -name ".git"`
do
  let count_all=${count_all}+1

  # cd to the dir that contains .git/:
  dir=`echo ${repo} | sed -e 's/\/.git/\//'`
  cd ${dir}

  git_status=($(git status -s))

  # If there are changes, print some status and branch info of this repo:
  if [ ! ${#git_status[@]} -eq 0 ]; then
    echo -e "\n \E[1;31m ${dir}\E[0m"
    git status -s
    let count_changed=${count_changed}+1
  else
    if [ ${verbose} -ne 0 ]; then echo "Nothing to do for ${dir}"; fi
    let count_unchanged=${count_unchanged}+1
  fi

  # cd back:
  cd - &> /dev/null
done

# Report status and exit:
echo -ne "\n\n${count_all} git repositories found: "
echo -ne "${count_changed} have changes, "
echo -ne "${count_unchanged} are unchanged.\n\n"
