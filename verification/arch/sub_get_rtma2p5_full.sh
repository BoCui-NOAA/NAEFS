#!/bin/bash
#PBS -N transfer
# Join error and output.  Will be placed in current working directory
#PBS -j oe
#PBS -A NAEFS-DEV 
#Select 1 vnode, 1 core=1cpus, 100 MB of memory
#PBS -l select=1:ncpus=1:mem=100MB
#PBS -q dev_transfer
#PBS -l walltime=45:30.00

cd $PBS_O_WORKDIR

#scp userid@machine:/directory/file /directory/file
#scp carolyn.pasti@cdxfer.wcoss2.ncep.noaa.gov:/u/carolyn.pasti/cactus.file /u/carolyn.pasti/dogwood.file

#HPSSTAR=/u/bo.cui/xbin/hpsstar

CDATE=2023010400
ndays=3 
CNVGRIB=/apps/ops/prod/libs/intel/19.1.3.304/grib_util/1.2.3/bin/cnvgrib

#CDATE=$1          
#ndays=31

#version=v2.10
version=v2.9

DATA=/lfs/h2/emc/vpppg/noscrub/$LOGNAME/com/rtma/v2.9      

HPSSOUT=/NCEPPROD/hpssprod/runhistory

cyclist1="00 01 02 03 04 05"
cyclist2="06 07 08 09 10 11"
cyclist3="12 13 14 15 16 17"
cyclist4="18 19 20 21 22 23"

#cyclist1="00 03"
#cyclist2="06 09"
#cyclist3="12 15"
#cyclist4="18 21"

cyclist1="   01 02    04 05"
cyclist2="   07 08    10 11"
cyclist3="   13 14    16 17"
cyclist4="   19 20    22 23"

iday=1
while [ $iday -le $ndays ]; do

  export YER=`echo $CDATE | cut -c1-4`
  export MON=`echo $CDATE | cut -c1-6`
  export PDY=`echo $CDATE | cut -c1-8`

  mkdir -p ${DATA}/rtma2p5.${PDY}
  cd $DATA/rtma2p5.${PDY}

  file=$HPSSOUT/rh${YER}/${MON}/${PDY}/com_rtma_${version}_rtma2p5.${PDY}00-05.tar

  for cyc in $cyclist1; do

#   hpsstar get $file  ./rtma2p5.t${cyc}z.2dvaranl_ndfd.grb2
#   $CNVGRIB -g21 rtma2p5.t${cyc}z.2dvaranl_ndfd.grb2 rtma2p5.t${cyc}z.2dvaranl_ndfd.grb1
#   hpsstar get $file  ./rtma.t${cyc}z.2dvaranl_ndfd.grb2
#   $CNVGRIB -g21 rtma.t${cyc}z.2dvaranl_ndfd.grb2 rtma.t${cyc}z.2dvaranl_ndfd.grb1
#   hpsstar get $file  ./rtma2p5.t${cyc}z.2dvaranl_ndfd.grb2_ext

    file_wexp=rtma2p5.t${cyc}z.2dvaranl_ndfd.grb2_wexp
    file_ext=rtma2p5.t${cyc}z.2dvaranl_ndfd.grb2_ext 
    hpsstar get $file  ./$file_wexp                                                      
    $WGRIB2 $file_wexp   -ijsmall_grib 201:2345 1:1597  $file_ext
    $CNVGRIB -g21 rtma2p5.t${cyc}z.2dvaranl_ndfd.grb2_ext rtma2p5.t${cyc}z.2dvaranl_ndfd.grb1_ext

  done

  file=$HPSSOUT/rh${YER}/${MON}/${PDY}/com_rtma_${version}_rtma2p5.${PDY}06-11.tar

  for cyc in $cyclist2; do
#   hpsstar get $file  ./rtma2p5.t${cyc}z.2dvaranl_ndfd.grb2
#   $CNVGRIB -g21 rtma2p5.t${cyc}z.2dvaranl_ndfd.grb2 rtma2p5.t${cyc}z.2dvaranl_ndfd.grb1
#   hpsstar get $file  ./rtma2p5.t${cyc}z.2dvaranl_ndfd.grb2_ext
#   $CNVGRIB -g21 rtma2p5.t${cyc}z.2dvaranl_ndfd.grb2_ext rtma2p5.t${cyc}z.2dvaranl_ndfd.grb1_ext
#   hpsstar get $file  ./rtma.t${cyc}z.2dvaranl_ndfd.grb2
#   $CNVGRIB -g21 rtma.t${cyc}z.2dvaranl_ndfd.grb2 rtma.t${cyc}z.2dvaranl_ndfd.grb1
    file_wexp=rtma2p5.t${cyc}z.2dvaranl_ndfd.grb2_wexp
    file_ext=rtma2p5.t${cyc}z.2dvaranl_ndfd.grb2_ext 
    hpsstar get $file  ./$file_wexp                                                      
    $WGRIB2 $file_wexp   -ijsmall_grib 201:2345 1:1597  $file_ext
    $CNVGRIB -g21 rtma2p5.t${cyc}z.2dvaranl_ndfd.grb2_ext rtma2p5.t${cyc}z.2dvaranl_ndfd.grb1_ext
  done

  file=$HPSSOUT/rh${YER}/${MON}/${PDY}/com_rtma_${version}_rtma2p5.${PDY}12-17.tar

  for cyc in $cyclist3; do
#   hpsstar get $file  ./rtma2p5.t${cyc}z.2dvaranl_ndfd.grb2
#   $CNVGRIB -g21 rtma2p5.t${cyc}z.2dvaranl_ndfd.grb2 rtma2p5.t${cyc}z.2dvaranl_ndfd.grb1
#   hpsstar get $file  ./rtma2p5.t${cyc}z.2dvaranl_ndfd.grb2_ext
#   $CNVGRIB -g21 rtma2p5.t${cyc}z.2dvaranl_ndfd.grb2_ext rtma2p5.t${cyc}z.2dvaranl_ndfd.grb1_ext
#   hpsstar get $file  ./rtma.t${cyc}z.2dvaranl_ndfd.grb2
#   $CNVGRIB -g21 rtma.t${cyc}z.2dvaranl_ndfd.grb2 rtma.t${cyc}z.2dvaranl_ndfd.grb1
    file_wexp=rtma2p5.t${cyc}z.2dvaranl_ndfd.grb2_wexp
    file_ext=rtma2p5.t${cyc}z.2dvaranl_ndfd.grb2_ext 
    hpsstar get $file  ./$file_wexp                                                      
    $WGRIB2 $file_wexp   -ijsmall_grib 201:2345 1:1597  $file_ext
    $CNVGRIB -g21 rtma2p5.t${cyc}z.2dvaranl_ndfd.grb2_ext rtma2p5.t${cyc}z.2dvaranl_ndfd.grb1_ext
  done

  file=$HPSSOUT/rh${YER}/${MON}/${PDY}/com_rtma_${version}_rtma2p5.${PDY}18-23.tar

  for cyc in $cyclist4; do
#   hpsstar get $file  ./rtma2p5.t${cyc}z.2dvaranl_ndfd.grb2
#   $CNVGRIB -g21 rtma2p5.t${cyc}z.2dvaranl_ndfd.grb2 rtma2p5.t${cyc}z.2dvaranl_ndfd.grb1
#   hpsstar get $file  ./rtma2p5.t${cyc}z.2dvaranl_ndfd.grb2_ext
#   $CNVGRIB -g21 rtma2p5.t${cyc}z.2dvaranl_ndfd.grb2_ext rtma2p5.t${cyc}z.2dvaranl_ndfd.grb1_ext
#   hpsstar get $file  ./rtma.t${cyc}z.2dvaranl_ndfd.grb2
#   $CNVGRIB -g21 rtma.t${cyc}z.2dvaranl_ndfd.grb2 rtma.t${cyc}z.2dvaranl_ndfd.grb1
    file_wexp=rtma2p5.t${cyc}z.2dvaranl_ndfd.grb2_wexp
    file_ext=rtma2p5.t${cyc}z.2dvaranl_ndfd.grb2_ext 
    hpsstar get $file  ./$file_wexp                                                      
    $WGRIB2 $file_wexp   -ijsmall_grib 201:2345 1:1597  $file_ext
    $CNVGRIB -g21 rtma2p5.t${cyc}z.2dvaranl_ndfd.grb2_ext rtma2p5.t${cyc}z.2dvaranl_ndfd.grb1_ext
  done

  iday=`expr $iday + 1`
  CDATE=`$NDATE +24 $CDATE`

done

