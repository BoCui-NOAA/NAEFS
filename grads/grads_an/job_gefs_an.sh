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

export memberlist="p01 p02 p03 p04 p05 p06 p07 p08 p09 p10 \
                   p11 p12 p13 p14 p15 p16 p17 p18 p19 p20 \
                   p21 p22 p23 p24 p25 p26 p27 p28 p29 p30 \
                   gfs c00"


export hourlist="048 120 126 132 138 240 360 "
export hourlist="048 "
export memberlist="p01 p21 avg"

ndays=1 
iday=1

DATA=$homedir/grads_an               
mkdir -p $DATA/tmpdir
cd $DATA/tmpdir
rm *
cp ../*gs .

#while [ $iday -le $ndays ]; do
  export PDY=`echo $CDATE | cut -c1-8`
  export cyc=`echo $CDATE | cut -c9-10`
  export MMDD=`echo $CDATE | cut -c5-8`
  echo " day " $PDY$cyc

  for nfhrs in $hourlist; do

    for mem in $memberlist; do 
#     rm  *ctl grads.gs

      infile=ge${mem}.t${cyc}z.pgrb2a.0p50_anf${nfhrs}
      cp $COM1/gefs.$PDY/$cyc/pgrb2ap5_an/$infile .
      $g2ctl -verf $infile  > me.ctl
      /u/$LOGNAME/xbin/gribmap -i me.ctl

      rm grads.gs
      sed -e "s/CDATE/$CDATE/" \
        -e "s/fhr/$nfhrs/" \
        -e "s/MEM/$mem/" \
        anomaly.gs  >grads.gs
       grads -bcl "grads.gs"

       mv t2m.png   gefs_an_t2m_${PDY}${cyc}.f${nfhrs}_${mem}.png
    done

      rm me.ctl grads.gs
      infile=geavg.t${cyc}z.pgrb2a.0p50_anvf${nfhrs}
      cp $COM1/gefs.$PDY/$cyc/pgrb2ap5_an/$infile .
      $g2ctl -verf $infile  > me.ctl
      /u/$LOGNAME/xbin/gribmap -i me.ctl

      sed -e "s/CDATE/$CDATE/" \
        -e "s/fhr/$nfhrs/" \
        -e "s/MEM/$mem/" \
        anomaly_anv.gs  >grads.gs
       grads -bcl "grads.gs"

       mv t2m.png   gefs_anv_t2m_${PDY}${cyc}.f${nfhrs}_avg.png

      rm me.ctl grads.gs
      infile=geefi.t${cyc}z.pgrb2a.0p50_bcf${nfhrs}
      cp $COM1/gefs.$PDY/$cyc/pgrb2ap5_an/$infile .
      $g2ctl -verf $infile  > me.ctl
      /u/$LOGNAME/xbin/gribmap -i me.ctl

      sed -e "s/CDATE/$CDATE/" \
        -e "s/fhr/$nfhrs/" \
        -e "s/MEM/$mem/" \
        efi.gs  >grads.gs
       grads -bcl "grads.gs"

       mv t2m.png   gefs_efi_t2m_${PDY}${cyc}.f${nfhrs}.png

  done

# iday=`expr $iday + 1`
# CDATE=`$NDATE +24 $CDATE`

#done

#dir_main=/home/people/emc/www/htdocs/gmb/wx20cb/naefs_wcoss2  
dir_new=gefs_an_$CDATE  

ssh -l bocui emcrzdm "mkdir ${dir_main}/${dir_new}"
ssh -l bocui emcrzdm "cp ${dir_main}/al* ${dir_main}/${dir_new}"
ssh -l bocui emcrzdm "cp ${dir_main}/in* ${dir_main}/${dir_new}"
ssh -l bocui emcrzdm "echo $dir_new > ${dir_main}/dir_new.txt"
ssh -l bocui emcrzdm "cat ${dir_main}/dir_new.txt >> ${dir_main}/allow.cfg"
scp *.png      bocui@emcrzdm:${dir_main}/$dir_new

