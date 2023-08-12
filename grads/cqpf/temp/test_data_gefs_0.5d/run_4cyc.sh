#set -x

stdate=$1
eddate=$2
CYCLE=$3
module load prod_util
#NDATE=/apps/ops/prod/nco/core/prod_util.v2.0.5/exec/ndate

while [ $stdate -le $eddate ]; do

export PDY=`echo $stdate | cut -c1-8`

#workdir=/u/yan.luo/save/naefs.v6.0.1/ecf
workdir=$SHOME/$LOGNAME/naefs.v6.0.1/ecf
cd $workdir

   export cyc=$CYCLE

   $workdir/JARCH_GEFS_PRCP_pgrb2ap5.ecf
   $workdir/JNAEFS_GEFS_6HR_PQPF.ecf
   $workdir/JNAEFS_GEFS_24HR_QPF.ecf

  echo "CQPF: Extracting precip data from pgrb2ap5 files for $stdate is done."

  stdate=`$NDATE +24 $stdate`

done

