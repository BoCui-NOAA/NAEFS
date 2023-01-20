#!/bin/bash -l

set -x

#module load prod_util

#Date=`date +%y%m%d%H`
#CDATE=20$Date

#PDY=`echo $CDATE | cut -c1-8`
#cyc=`echo $CDATE | cut -c9-10`

PDY=YYMMDD                          
cyc=CYC                                   

CDATE=${PDY}00
CDATE=`$NDATE -72 $CDATE`

PDYm3=`echo $CDATE | cut -c1-8`
cyc=`echo $CDATE | cut -c9-10`

COMROOT=/lfs/h1/ops/prod/com/naefs/v6.1
COM_OUT=/lfs/h2/emc/vpppg/noscrub/$LOGNAME/com/naefs/v6.1                 

outdir=/lfs/h2/emc/vpppg/noscrub/bo.cui/naefs.v7.0.0/mycron

dirlist="pgrb2ap5"

for cyc in 00 06 12 18; do
for dir in $dirlist; do
  COMOUT=$COM_OUT/gefs.$PDYm3/$cyc/$dir
  mkdir -p $COMOUT
  cp $COMROOT/gefs.$PDYm3/$cyc/$dir/*ncep* $COMOUT
done  
done  

>$outdir/output/out.warning.prodsave.$PDY
output="$( bash <<EOF
ls $COM_OUT/gefs.$PDYm3/*/$dir/* | wc -l
EOF
)"
echo "output=" $output 
if [ $output -ne 4 ]; then
  echo $PDY$cyc  >>$outdir/output/out.warning.prodsave.$PDY
  echo "Warning !!! GEFS ncep* has file 4 files" >>$outdir/output/out.warning.prodsave.$PDY
  echo $COMOUT   >>$outdir/output/out.warning.prodsave.$PDY
  echo "output=" $output  >>$outdir/output/out.warning.prodsave.$PDY
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
  echo $PDY$cyc >>$outdir/output/out.warning.prodsave.$PDY
  echo "Warning !!! 384 or 192 files"  >>$outdir/output/out.warning.prodsave.$PDY
  echo $COMOUT                              >>$outdir/output/out.warning.prodsave.$PDY
  echo "output=" $output  >>$outdir/output/out.warning.prodsave.$PDY
fi

done  
done  


### save gefs raw
COMROOT=/lfs/h1/ops/prod/com/gefs/v12.3 
COM_OUT=/lfs/h2/emc/vpppg/noscrub/$LOGNAME/com/gefs/v12.3                 

cyc=00
dirlist="pgrb2ap5"
modlelist="gefs"

for mod in $modlelist; do
for dir in $dirlist; do
  COMOUT=$COM_OUT/$mod.$PDY/$cyc/atmos/$dir
  mkdir -p $COMOUT
  cp $COMROOT/$mod.$PDY/$cyc/atmos/$dir/*geavg*f0* $COMOUT
  cp $COMROOT/$mod.$PDY/$cyc/atmos/$dir/*geavg*f1* $COMOUT
  cp $COMROOT/$mod.$PDY/$cyc/atmos/$dir/*geavg*f2* $COMOUT
  cp $COMROOT/$mod.$PDY/$cyc/atmos/$dir/*geavg*f3* $COMOUT
  cp $COMROOT/$mod.$PDY/$cyc/atmos/$dir/*gespr*f0* $COMOUT
  cp $COMROOT/$mod.$PDY/$cyc/atmos/$dir/*gespr*f1* $COMOUT
  cp $COMROOT/$mod.$PDY/$cyc/atmos/$dir/*gespr*f2* $COMOUT
  cp $COMROOT/$mod.$PDY/$cyc/atmos/$dir/*gespr*f3* $COMOUT
  cp $COMROOT/$mod.$PDY/$cyc/atmos/$dir/*gec00*f0* $COMOUT
  cp $COMROOT/$mod.$PDY/$cyc/atmos/$dir/*gec00*f1* $COMOUT
  cp $COMROOT/$mod.$PDY/$cyc/atmos/$dir/*gec00*f2* $COMOUT
  cp $COMROOT/$mod.$PDY/$cyc/atmos/$dir/*gec00*f3* $COMOUT
  cp $COMROOT/$mod.$PDY/$cyc/atmos/$dir/*gegfs*f0* $COMOUT
  cp $COMROOT/$mod.$PDY/$cyc/atmos/$dir/*gecgfsf1* $COMOUT
  rm $COMOUT/*idx 
  rm $COMOUT/*f39*

output="$( bash <<EOF
ls $COMOUT/* | wc -l
EOF
)"
echo "output=" $output 
if [  $output -ne 349 ]; then
  echo $PDY$cyc >>$outdir/output/out.warning.prodsave.$PDY
  echo "Warning !!! 349 files"  >>$outdir/output/out.warning.prodsave.$PDY
  echo $COMOUT                              >>$outdir/output/out.warning.prodsave.$PDY
  echo "output=" $output  >>$outdir/output/out.warning.prodsave.$PDY
fi

done  
done  


### save rtma data 

COMROOT=/lfs/h1/ops/prod/com/rtma/v2.9 
COM_OUT=/lfs/h2/emc/vpppg/noscrub/$LOGNAME/com/rtma/v2.9                  

cyclist="00 03 06 09 12 15 18 21"

COMOUT=$COM_OUT/akrtma.$PDYm3
mkdir -p $COMOUT
#for cyc in $cyclist; do
#  cp -p $COMROOT/akrtma.$PDYm3/akrtma.t${cyc}z.2dvaranl_ndfd_3p0.grb* $COMOUT
#done
cp -p $COMROOT/akrtma.$PDYm3/akrtma.t*z.2dvaranl_ndfd_3p0.grb* $COMOUT

COMOUT=$COM_OUT/rtma2p5.$PDYm3
mkdir -p $COMOUT
#for cyc in $cyclist; do
#  cp -p $COMROOT/rtma2p5.$PDYm3/rtma2p5.t${cyc}z.2dvaranl_ndfd.grb*_ext  $COMOUT
#done
cp -p $COMROOT/rtma2p5.$PDYm3/rtma2p5.t*z.2dvaranl_ndfd.grb*_ext  $COMOUT
