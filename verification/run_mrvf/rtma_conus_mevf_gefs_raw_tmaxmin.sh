if [ "$CDATE" -eq " " ]; then
  echo "No data for CDATE, please check"
  exit 8
fi

PDY=`echo $CDATE | cut -c1-8`
cyc=`echo $CDATE | cut -c9-10`

cd $DATA
rm output*

export pgm=4vefy_tmaxmin_alaska
export pgmout=output          
#. prep_step

########################################################
### define the days for searching bias estimation backup
########################################################

ymdh=$PDY$cyc
export PDYm1=`$NDATE -24 $ymdh | cut -c1-8`
export PDYm2=`$NDATE -48 $ymdh | cut -c1-8`
export PDYm3=`$NDATE -72 $ymdh | cut -c1-8`

################################################################
# Calculate bias estimation for different forecast lead time
#
# Conus Daylight Time:Tmax period: 11/12 UTC - 23/00 UTC
#                     Tmin period: 23/00 UTC  12/13 UTC
###############################################################

tmaxlist=" 11 12 13 14 15 16 17 18 19 20 21 22 23 00  "
tminlist=" 23 00 01 02 03 04 05 06 07 08 09 10 11 12 13"

tmax_nfhr_00="     30  54  78 102 126 150 174 198 222 246 270 294 318 342 366 384"
tmax_nfhr_06=" 24  48  72  96 120 144 168 192 216 240 264 288 312 336 360 384"
tmax_nfhr_12="     42  66  90 114 138 162 186 210 234 258 282 306 330 354 378"
tmax_nfhr_18="     36  60  84 108 132 156 180 204 228 252 276 300 324 348 372"

tmin_nfhr_00=" 18  42  66  90 114 138 162 186 210 234 258 282 306 330 354 378"
tmin_nfhr_06="     36  60  84 108 132 156 180 204 228 252 276 300 324 348 372"
tmin_nfhr_12="     30  54  78 102 126 150 174 198 222 246 270 294 318 342 366 384"
tmin_nfhr_18=" 24  48  72  96 120 144 168 192 216 240 264 288 312 336 360 384"

if [ $cyc -eq 00 ]; then
 tmax_nfhrlist=$tmax_nfhr_00
 tmin_nfhrlist=$tmin_nfhr_00
elif [ $cyc -eq 06 ]; then
 tmax_nfhrlist=$tmax_nfhr_06
 tmin_nfhrlist=$tmin_nfhr_06
elif [ $cyc -eq 12 ]; then
 tmax_nfhrlist=$tmax_nfhr_12
 tmin_nfhrlist=$tmin_nfhr_12
elif [ $cyc -eq 18 ]; then
 tmax_nfhrlist=$tmax_nfhr_18
 tmin_nfhrlist=$tmin_nfhr_18
fi

###
# rtma analysis files entry for tmax & tmin
###

rm tmax_rtma_conus tmin_rtma_conus

for acyc in $tmaxlist; do
  afile=$COMRTMA/rtma.$PDYm2/rtma.t${acyc}z.2dvaranl_ndfd.grb1      
  if [ $acyc -eq 00 ]; then
    afile=$COMRTMA/rtma.$PDYm1/rtma.t${acyc}z.2dvaranl_ndfd.grb1      
  fi
  cat $afile >> tmax_rtma_conus
done

for acyc in $tminlist; do
  afile=$COMRTMA/rtma.$PDYm1/rtma.t${acyc}z.2dvaranl_ndfd.grb1      
  if [ $acyc -eq 23 ]; then
    afile=$COMRTMA/rtma.$PDYm2/rtma.t${acyc}z.2dvaranl_ndfd.grb1      
  fi
  cat $afile >> tmin_rtma_conus
done

###
# step 1: calculate me and mae for tmax
###

nens=avg

for nfhrs in $tmax_nfhrlist; do

  fymdh=${PDYm1}18
  fymdh=`$NDATE -$nfhrs $fymdh `
  fymd=`echo $fymdh | cut -c1-8`

###
# forecast files entry, interpolate it on grids on conus    
###

  cfile=$COM/gefs.${fymd}/${cyc}/ndgd_raw/ge$nens.t${cyc}z.ndgd_conusf${nfhrs}

###
# rtma analysist file for tmax entry
###

  afile=tmax_rtma_conus

###
#  output ensemble forecasting bias estimation 
###

  ofile1=ge${nens}.t${cyc}z.ndgd_conus_mef${nfhrs}_tmax
  ofile2=ge${nens}.t${cyc}z.ndgd_conus_amef${nfhrs}_tmax
  ofile3=rtma_conus_${PDYm2}_tmax

  rm fort.* input.*
 
  echo "&namens"  >input.$nfhrs.$nens
  echo " icstart=${cstart}," >> input.$nfhrs.$nens
  echo " variable='tmax'," >>input.$nfhrs.$nens
  echo "/" >>input.$nfhrs.$nens
  
  ln -sf $afile  fort.12
  ln -sf $cfile  fort.13
  ln -sf $ofile1 fort.51
  ln -sf $ofile2 fort.52
  ln -sf $ofile3 fort.53

# startmsg
  $EXECNAEFS/$pgm  <input.$nfhrs.$nens > $pgmout.$nfhrs.${nens}_tmax
# export err=$?;err_chk

done

###
# step 2: calculate me and mae for tmin
###

for nfhrs in $tmin_nfhrlist; do

  fymdh=${PDYm1}18
  fymdh=`$NDATE -$nfhrs $fymdh `
  fymd=`echo $fymdh | cut -c1-8`

###
# forecast files entry, interpolate it on grids on conus    
###

  cfile=$COM/gefs.${fymd}/${cyc}/ndgd_raw/ge$nens.t${cyc}z.ndgd_conusf${nfhrs}

###
# rtma analysist file for tmin entry
###

  afile=tmin_rtma_conus

###
#  output ensemble forecasting bias estimation 
###

  ofile1=ge${nens}.t${cyc}z.ndgd_conus_mef${nfhrs}_tmin
  ofile2=ge${nens}.t${cyc}z.ndgd_conus_amef${nfhrs}_tmin
  ofile3=rtma_conus_${PDYm2}_tmin

  rm fort.* input.*
 
  echo "&namens"  >input.$nfhrs.$nens
  echo " icstart=${cstart}," >> input.$nfhrs.$nens
  echo " variable='tmin'," >>input.$nfhrs.$nens
  echo "/" >>input.$nfhrs.$nens
  
  ln -sf $afile  fort.12
  ln -sf $cfile  fort.13
  ln -sf $ofile1 fort.51
  ln -sf $ofile2 fort.52
  ln -sf $ofile3 fort.53

# startmsg
  $EXECNAEFS/$pgm  <input.$nfhrs.$nens > $pgmout.$nfhrs.${nens}_tmin
# export err=$?;err_chk

done