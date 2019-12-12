#!/bin/sh

dt=`date +%Y%m%d`
log="/var/log/polynimbus/$dt.log"
list="/var/cache/polynimbus/inventory/object-storage.list"

echo "### BEGIN `date`" >$log
/opt/polynimbus-backup/internal/s3.sh $list >>$log
/opt/polynimbus-backup/internal/azure.sh $list >>$log
echo "### END `date`" >>$log
