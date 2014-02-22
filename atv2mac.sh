#/bin/bash
#################################
# 
# Apple TV Hard Drive Converter 
#
# Author: Karl G. B. Holz
#
# www.new-aeon.com newaeon@mac.com
#
#################################

DISK=disk3
ID=$(gpt -r show /dev/$DISK | tr -s ' ' | grep "2 GPT" | cut -d' ' -f8)

#Hard drive partition IDs
ATV="5265636F-7665-11AA-AA11-00306543ECAC"
MAC="48465300-0000-11AA-AA11-00306543ECAC"
START=$(gpt -r show /dev/$DISK | tr -s ' ' | grep "2 GPT" | cut -d' ' -f2)
SIZE=$(gpt -r show /dev/$DISK | tr -s ' ' | grep "2 GPT" | cut -d' ' -f3)

#409640 
#7343680
function remove { 
  gpt remove -i 2 /dev/$1
}

function unmount {
  disktool -u $1 
}

function convert {
    gpt add -b $3 -s $4 -i 2 -t $2 /dev/$1 
}

function fixatv {
  cd $1
  sudo rm -f $1/mach_kernel $1/README.txt
  unzip mach_kernel.zip
  chmod a+x $1/mach_kernel
  sudo chown root:wheel $1/mach_kernel
  sudo rm -rf $1/System/Libary/Extensions.e* 
  sudo rm -f $1/System/Library/CoreServices/boot.efi
  sudo cp /Volumes/OSBoot/System/Library/CoreServices/boot.efi $1/System/Library/CoreServices/
   
  read -p "Unlock \"boot.efi\" in finder" 
  sudo bless --folder=$1/System/Library/CoreServices --file=$1/System/Library/CoreServices/boot.efi --setBoot
}
###
#unmount vol
c=$(df -h | grep $DISK)
if [ "x$c" = "x" ]
 then 
 echo ""
else
 unmount $DISK && remove $DISK
fi
#unmount again if vols remounted
#check ID if HD, if Apple TV, switch to MAC else if Mac change to Apple TV
if [ "$ID" = "$ATV" ]
 then
  echo "Converting your disk to Intel Mac Format => $MAC"
  unmount $DISK
  remove $DISK
  convert $DISK $MAC $START $SIZE
elif [ "$ID" = "$MAC" ]
 then
  echo "Converting your disk to Apple TV Format => $ATV"
  unmount $DISK
  remove $DISK
  convert $DISK $ATV $START $SIZE
fi
#


