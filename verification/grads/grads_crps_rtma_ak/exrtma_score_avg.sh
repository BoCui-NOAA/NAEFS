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
ENSIM=$3
ireg=$4

#EXECDIR=/sss/emc/ensemble/shared/Bo.Cui/Verification/exec
EXECDIR=/gpfs/sss/emc/ensemble/shared/Bo.Cui/Verification/exec

mkdir -p $COMOUT

pgm=crps_avg

cd $GDIR                  
rm input*

icnt=0

echo " &filec "  >>input1
echo " &filei "  >>input2

while [ $stymd -le $edymd ]; do

  PDY=`echo $stymd | cut -c1-8`
  cyc=`echo $stymd | cut -c9-10`

  if [ "$runini" = "YES" ]; then
    SFILE=$DATAVRFY/${CENTER}/${VFIELD}${ENSIM}f.$PDY$cyc.$ireg
    ls $SFILE
  fi

  if [ "$runini" = "NO" ]; then
    SFILE=$DATAVRFY/${CENTER}/${VFIELD}${ENSIM}a.$PDY$cyc.$ireg
  fi

    ls $SFILE
  if [ -s $SFILE ]; then
  (( icnt += 1 ))
     echo " cfile($icnt)='$SFILE' "
     echo " cfile($icnt)='$SFILE' " >>input1
     echo " ifile($icnt)=1 "
     echo " ifile($icnt)=1 " >>input2
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

$EXECDIR/$pgm <input >output.${VFIELD}${ENSIM}.$ireg

cp mean.output $COMOUT/crps_avg.$1.$2.${VFIELD}${ENSIM}.$ireg
cp mean.grads  $COMOUT/mean.grads_$1.$2.${VFIELD}${ENSIM}.$ireg

cp mean.output mean.txt_${ENSIM}
cp mean.grads  mean.grads_${ENSIM}

rm mean.output mean.grads
