
############################################
# 1. 3274+61: pgrb2a
# 2. 3471: pgrb2a_bc

############################################

#hourlist="     06  12  18  24  30  36  42  48  54  60  66  72  78  84  90  96 
#          102 108 114 120 126 132 138 144 150 156 162 168 174 180 186 192 198 \
#          204 210 216 222 228 234 240 246 252 258 264 270 276 282 288 294 300 \
#          306 312 318 324 330 336 342 348 354 360 "

nhoursx=/nwprod/util/exec/ndate

#CDATE=2015102900
#COM=/com/gens/prod
COM=$NGLOBAL2/Bo.Cui/naefs.v5.0.0.bocui/com2/gens/para

ndays=1
iday=1

while [ $iday -le $ndays ]; do

  PDY=`echo $CDATE | cut -c1-8`
  cyc=`echo $CDATE | cut -c9-10`

  echo " day " $PDY$cyc

  ymdh=`$nhoursx -24 $CDATE`
  PDYm1=`echo ${ymdh} | cut -c1-8`
  ymdh=`$nhoursx -48 $CDATE`
  PDYm2=`echo ${ymdh} | cut -c1-8`

  COMIN=$COM/ecme.$PDY/$cyc

  echo " ECMWF pgrb2a    prod 0, para 3335; for 06z and 18z: 1 "
  ls $COMIN/pgrb2a/ | wc
  echo " "

  echo " ECMWF pgrb2a_bc prod 0, para 3471; for 06z and 18z: 0"
  ls $COMIN/pgrb2a_bc/ | wc
  echo " "

  echo " ECMWF ndgd_gb2  prod 0, para 722; for 06z and 18z: 2"
  ls $COMIN/ndgd_gb2 | wc
  echo " "

  iday=`expr $iday + 1`
  CDATE=`$nhoursx +06 $CDATE`

done


