#!/bin/bash

export direxp=naefs.v7.0.0
export RUN_ENVIR=nco

#export PDY=20230102
#export cyc=00               
export PDY=YYMMDD  
export cyc=CYC              

export PACKAGEROOT=/lfs/h2/emc/vpppg/noscrub/$LOGNAME 
export HOMEcrps=$PACKAGEROOT/$direxp/verification
export FIXcrps=$PACKAGEROOT/$direxp/fix
export EXECcrps=$HOMEcrps/exec                                     

export COMROOT=/lfs/h2/emc/vpppg/noscrub/$LOGNAME/com
export DATAROOT=/lfs/h2/emc/ptmp/$LOGNAME/tmpnwprd

export APRUN="mpiexec -np 97 --cpu-bind verbose,core cfp "
export IOBUF_PARAMS='*:sync,%%stdout:sync'

export KEEPDATA=NO 
#export INTERACTIVE=YES

for px in conus_ext_2p5 alaska_3p0; do

export px

# 1. naefs v7.0 gefs ndgd

export model=naefs
export model_ver=v7.0
export package=gefs  
#export px=conus_ext_2p5
export outlist="geavg gespr"

$HOMEcrps/scripts/excnvgrib_gefs_naefs_ndgd.sh

# 2. naefs v7.0 naefs ndgd

export model=naefs
export model_ver=v7.0
export package=naefs 
#export px=conus_ext_2p5
export outlist="geavg gespr"

$HOMEcrps/scripts/excnvgrib_gefs_naefs_ndgd.sh

# 3. naefs v6.1 gefs ndgd

export model=naefs
export model_ver=v6.1
export package=gefs  
#export px=conus_ext_2p5
export outlist="geavg gespr"

$HOMEcrps/scripts/excnvgrib_gefs_naefs_ndgd.sh

# 4. naefs v6.1 naefs ndgd

export model=naefs
export model_ver=v6.1
export package=naefs 
#export px=conus_ext_2p5
export outlist="geavg gespr"

$HOMEcrps/scripts/excnvgrib_gefs_naefs_ndgd.sh

done

$HOMEcrps/scripts/excnvgrib_rtma.sh




