#COM=/gpfs/hps/nco/ops/com/nawips/prod
COM=/gpfs/hps3/ptmp/Bo.Cui/com/nawips/dev 

############################################

CDATE=2020051100
#CDATE=$1
ndays=1
iday=1

while [ $iday -le $ndays ]; do

  PDY=`echo $CDATE | cut -c1-8`
  cyc=`echo $CDATE | cut -c9-10`

  echo " day " $PDY$cyc

  COMIN=$COM/gefs.$PDY

  echo " dir GEFS ge file 348 (1392 in total)"
  ls $COMIN/ge* | wc
  echo

  echo " dir GEFS dir an 2290 (9160 intotal)"
  ls $COMIN/an  | wc
  echo

  echo " dir GEFS dir bc 2674 (10696 in total )"
  ls $COMIN/bc  | wc
  echo

  COMIN=$COM/naefs.$PDY

  echo " dir NAEFS ge files 864( 3456 in total)"
  ls $COMIN/ge*  | wc
  echo

  echo " dir NAEFS ndgd files 1152 (4608 in total )"
  ls $COMIN/ndgd*  | wc
  echo

  echo " dir NAEFS dvrtma files 8"
  ls $COMIN/dvrtma*      | wc
  echo

  iday=`expr $iday + 1`
  CDATE=`$NDATE +06 $CDATE`

done


