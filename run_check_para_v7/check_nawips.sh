#CDATE=$1
ndays=1
iday=1

#COM=/lfs/h2/emc/ptmp/Bo.Cui/com/nawips/prod

while [ $iday -le $ndays ]; do

  PDY=`echo $CDATE | cut -c1-8`
  cyc=`echo $CDATE | cut -c9-10`

  echo " day " $PDY$cyc
  echo " "

  ymdh=`$NDATE -24 $CDATE`
  PDYm1=`echo ${ymdh} | cut -c1-8`
  ymdh=`$NDATE -48 $CDATE`
  PDYm2=`echo ${ymdh} | cut -c1-8`

  COMIN=$COM/cmce.$PDY/gempak
  echo " dir CMCE prod 2860 (22*130) para 4268(194*22), 2134 for 00z "
  ls $COMIN | grep -v "pnaefs" | wc
  echo " "

  COMIN=$COM/gefs.$PDY/gempak
  echo " dir GEFS para anv me mecom gfsme, 96/60 for one cycle"
  echo " dir GEFS para 384 384 384 240    "
  ls $COMIN/geavganv*   | grep -v "pnaefs" | wc
  ls $COMIN/geavgme_*   | grep -v "pnaefs" | wc
  ls $COMIN/geavgmecom* | grep -v "pnaefs" | wc
  ls $COMIN/gegfsme*    | grep -v "pnaefs" | wc
  echo " "

  echo " dir GEFS/an para 13040 (3260 for one cycle) "
  ls $COMIN/an          | grep -v "pnaefs" | wc
  echo " "

output="$( bash <<EOF
  ls $COMIN/an | wc -l
EOF
)"
  if [ $output -ne 13040 -a $output -ne 3260 -a $output -ne 6520 -a $output -ne 9780 ]; then
    echo $PDY$cyc
    echo "Warning !!! GEFS an has gempak files 260/6520/9780/13040"
    echo $output
  fi

  echo " dir GEFS/bc para 14576 (3644/cycle) "
  ls $COMIN/bc          | grep -v "pnaefs" | wc
  echo " "

output="$( bash <<EOF
  ls $COMIN/bc | wc -l
EOF
)"
  if [ $output -ne 14576 -a $output -ne 3644 -a $output -ne 7288 -a $output -ne 10932 ]; then
    echo $PDY$cyc
    echo "Warning !!! GEFS bc has gempak files 3644/7288/10932/14576"
    echo $output
    echo " "
   fi

  COMIN=$COM/naefs.$PDY/gempak
  echo " dir NAEFS para 3456 (864/cycle) "
  ls $COMIN/ge*         | grep -v "pnaefs" | wc
  echo " "

output="$( bash <<EOF
  ls $COMIN/ge* | wc -l
EOF
)"
  if [ $output -ne 3456 -a $output -ne 864 -a $output -ne 1728 -a $output -ne 2592 ]; then
    echo $PDY$cyc
    echo "Warning !!! NAEFS has gempak files 864/1728/2592/3456"
    echo $output
  fi

  echo " dir naefs para ndgd* 4608 (1152/cycle) "
  ls $COMIN/ndgd*       | grep -v "pnaefs" | wc
  echo " "

output="$( bash <<EOF
  ls $COMIN/ndgd*       | grep -v "pnaefs" | wc
EOF
)"
  if [ $output -ne 1152 -a $output -ne 2304 -a $output -ne 3456 -a $output -ne 4608 ]; then
    echo $PDY$cyc
    echo "Warning !!! NAEFS ndgd has gempak files 1152/2304/3456/4608"
    echo $output
  fi

  COMIN=$COM/fens.$PDY/gempak
  echo " dir FNMOC para 3880, 1940 for 00z only "
  ls $COMIN             | grep -v "pnaefs" | wc
  echo " "

output="$( bash <<EOF
  ls $COMIN | wc -l
EOF
)"
  if [ $output -ne 3880 -a $output -ne 1940 ]; then
    echo $PDY$cyc
    echo "Warning !!! FNMOC has gempak files 3880 or 1940"
    echo $output
  fi

  echo " "
  COMIN=$COM/gefs.$PDY/gempak/prcp
  echo " dir prcp 2732, 683 for one cycle only "
  ls $COMIN | wc -l    
  echo " "

output="$( bash <<EOF
  ls $COMIN | wc -l
EOF
)"
  if [ $output -ne 2732 -a $output -ne 683 -a $output -ne 1366 -a $output -ne 2049 ]; then
    echo $PDY$cyc
    echo "Warning !!! prcp has gempak files 2732 or 683 or 1366 or 2049"
    echo $output
  fi

  iday=`expr $iday + 1`
  CDATE=`$NDATE +06 $CDATE`

done


