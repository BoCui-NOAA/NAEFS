#set -xS
if [ $# -lt 0 ]; then
    echo " Usage: $0 need "
    echo " For example: PLOT.sh"
    exit 8
fi

echo
echo " ######################################################## "
echo " ###   Start to average the probability scores        ### "
echo " ###   Please wait! wait! wait!!!!!!!                 ### "
echo " ######################################################## "
echo

direxp=naefs.v7.0.0

export PACKAGEROOT=/lfs/h2/emc/vpppg/noscrub/$LOGNAME
export HOMEcrps=$PACKAGEROOT/$direxp/verification
export EXECcrps=$HOMEcrps/exec
export PLOTcrps=$HOMEcrps/grads

export COMROOT=/lfs/h2/emc/vpppg/noscrub/$LOGNAME/com
export COMOUT=$COMROOT/stat/crps_ndgd               

export SCOREMEAN=$PLOTcrps/grads_crps_ndgd/exrtma_score_avg.sh  
export SCOREPLOT=$PLOTcrps/grads_crps_ndgd/explot_rtma_scoreavg.sh 

export DATAROOT=/lfs/h2/emc/ptmp/$LOGNAME/tmpnwprd

reglist="conus alaska"
reglist="alaska"
reglist="conus"

stymd=2023010700
edymd=2023063000
yyyymm=Spring2023

export runini=NO

export INTERHR=24h

# rtma has no RH

FIELDLIST="P2MTMP P10MUGRD P10MVGRD P2MDPT P10MWDIR P10MWIND P2MRH PTMAX PTMIN"
FIELDLIST="P2MTMP P10MUGRD P10MVGRD P2MDPT P10MWDIR P10MWIND PTMAX PTMIN"
FIELDLIST="P10MUGRD P10MVGRD P10MWDIR P10MWIND"
FIELDLIST="P2MTMP"
FIELDLIST="PTMAX PTMIN"
FIELDLIST="PTMIN"

for ireg in $reglist; do

case $ireg in
  conus)  regs=5;;
  alaska) regs=6;;
esac

export regs

export DATA=$DATAROOT/plot_crps_ndgd_$ireg  

mkdir -p $DATA                   
cd    $DATA                   
rm    $DATA/*

for VFIELD in $FIELDLIST; do

case $VFIELD in
  PTMAX) runini=YES;;
  PTMIN) runini=YES;;
esac

export VFIELD

#########################
# NAEFS CONUS prod (40nb) 
#########################

for naefs_ver in v6.1 v7.0; do
  for id in gefs naefs; do
    export ireg
    export naefs_ver
    export id
    export COM_IN=$COMROOT/stat/naefs.$naefs_ver
    export COMIN=$COM_IN/crps_${id}_ndgd  
    $SCOREMEAN $stymd $edymd $id $ireg $naefs_ver 
  done
done

############
# plot score
############

export ireg
$SCOREPLOT $stymd $edymd $yyyymm gefs.$ireg.v6.1 naefs.$ireg.v6.1 gefs.$ireg.v7.0 naefs.$ireg.v7.0  

done
#############################
# Send Plots to emcrzdm Computer
#############################

naefs_ver=v7.0.0

dir_main=/home/people/emc/www/htdocs/gmb/wx20cb/naefs.${naefs_ver}
dir_new=crps_4line_ndgd_$stymd.${edymd}_${INTERHR}_$ireg

ssh -l bocui emcrzdm "mkdir ${dir_main}/${dir_new}"
ssh -l bocui emcrzdm "cp ${dir_main}/al* ${dir_main}/${dir_new}"
ssh -l bocui emcrzdm "cp ${dir_main}/in* ${dir_main}/${dir_new}"
ssh -l bocui emcrzdm "echo $dir_new > ${dir_main}/dir_new.txt"
ssh -l bocui emcrzdm "cat ${dir_main}/dir_new.txt >> ${dir_main}/allow.cfg"

scp $PLOTcrps/grads_crps_ndgd/Blist.html_$ireg     bocui@emcrzdm:${dir_main}/$dir_new/Blist.html
rm *crpsc*png
scp *.png      bocui@emcrzdm:${dir_main}/$dir_new

done
