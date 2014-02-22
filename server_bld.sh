#!/bin/bash
#####
# DIRs
#####
PERL_DIR=/Users/newaeon/Downloads/perl-5.12.2 
KRB5_DIR=/Users/newaeon/Downloads/krb5-1.8.3-signed/krb5-1.8.3/src 
ZLIB_DIR=/Users/newaeon/Downloads/zlib-1.2.5 

OPENSSL_DIR=/Users/newaeon/Downloads/openssl-1.0.0a 

OPENLDAP_DIR=/Users/newaeon/Downloads/openldap-2.4.23 
MYSQL_DIR=/Users/newaeon/Downloads/mysql-cluster-gpl-7.1.9 

APACHE_DIR=/Users/newaeon/Downloads/apache_1.3.39 
MOD_DAV_DIR=/Users/newaeon/Downloads/mod_dav-1.0.3-1.3.6 
MOD_SSL_DIR=/Users/newaeon/Downloads/mod_ssl-2.8.30-1.3.39 
MOD_PERL_DIR=/Users/newaeon/Downloads/mod_perl-1.31 

#####
# other vals
###
PREFIX=/mnt/local
 # user perl modules
PERL_LIB=/mnt/perl



###########
# Make Opts
###########
PATH=$PREFIX/bin:$PREFIX/sbin:$PATH
 
 FLAGS="-arch ppc -arch i386 --target=powerpc-apple-darwin8.0.0 --target=i386-apple-darwin8.0.0 --with-macos-sdk=/Developer/SDKs/MacOSX10.4u.sdk" 
 CC="gcc-4.0 $FLAGS"
 CXX="g++-4.0 $FLAGS"
 #ac_add_options --target=powerpc-apple-darwin8.0.0
 #ac_add_options --target=i386-apple-darwin8.0.0 
 #ac_add_options --with-macos-sdk=/Developer/SDKs/MacOSX10.4u.sdk

HOST_CC="gcc-4.0"
HOST_CXX="g++-4.0"
RANLIB=ranlib
AR=ar
AS=$CC
LD=ld
STRIP="strip -x -S"
CROSS_COMPILE=1

#ac_add_options --disable-libIDLtest
#ac_add_options --disable-glibtest

##############
# start build
##############
mkdir $PREFIX

# perl
echo " * making Perl "
cd $PERL_DIR
make clean
./configure.gnu --prefix=$PREFIX
make && make install
# set variable for new perl iterperator
PERL=$PREFIX/bin/perl 

# krb5
#cd $KRB5_DIR
#make clean
#./configure --prefix=$PREFIX --with-ldap 
#make && make install

# zlib
make clean
cd $ZLIB_DIR
./configure --prefix=$PREFIX
make && make install


# openssl
echo " * making OpenSSL "
cd $OPENSSL_DIR
./config --prefix=$PREFIX zlib darwin-i386-cc
make && make install

# mysql
echo " * making a mysql server "
cd $MYSQL_DIR
./configure --prefix=$PREFIX --with-zlib-dir=$PREFIX --with-ssl=$PREFIX --with-plugins=max
make && make install

# openldap
#echo " * making openldap "
#cd $OPENLDAP_DIR
#./configure --enable-perl --enable-ndb --enable-bdb=no --enable-hdb=no --prefix=$PREFIX
#make depend && make && make install

