#!/usr/bin/env bash
find ./Ringtones -type f -iname '*mp3' |xargs -I{}  adb push {}  /storage/emulated/0/Ringtones/

./adbContactRingtones.bash
