##!/bin/bash 

#set -x

#Date=`date +%y%m%d%H`
#CDATE=20$Date

#PDY=`echo $CDATE | cut -c1-8`
#cyc=`echo $CDATE | cut -c9-10`
PDY=$1
echo $PDY

#CDATE=${PDY}00
#CDATE=`$NDATE -72 $CDATE`

#PDYm3=`echo $CDATE | cut -c1-8`
cyc=`echo $CDATE | cut -c9-10`

COMROOT=/lfs/h1/ops/prod/com/naefs/v6.1
COM_OUT=/lfs/h2/emc/vpppg/noscrub/$LOGNAME/com/naefs/v6.1                 

outdir=/lfs/h2/emc/vpppg/noscrub/bo.cui/naefs.v7.0.0/mycron

### save rtma data 

COMROOT=/lfs/h1/ops/prod/com/rtma/v2.10
COM_OUT=/lfs/h2/emc/vpppg/noscrub/$LOGNAME/com/rtma/v2.9                  

cyclist="00 03 06 09 12 15 18 21"

COMOUT=$COM_OUT/akrtma.$PDY
mkdir -p $COMOUT
#for cyc in $cyclist; do
#  cp -p $COMROOT/akrtma.$PDY/akrtma.t${cyc}z.2dvaranl_ndfd_3p0.grb2 $COMOUT
#done

cp -p $COMROOT/akrtma.$PDY/akrtma.t*z.2dvaranl_ndfd_3p0.grb2 $COMOUT

COMOUT=$COM_OUT/rtma2p5.$PDY
mkdir -p $COMOUT
#for cyc in $cyclist; do
#  cp -p $COMROOT/rtma2p5.$PDY/rtma2p5.t${cyc}z.2dvaranl_ndfd.grb2_ext  $COMOUT
#done
cp -p $COMROOT/rtma2p5.$PDY/rtma2p5.t*z.2dvaranl_ndfd.grb2_ext  $COMOUT
