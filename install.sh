#!/bin/bash

if [ "`which s3cmd 2>/dev/null`" = "" ]; then
	echo "error: s3cmd not found"
	exit 1
fi

echo "setting up Polynimbus Backup directories and files"
mkdir -p -m 0700 \
	/var/cache/polynimbus/inventory \
	/var/cache/polynimbus/settings/aws \
	/var/cache/polynimbus/cache/aws/s3cmd \
	/var/cache/polynimbus/cache/linode/s3cmd \
	/var/cache/polynimbus/cache/azure/storage-accounts \
	/var/cache/polynimbus/accounts \
	/var/cache/polynimbus/accounts/b2 \
	/var/log/polynimbus \
	/srv/polynimbus/b2 \
	/srv/polynimbus/gs \
	/srv/polynimbus/s3 \
	/srv/polynimbus/azure \
	/srv/polynimbus/linode \
	/srv/cifs/azure

chmod 0710 /var/cache/polynimbus
touch /var/cache/polynimbus/inventory/storage.list /var/cache/polynimbus/settings/aws/s3-backup.blacklist

if ! grep -q /opt/polynimbus-backup/cron /etc/crontab; then
	echo "setting up crontab entry"
	echo "$((RANDOM%60)) 8 * * * root /opt/polynimbus-backup/cron/daily.sh" >>/etc/crontab
fi
