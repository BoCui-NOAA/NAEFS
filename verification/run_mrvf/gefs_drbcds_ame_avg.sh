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

#COMOUT=$PTMP/$LOGNAME/prod/average
#DATA=/ptmp/Bo.Cui/infro_conus/gefs_drbcds_ameavg_${stymd}_$edymd

mkdir -p $DATA

cd $DATA                  
rm *

pgm=average_alaska_endt

##############################################################
### calculate bias estimation for different forecast lead time
##############################################################

hourlist=" 00  06  12  18  24  30  36  42  48  54  60  66  72  78  84  90  96 \
          102 108 114 120 126 132 138 144 150 156 162 168 174 180 186 192 198 \
          204 210 216 222 228 234 240 246 252 258 264 270 276 282 288 294 300 \
          306 312 318 324 330 336 342 348 354 360 366 372 378 384"

nens="avg"

########################################################
# input basic information, member and forecast lead time
########################################################

for nfhrs in $hourlist; do

  stymd=$1
  icnt=0

  rm input*

  echo " &filec "  >>input1
  echo " &filei "  >>input2

  while [ $stymd -le $edymd ]; do

    PDY=`echo $stymd | cut -c1-8`
    cyc=`echo $stymd | cut -c9-10`

    file=ge${nens}.t${cyc}z.ndgd_conus_amef${nfhrs} 
    ofile=gefs_drbcds_ge${nens}.t${cyc}z.ndgd_conus_amef${nfhrs}
    SFILE=$MEINPUT/gefs.$PDY/${cyc}/mevf_gefs/$file

    ls -l $SFILE
    if [ -s $SFILE ]; then
    (( icnt += 1 ))
       echo " cfile($icnt)='$SFILE' "
       echo " cfile($icnt)='$SFILE' " >>input1
       echo " infile($icnt)=1 "
       echo " infile($icnt)=1 " >>input2
    fi

    stymd=`$nhours +24 $stymd`

  done

  echo " outfile='mean.output.$nfhrs' " >>input1
  echo " /" >>input1
  echo " /" >>input2

  echo " &namin " >>input3
  echo " ilen=$icnt " >>input3
  echo " odate=$edymd " >>input3
  echo " /" >>input3

  cat input1 input2 input3 >input

  $EXECVRFY/$pgm <input >output.$nfhrs

  cp mean.output.$nfhrs $COMOUT/${ofile}_$1.$2

done

