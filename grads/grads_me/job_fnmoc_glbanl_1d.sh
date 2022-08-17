grib2ctl=/u/$LOGNAME/xbin/grib2ctl
g2ctl=/u/$LOGNAME/xbin/g2ctl
GXGIF=/u/$LOGNAME/xbin/gxgif
#NDATE=/nwprod/util/exec/ndate
WGRIB=/nwprod/util/exec/wgrib

#COM1=/lfs/h2/emc/ptmp/$LOGNAME/com/naefs/v7.0                               

#CDATE=2020042800

export hourlist="00"
export memberlist="avg"

ndays=1 
iday=1

DATA=$homedir/grads_me
mkdir -p $DATA/tmpdir
cd $DATA/tmpdir
rm *
cp $DATA/*gs .

#while [ $iday -le $ndays ]; do
  export PDY=`echo $CDATE | cut -c1-8`
  export PDYm1=`$NDATE -24 $CDATE | cut -c1-8`
  export PDYm2=`$NDATE -48 $CDATE | cut -c1-8`
  export cyc=`echo $CDATE | cut -c9-10`
  export MMDD=`echo $CDATE | cut -c5-8`
  echo " day " $PDY$cyc

  for nfhrs in $hourlist; do
    for mem in $memberlist; do 
      rm *.gr *ctl

      infile=fnmoc_glbanl.t${cyc}z.pgrb2a_mdf${nfhrs}      
      cp $COM1/fens.$PDYm2/$cyc/pgrb2a/$infile .
      $g2ctl -verf $infile  > me.ctl
      /u/$LOGNAME/xbin/gribmap -i me.ctl

      rm grads.gs
      sed -e "s/PDY/$PDY/" \
        -e "s/cyc/$cyc/" \
        -e "s/CDATE/$CDATE/" \
        -e "s/fhr/$nfhrs/" \
        -e "s/mem/$mem/" \
        -e "s/MMDD/$MMDD/" \
        fnmoc_glbanl.gs  >grads.gs
       grads -bcl "grads.gs"

       mv t2m_me.png      fnmoc_glbanl_t2m_${PDY}${cyc}.f${nfhrs}.png
       mv z500_me.png     fnmoc_glbanl_z500_${PDY}${cyc}.f${nfhrs}.png
       mv z250_me.png     fnmoc_glbanl_z250_${PDY}${cyc}.f${nfhrs}.png
       mv t850_me.png     fnmoc_glbanl_t850_${PDY}${cyc}.f${nfhrs}.png
       mv u10m_me.png     fnmoc_glbanl_u10m_${PDY}${cyc}.f${nfhrs}.png
       mv v10m_me.png     fnmoc_glbanl_v10m_${PDY}${cyc}.f${nfhrs}.png

      rm *.gr *ctl

      infile=ncepfnmoc_glbanl.t${cyc}z.pgrb2a_mdf${nfhrs}      
      cp $COM1/gefs.$PDYm1/$cyc/pgrb2a/$infile .
      $g2ctl -verf $infile  > me.ctl
      /u/$LOGNAME/xbin/gribmap -i me.ctl

      rm grads.gs
      sed -e "s/PDY/$PDY/" \
        -e "s/cyc/$cyc/" \
        -e "s/CDATE/$CDATE/" \
        -e "s/fhr/$nfhrs/" \
        -e "s/mem/$mem/" \
        -e "s/MMDD/$MMDD/" \
        ncepfnmoc_glbanl.gs  >grads.gs
       grads -bcl "grads.gs"

       mv t2m_me.png      ncepfnmoc_glbanl_t2m_${PDY}${cyc}.f${nfhrs}.png
       mv z500_me.png     ncepfnmoc_glbanl_z500_${PDY}${cyc}.f${nfhrs}.png
       mv z250_me.png     ncepfnmoc_glbanl_z250_${PDY}${cyc}.f${nfhrs}.png
       mv t850_me.png     ncepfnmoc_glbanl_t850_${PDY}${cyc}.f${nfhrs}.png
       mv u10m_me.png     ncepfnmoc_glbanl_u10m_${PDY}${cyc}.f${nfhrs}.png
       mv v10m_me.png     ncepfnmoc_glbanl_v10m_${PDY}${cyc}.f${nfhrs}.png

    done
  done

  iday=`expr $iday + 1`
# CDATE=`$NDATE +24 $CDATE`

#done

dir_main=/home/people/emc/www/htdocs/gmb/wx20cb/naefs.v7.0.0        
dir_new=fnmoc_me_1d.$CDATE        

ssh -l bocui emcrzdm "mkdir ${dir_main}/${dir_new}"
ssh -l bocui emcrzdm "cp ${dir_main}/a* ${dir_main}/${dir_new}"
ssh -l bocui emcrzdm "cp ${dir_main}/i* ${dir_main}/${dir_new}"
ssh -l bocui emcrzdm "echo $dir_new > ${dir_main}/dir_new.txt"
ssh -l bocui emcrzdm "cat ${dir_main}/dir_new.txt >> ${dir_main}/allow.cfg"
scp *.png      bocui@emcrzdm:${dir_main}/$dir_new

