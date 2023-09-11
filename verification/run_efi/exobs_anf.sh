#!/bin/sh
########################################################################
# Script:   naefs_climate_anomaly.sh 
# Abstract: this script produces GRIB files of climate anomaly forecast
#           for gefs observation only
########################################################################

set +x
echo " "
echo " Entering sub script climate_anomaly.sh"
echo " "
set -x

CDATE=$PDY$cyc             

mkdir -m 775 -p ${COMOUT}
mkdir -m 775 -p $DATA

cd $DATA

hourlist=" 024"

pgm=gefs_climate_anomaly 

pgmout=output
###
########################################
# define the time that the bias between CDAS and GDAS available: $BDATE
########################################
###

for FHR in $hourlist; do

 FDATE=`$NDATE +$FHR $CDATE`
 HH=`echo $FDATE | cut -c9-10`
 MDH=`echo $FDATE | cut -c5-10`         
 MD=`echo $FDATE | cut -c5-8`         
 bcyc=`echo $FDATE | cut -c9-10`

 for ens in p01; do                                              

#ln -fs $COMfcst/ge${ens}.t${cyc}z.pgrb2a.0p50.f${FHR}   fcst_$ens.dat
 ln -fs $COMfcst/ge${ens}.t${cyc}z.pgrb2a.0p50_bcf${FHR}   fcst_$ens.dat
 ln -fs $FIXnaefs/cmean_p5d.1979${MD}             mean_$ens.dat
 ln -fs $FIXnaefs/cstdv_p5d.1979${MD}             stdv_$ens.dat

 ### get analysis difference between CFS and GDAS
 ### note: "cyc" will be defined by forecast valid time - Yuejian Zhu

 ### set ifbias=0 as default, bias information available

 ifbias=0
 infile=glbanl.t${bcyc}z.pgrb2a.0p50_mdf000

# if [ -s $COM_NCEPANL/gefs.${PDYm1}/${bcyc}/pgrb2ap5/${infile} ]; then
#  ln -fs $COM_NCEPANL/gefs.${PDYm1}/${bcyc}/pgrb2ap5/${infile} bias_$ens.dat
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
   ifbias=1
 fi

 echo "&namin " >input.${FHR}.${ens}_an
 echo "cfcst='fcst_$ens.dat'," >>input.${FHR}.${ens}_an
 echo "cmean='mean_$ens.dat'," >>input.${FHR}.${ens}_an
 echo "cstdv='stdv_$ens.dat'," >>input.${FHR}.${ens}_an
 echo "cbias='bias_$ens.dat'," >>input.${FHR}.${ens}_an
 echo "canom='anom_$ens.dat'," >>input.${FHR}.${ens}_an
 echo "ibias=$ifbias," >>input.${FHR}.${ens}_an
 echo "/" >>input.${FHR}.${ens}_an

 startmsg
 $EXECstat/$pgm <input.${FHR}.${ens}_an > $pgmout.$FHR.${ens}_anf 2> errfile
 export err=$?;err_chk

 cp anom_$ens.dat ge${ens}.t${cyc}z.pgrb2a.0p50_anaf${FHR}
 mv ge${ens}.t${cyc}z.pgrb2a.0p50_anaf${FHR} $COMOUT

 done

#rm fcst_*.dat mean_*.dat stdv_*.dat 
#if [ -s bias_$ens.dat ]; then
#  rm bias_$ens.dat
#fi

done

set +x
echo " "
echo "Leaving sub script naefs_climate_anomaly.sh"
echo " "
set -x
