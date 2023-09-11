########################################
# Script:   global_biasavg.sh
# Abstract: this script produces gif files of region averaged bias ( absolute and relative)
# Author:   Bo Cui
# History:  May 2006, first implentament
########################################


CDATE=$EDY

if [ "$CDATE" -eq " " ]; then
  echo "No data for CDATE, please check"
  exit 8
fi
     
export PDY=`echo $CDATE | cut -c1-8`
export cyc=`echo $CDATE | cut -c9-10`

set +x
echo " "
echo " Entering sub script global_biasavg.sh"
echo " iob input initial time is: $ymd=$1 "
echo " job input forecast time is: $cyc=$2   "
echo " "
set -x

#export DATA=/ptmp/wx20cb/plot_bias/plot_biasavg_meame_$SDY.$EDY

#rm -rf $DATA

if [[ ! -d $DATA ]]; then
  mkdir -p $DATA
fi
cd $DATA
#rm *

#######################################
# define directory and utility used
#######################################

export HOMEPLOT=$HOME/naefs_dvrtma           
export NDATE=/nwprod/util/exec/ndate

export COMIN=$NGLOBAL/wx20cb/para_conus/average
export GRADSDIR=/global/save/wx20cb/CONUS_Q1_2012/grads                                     
export EXECGRAD=$HOME/naefs_plot/exec                                                               

YY=`echo $EDY   | cut -c1-4`
MM=`echo $EDY   | cut -c5-6`
DD=`echo $EDY   | cut -c7-8`
CMM=`grep $MM $EXECGRAD/mon2mon | cut -c8-10`
STYMD=${cyc}Z$DD$CMM$YY
if [ $STARTHR  -eq 12 ]; then
  STYMD=12Z$DD$CMM$YY
fi
YMDH=$PDY$cyc      

CYC=t${cyc}z
#NDAYS=61
#INTERHR=6hr
XDEF=1073
YDEF=689

NM1=naefs_drbcds         
NM2=gefs_raw
NM3=gefs_drbcds

cp /u/wx20cb/naefs_plot/grads/linesmpos.gs .

#######################################
# start to draw plots                             
#####################################

#hourlist=" 00  06  12  18  24  30  36  42  48  54  60  66  72  78  84  90  96 \
#          102 108 114 120 126 132 138 144 150 156 162 168 174 180 186 192 198 \
#          204 210 216 222 228 234 240 246 252 258 264 270 276 282 288 294 300 \
#          306 312 318 324 330 336 342 348 354 360 366 372 378 384"

reglist=" nh sh tr "

fldlist=" pres t2m u10m v10m tmax tmin wspd10m wdir10m dpt2m rh2m"
#fldlist=" pres t2m u10m v10m           wspd10m wdir10m dpt2m rh2m"
#fldlist=" tmax tmin"

wtlist="naefs gefs_drbcds gefs_raw "

for nfhrs in $hourlist; do
  for wt in $wtlist; do
    tnfhrs=$nfhrs
    if [ $STARTHR  -eq 12 ]; then
      tnfhrs=`expr $nfhrs - 12`
    fi
    if [ $tnfhrs -eq 00 ]; then
      ln -fs $COMIN/${wt}_geavg.t${cyc}z.ndgd_conus_mef${nfhrs}_$SDY.$EDY  ${wt}_geavg.t${cyc}z.ndgd_conus_mef00
      ln -fs $COMIN/${wt}_geavg.t${cyc}z.ndgd_conus_amef${nfhrs}_$SDY.$EDY ${wt}_geavg.t${cyc}z.ndgd_conus_amef00
    else
      ln -fs $COMIN/${wt}_geavg.t${cyc}z.ndgd_conus_mef${nfhrs}_$SDY.$EDY  ${wt}_geavg.t${cyc}z.ndgd_conus_mef${tnfhrs}
      ln -fs $COMIN/${wt}_geavg.t${cyc}z.ndgd_conus_amef${nfhrs}_$SDY.$EDY ${wt}_geavg.t${cyc}z.ndgd_conus_amef${tnfhrs}
    fi
  done
done

for wt in $wtlist; do

  FNAME=^${wt}_geavg.t${cyc}z.ndgd_conus_mef%f2

  sed -e "s/STYMD/$STYMD/" \
      -e "s/NDAYS/$NDAYS/" \
      -e "s/INTERHR/$INTERHR/" \
      -e "s/CYC/$CYC/" \
      -e "s/FNAME/$FNAME/" \
      $GRADSDIR/geavg_ndgd.ctl > ${wt}_geavg.ndgd_me.ctl

  FNAME=^${wt}_geavg.t${cyc}z.ndgd_conus_amef%f2

  sed -e "s/STYMD/$STYMD/" \
      -e "s/NDAYS/$NDAYS/" \
      -e "s/INTERHR/$INTERHR/" \
      -e "s/CYC/$CYC/" \
      -e "s/FNAME/$FNAME/" \
      $GRADSDIR/geavg_ndgd.ctl > ${wt}_geavg.ndgd_ame.ctl

   gribmap -i ${wt}_geavg.ndgd_me.ctl
   gribmap -i ${wt}_geavg.ndgd_ame.ctl

done

sed -e "s/NM1/$NM1/" \
    -e "s/NM2/$NM2/" \
    -e "s/NM3/$NM3/" \
    $HOME/rtma/grads/leg_rms_lines3 > leg_rms_lines

sed -e "s/YMDH/$YMDH/" \
    -e "s/NDAYS/$NDAYS/" \
    -e "s/XDEF/$XDEF/" \
    -e "s/YDEF/$YDEF/" \
    -e "s/CYC/$CYC/" \
    -e "s/SDY/$SDY/" \
    -e "s/EDY/$EDY/" \
    -e "s/ISVAR/$ISVAR/" \
    -e "s/IEVAR/$IEVAR/" \
    -e "s/LATS/$LATS/" \
    -e "s/LATE/$LATE/" \
    -e "s/LONS/$LONS/" \
    -e "s/LONE/$LONE/" \
    -e "s/LABDAYS/$LABDAYS/" \
    $GRADSDIR/rtma_meavg.gs > rtma_meavg.gs                    

rm *.gr

grads -bcl "rtma_meavg.gs"
#grads -cl "rtma_meavg.gs"

for fld in $fldlist; do
  gxgif -r -x 1100 -y 850  -i rtma_${fld}_bias_die_t${cyc}z.gr -o rtma_${fld}_me_die_t${cyc}z.gif
# gxps  -c  -i rtma_${fld}_bias_die_t${cyc}z.gr -o rtma_${fld}_bias_die_t${cyc}z.ps                         
done


##############################
# for rtma conus region AME
##############################
sed -e "s/YMDH/$YMDH/" \
    -e "s/NDAYS/$NDAYS/" \
    -e "s/XDEF/$XDEF/" \
    -e "s/YDEF/$YDEF/" \
    -e "s/CYC/$CYC/" \
    -e "s/SDY/$SDY/" \
    -e "s/EDY/$EDY/" \
    -e "s/ISVAR/$ISVAR/" \
    -e "s/IEVAR/$IEVAR/" \
    -e "s/LATS/$LATS/" \
    -e "s/LATE/$LATE/" \
    -e "s/LONS/$LONS/" \
    -e "s/LONE/$LONE/" \
    -e "s/LABDAYS/$LABDAYS/" \
    $GRADSDIR/rtma_ameavg.gs > rtma_ameavg.gs               

rm *.gr

grads -bcl "rtma_ameavg.gs"

for fld in $fldlist; do
  gxgif -r -x 1100 -y 850  -i rtma_${fld}_bias_die_t${cyc}z.gr -o rtma_${fld}_ame_die_t${cyc}z.gif
done

#####################################
# Send Plots to rzdm Computer
#####################################

#export dir_main=/home/people/emc/www/htdocs/gmb/wx20cb/akrtma    
#export dir_new=conus_meame                  

ssh -l bocui rzdm "mkdir ${dir_main}/${dir_new}"
scp *.gif      bocui@rzdm:${dir_main}/$dir_new
#scp index.html bocui@rzdm:${dir_main}/$dir_new

