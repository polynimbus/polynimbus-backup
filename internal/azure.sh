#!/bin/bash

list=$1

entries=`grep ^azure $list |grep ' files ' |awk '{ print $2 ":" $7 }' |sort |uniq`
for entry in $entries; do

    account="${entry%:*}"
    storage="${entry##*:}"

    file="/var/cache/polynimbus/azure/storage-accounts/$account-$storage.cifs"
    if [ ! -f $file ]; then
		echo "### skipping Azure Storage account $account/$storage (credentials file not found)"
		continue
    fi

	echo "### processing Azure Storage account $account/$storage"
	shares=`grep "^azure $account files " $list |grep $storage$ |cut -d' ' -f5`
	for share in $shares; do

		remote="//$storage.file.core.windows.net/$share"
		path="/srv/cifs/azure/$account-$storage-$share"
		if [ ! -d $path ]; then
			mkdir -p -m 0700 $path
		fi

		echo "### syncing share $share"
		mount -t cifs $remote $path -o vers=3.0,credentials=$file,serverino
		rsync -av --delete $path /srv/polynimbus/azure
		umount $path
	done
done
