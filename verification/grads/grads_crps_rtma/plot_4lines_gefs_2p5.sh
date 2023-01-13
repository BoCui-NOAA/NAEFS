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

#export HOME=$SHOME/naefs.v6.0.1
export HOME=/gpfs/hps3/emc/ensemble/save/Bo.Cui/naefs.v6.0.1

export GDIR=$PTMP/Bo.Cui/plot_bias/prob_nuopc_rtma_test
mkdir -p  $GDIR                   
cd    $GDIR                   
rm    $GDIR/*

stymd=2017060100
edymd=2017073100
yyyymm=Spr2017

export runini=YES

export SCOREMEAN=$HOME/grads_crps_rtma/exrtma_score_avg.sh  
export COMOUT=$NGLOBAL/Bo.Cui/naefs.v6.0.1/com/gens/crps_ndgd2p5_conus    

#for VFIELD in P2MTMP P10MUGRD P10MVGRD P2MDPT P10MWDIR P10MWIND P2MRH PTMAX PTMIN
for VFIELD in P2MTMP 
do

case $VFIELD in
  PTMAX) runini=YES;;
  PTMIN) runini=YES;;
esac

export VFIELD

#########################
# NAEFS CONUS prod (40nb) 
#########################

export DATAVRFY=/gpfs/hps3/emc/ensemble/noscrub/Bo.Cui/naefs.v6.0.0/com/gens

export CENTER=crps_ndgd2p5_conus              

#$SCOREMEAN $stymd $edymd gefs_raw2p5         conus    
#$SCOREMEAN $stymd $edymd gefs_bc2p5          conus    
#$SCOREMEAN $stymd $edymd gefs_p5raw2p5       conus    

$SCOREMEAN $stymd $edymd gefs_bcds          conus    
$SCOREMEAN $stymd $edymd naefs_bcds          conus    
#$SCOREMEAN $stymd $edymd gefs_p5bcds          conus    
#$SCOREMEAN $stymd $edymd naefs_p5bcds          conus    

############
# plot score
############

#$HOME/grads_crps_rtma/explot_rtma_scoreavg.sh $stymd $edymd $yyyymm gefs_raw2p5 gefs_bc2p5 gefs_p5raw2p5
#$HOME/grads_crps_rtma/explot_rtma_scoreavg.sh $stymd $edymd $yyyymm gefs_bcds gefs_p5bcds naefs_p5bcds
$HOME/grads_crps_rtma/explot_rtma_scoreavg.sh $stymd $edymd $yyyymm gefs_bcds naefs_bcds

done

#############################
# Send Plots to emcrzdm Computer
#############################

#sed -e "s/MD1/NCEP/" \
#    -e "s/MD2/FNO/" \
#    -e "s/SDIR/FNMOCb_NCEPb/" \
#    -e "s/SEASON/${yyyymm}/" \
#    $HOME/naefs/grads_pub/SAMPLE_fno.HTML >FNMOCb_NCEPb_${yyyymm}.html

dir_main=/home/people/emc/www/htdocs/gmb/wx20cb/naefs.v6.0.0 

#dir_new=crps_4lines_dev_$stymd.$etymd
dir_new=crps_2lines_dev_$stymd.$etymd

ssh -l bocui emcrzdm "mkdir -p ${dir_main}/${dir_new}"
scp *.gif      bocui@emcrzdm:${dir_main}/$dir_new
# scp FNMOC_NCEP_${yyyymm}.html      bocui@emcrzdm:${dir_main}/$dir_new


