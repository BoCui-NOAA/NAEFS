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

export GDIR=/ptmp/Bo.Cui/plot_bias/prob_pub_ecmwf_temp
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

#dir_new=crps_bc_gefs_cmce_ecmwf_naefs
dir_new=crps_bc_NCE60_wrt_gefs_c00

#cp  $HOME/grads_crps_naefs/SAMPLE_NAEFS.HTML  ECMWF_${yyyymm}.html

ssh -l bocui emcrzdm "mkdir ${dir_main}/${dir_new}"
scp *.html   bocui@emcrzdm:${dir_main}/$dir_new

################################

#for VFIELD in P1000HGT P500HGT P850TMP P2MTMP P10MUGRD P10MVGRD
#for VFIELD in  P2MTMP P10MUGRD P10MVGRD P850TMP PPRES PTMAX PTMIN PRH2M
for VFIELD in P2MTMP P1000HGT P500HGT P850TMP P10MUGRD P10MVGRD
#for VFIELD in P2MTMP
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


$SCOREMEAN $stymd $edymd NCE60bc_nCnE
$SCOREMEAN $stymd $edymd NCE60bc_dCnE
$SCOREMEAN $stymd $edymd NCE60bc_nCdE
$SCOREMEAN $stymd $edymd NCE60bc

############
# plot score
############

COMIN=/gpfs/gd1/emc/ensemble/save/Bo.Cui/ECMWF/grads_crps_naefs

#$COMIN/explot_naefs_scoreavg.sh $stymd $edymd $yyyymm  gefs_bc cmce_bc NC40bc naefs_bc
#$COMIN/explot_naefs_scoreavg.sh $stymd $edymd $yyyymm  gefs_bc ecmwf_bc NCE60bc naefs_bc
$COMIN/explot_naefs_scoreavg.sh $stymd $edymd $yyyymm  NCE60bc_nCnE NCE60bc_dCnE NCE60bc_nCdE NCE60bc

scp *.gif     bocui@emcrzdm:${dir_main}/$dir_new

done

