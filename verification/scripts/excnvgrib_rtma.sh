#!/bin/bash -l

set -x

Date=`date +%y%m%d%H`
CDATE=20$Date

#PDY=`echo $CDATE | cut -c1-8`
#cyc=`echo $CDATE | cut -c9-10`

CDATE=${PDY}00
cyc=00                                 

### save rtma data 

COM_OUT=/lfs/h2/emc/vpppg/noscrub/$LOGNAME/com/rtma/v2.9                  

cyclist="00 03 06 09 12 15 18 21"

COMOUT=$COM_OUT/akrtma.$PDY
for cyc in $cyclist; do
  filein=$COMOUT/akrtma.t${cyc}z.2dvaranl_ndfd_3p0.grb2
  fileout=$COMOUT/akrtma.t${cyc}z.2dvaranl_ndfd_3p0.grb1
  $CNVGRIB -g21 $filein $fileout
done

COMOUT=$COM_OUT/rtma2p5.$PDY
for cyc in $cyclist; do
  filein=$COMOUT/rtma2p5.t${cyc}z.2dvaranl_ndfd.grb2_ext
  fileout=$COMOUT/rtma2p5.t${cyc}z.2dvaranl_ndfd.grb1_ext
  $CNVGRIB -g21 $filein $fileout
done
