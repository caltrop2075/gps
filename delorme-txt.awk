#!/usr/bin/awk -f
#------------------------------------------------------------------------------#
#                            Programmed By Liz                                 #
#------------------------------------------------------------------------------#
#===============================================================================
BEGIN {
   printf ("%s\n","<?xml version=\"1.0\" encoding=\"UTF-8\"?>")
   printf ("%s\n","<gpx version=\"1.0\" creator=\"Liz\">")

   FS=","
}
#===============================================================================
{
   if($0 != "BEGIN SYMBOL" && $0 != "END")
   {
      printf("   <wpt lat=\"%s\" lon=\"%s\">\n",$1,$2)
      printf("      <name>%s</name>\n",$3)
      # printf("      <sym>Waypoint</sym>\n")
      printf("   </wpt>\n")
   }
}
#===============================================================================
END {
   printf ("%s\n","</gpx>")
}
#===============================================================================
# functions
#-------------------------------------------------------------------------------
#===============================================================================