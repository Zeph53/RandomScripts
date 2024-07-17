#!/bin/bash

#
#
#
#
# Argument parsing
script_filename="$(readlink -f "$0" | awk -F '/' '{printf $NF}')"
if
  [[ "$#" -eq 0 ]]
then
  printf "Add a file or folder to the command as an argument.\n"
  printf "Use \"$script_filename --help\" for help. \n"
  exit 1
fi
while
  [[ "$#" -gt 0 ]]
do
  case "$1" in
    (--)
      shift
      break
    ;;
    ('-?'|'-h'|'--help')
      show_help="true"
      break 1
    ;;
    ('-y'|'--no-confirms')
      no_confirms="true"
      break 1
    ;;
    (*)
      if
        ! [[ -e "$1" ]]
      then
        printf "File or folder \"%s\" does not exist.\n" "$1"
        if
          [[ "${1:0:1}" == "-" ]]
        then
          printf "%s is an invalid command argument. \n" "\"$1\""
          printf "Use \"$script_filename --help\" for help. \n"
          exit 1
        fi
      fi
    ;;
  esac
  shift
done
# Show a help menu when --help is passed
if
  [[ "$show_help" == "true" ]]
then
  printf "Usage:
  Add a file or folder to the command as an argument.
  After following the on screen directions, out comes a repository on GitHub!

  To upload a file to Github:
  git-repocreater2.bash \"/home/user/scripts/a-script-i-wanna-backup.sh\"

  To upload a directory to Github:
  git-repocreater2.bash \"/home/user/scripts/a-directory-i-wanna-backup\"

  Options:
  -h --help                Display this help menu then exit.
  -y --no-confirms         Prevent prompt for confirming input.

  Git-Repocreater2
  Copyright (C) 2024 GitHub.com/Zeph53
  This program comes with ABSOLUTELY NO WARRANTY!
  This is free software, and you are welcome to
  redistribute it under certain conditions.
  See \"https://www.gnu.org/licenses/gpl-3.0.txt\"
  "
  printf "\n"
  exit 0
fi
# Tell the user the Yes/No: prompt will not be used.
if
  [[ "$no_confirms" == "true" ]]
then
  printf "$script_filename will skip most confirmation dialogues. \n"
fi

printf "%s\n" "$1"









