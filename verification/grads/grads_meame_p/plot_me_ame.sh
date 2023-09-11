
#SDY=2007090100 
#EDY=2007093000

#export HOMEgrads=/sss/emc/ensemble/shared/Bo.Cui/CONUS_Q1_2012/grads
#export EXECgrads=$NGLOBAL/Bo.Cui/ccs_u/naefs_plot/exec
#export NDATE=/nwprod/util/exec/ndate

#GXGIF=/u/Bo.Cui/xbin/gxgif

mkdir -p $DATA
cd $DATA
#rm *
#rm *gr *gif

fldlist=" pres t2m u10m v10m tmin2m tmax2m wdir10m wind10m dpt2m rh2m "

XDEF=1073
YDEF=689

cp $HOMEgrads/rgbset.gs .
cp $HOMEgrads/cbarn.gs .
cp $HOMEgrads/bytemap.USA_swap .

for CYC in 00 ; do

  cycle=t${CYC}z

for nfhr in $hourlist;  do

  CDATE=`$NDATE +$nfhr $EDY `
  YY=`echo $CDATE | cut -c1-4`
  MM=`echo $CDATE | cut -c5-6`
  DD=`echo $CDATE | cut -c7-8`
  cyc=`echo $CDATE | cut -c9-10`
  CMM=`grep $MM $EXECgrads/mon2mon | cut -c8-10`
  STYMD=${cyc}Z$DD$CMM$YY

########################
## for mean average bias
########################

  INPUT=${fname}_mef${nfhr}_$SDY.$EDY
  cp ${COMIN}/${INPUT} . 

  sed -e "s/INPUT/$INPUT/" \
      -e "s/STYMD/$STYMD/" \
      $HOMEgrads/naefs_mevf.ctl > naefs_mevf.ctl 

  sed -e "s/STYMD/$STYMD/" \
      $HOMEgrads/land_ndgd.ctl    > land_ndgd.ctl    

  gribmap -i naefs_mevf.ctl

  sed -e "s/SDY/$SDY/" \
      -e "s/EDY/$EDY/" \
      -e "s/XDEF/$XDEF/" \
      -e "s/YDEF/$YDEF/" \
      -e "s/ENSM/$ENSM/" \
      -e "s/nfhr/$nfhr/" \
      $HOMEgrads/naefs_me.gs > naefs_me.gs

  grads -bcl "naefs_me.gs"

  for fld in $fldlist; do
    $GXGIF -r -x 1100 -y 850  -i naefs_${fld}.gr -o ${ensm}_${fld}.t00z.ndgd_mef${nfhr}.gif
  done

#################################
## for absolute mean average bias
#################################

  rm *gr naefs_mevf.ctl 

  INPUT=${fname}_amef${nfhr}_$SDY.$EDY
  cp ${COMIN}/${INPUT} . 

  sed -e "s/INPUT/$INPUT/" \
      -e "s/STYMD/$STYMD/" \
      $HOMEgrads/naefs_mevf.ctl > naefs_mevf.ctl 

  sed -e "s/STYMD/$STYMD/" \
      $HOMEgrads/land_ndgd.ctl    > land_ndgd.ctl    

  gribmap -i naefs_mevf.ctl

  sed -e "s/SDY/$SDY/" \
      -e "s/EDY/$EDY/" \
      -e "s/XDEF/$XDEF/" \
      -e "s/YDEF/$YDEF/" \
      -e "s/ENSM/$ENSM/" \
      -e "s/nfhr/$nfhr/" \
      $HOMEgrads/naefs_ame.gs > naefs_ame.gs

  grads -bcl "naefs_ame.gs"

#  for fld in $fldlist; do
#    $GXGIF -r -x 1100 -y 850  -i naefs_${fld}.gr -o ${ensm}_${fld}.t00z.ndgd_amef${nfhr}.gif
#  done

done

done

#ssh -l bocui emcrzdm "mkdir ${dir_main}/${dir_new}"
#scp *.gif      bocui@emcrzdm:${dir_main}/$dir_new
#scp index.html bocui@emcrzdm:${dir_main}/$dir_new

ssh -l bocui emcrzdm "mkdir -p ${dir_main}/${dir_new}"
ssh -l bocui emcrzdm "cp ${dir_main}/al* ${dir_main}/${dir_new}"
ssh -l bocui emcrzdm "cp ${dir_main}/in* ${dir_main}/${dir_new}"
ssh -l bocui emcrzdm "echo $dir_new > ${dir_main}/dir_new.txt"
ssh -l bocui emcrzdm "cat ${dir_main}/dir_new.txt >> ${dir_main}/allow.cfg"
scp *.png      bocui@emcrzdm:${dir_main}/$dir_new
scp  $HOMEcrps/grads/grads_crps_naefs/SAMPLE_NAEFS.HTML  bocui@emcrzdm:${dir_main}/$dir_new

