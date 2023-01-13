
if [ $# -lt 4 ]; then
    echo " Usage: $0 need s-yyyymmdd, e-yyyymmdd, cname, id1, id2 ..."
    echo " For example: GRADS.sh 20060220 20060313 200603 10x 14x"
    exit 8
fi

STYMD=$1       
EDYMD=$2        
CNAME=$3
id1=$4
id2=$5
id3=$6
id4=$7
export GDIR=$GDIR
export VFIELD=$VFIELD

cyc=`echo $STYMD | cut -c9-10`

CYC=t${cyc}z                          

cd $GDIR;pwd

export HOME=/gpfs/sss/emc/ensemble/shared/Bo.Cui/Verification

cp $HOME/grads_pub/linesmpos.gs .

icnt=0

case $VFIELD in
 P1000HGT) field=z1000;FIELD="1000hPa Height";;
 P500HGT) field=z500;FIELD="500hPa Height";;
 P850TMP) field=t850;FIELD="850hPa Temp.";;
 P2MTMP) field=t2m;FIELD="2 Meter Temp.";;
 P10MUGRD) field=u10m;FIELD="10 Meter U(wind)";;
 P10MVGRD) field=v10m;FIELD="10 Meter V(wind)";;
 PTMIN) field=tmin;FIELD="Tmin";;
 PTMAX) field=tmax;FIELD="Tmax";;
 PTCDC) field=tcdc;FIELD="TCDC";;
 P2MDPT) field=dpt;FIELD="2 Meter Dew Point Temp.";;
 P10MWIND) field=wspd;FIELD="10 Meter Wind Speed";;
 P10MWDIR) field=wdir;FIELD="10 Meter Wind Direction";;
 P2MRH) field=rh2m;FIELD="2 Meter Relative Humility";;
esac

for expid in $id1 $id2 $id3 $id4
do

 sed -e "s/EXPID/$expid/" \
    $SHOME/naefs.v6.0.1/grads_crps_rtma/rtma_scoreavg.ctl  >grads_${expid}.ctl

 icnt=`expr $icnt + 1`

done

sed -e "s/EXPID1/$id1/" \
    -e "s/EXPID2/$id2/" \
    -e "s/EXPID3/$id3/" \
    -e "s/EXPID4/$id4/" \
    $HOME/grads_pub/leg_${icnt}lines >leg_lines

#TEMP=/gpfs/gd1/emc/ensemble/save/Bo.Cui/ECMWF/grads_crps_rtma
TEMP=$SHOME/naefs.v6.0.1/grads_crps_rtma

sed -e "s/EXPID1/$id1/" \
    -e "s/EXPID2/$id2/" \
    -e "s/EXPID3/$id3/" \
    -e "s/EXPID4/$id4/" \
    -e "s/CSTYMD/$STYMD/" \
    -e "s/CEDYMD/$EDYMD/" \
    -e "s/field/$field/" \
    -e "s/FIELD/$FIELD/" \
    -e "s/STYMD/$STYMD/" \
    -e "s/EDYMD/$EDYMD/" \
    -e "s/CYC/$CYC/" \
    $TEMP/rtma_scoreavg_${icnt}line_24h.gs >grads.gs
#   $TEMP/rtma_scoreavg_${icnt}line_tmax.gs >grads.gs

grads -bcl "grads.gs"

reglist="rtma"
sclist="crpsf rmsa rmsm merr ctp"
#sclist=" crpsc"

for reg in $reglist; do
  for score in $sclist; do
    $GXGIF -r -x 1100 -y 850  -i ${reg}_${field}_${score}_${CYC}.gr -o ${reg}_${field}_${score}_${CYC}.gif
  done
done


