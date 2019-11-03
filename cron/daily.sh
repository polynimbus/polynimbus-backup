#!/bin/sh

dt=`date +%Y%m%d`
log="/var/log/polynimbus/s3/$dt.log"

echo "### BEGIN `date`" >$log
/opt/polynimbus-backup/internal/s3.sh >>$log
echo "### END `date`" >>$log
