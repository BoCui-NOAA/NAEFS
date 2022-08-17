grib2ctl=/u/Bo.Cui/xbin/grib2ctl
g2ctl=/u/Bo.Cui/xbin/g2ctl
GXGIF=/u/Bo.Cui/xbin/gxgif
#NDATE=/nwprod/util/exec/ndate
WGRIB=/nwprod/util/exec/wgrib

COM1=/gpfs/hps3/ptmp/Bo.Cui/com/naefs/dev                                 

CDATE=2020051100

export hourlist=" 000 003 006 009 012 015 018 021 024 027 030 033 036 039 042 045 048 \
                  051 054 057 060 063 066 069 072 075 078 081 084 087 090 093 096 099 \
                  102 105 108 111 114 117 120 123 126 129 132 135 138 141 144 147 150 \
                  153 156 159 162 165 168 171 174 177 180 183 186 189 192 198 204 \
                  210 216 222 228 234 240 246 252 258 264 270 276 282 288 294 300 \
                  306 312 318 324 330 336 342 348 354 360 366 372 378 384"

export memberlist="1 2 3 4 5 6 7 8 9 10 \
                   11 12 13 14 15 16 17 18 19 20 -0"

export hourlist="048 "
export hourlist="120 126 132 138 240 360 "
export hourlist="048 "
export memberlist="avg"

ndays=4 
iday=1

DATA=/gpfs/dell2/emc/retros/noscrub/Bo.Cui/naefs/grads_bc     
mkdir -p $DATA/tmpdir
cd $DATA/tmpdir
rm *
cp $DATA/*gs .

while [ $iday -le $ndays ]; do
  export PDY=`echo $CDATE | cut -c1-8`
  export cyc=`echo $CDATE | cut -c9-10`
  export MMDD=`echo $CDATE | cut -c5-8`
  echo " day " $PDY$cyc

  for nfhrs in $hourlist; do
    for mem in $memberlist; do 
      rm *.gr *ctl

      infile=ge${mem}.t${cyc}z.pgrb2a.0p50_mecomf${nfhrs}
      cp $COM1/gefs.$PDY/$cyc/pgrb2ap5/$infile .
      $g2ctl -verf $infile  > me.ctl
      /u/Bo.Cui/xbin/gribmap -i me.ctl

      rm grads.gs
      sed -e "s/PDY/$PDY/" \
        -e "s/cyc/$cyc/" \
        -e "s/CDATE/$CDATE/" \
        -e "s/fhr/$nfhrs/" \
        -e "s/mem/$mem/" \
        -e "s/MMDD/$MMDD/" \
        gefs_mecom.gs  >grads.gs
       grads -bcl "grads.gs"

       mv t2m_me.png      gefs_mecom_t2m_${PDY}${cyc}.f${nfhrs}.png
       mv z500_me.png     gefs_mecom_z500_${PDY}${cyc}.f${nfhrs}.png
       mv z250_me.png     gefs_mecom_z250_${PDY}${cyc}.f${nfhrs}.png
       mv t850_me.png     gefs_mecom_t850_${PDY}${cyc}.f${nfhrs}.png
       mv u10m_me.png     gefs_mecom_u10m_${PDY}${cyc}.f${nfhrs}.png
       mv v10m_me.png     gefs_mecom_v10m_${PDY}${cyc}.f${nfhrs}.png

    done
  done

  iday=`expr $iday + 1`
  CDATE=`$NDATE +24 $CDATE`

done

dir_main=/home/people/emc/www/htdocs/gmb/wx20cb/refcst_gefsv12
dir_new=sample_gefs_v12        

ssh -l bocui emcrzdm "mkdir ${dir_main}/${dir_new}"
scp *.png      bocui@emcrzdm:${dir_main}/$dir_new
