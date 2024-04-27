#!/usr/bin/awk -f
#------------------------------------------------------------------------------#
#                            Programmed By Liz                                 #
#------------------------------------------------------------------------------#
#  GPX -> WPT PCX5 -> MapSource
#
# 2024-03-30 WPT duplicate name fix, forgot about this issue
#===============================================================================
BEGIN {
   lst=""                                                # last nam
   cnt=0                                                 # nam mod counter
   flg=0
   printf("H  SOFTWARE NAME & VERSION\n")
   printf("I  PCX5 2.00\n\n")
   printf("H  R DATUM               IDX DA            DF            DX            DY            DZ\n")
   printf("M  G WGS84               100 +0.000000e+00 +0.000000e+00 +0.000000e+00 +0.000000e+00 +0.000000e+00\n\n")
   printf("H  COORDINATE SYSTEM\n")
   printf("U  LAT LON DM\n")
}
#===============================================================================
{
   gsub(/&apos;/,"'")
   gsub(/&amp;/,"\\&")
   switch($0)
   {
      case /<trk>/ :                                     # track
         printf("\nH  LATITUDE   LONGITUDE   DATE      TIME     ALT\n")
         break
      case /<trkpt / :                                   # track point
         n=split(substr($2,6,length($2)-6),a,".")
         lat=sprintf("%+03d%07.4f",a[1],("."a[2])*60)
         sub(/+/,"N",lat)
         sub(/-/,"S",lat)

         n=split(substr($3,6,length($3)-7),a,".")
         lon=sprintf("%+04d%07.4f",a[1],("."a[2])*60)
         sub(/+/,"E",lon)
         sub(/-/,"W",lon)
         break
      case /<ele>/ :                                     # name
         sub(/^ */,"")                                   # trim leading space
         gsub(/<.?ele>/,"")                              # remove tags
         alt=$0
         break
      case /<\/trkpt>/ :
         printf("T  %s %s %s %s %05d\n",lat,lon,dte,tim,alt)
         break
      case /<\/trk>/ :
         break
   }
}
#===============================================================================
END {
}
#===============================================================================
# functions
#-------------------------------------------------------------------------------
#===============================================================================
