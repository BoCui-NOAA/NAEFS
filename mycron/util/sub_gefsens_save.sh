#!/bin/bash -l

set -x

#module load prod_util

Date=`date +%y%m%d%H`
#CDATE=20$Date
#CDATE=`$NDATE -5 $CDATE`

#PDY=`echo $CDATE | cut -c1-8`
#cyc=`echo $CDATE | cut -c9-10`

#PDY=20221120

CDATE=${PDY}00
CDATE=`$NDATE -48 $CDATE`

PDYm2=`echo $CDATE | cut -c1-8`
cyc=`echo $CDATE | cut -c9-10`

#PROD='grep primary /lfs/h1/ops/prod/config/prodmachinefile | cut -d: -f2'
#eval $PROD
#echo "prod is" $prod

#if [  $prod == cactus ]; then
#  # Data on cactus
#  export COMROOT=/lfs/h1/ops/prod/com/naefs/v6.1
#else
# Data on dogwood
#  export COMROOT=/lfs/h1/ops/prod/com/naefs/v6.1
#fi

COMROOT=/lfs/h1/ops/prod/com/naefs/v6.1
COM_OUT=/lfs/h2/emc/vpppg/noscrub/$LOGNAME/com/naefs/v6.1                 

dirlist="pgrb2ap5"

for cyc in 00 06 12 18; do
for dir in $dirlist; do
  COMOUT=$COM_OUT/gefs.$PDYm2/$cyc/$dir
  mkdir -p $COMOUT
  cp $COMROOT/gefs.$PDYm2/$cyc/$dir/*ncep* $COMOUT
done  
done  

>trash/out.warning.$PDY
output="$( bash <<EOF
ls $COM_OUT/gefs.$PDYm2/*/$dir/* | wc -l
EOF
)"
echo "output=" $output 
if [ $output -ne 4 ]; then
  echo $PDY$cyc  >>trash/out.warning.$PDY
  echo "Warning !!! GEFS ncep* has file 4 files" >>trash/out.warning.$PDY
  echo $COMOUT   >>trash/out.warning.$PDY
  echo "output=" $output  >>trash/out.warning.$PDY
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
  echo $PDY$cyc >>trash/out.warning.$PDY
  echo "Warning !!! 384 or 192 files"  >>trash/out.warning.$PDY
  echo $COMOUT                              >>trash/out.warning.$PDY
  echo "output=" $output  >>trash/out.warning.$PDY
fi

done  
done  

