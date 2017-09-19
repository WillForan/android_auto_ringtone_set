#!/usr/bin/env bash

# script_on_droid=/sdcard/sl4a/scripts/contacts.py
# adb push contacts.py $script_on_droid
# adb shell am start -a com.googlecode.android_scripting.action.LAUNCH_FOREGROUND_SCRIPT -n com.googlecode.android_scripting/.activity.ScriptingLayerServiceLauncher -e com.googlecode.android_scripting.extra.SCRIPT_PATH $script_on_droid

# built from 
# adb shell content query --uri content://contacts/people/ --projection display_name:number| egrep -i "(=(Kat.*|Rose.*|Sarah|Pat) Foran)|(Rachel Elder)|(Emily Mente)|(Cyn.* Majistro)"

# cannot get by number
getcid(){
  number=$1
  adb shell content query --uri content://contacts/people/ --projection _id --where "number='$number'"|cut -f2 -d=
}

idfromlast(){ sed 's/.*id=//'; }
getstarred(){
   adb shell content query \
     --uri content://contacts/people/ \
     --where 'starred=1' \
     --projection display_name:number:_id
}
getmedia() {
   adb shell content query \
     --uri content://media/external/audio/media\
     --projection _data:_id $@
}
makemedia(){
  ringtone=$1
  data=/storage/emulated/0/Ringtones/$ringtone
  adb shell content insert \
     --uri content://media/external/audio/media \
     --bind _data:s:$data
  getmedia --where "_data=\'$data\'" | idfromlast
}

updateringtone(){
  contact_id=$1;shift
  media_id=$1;shift
  adb shell content update \
    --uri "content://contacts/people/$contact_id" \
    --bind "custom_ringtone:s:content://media/external/audio/media/$media_id"
}

getmedia > all_media.txt
getstarred |sed s/,\ M.D.//| cut -d= -f2-|sort > starred.txt
# merge stared with rintones
# people_ringtones.txt: name as in phone, ringtone.mp3
join -t, -j1 starred.txt  <(sort people_ringtones.txt) |
while IFS=, read name number id ringtone; do
  cid=$(echo $id| idfromlast)
  echo -e "$name: '$cid'"

  mid=$(grep $ringtone all_media.txt | idfromlast)
  [ -z "$mid" ] && mid=$(yes|makemedia $ringtone) 
  [ -z "$mid" ] && echo "media error!" && continue
  echo -e "\t$ringtone: '$mid'"

  # globs up the while read
  # yes pipe stops this
  yes | updateringtone "$cid" "$mid" 

done


