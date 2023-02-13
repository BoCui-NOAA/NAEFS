CDATE=2022120100
ndays=35
iday=1

#COMIN=/gpfs/hps3/emc/ensemble/noscrub/Bo.Cui/naefs.v6.0.0/com/gens/crps_gefs

#export naefs_ver=v6.1
#export ENSIM=gefs_bcp5

export COMROOT=/lfs/h2/emc/vpppg/noscrub/$LOGNAME/com
#export COM_IN=$COMROOT/stat/naefs.$naefs_ver
#export COMIN=$COM_IN/crps_$ENSIM

#NDATE=/nwprod2/util/exec/ndate

rm print_crps
>print_crps

while [ $iday -le $ndays ]; do

  export PDY=`echo $CDATE | cut -c1-8`
  export cyc=`echo $CDATE | cut -c9-10`

  echo $CDATE >> print_crps

  for naefs_ver in v6.1 v7.0; do
    for ENSIM in gefs_bcp5 naefs_bcp5; do

    COM_IN=$COMROOT/stat/naefs.$naefs_ver
    COMIN=$COM_IN/crps_$ENSIM

    exp=${ENSIM}a
    file=P2MTMP.${exp}.${CDATE}
#   file=P10MVGRD${exp}.${CDATE}
#   cat $COMIN/$file  | sed -n "31,31p" >> print_crps
#   cat $COMIN/$file  | sed -n "507,507p" >> print_crps
#   cat $COMIN/$file  | sed -n "3,3p" >> print_crps
#   cat $COMIN/$file  | sed -n "11,11p" >> print_crps
#   cat $COMIN/$file  | sed -n "229,229p" >> print_crps
#   cat $COMIN/$file  | sed -n "3839,3839p" >> print_crps
    cat $COMIN/$file  | sed -n "3814,3814p" >> print_crps
    done
  done

  echo "    " >> print_crps

  iday=`expr $iday + 1`
  export CDATE=`$NDATE +24 $CDATE`

done
