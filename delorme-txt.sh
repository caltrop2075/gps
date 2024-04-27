#!/usr/bin/bash
#------------------------------------------------------------------------------#
#                            Programmed By Liz                                 #
#------------------------------------------------------------------------------#
# DeLorme drawing TXT -> GPX
#-------------------------------------------------------------------------------
clear
source ~/data/global.dat
dir="/home/caltrop/WinXP/DeLorme"
gpx="$dir/gpx"
#-------------------------------------------------------------------------------
find "$dir" -maxdepth 1 -type f -name "*.txt" | sort |
while read src
do
   title-80.sh "$src"
   fil=${src##*/}
   des="$dir/${fil%.*}.gpx"
   printf "%s\n%s\n\n" "$src" "$des"
   cat "$src" | dos-linux.sed | delorme-txt.awk | tee "$des"
   mkdir -p "$gpx"
   mv "$des" "$gpx"
done
#-------------------------------------------------------------------------------
