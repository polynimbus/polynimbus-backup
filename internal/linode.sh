#!/bin/bash

list=$1

buckets=`grep ^linode $list |grep ' beta ' |awk '{ print $2 ":" $5 }'`
for entry in $buckets; do

	account="${entry%:*}"
	bucket="${entry##*:}"

	file=/var/cache/polynimbus/cache/linode/s3cmd/$account.ini
	if [ ! -f $file ]; then
		echo "### skipping bucket $account/$bucket (s3cmd configuration file not found)"
		continue
	fi

	path="/srv/polynimbus/linode/$account-$bucket"
	if [ ! -d $path ]; then
		mkdir -p -m 0700 $path
	fi

	echo "### syncing s3://$bucket"
	s3cmd -c $file sync s3://$bucket/ $path/ --skip-existing
done
