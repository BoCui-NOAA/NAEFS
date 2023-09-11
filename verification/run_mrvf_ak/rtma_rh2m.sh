
#######################################################
# read in akrtma raw rh and t2m to get dpt for each member
# output: 2 variables, rh2m and dpt
# attached: 6 variables from raw akrtma
#######################################################

#CDATE=$1
#CDATE=2011030100

MON=`echo $CDATE | cut -c1-6`
PDY=`echo $CDATE | cut -c1-8`
cyc=`echo $CDATE | cut -c9-10`

EXECCMCE=/sss/emc/ensemble/shared/Bo.Cui/CONUS_Q1_2012/exec_4_run

COMIN=$NGLOBAL/Bo.Cui/com/rtma/prod/akrtma.$PDY
COMOUT=$NGLOBAL/Bo.Cui/com/rtma/prod/akrtma.$PDY

DATA=$PTMP/Bo.Cui/infro_gefs/akrtma_add_$PDY$cyc

mkdir -p $DATA   
cd $DATA

pgm=rtma_rh2m   
pgmout=output

hourlist=" 00 01 02 03 04 05 06 07 08 09 10 11 12 \
           13 14 15 16 17 18 19 20 21 22 23 "

for cyc in $hourlist; do
    ifile_ens=$COMIN/akrtma.t${cyc}z.2dvaranl_ndfd_3p0.grb1
    ofile=$COMOUT/akrtma.t${cyc}z.2dvaranl_ndfd_3p0.grb1_rh2m
    ln -sf $ifile_ens fort.11
    ln -sf $ofile     fort.51
    $EXECCMCE/$pgm   > $pgmout.$cyc 2> errfile
done

for cyc in $hourlist; do
    ifile_ens=$COMIN/akrtma.t${cyc}z.2dvaranl_ndfd.grb1
    ofile=$COMOUT/akrtma.t${cyc}z.2dvaranl_ndfd.grb1_rh2m
    ln -sf $ifile_ens fort.11
    ln -sf $ofile     fort.51
    $EXECCMCE/$pgm   > $pgmout.$cyc 2> errfile
done 

for cyc in $hourlist; do
    ifile=$COMIN/akrtma.t${cyc}z.2dvaranl_ndfd.grb1 
    ofile=$COMIN/akrtma.t${cyc}z.2dvaranl_ndfd.grb1_rh2m 
    cat $ofile >>$ifile
    ifile=$COMIN/akrtma.t${cyc}z.2dvaranl_ndfd_3p0.grb1
    ofile=$COMIN/akrtma.t${cyc}z.2dvaranl_ndfd_3p0.grb1_rh2m
    cat $ofile >>$ifile
done

