#!/bin/bash
# including file to get access of PROXY variables
. /etc/sysconfig/phone-home

# get status variable from config file
STATUS=`/sbin/e-smith/config get phone-home status`

# check if status if disabled
if [ "$STATUS" == "disabled" ]; then
   exit 0
fi

if [ "x$PROXY_SERVER" != "x" ]; then
   # set param curl
   PROXY_OPTIONS_SERVER="--proxy http://$PROXY_SERVER"
else
   # default
   PROXY_OPTIONS_SERVER=""
fi

if [ "x$PROXY_PORT" != "x" ]; then
   # set param curl
   PROXY_OPTIONS_SERVER="$PROXY_OPTIONS_SERVER:$PROXY_PORT"
else
   # default
   PROXY_OPTIONS_SERVER=""
fi

if [ "x$PROXY_USER" != "x" ]; then
   # set param curl
   PROXY_OPTIONS_USER="--proxy-user $PROXY_USER"
else
   # default
   PROXY_OPTIONS_USER=""
fi

if [ "x$PROXY_PASS" != "x" ]; then
   # set param curl
   PROXY_OPTIONS_USER="$PROXY_OPTIONS_USER:$PROXY_PASS"
else
   # default
   PROXY_OPTIONS_USER=""
fi

PROXY_OPTIONS="$PROXY_OPTIONS_SERVER $PROXY_OPTIONS_USER"

UUID=`/bin/cat /var/lib/yum/uuid`
RELEASE=`/sbin/e-smith/config getprop sysconfig Version`

curl -X POST --data "method=add_info&uuid=$UUID&release=$RELEASE" $PROXY_OPTIONS http://$SERVER_IP/phone-home/index.php