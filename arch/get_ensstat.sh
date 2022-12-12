#CDATE=$1      
#ndays=$2      

CDATE=2019033000
ndays=3  

COMOUT=/gpfs/dell3/nco/storage/fv3gefs/HOME/Bo.Cui/GEFS_V11.3.0/com/gens/prod

#HPSSOUT=/NCEPPROD/hpssprod/runhistory
HPSSOUT=/NCEPPROD/1year/hpssprod/runhistory

hourlist=" 00  06  12  18  24  30  36  42  48  54  60  66  72  78  84  90  96 \
          102 108 114 120 126 132 138 144 150 156 162 168 174 180 186 192 198 \
          204 210 216 222 228 234 240 246 252 258 264 270 276 282 288 294 300 \
          306 312 318 324 330 336 342 348 354 360 366 372 378 384"

hourlist_gfs=" 00  06  12  18  24  30  36  42  48  54  60  66  72  78  84  90  96 \
          102 108 114 120 126 132 138 144 150 156 162 168 174 180"

iday=1
while [ $iday -le $ndays ]; do

  export YER=`echo $CDATE | cut -c1-4`
  export MON=`echo $CDATE | cut -c1-6`
  export PDY=`echo $CDATE | cut -c1-8`
  export cyc=`echo $CDATE | cut -c9-10`

  mkdir -p ${COMOUT}/gefs.${PDY}/${cyc}
 
  cd ${COMOUT}/gefs.${PDY}/${cyc}

# file=$HPSSOUT/rh${YER}/${MON}/${PDY}/com2_gens_prod_gefs.${PDY}_${cyc}.pgrb2ap5.tar
  file=$HPSSOUT/rh${YER}/${MON}/${PDY}/com2_gens_prod_gefs.${PDY}_${cyc}.ensstat.tar  

# hpsstar dir $file 
  hpsstar get $file 

  iday=`expr $iday + 1`
  CDATE=`$NDATE +24 $CDATE` 

done

