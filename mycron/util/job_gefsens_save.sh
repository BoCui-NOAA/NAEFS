CDATE=2022111600

ntimes=4
iday=1

job=sub_jnaefs_gefs_debias.ecf

while [ $iday -le $ntimes ]; do
  export PDY=`echo $CDATE | cut -c1-8`
  export cyc=`echo $CDATE | cut -c9-10`
  export YYMMDD=`echo $CDATE | cut -c1-8`
  export CYC=`echo $CDATE | cut -c9-10`
  echo " day " $PDY$cyc
  rm trash/out_save.$PDY
  sub_gefsens_save.sh > trash/out_save.$PDY 2>&1&
  iday=`expr $iday + 1`
  CDATE=`$NDATE +24 $CDATE`
done

