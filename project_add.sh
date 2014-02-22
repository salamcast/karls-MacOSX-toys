#!/bin/bash
SVN=$1 # new repo
DIR=/Users/svn/repo/
TMP=/tmp/svn/

#SVN bin files
SVNADMIN=/opt/subversion/bin/svnadmin
SVNBIN=/opt/subversion/bin/svn
SVNSRV=/opt/subversion/bin/svnserve
SVNUSR="_svn"
SVNGRP="_svn"
REDGRP="_svn_crew"

${SVNADMIN} create --fs-type fsfs ${DIR}${SVN} 

#Tmp layout
rm -rf ${TMP}/* 2>/dev/null
mkdir -p ${TMP}${SVN}/trunk 2>/dev/null
mkdir -p ${TMP}${SVN}/branches 2>/dev/null
mkdir -p ${TMP}${SVN}/tags 2>/dev/null

${SVNBIN} import -m "Creating the defaults for ${SVN}." \
 ${TMP}${SVN} file://${DIR}${SVN}

chown -R ${SVNUSR}:${REDGRP} ${DIR}${SVN}
chmod -R g+w ${DIR}${SVN} 
chmod g+s ${DIR}${SVN}/db 

dscl . -create /Users/${SVN}
dscl . -append /Groups/${SVNGRP} GroupMembership $SVN
dscl . -append /Groups/${REDGRP} GroupMembership $SVN

cp ${DIR}${SVN}/conf/svnserve.conf \
   ${DIR}${SVN}/conf/svnserve.conf.default 2>/dev/null
cat > ${DIR}${SVN}/conf/svnserve.conf << "EOF"
[general]
anon-access = read
auth-access = write
EOF
if [ ! -f /etc/xinetd.conf ]
then
cat >> /etc/xinetd.conf << "EOF"

service svn
{
        port                    = 3690
        socket_type             = stream
        protocol                = tcp
        wait                    = no
        user                    = ${SVNUSR}
        server                  = ${SVNSRV}
        server_args             = -i -r ${DIR} 
}

# End /etc/xinetd.d/svn
EOF

fi
