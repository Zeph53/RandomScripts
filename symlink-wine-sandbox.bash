#!/bin/bash
#
##
#
## Ask for Wine prefix directory, and confirm it
while true
do
  printf "Enter directory path containing Wine prefix directories:\n"
  read -r -e "prefix_dir"
  while [[ ! -d "$prefix_dir" ]]
  do
    if [[ -z "$prefix_dir" ]]
    then
      printf "Prefix directories path can't be empty.\n"
      break 1
    fi
    printf "\"$prefix_dir\" does not exist.\n"
    break 1
  done
  while [[ -d "$prefix_dir" ]]
  do
    printf "Is this correct? Yes/No: "
    read -r -e "confirm_prefix_dir"
    confirm_prefix_dir="$(printf "$confirm_prefix_dir" | tr '[:upper:]' '[:lower:]')"
    if [[ "$confirm_prefix_dir" == "yes" ]] || [[ "$confirm_prefix_dir" == "y" ]]
    then
      break 2
      prefix_dir_confirmed="true"
    elif [[ "$confirm_prefix_dir" == "no" ]] || [[ "$confirm_prefix_dir" == "n" ]]
    then
      break 1
      prefix_dir_confirmed="false"
    fi
  done
done
## Ask for sandbox directory, and confirm it
while true
do
  printf "Enter directory path containing the Wine sandbox:\n"
  read -r -e "sandbox_dir"
  while [[ ! -d "$sandbox_dir" ]]
  do
    if [[ -z "$sandbox_dir" ]]
    then
      printf "Sandbox directory path can't be empty.\n"
      break 1
    fi
    printf "\"$sandbox_dir\" does not exist.\n"
    break 1
  done
  while [[ -d "$sandbox_dir" ]]
  do
    printf "Is this correct? Yes/No: "
    read -r -e "confirm_sandbox_dir"
    confirm_sandbox_dir="$(printf "$confirm_sandbox_dir" | tr '[:upper:]' '[:lower:]')"
    if [[ "$confirm_sandbox_dir" == "yes" ]] || [[ "$confirm_sandbox_dir" == "y" ]]
    then
      break 2
      sandbox_dir_confirmed="true"
    elif [[ "$confirm_sandbox_dir" == "no" ]] || [[ "$confirm_sandbox_dir" == "n" ]]
    then
      break 1
      sandbox_dir_confirmed="false"
    fi
  done
done
#
## Check the directory for existing Wine prefixes
find "$prefix_dir"/*/drive_c/users/*/* -maxdepth 0 -type d | while IFS= read -r directory
do
  # Check if the directory should be skipped
  if 
    [[ "$directory" != *"*/Temp"* ]] &&
    [[ "$directory" != *"*/AppData/Local/Microsoft"* ]] &&
    [[ "$directory" != *"*/AppData/Roaming/Microsoft"* ]] &&
    [[ "$directory" != *"*/AppData/Roaming/dgVoodoo"* ]] &&
    [[ "$directory" != *"*/AppData/Roaming/wine_gecko"* ]]
  then
    # Remove the directory and all its contents
    rm -r -f -- "$directory"*
  fi
done
