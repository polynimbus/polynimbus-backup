#!/bin/bash

list=$1

buckets=`grep ^aws $list |grep ' s3 ' |awk '{ print $2 ":" $5 }'`
for entry in $buckets; do

	account="${entry%:*}"
	bucket="${entry##*:}"

	if grep -qxF $account /var/cache/polynimbus/settings/aws/s3-backup.blacklist; then
		echo "### skipping bucket $account/$bucket (blacklisted by account)"
		continue
	fi

	if grep -qxF "$account/$bucket" /var/cache/polynimbus/settings/aws/s3-backup.blacklist; then
		echo "### skipping bucket $account/$bucket (blacklisted)"
		continue
	fi

	file=/var/cache/polynimbus/cache/aws/s3cmd/$account-$bucket.ini
	if [ ! -f $file ]; then
		echo "### skipping bucket $account/$bucket (s3cmd configuration file not found)"
		continue
	fi

	path="/srv/polynimbus/s3/$account-$bucket"
	if [ ! -d $path ]; then
		mkdir -p -m 0700 $path
	fi

	echo "### syncing s3://$bucket"
	s3cmd -c $file sync s3://$bucket/ $path/ --skip-existing
done
