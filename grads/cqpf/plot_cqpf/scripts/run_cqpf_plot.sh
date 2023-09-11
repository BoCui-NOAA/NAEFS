set +x

module load prod_util/2.0.13
module load grib_util/1.2.3

#export CDATE=2023071000

export PACKAGEROOT=/lfs/h2/emc/vpppg/noscrub/$LOGNAME
export COMROOT=/lfs/h2/emc/ptmp/$LOGNAME/com
#export DATAROOT=/lfs/h2/emc/ptmp/$LOGNAME
export DATAROOT=/lfs/h2/emc/ptmp/$LOGNAME/plot_cqpf

export SHOME=$PACKAGEROOT/naefs.v7.0.0/grads/cqpf

# naefs data
#export naefs_ver=v6.1
#export datdir2=/lfs/h1/ops/prod/com/naefs/v6.1
#export datdir3=/lfs/h1/ops/prod/com/naefs/v6.1

export datdir1=/lfs/h2/emc/vpppg/noscrub/$LOGNAME/ncep_gefs_0.5d

# ccpa data
export COMIN=/lfs/h1/ops/prod/com/ccpa/v4.2
export COMINobs=$SHOME/data/daily_hrap_ccpav4   
export COMOUT=$SHOME/data/daily_0.125d_ccpav4
export COM_TAR=/lfs/h2/emc/vpppg/noscrub/$LOGNAME/COM_TAR 

# emcrzdm data
export dir_main=/home/people/emc/www/htdocs/gmb/wx20cb/naefs.v7.0.0              

# ccpa:tempdir=/lfs/h2/emc/ptmp/$LOGNAME/daily_ccpa_12z_ccpav4
export exec_dir=/lfs/h1/ops/para/packages/ccpa.v4.2.0/exec

export hourlist="006 012 018 024 030 036 042 048 054 060 066 072 078 084 090 096 \
              102 108 114 120 126 132 138 144 150 156 162 168 174 180 186 192\
              198 204 210 216 222 228 234 240"

export hourlist_idx="    06  12  18  24  30  36  42  48  54  60  66  72  78  84  90  96 \
              102 108 114 120 126 132 138 144 150 156 162 168 174 180 186 192\
              198 204 210 216 222 228 234 240"

export hourlist_24="36 60 84 108 132 156 180 204 228 252 276 300 324 348 372 "

#export hourlist="018 024 036"
#export hourlist_idx="06  12   24   36"
#export hourlist_24="36 60"

#NDATE=/apps/ops/prod/nco/core/prod_util.v2.0.5/exec/ndate

#Date=`date +%y%m%d`
#export CDATE=20$Date\00

export CDATEm24=`$NDATE -24 $CDATE`
export CDATEm48=`$NDATE -48 $CDATE`
export CDATEm72=`$NDATE -72 $CDATE`
export CDATEm96=`$NDATE -96 $CDATE`
export CDATEm120=`$NDATE -120 $CDATE`
export CDATEm144=`$NDATE -144 $CDATE`
export CDATEm240=`$NDATE -240 $CDATE`

#---------------------------------------
eval primary=`cat  /lfs/h1/ops/prod/config/prodmachinefile | grep primary`
eval backup=`cat  /lfs/h1/ops/prod/config/prodmachinefile | grep backup`

echo $primary "and " $backup

isdogwood=primary:dogwood

#if [  $primary != $isdogwood ]; then
   echo  " Check plotting jobs on dogwood!"
#else
echo " cactus is the production machine! "
echo " Send web plots through cactus "

echo "++++++ Submite the cqpf plotting job ++++++"

cd $SHOME/plot_cqpf/scripts

./run_ccpa.sh $CDATEm120 $CDATE
echo " Job run_ccpa.sh complete "

./plot_cqpf_6hr_gb2.sh $CDATEm96 5
#./plot_cqpf_6hr_gb2.sh $CDATE 1
echo " Job plot_cqpf_6hr_gb2.sh complete "

./plot_cqpf_24hr_gb2.sh $CDATEm96 5
#./plot_cqpf_24hr_gb2.sh $CDATE 1
echo " Job plot_cqpf_24hr_gb2.sh complete "

#fi

exit