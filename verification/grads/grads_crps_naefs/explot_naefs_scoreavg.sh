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
#export DATA=$DATA
export VFIELD=$VFIELD

cyc=`echo $STYMD | cut -c9-10`

CYC=t${cyc}z                          

cd $DATA;pwd
rm *.gs

cp $PLOTcrps/grads_pub/linesmpos.gs .

GXGIF=/u/$LOGNAME/xbin/gxgif

icnt=0

case $VFIELD in
 P1000HGT) field=z1000;FIELD="1000hPa Height";;
 P500HGT) field=z500;FIELD="500hPa Height";;
 P850TMP) field=t850;FIELD="850hPa Temp.";;
 P2MTMP) field=t2m;FIELD="2 Meter Temp.";;
 PTMAX) field=tmax;FIELD="Max Temperature";;
 PTMIN) field=tmin;FIELD="Min Temperature";;
 P10MUGRD) field=u10m;FIELD="10 Meter U(wind)";;
 P10MVGRD) field=v10m;FIELD="10 Meter V(wind)";;
 PRH2M) field=rh2m;FIELD="2 Meter RH";;
 PDPT2M) field=td2m;FIELD="2 Meter dew Point Temp";;
 PPRES) field=pres;FIELD="Surface Pressure";;
 PTCDC) field=tcdc;FIELD="Total Cloud Cover";;
 P10MWIND) field=wspd10m;FIELD="10 Meter Wind";;
 P850UGRD) field=u850;FIELD="850mb Meter U(wind)";;
 P850VGRD) field=v850;FIELD="850mb Meter V(wind)";;
 P250UGRD) field=u250;FIELD="250mb Meter U(wind)";;
 P250VGRD) field=v250;FIELD="250mb Meter V(wind)";;
esac

for expid in $id1 $id2 $id3 $id4
do

 sed -e "s/EXPID/$expid/" \
    $PLOTcrps/grads_crps_naefs/naefs_scoreavg.ctl  >grads_${expid}.ctl

 icnt=`expr $icnt + 1`

done

#sed -e "s/EXPID1/$id1/" \
#    -e "s/EXPID2/$id2/" \
#    -e "s/EXPID3/$id3/" \
#    -e "s/EXPID4/$id4/" \
#    $PLOTcrps/grads_pub/leg_${icnt}lines >leg_lines
cp  $PLOTcrps/grads_crps_naefs/leg_${icnt}lines leg_lines                        

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
    $PLOTcrps/grads_crps_naefs/naefs_scoreavg_${icnt}line_${INTERHR}.gs >grads.gs

grads -bcl "grads.gs"

reglist="nh sh tr as na eu" 
sclist="crpsf crpsc rmsa rmsm merr ctp"
sclist="crpsf rmsa rmsm merr ctp"

#for reg in $reglist; do
#  for score in $sclist; do
#   $GXGIF -r -x 1100 -y 850  -i ${reg}_${field}_${score}_${CYC}.gr -o ${reg}${field}_${score}_${CNAME}.gif
#    $GXGIF -r -x 1100 -y 850  -i ${reg}_${field}_${score}_${CYC}.gr -o ${reg}${field}_${score}.gif
#  done
#done

