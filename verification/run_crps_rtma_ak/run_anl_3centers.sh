#!/bin/bash
#BSUB -J jvrfy_rtma
#BSUB -o /gpfs/hps/ptmp/Bo.Cui/output/jvrfy_rtma.%J
#BSUB -e /gpfs/hps/ptmp/Bo.Cui/output/jvrfy_rtma.%J
#BSUB -cwd /gpfs/hps/ptmp/Bo.Cui
#BSUB -P GEN-T2O
#BSUB -q dev
##BSUB -q debug
#BSUB -W 0:50
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
### 01 Submit job for  10% NAEFS ALASKA
#########################################

job=$COMIN/run_crps_rtma_ak/exrtma_crps.sh.sms

for cyc in 00 ; do

  echo "++++++ Submite the naefs alaska job for 00z ++++++"

  export CDATE=$PDY$cyc    

  export runini=NO 

  export ENSIM
  export id
  export ireg

  export COMCLIM=$NGLOBAL/Bo.Cui/fix/fix_${ireg}_3p0
  export COM_RTMA=/gpfs/gd1/emc/ensemble/noscrub/Bo.Cui/com/rtma/prod

  export COM_OUT=$NGLOBAL/Bo.Cui/naefs.v6.0.1
  export COMOUT=/gpfs/hps/emc/ensemble/noscrub/Bo.Cui/naefs.v6.0.0/com/gens/crps_ndgd3p0_ak
  export DATA=$PTMP/$LOGNAME/vrfy_ndgd/scores_${ireg}_${id}_${CDATE}_ini${runini}_$DSIM

  out=$COMOUTJOB/out_ndgd_${ireg}_${id}_${CDATE}_ini${runini}_$DSIM 

  $job

done

if [ $? -ne 0 ]; then
  ecflow_client --abort
  exit
fi

#%include <tail.h>
#%manual
