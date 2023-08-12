#set -x

############################################################
#HISTORY:
#09/01/2011: Initial script created by $LOGNAME
############################################################
#----------------------------------------------------------

#SHOME=/u/$LOGNAME/save
#SHOME=/lfs/h2/emc/vpppg/save/$LOGNAME/cqpf
#COMIN=/lfs/h2/emc/vpppg/noscrub/$LOGNAME/COM_TAR/0.5d
#COMOUT=/lfs/h2/emc/vpppg/noscrub/$LOGNAME/daily_0.5d_ccpav4
#exec_dir=/lfs/h1/ops/para/packages/ccpa.v4.2.0/exec

COMIN=${COM_TAR}/0.5d
COMOUT=$SHOME/data/daily_0.5d_ccpav4
tempdir=${DATAROOT}/daily_ccpa_0.5d

mkdir -p $COMOUT

CDATE=$1

if [ -s $tempdir ]; then
cd $tempdir; rm * 
else
mkdir -p $tempdir
cd $tempdir
fi

YY=`echo $CDATE | cut -c1-4`
MM=`echo $CDATE | cut -c5-6`
DD=`echo $CDATE | cut -c7-8`
HH=`echo $CDATE | cut -c9-10`
CMM=`grep "$MM" $SHOME/bin/mon2mon | cut -c8-10`
curdate=`echo $CDATE | cut -c1-8`
datnext=`$NDATE +24 $CDATE | cut -c1-8`

cd $tempdir

cp -pr $COMIN/ccpa.$curdate/18/ccpa.t18z.06h.0p5.conus  $tempdir/rfc_06h_1.grb
cp -pr $COMIN/ccpa.$datnext/00/ccpa.t00z.06h.0p5.conus  $tempdir/rfc_06h_2.grb
cp -pr $COMIN/ccpa.$datnext/06/ccpa.t06z.06h.0p5.conus  $tempdir/rfc_06h_3.grb
cp -pr $COMIN/ccpa.$datnext/12/ccpa.t12z.06h.0p5.conus  $tempdir/rfc_06h_4.grb

$exec_dir/ccpa_accum_6h_files  $YY $MM $DD 12         

mv $tempdir/rfc_24h.grb $COMOUT/ccpa_conus_0.5d_${datnext}
