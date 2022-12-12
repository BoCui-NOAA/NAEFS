#!/bin/bash -l
set -x

module load prod_util

Date=`date +%y%m%d%H`
CDATE=20$Date
CDATE=`$NDATE -8 $CDATE`

PDY=`echo $CDATE | cut -c1-8`
cyc=`echo $CDATE | cut -c9-10`

PDYm1=`$NDATE -24 $CDATE | cut -c1-8`

eval dev=` cat /etc/dev `
eval prod=` cat /etc/prod `

echo "dev is" $dev "and prod is" $prod

COM_IN=/gpfs/hps3/ptmp/emc.enspara1/bc/o/com/naefs/dev
COM_OUT=/gpfs/hps3/ptmp/emc.enspara1/bc/o/com/naefs/dev                         

if [ $cyc -eq 00 -o $cyc -eq 12 ]; then
  COMIN=$COM_IN/cmce.$PDY/$cyc
  COMOUT=$COM_OUT/cmce.$PDY/$cyc
  mkdir -p $COMOUT
  scp -rp $prod:$COMIN/pgrb2ap5 $COMOUT/
  COMIN=$COM_IN/cmce.$PDY/$cyc
  COMOUT=$COM_OUT/cmce.$PDY/$cyc
  mkdir -p $COMOUT
  scp -rp $prod:$COMIN/pgrb2ap5_bc $COMOUT/
fi

COMIN=$COM_IN/cmce.$PDYm1/$cyc
COMOUT=$COM_OUT/cmce.$PDYm1/$cyc
mkdir -p $COMOUT/pgrb2ap5
scp -p $prod:$COMIN/pgrb2ap5/*anl $COMOUT/pgrb2ap5

if [  $prod == luna ]; then
 COMROOT=/gpfs/tp2/nco/ops/com
else
 COMROOT=/gpfs/gp2/nco/ops/com
fi

COMIN=$COMROOT/gens/para/gefs.$PDY/$cyc
COMOUT=$COM_OUT/gefs.$PDY/$cyc
mkdir -p $COMOUT
scp -rp $prod:$COMIN/pgrb2ap5 $COMOUT/

COMIN=$COM_IN/gefs.$PDY/$cyc
COMOUT=$COM_OUT/gefs.$PDY/$cyc
mkdir -p $COMOUT
scp -rp $prod:$COMIN/pgrb2ap5_bc $COMOUT/

exit

