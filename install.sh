#!/bin/bash

if [ "`which s3cmd 2>/dev/null`" = "" ]; then
	echo "error: s3cmd not found"
	exit 1
fi

echo "setting up Polynimbus Backup directories and files"
if [ ! -e /root/.polynimbus/inventory ]; then
	mkdir -p -m 0700 \
		/root/.polynimbus/inventory \
		/var/cache/polynimbus/aws/s3cmd \
		/var/cache/polynimbus/linode/s3cmd \
		/var/cache/polynimbus/azure/storage-accounts \
		/etc/polynimbus \
		/srv/polynimbus/b2 \
		/srv/polynimbus/gs \
		/srv/polynimbus/s3 \
		/srv/polynimbus/azure \
		/srv/polynimbus/linode
fi

mkdir -p -m 0700 \
	/var/log/polynimbus \
	/srv/cifs/azure

chmod 0710 /root/.polynimbus
touch /root/.polynimbus/inventory/storage.list /var/cache/polynimbus/aws/s3-backup.blacklist

if ! grep -q /opt/polynimbus-backup/cron /etc/crontab; then
	echo "setting up crontab entry"
	echo "$((RANDOM%60)) 8 * * * root /opt/polynimbus-backup/cron/daily.sh" >>/etc/crontab
fi
