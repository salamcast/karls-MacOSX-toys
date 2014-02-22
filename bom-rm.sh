#!/bin/bash
#set -x

. ./common.inc.sh

#MacBook
ROOT='/Volumes/abdulaudio'
TMP="/Volumes/binholz/bk"

#netbook
#TMP="/Volumes/Other/test"
#ROOT="/Volumes/net"
CD=$(CD)
rv=$(${CD} fileselect \
  --title "Installed Mac OS X Apps" \
  --text "Pick BOM file to backup, remove, make live" \
  --with-directory "${rect}" \
  --with-extensions .bom 2>/dev/null ) 
 if [ -n "$rv" ]; then
  ### Loop over lines returned by fileselect
  echo -e "$rv" | while read file; do
  ### Check if it's a directory
   if [ -d "$file" ]; then
    exit
    ### Else a regular file
   elif [ -e "$file" ]; then
    filen "${file}"
    num_files "${file}" 
    cd "${ROOT}"
    bomcp "${file}" 

   fi
  done
 else
  echo "No files chosen"
  exit
 fi




