CDATE=2016080100
ndays=31
iday=1

COM_PARA=$NGLOBAL/Bo.Cui/naefs.v6.0.1/com/gens/crps_ndgd2p5_conus

rm print_crps
>print_crps

while [ $iday -le $ndays ]; do

  export PDY=`echo $CDATE | cut -c1-8`
  export cyc=`echo $CDATE | cut -c9-10`

  echo $CDATE >> print_crps

# for exp in gefs_raw2p5f gefs_bc2p5f gefs_p5raw2p5f; do
  for exp in gefs_p5raw2p5f gefs_p5bc_ctlf gefs_p5bc_meanf; do
    file=P2MTMP${exp}.${CDATE}.conus  
#   cat $COM_PARA/$file  | sed -n "31,31p" >> print_crps
#   cat $COM_PARA/$file  | sed -n "507,507p" >> print_crps
#   cat $COM_PARA/$file  | sed -n "3,3p" >> print_crps
#   cat $COM_PARA/$file  | sed -n "11,11p" >> print_crps
    cat $COM_PARA/$file  | sed -n "35,35p" >> print_crps
  done

  echo "    " >> print_crps

  iday=`expr $iday + 1`
  export CDATE=`$NDATE +24 $CDATE`

done

