#! /usr/bin/env bash

SAVELOCATION=$HOME/.steam/steam/steamapps/compatdata/389730/pfx/drive_c/users/steamuser/AppData/Local
BACKUPLOCATION=$HOME/Pictures/tekkenBak/

TIMENAME=$(date +"%d-%m-%y_%T")

cd $SAVELOCATION
tar -czvf $BACKUPLOCATION/TekkenGame$TIMENAME.tar.gz TekkenGame
