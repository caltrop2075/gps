#!/usr/bin/awk -f
#------------------------------------------------------------------------------#
#                            Programmed By Liz                                 #
#------------------------------------------------------------------------------#
#===============================================================================
# mapsource PCX5 conversion

# ToDo: track time

BEGIN {
   d=""
   for(i=0;i<35;i++)
      d=d"-"
   k=1
   l=""
}
#===============================================================================
{
   gsub(/&amp;/,"\\&")                                # $amp;  -> &
   gsub(/&apos;/,"'")                                 # $apos; -> '

   switch($0)
   {
#------------------------------------------------------------------------ tracks
      case /<trk>/ :
         f=1
         fx_init()
         break
      case /<\/trk>/ :
         f=0
         break
      case /<trkpt.*>/ :
         sub(/<trkpt /,"")
         n=split($0,r,"><")
         x=r[1]
         fx_loc()
         sub(/ele>/,"",r[2])
         sub(/<\/ele/,"",r[2])
         a[7]=sprintf("%05.f",r[2])
         printf("%-3s","T") >> t
         for(i=3;i<7;i++)
            printf("%s",a[i]) >>t
         printf("%s\n",a[7]) >> t
         break
      case /<trkseg>/ :
         break
#--------------------------------------------------------------------- waypoints
      case /<wpt.*>/ :
         f=2
         fx_init()
         sub(/<wpt /,"")
         x=$0
         fx_loc()
         break
      case /<\/wpt>/ :
         f=0
         for(i=1;i<10;i++)
            printf("%s",a[i]) >> w
         printf("%s\n",a[10]) >> w
         break
      case /<desc>/ :
         sub(/<desc>/,"")
         sub(/<\/desc>/,"")
         s=substr($0,1,40)
         a[8]=sprintf("%-41s",s)
         break
      case /<sym>/ :
         break
      case /<ele>/ :
         sub(/<ele>/,"")
         sub(/<\/ele>/,"")
         if($0>=0)
            a[7]=sprintf("%05.f ",$0)
         break
#-------------------------------------------------------------------------- both
      case /<name>/ :
         sub(/<name>/,"")
         sub(/<\/name>/,"")
         if(f==1)
         {
            #  1      2    3  4   5    6                    get trk date fr name
            # |ACTIVE|LOG:|16|SEP|2021|16:17|
            n=split($0,q)
            a[5]=q[3]"-"substr(q[4],1,1)tolower(substr(q[4],2))"-"substr(q[5],3)" "
            a[6]=q[6]":00 "
         printf("\nH  TN %s\n",$0) >> t
         printf("H  LATITUDE   LONGITUDE   DATE      TIME     ALT\n") >> t
         }
         else
         {
            s=substr($0,1,6)
            if(s==l)
            {
               s=substr($0,1,5)k
               k++
            }
            else
            {
               k=1
               l=s
            }
            a[2]=sprintf("%-7s",s)
         }
         printf("%s\n",$0)          # display
         system("sleep 0.01")
         break
      case /<time>/ :
         break
   }
}
#===============================================================================
END {
}
#===============================================================================
# functions
function fx_init()
{
   a[1]="W  "                                         #  1  3 H       load array
   a[2]="       "                                     #  2  7 IDENT
   a[3]="           "                                 #  3 11 LATITUDE
   a[4]="            "                                #  4 12 LONGITUDE
   a[5]="          "                                  #  5 10 DATE
   a[6]="         "                                   #  6  9 TIME
   a[7]="00000 "                                      #  7  6 ALT
   a[8]="                                         "   #  8 41 DESCRIPTION
   a[9]="0.00000e+00 "                                #  9 12 PROXIMITY
   a[10]="18"                                         # 10  2 SYMBOL - Waypoint

   "date +\"%d-%b-%y \"" | getline a[5]
   close("date +\"%d-%b-%y \"")

   "date +\"%H:%M:%S \"" | getline a[6]
   close("date +\"%H:%M:%S \"")
}
#-------------------------------------------------------------------------------
function fx_loc()
{
   sub(/>/,"",x)
   sub(/lat=/,"",x)
   sub(/lon=/,"",x)
   gsub(/"/,"",x)                                                        # "
   n=split(x,q)

   if(q[1]>=0)                # latitude
      c="N"
   else
   {
      c="S"
      q[1]=-q[1]
   }
   d=int(q[1])
   m=(q[1]-d)*60
   lt=sprintf("%s%02d%07.4f",c,d,m)
   a[3]=sprintf("%-11s",lt)

   if(q[2]>=0)                # longitude
      c="E"
   else
   {
      c="W"
      q[2]=-q[2]
   }
   d=int(q[2])
   m=(q[2]-d)*60
   lo=sprintf("%s%03d%07.4f",c,d,m)
   a[4]=sprintf("%-12s",lo)
}
#===============================================================================
