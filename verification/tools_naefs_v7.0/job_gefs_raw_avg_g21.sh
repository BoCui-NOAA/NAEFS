#CDATE=$1      
#ndays=$2      

CDATE=2017071200
ndays=2

COMOUT=/gpfs/hps/emc/ensemble/noscrub/emc.enspara1/bc/o/com/naefs/dev

export hourlist="    003 006 009 012 015 018 021 024 027 030 033 036 039 042 045 048 \
                 051 054 057 060 063 066 069 072 075 078 081 084 087 090 093 096 099 \
                 102 105 108 111 114 117 120 123 126 129 132 135 138 141 144 147 150 \
                 153 156 159 162 165 168 171 174 177 180 183 186 189 192 198 204 \
                 210 216 222 228 234 240 246 252 258 264 270 276 282 288 294 300 \
                 306 312 318 324 330 336 342 348 354 360 366 372 378 384"

#hourlist=" 006"

iday=1
while [ $iday -le $ndays ]; do

  export YER=`echo $CDATE | cut -c1-4`
  export MON=`echo $CDATE | cut -c1-6`
  export PDY=`echo $CDATE | cut -c1-8`
  export cyc=`echo $CDATE | cut -c9-10`

  mkdir -p ${COMOUT}/gefs.${PDY}/${cyc}/pgrbap5

  for ifh in $hourlist; do

    ifile=${COMOUT}/gefs.${PDY}/${cyc}/pgrb2ap5/geavg.t${cyc}z.pgrb2a.0p50.f$ifh
    ofile=${COMOUT}/gefs.${PDY}/${cyc}/pgrbap5/geavg.t${cyc}z.pgrba.0p50.f$ifh
    $CNVGRIB -g21  $ifile $ofile

    ifile=${COMOUT}/gefs.${PDY}/${cyc}/pgrb2ap5/gespr.t${cyc}z.pgrb2a.0p50.f$ifh
    ofile=${COMOUT}/gefs.${PDY}/${cyc}/pgrbap5/gespr.t${cyc}z.pgrba.0p50.f$ifh
    $CNVGRIB -g21  $ifile $ofile

  done

  iday=`expr $iday + 1`
  CDATE=`$NDATE +24 $CDATE` 

done

