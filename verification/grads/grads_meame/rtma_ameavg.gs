'open naefs_geavg.ndgd_ame.ctl'
'open gefs_raw_geavg.ndgd_ame.ctl'
'open gefs_drbcds_geavg.ndgd_ame.ctl'

*isvar=1
*ievar=8
isvar=ISVAR
ievar=IEVAR
ivar=isvar
while (ivar<=ievar)
var=getvar(ivar)
lev=getlev(ivar)
maxtop=getmaxtop(ivar)
minbot=getminbot(ivar)
fld=getfld(ivar)
txt=gettxt(ivar)
ytxt=getytxt(ivar)

regs=5
rege=5
reg=regs
while (reg<=rege)
titreg=getreg(reg)
greg=getgreg(reg)
*lats=getlats(reg)
*late=getlate(reg)

'set display color white'
'clear'

*grfile=''greg''fld'_bias_die.gr'
grfile='rtma_'fld'_bias_die_CYC.gr'
say grfile
'enable print 'grfile
'reset'
'set vpage 0.0 11.0 0.6 8.5'
'set grads off'

'set vrange 'minbot' 'maxtop''
'set ccolor 1'
'set cmark 1'
'set xlab  off'
'set x 1'
'set y 1'
'set z 'lev''
'set t 1 NDAYS'
*'d tloop(aave(abs('var'),lon=LONS,lon=LONE,lat=LATS,lat=LATE))'
'set missconn on'
'd tloop(aave(abs('var'),x=1,x=XDEF,y=1,y=YDEF))'

'set ccolor 2'
'set cmark 2'
'set missconn on'
*'d tloop(aave(abs('var'.2),lon=LONS,lon=LONE,lat=LATS,lat=LATE))'
'd tloop(aave(abs('var'.2),x=1,x=XDEF,y=1,y=YDEF))'

'set ccolor 3'
'set cmark 3'
'set missconn on'
*'d tloop(aave(abs('var'.3),lon=LONS,lon=LONE,lat=LATS,lat=LATE))'
'd tloop(aave(abs('var'.3),x=1,x=XDEF,y=1,y=YDEF))'

'set xlab  off'
'set x 1 31'
'set y 1'      
'set z 1'
'set t 1'

'draw title 'titreg' 'txt' \ Averaged From SDY to EDY'
'draw xlab Lead Time (Days)'
*'draw ylab Mean Absolute Error'
'draw ylab 'ytxt' '
days=drawds(LABDAYS)

*'run linesmpos.gs leg_rms_lines 6.9 1.5 10.3 3.5'
'run linesmpos.gs leg_rms_lines 2.3 5.9 4.4 7.2'

'set string 4'
'set strsiz 0.10'
'draw string 7.8 0.09 BO CUI, GCWMB/EMC/NCEP/NOAA'
'print'
*'printim rtma_'fld'_bias_die_CYC.gif '
'disable print'
'c'

*say 'type in c to continue or quit to exit'
*pull corquit
*corquit

reg=reg+1
endwhile

ivar=ivar+1
endwhile

'quit'

function getreg(reg)
if(reg=1);titreg='NH';endif;
if(reg=2);titreg='SH';endif;
if(reg=3);titreg='TROPICS';endif;
if(reg=4);titreg='GLOBAL';endif;
if(reg=5);titreg='RTMA CONUS Region';endif;
if(reg=6);titreg='RTMA Alaska Region';endif;
return titreg

function getgreg(reg)
if(reg=1);greg='nh';endif;
if(reg=2);greg='sh';endif;
if(reg=3);greg='tr';endif;
if(reg=4);greg='global';endif;
if(reg=5);greg='rtma';endif;
if(reg=6);greg='rtma';endif;
return greg

function getlats(reg)
if(reg=1);lats=20;endif;
if(reg=2);lats=-80;endif;
if(reg=3);lats=-20;endif;
if(reg=4);lats=-90;endif;
return lats

function getlate(reg)
if(reg=1);late=80;endif;
if(reg=2);late=-20;endif;
if(reg=3);late=20;endif;
if(reg=4);late=90;endif;
return late

function getmaxtop(ivar)
if(ivar=1);maxtop=1400;endif;
if(ivar=2);maxtop=5.0;endif;
if(ivar=3);maxtop=4.0;endif;
if(ivar=4);maxtop=4.0;endif;
if(ivar=5);maxtop=3.5;endif;
if(ivar=6);maxtop=100;endif;
if(ivar=7);maxtop=4.0;endif;
if(ivar=8);maxtop=4.0;endif;
if(ivar=9);maxtop=6.0;endif;
if(ivar=10);maxtop=25.0;endif;
return maxtop

function getminbot(ivar)
if(ivar=1);minbot=0;endif;
if(ivar=2);minbot=0;endif;
if(ivar=3);minbot=0;endif;
if(ivar=4);minbot=0;endif;
if(ivar=5);minbot=0;endif;
if(ivar=6);minbot=0;endif;
if(ivar=7);minbot=0;endif;
if(ivar=8);minbot=0;endif;
if(ivar=9);minbot=0;endif;
if(ivar=10);minbot=0;endif;
return minbot

function getvar(ivar)
if(ivar=1);var='pressfc';endif;
if(ivar=2);var='tmp2m';endif;
if(ivar=3);var='ugrd10m';endif;
if(ivar=4);var='vgrd10m';endif;
if(ivar=5);var='wind10m';endif;
if(ivar=6);var='wdir10m';endif;
if(ivar=7);var='tmax2m';endif;
if(ivar=8);var='tmin2m';endif;
if(ivar=9);var='dpt2m';endif;
if(ivar=10);var='rh2m';endif;
return var

function getlev(ivar)
if(ivar=1);lev=0;endif;
if(ivar=2);lev=0;endif;
if(ivar=3);lev=0;endif;
if(ivar=4);lev=0;endif;
if(ivar=5);lev=0;endif;
if(ivar=6);lev=0;endif;
if(ivar=7);lev=0;endif;
if(ivar=8);lev=0;endif;
if(ivar=9);lev=0;endif;
if(ivar=10);lev=0;endif;
return lev

function getfld(ivar)
if(ivar=1);fld='pres';endif;
if(ivar=2);fld='t2m';endif;
if(ivar=3);fld='u10m';endif;
if(ivar=4);fld='v10m';endif;
if(ivar=5);fld='wspd10m';endif;
if(ivar=6);fld='wdir10m';endif;
if(ivar=7);fld='tmax';endif;
if(ivar=8);fld='tmin';endif;
if(ivar=9);fld='dpt2m';endif;
if(ivar=10);fld='rh2m';endif;
return fld

function gettxt(ivar)
if(ivar=1);txt='Surface Pressure';endif;
if(ivar=2);txt='2m Temperature';endif;
if(ivar=3);txt='10m U Component';endif;
if(ivar=4);txt='10m V Component';endif;
if(ivar=5);txt='10m Wind Speed';endif;
if(ivar=6);txt='10m Wind Direction';endif;
if(ivar=7);txt='2m Tmax';endif;
if(ivar=8);txt='2m Tmin';endif;
if(ivar=9);txt='2m Dew Point Temp';endif
if(ivar=10);txt='2m RH';endif
return txt   

function getytxt(ivar)
if(ivar=1);ytxt='Mean Absolute Error (Pa)';endif;
if(ivar=2);ytxt='Mean Absolute Error (C)';endif;
if(ivar=3);ytxt='Mean Absolute Error (m/s)';endif;
if(ivar=4);ytxt='Mean Absolute Error (m/s)';endif;
if(ivar=5);ytxt='Mean Absolute Error (m/s)';endif;
if(ivar=6);ytxt='Mean Absolute Error (Degree)';endif;
if(ivar=7);ytxt='Mean Absolute Error (C)';endif;
if(ivar=8);ytxt='Mean Absolute Error (C)';endif;
if(ivar=9);ytxt='Mean Absolute Error (C)';endif;
if(ivar=10);ytxt='Mean Absolute Error (%)';endif;
return ytxt  

function drawds(days)
if (days=16);
'draw string 1.920 0.55 0'
'draw string 2.445 0.55 1'
'draw string 2.970 0.55 2'
'draw string 3.495 0.55 3'
'draw string 4.020 0.55 4'
'draw string 4.545 0.55 5'
'draw string 5.070 0.55 6'
'draw string 5.595 0.55 7'
'draw string 6.120 0.55 8'
'draw string 6.645 0.55 9'
'draw string 7.170 0.55 10'
'draw string 7.695 0.55 11'
'draw string 8.220 0.55 12'
'draw string 8.745 0.55 13'
'draw string 9.270 0.55 14'
'draw string 9.795 0.55 15'
'draw string 10.32 0.55 16'
endif
if (days=10);
'draw string 1.96 0.55 0'
'draw string 2.80 0.55 1'
'draw string 3.64 0.55 2'
'draw string 4.48 0.55 3'
'draw string 5.32 0.55 4'
'draw string 6.16 0.55 5'
'draw string 7.00 0.55 6'
'draw string 7.84 0.55 7'
'draw string 8.68 0.55 8'
'draw string 9.52 0.55 9'
'draw string 10.36 0.55 10'
endif
if (days=15);
'draw string 1.92 0.55 0'
'draw string 2.48 0.55 1'
'draw string 3.04 0.55 2'
'draw string 3.60 0.55 3'
'draw string 4.16 0.55 4'
'draw string 4.72 0.55 5'
'draw string 5.28 0.55 6'
'draw string 5.84 0.55 7'
'draw string 6.40 0.55 8'
'draw string 6.96 0.55 9'
'draw string 7.52 0.55 10'
'draw string 8.08 0.55 11'
'draw string 8.64 0.55 12'
'draw string 9.20 0.55 13'
'draw string 9.76 0.55 14'
'draw string 10.32 0.55 15'
endif
if (days=155);
'draw string 2.20 0.55 1'
'draw string 2.77 0.55 2'
'draw string 3.34 0.55 3'
'draw string 3.82 0.55 4'
'draw string 4.36 0.55 5'
'draw string 5.02 0.55 6'
'draw string 5.58 0.55 7'
'draw string 6.14 0.55 8'
'draw string 6.70 0.55 9'
'draw string 7.26 0.55 10'
'draw string 7.82 0.55 11'
'draw string 8.38 0.55 12'
'draw string 8.94 0.55 13'
'draw string 9.50 0.55 14'
'draw string 10.06 0.55 15'
endif
return days

