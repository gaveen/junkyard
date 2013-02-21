#!/bin/bash
#
# bsd-restart_tenants - restart all tenant apache instances (tc_aura)
#
# Usage: $ bsd-restart_tenants  TENANT_FILE
#
# Restart apache instances inside each tenant directory listed in the
# file provided as the first command line parameter.
#
ARGS=1
E_BADARGS=65
E_NOFILE=66

if [ $# -lt $ARGS ] ; then
    echo "Usage: `basename $0`  /path/to/tenant_list.file"
    exit $E_BADARGS
fi

if [ -r $1 ] ; then
    INSTANCE_LIST=$1
else
    echo "Cannot read file: $1"
    exit $E_NOFILE
fi

exec 3<&0
exec 0<$INSTANCE_LIST

while read line
do
    apachectl -f /home/$line/etc/apache2/apache2.conf -k restart
done
exec 0<&3
