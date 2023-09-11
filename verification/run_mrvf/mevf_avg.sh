if [ $# -lt 2 ]; then
    echo " Usage: $0 need s-yyyymmdd, e-yyyymmdd, id, YYYYMM and ensm"
    echo " For example: PROB_NCEP_MEAN.sh 19960101 19960131 weight "
    exit 8
fi

echo
echo " ######################################################## "
echo " ###   Start to average the probability scores        ### "
echo " ###   Please wait! wait! wait!!!!!!!                 ### "
echo " ######################################################## "
echo

stymd=$1
edymd=$2

export ireg=conus
export var=ame

export direxp=naefs.v7.0.0

export PACKAGEROOT=/lfs/h2/emc/vpppg/noscrub/$LOGNAME
export HOMEcrps=$PACKAGEROOT/$direxp/verification
export EXECcrps=$HOMEcrps/exec

export DATAROOT=/lfs/h2/emc/ptmp/$LOGNAME/tmpnwprd

#export COMROOT=/lfs/h2/emc/vpppg/noscrub/$LOGNAME/com

pgm=average_alaska_endt

##############################################################
### calculate bias estimation for different forecast lead time
##############################################################

hourlist="000 006 012 018 024 030 036 042 048 054 060 066 072 078 084 090 096 \
          102 108 114 120 126 132 138 144 150 156 162 168 174 180 186 192 198 \
          204 210 216 222 228 234 240 246 252 258 264 270 276 282 288 294 300 \
          306 312 318 324 330 336 342 348 354 360 366 372 378 384"

hourlist="024 048"
##############################################################

for naefs_ver in v6.1 v7.0; do
for id in gefs naefs; do

for ireg in conus; do
  case $ireg in
    conus) grid=ext_2p5;;                           
    alaska) grid=3p0;;                           
  esac
  COMROOT=/lfs/h2/emc/ptmp/$LOGNAME/com
  COM_IN=$COMROOT/naefs/$naefs_ver
  COMROOT=/lfs/h2/emc/vpppg/noscrub/$LOGNAME/com
  COMOUT=$COMROOT/stat/naefs.$naefs_ver/me_ame_${ireg}_$id
  mkdir -p $COMOUT

for var in me ame; do

DATA=$DATAROOT/crps_vrfy/${naefs_ver}_${id}_${ireg}_${var}_mevf_avg.$1.$2

rm -rf $DATA
mkdir -m 775 -p $DATA

cd $DATA                  
########################################################
# input basic information, member and forecast lead time
########################################################

for nfhrs in $hourlist; do

  stymd=$1
  edymd=$2
  icnt=0

  echo " &filec "  >>input1
  echo " &filei "  >>input2

  while [ $stymd -le $edymd ]; do

    PDY=`echo $stymd | cut -c1-8`
    cyc=`echo $stymd | cut -c9-10`

    file=${id}.t${cyc}z.${ireg}_${grid}_${var}f${nfhrs}
    SFILE=$COM_IN/${id}.$PDY/${cyc}/mevf_${ireg}/$file

    ls -l $SFILE
    if [ -s $SFILE ]; then
    (( icnt += 1 ))
       echo " cfile($icnt)='$SFILE' "
       echo " cfile($icnt)='$SFILE' " >>input1
       echo " infile($icnt)=1 "
       echo " infile($icnt)=1 " >>input2
    fi

    stymd=`$NDATE +24 $stymd`

  done

  echo " outfile='mean.output.$nfhrs' " >>input1
  echo " /" >>input1
  echo " /" >>input2

  echo " &namin " >>input3
  echo " ilen=$icnt " >>input3
  echo " odate=$edymd " >>input3
  echo " /" >>input3

  cat input1 input2 input3 >input

  $EXECcrps/$pgm <input >output.$nfhrs

  ofile=${id}.t${cyc}z.${ireg}_${var}f${nfhrs}
  cp mean.output.$nfhrs $COMOUT/${ofile}_$1.$2
  
  rm input*

done

# end of hourlst

########################################################

done
done
done
done
