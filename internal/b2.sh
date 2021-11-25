#!/bin/bash

list=$1

buckets=`grep ^backblaze $list |grep ' b2 ' |awk '{ print $2 ":" $5 }'`
for entry in $buckets; do

	account="${entry%:*}"
	bucket="${entry##*:}"

	file=/var/cache/polynimbus/accounts/b2/$account.db
	if [ ! -f $file ]; then
		echo "### skipping bucket $account/$bucket (b2 configuration file not found)"
		continue
	fi

	path="/srv/polynimbus/b2/$account-$bucket"
	if [ ! -d $path ]; then
		mkdir -p -m 0700 $path
	fi

	echo "### syncing $bucket"
	B2_ACCOUNT_INFO=$file b2 sync --noProgress --compareVersions size b2://$bucket $path
done
