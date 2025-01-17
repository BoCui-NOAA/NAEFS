#!/bin/sh
############################################################################################
# CMC Ensemble Postprocessing               
# Function:
#   convert precipitation to 6h interval accumulations
#   convert precip accumulations to masks
#   create pgrba files and enspost
#
# AUTHOR: Bo Cui    (wx20cb)  
# History: March 2006 - Implementation of this new script. 
#           Sept 2004 - Yuejian Zhu - pqpf added
#           Sept 2004 - Richard Wobus - generate ensemble statistics file
#            Dec 2005 - new CMC ensemble forecast,384h forecast with 6h interval
#            Jun 2007 - CMC ensemble upgrad, member change from 16 to 20
#            Mar 2010 - update scripts for pgrba/enspost files after CMC new implementation
#            Mar 2017 - updated for post-processing grib2 data directly 
############################################################################################

export PS4='+ $SECONDS + '
set -x

##############################
# Define Script/Exec Variables
##############################

export ENSPOST_acct=$USHcmce/cmcens_post_acc.sh
export ENSPOST_stat=$USHcmce/cmcens_post_stat.sh
export ENSPOST_avgspr=$USHcmce/cmcens_post_avgspr.sh
export ENSPOST_ppf=$USHcmce/cmcens_post_pqpf_24h.sh

#####################################
# START TO DUMP DATA FOR $cycle CYCLE
#####################################

msg="Starting postprocessing for $cycle Ensemble memebers"
postmsg "$jlogfile" "$msg"

########################################
#  define ensemble members and lead time
########################################

if [ "$EXTDFCST" = "NO" ]; then
  export hourlist=" 000 003 006 009 012 015 018 021 024 027 030 033 036 039 042 045 048 \
                    051 054 057 060 063 066 069 072 075 078 081 084 087 090 093 096 099 \
                    102 105 108 111 114 117 120 123 126 129 132 135 138 141 144 147 150 \
                    153 156 159 162 165 168 171 174 177 180 183 186 189 192 198 204 \
                    210 216 222 228 234 240 246 252 258 264 270 276 282 288 294 300 \
                    306 312 318 324 330 336 342 348 354 360 366 372 378 384"
else
# export hourlist=" 000 003 006 009 012 015 018 021 024 027 030 033 036 039 042 045 048 \
#                   051 054 057 060 063 066 069 072 075 078 081 084 087 090 093 096 099 \
#                   102 105 108 111 114 117 120 123 126 129 132 135 138 141 144 147 150 \
#                   153 156 159 162 165 168 171 174 177 180 183 186 189 192 198 204 \
#                   210 216 222 228 234 240 246 252 258 264 270 276 282 288 294 300 \
#                   306 312 318 324 330 336 342 348 354 360 366 372 378 384         \
#                   390 396 402 408 414 420 426 432 438 444 450 456 462 468 474 480 \
#                   486 492 498 504 510 516 522 528 534 540 546 552 558 564 570 576 \
#                   582 588 594 600 606 612 618 624 630 636 642 648 654 660 666 672 \
#                   678 684 690 696 702 708 714 720 726 732 738 744 750 756 762 768 "
  export hourlist=" 390 396 402 408 414 420 426 432 438 444 450 456 462 468 474 480 \
                    486 492 498 504 510 516 522 528 534 540 546 552 558 564 570 576 \
                    582 588 594 600 606 612 618 624 630 636 642 648 654 660 666 672 \
                    678 684 690 696 702 708 714 720 726 732 738 744 750 756 762 768 "
fi
  
export memberlist="p01 p02 p03 p04 p05 p06 p07 p08 p09 p10 \
                   p11 p12 p13 p14 p15 p16 p17 p18 p19 p20 c00"

if [ $cyc -eq 00 -o $cyc -eq 12 ]; then

##########################################
# Step 0: check if all files are available
##########################################

  icnt=0
  while [ $icnt -le 30 ]; do
    ifile=0
    tfile=0
    for nfhrs in $hourlist; do
      for mem in $memberlist; do
        (( tfile = tfile + 1 ))
        cmcmem=`echo $mem | cut -c2-3`
        ifile_cmc=$COMIN/${PDY}${cyc}_CMC_naefs_hr_latlon0p5x0p5_P${nfhrs}_0${cmcmem}.grib2
        if [ -s $ifile_cmc ]; then
          (( ifile = ifile + 1 ))
        fi
      done
    done
    if [ $tfile -eq $ifile ]; then
      icnt=31
    else
      sleep 30
      icnt=`expr $icnt + 1`
    fi
  done

  icnt=0
  for nfhrs in $hourlist; do
    for mem in $memberlist; do
      cmcmem=`echo $mem | cut -c2-3`
      ifile_cmc=$COMIN/${PDY}${cyc}_CMC_naefs_hr_latlon0p5x0p5_P${nfhrs}_0${cmcmem}.grib2
      if [ ! -s $ifile_cmc ]; then
        echo "File $ifile_cmc is missing "
        icnt=`expr $icnt + 1`
      fi
    done
  done

  # if [ $icnt -ge 180 ]; then
  if [ $icnt -ge 1 ]; then
    echo "ERROR: totally $icnt CMC files missing, please wait until they are available and rerun this job"
    err_exit
  fi

##############################################################
# Step 1: Delete accumulated variables from raw ensemble files  
##############################################################

  for nfhrs in $hourlist; do
    if [ -s poe_separate.${nfhrs} ]; then rm poe_separate.${nfhrs}; fi
    for mem in $memberlist; do
      cmcmem=`echo $mem | cut -c2-3`
      ifile_cmc=$COMIN/${PDY}${cyc}_CMC_naefs_hr_latlon0p5x0p5_P${nfhrs}_0${cmcmem}.grib2  
      ifile_part1=${PDY}${cyc}_CMC_naefs_hr_latlon0p5x0p5_P${nfhrs}_0${cmcmem}.grib2_part1
      ifile_part2=${PDY}${cyc}_CMC_naefs_hr_latlon0p5x0p5_P${nfhrs}_0${cmcmem}.grib2_part2
      if [ -s $ifile_cmc ]; then
        echo "$WGRIB2 $ifile_cmc -if \"acc fcst\" -grib $ifile_part2 \
                           -not_if \"acc fcst\" -grib $ifile_part1" >>poe_separate.${nfhrs}
      else
        echo "echo "no file of" $ifile_cmc "                        >>poe_separate.${nfhrs}
      fi
    done
  done

  if [ -s poescript_wgrib ]; then
    rm poescript_wgrib
  fi

  for nfhrs in $hourlist; do
    chmod +x poe_separate.${nfhrs}
    echo ". ./poe_separate.${nfhrs}" >>poescript_wgrib
  done

  chmod +x poescript_wgrib
  startmsg
  $APRUN poescript_wgrib
  export err=$?;err_chk

##########################################################
# Step 2: Generate Prcp & Flux Variables for every 6 hours
##########################################################
 
  $ENSPOST_acct

########################################################
# Step 3: Combine prcp/flux file with raw files together
########################################################

  for nfhrs in $hourlist; do
    if [ -s poe_cat.${nfhrs} ]; then rm poe_cat.${nfhrs}; fi
    for mem in $memberlist; do
      cmcmem=`echo $mem | cut -c2-3`
      ifile1=CMC_naefs_hr_latlon0p5x0p5_P${nfhrs}_0${cmcmem}_acc
      ifile2=${PDY}${cyc}_CMC_naefs_hr_latlon0p5x0p5_P${nfhrs}_0${cmcmem}.grib2_part1
      ofile=cmc_ge${mem}.t${cyc}z.pgrb2a.0p50.f$nfhrs
      if [ -s $COMOUT/$ofile ]; then
        rm $COMOUT/$ofile
      fi
      if [ -s $ifile1 -a -s $ifile2 ]; then
        echo "cat $ifile1 $ifile2 >> $COMOUT/$ofile"     >>poe_cat.${nfhrs}
      elif [ ! -s $ifile1 -a -s $ifile2 ]; then
        echo "cp $ifile2           $COMOUT/$ofile"       >>poe_cat.${nfhrs}
      elif [ ! -s $ifile2 -a -s $ifile1 ]; then
        echo "cp $ifile1           $COMOUT/$ofile"       >>poe_cat.${nfhrs}
      elif [ ! -s $ifile2 -a ! -s $ifile1 ]; then
        echo "echo \"$ifile1 and $ifile2 both missing\"" >>poe_cat.${nfhrs}
      fi
    done
  done

  if [ -s poescript_cat ]; then
    rm poescript_cat
  fi

  for nfhrs in $hourlist; do
    chmod +x poe_cat.${nfhrs}
    echo ". ./poe_cat.${nfhrs}" >>poescript_cat
  done

  chmod +x poescript_cat
  startmsg
  $APRUN poescript_cat
  export err=$?;err_chk

######################################
# Step 4: generate ens mean and spread
######################################

  $ENSPOST_avgspr

####################################################################
#  move event flag here, so gempak job will get cmc_geavg grib data
####################################################################

  ecflow_client --event release_debias


  if [ $SENDDBN_GB2 = YES ]; then
    for nfhrs in $hourlist; do
      if [ -s poe_idx.${nfhrs} ]; then rm poe_idx.${nfhrs}; fi
      ifile_avg=cmc_geavg.t${cyc}z.pgrb2a.0p50.f${nfhrs}
      echo "$WGRIB2 $COMOUT/${ifile_avg} -s > $COMOUT/${ifile_avg}.idx"  >>poe_idx.${nfhrs}
      ifile_spr=cmc_gespr.t${cyc}z.pgrb2a.0p50.f${nfhrs}
      echo "$WGRIB2 $COMOUT/${ifile_spr} -s > $COMOUT/${ifile_spr}.idx"  >>poe_idx.${nfhrs}
      for mem in $memberlist; do
        ifile_mem=cmc_ge${mem}.t${cyc}z.pgrb2a.0p50.f${nfhrs}
        echo "$WGRIB2 $COMOUT/${ifile_mem} -s > $COMOUT/${ifile_mem}.idx" >>poe_idx.${nfhrs}
      done
    done

    if [ -s poescript_idx ]; then
      rm poescript_idx
    fi

    for nfhrs in $hourlist; do
      chmod +x poe_idx.${nfhrs}
      echo ". ./poe_idx.${nfhrs}" >>poescript_idx
    done

    chmod +x poescript_idx
    startmsg
    $APRUN poescript_idx
  fi

  if [ $SENDDBN_GB2 = YES ]; then
    for nfhrs in $hourlist; do
      ifile_avg=cmc_geavg.t${cyc}z.pgrb2a.0p50.f${nfhrs}

      echo "$DBNROOT/bin/dbn_alert MODEL NAEFS_CMCENS_PGBA_GB2      $job $COMOUT/${ifile_avg}"     >>poe_alert.${nfhrs} 
      echo "$DBNROOT/bin/dbn_alert MODEL NAEFS_CMCENS_PGBA_GB2_WIDX $job $COMOUT/${ifile_avg}.idx" >>poe_alert.${nfhrs} 

      ifile_spr=cmc_gespr.t${cyc}z.pgrb2a.0p50.f${nfhrs}
      echo "$DBNROOT/bin/dbn_alert MODEL NAEFS_CMCENS_PGBA_GB2      $job $COMOUT/${ifile_spr}"     >>poe_alert.${nfhrs} 
      echo "$DBNROOT/bin/dbn_alert MODEL NAEFS_CMCENS_PGBA_GB2_WIDX $job $COMOUT/${ifile_spr}.idx" >>poe_alert.${nfhrs} 

      for mem in $memberlist; do
        ifile_mem=cmc_ge${mem}.t${cyc}z.pgrb2a.0p50.f${nfhrs}
        echo "$DBNROOT/bin/dbn_alert MODEL NAEFS_CMCENS_PGBA_GB2    $job $COMOUT/${ifile_mem}"     >>poe_alert.${nfhrs}
        echo "$DBNROOT/bin/dbn_alert MODEL NAEFS_CMCENS_PGBA_GB2_WIDX    $job $COMOUT/${ifile_mem}.idx"     >>poe_alert.${nfhrs}
      done
    done

  if [ -s poescript_alert ]; then
    rm poescript_alert
  fi

  for nfhrs in $hourlist; do
    chmod +x poe_alert.${nfhrs}
    echo ". ./poe_alert.${nfhrs}" >>poescript_alert
  done

  chmod +x poescript_alert
  startmsg
  $APRUN poescript_alert

  fi
## move up earlier to release the gempak job sooner - 05/14/2018 - JY
#####################################################################
##  move event flag here, so gempak job will get cmc_geavg grib data
#####################################################################

#  ecflow_client --event release_debias

  if [ "$EXTDFCST" = "NO" ]; then

############################################
# Step 5: Generate enspost and ensstat files
############################################
    $ENSPOST_stat   
###########################
# Step 6: Generate CMC PQPF                       
###########################

    if [ $cyc -eq 00 ]; then
      $ENSPOST_ppf enspostc.t${cyc}z.prcphr ensppf.$PDY$cyc
      if [ $SENDCOM = "YES" ]; then
        if [ -s ensppf.$PDY$cyc ]; then
          cp ensppf.$PDY$cyc $COMOUTenst/ensstatc.$cycle.pqpfhr_24h
       fi
      fi
    fi

    cat $pgmout.003.p10
    cat $pgmout.024.p12
    cat $pgmout.024.c00
    cat $pgmout.039_avgspr
    cat $pgmout.120_avgspr

  else

    cat $pgmout.540.p10
    cat $pgmout.768.p12
    cat $pgmout.540_avgspr
    cat $pgmout.768_avgspr

  fi

fi

################################################################
# Step 7: Start Processing CMC Analysis at 00z, 06z, 12z and 18z
################################################################

if [ "$ANAPRDGEN" = "YES" ]; then
  if [ "$SENDCOM" = "YES" ]; then
    infile=${PDYm1}${cyc}_CMC_naefs_latlon0p5x0p5_000_ana.grib2
    outfile=cmc_gec00.t${cyc}z.pgrb2a.0p50.anl   
    if [ -s $COMINm1/$infile ]; then
      cp $COMINm1/$infile  $COMOUTm1/$outfile                          
      $WGRIB2 -s $COMINm1/$infile > $COMOUTm1/$outfile.idx 
    fi
  fi
fi

msg="HAS COMPLETED NORMALLY!"
postmsg "$jlogfile" "$msg"

exit 0
