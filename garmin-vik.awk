#!/usr/bin/awk -f
#------------------------------------------------------------------------------#
#                            Programmed By Liz                                 #
#------------------------------------------------------------------------------#
# Viking VIK -> GPX
#
# 2024-03-31 trimmed code, fixed glitches, added tags
#===============================================================================
BEGIN {
#-------------------------------------------------------------------------------
# 1               2                    3                     4
# type="waypoint" latitude="39.337216" longitude="-85.46356" name="Park E Picnic 2" unixtime="1687030644" symbol="picnic area"
#-------------------------------------------------------------------------------
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
   if($1 ~ /^type="waypoint"/)
   {
#-------------------------------------------------------------------------------
      sub(/latitude/,"lat",$2)
      sub(/longitude/,"lon",$3)
      printf("   <wpt %s %s>\n",$2,$3)
#-------------------------------------------------------------------------------
      n=split($0,a,/[a-z]*=/,f)
      for(i=1;i<n;i++)
      {
         sub(/ *$/,"",a[i+1])             # trim trailing spaces
         sub(/=/,"",f[i])                 # replacements
         gsub(/"/,"",a[i+1])              # "
         gsub(/&/,r1,a[i+1])
         gsub(/'/,r2,a[i+1])              # '
         switch(f[i])
         {
            case "name" :
               printf("      <name>%s</name>\n",a[i+1])
               break
            case "symbol" :
               printf("      <sym>%s</sym>\n",a[i+1])
               break
            case "unixtime" :
               cmd="date -d @"a[i+1]" +\"%FT%TZ\""
               cmd | getline tim
               close(cmd)
               printf("      <time>%s</time>\n",tim)
               break
            case "comment" :
               printf("      <cmt>%s</cmt>\n",a[i+1])
               break
            case "description" :
               printf("      <desc>%s</desc>\n",a[i+1])
               break
            case "altitude" :
               printf("      <ele>%s</ele>\n",a[i+1])
               break
            case "" :
               break
         }
      }
#-------------------------------------------------------------------------------
      printf("   </wpt>\n")
#-------------------------------------------------------------------------------
   }
}
#===============================================================================
END {
   printf("%s\n","</gpx>")                # file footer
}
#===============================================================================
# functions
#-------------------------------------------------------------------------------
#===============================================================================
