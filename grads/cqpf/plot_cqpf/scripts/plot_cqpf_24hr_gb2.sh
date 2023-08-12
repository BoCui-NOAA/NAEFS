#set -x
nhours=/apps/ops/prod/nco/core/prod_util.v2.0.5/exec/ndate
export CDATE=$1
ndays=$2

#SHOME=/lfs/h2/emc/vpppg/save/$LOGNAME/cqpf

iday=1
while [ $iday -le $ndays ]; do

export CDATE=$CDATE;$SHOME/plot_cqpf/grads_daily/PLOT_QPF_gb2.sh $CDATE
export CDATE=$CDATE;$SHOME/plot_cqpf/grads_daily/PLOT_PQPF_gb2.sh $CDATE


  iday=`expr $iday + 1`
  CDATE=`$nhours +24 $CDATE` 
done
