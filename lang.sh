#!/bin/sh
#DIR=/Volumes/TigLive
#DIR=/Volumes/TigStick
#DIR=/Volumes/LepStick
DIR=/
LOG=/var/log/rmlang
LIST=$(find $DIR -iname '*.lproj'| sed '/English.lproj$/d'| sed '/en.lproj$/d'|sed 's/\ /|/g')
echo '' > ${LOG}
for x in ${LIST}
do
 y=$(echo $x| sed 's/|/\ /g')
# echo -e "$y \n"
 rm -Rv "$y" 1>>${LOG}
done
