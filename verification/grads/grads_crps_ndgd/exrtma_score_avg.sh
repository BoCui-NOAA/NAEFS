if [ $# -lt 4 ]; then
    echo " Usage: $0 need s-yyyymmdd, e-yyyymmdd, id, YYYYMM and ensm region"
    echo " For example: exrtma_score_avg.sh 19960101 19960131 20sb conus "
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
id=$3
ireg=$4
model=$5

mkdir -p $COMOUT

pgm=rtma_crps_avg

cd $DATA                  
rm input*

icnt=0

echo " &filec "  >>input1
echo " &filei "  >>input2

while [ $stymd -le $edymd ]; do

  PDY=`echo $stymd | cut -c1-8`
  cyc=`echo $stymd | cut -c9-10`

  if [ "$runini" = "YES" ]; then
    SFILE=$COMIN/${VFIELD}.${id}f.$PDY$cyc.$ireg
    ls $SFILE
  fi

  if [ "$runini" = "NO" ]; then
    SFILE=$COMIN/${VFIELD}.${id}a.$PDY$cyc.$ireg
    ls $SFILE
  fi

  if [ -s $SFILE ]; then
  (( icnt += 1 ))
     echo " cfile($icnt)='$SFILE' "
     echo " cfile($icnt)='$SFILE' " >>input1
     echo " ifile($icnt)=1 "
     echo " ifile($icnt)=1 " >>input2
  fi

  stymd=`$NDATE +24 $stymd`

done

echo "There is file icnt=" $icnt

echo " ofile='mean.output' " >>input1
echo " gfile='mean.grads'  " >>input1
echo " /" >>input1
echo " /" >>input2

istymd=$1

echo " &namin " >>input3
echo " ilen=$icnt,istymd=$istymd,iedymd=$edymd " >>input3
echo " /" >>input3

cat input1 input2 input3 >input

$EXECcrps/$pgm <input >output.${VFIELD}${id}.$ireg.$model

cp mean.output $COMOUT/crps_avg.$1.$2.${VFIELD}.${id}.$ireg.$model
cp mean.grads  $COMOUT/mean.grads_$1.$2.${VFIELD}.${id}.$ireg.$model

mv mean.output mean.txt_${id}.$ireg.$model
mv mean.grads  mean.grads_${id}.$ireg.$model

