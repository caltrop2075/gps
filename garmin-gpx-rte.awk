#!/usr/bin/awk -f
#------------------------------------------------------------------------------#
#                            Programmed By Liz                                 #
#------------------------------------------------------------------------------#
# GPX -> WPT PCX5 -> MapSource
#
# 2024-03-30 WPT duplicate name fix, forgot about this issue
#===============================================================================
BEGIN {
   lst=""                                                # last nam
   tmp=""
   cnt=0                                                 # nam mod counter
   rte=0
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
      case /<rte>/ :                                     # route
         flg=1
         break
      case /<rtept / :                                   # route point
         n=split(substr($2,6,length($2)-6),a,".")
         lat=sprintf("%+03d%07.4f",a[1],("."a[2])*60)
         sub(/+/,"N",lat)
         sub(/-/,"S",lat)

         n=split(substr($3,6,length($3)-7),a,".")
         lon=sprintf("%+04d%07.4f",a[1],("."a[2])*60)
         sub(/+/,"E",lon)
         sub(/-/,"W",lon)
         break
      case /<name>/ :                                    # name
         sub(/^ */,"")                                   # trim leading space
         gsub(/<.?name>/,"")                             # remove tags
         nam=$0
         if(flg)                                         # route init
         {
            printf("\nR  %02d  %-20.20s\n\n",rte,nam)
            printf("H  IDNT   LATITUDE   LONGITUDE   DATE      TIME     ALT   DESCRIPTION                              PROXIMITY   SYMBOL\n")
            rte++
            flg=0
         }
         break
      case /<desc>/ :                                    # description
         sub(/^ */,"")                                   # trim leading space
         gsub(/<.?desc>/,"")                             # remove tags
         dsc=$0
         break
      case /<\/rtept>/ :
         nam=sprintf("%-6.6s",nam)
         tmp=substr(nam,1,5)
         if(tmp==lst)
         {
            nam=tmp cnt
            cnt++
         }
         else
            cnt=0
         printf("W  %s %s %s %s %s %05d %-40s %7.5e %02d\n",nam,lat,lon,dte,tim,0,dsc,0,18)
         break
      case /<\/rte>/ :
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
