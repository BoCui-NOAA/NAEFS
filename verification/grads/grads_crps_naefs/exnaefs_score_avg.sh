if [ $# -lt 3 ]; then
    echo " Usage: $0 need s-yyyymmdd, e-yyyymmdd, id, YYYYMM and ensm "
    echo " For example: exrtma_score_avg.sh 19960101 19960131 20sb "
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
ENSIM=$3
model=$4
#ireg=$4

mkdir -p $COMOUT

pgm=naefs_crps_avg_3hr

cd $DATA                  
rm input*

icnt=0

echo " &filec "  >>input1
echo " &filei "  >>input2

echo $stymd $edymd

while [ $stymd -le $edymd ]; do

  PDY=`echo $stymd | cut -c1-8`
  cyc=`echo $stymd | cut -c9-10`

  if [ "$runini" = "YES" ]; then
    SFILE=$COMIN/${VFIELD}${ENSIM}f.$PDY$cyc
  fi
  if [ "$runini" = "NO" ]; then
#   SFILE=$COMIN/${CENTER}/${VFIELD}${ENSIM}a.$PDY$cyc
    SFILE=$COMIN/${VFIELD}.${ENSIM}a.$PDY$cyc
  fi

  if [ -s $SFILE ]; then
  (( icnt += 1 ))
     echo " cfile($icnt)='$SFILE' "
     echo " cfile($icnt)='$SFILE' " >>input1
     echo " ifile($icnt)=1 "
     echo " ifile($icnt)=1 " >>input2
   else
     echo " there is no file " $SFILE
  fi

  stymd=`$NDATE +24 $stymd`

done

echo " ofile='mean.output' " >>input1
echo " gfile='mean.grads'  " >>input1
echo " /" >>input1
echo " /" >>input2

istymd=$1

echo " &namin " >>input3
echo " ilen=$icnt,istymd=$istymd,iedymd=$edymd " >>input3
echo " /" >>input3

cat input1 input2 input3 >input

$EXECcrps/$pgm <input >output.${VFIELD}${ENSIM}.$model

cp mean.output $COMOUT/crps_avg.$1.$2.${VFIELD}${ENSIM}.$model
cp mean.grads  $COMOUT/mean.grads_$1.$2.${VFIELD}${ENSIM}.$model

cp mean.output mean.txt_${ENSIM}.$model
cp mean.grads  mean.grads_${ENSIM}.$model

rm mean.output mean.grads
