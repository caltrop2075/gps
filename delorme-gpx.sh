#!/usr/bin/bash
#------------------------------------------------------------------------------#
#                            Programmed By Liz                                 #
#------------------------------------------------------------------------------#
# GPX -> DeLorme AN1 -> WinXP/Delorme
#
# then in windows copy the AN1 from the shared folder/network drive to
# C:\DeLorme Docs\Draw & FUCK with DeLorme Topo USA
# if it is the same file name NO FUCKING needed
# ...shows you how much I like DeLorme Topo USA - a KLUDGE!!!
#
# WARNING!
# uses <desc>Greensburg</desc> NOT <name>0 HOME</name> & the default FLAG
#
# GPS Babel OPTIONS GLITCH  -r -t -w    ALL are used no matter what
#-------------------------------------------------------------------------------
tmp="$HOME/temp/temp.gpx"                    # temp.gpx
des="/home/caltrop/WinXP/DeLorme"            # destination directory
dir=${1%/*}                                  # source directory
fil=${1##*/}                                 # file name
nam=${fil%.*}                                # name
tgt="$dir/$nam.an1"                          # conversion target
delorme-gpx.awk < "$1" > "$tmp"              # extract waypoints only
gpsbabel -i gpx -f "$tmp" -o an1 -F "$tgt"   # GPX -> AN1
mv "$tgt" "$des"                             # move to delorme directory
#-------------------------------------------------------------------------------
