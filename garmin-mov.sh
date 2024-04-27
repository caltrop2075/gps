#!/usr/bin/bash
#------------------------------------------------------------------------------#
#                            Programmed By Liz                                 #
#------------------------------------------------------------------------------#
# move garmin stuff
#-------------------------------------------------------------------------------
source ~/data/global.dat
dir="/home/caltrop/WinXP/Garmin"
#-------------------------------------------------------------------------------
title-80.sh -t line "Moving GPX & WPT"
while read ext
do
#                                            move from base directory
   des="$dir/$ext"
   printf "$Wht%s$nrm\n" "$des"
   mkdir -p "$des"
   find "$dir" -maxdepth 1 -type f -name "*.$ext" \! -name "_*" | sort |
   while read src
   do
      echo "$src"
      mv "$src" "$des"
   done
#                                            move from destination directoty
   find "$dir/$ext" -maxdepth 1 -type f \! -name "*.$ext" | sort |
   while read src
   do
      des="$dir/${src##*.}"                  # destination
      echo "$src -> $des"
      mv "$src" "$des"
   done
   echo
done << EOF
gpx
txt
wpt
EOF
#-------------------------------------------------------------------------------
