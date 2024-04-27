#!/usr/bin/bash
#------------------------------------------------------------------------------#
#                            Programmed By Liz                                 #
#------------------------------------------------------------------------------#
# WARNING! now using 'foretrex.sh'
#
# garmin GPX data processing
# extract waypoints & tracks from gpx
#
# never processed routes from GPS
# always done with mapping software then transferred to GPS
#
# old compiled C program 2018
# process wherever the ~/WinXP/GarminGPX.cfg is located, need to change dir
# GPX files are indented
# track gpx -> wpt is broken by segments
# files:
#     ~/.local/bin/gpx
#     ~/WinXP/Garmin/GPX.cfg
#     ~/WinXP/Garmin/Current.gpx       GPS -> comp, then process
#     ~/WinXP/Garmin/Current-TRK.gpx   modern GPX
#     ~/WinXP/Garmin/Current-WPT.gpx
#     ~/WinXP/Garmin/Current-TRK.wpt   old PCX5 WPT, older than Garmin MPS
#     ~/WinXP/Garmin/Current-WPT.wpt
#
# new script programs 2022
# no config, no change dir, more verbose, no indentation yet...
# files were in 'data' but moved to 'Map' to be with 'Viking'
# track gpx -> wpt is broken by tracks, segments are combined
# files:
#     ~/.local/bin/garmin.sh           main program
#     ~/.local/bin/garmin.sed          break into lines
#     ~/.local/bin/garmin.awk          extract tracks & waypoints -> gpx
#     ~/.local/bin/garmin-xfr.awk      PCX5 conversion
#     ~/Map/garmin-trk.gpx             modern GPX
#     ~/Map/garmin-wpt.gpx
#     ~/Map/garmin-trk.wpt             old PCX5
#     ~/Map/garmin-wpt.wpt
# modified so all trkpt on one line like the C program
#     <trkpt lat="39.218405" lon="-85.885499"><ele>193.84</ele><time>2022-05-31T17:44:00Z</time></trkpt>

source ~/data/global.dat

dev="$MEDIA/GARMIN/Garmin/GPX/Current.gpx"         # nuvi, defunct
dev="$MEDIA/GARMIN/Garmin/GPX/current/Current.gpx" # foretrex

dir="$HOME/Map/Garmin/GPX/current"                 # Linux Map
dir="$HOME/WinXP/Garmin"                           # WinXP

src="$dir/Current.gpx"

if [ -f "$dev" ]
then
   clear
#------------------------------------------------------- garmin gpx -> trk & wpt
   title-80.sh -t double "Processing Garmin GPS Data"
   echo "copy data from device"
   cp "$dev" "$src"
   echo "deleting associated GPX"
   while read tgt
   do
      echo "   $tgt"
      find "$HOME/Map" -type f -name "$tgt*.gpx" -delete
      sleep 0.5
   done <<- EOF
	Archive
	ForeTrex
	Home
	eMap
	eTrex
	symbols
	EOF
   sleep 2
#------------------------------------------------------- process with C         
   title-80.sh -t line "process with C (16 Feb 2018)\n~/WinXP/Garmin"
   sleep 1
   cd "$dir"
   pwd
   gpx
   cd
   pwd
   sleep 1
#------------------------------------------------------- process with awk/sed   
   title-80.sh -t line "process with awk (05 Jun 2022)\n~/Map"
   sleep 1
   t="$HOME/Map/garmin-trk.wpt"
   w="$HOME/Map/garmin-wpt.wpt"
   cat "$src" | garmin.sed | garmin.awk -v t=$t -v w=$w
   sleep 1
# init wpt files
# tracks
   printf "H  SOFTWARE NAME & VERSION\n" > $t
   printf "I  PCX5 2.00\n\n" >> $t
   printf "H  R DATUM               IDX DA            DF            DX            DY            DZ\n" >> $t
   printf "M  G WGS84               100 +0.000000e+00 +0.000000e+00 +0.000000e+00 +0.000000e+00 +0.000000e+00\n\n" >> $t
   printf "H  COORDINATE SYSTEM\n" >> $t
   printf "U  LAT LON DM\n" >> $t
#          1  3          4           5         6        7
#          H  LATITUDE   LONGITUDE   DATE      TIME     ALT
# waypoints
   printf "H  SOFTWARE NAME & VERSION\n" > $w
   printf "I  PCX5 2.00\n\n" >> $w
   printf "H  R DATUM               IDX DA            DF            DX            DY            DZ\n" >> $w
   printf "M  G WGS84               100 +0.000000e+00 +0.000000e+00 +0.000000e+00 +0.000000e+00 +0.000000e+00\n\n" >> $w
   printf "H  COORDINATE SYSTEM\n" >> $w
   printf "U  LAT LON DM\n\n" >> $w
#          1  2      3          4           5         6        7     8
   printf "H  IDNT   LATITUDE   LONGITUDE   DATE      TIME     ALT   DESCRIPTION                              PROXIMITY   SYMBOL\n" >> $w
# trk & wpt -> xfr format
   title-80.sh -t double "converting data for mapsource transfer\nPCX5 format"
   sleep 3
   title-80.sh -t line "waypoints"
   sleep 1
   cat ~/Map/garmin-wpt.gpx | garmin-xfr.awk -v t=$t -v w=$w
   sleep 1
   title-80.sh -t line "tracks"
   sleep 1
   cat ~/Map/garmin-trk.gpx | garmin-xfr.awk -v t=$t -v w=$w
   sleep 1
#------------------------------------------------------- tree                   
   unset LC_ALL
   echo "device tree"
   tree $MEDIA/GARMIN -P "*.gpx|*.rte|*.xml|*.bin" --ignore-case >> ~/Map/garmin-tree.txt
   export LC_ALL=C
#------------------------------------------------------- lines of code          
   title-80.sh -t line "lines of code"
   t=0
   for tgt in $dir/Current-* $HOME/Map/garmin-*
   do
      l=$(cat $tgt | wc -l)
      t=$(( $t + $l ))
      f=${tgt#$HOME/Map/}
      printf "%6d %s\n" $l $f
   done
   printf "%s\n%6d %s\n" "---------------------" $t "lines"
else
   echo -e "\nERROR: GPS device not found"
fi
