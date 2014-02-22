#!/bin/bash
#set -x
OPT=$1
# VER set to on will only print the command, this safety is set by default
# VER set to off will actually delete files and directories with rm -rf
VER='on'
if [ "x${OPT}" == 'x-h' ]
then
# Basic Help Menu
 cat <<EOF
 $0 : is a script to search the root directory for language *.lproj profiles

  -h	This memu
  -f	Delete files only, not *.lproj directories
  -d    Delete all non-English profiles 

 when run with out options, the program will just list files that are found

EOF
exit 0
fi

#find the root directory in /Volumes 
root=$(ls -dl /Volumes/*|grep "/$"|tr -s ' '|cut -d ' ' -f9)

#Search Root directory for language profiles, and omit English profiles. add a space place holder for loop to work
list=$(find ${root}/ -iname '*.lproj' 2>/dev/null | sed -e '/English.lproj$/d' -e '/en.lproj$/d' | tr ' ' '|' | tr -s '/')

# go threw list of found folders; *.lproj is a folder
for c in $(echo $list) 
 do
  # clean up file from list, replace space holder with a real space
  f="$(echo ${c}| tr '|' ' ')"
  case in ${OPT}
   "-f")
    echo " * Deleteing files in ${f}"
    [ "x${VER}" == 'xon' ] && echo "# rm -rf ${f}/*"
    [ "x${VER}" == 'xoff' ] && rm -rf ${f}/* && echo "[=- Done -=]" || echo "[=- Failed -=]"
   ;;
   "-d")
    echo " * Deleteing folder ${f}"
    [ "x${VER}" == 'xon' ] && echo "# rm -rf ${f}"
    [ "x${VER}" == 'xoff' ] && rm -rf ${f} && echo "[=- Done -=]" || echo "[=- Failed -=]"  
   ;;
   *)
    echo " * Found *.lproj folder ${f}"
    ls -l ${f}
    echo "Size $(du -sh ${f}|sed 's|\t| |g'|cut -d ' ' -f1)"
    echo "-------------------------------------------------"
   ;;
  esac
 done

