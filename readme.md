# About
Assign ringtones to starred contacts using `adb shell content`

  1. `install.bash` puts files on the phone (Ringtones on emulated sd storage) and runs
  2. `adbContactRingtones.bash` 
     2.1 merges star contacts with their desired ringtone (get contact id)
     2.2 creates media db entry for ringtone if it doesn't exit (get ringtone media id)
     2.3 sets `custom_ringtone` for contact

# Notes
## personal android automation
Modifying phone content without writing an app is under-documented. 
Other attempts include.
 * `adb pull /data/data/com.android.providers.contacts/databases/contacts2.db` wont work without root, and is probably dangerous to modify the database without letting android know.
 * [`sl4a`](https://github.com/kuri65536/sl4a) has a [contacts facade](http://www.mithril.com.au/android/doc/ContactsFacade.htm), but does not appear to be able to set values.
 * `adb shell am start` to script app launch and button pushes. These seems like hell. Some is trying on [SO](https://stackoverflow.com/questions/14377208/android-adb-insert-contacts-and-need-to-hit-done-to-complete) though.
 * Jython `monkeyrunner` is more automatic button pushing?


## `adb shell content` `create` and `update`
`create` and `update` subcommands do not work well in a bash/shell `while read` loop. They eat the remaining data. I cheated and used `yes |` before the command.


