#export GADDIR=/usrx/local/grads/dat
##Hong Guan
export GADDIR=/usrx/local/GrADS/2.0.2/lib
export nhours=/nwprod/util/exec/ndate

export YMD=`echo $CDATE | cut -c1-8`
export CYC=`echo $CDATE | cut -c9-10`
export cyc=$CYC

hourlist=" 36 60 84 108 132 156 180 204 228 252 276 300 324 348 372"

#hourlist=" 36"

for nfhrs in $hourlist
do
   FHR=$nfhrs
   if [ $nfhrs -lt 108 ]; then
      export  FHR3d='0'$nfhrs
   else
      export  FHR3d=$nfhrs
   fi
   export  JDATE=`$nhours +$nfhrs $CDATE`
   export  PDY1=`echo $JDATE | cut -c1-8`
   export  cyc1=`echo $JDATE | cut -c9-10`
   export  MMDD=`echo $JDATE | cut -c5-8`

   FHR1=`expr $nfhrs - 24`

   rm -f *.ctl *idx

   cp /gpfs/hps/emc/ensemble/noscrub/emc.enspara1/Yan.Luo/com/naefs/dev/gefs.$YMD/$cyc/prcp_gb2/geprcp.t00z.pgrb2a.0p50.anvf$FHR3d geavg.t00z.pgrb2a.0p50_anvf$FHR3d
   cp /gpfs/hps/emc/ensemble/noscrub/emc.enspara1/Yan.Luo/com/naefs/dev/gefs.$YMD/$cyc/prcp_gb2/geprcp.t00z.pgrb2a.0p50.efif$FHR3d geavg.t00z.pgrb2a.0p50_efif$FHR3d
  rm -fr ccpa24.t12z.pgrb2a.0p50_anv  ccpa.t12z.24h.0p5.conus.gb2
   cp /ensemble/noscrub/Hong.Guan/ccpa/prod/ccpa.${PDY1}/${cyc1}/ccpa24.t12z.pgrb2a.0p50_anv .
   cp /ensemble/noscrub/Hong.Guan/ccpa/prod/ccpa.${PDY1}/${cyc1}/ccpa.t12z.24h.0p5.conus.gb2 .

   g2ctl -verf geavg.t00z.pgrb2a.0p50_anvf$FHR3d > geavg.t00z.pgrb2a.0p50_anvf${FHR3d}.ctl 
   gribmap -i   geavg.t00z.pgrb2a.0p50_anvf$FHR3d.ctl

   g2ctl  -verf geavg.t00z.pgrb2a.0p50_efif$FHR3d  > geavg.t00z.pgrb2a.0p50_efif${FHR3d}.ctl
   gribmap -i  geavg.t00z.pgrb2a.0p50_efif$FHR3d.ctl

   g2ctl  -verf ccpa24.t12z.pgrb2a.0p50_anv > ccpa24.t12z.pgrb2a.0p50_anv$FHR3d.ctl
   gribmap -i ccpa24.t12z.pgrb2a.0p50_anv$FHR3d.ctl

   g2ctl  -verf ccpa.t12z.24h.0p5.conus.gb2 > ccpa.t12z.24h.0p5.conus.gb2$FHR3d.ctl
   gribmap -i ccpa.t12z.24h.0p5.conus.gb2$FHR3d.ctl


   sed -e "s/test/$CDATE/" \
       -e "s/FHR1/$FHR1/" \
       -e "s/3d/${FHR3d}/" \
       -e "s/FHR/$FHR/" \
       -e "s/JDATE/$JDATE/" \
       -e "s/VAR/APCPsfc/" \
       -e "s/VA1/acp/" \
   plot_prcp_org.gs > plot_prcp.gs
   grads -bcl "run plot_prcp.gs"
   
   rm -fr *ctl *idx geavg*
done

RZDMDIR_html=/home/www/emc/htdocs/gmb/wd20hg/4vars_efianf

ftp -n << eof
verbos
open emcrzdm.ncep.noaa.gov
user wd20hg  passwrd
mkdir ${RZDMDIR_html}/${YMD}
mkdir ${RZDMDIR_html}/${YMD}/${CYC}
bi
prompt off
cd ${RZDMDIR_html}/${YMD}/${CYC}
mput *.gif
EOF
rm -fr *.gif
exit

ftp -n << eof
verbos
open emcrzdm.ncep.noaa.gov
user wd20hg  passwrd
bi
prompt
EOF

exit
