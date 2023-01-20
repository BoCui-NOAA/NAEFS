SDATE=2011070100
ndays=31
iday=1

COM=$NGLOBAL/wx20cb/BMA/vrfy

varlist="P850TMP P2MTMP P10MUGRD P10MVGRD"
varlist="P2MTMP"

for VFIELD in $varlist; do

  rm print_${VFIELD}
  >print_${VFIELD}

  CDATE=$SDATE          
  iday=1

  while [ $iday -le $ndays ]; do

    echo $CDATE >> print_${VFIELD}

#   cat $COM/${VFIELD}20Nrb_wNOf.$CDATE  | sed -n "124,124p" >> print_${VFIELD}
#   cat $COM/${VFIELD}20Nrb_wYESf.$CDATE  | sed -n "124,124p" >> print_${VFIELD}

#   cat $COM/${VFIELD}20Nrb_wYES_addwf.$CDATE  | sed -n "124,124p" >> print_${VFIELD}
#   cat $COM/${VFIELD}20Nbb_wNOf.$CDATE | sed -n "124,124p" >> print_${VFIELD}
#   cat $COM/${VFIELD}20Nbb_wYESf.$CDATE | sed -n "124,124p" >> print_${VFIELD}
#   cat $COM/${VFIELD}20Nbb_wYES_sdk_skf.$CDATE | sed -n "124,124p" >> print_${VFIELD}

#   cat $COM/${VFIELD}40NAb_prodf.$CDATE | sed -n "124,124p" >> print_${VFIELD}
#   cat $COM/${VFIELD}40NAbb_wNOf.$CDATE | sed -n "124,124p" >> print_${VFIELD}
    cat $COM/${VFIELD}40NAbb_wYESf.$CDATE | sed -n "124,124p" >> print_${VFIELD}
#   cat $COM/${VFIELD}60NUbb_wNOf.$CDATE | sed -n "124,124p" >> print_${VFIELD}
    cat $COM/${VFIELD}60NUbb_wYESf.$CDATE | sed -n "124,124p" >> print_${VFIELD}



    echo "    " >> print_${VFIELD}

    iday=`expr $iday + 1`
    export CDATE=`$nhours +24 $CDATE`

  done
done
