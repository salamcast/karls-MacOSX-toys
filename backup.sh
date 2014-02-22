#!/usr/bin/bash

USER=`whoami`
VOL=/Volumes/$USER

#folders not to sync
LIB='/^Library$/d'
APPS='/^Applications$/d'
MOV='/^Movies$/d'
MUSIC='/^Music$/d'
DOT='/^\.$/d'
DDOT='/^\.\.$/d'



#
FILES=$(ls -a | sed -e $LIB -e $MUSIC -e $MOV -e APPS -e $DOT -e $DDOT | tr '\n' ' ')


#Home Root
rsync -avz $FILES $VOL 
