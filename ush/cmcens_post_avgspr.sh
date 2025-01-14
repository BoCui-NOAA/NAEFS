#!/bin/sh
#############################################################################
# Script: cmcens_post_avgspr.sh
# Abstract: produces mean and spread of CMC raw ensemble forecast
# Author: Bo Cui ---- Feb. 2017
#############################################################################

set -x

pgm=ens_avgspr

######################################################
# start mean and spread calculation for each lead time
######################################################

for nfhrs in $hourlist; do

  if [ -s namin_avgspr_${nfhrs} ]; then
   rm namin_avgspr_${nfhrs}
  fi

  echo " &namens" >>namin_avgspr_${nfhrs}

  ifile=0

  for mem in $memberlist; do
    ifile_cmc=cmc_ge${mem}.t${cyc}z.pgrb2a.0p50.f${nfhrs} 
    if [ -s $COMOUT/${ifile_cmc} ]; then
      if [ "$mem" = "c00" ]; then
        iskip=1
      else
        (( ifile = ifile + 1 ))
        iskip=0
        echo " cfipg($ifile)='$COMOUT/${ifile_cmc}'," >>namin_avgspr_${nfhrs}
        echo " iskip($ifile)=${iskip},"               >>namin_avgspr_${nfhrs}
      fi
    fi
  done

  echo " nfiles=${ifile}," >>namin_avgspr_${nfhrs}
  echo " cfopg1='cmc_geavg.t${cyc}z.pgrb2a.0p50.f${nfhrs}'," >>namin_avgspr_${nfhrs}
  echo " cfopg2='cmc_gespr.t${cyc}z.pgrb2a.0p50.f${nfhrs}'," >>namin_avgspr_${nfhrs}
  echo " /" >>namin_avgspr_${nfhrs}

done

if [ -s poescript_avgspr ]; then
  rm poescript_avgspr
fi

for nfhrs in $hourlist; do
  echo "$EXECcmce/${pgm} <namin_avgspr_${nfhrs} > $pgmout.${nfhrs}_avgspr" >> poescript_avgspr
done

chmod +x poescript_avgspr
startmsg
$APRUN poescript_avgspr  
export err=$?;err_chk

if [ "$SENDCOM" = "YES" ]; then
  for nfhrs in $hourlist; do
    file=cmc_geavg.t${cyc}z.pgrb2a.0p50.f${nfhrs}
    if [ -s $file ]; then
      cpfs $file $COMOUT/
    fi
    file=cmc_gespr.t${cyc}z.pgrb2a.0p50.f${nfhrs}
    if [ -s $file ]; then
      cpfs $file $COMOUT/
    fi
  done
fi

set +x
echo " "
echo "Leaving sub script cmcens_post_avgspr.sh"
echo " "
set -x

