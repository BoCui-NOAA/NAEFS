
####
### there is no mean rom prcp conus data, chhose ctl file and identcal result


grib2ctl=/u/$LOGNAME/xbin/grib2ctl
g2ctl=/u/$LOGNAME/xbin/g2ctl
GXGIF=/u/$LOGNAME/xbin/gxgif

COM1=/lfs/h1/ops/prod/com/naefs/v6.1                        
COM2=/lfs/h2/emc/ptmp/$LOGNAME/com/naefs/v7.0                        
homedir=/lfs/h2/emc/vpppg/noscrub/bo.cui/naefs.v7.0.0/grads

#CDATE=$1                
CDATE=2023020500        


export hourlist=" 000 003 006 009 012 015 018 021 024 027 030 033 036 039 042 045 048 \
                  051 054 057 060 063 066 069 072 075 078 081 084 087 090 093 096 099 \
                  102 105 108 111 114 117 120 123 126 129 132 135 138 141 144 147 150 \
                  153 156 159 162 165 168 171 174 177 180 183 186 189 192 198 204 \
                  210 216 222 228 234 240 246 252 258 264 270 276 282 288 294 300 \
                  306 312 318 324 330 336 342 348 354 360 366 372 378 384"

export memberlist="1 2 3 4 5 6 7 8 9 10 \
                   11 12 13 14 15 16 17 18 19 20 -0"

export hourlist="048 120 240 "
export hourlist="048 120 126 132 138 240 360 "
export hourlist="048"
export memberlist="prcp"

ndays=1 
iday=1

DATA=$homedir/grads_cqpf             
mkdir -p $DATA/tmpdir
cd $DATA/tmpdir
rm *
cp ../*gs .
cp ../*ctl .

#while [ $iday -le $ndays ]; do
  export PDY=`echo $CDATE | cut -c1-8`
  export cyc=`echo $CDATE | cut -c9-10`
  export MMDD=`echo $CDATE | cut -c5-8`
  echo " day " $PDY$cyc

  for INTER in 24h 06h; do
  for nfhrs in $hourlist; do
  for mem in $memberlist; do 

      version=v6.1
      rm $version.ctl
      infile=ge${mem}.t${cyc}z.ndgd2p5_conus.${INTER}f${nfhrs}.gb2
      cp $COM1/gefs.$PDY/$cyc/ndgd_prcp_gb2/$infile ${infile}_$version
      $WGRIB2 -match "low-res ctl" ${infile}_$version  -append -grib  mean_${infile}_$version
      $g2ctl -verf mean_${infile}_$version > $version.ctl
      /u/$LOGNAME/xbin/gribmap -i $version.ctl

      version=v7.0
      rm $version.ctl
      infile=ge${mem}.t${cyc}z.ndgd2p5_conus.${INTER}f${nfhrs}.gb2
      cp $COM2/gefs.$PDY/$cyc/ndgd_prcp_gb2/$infile ${infile}_$version
      $WGRIB2 -match "low-res ctl" ${infile}_$version  -append -grib  mean_${infile}_$version
      $g2ctl -verf mean_${infile}_$version > $version.ctl
      /u/$LOGNAME/xbin/gribmap -i $version.ctl

      rm grads.gs
      sed -e "s/PDY/$PDY/" \
        -e "s/cyc/$cyc/" \
        -e "s/CDATE/$CDATE/" \
        -e "s/fhr/$nfhrs/" \
        -e "s/mem/$mem/" \
        -e "s/MMDD/$MMDD/" \
        -e "s/var/$var/" \
        -e "s/INTER/$INTER/" \
        diff_geprcp_conus.gs  >grads.gs

       grads -bcl "grads.gs"

       mv enscqpf.png  diff_geprcp_conus.${INTER}.${PDY}${cyc}.f${nfhrs}.png
    done
  done
  done

# iday=`expr $iday + 1`
# CDATE=`$NDATE +24 $CDATE`

#done

dir_main=/home/people/emc/www/htdocs/gmb/wx20cb/naefs.v7.0.0  
dir_new=diff_geprcp_conus.$CDATE  

ssh -l bocui emcrzdm "mkdir ${dir_main}/${dir_new}"
ssh -l bocui emcrzdm "cp ${dir_main}/a* ${dir_main}/${dir_new}"
ssh -l bocui emcrzdm "cp ${dir_main}/i* ${dir_main}/${dir_new}"
ssh -l bocui emcrzdm "echo $dir_new > ${dir_main}/dir_new.txt"
ssh -l bocui emcrzdm "cat ${dir_main}/dir_new.txt >> ${dir_main}/allow.cfg"
scp *.png      bocui@emcrzdm:${dir_main}/$dir_new


