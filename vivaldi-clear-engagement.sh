#!/bin/sh

# Author: WernerFP
# License: GPL
# Source: https://github.com/WernerFP/vivaldi-clear-engagement.sh

# Vivaldi-Stable and Vivaldi-Snapshot:
# The script deletes engagement data stored in "Preferences".
# If requested, a backup of "Preferences" will be created first.

# ------------------------ Option ---------------------------------
# Specify how many backups of "Preferences" file should be kept
# If more backups are found the oldest will be deleted
# Empty: no backups will be created
keep=3

# ------------------------ Script ---------------------------------

# Exit if root or Vivaldi is running
itsme=$( basename $( readlink -f $0) )
if [[ $( ps --no-headers -fC vivaldi-bin | wc -l ) != 0 ]]; then
	echo "Please quit Vivaldi before running '$itsme'."
	exit
elif [ $UID = 0 ]; then
	echo  "Please don't run '$itsme' as root"
	exit
fi

# Engagement data search pattern
ap_in=",\"setting\":\{\"audiblePlaybacks\":"
ap_out=",\n\"setting\":\{\"audiblePlaybacks\":"
hs_in=",\"setting\":\{\"hasHighScore\":"
hs_out=",\n\"setting\":\{\"hasHighScore\":"
et_in=",\"setting\":\{\"lastEngagementTime\":"
et_out=",\n\"setting\":\{\"lastEngagementTime\":"

# Validate backup request
if [[ ! -z "$keep" && $keep = [[:digit:]] ]]; then
	backup=1
fi

# Paths
pref_snap=$( echo $HOME"/.config/vivaldi-snapshot/Default/Preferences" )
pref_stab=$( echo $HOME"/.config/vivaldi/Default/Preferences" )

# Vivaldi-Snapshot: clear engagement data
if [[ -f "$pref_snap" ]]; then
	if [[ "$backup" ]]; then
		cp "$pref_snap" "$pref_snap-$( date +"%Y%m%d_%H%M%S" ).bak"
	fi
	tmp_snap=$( cat $pref_snap 2>/dev/null | sed ':a;N;$!ba;s/\n//g' )
	tmp_snap=$( echo -n "$tmp_snap" \
		| sed -r 's/'$ap_in'/'$ap_out'/g' \
		| sed -r 's/'$hs_in'/'$hs_out'/g' \
		| sed -r 's/'$et_in'/'$et_out'/g' \
		| sed  -n '1p;$p' \
		| sed  ':a;N;$!ba;s/\n//g')
	echo -n "$tmp_snap" > "$pref_snap"
fi

# Vivaldi-Stable: clear engagement data
if [[ -f "$pref_stab" ]]; then
	if [[ "$backup" ]]; then
		cp "$pref_stab" "$pref_stab-$( date +"%Y%m%d_%H%M%S" ).bak"
	fi
	tmp_stab=$( cat $pref_stab 2>/dev/null | sed ':a;N;$!ba;s/\n//g' )
	tmp_stab=$( echo -n "$tmp_stab" \
		| sed -r 's/'$ap_in'/'$ap_out'/g' \
		| sed -r 's/'$hs_in'/'$hs_out'/g' \
		| sed -r 's/'$et_in'/'$et_out'/g' \
		| sed  -n '1p;$p' \
		| sed  ':a;N;$!ba;s/\n//g')
	echo -n "$tmp_stab" > "$pref_stab"
fi

# Cleanup backup files, keep requested number of backups
if [[ $backup ]]; then
	let keep=$keep+1
	if [[ -f "$pref_snap" ]]; then
		find -H "$HOME/.config/vivaldi-snapshot/Default" -name 'Preferences*.bak' -type f -print0 \
		| xargs -0 stat --format "%Y %n" | sort -rn | cut -d' ' -f2- | tail -n +$keep \
		| xargs -d'\n' rm 2>/dev/null
	fi
	if [[ -f "$pref_stab" ]]; then
		find -H "$HOME/.config/vivaldi/Default" -name 'Preferences*.bak' -type f -print0 \
		| xargs -0 stat --format "%Y %n" | sort -rn | cut -d' ' -f2- | tail -n +$keep \
		| xargs -d'\n' rm 2>/dev/null
	fi
fi
