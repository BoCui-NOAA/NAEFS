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

#export VFIELD=$VFIELD

cyc=`echo $STYMD | cut -c9-10`

CYC=t${cyc}z                          

cd $DATA;pwd

cp $PLOTcrps/grads_pub/linesmpos.gs .

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
 P2MDPT) field=dpt;FIELD="2 Meter Dew Point Temp";;
 P10MWIND) field=wspd;FIELD="10 Meter Wind Speed";;
 P10MWDIR) field=wdir;FIELD="10 Meter Wind Direction";;
 P2MRH) field=rh2m;FIELD="2 Meter Relative Humility";;
esac

for expid in $id1 $id2 $id3 $id4
do

 sed -e "s/EXPID/$expid/" \
    $PLOTcrps/grads_crps_ndgd/rtma_scoreavg.ctl  >grads_${expid}.ctl

 icnt=`expr $icnt + 1`

done

#sed -e "s/EXPID1/$id1/" \
#    -e "s/EXPID2/$id2/" \
#    -e "s/EXPID3/$id3/" \
#    -e "s/EXPID4/$id4/" \
#    $HOME/grads_pub/leg_${icnt}lines >leg_lines

cp  $PLOTcrps/grads_crps_ndgd/leg_${icnt}lines leg_lines

if [ $ireg = "conus" ]; then
  if [ $field = "tmin" -o $field = "tmax" ]; then
     gsfile=${ireg}_rtma_scoreavg_${icnt}line_tmaxmin.gs   
  else
     gsfile=${ireg}_rtma_scoreavg_${icnt}line_24h.gs
  fi
elif [ $ireg = "alaska" ]; then
  if [ $field = "tmax" ]; then
     gsfile=${ireg}_rtma_scoreavg_${icnt}line_tmax.gs
  else
     gsfile=${ireg}_rtma_scoreavg_${icnt}line_24h.gs
  fi
fi

rm grads.gs

sed -e "s/EXPID1/$id1/" \
    -e "s/EXPID2/$id2/" \
    -e "s/EXPID3/$id3/" \
    -e "s/EXPID4/$id4/" \
    -e "s/field/$field/" \
    -e "s/FIELD/$FIELD/" \
    -e "s/STYMD/$STYMD/" \
    -e "s/EDYMD/$EDYMD/" \
    -e "s/CYC/$CYC/" \
    -e "s/regs/$regs/" \
    $PLOTcrps/grads_crps_ndgd/${gsfile} >grads.gs
#   $PLOTcrps/grads_crps_ndgd/rtma_scoreavg_${icnt}line_24h.gs >grads.gs

grads -bcl "grads.gs"

sclist="crpsf rmsa rmsm merr ctp"

#for score in $sclist; do
#  mv rtma_${field}_${score}_${CYC}.png ${ireg}_${field}_${score}_${CYC}.png    
#done


