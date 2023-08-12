#Hong Guan 07/16/2023 
export CDATE

if [ "$id" = "naefs" ]; then
   px=naefs_
   ID=NAEFS
elif [ "$id" = "ecmwf" ]; then
   px=ecmwf_
else
   px=
   ID=GEFS
fi

export YMD=`echo $CDATE | cut -c1-8`
export CYC=`echo $CDATE | cut -c9-10`
export cyc=$CYC

YMD000=$YMD

export YMDM1=`$NDATE -24 $CDATE`
export YMDM1=`echo $YMDM1 | cut -c1-8`

export YMDM2=`$NDATE -48 $CDATE`
export YMDM2=`echo $YMDM2 | cut -c1-8`

export YMDM3=`$NDATE -72 $CDATE`
export YMDM3=`echo $YMDM3 | cut -c1-8`

export YMDM4=`$NDATE -96 $CDATE`
export YMDM4=`echo $YMDM4 | cut -c1-8`

export YMDM5=`$NDATE -120 $CDATE`
export YMDM5=`echo $YMDM5 | cut -c1-8`

export YMDM6=`$NDATE -144 $CDATE`
export YMDM6=`echo $YMDM6 | cut -c1-8`

export YMDM7=`$NDATE -168 $CDATE`
export YMDM7=`echo $YMDM7 | cut -c1-8`

export YMDM8=`$NDATE -192 $CDATE`
export YMDM8=`echo $YMDM8 | cut -c1-8`

export YMDM9=`$NDATE -216 $CDATE`
export YMDM9=`echo $YMDM9 | cut -c1-8`

export YMDM10=`$NDATE -240 $CDATE`
export YMDM10=`echo $YMDM10 | cut -c1-8`

export YMDM11=`$NDATE -264 $CDATE`
export YMDM11=`echo $YMDM11 | cut -c1-8`

export YMDM12=`$NDATE -288 $CDATE`
export YMDM12=`echo $YMDM12 | cut -c1-8`

export YMDM13=`$NDATE -312 $CDATE`
export YMDM13=`echo $YMDM13 | cut -c1-8`

export YMDM14=`$NDATE -336 $CDATE`
export YMDM14=`echo $YMDM14 | cut -c1-8`

   sed -e "s/YMD/$YMD/"               \
       -e "s/CYC/$cyc/"         \
       -e "s/CDATE/$CDATE/"         \
   $HOMEplot/slp.t${cyc}z_org.html > slp.t${cyc}z.html

   sed -e "s/YMD/$YMD/"               \
       -e "s/CYC/$cyc/"         \
       -e "s/CDATE/$CDATE/"         \
   $HOMEplot/t2m.t${cyc}z_org.html > t2m.t${cyc}z.html

   sed -e "s/YMD/$YMD/"               \
       -e "s/CYC/$cyc/"         \
       -e "s/CDATE/$CDATE/"         \
   $HOMEplot/w10.t${cyc}z_org.html > w10.t${cyc}z.html

   sed -e "s/YMD/$YMD/"               \
       -e "s/CYC/$cyc/"         \
       -e "s/CDATE/$CDATE/"         \
       -e "s/naefs_ver/${naefs_ver}/"         \
   $HOMEplot/acp.t${cyc}z_org.html > acp.t${cyc}z.html

hourlist=" 36"
hourlist=" 36 60 84 108 132 156 180"
hourlist=" 36 60 84 108 132 156 180 204 228 252 276 300 324 348 372"

if [ "$id" = "gefs" ]; then

for nfhrs in $hourlist
do
   FHR=$nfhrs
   if [ $nfhrs -lt 108 ]; then
      export  FHR3d='0'$nfhrs
   else
      export  FHR3d=$nfhrs
   fi
   export  JDATE=`$NDATE +$nfhrs $CDATE`
   export  PDY1=`echo $JDATE | cut -c1-8`
   export  cyc1=`echo $JDATE | cut -c9-10`
   export  MMDD=`echo $JDATE | cut -c5-8`

   FHR1=`expr $nfhrs - 24`

   rm -f *.ctl *idx ccpa24*

   COMIN=$COMROOT/naefs/${naefs_ver}/${id}.$YMD/$cyc/prcp_bc_gb2
   cp $COMIN/${px}geprcp.t00z.pgrb2a.0p50.anvf$FHR3d geavg.t00z.pgrb2a.0p50_anvf$FHR3d
   cp $COMIN/${px}geprcp.t00z.pgrb2a.0p50.efif$FHR3d geavg.t00z.pgrb2a.0p50_efif$FHR3d

   COMIN=$COMROOT/naefs/v7.0/gefs.$PDY1/$cyc/pgrb2ap5_ana
   cp $COMIN/geprcp.t00z.pgrb2a.0p50.anaf000 ccpa24.t12z.pgrb2a.0p50_anv

   g2ctl -verf geavg.t00z.pgrb2a.0p50_anvf$FHR3d > geavg.t00z.pgrb2a.0p50_anvf${FHR3d}.ctl 
   gribmap -i   geavg.t00z.pgrb2a.0p50_anvf$FHR3d.ctl

   g2ctl  -verf geavg.t00z.pgrb2a.0p50_efif$FHR3d  > geavg.t00z.pgrb2a.0p50_efif${FHR3d}.ctl
   gribmap -i  geavg.t00z.pgrb2a.0p50_efif$FHR3d.ctl

   g2ctl -verf  ccpa24.t12z.pgrb2a.0p50_anv > ccpa24.t12z.pgrb2a.0p50_anv$FHR3d.ctl
   gribmap -i ccpa24.t12z.pgrb2a.0p50_anv$FHR3d.ctl

#  g2ctl  -verf ccpa.t12z.24h.0p5.conus.gb2 > ccpa.t12z.24h.0p5.conus.gb2$FHR3d.ctl
#  gribmap -i ccpa.t12z.24h.0p5.conus.gb2$FHR3d.ctl

   if [ -s ccpa24.t12z.pgrb2a.0p50_anv$FHR3d.ctl ]; then

   sed -e "s/test/$CDATE/" \
       -e "s/FHR1/$FHR1/" \
       -e "s/3d/${FHR3d}/" \
       -e "s/FHR/$FHR/" \
       -e "s/JDATE/$JDATE/" \
       -e "s/VAR/APCPsfc/" \
       -e "s/VA1/acp/" \
       -e "s/ID/${ID}/" \
       -e "s/VER/${naefs_ver}/" \
   $HOMEplot/plot_prcp_org.gs > plot_prcp.gs
   grads -bcl "plot_prcp.gs"
   
   fi
   rm -fr *ctl *idx ccpa24*
done
fi

#hourlist="06  12 24 36 48 60 72 84 96 108 120 132 144 156 168 180 192 204 216 228 240 252 264 276 288 300 312 324 336 348 360 372 384"
hourlist="  24 48 72 96 120 144"
hourlist="  24"
hourlist="  24 48 72 96 120 144 168 192 216 240 264 288 312 336 360 384"

for nfhrs in $hourlist
do
   FHR=$nfhrs
   if [ $nfhrs -lt 100 ]; then
      export  FHR3d='0'$nfhrs
   else
      export  FHR3d=$nfhrs
   fi
   export  JDATE=`$NDATE +$nfhrs $CDATE`
   export  PDY1=`echo $JDATE | cut -c1-8`
   export  cyc1=`echo $JDATE | cut -c9-10`
   export  MMDD=`echo $JDATE | cut -c5-8`

   FHR1=`expr $nfhrs - 24`
   if [ ${FHR1} -lt 6 ]; then
      export  FHR1='00'
   fi

   rm -f *.ctl *idx geavg*

   COMIN=$COMROOT/naefs/${naefs_ver}/${id}.$YMD/$cyc/pgrb2ap5_an
   cp $COMIN/${px}geavg.t00z.pgrb2a.0p50_anf$FHR3d geavg.t00z.pgrb2a.0p50_anvf$FHR3d
   cp $COMIN/${px}geefi.t00z.pgrb2a.0p50_bcf$FHR3d geavg.t00z.pgrb2a.0p50_efif$FHR3d

   COMIN=$COMROOT/naefs/v7.0/gefs.$PDY1/$cyc1/pgrb2ap5_ana
   cp $COMIN/geavg.t00z.pgrb2a.0p50_anaf000 geavg.t00z.pgrb2a.0p50_ana

   g2ctl -verf geavg.t00z.pgrb2a.0p50_anvf$FHR3d > geavg.t00z.pgrb2a.0p50_anvf${FHR3d}.ctl 
   gribmap -i   geavg.t00z.pgrb2a.0p50_anvf$FHR3d.ctl

   g2ctl -verf geavg.t00z.pgrb2a.0p50_efif$FHR3d > geavg.t00z.pgrb2a.0p50_efif${FHR3d}.ctl 
   gribmap -i   geavg.t00z.pgrb2a.0p50_efif$FHR3d.ctl

   g2ctl -verf geavg.t00z.pgrb2a.0p50_ana    > geavg.t00z.pgrb2a.0p50_ana.ctl 
   gribmap -i   geavg.t00z.pgrb2a.0p50_ana.ctl

   if [ -s geavg.t00z.pgrb2a.0p50_ana.ctl ]; then
    sed -e "s/test/$CDATE/" \
        -e "s/FHR1/$FHR1/" \
        -e "s/3d/${FHR3d}/" \
        -e "s/FHR/$FHR/" \
        -e "s/JDATE/$JDATE/" \
        -e "s/VAR/TMP2M/" \
        -e "s/VA1/t2m/" \
        -e "s/ID/${ID}/" \
        -e "s/VER/${naefs_ver}/" \
    $HOMEplot/plot_2vars_org.gs > plot_3vars.gs
    grads -bcl "plot_3vars.gs"

    sed -e "s/test/$CDATE/" \
        -e "s/FHR1/$FHR1/" \
        -e "s/3d/${FHR3d}/" \
        -e "s/FHR/$FHR/" \
        -e "s/JDATE/$JDATE/" \
        -e "s/VAR/WIND10M/" \
        -e "s/VA1/w10/" \
        -e "s/ID/${ID}/" \
        -e "s/VER/${naefs_ver}/" \
    $HOMEplot/plot_1var_org.gs > plot_3vars.gs
    grads -bcl "plot_3vars.gs"

    sed -e "s/test/$CDATE/" \
        -e "s/FHR1/$FHR1/" \
        -e "s/3d/${FHR3d}/" \
        -e "s/FHR/$FHR/" \
        -e "s/JDATE/$JDATE/" \
        -e "s/VAR/PRMSLmsl/" \
        -e "s/VA1/slp/" \
        -e "s/ID/${ID}/" \
        -e "s/VER/${naefs_ver}/" \
    $HOMEplot/plot_2vars_org.gs > plot_3vars.gs

    grads -bcl "plot_3vars.gs"

   fi

   rm -fr *.ctl *idx  geavg.t00z.pgrb2a.*
done

sed -e "s/YMD000/$YMD000/"         \
    -e "s/YMDM1/$YMDM1/"         \
    -e "s/YMDM2/$YMDM2/"         \
    -e "s/YMDM3/$YMDM3/"         \
    -e "s/YMDM4/$YMDM4/"         \
    -e "s/YMDM5/$YMDM5/"         \
    -e "s/YMDM6/$YMDM6/"         \
    -e "s/YMDM7/$YMDM7/"         \
    -e "s/YMDM8/$YMDM8/"         \
    -e "s/YMDM9/$YMDM9/"         \
    -e "s/YMDM0010/$YMDM10/"         \
    -e "s/YMDM01/$YMDM11/"         \
    -e "s/YMDM02/$YMDM12/"         \
    -e "s/YMDM03/$YMDM13/"         \
    -e "s/YMDM04/$YMDM14/"         \
$HOMEplot/EFIANF_org.html > EFIANF.html

#dir_main=/home/people/emc/www/htdocs/gmb/wx20cb/naefs.v7.0.0/4vars_efianf  
                  
ssh -l bocui emcrzdm "mkdir -p ${dir_main}/${YMD}"
ssh -l bocui emcrzdm "mkdir -p ${dir_main}/${YMD}/${CYC}"
ssh -l bocui emcrzdm "cp ${dir_main}/al* ${dir_main}/${YMD}"
ssh -l bocui emcrzdm "cp ${dir_main}/in* ${dir_main}/${YMD}"
ssh -l bocui emcrzdm "cp ${dir_main}/al* ${dir_main}/${YMD}/${CYC}"
ssh -l bocui emcrzdm "cp ${dir_main}/in* ${dir_main}/${YMD}/${CYC}"
scp *.png      bocui@emcrzdm:${dir_main}/${YMD}/${CYC}
scp *.html     bocui@emcrzdm:${dir_main}/${YMD}/${CYC}

