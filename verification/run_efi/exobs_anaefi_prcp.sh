#!/bin/sh
###############################################################################################

echo "---------------------------------------------------------"
echo "Calculate GEFS anomaly forecast and EFI for 24-hr accmulated precipitation"
echo "---------------------------------------------------------"
echo "History: March 2017 - First implementation of this new script"
echo "AUTHOR: Hong Guan (Hong.Guan)"
####################################################################################################

set -x

################################################################
# define exec variable, and entry grib utility 
################################################################

export CDATE=${PDY}${cyc}
export YMDH=$CDATE
export YMDM1=`$NDATE -24 $YMDH | cut -c1-8`

mkdir -m 775 -p ${COMOUT} 
mkdir -m 775 -p $DATA

pgmout=output
pgm=obs_climate_anfefi_acpr

cd $DATA
rm *

hourlist="000"

if [ $cyc -eq 18 ]; then
export YMDH=${YMDM1}\18
fi

grid="0 6 0 0 0 0 0 0 720 361 0 0 90000000 0 48 -90000000 359500000 500000 500000 0"

  for nfhrs in $hourlist; do

    export  JDATE=`$NDATE +$nfhrs $YMDH`
    export  MMDD=`echo $JDATE | cut -c5-8`
    export  YYMMDD=`echo $JDATE | cut -c1-8`

    ln -fs ${FIXnaefs}/gamma1_24hr_2004${MMDD} gam1.dat
    ln -fs ${FIXnaefs}/gamma2_24hr_2004${MMDD} gam2.dat
    $COPYGB2 -g "$grid" -x  gam1.dat  gamma1.dat
    $COPYGB2 -g "$grid" -x  gam2.dat  gamma2.dat

    echo "&message"  >input.$nfhrs
    echo " nfhr=${nfhrs}," >> input.$nfhrs
    echo "/" >>input.$nfhrs

    file=ccpa_conus_0.5d_${YYMMDD}
    cp ${COMprcp}/$file  $file.g1 

    $CNVGRIB -g12 $file.g1  $file
    $COPYGB2 -g "$grid" -x $file fcst.dat

    echo "&namin " >input
    echo "cfcst='fcst.dat'," >>input
    echo "cgamma1='gamma1.dat'," >>input
    echo "cgamma2='gamma2.dat'," >>input
    echo "cefi='efi.dat'," >>input
    echo "canom='anom.dat'," >>input
    echo "/" >>input
   
    startmsg
    $EXECstat/$pgm <input > ${pgmout}_an 2> errfile
    export err=$?;err_chk
   
    mv efi.dat  geprcp.t${cyc}z.pgrb2a.0p50.efif$nfhrs 
    mv anom.dat geprcp.t${cyc}z.pgrb2a.0p50.anaf$nfhrs 

    outfile=geprcp.t${cyc}z.pgrb2a.0p50.anaf$nfhrs
    if [ -s $outfile ]; then
      cp $outfile $COMOUT/
    fi
    outfile=geprcp.t${cyc}z.pgrb2a.0p50.efif$nfhrs
    if [ -s $outfile ]; then
      cp $outfile $COMOUT/
     fi
  done

msg="HAS COMPLETED NORMALLY!"
postmsg "$jlogfile" "$msg"

exit 0
