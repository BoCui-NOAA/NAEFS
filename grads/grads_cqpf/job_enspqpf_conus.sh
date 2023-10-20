grib2ctl=/u/$LOGNAME/xbin/grib2ctl
g2ctl=/u/$LOGNAME/xbin/g2ctl
GXGIF=/u/$LOGNAME/xbin/gxgif

COM_v6=/lfs/h1/ops/prod/com/naefs/v6.1                        
#COM_v7=/lfs/h2/emc/ptmp/$LOGNAME/com/naefs/v7.0                        
COM_v7=/lfs/h1/ops/para/com/naefs/v7.0
homedir=/lfs/h2/emc/vpppg/noscrub/bo.cui/naefs.v7.0.0/grads

#CDATE=$1
CDATE=2023101600

export hourlist=" 000 003 006 009 012 015 018 021 024 027 030 033 036 039 042 045 048 \
                  051 054 057 060 063 066 069 072 075 078 081 084 087 090 093 096 099 \
                  102 105 108 111 114 117 120 123 126 129 132 135 138 141 144 147 150 \
                  153 156 159 162 165 168 171 174 177 180 183 186 189 192 198 204 \
                  210 216 222 228 234 240 246 252 258 264 270 276 282 288 294 300 \
                  306 312 318 324 330 336 342 348 354 360 366 372 378 384"

export memberlist="1 2 3 4 5 6 7 8 9 10 \
                   11 12 13 14 15 16 17 18 19 20 -0"

export hourlist="048 120 126 132 138 240 360 "
export hourlist="048 120 240 "
export hourlist="204"
export memberlist="pqpf"

export varlist="
APCP101600GTsfc
APCP12700GTsfc
APCP1270GTsfc
APCP152400GTsfc
APCP1e3GTsfc
APCP1e4GTsfc
APCP25400GTsfc
APCP2540GTsfc
APCP254GTsfc
APCP2e4GTsfc
APCP50800GTsfc
APCP5e3GTsfc
APCP6350GTsfc"

#export varlist="APCP12700GTsfc"

ndays=1 
iday=1

DATA=$homedir/grads_cqpf             
mkdir -p $DATA/tmpdir
cd $DATA/tmpdir
rm *
cp ../*gs .
cp ../*ctl .

# ndgd_prcp_gb2 only 24h pqpf

#while [ $iday -le $ndays ]; do
  export PDY=`echo $CDATE | cut -c1-8`
  export cyc=`echo $CDATE | cut -c9-10`
  export MMDD=`echo $CDATE | cut -c5-8`
  echo " day " $PDY$cyc

  for version in v7.0 v6.1; do
  for INTER in 06h 24h; do
  for nfhrs in $hourlist; do
  for mem in $memberlist; do 
    for var in $varlist; do

      case $version in
        v7.0)  COM=$COM_v7;;
        v6.1)  COM=$COM_v6;;
      esac

      rm $version.ctl
      infile=ge${mem}.t${cyc}z.ndgd2p5_conus.${INTER}f${nfhrs}.gb2
      cp $COM/gefs.$PDY/$cyc/ndgd_prcp_gb2/$infile ${infile}_$version
      sed -e "s/cyc/$cyc/" \
        -e "s/INTER/$INTER/" \
        -e "s/version/$version/" \
        -e "s/nfhrs/$nfhrs/" \
        control_enspqpf_ndgd.ctl >$version.ctl    
#     $g2ctl -verf $infile  > me.ctl
      /u/$LOGNAME/xbin/gribmap -i $version.ctl

      case $var in
        APCP101600GTsfc)  PRCP=101.6;;
        APCP12700GTsfc)   PRCP=12.7;;
        APCP1270GTsfc)    PRCP=1.27;;
        APCP152400GTsfc)  PRCP=152.4;;
        APCP1e3GTsfc)     PRCP=1;;
        APCP1e4GTsfc)     PRCP=10;;
        APCP25400GTsfc)   PRCP=25.4;;
        APCP2540GTsfc)    PRCP=2.54;;
        APCP254GTsfc)     PRCP=0.254;;
        APCP2e4GTsfc)     PRCP=20;;
        APCP50800GTsfc)   PRCP=50.8;;
        APCP5e3GTsfc)     PRCP=5;;
        APCP6350GTsfc)    PRCP=6.35;;
      esac

      rm grads.gs 
      sed -e "s/PDY/$PDY/" \
        -e "s/cyc/$cyc/" \
        -e "s/CDATE/$CDATE/" \
        -e "s/fhr/$nfhrs/" \
        -e "s/mem/$mem/" \
        -e "s/MMDD/$MMDD/" \
        -e "s/var/$var/" \
        -e "s/version/$version/" \
        -e "s/INTER/$INTER/" \
        -e "s/PRCP/$PRCP/" \
        enspqpf.gs  >grads.gs

       grads -bcl "grads.gs"

       mv enscqpf.png      enspqpf_${version}_${INTER}.${PRCP}mm.${PDY}${cyc}.f${nfhrs}.png
    done
  done
  done
  done
  done

# iday=`expr $iday + 1`
# CDATE=`$NDATE +24 $CDATE`

#done

dir_main=/home/people/emc/www/htdocs/gmb/wx20cb/naefs.v7.0.0  
dir_new=enspqpf_conus.$CDATE  

ssh -l bocui emcrzdm "mkdir ${dir_main}/${dir_new}"
ssh -l bocui emcrzdm "cp ${dir_main}/a* ${dir_main}/${dir_new}"
ssh -l bocui emcrzdm "cp ${dir_main}/i* ${dir_main}/${dir_new}"
ssh -l bocui emcrzdm "echo $dir_new > ${dir_main}/dir_new.txt"
ssh -l bocui emcrzdm "cat ${dir_main}/dir_new.txt >> ${dir_main}/allow.cfg"
scp *.png      bocui@emcrzdm:${dir_main}/$dir_new


exit

APCP101600GTsfc  0,1,0 a1,101.6   0,1,8,1 ** surface prob >101.6
APCP12700GTsfc  0,1,0 a1,12.7   0,1,8,1 ** surface prob >12.7
APCP1270GTsfc  0,1,0 a1,1.27   0,1,8,1 ** surface prob >1.27
APCP152400GTsfc  0,1,0 a1,152.4   0,1,8,1 ** surface prob >152.4
APCP1e3GTsfc  0,1,0 a1,1   0,1,8,1 ** surface prob >1
APCP1e4GTsfc  0,1,0 a1,10   0,1,8,1 ** surface prob >10
APCP25400GTsfc  0,1,0 a1,25.4   0,1,8,1 ** surface prob >25.4
APCP2540GTsfc  0,1,0 a1,2.54   0,1,8,1 ** surface prob >2.54
APCP254GTsfc  0,1,0 a1,0.254   0,1,8,1 ** surface prob >0.254
APCP2e4GTsfc  0,1,0 a1,20   0,1,8,1 ** surface prob >20
APCP50800GTsfc  0,1,0 a1,50.8   0,1,8,1 ** surface prob >50.8
APCP5e3GTsfc  0,1,0 a1,5   0,1,8,1 ** surface prob >5
APCP6350GTsfc  0,1,0 a1,6.35   0,1,8,1 ** surface prob >6.35

