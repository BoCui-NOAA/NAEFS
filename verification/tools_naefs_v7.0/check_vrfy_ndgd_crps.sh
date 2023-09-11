CDATE=2023010700
ndays=48
iday=1

export COMROOT=/lfs/h2/emc/vpppg/noscrub/$LOGNAME/com


#CDATE=$SDATE

rm print_crps_conus
rm print_crps_alaska
>print_crps_conus 
>print_crps_alaska

while [ $iday -le $ndays ]; do

  for ireg in conus alaska; do

  export  PDY=`echo $CDATE | cut -c1-8`
  export cyc=`echo $CDATE | cut -c9-10`

  echo $CDATE >> print_crps_$ireg

  for naefs_ver in v6.1 v7.0; do
    for exp in gefs naefs; do
      COM_IN=$COMROOT/stat/naefs.$naefs_ver
      COMIN=$COM_IN/crps_${exp}_ndgd   
      file=P2MTMP.${exp}a.$CDATE.$ireg 
#     file=P10MUGRD${exp}f.$CDATE.$ireg 
#     cat $COMIN/$file       | sed -n "31,31p" >> print_crps_$ireg
      cat $COMIN/$file       | sed -n "507,507p" >> print_crps_$ireg
    done
  done

  echo "    " >> print_crps_$ireg
  done

  iday=`expr $iday + 1`
  export CDATE=`$NDATE +24 $CDATE`

done

