
CDATE=2019113000
#CDATE=$1             
ndays=31 

COMOUT=/gpfs/hps3/emc/ensemble/noscrub/emc.enspara1/bc/o/com/naefs/dev                    
HPSSOUT=/NCEPDEV/emc-ensemble/2year/emc.enspara/fv3gefs/RETRO

grid='0 6 0 0 0 0 0 0 720 361 0 0 90000000 0 48 -90000000 359500000 500000 500000 0'

#hourlist=" 00  06  12  18  24  30  36  42  48  54  60  66  72  78  84  90  96 \
#          102 108 114 120 126 132 138 144 150 156 162 168 174 180 186 192 198 \
#          204 210 216 222 228 234 240 246 252 258 264 270 276 282 288 294 300 \
#          306 312 318 324 330 336 342 348 354 360 366 372 378 384"

export hourlist="    003 006 009 012 015 018 021 024 027 030 033 036 039 042 045 048 \
                 051 054 057 060 063 066 069 072 075 078 081 084 087 090 093 096 099 \
                 102 105 108 111 114 117 120 123 126 129 132 135 138 141 144 147 150 \
                 153 156 159 162 165 168 171 174 177 180 183 186 189 192 198 204 \
                 210 216 222 228 234 240 246 252 258 264 270 276 282 288 294 300 \
                 306 312 318 324 330 336 342 348 354 360 366 372 378 384"

hourlist_gfs=" 00  06  12  18  24  30  36  42  48  54  60  66  72  78  84  90  96 \
          102 108 114 120 126 132 138 144 150 156 162 168 174 180"

#hourlist="000"

iday=1
while [ $iday -le $ndays ]; do

  export YER=`echo $CDATE | cut -c1-4`
  export MON=`echo $CDATE | cut -c1-6`
  export PDY=`echo $CDATE | cut -c1-8`
  export cyc=`echo $CDATE | cut -c9-10`

  mkdir -p ${COMOUT}/gefs.${PDY}/${cyc}/pgrb2ap5
  mkdir -p ${COMOUT}/gefs.${PDY}/${cyc}/pgrb2ap25
 
  cd ${COMOUT}/gefs.${PDY}/${cyc}

  file=$HPSSOUT/${YER}/${MON}/${PDY}/gefs.${PDY}_${cyc}.pgrb2ap25.tar                  

  echo $file
  /u/emc.enspara1/bin/hpsstar.Bo.Cui dir $file 
exit
  hpsstar inx $file 
# /u/emc.enspara1/bin/hpsstar.Bo.Cui inx $file 

  for ifh in $hourlist; do
    /u/emc.enspara1/bin/hpsstar.Bo.Cui get $file pgrb2ap25/geavg.t${cyc}z.pgrb2a.0p25.f$ifh
    infile=pgrb2ap25/geavg.t${cyc}z.pgrb2a.0p25.f$ifh
    outfile=pgrb2ap5/geavg.t${cyc}z.pgrb2a.0p50.f$ifh
    $COPYGB2 -g "$grid" -i1,1 -x $infile $outfile
  done
  for ifh in 000 003 006 009 012; do
    /u/emc.enspara1/bin/hpsstar.Bo.Cui get $file pgrb2ap25/gec00.t${cyc}z.pgrb2a.0p25.f$ifh
    infile=pgrb2ap25/gec00.t${cyc}z.pgrb2a.0p25.f$ifh
    outfile=pgrb2ap5/gec00.t${cyc}z.pgrb2a.0p50.f$ifh
    $COPYGB2 -g "$grid" -i1,1 -x $infile $outfile
  done

  iday=`expr $iday + 1`
  CDATE=`$NDATE +24 $CDATE` 

done

