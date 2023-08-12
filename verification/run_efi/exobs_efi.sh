#!/bin/sh
############################################################
# Script: naefs_climate_efi.sh
# ABSTRACT:  produces ensemble mean climate anomaly forecast
#            extreme foreacst index
############################################################
set +x

echo " "
echo " Entering sub script gefs_climate_anfefi.sh"
echo " iob input initial time is: $CDATE=$1 "
echo " job input forecast time is: $fhr=$2   "
echo " "

CDATE=$PDY$cyc

mkdir -m 775 -p ${COMOUT}
mkdir -m 775 -p $DATA

cd $DATA

hourlist=" 000"

YMD=`echo $CDATE | cut -c1-8`
cyc=`echo $CDATE | cut -c9-10`

pgm=gefs_climate_anomefi
pgmout=output

for FHR in $hourlist; do

# input ensemble mean and spread forecasts

  ln -fs $COMfcst/geavg.t${cyc}z.pgrb2a.0p50.f${FHR} fcstm.dat
  ln -fs $COMfcst/gespr.t${cyc}z.pgrb2a.0p50.f${FHR} fcsts.dat

# input claimtology

  export  JDATE=`$NDATE +$FHR $CDATE`
  export  MMDD=`echo $JDATE | cut -c5-8`         
  export  MMDDHH=`echo $JDATE | cut -c5-10`         
  bcyc=`echo $JDATE | cut -c9-10`

  cfile=$FIXnaefs/cmean_p5d.1979${MMDD}
  $WGRIB2 $cfile -s | egrep "1979${MMDDHH}" | $WGRIB2 -i $cfile -grib anlm

  cfile=$FIXnaefs/cstdv_p5d.1979${MMDD}
  $WGRIB2 $cfile -s | egrep "1979${MMDDHH}" | $WGRIB2 -i $cfile -grib anls

# 

  for ens in avg; do                                          

    ibias=0
    infile=glbanl.t${bcyc}z.pgrb2a.0p50_mdf000

#   if [ -s $COM_NCEPANL/gefs.${PDYm1}/${bcyc}/pgrb2ap5/${infile} ]; then
#     ln -fs $COM_NCEPANL/gefs.${PDYm1}/${bcyc}/pgrb2ap5/${infile} bias_$ens.dat
    if [ -s $COM_NCEPANL/gefs.${PDYm2}/${bcyc}/pgrb2ap5/${infile} ]; then
      ln -fs $COM_NCEPANL/gefs.${PDYm2}/${bcyc}/pgrb2ap5/${infile} bias_$ens.dat
    elif [ -s $COM_NCEPANL/gefs.${PDYm3}/${bcyc}/pgrb2ap5/${infile} ]; then
      ln -fs $COM_NCEPANL/gefs.${PDYm3}/${bcyc}/pgrb2ap5/${infile} bias_$ens.dat
    elif [ -s $COM_NCEPANL/gefs.${PDYm4}/${bcyc}/pgrb2ap5/${infile} ]; then
      ln -fs $COM_NCEPANL/gefs.${PDYm4}/${bcyc}/pgrb2ap5/${infile} bias_$ens.dat
    elif [ -s $COM_NCEPANL/gefs.${PDYm5}/${bcyc}/pgrb2ap5/${infile} ]; then
      ln -fs $COM_NCEPANL/gefs.${PDYm5}/${bcyc}/pgrb2ap5/${infile} bias_$ens.dat
    elif [ -s $COM_NCEPANL/gefs.${PDYm6}/${bcyc}/pgrb2ap5/${infile} ]; then
      ln -fs $COM_NCEPANL/gefs.${PDYm6}/${bcyc}/pgrb2ap5/${infile} bias_$ens.dat
    else
      ibias=1
    fi

    echo "&namin " >input.${FHR}.${ens}_anfefi
    echo "cfcstm='fcstm.dat'," >>input.${FHR}.${ens}_anfefi
    echo "cfcsts='fcsts.dat'," >>input.${FHR}.${ens}_anfefi
    echo "canlm='anlm'," >>input.${FHR}.${ens}_anfefi
    echo "canls='anls'," >>input.${FHR}.${ens}_anfefi
    echo "cefi='efi_$ens.dat'," >>input.${FHR}.${ens}_anfefi
    echo "canom='anom_$ens.dat'," >>input.${FHR}.${ens}_anfefi
    echo "cbias='bias_$ens.dat'," >>input.${FHR}.${ens}_anfefi
    echo "ibias=$ibias," >>input.${FHR}.${ens}_anfefi
    echo "/" >>input.${FHR}.${ens}_anfefi

#  excute program

    startmsg
    $EXECstat/$pgm  <input.${FHR}.${ens}_anfefi > $pgmout.$FHR.${ens}_anfefi 2> errfile
    export err=$?;err_chk

#  output data

    cp efi_$ens.dat  geefi.t${cyc}z.pgrb2a.0p50_anaf${FHR}
    cp anom_$ens.dat ge${ens}.t${cyc}z.pgrb2a.0p50_anaf${FHR}

    mv ge${ens}.t${cyc}z.pgrb2a.0p50_anaf${FHR} $COMOUT
    mv geefi.t${cyc}z.pgrb2a.0p50_anaf${FHR}   $COMOUT

  done

  rm fcstm.dat fcsts.dat anlm anls
  if [ -s bias_$ens.dat ]; then
   rm bias_$ens.dat
  fi

done

set +x
echo " "
echo "Leaving sub naefs_climate_efi.sh"
echo " "
set -x

