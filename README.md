# gps
gps for viking &amp; garmin

delorme-gpx.awk
--------------------------------------------------------------------------------
extract GPX waypoints only

<?xml version="1.0" encoding="UTF-8"?>
<gpx version="1.0" creator="Lis">
<wpt lat="39.512572680" lon="-84.996385016">
<name>Brookville</name>                      not needed
<cmt>Brookville Lake</cmt>                   not needed
<desc>Brookville Lake</desc>
<sym>Anchor</sym>                            not needed
</wpt>
</gpx/


delorme-gpx.sh
--------------------------------------------------------------------------------
GPX -> DeLorme AN1 -> WinXP/Delorme

then in windows copy the AN1 from the shared folder/network drive to
C:DeLorme DocsDraw & FUCK with DeLorme Topo USA
if it is the same file name NO FUCKING needed
...shows you how much I like DeLorme Topo USA - a KLUDGE!!!

WARNING!
uses <desc>Greensburg</desc> NOT <name>0 HOME</name> & the default FLAG

GPS Babel OPTIONS GLITCH  -r -t -w    ALL are used no matter what

delorme-txt.awk
--------------------------------------------------------------------------------

delorme-txt.sh
--------------------------------------------------------------------------------
DeLorme drawing TXT -> GPX

foretrex.sh
--------------------------------------------------------------------------------
'garmin.sh' replacement for managing Garmin ForeTrex GPS
much simpler than 'garmin.sh' though 'garmin-cvt.sh' uses awk routines
copies GPS GPX, converts, then moves to separate directories
does GPX waypoints, routes & tracks -> WPT

garmin-an1.sh
--------------------------------------------------------------------------------
DeLorme AN1 -> GPX

GPS Babel OPTIONS GLITCH  -r -t -w    ALL are used no matter what

garmin-cvt.sh
--------------------------------------------------------------------------------
auto convert various GPS files based on file extension
output to same directory as source

most waypoint only, for now
added file exist & extension check
added waypoint counters at end of files

any GPS file garmin-cvt.sh        runs one of the following
GPX -> MPS   [no program]         does not work, something with MapSource 5.4
GPX -> WPT   garmin-gpx.awk       waypoints, have to use crappy WPT PCX5
             garmin-gpx-rte.awk   routes
             garmin-gpx-trk.awk   tracks
MPS -> GPX   garmin-mps.sh        gpsbabel works fine but NOT the inverse
TXT -> GPX   garmin-txt.awk       waypoints, doene as an exercise, use MPS -> GPX
             [no program]         routes & tracks too problematic
VIK -> GPX   garmin-vik.awk       waypoints

2024-03-30 WPT duplicate name fix, forgot about this issue
2024-04-02 fixed extension change glitch
           added an1 & json conversions
2024-04-03 added notify-send
2024-04-05 changed notify icon

garmin-del.sh
--------------------------------------------------------------------------------
delete empty files

garmin-gpx-rte.awk
--------------------------------------------------------------------------------
GPX -> WPT PCX5 -> MapSource

2024-03-30 WPT duplicate name fix, forgot about this issue

garmin-gpx-trk.awk
--------------------------------------------------------------------------------
 GPX -> WPT PCX5 -> MapSource

2024-03-30 WPT duplicate name fix, forgot about this issue

garmin-gpx.awk
--------------------------------------------------------------------------------
GPX -> WPT PCX5 -> MapSource

2024-03-30 WPT duplicate name fix, forgot about this issue

garmin-json.sh
--------------------------------------------------------------------------------
JSON -> GPX

GPS Babel OPTIONS GLITCH  -r -t -w    ALL are used no matter what

garmin-mov.sh
--------------------------------------------------------------------------------
move garmin stuff

garmin-mps.sh
--------------------------------------------------------------------------------
MapSource MPS -> GPX

GPS Babel OPTIONS GLITCH  -r -t -w    ALL are used no matter what

garmin-pre.awk
--------------------------------------------------------------------------------
GPX pre process
converts one long GPX
flg=0  into lines
flg!=0 formats lines

2024-03-31 cleand up indent logic

garmin-txt.awk
--------------------------------------------------------------------------------
MapSource ->  TXT -> GPX

waypoints only, minimal data
nicely formatted with all the proper indents

garmin-upd.sh
--------------------------------------------------------------------------------
update WinXP GPS files
 garmin MPS -> GPX
delorme AN1 -> GPX

using 'tty' to detect no terminal, 'not a tty' is not documented
the 'not a tty' runs faster

garmin-vik.awk
--------------------------------------------------------------------------------
Viking VIK -> GPX

2024-03-31 trimmed code, fixed glitches, added tags

garmin-xfr.awk
--------------------------------------------------------------------------------

garmin.awk
--------------------------------------------------------------------------------
extract tracks & waypoints

todo: indent

garmin.sh
--------------------------------------------------------------------------------
WARNING! now using 'foretrex.sh'

garmin GPX data processing
extract waypoints & tracks from gpx

never processed routes from GPS
always done with mapping software then transferred to GPS

old compiled C program 2018
process wherever the ~/WinXP/GarminGPX.cfg is located, need to change dir
GPX files are indented
track gpx -> wpt is broken by segments
files:
    ~/.local/bin/gpx
    ~/WinXP/Garmin/GPX.cfg
    ~/WinXP/Garmin/Current.gpx       GPS -> comp, then process
    ~/WinXP/Garmin/Current-TRK.gpx   modern GPX
    ~/WinXP/Garmin/Current-WPT.gpx
    ~/WinXP/Garmin/Current-TRK.wpt   old PCX5 WPT, older than Garmin MPS
    ~/WinXP/Garmin/Current-WPT.wpt

new script programs 2022
no config, no change dir, more verbose, no indentation yet...
files were in 'data' but moved to 'Map' to be with 'Viking'
track gpx -> wpt is broken by tracks, segments are combined
files:
    ~/.local/bin/garmin.sh           main program
    ~/.local/bin/garmin.sed          break into lines
    ~/.local/bin/garmin.awk          extract tracks & waypoints -> gpx
    ~/.local/bin/garmin-xfr.awk      PCX5 conversion
    ~/Map/garmin-trk.gpx             modern GPX
    ~/Map/garmin-wpt.gpx
    ~/Map/garmin-trk.wpt             old PCX5
    ~/Map/garmin-wpt.wpt
modified so all trkpt on one line like the C program
    <trkpt lat="39.218405" lon="-85.885499"><ele>193.84</ele><time>2022-05-31T17:44:00Z</time></trkpt>

source ~/data/global.dat

dev="$MEDIA/GARMIN/Garmin/GPX/Current.gpx"         # nuvi, defunct
dev="$MEDIA/GARMIN/Garmin/GPX/current/Current.gpx" # foretrex

dir="$HOME/Map/Garmin/GPX/current"                 # Linux Map
dir="$HOME/WinXP/Garmin"                           # WinXP

src="$dir/Current.gpx"

if [ -f "$dev" ]
then
clear
