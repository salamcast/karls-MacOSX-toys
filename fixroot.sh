#!/bin/bash
#R=$(ls -ld /Volumes/*| grep "/$"| tr -s ' '|cut -d ' ' -f9)
R=$(ls -d /Volumes/* | grep "`pwd`")
chmod -R 755 ${R}/System/Library/Extensions

chown -R root:wheel ${R}/System/Library/Extensions

# 5. Create caches

kextcache -z -a i386 -m ${R}/System/Library/Caches/com.apple.kext.caches/Startup/Extensions.mkext ${R}/System/Library/Extensions ${R}/Extra/Extensions

kextcache -z -a i386 -m ${R}/Extra/Extensions.mkext ${R}/Extra/Extensions ${R}/System/Library/Extensions

chmod 755 ${R}/Extra/Extensions.mkext

chown root:wheel ${R}/Extra/Extensions.mkext

chmod 755 ${R}/System/Library/Caches/com.apple.kext.caches/Startup/Extensions.mkext

chown -R root:wheel ${R}/System/Library/Caches/com.apple.kext.caches/Startup/Extensions.mkext 
