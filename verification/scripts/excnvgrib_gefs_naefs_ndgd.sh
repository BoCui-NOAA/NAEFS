######################################################################

set -x

echo "----------------------------------------"
echo "Enter sub script gefs_bc2p5_conus.sh"
echo "----------------------------------------"

#PDY=20160801
#cyc=00

if [ $model = "gefs" ]; then
  export COMIN=$COMROOT/${model}/${model_ver}/$package.$PDY/$cyc/atmos/pgrb2ap5${px}
  export COMOUT=$COMROOT/${model}/${model_ver}/$package.$PDY/$cyc/atmos/pgrbap5${px}
else
  export COMIN=$COMROOT/${model}/${model_ver}/$package.$PDY/$cyc/ndgd_gb2     
  export COMOUT=$COMROOT/${model}/${model_ver}/$package.$PDY/$cyc/ndgd                
fi
export DATA=$DATAROOT/dir_cnvgrib_${model}.${model_ver}.$package.${px}.$PDY$cyc

mkdir -p $DATA
mkdir -p $COMOUT

cd $DATA

##############################################
# define exec variable, and entry grib utility 
##############################################

. prep_step

hourlist="000 003 006 009 012 015 018 021 024 027 030 033 036 039 042 045 048 \
          051 054 057 060 063 066 069 072 075 078 081 084 087 090 093 096 099 \
          102 105 108 111 114 117 120 123 126 129 132 135 138 141 144 147 150 \
          153 156 159 162 165 168 171 174 177 180 183 186 189 192 198 204 \
          210 216 222 228 234 240 246 252 258 264 270 276 282 288 294 300 \
          306 312 318 324 330 336 342 348 354 360 366 372 378 384"

#hourlist="006"

#outlist="geavg gegfs gec00 gespr "

for nens in $outlist; do

  if [ -s poescript_cnv_$nens ]; then 
    rm poescript_cnv_$nens    
  fi

  for nfhrs in $hourlist; do

    if [ $model = "gefs" ]; then
      file_in=$COMIN/${nens}.t${cyc}z.pgrb2a.0p50.f${nfhrs}
      file_out=$COMOUT/${nens}.t${cyc}z.pgrba.0p50.f${nfhrs}
    else
      file_in=$COMIN/${package}.t${cyc}z.${nens}.f${nfhrs}.${px}.grib2
      file_out=$COMOUT/${package}.t${cyc}z.${nens}.f${nfhrs}.${px}.grib1
    fi

    if [ -s $file_in ]; then
      echo "$CNVGRIB -g21 $file_in $file_out" >>poescript_cnv_$nens
    else
      echo "echo "no file of" $file_in "      >>poescript_cnv_$nens        
    fi

  done

  chmod +x poescript_cnv_$nens         
  startmsg
  if [ $INTERACTIVE = YES ]; then
    poescript_cnv_$nens
  else
    $APRUN poescript_cnv_$nens         
  fi
  export err=$?;err_chk
  wait

done

wait

if [ $KEEPDATA != YES ]; then
  rm -rf $DATA
fi

set +x
echo " "
echo "Leaving sub script gefs_ndgd_cnvgrib.sh"
echo " "
set -x
