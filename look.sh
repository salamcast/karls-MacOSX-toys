#!/bin/bash

cd /root/Desktop/BT3/

for x in `find ./BT3/ -iname '*.lzm'` 
do
 echo -e " **********[ $x ]********** "
 f=look/$(echo $x|sed 's/^\.\/BT3\///')
 mkdir -p $f 2>/dev/null
 ./bin/lzm2dir $x $f 2>>./look_error.log
 echo -e " * $x extracted to:\n=> `pwd`/$f"
 echo -e " * lzm size: $(du -sh $x|tr '\t' ' ')"
 echo -e " * dir size: $(du -sh $f|tr '\t' ' ')"
 ls $f
 echo -e " **********[ done ]********** "

done
