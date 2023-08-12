#set -x
date;pwd
stdate=$1
eddate=$2

module load prod_util/2.0.5

cd /u/yan.luo/save/plot_cqpf/scripts

while [ $stdate -le $eddate ]; do

daily_1deg_CCPA.sh $stdate
daily_hrap_CCPA.sh $stdate
daily_0.5d_CCPA.sh $stdate
daily_0.125d_CCPA_12z_12z.sh $stdate
daily_0.125d_CCPA_00z_00z.sh $stdate

  stdate=`$NDATE +24 $stdate`

done

cd /lfs/h2/emc/vpppg/noscrub/yan.luo/daily_0.125d_ccpav4
gribmap -i ccpa_conus_0.125d_00z_all.ctl
gribmap -i ccpa_conus_0.125d_12z_all.ctl

exit
