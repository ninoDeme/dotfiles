#! /usr/bin/env bash

SAVELOCATION=$HOME/.steam/steam/steamapps/compatdata/389730/pfx/drive_c/users/steamuser/AppData/Local
BACKUPLOCATION=$HOME/Pictures/tekkenBak/

TIMENAME=$(date +"%d-%m-%y_%T")

cd $SAVELOCATION
tar -czvf $BACKUPLOCATION/TekkenGame$TIMENAME.tar.gz --exclude="Logs" TekkenGame 

cd $BACKUPLOCATION

CURRENTBAK=$(ls)
# Remove  duplicates
for FILENAMEBAK in $CURRENTBAK; do 
	CURRENTBAK=$(ls)
	for i in $CURRENTBAK; do 
		if [ "$FILENAMEBAK" != "$i" ]; then
			echo "checking $i and $FILENAMEBAK"
			if cmp $FILENAMEBAK $i >/dev/null 2>&1; then
				rm -v $i
			fi
		fi
	done
done
