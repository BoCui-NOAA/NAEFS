#!/bin/bash -l

set -x

#module load prod_util

Date=`date +%y%m%d%H`
CDATE=20$Date

PDY=`echo $CDATE | cut -c1-8`
cyc=`echo $CDATE | cut -c9-10`

PDY=20221122

CDATE=${PDY}00
CDATE=`$NDATE -48 $CDATE`

PDYm2=`echo $CDATE | cut -c1-8`
cyc=`echo $CDATE | cut -c9-10`

COMROOT=/lfs/h1/ops/prod/com/naefs/v6.1
COM_OUT=/lfs/h2/emc/vpppg/noscrub/$LOGNAME/com/naefs/v6.1                 

outdir=/lfs/h2/emc/vpppg/noscrub/bo.cui/naefs.v7.0.0/mycron

dirlist="pgrb2ap5"

for cyc in 00 06 12 18; do
for dir in $dirlist; do
  COMOUT=$COM_OUT/gefs.$PDYm2/$cyc/$dir
  mkdir -p $COMOUT
  cp $COMROOT/gefs.$PDYm2/$cyc/$dir/*ncep* $COMOUT
done  
done  

>$outdir/output/out.warning.$PDY
output="$( bash <<EOF
ls $COM_OUT/gefs.$PDYm2/*/$dir/* | wc -l
EOF
)"
echo "output=" $output 
if [ $output -ne 4 ]; then
  echo $PDY$cyc  >>$outdir/output/out.warning.$PDY
  echo "Warning !!! GEFS ncep* has file 4 files" >>$outdir/output/out.warning.$PDY
  echo $COMOUT   >>$outdir/output/out.warning.$PDY
  echo "output=" $output  >>$outdir/output/out.warning.$PDY
fi

cyc=00

dirlist="pgrb2ap5_bc ndgd_gb2"
modlelist="gefs naefs"

for mod in $modlelist; do
for dir in $dirlist; do
  COMOUT=$COM_OUT/$mod.$PDY/$cyc/$dir
  mkdir -p $COMOUT
  cp $COMROOT/$mod.$PDY/$cyc/$dir/*geavg* $COMOUT
  cp $COMROOT/$mod.$PDY/$cyc/$dir/*gespr* $COMOUT

output="$( bash <<EOF
ls $COMOUT/* | wc -l
EOF
)"
echo "output=" $output 
if [ $output -ne 384 -a $output -ne 192 ]; then
  echo $PDY$cyc >>$outdir/output/out.warning.$PDY
  echo "Warning !!! 384 or 192 files"  >>$outdir/output/out.warning.$PDY
  echo $COMOUT                              >>$outdir/output/out.warning.$PDY
  echo "output=" $output  >>$outdir/output/out.warning.$PDY
fi

done  
done  

