grib2ctl=/u/$LOGNAME/xbin/grib2ctl
g2ctl=/u/$LOGNAME/xbin/g2ctl
GXGIF=/u/$LOGNAME/xbin/gxgif

#module use /apps/test/modules
#module load GrADS/2.2.0
#module use /apps/test/modules
#module load GrADS/2.2.1-cce-11.0.4

#COM1=/lfs/h2/emc/vpppg/noscrub/$LOGNAME/com/naefs/v6.1                      
#COM1=/lfs/h1/ops/canned/com/naefs/v6.1                      

#CDATE=2021082400

export hourlist=" 000 003 006 009 012 015 018 021 024 027 030 033 036 039 042 045 048 \
                  051 054 057 060 063 066 069 072 075 078 081 084 087 090 093 096 099 \
                  102 105 108 111 114 117 120 123 126 129 132 135 138 141 144 147 150 \
                  153 156 159 162 165 168 171 174 177 180 183 186 189 192 198 204 \
                  210 216 222 228 234 240 246 252 258 264 270 276 282 288 294 300 \
                  306 312 318 324 330 336 342 348 354 360 366 372 378 384"

export memberlist="1 2 3 4 5 6 7 8 9 10 \
                   11 12 13 14 15 16 17 18 19 20 -0"

export hourlist="048 120 126 132 138 240 360 "
export hourlist="042 054 240 360 "
export hourlist="042"
export memberlist="avg"

ndays=1 
iday=1

DATA=$homedir/ndgd_conus
mkdir -p $DATA/tmpdir_gefs_conus
cd $DATA/tmpdir_gefs_conus
rm *.png
cp ../*gs .

#while [ $iday -le $ndays ]; do
  export PDY=`echo $CDATE | cut -c1-8`
  export cyc=`echo $CDATE | cut -c9-10`
  export MMDD=`echo $CDATE | cut -c5-8`
  echo " day " $PDY$cyc

  for nfhrs in $hourlist; do
    for mem in $memberlist; do 
      rm *.gr *ctl

      infile=gefs.t${cyc}z.ge${mem}.f${nfhrs}.conus_ext_2p5.grib2
#     infile=gefs.t${cyc}z.ge${mem}.f${nfhrs}.alaska_3p0.grib2         
      cp $COM1/gefs.$PDY/$cyc/ndgd_gb2/$infile .
      $g2ctl -verf $infile  > me.ctl
      /u/$LOGNAME/xbin/gribmap -i me.ctl

      rm grads.gs
      sed -e "s/PDY/$PDY/" \
        -e "s/cyc/$cyc/" \
        -e "s/CDATE/$CDATE/" \
        -e "s/fhr/$nfhrs/" \
        -e "s/mem/$mem/" \
        -e "s/MMDD/$MMDD/" \
        ndgd_conus.gs  >grads.gs
       grads -bcl "grads.gs"

       mv t2m_me.png      gefs_conus_t2m_${PDY}${cyc}.f${nfhrs}.png
       mv u10m_me.png     gefs_conus_u10m_${PDY}${cyc}.f${nfhrs}.png
       mv v10m_me.png     gefs_conus_v0m_${PDY}${cyc}.f${nfhrs}.png
       mv dpt2m_me.png    gefs_conus_dpt2m_${PDY}${cyc}.f${nfhrs}.png
       mv rh2m_me.png     gefs_conus_rh2m_${PDY}${cyc}.f${nfhrs}.png
       mv tmax2m_me.png   gefs_conus_tmax2m_${PDY}${cyc}.f${nfhrs}.png
       mv tmin2m_me.png   gefs_conus_tmin2m_${PDY}${cyc}.f${nfhrs}.png
       mv wind10m_me.png  gefs_conus_wind10m_${PDY}${cyc}.f${nfhrs}.png

    done
  done

# iday=`expr $iday + 1`
# CDATE=`$NDATE +24 $CDATE`

#done

#dir_main=/home/people/emc/www/htdocs/gmb/wx20cb/naefs_wcoss2  
dir_new=gefs_conus_$CDATE

ssh -l bocui emcrzdm "mkdir ${dir_main}/${dir_new}"
ssh -l bocui emcrzdm "cp ${dir_main}/al* ${dir_main}/${dir_new}"
ssh -l bocui emcrzdm "cp ${dir_main}/in* ${dir_main}/${dir_new}"
ssh -l bocui emcrzdm "echo $dir_new > ${dir_main}/dir_new.txt"
ssh -l bocui emcrzdm "cat ${dir_main}/dir_new.txt >> ${dir_main}/allow.cfg"
scp *.png      bocui@emcrzdm:${dir_main}/$dir_new

