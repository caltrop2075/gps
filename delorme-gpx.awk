#!/usr/bin/awk -f
#------------------------------------------------------------------------------#
#                            Programmed By Liz                                 #
#------------------------------------------------------------------------------#
# extract GPX waypoints only
#
# <?xml version="1.0" encoding="UTF-8"?>
# <gpx version="1.0" creator="Lis">
   # <wpt lat="39.512572680" lon="-84.996385016">
    # <name>Brookville</name>                      not needed
    # <cmt>Brookville Lake</cmt>                   not needed
    # <desc>Brookville Lake</desc>
    # <sym>Anchor</sym>                            not needed
   # </wpt>
# </gpx/
#
#===============================================================================
BEGIN {
   printf ("%s\n","<?xml version=\"1.0\" encoding=\"UTF-8\"?>")
   printf ("%s\n","<gpx version=\"1.0\" creator=\"Liz\">")
   flg=1
}
#===============================================================================
{
   if($0 ~ /<rte>/)                 # don't print rout stuff
         flg=0
   if(flg)                          # print waypoint stuff
      switch($0)                    # only print necessary waypoint stuff
      {
         case /<wpt.*>/ :
         case /<desc>.*<\/desc>/ :
         case /<\/wpt>/ :
            print
      }
   if($0 ~ /<\/rte>/)
         flg=1
}
#===============================================================================
END {
   printf ("%s\n","</gpx>")
}
#===============================================================================
# functions
#-------------------------------------------------------------------------------
#===============================================================================
