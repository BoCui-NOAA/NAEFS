#set -x
date;pwd
stdate=$1
eddate=$2

#module load prod_util/2.0.13
#SHOME=/lfs/h2/emc/vpppg/save/$LOGNAME/cqpf

cd $SHOME/plot_cqpf/scripts

while [ $stdate -le $eddate ]; do

# comment 1deg hrap and 0.5d
# daily_1deg_CCPA.sh $stdate
  daily_hrap_CCPA.sh $stdate
  daily_0.5d_CCPA.sh $stdate
  daily_0.125d_CCPA_12z_12z.sh $stdate
  daily_0.125d_CCPA_00z_00z.sh $stdate

  stdate=`$NDATE +24 $stdate`
  echo "stdate=" $stdate 
done

cd $SHOME/data/daily_0.125d_ccpav4
$SHOME/xbin/gribmap -i ccpa_conus_0.125d_00z_all.ctl
$SHOME/xbin/gribmap -i ccpa_conus_0.125d_12z_all.ctl

echo "script run_ccpa.sh complete ! " 

exit
