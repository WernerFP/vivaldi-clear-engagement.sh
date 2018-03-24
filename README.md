# vivaldi-clear-engagement.sh

## Background
The Chromium function "*[Site Engagement](https://www.chromium.org/developers/design-documents/site-engagement)*" stores continuously updated usage data. The collected data result in an expressive and detailed user profile. The function cannot be disabled.

All Chromium based browsers are effected by this behaviour, including Vivaldi. The engagement analysis of user data in Vivaldi is visible at this URLs:<br/>
`vivaldi://site-engagement`<br/>
`vivaldi://media-engagement`

If you wish a clean browser profile, you should delete this data.

The Vivaldi command "*Clear browser data*" does not delete engagement data. The only way to eliminate them is to call the Chromium function "*Clear browsing data*" in `chrome://settings/clearBrowserData`.

There are some WebExtensions to clean up the browser profile (such as *Click&Clean*, *Clear Browsing Data*, *Forget It* etc.), but also do not delete the engagement data.

## Bash Script
The engagement data are stored in these files:<br/>
`~/.config/vivaldi/Default/Preferences`<br/>
`~/.config/vivaldi-snapshot/Default/Preferences`

All browser settings are stored in the *Preferences* file. It is a rather confusing text file consisting of only one single line with an enormous number of characters.

The script *vivaldi-clear-engagement.sh* finds all site- and media-engagement data by search patterns and removes them from the *Preferences* files in Vivaldi-Stable and Vivaldi-Snapshot.

If requested, rotating backups of the file *Preferences* will be created. The number of backups to keep can be specified in the variable `keep` (for example`keep=3`). If more backups are found the oldest will be deleted.
