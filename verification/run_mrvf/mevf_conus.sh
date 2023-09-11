#!/bin/bash
########################### BIASUPDATE ################################
echo "---------------------------------------------------------------"
echo "Calculate ME and AME of Downscaled NAEFS Against RTMA Analysis"
echo "---------------------------------------------------------------"
echo "History: May 2006 - First implementation of this new script."
echo "AUTHOR: Bo Cui  (Bo.Cui)"

### To submit this job for T00Z and T12Z  two cycles per day

### need pass the values of PDY, CYC, DATA, COMIN, and COMOUT

#export CDATE=$1                 

#if [ "$CDATE" -eq " " ]; then
#  echo "No data for CDATE, please check"
#  exit 8
#fi

export PDY=`echo $CDATE | cut -c1-8`
export cyc=`echo $CDATE | cut -c9-10`

###    
################################################################
# define exec variable, and entry grib utility 
################################################################
###    

SENDCOM=YES

export ireg=conus 

export direxp=naefs.v7.0.0
export gefs_ver=v12.3
export rtma_ver=v2.9

export PACKAGEROOT=/lfs/h2/emc/vpppg/noscrub/$LOGNAME
export HOMEcrps=$PACKAGEROOT/$direxp/verification
export EXECcrps=$HOMEcrps/exec

export COMROOT=/lfs/h2/emc/vpppg/noscrub/$LOGNAME/com
export COM_RTMA=$COMROOT/rtma/$rtma_ver

export DATAROOT=/lfs/h2/emc/ptmp/$LOGNAME/tmpnwprd

VEFYTMAXMIN=$HOMEcrps/run_mrvf/mevf_conus_tmaxmin.sh                     

#export naefs_ver=v6.1 
#export id=gefs

for naefs_ver in v6.1 v7.0; do
for id in gefs naefs; do

export naefs_ver
export id        

export COMROOT=/lfs/h2/emc/vpppg/noscrub/$LOGNAME/com
export COM_NDGD=$COMROOT/naefs/$naefs_ver

COMROOT=/lfs/h2/emc/ptmp/$LOGNAME/com          
export COM_OUT=$COMROOT/naefs/$naefs_ver
export COMOUT=$COM_OUT/${id}.${PDY}/${cyc}/mevf_${ireg}

rm -rf $COMOUT
mkdir -m 775 -p ${COMOUT}

export DATA=$DATAROOT/crps_vrfy/out_${naefs_ver}_${id}_mevf_$PDY$cyc.$ireg

rm -rf $DATA
mkdir -m 775 -p $DATA
cd $DATA

export pgm=rtma_me_ame_6vars   
export pgmout=output          
#. prep_step

################################################################
### define the days for searching bias estimation backup
################################################################

ymdh=$PDY$cyc
export PDYm1=`$NDATE -24 $ymdh | cut -c1-8`
export PDYm2=`$NDATE -48 $ymdh | cut -c1-8`
export PDYm3=`$NDATE -72 $ymdh | cut -c1-8`
export PDYm4=`$NDATE -96 $ymdh | cut -c1-8`
export PDYm5=`$NDATE -120 $ymdh | cut -c1-8`
export PDYm6=`$NDATE -144 $ymdh | cut -c1-8`
export PDYm7=`$NDATE -168 $ymdh | cut -c1-8`
export PDYm8=`$NDATE -192 $ymdh | cut -c1-8`

###

$VEFYTMAXMIN

#cp rtma_conus_${PDYm1}_tmax $COM_RTMA/rtma2p5.${PDYm1}/rtma2p5_conus_${PDYm1}_tmax_ext
#cp rtma_conus_${PDYm1}_tmin $COM_RTMA/rtma2p5.${PDYm1}/rtma2p5_conus_${PDYm1}_tmin_ext

################################################################
### calculate bias estimation for different forecast lead time
################################################################

hourlist="000 006 012 018 024 030 036 042 048 054 060 066 072 078 084 090 096 \
          102 108 114 120 126 132 138 144 150 156 162 168 174 180 186 192 198 \
          204 210 216 222 228 234 240 246 252 258 264 270 276 282 288 294 300 \
          306 312 318 324 330 336 342 348 354 360 366 372 378 384"

#hourlist="006"

export memberlist="geavg"

###
# input basic information, member and forecast lead time
###

for nfhrs in $hourlist; do

###
# rtma analysis files entry
###

  fymdh=${PDYm1}18
  fymdh=`$NDATE -$nfhrs $fymdh `
  fymd=`echo $fymdh | cut -c1-8`

  aymdh=`$NDATE +$nfhrs $fymd$cyc `
  aymh=`echo $aymdh | cut -c1-8`
  acyc=`echo $aymdh | cut -c9-10`

  afile=$COM_RTMA/rtma2p5.$aymh/rtma2p5.t${acyc}z.2dvaranl_ndfd.grb1_ext

# cat $afile_01 $afile_02 >>$afile

  if [ ! -s $afile ]; then
    echo " There is no RTMA data, Stop! for " $acyc 
    echo $afile
  fi

# if [ ! -s $afile ]; then
#   echo " "
# else
#   echo " There is no RTMA data, Stop! for " $acyc 
#   echo $afile
#   exit
# fi

###
# forecast files entry, interpolate it on grids on conus    
###

  nens=avg

  COMNDGD=$COM_NDGD/${id}.${fymd}/${cyc}/ndgd
  cfile=$COMNDGD/${id}.t${cyc}z.geavg.f${nfhrs}.conus_ext_2p5.grib1

###
#  output ensemble forecasting bias estimation 
###

  ofile1=${id}.t${cyc}z.conus_ext_2p5_mef${nfhrs}_part
  ofile2=${id}.t${cyc}z.conus_ext_2p5_amef${nfhrs}_part

  rm fort.* input.*
 
  odate=`$NDATE -24 $PDY$cyc `

  echo "&message"  >input.$nfhrs.$nens
  echo " icstart=${cstart}," >> input.$nfhrs.$nens
  echo " odate=$odate," >>input.$nfhrs.$nens
  echo "/" >>input.$nfhrs.$nens
  
  ln -sf $afile  fort.12
  ln -sf $cfile  fort.13
  ln -sf $ofile1 fort.51
  ln -sf $ofile2 fort.52

# startmsg
  $EXECcrps/$pgm  <input.$nfhrs.$nens > $pgmout.$nfhrs.${nens}
# export err=$?;err_chk

done

if [ "$SENDCOM" = "YES" ]; then
  for nfhrs in $hourlist; do
    for nens in $memberlist; do

      ofile=${id}.t${cyc}z.conus_ext_2p5_mef${nfhrs}
      ofile1=${id}.t${cyc}z.conus_ext_2p5_mef${nfhrs}_part
      ofile2=${id}.t${cyc}z.conus_ext_2p5_mef${nfhrs}_tmax
      ofile3=${id}.t${cyc}z.conus_ext_2p5_mef${nfhrs}_tmin
      cp $ofile1 $ofile
      if [ -s $ofile2 ]; then
        cat $ofile2 >>$ofile
      fi
      if [ -s $ofile3 ]; then
        cat $ofile3 >>$ofile
      fi
      if [ -s $ofile ]; then
        mv $ofile $COMOUT/
      fi

      ofile=${id}.t${cyc}z.conus_ext_2p5_amef${nfhrs}
      ofile1=${id}.t${cyc}z.conus_ext_2p5_amef${nfhrs}_part
      ofile2=${id}.t${cyc}z.conus_ext_2p5_amef${nfhrs}_tmax
      ofile3=${id}.t${cyc}z.conus_ext_2p5_amef${nfhrs}_tmin
      cp $ofile1 $ofile
      if [ -s $ofile2 ]; then
        cat $ofile2 >>$ofile
      fi
      if [ -s $ofile3 ]; then
        cat $ofile3 >>$ofile
      fi
      if [ -s $ofile ]; then
        mv $ofile $COMOUT/
      fi

    done
  done
fi

done
done

msg="HAS COMPLETED NORMALLY!"
#postmsg "$jlogfile" "$msg"

###