#export CDATE=2008082900         

if [ "$CDATE" -eq " " ]; then
  echo "No data for CDATE, please check"
  exit 8
fi

PDY=`echo $CDATE | cut -c1-8`
cyc=`echo $CDATE | cut -c9-10`

cd $DATA

export pgm=4vefy_tmaxmin_alaska
export pgmout=output          
#. prep_step

################################################################
### define the days for searching bias estimation backup
################################################################

ymdh=$PDY$cyc
export PDYm1=`$NDATE -24 $ymdh | cut -c1-8`
export PDYm2=`$NDATE -48 $ymdh | cut -c1-8`
export PDYm3=`$NDATE -72 $ymdh | cut -c1-8`

###############################################################################################
### calculate bias estimation for different forecast lead time
# Alaska Daylight Time:Tmax period: 13UTC (5am-local) 04UTC ( 8pm-local) � local daylight time
#                    Tmin period: 01UTC (5pm-local) 19UTC (11am-local) � local daylight time
# Alaska Standard Time:Tmax period: 14UTC (5am-local) 05UTC (8pm-local)    local daylight time
#    	             Tmin period: 02UTC (5pm-local)  20UTC (11am-local)  local daylight time
##############################################################################################

#tmaxlist=" 15 16 17 18 19 20 21 22 23 00 01 02 03 04 "
#tminlist=" 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17"

tmaxlist=" 13 14 15 16 17 18 19 20 21 22 23 00 01 02 03 04 "
tminlist=" 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19"

tmax_nfhr_00="     36  60  84 108 132 156 180 204 228 252 276 300 324 348 372"
tmax_nfhr_06="     30  54  78 102 126 150 174 198 222 246 270 294 318 342 366 384"
tmax_nfhr_12=" 24  48  72  96 120 144 168 192 216 240 264 288 312 336 360 384"
tmax_nfhr_18="     42  66  90 114 138 162 186 210 234 258 282 306 330 354 378"

tmin_nfhr_00=" 24  48  72  96 120 144 168 192 216 240 264 288 312 336 360 384"
tmin_nfhr_06="     42  66  90 114 138 162 186 210 234 258 282 306 330 354 378"
tmin_nfhr_12="     36  60  84 108 132 156 180 204 228 252 276 300 324 348 372"
tmin_nfhr_18="     30  54  78 102 126 150 174 198 222 246 270 294 318 342 366 384"

tmax_nfhr_00="     36"
tmin_nfhr_00=" 24  "

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

rm tmax_rtma_alaska tmin_rtma_alaska

for acyc in $tmaxlist; do
  afile=$COMRTMA/akrtma.$PDYm2/akrtma.t${acyc}z.2dvaranl_ndfd.grb1      
  if [ $acyc -le 5 ]; then
    afile=$COMRTMA/akrtma.$PDYm1/akrtma.t${acyc}z.2dvaranl_ndfd.grb1      
  fi
  cat $afile >> tmax_rtma_alaska
done

for acyc in $tminlist; do
  afile=$COMRTMA/akrtma.$PDYm2/akrtma.t${acyc}z.2dvaranl_ndfd.grb1      
  cat $afile >> tmin_rtma_alaska
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
# forecast files entry, interpolate it on grids on alaska    
###

# cfile=$COM/gefs.${fymd}/${cyc}/ndgd/ge$nens.t${cyc}z.ndgd_alaskaf${nfhrs}
  cfile=$COM/gefs.${fymd}/${cyc}/ndgd/ge$nens.t${cyc}z.ndgd_alaskaf${nfhrs}

###
# rtma analysist file for tmax entry
###

  afile=tmax_rtma_alaska

###
#  output ensemble forecasting bias estimation 
###

  ofile1=ge${nens}.t${cyc}z.ndgd_alaska_mef${nfhrs}_tmax
  ofile2=ge${nens}.t${cyc}z.ndgd_alaska_amef${nfhrs}_tmax
  ofile3=rtma_alaska_${PDYm2}_tmax

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
# forecast files entry, interpolate it on grids on alaska    
###

  cfile=$COM/gefs.${fymd}/${cyc}/ndgd/ge$nens.t${cyc}z.ndgd_alaskaf${nfhrs}

###
# rtma analysist file for tmin entry
###

  afile=tmin_rtma_alaska

###
#  output ensemble forecasting bias estimation 
###

  ofile1=ge${nens}.t${cyc}z.ndgd_alaska_mef${nfhrs}_tmin
  ofile2=ge${nens}.t${cyc}z.ndgd_alaska_amef${nfhrs}_tmin
  ofile3=rtma_alaska_${PDYm2}_tmin

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