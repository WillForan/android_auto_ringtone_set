# About
Assign ringtones to starred contacts using `adb shell content`

  1. `install.bash` puts files on the phone (Ringtones on emulated sd storage) and runs
  2. `adbContactRingtones.bash` 
     1. merges star contacts with their desired ringtone (get contact id)
     2. creates media db entry for ringtone if it doesn't exit (get ringtone media id)
     3. sets `custom_ringtone` for contact

## Why
I assigned bird sounds to the people who call me often (from [the Cornell lab of ornithology](https://www.allaboutbirds.org/guide/search/)). I will probably decide this is a bad idea and want to quickly change the sounds. It's laborious to do by hand. Also it's nice to be sure what sound is associated with what person.

## prereq
`people_ringtones.txt` lines looks like 

```
android contact display name, no_path_ringtone.mp3
another contact display name, no_path_ringtone2.mp3
```

script hard codes location of Ringtones to `/storage/emulated/0/Ringtones/`

# Notes
## personal android automation
Modifying phone content without writing an app is under-documented. 
Other attempts include.

  * `adb pull /data/data/com.android.providers.contacts/databases/contacts2.db` wont work without root, and is probably dangerous to modify the database without letting android know.
  * [`sl4a`](https://github.com/kuri65536/sl4a) has a [contacts facade](http://www.mithril.com.au/android/doc/ContactsFacade.htm), but does not appear to be able to set values.
  * `adb shell am start` to script app launch and button pushes. These seems like hell. Some is trying on [SO](https://stackoverflow.com/questions/14377208/android-adb-insert-contacts-and-need-to-hit-done-to-complete) though.
  * Jython `monkeyrunner` is more automatic button pushing?


## `adb shell content`

  * `create` and `update` subcommands do not work well in a bash/shell `while read` loop. They eat the remaining data. I cheated and used `yes |` before the command.
  * `query --uri  content://contacts/people/ --where 'number="..."'` will not return matches.
  * how to or if it is at all possible to use wildcard (`%partial%`) in `--where` "SQL like" query is an open question 

## ringtone "creation"
`normalize *mp3` should have equalized the volume. However, I do not have confidence that this invocation is sufficient. 

Bird noises are easy to lift from the very straight forward html of allaboutbirds.org

For non-bird/music clips, I 
  - used audacity to clip the audio to just an instrumental segment
  - cut the start of the clip and placed it at the end in a new layer
  - chopped and moved the ends such that the repeat transition was as seamless as I cared to fuss with. Highlighting the end + new layer start region and using shift+click for looped play was extremely useful.
