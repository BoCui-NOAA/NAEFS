#!/bin/bash

set -x

hpsstar=/u/$LOGNAME/xbin/hpsstar

Date=`date +%y%m%d%H`
CDATE=20$Date
CDATE=`$NDATE -48 $CDATE`

CDATE=2022112900

PDY=`echo $CDATE | cut -c1-8`

HPSSOUT=/NCEPDEV/emc-ensemble/5year/Bo.Cui/naefs.v7.0/v6.1

output=/lfs/h2/emc/vpppg/noscrub/$LOGNAME/naefs.v7.0.0/mycron/output

YER=`echo $CDATE | cut -c1-4`
MON=`echo $CDATE | cut -c1-6`
PDY=`echo $CDATE | cut -c1-8`
#cyc=`echo $CDATE | cut -c9-10`
cyc=00

#$hpsstar mkd $HPSSOUT
#$hpsstar mkd $HPSSOUT/rh${YER}
#$hpsstar mkd $HPSSOUT/rh${YER}/${MON}
#$hpsstar mkd $HPSSOUT/rh${YER}/${MON}/${PDY}

###

COM=/lfs/h2/emc/ptmp/$LOGNAME/com/naefs/v6.1                        

COMIN=$COM/naefs.$PDY/$cyc
mkdir -p $COMIN
cd $COMIN

file=$HPSSOUT/rh${YER}/${MON}/${PDY}/avgspr_naefs.${PDY}_${cyc}.pgrb2ap5_bc.tar
$hpsstar get $file > $output/get_hpss_naefs_v6.1_pgrb2ap5_bc 2>&1&

file=$HPSSOUT/rh${YER}/${MON}/${PDY}/avgspr_naefs.${PDY}_${cyc}.ndgd_gb2.tar
$hpsstar get $file > $output/get_hpss_naefs_v6.1_ndgd_gb2 2>&1& 

###

cyc=00
COMIN=$COM/gefs.$PDY/$cyc
cd $COMIN

file=$HPSSOUT/rh${YER}/${MON}/${PDY}/avgspr_gefs.${PDY}_${cyc}.pgrb2ap5_bc.tar
$hpsstar get $file > $output/get_hpss_gefs_v6.1_pgrb2ap5_bc 2>&1&

file=$HPSSOUT/rh${YER}/${MON}/${PDY}/avgspr_gefs.${PDY}_${cyc}.ndgd_gb2.tar
$hpsstar get $file > $output/get_hpss_gefs_v6.1_ndgd_gb2  2>&1&         


