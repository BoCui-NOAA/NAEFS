#!/bin/bash -l

set -x

hpsstar=/u/$LOGNAME/xbin/hpsstar

Date=`date +%y%m%d%H`
CDATE=20$Date
CDATE=`$NDATE -48 $CDATE`

PDY=`echo $CDATE | cut -c1-8`

HPSSOUT=/NCEPDEV/emc-ensemble/5year/Bo.Cui/naefs.v7.0/v7.0

output=/lfs/h2/emc/vpppg/noscrub/$LOGNAME/naefs.v7.0.0/mycron/output

YER=`echo $CDATE | cut -c1-4`
MON=`echo $CDATE | cut -c1-6`
PDY=`echo $CDATE | cut -c1-8`
cyc=`echo $CDATE | cut -c9-10`

cd /lfs/h2/emc/vpppg/noscrub/bo.cui/naefs.v7.0.0/mycron/ecf

file=$HPSSOUT/rh${YER}/${MON}/${PDY}/test.tar                                                                                        
$hpsstar put $file *
exit

#$hpsstar mkd $HPSSOUT
$hpsstar mkd $HPSSOUT/rh${YER}
$hpsstar mkd $HPSSOUT/rh${YER}/${MON}
$hpsstar mkd $HPSSOUT/rh${YER}/${MON}/${PDY}

###

COM=/lfs/h2/emc/ptmp/$LOGNAME/com/naefs/v7.0

if [ $cyc -eq 00 -o $cyc -eq 12 ]; then
  COMIN=$COM/naefs.$PDY/$cyc
  cd $COMIN
  file=$HPSSOUT/rh${YER}/${MON}/${PDY}/com_naefs_dev_naefs.${PDY}_${cyc}.pgrb2ap5_bc.tar
  $hpsstar put $file pgrb2ap5_bc > $output/output_hpss_naefs_pgrb2ap5_bc
  file=$HPSSOUT/rh${YER}/${MON}/${PDY}/com_naefs_dev_naefs.${PDY}_${cyc}.ndgd_gb2.tar
  $hpsstar put $file ndgd_gb2     > $output/output_hpss_naefs_ndgd_gb2          

  file=$HPSSOUT/rh${YER}/${MON}/${PDY}/avgspr_naefs.${PDY}_${cyc}.pgrb2ap5_bc.tar
  $hpsstar put $file pgrb2ap5_bc/*avg* pgrb2ap5_bc/*spr* > $output/output_hpss_naefs_pgrb2ap5_bc_avgspr
  file=$HPSSOUT/rh${YER}/${MON}/${PDY}/avgspr_naefs.${PDY}_${cyc}.ndgd_gb2.tar
  $hpsstar put $file ndgd_gb2/*avg* ndgd_gb2/*spr*     > $output/output_hpss_naefs_ndgd_gb2_avgspr          
fi

###

cyc=00
COMIN=$COM/gefs.$PDY/$cyc
cd $COMIN
file=$HPSSOUT/rh${YER}/${MON}/${PDY}/com_naefs_dev_gefs.${PDY}_${cyc}.pgrb2ap5_bc.tar
$hpsstar put $file pgrb2ap5_bc > $output/output_hpss_pgrb2ap5_bc
file=$HPSSOUT/rh${YER}/${MON}/${PDY}/com_naefs_dev_gefs.${PDY}_${cyc}.pgrb2ap5_an.tar
$hpsstar put $file pgrb2ap5_an > $output/output_hpss_pgrb2ap5_an
file=$HPSSOUT/rh${YER}/${MON}/${PDY}/com_naefs_dev_gefs.${PDY}_${cyc}.ndgd_gb2.tar
$hpsstar put $file ndgd_gb2     > $output/output_hpss_ndgd_gb2          

file=$HPSSOUT/rh${YER}/${MON}/${PDY}/avgspr_gefs.${PDY}_${cyc}.pgrb2ap5_bc.tar
$hpsstar put $file pgrb2ap5_bc/*avg* pgrb2ap5_bc/*spr* > $output/output_hpss_gefs_pgrb2ap5_bc_avgspr
file=$HPSSOUT/rh${YER}/${MON}/${PDY}/avgspr_gefs.${PDY}_${cyc}.ndgd_gb2.tar
$hpsstar put $file ndgd_gb2/*avg* ndgd_gb2/*spr*     > $output/output_hpss_gefs_ndgd_gb2_avgspr          

###

#COMIN=$COM/cmce.$PDY/$cyc
#cd $COMIN
#file=$HPSSOUT/rh${YER}/${MON}/${PDY}/com_naefs_dev_cmce.${PDY}_${cyc}.pgrb2ap5_bc.tar
#$hpsstar put $file pgrb2ap5_bc > $output/output_hpss_pgrb2ap5_bc_cmce
#file=$HPSSOUT/rh${YER}/${MON}/${PDY}/com_naefs_dev_cmce.${PDY}_${cyc}.pgrb2ap5.tar
#$hpsstar put $file pgrb2ap5    > $output/output_hpss_pgrb2ap5_cmce

###

#PDYm03=`$NDATE -3 $PDY$cyc | cut -c1-8`
#cycm03=`$NDATE -3 $PDY$cyc | cut -c9-10`
#COMIN=/gpfs/hps3/ptmp/emc.enspara1/bc/o/com/naefs/dev/gefs.$PDYm03/$cycm03
#cd $COMIN
#file=$HPSSOUT/rh${YER}/${MON}/${PDYm03}/com_naefs_dev_gefs.${PDYm03}_${cycm03}.ndgd_gb2.tar
#$hpsstar put $file ndgd_gb2     > $output/output_hpss_ndgd_gb2          

###

#COMIN=$COM/gefs.$PDY/$cyc
#cd $COMIN
#if [ $cyc -eq 00 -o $cyc -eq 06 -o $cyc -eq 12 -o $cyc -eq 18 ]; then
#  file=$HPSSOUT/rh${YER}/${MON}/${PDY}/com_naefs_dev_gefs.${PDY}_${cyc}.pgrb2ap5_me.tar
#  $hpsstar put $file pgrb2ap5 > $output/output_hpss_pgrb2ap5_me
##fi
