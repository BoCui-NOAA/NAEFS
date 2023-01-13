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

export HOME=/sss/emc/ensemble/shared/Bo.Cui/Verification

export GDIR=/ptmpp1/Bo.Cui/plot_bias/prob_pub_ecmwf_temp
mkdir -p  $GDIR                   
cd    $GDIR                   
rm    $GDIR/*

nhoursx=/nwprod/util/exec/ndate
stymd=2014011600
edymd=2014021500
yyyymm=Win2014

export runini=NO 

export IFECMWF=NO 
export IFNCEP=YES 

export SCOREMEAN=$HOME/grads_crps_naefs/exnaefs_score_avg.sh  
export COMOUT=$NGLOBAL/Bo.Cui/com/gens/crps_ecmwf

################################
# Send Plots to emcrzdm Computer
################################

dir_main=/home/people/emc/www/htdocs/gmb/wx20cb/ECMWF

#dir_new=score_crps_ecmwf_$stymd.${edymd}_wrt_gefs_c00
#dir_new=score_crps_ecmwf_$stymd.${edymd}_wrt_ecmwf_gfs
dir_new=crps_bc_ecmwf_ecmwf50_wrt_gefs_c00

#cp  $HOME/grads_crps_naefs/SAMPLE_NAEFS.HTML  ECMWF_${yyyymm}.html

ssh -l bocui emcrzdm "mkdir ${dir_main}/${dir_new}"
scp *.html   bocui@emcrzdm:${dir_main}/$dir_new

################################

#for VFIELD in P1000HGT P500HGT P850TMP P2MTMP P10MUGRD P10MVGRD
#for VFIELD in  P2MTMP P10MUGRD P10MVGRD P850TMP PPRES PTMAX PTMIN PRH2M
#for VFIELD in P2MTMP P1000HGT P500HGT P850TMP P10MUGRD P10MVGRD
for VFIELD in P1000HGT P500HGT P850TMP P10MUGRD P10MVGRD
do

export VFIELD

#######################################
# NCEP ECMWF raw (ecmwf) and bc
#######################################

export DATAVRFY=$NGLOBAL/Bo.Cui/com/gens/crps_ecmwf

if [ "$IFECMWF" = "YES" ]; then
  export CENTER=wrt_ecmwf_gfs           
elif [ "$IFNCEP" = "YES" ]; then
  export CENTER=wrt_gefs_c00            
fi

#$SCOREMEAN $stymd $edymd ecmwf   
#$SCOREMEAN $stymd $edymd ecmwf_bc 

$SCOREMEAN $stymd $edymd ecmwfbc_dE 
$SCOREMEAN $stymd $edymd ecmwfbc50_dE 

#$SCOREMEAN $stymd $edymd gefs_bc    
#$SCOREMEAN $stymd $edymd cmce_bc    
#$SCOREMEAN $stymd $edymd NC40bc
#$SCOREMEAN $stymd $edymd naefs_bc    

############
# plot score
############

COMIN=/gpfs/gd1/emc/ensemble/save/Bo.Cui/ECMWF/grads_crps_naefs

#$COMIN/explot_naefs_scoreavg.sh $stymd $edymd $yyyymm  ecmwf ecmwf_bc  
$COMIN/explot_naefs_scoreavg.sh $stymd $edymd $yyyymm ecmwfbc_dE ecmwfbc50_dE

scp *.gif     bocui@emcrzdm:${dir_main}/$dir_new

done




