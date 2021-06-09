#!/bin/bash

#####
# This script set a permanent proxy server 
# To run it you have to specify the proxy server as first argument
#####

[[ -z "$1" ]] && printf "You have to specify the proxy server/complete URL,\nincluding port number as a first argument\n" && exit 1
grep -iE $1 /etc/yum.conf
result=$(echo $?)
if [ $result -ne '0' ];
then
cp /etc/yum.conf /etc/yum.conf.bck
echo "proxy=$1" >> /etc/yum.conf     
echo "
HTTP_PROXY=$1
HTTPS_PROXY=$1
FTP_PROXY=$1
http_proxy=$1
https_proxy=$1
ftp_proxy=$1
export HTTP_PROXY HTTPS_PROXY FTP_PROXY http_proxy https_proxy ftp_proxy 
" >> /etc/profile
cp /etc/wgetrc /etc/wgetrc.bck 
echo "
http_proxy=$1
https_proxy=$1
ftp_proxy=$1
" >> /etc/wgetrc
source /etc/wgetrc
fi

