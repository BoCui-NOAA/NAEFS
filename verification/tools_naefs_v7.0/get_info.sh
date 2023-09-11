#!/bin/bash

export NAWIPS=/nwprod/gempak/nawips
. $NAWIPS/environ/gemenv.sh

#gdfile=$NAWIPS/gempak/data/hrcbob.grd
#gdfile=/com2/nawips/para/gefs.20151104/gep01_2015110400f000
#gdfile=/com2/nawips/para/naefs.20151104/ndgd90pt_2015110400f168
#gdfile=/com2/nawips/para/rtma2p5.20151104/rtma2p5_2015110400f000
#gdfile=/com/nawips/prod/gefs.20151108/gep01_2015110800f006
#gdfile=/u/Wen.Meng/noscrub2/naefs.v5.0.0/com2/nawips/para/ecme.20151029/bc/ecme_gep16_2015102900f330
#gdfile="GEFSPRD | 20151117/12 "
#gdfile=/u/Wen.Meng/noscrub2/naefs.v5.0.0/com2/nawips/para/fens.20151115/fnmoc_gep10_2015111500f096
#gdfile=/com/nawips/prod/gefs.20151129/bc/gep01bc_2015112900f384
#gdfile=/com/nawips/prod/rtma2p5.20151206/rtma2p5_2015120605f000
#gdfile=/com2/nawips/prod/naefs.20151206/ndgd_alaskageavg_2015120606f090
#gdfile=/com2/nawips/prod/naefs.20170105/ndgdgeavg_2017010506f384
gdfile=/gpfs/gp2/nco/ops/com/nawips/prod/gefs.20190729/gep16_0p50_2019072906f150                

gdinfo << end_input
GDFILE   =  $gdfile
 LSTALL   = y
 OUTPUT   = t
 GDATTIM  = all
 GLEVEL   = all
 GVCORD   = all
 GFUNC    = all
 run

 exit
end_input
