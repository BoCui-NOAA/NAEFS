SDATE=2011010100
ndays=20
iday=1

COM=$NGLOBAL/wx20cb/BMA

memberlist="avg"
hourlist="24"
hourlist="24 48 72 96 120 144 168 192 216 240 264 288 312 336 360 384"

for mem in $memberlist; do
for nhr in $hourlist; do

  iday=1

  >print_ens${mem}_${nhr}hr    

  CDATE=$SDATE          
  iday=1

  while [ $iday -le $ndays ]; do

    PDY=`echo $CDATE | cut -c1-8`
    cyc=`echo $CDATE | cut -c9-10`

    echo $CDATE >> print_ens${mem}_${nhr}hr

    gbscan.sh $COM/gefs.$PDY/$cyc/pgrba_wNO/ens${mem}.t${cyc}z.pgrbaf${nhr}  | sed -n "3,3p" >> print_ens${mem}_${nhr}hr
    gbscan.sh $COM/gefs.$PDY/$cyc/pgrba_wYES/ens${mem}.t${cyc}z.pgrbaf${nhr} | sed -n "3,3p" >> print_ens${mem}_${nhr}hr

    gbscan.sh $COM/gefs.$PDY/$cyc/pgrba_bc_wNO/ens${mem}.t${cyc}z.pgrba_bcf${nhr}  | sed -n "3,3p" >> print_ens${mem}_${nhr}hr
    gbscan.sh $COM/gefs.$PDY/$cyc/pgrba_bc_wYES/ens${mem}.t${cyc}z.pgrba_bcf${nhr} | sed -n "3,3p" >> print_ens${mem}_${nhr}hr

    echo "    " >> print_ens${mem}_${nhr}hr

    iday=`expr $iday + 1`
    export CDATE=`$nhours +24 $CDATE`

  done

done
done
