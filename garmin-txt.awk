#!/usr/bin/awk -f
#------------------------------------------------------------------------------#
#                            Programmed By Liz                                 #
#------------------------------------------------------------------------------#
# MapSource ->  TXT -> GPX
#
# waypoints only, minimal data
# nicely formatted with all the proper indents
#===============================================================================
BEGIN {
#-------------------------------------------------------------------------------
# Header	Name	Description	Type	Position	Altitude	Depth	Proximity	Display Mode	Color	Symbol	Facility	City	State	Country
# Waypoint	0 center	center zoom 500 ft	User Waypoint	N40.33658 W83.63952				Symbol	Unknown	Waypoint
#-------------------------------------------------------------------------------
# FILEDS/COLUMNS     used
#  1  Header
#  2  Name           <<<
#  3  Description    <<<
#  4  Type
#  5  Position       <<<
#  6  Altitude
#  7  Depth
#  8  Proximity
#  9  Display Mode
# 10  Color
# 11  Symbol         <<<
# 12  Facility
# 13  City
# 14  State
# 15  Country
#-------------------------------------------------------------------------------
# WAYPOINT FORMAT
#  <wpt lat="39.794986155" lon="-86.088945642">
#     <name>+000</name>
#     <cmt>Contact, Afro</cmt>
#     <desc>Contact, Afro</desc>
#     <sym>Contact, Afro</sym>
#  </wpt>
#-------------------------------------------------------------------------------
   FS="\t"                                # field separator

   r1="\\&amp;"                           # replacements
   r2="\\&apos;"

   printf("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n") # file header
   printf("<gpx version=\"1.0\" creator=\"Liz\">\n")
   printf("   <name>Imported File</name>\n")
   printf("   <desc>Garmin TXT -> GPX</desc>\n")
   printf("   <time>%s</time>\n",dte)
}
#===============================================================================
{
   if($1 == "Grid")
   {
      sub(/\xb0/,"°",$2)                  # degree text glitch
      grd=$2
   }
   if($1 == "Datum")
      dat=$2
   if($1=="Waypoint" && $4=="User Waypoint") # filter data
   {
      if($1 != "Header" && $3!="Description")
      {
         gsub(/&/,r1,$2)                  # replacements
         gsub(/&/,r1,$3)                  # ampersand
         gsub(/'/,r2,$2)              # ' # apostrophe
         gsub(/'/,r2,$3)              # '
#-------------------------------------------------------------------------------
         n=split($5,a," ")                # split lat lon

         lat=a[1]                         # +/- lat
         sub(/N/,"+",lat)
         sub(/S/,"-",lat)

         lon=a[2]                         # +/- lon
         sub(/E/,"+",lon)
         sub(/W/,"-",lon)
#-------------------------------------------------------------------------------
         printf("   <wpt lat=\"%s\" lon=\"%s\">\n",lat,lon)
         printf("      <name>%s</name>\n",$2)
         printf("      <desc>%s</desc>\n",$3)
         printf("      <sym>%s</sym>\n",$11)
         printf("   </wpt>\n")
      }
   }
}
#===============================================================================
END {
   printf("%s\n","</gpx>")                # file footer
   w=5
   printf("\n")
   printf("%s %-"w"s: %s %s \n","<!--","Grid:",grd,"-->")
   printf("%s %-"w"s %s %s \n","<!--","Datum:",dat,"-->")
}
#===============================================================================
# functions
#-------------------------------------------------------------------------------
#===============================================================================
