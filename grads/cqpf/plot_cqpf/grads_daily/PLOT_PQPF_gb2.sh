#set -x

#export SHOME=/lfs/h2/emc/vpppg/save/$LOGNAME/cqpf
#export COMIN=/lfs/h2/emc/vpppg/noscrub/$LOGNAME/daily_hrap_ccpav4
#export COMIN=$SHOME/data/daily_hrap_ccpav4
export scripts=$SHOME/plot_cqpf/grads_daily
export nhours=/apps/ops/prod/nco/core/prod_util.v2.0.5/exec/ndate

export tmpdir=$DATAROOT/pqpf_tmp_${naefs_ver}

if [ -s $tmpdir ]; then
  rm -rf  $tmpdir/obs
  rm $tmpdir/*
  cd $tmpdir
else
  mkdir -p $tmpdir
cd $tmpdir 
fi

mkdir -p $tmpdir/obs            
cp $SHOME/grads/rgbset.gs .
cp $SHOME/grads/cbar.gs   .
cp $SHOME/grads/cbarn.gs   .

CDATE=$1

$scripts/get_pqpf_0.5d_gb2.sh  $CDATE
$scripts/get_pqpf_ndgd_gb2.sh  $CDATE

YY=`echo $CDATE | cut -c1-4`
MM=`echo $CDATE | cut -c5-6`
DD=`echo $CDATE | cut -c7-8`
HH=`echo $CDATE | cut -c9-10`
CMM=`grep "$MM" $SHOME/bin/mon2mon | cut -c8-10`

#hourlist_24="    36 60 84 108 132 156 180 204 228 252 276 300 324 348 372 "

cd  $tmpdir/obs
for nfhrs in $hourlist_24; do
   fymdh=`$nhours +$nfhrs $CDATE`
   fymd=`echo $fymdh | cut -c1-8`
   fcyc=`echo $fymdh | cut -c9-10`
    nshrs=`expr $nfhrs - 24`
    grptime=$nshrs"_"$nfhrs
    file=ccpa_conus_hrap_${fymd}
    infile=$COMINobs/$file
    outfile=$tmpdir/obs/obs_${CDATE}_${grptime}
    cp $infile $outfile
    $SHOME/xbin/grib2ctl -verf obs_${CDATE}_${grptime}   > obs_$nfhrs.ctl
    $SHOME/xbin/gribmap -i  obs_$nfhrs.ctl
done
cd  $tmpdir
HHDDMMYY=00Z$DD$CMM$YY

for AMOUNT in 1.00 6.35 12.7 25.4 50.8
do

FILENAME=pqpf_$AMOUNT\_opr
$SHOME/xbin/grib2ctl -verf pqpf_$AMOUNT\_opr  > opr_$AMOUNT\_ctl
$SHOME/xbin/gribmap -i opr_$AMOUNT\_ctl

FILENAME=pqpf_$AMOUNT\_cal
$SHOME/xbin/grib2ctl -verf pqpf_$AMOUNT\_cal > cal_$AMOUNT\_ctl
$SHOME/xbin/gribmap -i cal_$AMOUNT\_ctl

FILENAME=pqpf_$AMOUNT\_dsc
$SHOME/xbin/grib2ctl -verf pqpf_$AMOUNT\_dsc > 4.ctl
sed -e "s/xdef 2145 linear -121.554 0.0245932917324725/xdef 2814 linear -130.100275 0.0245932917324725/"  \
    -e "s/ydef 1377 linear 20.192000 0.0230818181818182/ydef 1413 linear 20.196426 0.0230818181818182/" \
    4.ctl  > dsc_$AMOUNT\_ctl
$SHOME/xbin/gribmap -i dsc_$AMOUNT\_ctl

fname1=opr_$AMOUNT\_ctl
fname2=cal_$AMOUNT\_ctl
fname3=dsc_$AMOUNT\_ctl

case $AMOUNT in
0.254) amt1=0.254;amt2=0.01;;
1.00) amt1=1.0;amt2=0.04;;
2.54) amt1=2.54;amt2=0.1;;
6.35) amt1=6.35;amt2=0.25;;
12.7) amt1=12.7;amt2=0.50;;
25.4) amt1=25.4;amt2=1.00;;
50.8) amt1=50.8;amt2=2.00;;
esac

done

for nfhrs in  $hourlist_24; do

   fymdh=`$nhours +$nfhrs $CDATE`
   fymd=`echo $fymdh | cut -c1-8`
   fcyc=`echo $fymdh | cut -c9-10`
    nshrs=`expr $nfhrs - 24`
    nvhrs=`expr $nfhrs - 12`
    grptime=$nshrs"_"$nfhrs
    symdh=`$nhours +$nshrs $CDATE`
    ttime=`expr $nvhrs / 24`
for AMOUNT in 1.00 6.35 12.7 25.4 50.8
do
fname1=opr_$AMOUNT\_ctl
fname2=cal_$AMOUNT\_ctl
fname3=dsc_$AMOUNT\_ctl

sed -e "s/IDATE/$CDATE/"  \
    -e "s/TIME1/$nshrs/" \
    -e "s/TIME2/$nfhrs/" \
    -e "s/VDATE1/$symdh/" \
    -e "s/VDATE2/$fymdh/" \
    -e "s/TTIME/$ttime/" \
    -e "s/FILENAME1/$fname1/" \
    -e "s/FILENAME2/$fname2/" \
    -e "s/FILENAME3/$fname3/" \
    -e "s/AMT1/$AMOUNT/"        \
    $scripts/pqpf_gb2.GS  >pgrads_pqpf.gs

#grads -d Cairo -h GD -cbl "run pgrads_pqpf.gs"
grads -cbl "run pgrads_pqpf.gs"

done
done
   
dir_new=cpqpf_24h_${naefs_ver}
ssh -l bocui emcrzdm "mkdir ${dir_main}/${dir_new}"
export RZDMDIR=${dir_main}/${dir_new}

$SHOME/xbin/ftpemcrzdmmkdir emcrzdm $RZDMDIR $YY$MM$DD

scp *.png   bocui@emcrzdm:$RZDMDIR/$YY$MM$DD
ssh -l bocui emcrzdm "cp $RZDMDIR/al* $RZDMDIR/$YY$MM$DD"    
ssh -l bocui emcrzdm "cp $RZDMDIR/in* $RZDMDIR/$YY$MM$DD"

###
### to generate html scripts
###

for amap in ctl a1.00 a6.35 a12.7 a25.4 a50.8
do

sed -e "s/YYYYMMDDHH/$YY$MM$DD$HH/"  \
    -e "s/YYYYMMDD/$YY$MM$DD/"       \
    -e "s/AMAP/$amap/"                  \
    $scripts/naefs.${naefs_ver}_today.HTML >$amap.t00z.html

$SHOME/xbin/ftpemcrzdm emcrzdm put $RZDMDIR/$YY$MM$DD $tmpdir $amap.t00z.html

done

sed -e "s/YYYYMMDD/$YY$MM$DD/"    \
cat    $scripts/naefs.${naefs_ver}_CPQPF_24h_H.HTML   >CPQPF_24h.html

for hhour in 24 48 72 96 120 144 168 192 216 240 264 288 312 336 360 \
             384 408 432 456 480 504 528 552 576 600 624 648 672 696 720
do
 SYMD=`$nhours -$hhour $CDATE | cut -c1-8`
 SYMDH=`$nhours -$hhour $CDATE`

 sed -e "s/YYYYMMDDHH/$SYMDH/"  \
     -e "s/YYYYMMDD/$SYMD/"     \
     $scripts/naefs.${naefs_ver}_CPQPF_24h_M.HTML   >>CPQPF_24h.html
done

cat $scripts/CPQPF_24h_E.HTML   >>CPQPF_24h.html
cp CPQPF_24h.html naefs.${naefs_ver}_CPQPF_24h.html

#RZDMDIR=/home/people/emc/www/htdocs/gmb/wx20cb/GEFS_VRFY
RZDMDIR=${dir_main}/GEFS_VRFY 
$SHOME/xbin/ftpemcrzdm emcrzdm put $RZDMDIR $tmpdir naefs.${naefs_ver}_CPQPF_24h.html
                             
