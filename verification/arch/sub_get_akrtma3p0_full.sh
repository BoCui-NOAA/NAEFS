#!/bin/bash
#PBS -N transfer
# Join error and output.  Will be placed in current working directory
#PBS -j oe
#PBS -A NAEFS-DEV
#Select 1 vnode, 1 core=1cpus, 100 MB of memory
#PBS -l select=1:ncpus=1:mem=100MB
#PBS -q dev_transfer
#PBS -l walltime=15:30.00

cd $PBS_O_WORKDIR

CDATE=2023010500
ndays=2

#CDATE=$1          
#ndays=31

#version=v2.10
version=v2.9

DATA=/lfs/h2/emc/vpppg/noscrub/$LOGNAME/com/rtma/v2.9

HPSSOUT=/NCEPPROD/hpssprod/runhistory

#cyclist1="00 03"
#cyclist2="06 09"
#cyclist3="12 15"
#cyclist4="18 21"

cyclist1="   01 02    04 05"
cyclist2="   07 08    10 11"
cyclist3="   13 14    16 17"
cyclist4="   19 20    22 23"

cyclist1="00 01 02 03 04 05"
cyclist2="06 07 08 09 10 11"
cyclist3="12 13 14 15 16 17"
cyclist4="18 19 20 21 22 23"

iday=1
while [ $iday -le $ndays ]; do

  export YER=`echo $CDATE | cut -c1-4`
  export MON=`echo $CDATE | cut -c1-6`
  export PDY=`echo $CDATE | cut -c1-8`

  mkdir -p ${DATA}/akrtma.${PDY}
  cd $DATA/akrtma.${PDY}

  file=$HPSSOUT/rh${YER}/${MON}/${PDY}/com_rtma_${version}_akrtma.${PDY}00-05.tar

  for cyc in $cyclist1; do
    echo $cyc
    hpsstar get $file  ./akrtma.t${cyc}z.2dvaranl_ndfd_3p0.grb2
#    $CNVGRIB -g21 akrtma.t${cyc}z.2dvaranl_ndfd_3p0.grb2 akrtma.t${cyc}z.2dvaranl_ndfd_3p0.grb1
  done

  file=$HPSSOUT/rh${YER}/${MON}/${PDY}/com_rtma_${version}_akrtma.${PDY}06-11.tar

  for cyc in $cyclist2; do
    echo $cyc
    hpsstar get $file  ./akrtma.t${cyc}z.2dvaranl_ndfd_3p0.grb2
#    $CNVGRIB -g21 akrtma.t${cyc}z.2dvaranl_ndfd_3p0.grb2 akrtma.t${cyc}z.2dvaranl_ndfd_3p0.grb1
  done

  file=$HPSSOUT/rh${YER}/${MON}/${PDY}/com_rtma_${version}_akrtma.${PDY}12-17.tar

  for cyc in $cyclist3; do
    echo $cyc
    hpsstar get $file  ./akrtma.t${cyc}z.2dvaranl_ndfd_3p0.grb2
#    $CNVGRIB -g21 akrtma.t${cyc}z.2dvaranl_ndfd_3p0.grb2 akrtma.t${cyc}z.2dvaranl_ndfd_3p0.grb1
  done

  file=$HPSSOUT/rh${YER}/${MON}/${PDY}/com_rtma_${version}_akrtma.${PDY}18-23.tar

  for cyc in $cyclist4; do
    echo $cyc
    hpsstar get $file  ./akrtma.t${cyc}z.2dvaranl_ndfd_3p0.grb2
#    $CNVGRIB -g21 akrtma.t${cyc}z.2dvaranl_ndfd_3p0.grb2 akrtma.t${cyc}z.2dvaranl_ndfd_3p0.grb1
  done

  iday=`expr $iday + 1`
  CDATE=`$NDATE +24 $CDATE`

done

