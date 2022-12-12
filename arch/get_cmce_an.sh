#CDATE=$1      
#ndays=$2      

CDATE=2019042200
#CDATE=$1             
ndays=1  

COMOUT=/gpfs/dell3/nco/storage/fv3gefs/HOME/Bo.Cui/GEFS_V11.3.0/com/gens/prod

HPSSOUT=/NCEPPROD/1year/hpssprod/runhistory/

hourlist=" 00  06  12  18  24  30  36  42  48  54  60  66  72  78  84  90  96 \
          102 108 114 120 126 132 138 144 150 156 162 168 174 180 186 192 198 \
          204 210 216 222 228 234 240 246 252 258 264 270 276 282 288 294 300 \
          306 312 318 324 330 336 342 348 354 360 366 372 378 384"

hourlist_gfs=" 00  06  12  18  24  30  36  42  48  54  60  66  72  78  84  90  96 \
          102 108 114 120 126 132 138 144 150 156 162 168 174 180"

hourlist=" 048 120 240 384"

iday=1
while [ $iday -le $ndays ]; do

  export YER=`echo $CDATE | cut -c1-4`
  export MON=`echo $CDATE | cut -c1-6`
  export PDY=`echo $CDATE | cut -c1-8`
  export cyc=`echo $CDATE | cut -c9-10`

  mkdir -p ${COMOUT}/cmce.${PDY}/${cyc}/pgrb2ap5
 
  cd ${COMOUT}/cmce.${PDY}/${cyc}

  file=$HPSSOUT/rh${YER}/${MON}/${PDY}/gpfs_hps_nco_ops_com_naefs_prod_cmce.${PDY}_${cyc}.pgrb2ap5_an.tar

# hpsstar inx $file 
# hpsstar get $file 

  for ifh in $hourlist; do
    hpsstar get $file ./pgrb2ap5_an/cmc_geavg.t${cyc}z.pgrb2a.0p50_anf$ifh
    hpsstar get $file ./pgrb2ap5_an/cmc_geavg.t${cyc}z.pgrb2a.0p50_anvf$ifh
  done

  iday=`expr $iday + 1`
  CDATE=`$NDATE +24 $CDATE` 

done

