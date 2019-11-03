#!/bin/bash

if [ "`which s3cmd 2>/dev/null`" = "" ]; then
	echo "error: s3cmd not found"
	exit 1
fi

echo "setting up Polynimbus Backup directories and files"
mkdir -p -m 0700 /var/cache/polynimbus/inventory /var/cache/polynimbus/aws/s3cmd /var/log/polynimbus/s3 /srv/mounts/s3
chmod 0710 /var/cache/polynimbus
touch /var/cache/polynimbus/inventory/object-storage.list /var/cache/polynimbus/aws/s3-backup.blacklist

if ! grep -q /opt/polynimbus-backup/cron /etc/crontab; then
	echo "setting up crontab entry"
	echo "$((RANDOM%60)) 8 * * * root /opt/polynimbus-backup/cron/daily.sh" >>/etc/crontab
fi