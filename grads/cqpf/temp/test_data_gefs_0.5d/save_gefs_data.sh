#!/bin/bash -l

set -x

module load prod_util

Date=`date +%y%m%d%H`
CDATE=20$Date
export PDY=`echo $CDATE | cut -c1-8`
export cyc=00

mkdir -p /lfs/h2/emc/vpppg/noscrub/$LOGNAME/com/naefs/prod/gefs.${PDY}/${cyc}
 cp -pr  /lfs/h1/ops/prod/com/naefs/v6.1/gefs.${PDY}/${cyc}/prcp_bc_gb2 /lfs/h2/emc/vpppg/noscrub/$LOGNAME/com/naefs/prod/gefs.${PDY}/${cyc}

export PDY=`echo $CDATE | cut -c1-8`
export cyc=00

#cd /u/$LOGNAME/save/naefs.v6.0.1/ecf
cd $SHOME/$LOGNAME/naefs.v6.0.1/ecf
run_4cyc.sh $CDATE  $CDATE $cyc

CDATE=`$NDATE -24 $CDATE`

export PDY=`echo $CDATE | cut -c1-8`
export cyc=12

#cd /u/$LOGNAME/save/naefs.v6.0.1/ecf
cd $SHOME/$LOGNAME/naefs.v6.0.1/ecf
run_4cyc.sh $CDATE  $CDATE $cyc

exit
