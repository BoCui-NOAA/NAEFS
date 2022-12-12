#!/bin/bash -l
set -x

module load prod_util

Date=`date +%y%m%d%H`
CDATE=20$Date
CDATE=`$NDATE -26 $CDATE`

CDATE=$1

PDY=`echo $CDATE | cut -c1-8`
cyc=`echo $CDATE | cut -c9-10`

eval dev=` cat /etc/dev `
eval prod=` cat /etc/prod `

echo "dev is" $dev "and prod is" $prod

COM_IN=/gpfs/hps/emc/ensemble/noscrub/emc.enspara1/bc/o/com/naefs/dev
COM_OUT=/gpfs/hps3/emc/ensemble/noscrub/emc.enspara1/bc/o/com/naefs/dev

COMIN=$COM_IN/gefs.$PDY/$cyc
COMOUT=$COM_OUT/gefs.$PDY/$cyc
mkdir -p $COMOUT
scp -rp $prod:$COMIN/* $COMOUT/

COMIN=$COM_IN/naefs.$PDY/$cyc
COMOUT=$COM_OUT/naefs.$PDY/$cyc
mkdir -p $COMOUT
scp -rp $prod:$COMIN/* $COMOUT/

