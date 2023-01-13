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

export DATAROOT=/lfs/h2/emc/ptmp/$LOGNAME/tmpnwprd

export COMROOT=/lfs/h2/emc/vpppg/noscrub/$LOGNAME/com
export COMOUT=$COMROOT/stat/crps_naefs              

export SCOREMEAN=$PLOTcrps/grads_crps_naefs/exnaefs_score_avg.sh  
export SCOREPLOT=$PLOTcrps/grads_crps_naefs/explot_naefs_scoreavg.sh

export DATA=$DATAROOT/plot_crps_naefs
mkdir -p  $DATA                   
cd    $DATA                   
rm    $DATA/*gr $DATA/*gif

stymd=2022120600
edymd=2023010400
yyyymm=Winter2022

export runini=NO 

#export IFECMWF=NO 
#export IFNCEP=YES

################################

varlist="P2MTMP P1000HGT P500HGT P850TMP P10MUGRD P10MVGRD PPRES PTMAX PTMIN PRH2M PTCDC PDPT2M"
varlist="P2MTMP P1000HGT P500HGT P850TMP P10MUGRD P10MVGRD"
varlist="P2MTMP"

for VFIELD in $varlist; do

export VFIELD

#######################################
# NCEP ECMWF raw (ecmwf) and bc
#######################################

naefs_ver=v6.1

for ENSIM in gefs_bcp5 naefs_bcp5; do
  export COM_IN=$COMROOT/stat/naefs.$naefs_ver
  export COMIN=$COM_IN/crps_$ENSIM
  $SCOREMEAN $stymd $edymd $ENSIM naefs.$naefs_ver
done


naefs_ver=v7.0

for ENSIM in gefs_bcp5 naefs_bcp5; do
  export COM_IN=$COMROOT/stat/naefs.$naefs_ver
  export COMIN=$COM_IN/crps_$ENSIM
  $SCOREMEAN $stymd $edymd $ENSIM naefs.$naefs_ver
done


############
# plot score
############

export INTERHR=24h

$SCOREPLOT $stymd $edymd $yyyymm \
           gefs_bcp5.naefs.v6.1 naefs_bcp5.naefs.v6.1 \
           gefs_bcp5.naefs.v7.0 naefs_bcp5.naefs.v7.0

done

################################
# Send Plots to emcrzdm Computer
################################

naefs_ver=v7.0.0

dir_main=/home/people/emc/www/htdocs/gmb/wx20cb/naefs.${naefs_ver}
dir_new=crps_4line_naefs_$stymd.${edymd}_${INTERHR}

#cp  $HOMEcrps/grads_crps_naefs/SAMPLE_NAEFS.HTML  ECMWF_${yyyymm}.html

ssh -l bocui emcrzdm "mkdir ${dir_main}/${dir_new}"
ssh -l bocui emcrzdm "cp ${dir_main}/al* ${dir_main}/${dir_new}"
ssh -l bocui emcrzdm "cp ${dir_main}/in* ${dir_main}/${dir_new}"
ssh -l bocui emcrzdm "echo $dir_new > ${dir_main}/dir_new.txt"
ssh -l bocui emcrzdm "cat ${dir_main}/dir_new.txt >> ${dir_main}/allow.cfg"
scp *.png      bocui@emcrzdm:${dir_main}/$dir_new
scp *.gif      bocui@emcrzdm:${dir_main}/$dir_new

#scp *.html   bocui@emcrzdm:${dir_main}/$dir_new
#scp *.gif     bocui@emcrzdm:${dir_main}/$dir_new

