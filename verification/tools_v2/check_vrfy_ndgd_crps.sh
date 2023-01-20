DATE=2016041100
ndays=36
iday=1

nhours=/nwprod/util/exec/ndate

COM_PARA=$NGLOBAL2/Bo.Cui/naefs.v5.0.0/com/gens/crps_ndgd3p0

rm print_crps
>print_crps

CDATE=$SDATE
iday=1

while [ $iday -le $ndays ]; do

  export PDY=`echo $CDATE | cut -c1-8`
  export cyc=`echo $CDATE | cut -c9-10`

  echo $CDATE >> print_crps

#   file=P2MTMP${exp}.$CDATE.conus

# for exp in prod_gefs_3p0a prod_naefs_3p0a test_gefs_3p0a test_naefs_3p0a; do
  for exp in prod_gefs_3p0f prod_naefs_3p0f test_gefs_3p0f test_naefs_3p0f; do
# for exp in prod_gefsa prod_naefsa test_gefsa test_naefsa; do
# for exp in prod_gefsa prod2_gefsa test_gefsa test2_gefsa; do
# for exp in prod_gefsa prod_gefs_3p0a test_gefsa test_gefs_3p0a; do
#   file=P2MTMP${exp}.$CDATE.alaska
    file=PTMIN${exp}.$CDATE.alaska
    cat $COM_PARA/$file  | sed -n "19,19p" >> print_crps
#   cat $COM_PARA/$file  | sed -n "259,259p" >> print_crps
  done

  echo "    " >> print_crps

  iday=`expr $iday + 1`
  export CDATE=`$nhours +24 $CDATE`

done

