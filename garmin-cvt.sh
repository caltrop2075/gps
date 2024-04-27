#!/usr/bin/bash
#------------------------------------------------------------------------------#
#                            Programmed By Liz                                 #
#------------------------------------------------------------------------------#
# auto convert various GPS files based on file extension
# output to same directory as source
#
# most waypoint only, for now
# added file exist & extension check
# added waypoint counters at end of files
#
# any GPS file garmin-cvt.sh        runs one of the following
# GPX -> MPS   [no program]         does not work, something with MapSource 5.4
# GPX -> WPT   garmin-gpx.awk       waypoints, have to use crappy WPT PCX5
#              garmin-gpx-rte.awk   routes
#              garmin-gpx-trk.awk   tracks
# MPS -> GPX   garmin-mps.sh        gpsbabel works fine but NOT the inverse
# TXT -> GPX   garmin-txt.awk       waypoints, doene as an exercise, use MPS -> GPX
#              [no program]         routes & tracks too problematic
# VIK -> GPX   garmin-vik.awk       waypoints
#
# 2024-03-30 WPT duplicate name fix, forgot about this issue
# 2024-04-02 fixed extension change glitch
#            added an1 & json conversions
# 2024-04-03 added notify-send
# 2024-04-05 changed notify icon
#-------------------------------------------------------------------------------
# clear
source ~/data/global.dat
dly=1
#-------------------------------------------------------------------------------
function fx_warn ()
{
   notify-send -i "$i_expl" "$1" "$2"
   printf "\n$1 $2\n"
}

function fx_noti ()
{
   notify-send -i "$i_volt" "$1" "$2"
   printf "\n$1 $2\n"
}

function fx_title ()                      # title
{
   fil=${src##*/}
   fil="${fil%.*}.$2"
   des="${src%/*}/$fil"
   if [ "$src" -nt "$des" ]
   then
      fx_noti "CONVERTING" "${src#$HOME} -> ${des##*/}"
      msg="${1^^} -> ${2^^}"
      case $1 in
          an1  ) msg="$msg | all data";;
          gpx  ) msg="$msg | waypoint only";;
         .gpx  ) msg="$msg | route / track";;
          json ) msg="$msg | all data";;
          mps  ) msg="$msg | all data";;
          txt  ) msg="$msg | waypoint only";;
          vik  ) msg="$msg | waypoint only";;
      esac
      dir=${src%/*}
      dir="~${dir#$HOME}"
      title-80.sh -t line "GPS File Convert | $msg\n$dir\n${src##*/} -> ${des##*/}"
   else
      fx_warn "NO CONVERSION" "~${src#$HOME} -> ${des##*/}"
      exit
   fi
   sleep $dly
}

function fx_cnt ()                        # GPX waypoint counter
{
   cnt=0
   while read lin
   do
      if [[ "$lin" =~ \<wpt ]]
      then
         ((cnt++))
      fi
   done < "$des"
   printf "\n<!-- waypoints: %03d -->\n" "$cnt" | tee -a "$des"
   sleep $dly
}
#-------------------------------------------------------------------------------
if [ -f "$1" ]                            # file exist
then
   ext=${1##*.}
   src="$1"
   tmp="$HOME/temp/temp.txt"
   case $ext in
      an1 )                               # AN1 -> GPX
         fx_title an1 gpx
         garmin-an1.sh "$src" "$des"
         cat "$des"
         fx_cnt
         ;;
      gpx )                               # GPX -> WPT
         fx_title gpx wpt                 # waypoints
         garmin-gpx.awk -v dte=$(date +"%d-%b-%y") -v tim=$(date +"%T") < "$src" | tee "$des"
         printf "\nC  waypoints: %s\n" "$(($(wc -l < "$des")-10))" | tee -a "$des"
         sleep 1
         fx_title .gpx -rte.wpt           # routes
         garmin-gpx-rte.awk -v dte=$(date +"%d-%b-%y") -v tim=$(date +"%T") < "$src" | tee "$des"
         sleep 1
         fx_title .gpx -trk.wpt           # tracks
         garmin-gpx-trk.awk -v dte=$(date +"%d-%b-%y") -v tim=$(date +"%T") < "$src" | tee "$des"
         sleep $dly
         ;;
      json )                              # JSON -> GPX
         fx_title json gpx
         garmin-json.sh "$src" "$des"
         cat "$des"
         fx_cnt
         ;;
      mps )                               # MPS -> GPX
         fx_title mps gpx
         garmin-mps.sh "$src" "$des"
         cat "$des"
         fx_cnt
         ;;
      txt )                               # TXT -> GPX
         fx_title txt gpx
         dos-linux.sed < "$src" > "$tmp"  # text DOS -> Linux
         garmin-txt.awk -v dte=$(date -u +"%FT%TZ") < "$tmp" | tee "$des"
         fx_cnt
         ;;
      vik )                               # VIK -> GPX
         fx_title vik gpx
         garmin-vik.awk -v dte=$(date -u +"%FT%TZ") < "$src" | tee "$des"
         fx_cnt
         ;;
      *)
         fx_warn "ERROR!" "file EXTENSION not found"
   esac
else
   fx_warn "ERROR!" "FILE not found"
fi
#-------------------------------------------------------------------------------
