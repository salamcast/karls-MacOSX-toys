#!/bin/bash
ROOT='/Volumes/abdulaudio'
function bk() { 
 echo "/Volumes/binholz/bk"
}

function CD(){
 echo "/Users/kholz/Applications/CocoaDialog.app/Contents/MacOS/CocoaDialog"
}


rect='/var/db/receipts/'

function quote()
{
 sed -e 's/\.\//"/g' -e 's/$/"/g'
}

function bom_list() {
 local bom=$1
 local filter=$2
 # files to 
 case ${filter} in
  'en')
   lsbom -sd "${bom}" | grep lproj | quote | filter ${filter}
  ;;
  'lang')
   lsbom -sd "${bom}" | grep lproj | quote | sed -e '/en.lproj/d' -e '/English.lproj/d' -e '/locale\/en_/d'
  ;; 
  'root')
   lsbom -sf "${bom}" | quote | sed -e '/[pP]ython/d' -e '/[Rr]uby/d' -e '/[Gg]em/d'  -e '/.*\.lproj/d' -e '/locale/d'
  ;;
  'python')
   lsbom -fs "${bom}" | quote | sed -n -e '/[Pp]ython/p' 
  ;;
  'ruby')
   lsbom -fs "${bom}" | quote | sed -n -e '/[Rr]uby/p' -e '/[Gg]em/p'
  ;;
  'perl')
   lsbom -fs "${bom}" | quote | sed -n -e '/[Pp]erl/p' -e '/[Cc]pan/p'
  ;;
 
 esac
}

function filter() {
 local filter=$1
 # files to 
 case ${filter} in
  'en')
   sed -n -e '/en.lproj/p' -e '/English.lproj/p' -e '/locale\/en_/p'
  ;;
  'lang')
   sed -e '/en.lproj/d' -e '/English.lproj/d' -e '/locale\/en_/d'
  ;; 
  'root')
   sed -e '/[pP]ython/d' -e '/[Rr]uby/d' -e '/[Gg]em/d'  -e '/.*\.lproj/d' -e '/locale/d'
  ;;
  'python')
   sed -n -e '/[Pp]ython/p' 
  ;;
  'ruby')
   sed -n -e '/[Rr]uby/p' -e '/[Gg]em/p'
  ;;
  'perl')
   sed -n -e '/[Pp]erl/p' -e '/[Cc]pan/p'
  ;;
 
 esac
}



function bubble() {
 local B=$1

 local CD=$(CD)
 local timeo=20
 local xp="center"
 local yp="center"
 case $B in
  'arc')
   local title="Compress ${2} Files"
   local text="Creating $(basename ${3})"
   local bcolor="2100b4"
   local tcolor="000000"
   local btcolor="aabdcf"
   local bbcolor="fdde88"
   local icon="find"
  ;;
  'num_files')
   local title="# Files in Bom: "
   local text=" $(echo ${2}| tr -d ' ') Files"
   local bcolor="2100b4"
   local tcolor="000000"
   local btcolor="aabdcf"
   local bbcolor="fdde88"
   local icon="info"
  ;;
  'filen')
   local title="File:"
   local text="${2}"
   local bcolor="2100b4"
   local tcolor="180082"
   local btcolor="aabdcf"
   local bbcolor="86c7fe"
   local icon="finder"
  ;; 
  'size')
   local title="File Size:"
   local text="$(basename ${2}): ${3}"
   local bcolor="a25f0a"
   local tcolor="180082"
   local btcolor="dfa723"
   local bbcolor="86c7fe"
   local icon="info"
  ;;

 esac 
 ${CD} bubble --titles "${title}"    \
   --timeout ${timeo}                \
   --texts "${text}"                 \
   --border-colors "${bcolor}"       \
   --text-colors "${tcolor}"         \
   --background-tops "${btcolor}"    \
   --background-bottoms "${bbcolor}" \
   --icons "${icon}"                 \
   --x-placement "${xp}"             \
   --y-placement "${yp}"

}

function log() {
 local l=$1
 local log=$(log_file)

  echo -e "#####################################################\n" >> ${log}
 case $l in
  'arc')
   local arc=$2
   echo -e "# $(date) \t\t Compress ${arc} Files\n" >> ${log}
  ;;
  'size')
   local tar=$2
   local size=$3
   echo -e "# Done ${tar} @ $(date) \t\t Size: ${size} \n\n" >> ${log}
  ;;
 esac
 echo -e "#####################################################\n" >> ${log}
 echo -e "-----------------------------------------------------\n" >> ${log}
}
function arc()
{
 local bom=$1
 local bk="$(root ${bom})"
 local arc="$2"
 local tar="${bk}/${arc}.tar.bz2"
 local log="$(log_file ${bom})"
 local list=$(bom_list ${bom} ${arc})
 if [ $(echo $list| wc -c) -gt 0 ]
 then
  bubble 'arc' "${arc}" "${tar}" 
  log 'arc' "${arc}" 
  echo ${list} >> ${log}
  progress 'start' $(basename ${tar}) 
  echo ${list} | xargs tar cjvf "${tar}" 2>&3
  progress 'stop' 
  arc_size ${tar} 
 fi
}

function progress() {
 local CD=$(CD)
 local s=$1
 local title="Creating $2"
 local tmp="/tmp/bom.tmp"
 case $s in
  'start')
   rm -f ${tmp} 2>/dev/null
   mkfifo ${tmp} 
   ${CD} progressbar --indeterminate --title "${title}" < ${tmp} &
   exec 3<> ${tmp}
  ;;
  'stop')
   sleep 20
   exec 3>&-
   wait
   rm -f ${tmp}
  ;;
 esac
}

function num_files()
{
 local file=$1
 local num="$(lsbom -sf "${file}"|wc -l|tr -d "\t" | tr -d ' ')"
 bubble 'num_files' ${num}
 log 'num_files' ${num} 
}

function filen() {
 local file=$(basename $1)
 bubble 'filen' "${file}"
 log 'filen' ${file}
}

function arc_size(){
 local tar=$1
 if [ -f "${tar}" ]
  then
   local size=$(du -sh "${tar}"| tr  "\t" ' '|cut -d ' ' -f2)
   if [ ! -f "${size}" ] && [ ! -d "${size}" ]
   then
    bubble 'size' "${tar}" "${size}" 
    log 'size' "${tar}" "${size}"   
   fi
 fi
}

function log_file(){
 local root=$(root "$1")
 echo "${root}/copy.log"
}
function root(){
 local bk="$(bk)"
 local bom="$1"
 echo "${bk}/$(echo ${bom}| sed 's/\/var\/db\/receipts\///')"
}

function ftype() {
 local bom="$1"
 file -b "${bom}" | tr ' ' '_'
}

function mdir(){
 local root=$(root "$1")
 mkdir -p ${root} 2>/dev/null
}
function bomcp() {
 # $1 - bom file
 local bom="$1"
 local ftype="$(ftype "${bom}")"
 
 case "$ftype" in
# read normal text file as is
  'ASCII_text')
   echo "This file type is not supported"
   exit
  ;;

# read Apple BOM file with mac tools, lsbom
  'Mac_OS_X_bill_of_materials_(BOM)_file')
   mdir "${bom}"
   local log="$(log_file ${bom})"
   touch ${log}
   echo ''>${log}
   # lang
   arc ${bom} 'lang' 
   # lang
   arc ${bom} 'en' 
    # ruby 
   arc ${bom} 'ruby' 
   # perl
   arc ${bom} 'perl' 
   # python
   arc ${bom} 'python' 
   # root
   arc ${bom} 'root' 
  ;;
 esac
}


