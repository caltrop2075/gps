#!/usr/bin/bash
#------------------------------------------------------------------------------#
#                            Programmed By Liz                                 #
#------------------------------------------------------------------------------#
# 'garmin.sh' replacement for managing Garmin ForeTrex GPS
# much simpler than 'garmin.sh' though 'garmin-cvt.sh' uses awk routines
# copies GPS GPX, converts, then moves to separate directories
# does GPX waypoints, routes & tracks -> WPT
#-------------------------------------------------------------------------------
dev="$MEDIA/GARMIN/Garmin/GPX/current/Current.gpx" # foretrex
dir="$HOME/WinXP/Garmin"                           # WinXP
src="$dir/${dev##*/}"                              # GPX source on system
tmp="$HOME/temp/temp.gpx"                          # temporary conversion
if [ -f "$dev" ]
then
   clear
   cp "$dev" "$src"                                # get GPS GPX
   garmin-pre.awk < "$src" > "$tmp"                # break GPX into lines
   garmin-pre.awk -v flg=1 < "$tmp" > "$src"       # format GPX lines
   garmin-cvt.sh "$src"                            # convert GPX -> WPT rte trk
   garmin-mov.sh                                   # move -> gpx txt wpt
   garmin-del.sh                                   # delete empty wpt files
else
   echo -e "\nERROR: GPS device not found"
fi
#-------------------------------------------------------------------------------
# series.sh "Star Trek/03 TNG" 04
#-------------------------------------------------------------------------------
