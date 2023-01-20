#!/bin/bash
#BSUB -J jvrfy_rtma
#BSUB -o /gpfs/hps3/ptmp/Bo.Cui/output/jvrfy_rtma.%J
#BSUB -e /gpfs/hps3/ptmp/Bo.Cui/output/jvrfy_rtma.%J
#BSUB -cwd /gpfs/hps3/ptmp/Bo.Cui
#BSUB -P GEN-T2O
#BSUB -q dev
##BSUB -q debug
#BSUB -W 1:45
#BSUB -M 2000

# EXPORT list here

export IOBUF_PARAMS='*:sync,%stdout:sync'

set -xue

########################
# add the following part
########################

module load PrgEnv-intel/5.2.56
module use /gpfs/hps/nco/ops/nwprod/modulefiles
module load prod_util
module load grib_util/1.0.3
module load ecflow

###
### define the directory and utility
###

COMIN=$SHOME/naefs.v6.0.1

COMOUTJOB=$PTMP/Bo.Cui/output

###
### Define the time for each cycle and different days
###

PDY=`echo $CDATE | cut -c1-8`
cyc=`echo $CDATE | cut -c9-10`

CUE=transfer

#########################################
### 01 Submit job for  10% NAEFS CONUS
#########################################

job=$COMIN/run_crps_rtma/exrtma_crps.sh.sms

for cyc in 00 ; do

  echo "++++++ Submite the naefs conus job for 00z ++++++"

  export CDATE=$PDY$cyc    

  export runini=NO 

  export ENSIM
  export id
  export ireg

  export COMCLIM=$NGLOBAL/Bo.Cui/fix/fix_${ireg}_2p5
  export COM_RTMA=/gpfs/gd1/emc/ensemble/noscrub/Bo.Cui/com/rtma/prod

# if [ "$IF_NDGD" = "NO" -o "$IF_NDGD" = "NA" ]; then
#   export COM_DV=$NGLOBAL/Bo.Cui/com/gens/prod
#   export COM_FCST=$NGLOBAL/Bo.Cui/com/gens/wcoss
# else
#   export COM_NDGD=$NGLOBAL/Bo.Cui/com/gens/prod  
#   export COM_NDGD=$NGLOBAL2/Bo.Cui/naefs.v5.0.0/com/gens/prod  
#   export COM_NDGD=$NGLOBAL/Bo.Cui/com/gens/prod  
# fi

  export COM_OUT=$NGLOBAL/Bo.Cui/naefs.v6.0.1
# export COMOUT=$NGLOBAL/$LOGNAME/naefs.v6.0.1/com/gens/crps_ndgd2p5_conus                
  export COMOUT=/gpfs/hps3/emc/ensemble/noscrub/Bo.Cui/naefs.v6.0.0/com/gens/crps_ndgd2p5_conus
  export DATA=$PTMP/$LOGNAME/vrfy_ndgd/scores_${ireg}_${id}_${CDATE}_ini${runini}_$DSIM

  out=$COMOUTJOB/out_ndgd_${ireg}_${id}_${CDATE}_ini${runini}_$DSIM 

# /u/Bo.Cui/xbin/sub_wcoss -a GEN-MTN -q $CUE -p 1/1/S -r 512/1 -t 1:00 -j ens00 -o $out $job
  $job

done

if [ $? -ne 0 ]; then
  ecflow_client --abort
  exit
fi

#%include <tail.h>
#%manual
