#!/bin/bash

export direxp=naefs.v7.0.0
export RUN_ENVIR=nco

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

# 1. naefs v7.0 gefs bcp5

export model=naefs
export model_ver=v7.0
export package=gefs  
export px=_bc
export outlist="geavg gespr"

$HOMEcrps/scripts/excnvgrib_gefs_bcp5.sh

# 2. naefs v7.0 naefs bcp5

export model=naefs
export model_ver=v7.0
export package=naefs 
export px=_bc
export outlist="naefs_geavg naefs_gespr"

$HOMEcrps/scripts/excnvgrib_gefs_bcp5.sh

# 3. naefs v6.1 gefs bcp5

export model=naefs
export model_ver=v6.1
export package=gefs  
export px=_bc
export outlist="geavg gespr"

$HOMEcrps/scripts/excnvgrib_gefs_bcp5.sh

# 4. naefs v6.1 naefs bcp5

export model=naefs
export model_ver=v6.1
export package=naefs 
export px=_bc
export outlist="naefs_geavg naefs_gespr"

$HOMEcrps/scripts/excnvgrib_gefs_bcp5.sh

# 5. gefs v12.3 raw pgrb2ap5

export model=gefs  
export model_ver=v12.3
export package=gefs  
export px=
export outlist="gegfs gec00 geavg gespr"

$HOMEcrps/scripts/excnvgrib_gefs_bcp5.sh





