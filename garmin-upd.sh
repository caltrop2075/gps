#!/usr/bin/bash
#------------------------------------------------------------------------------#
#                            Programmed By Liz                                 #
#------------------------------------------------------------------------------#
# update WinXP GPS files
#  garmin MPS -> GPX
# delorme AN1 -> GPX
#
# using 'tty' to detect no terminal, 'not a tty' is not documented
# the 'not a tty' runs faster
#================================================================ initialization
# clear
source ~/data/global.dat
tty=$(tty)                                         # tty detect
#===================================================================== functions
function fx_slee ()                                # sleep control
{
   if [[ $tty != "not a tty" ]]                    # ignore non-terminal, ie keydef
   then
      sleep $1
   fi
}
#-------------------------------------------------------------------------------
function fx_noti ()                                # notifications
{
   notify-send -i "$i_recy" "$1" "$2"
   title-80.sh -t line "$1\n$2"
   # fx_slee 1
   sleep 1                                         # like this better
}
#-------------------------------------------------------------------------------
function fx_scan ()                                # scan & process data
{
   cnt=0
   upd=0
   while read src
   do
      ((cnt++))                                    # scan count
      dir=${src%/*}                                # directory
      des="$dir/gpx"                               # destination dir
      fil=${src##*/}                               # file name
      nam=${fil%.*}                                # name w/o ext
      cvt="$des/$nam.gpx"                          # gpx file to test
      printf "$grn%-100s$nrm\r" "..${src#$bse}"    # progress
      fx_slee 0.02
      if [ "$src" -nt "$cvt" ]                     # new MPS/AN1
      then
         ((upd++))                                 # updated count
         printf "%-100s\n" "..${src#$bse}"         # progress
         garmin-cvt.sh "$src" > /dev/null          # convert & suppress output
         mkdir -p "$des"                           # dir ?
         mv "$dir/$nam.gpx" "$des"                 # move GPX
      fi
   done
   printf "%-100s\r" ""                            # erase progress line
   printf "${Wht}scanned: %3d   updated: %3d$nrm\n" "$cnt" "$upd" # stats
   fx_slee 1
}
#================================================================== main program
bse="$HOME/WinXP/Garmin"                           # garmin
fx_noti "Garmin Update" "MPS -> GPX\n\$HOME${bse#$HOME}"
find "$bse" -type f -name "*.mps" | sort | fx_scan

bse="$HOME/WinXP/DeLorme"                          # delorme
fx_noti "DeLorme Update" "AN1 -> GPX\n\$HOME${bse#$HOME}"
find "$bse" -type f -name "*.an1" | sort | fx_scan

notify-send -i "$i_cat" "Garmin/DeLorme Update" "finished" # finished
#===============================================================================
