#!/bin/bash

list=$1

if [ "`which gcloud 2>/dev/null`" = "" ] && [ -f /root/google-cloud-sdk/path.bash.inc ]; then
	. /root/google-cloud-sdk/path.bash.inc
fi

if [ "`which gcloud 2>/dev/null`" = "" ] || [ "`which gsutil 2>/dev/null`" = "" ]; then
	echo "### skipping Google Storage (client software not found)"
	exit 0
fi


buckets=`grep ^google $list |grep ' gs ' |awk '{ print $2 ":" $5 }'`
for entry in $buckets; do

	account="${entry%:*}"
	bucket="${entry##*:}"

	path="/srv/polynimbus/gs/$account-$bucket"
	if [ ! -d $path ]; then
		mkdir -p -m 0700 $path
	fi

	echo "### syncing gs://$bucket"
	gsutil rsync -r gs://$bucket $path
done
