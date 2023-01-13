'open grads_EXPID1.ctl'
'open grads_EXPID2.ctl'
*'open grads_EXPID3.ctl'
*'open grads_EXPID4.ctl'

lev=getlev(field)
minbot=0

regs=5
rege=5
reg=regs
while (reg<=rege)
titreg=getreg(reg)
greg=getgreg(reg)

'set display color white'
'clear'
*
* 1). plotting CRPSF Scores
*
grfile='rtma_field_crpsf_CYC.gr'
say grfile
'enable print 'grfile
'reset'
'set vpage 0.0 11.0 0.0 8.0'
'set grads off'
'set xlab  off'
'set x 0 128'
'set y 1'
'set z 1'
'set t 1'
maxtop=getcrp(field)
minbot=getcrpmin(field)
*'set vrange 0.0 'maxtop
'set vrange 'minbot' 'maxtop''
'set ccolor 1'
'set cmark 1'
'set missconn on'
'd skip(crpsf.1,8,1)'

'set ccolor 2'
'set cmark 2'
'd skip(crpsf.2,8,1)'

'set ccolor 3'
'set cmark 3'
'd skip(crpsf.3,8,1)'

'set ccolor 4'
'set cmark 4'
'd skip(crpsf.4,8,1)'

*'set ccolor 5'
*'set cmark 5'
*'d crpsf.5'

*'set ccolor 6'
*'set cmark 6'
*'d crpsf.6'

'draw xlab Forecast Days'
'draw ylab Continuous Ranked Probability Score'
'set vpage 0.0 11.0 0.0 8.5'
'draw title 'titreg' FIELD \ Continuous Ranked Probability Scores\ Average For 'STYMD' - 'EDYMD''
days=drawds(16)

*'run linesmpos.gs leg_lines 2.3 5.7 4.4 7.0'
'run linesmpos.gs leg_lines 2.3 5.7 4.8 7.0'

'set string 4'
'set strsiz 0.10'
*'draw string 7.8 0.09 BO CUI, GCWMB/EMC/NCEP/NOAA'
'print'
'disable print'
'c'

*say 'type in c to continue or quit to exit'
*pull corquit
*corquit

* 2). plotting CRPSC Scores
*
grfile='rtma_field_crpsc_CYC.gr'
say grfile
'enable print 'grfile
'reset'
'set vpage 0.0 11.0 0.0 8.0'
'set grads off'
'set xlab  off'
'set x 0 64'
'set y 1'
'set z 1'
'set t 1'
maxtop=getcrpc(field)
*minbot=getcrpmin(field)
*'set vrange 0.0 'maxtop
'set vrange 'minbot' 'maxtop''
'set ccolor 1'
'set cmark 1'
'set missconn on'
'd skip(crpsc.1,8,1)'

'set ccolor 2'
'set cmark 2'
'd skip(crpsc.2,8,1)'

'set ccolor 3'
'set cmark 3'
'd skip(crpsc.3,8,1)'

'set ccolor 4'
'set cmark 4'
'd skip(crpsc.4,8,1)'

*'set ccolor 5'
*'set cmark 5'
*'d crpsc.5'

*'set ccolor 6'
*'set cmark 6'
*'d crpsc.6'

'draw xlab Forecast Days'
'draw ylab Continuous Ranked Probability Score (Climate)'
'set vpage 0.0 11.0 0.0 8.5'
'draw title 'titreg' FIELD \ Continuous Ranked Probability Scores (Climate)\ Average For For 'STYMD' - 'EDYMD''
days=drawds(16)

*'run linesmpos.gs leg_lines 2.3 5.7 4.4 7.0'
*'run linesmpos.gs leg_lines 2.3 1.1 4.4 2.4'
'run linesmpos.gs leg_lines 2.3 1.1 4.8 2.4'

'set string 4'
'set strsiz 0.10'
*'draw string 7.8 0.09 BO CUI, GCWMB/EMC/NCEP/NOAA'
'print'
'disable print'
'c'

*say 'type in c to continue or quit to exit'
*pull corquit
*corquit

*
* 3). plotting RMSA and SPRD
*
'clear'
grfile='rtma_field_rmsa_CYC.gr'
say grfile
'enable print 'grfile
'reset'

'set vpage 0 11 0.0 8.0'
'set grads off'
'set xlab  off'
'set x 0 64'
'set y 1'
'set z 1'
'set t 1'
maxtop=getrms(field)
'set vrange 0 'maxtop
*'set cthick 8'

'set ccolor 1'
'set cmark 1'
'set missconn on'
'd skip(rmsa.1,8,1)'

'set ccolor 2'
'set cmark 2'
'd skip(rmsa.2,8,1)'

'set ccolor 3'
'set cmark 3'
'd skip(rmsa.3,8,1)'

'set ccolor 4'
'set cmark 4'
'd skip(rmsa.4,8,1)'

'set ccolor 5'
'set cmark 5'
*'d rmsa.5'

'set cstyle 5'
'set ccolor 1'
'set cmark 1'
'set missconn on'
'd skip(sprd.1,8,1)'

'set cstyle 5'
'set ccolor 2'
'set cmark 2'
'd skip(sprd.2,8,1)'

'set cstyle 5'
'set ccolor 3'
'set cmark 3'
'd skip(sprd.3,8,1)'

'set cstyle 5'
'set ccolor 4'
'set cmark 4'
'd skip(sprd.4,8,1)'

*'set cstyle 5'
*'set ccolor 5'
*'set cmark 5'
*'d sprd.5'

'draw xlab Forecast Days'
'draw ylab Ensemble Mean RMSA(solid) and SPREAD(dash)'
'set vpage 0.0 11.0 0.0 8.5'
'draw title 'titreg' FIELD \ Ensemble Mean RMSE and Ensemble SPREAD\ Average For 'STYMD' - 'EDYMD''
days=drawds(16)

*'run linesmpos.gs leg_lines 2.3 5.7 4.4 7.0'
'run linesmpos.gs leg_lines 2.3 5.7 4.8 7.0'

'set string 4'
'set strsiz 0.10'
*'draw string 7.8 0.09 BO CUI, GCWMB/EMC/NCEP/NOAA'
'print'
*'printim rtma_field_rms_CYC.gif x1100 y850'
'disable print'
'c'

*say 'type in c to continue or quit to exit'
*pull corquit
*corquit

*
* 4). plotting RMSM ( w.r.t 50% Prib fcst) and SPRD
*
'clear'
grfile='rtma_field_rmsm_CYC.gr'
say grfile
'enable print 'grfile
'reset'

'set vpage 0 11 0.0 8.0'
'set grads off'
'set xlab  off'
'set x 0 64'
'set y 1'
'set z 1'
'set t 1'
maxtop=getrms(field)
'set vrange 0 'maxtop
*'set cthick 8'

'set ccolor 1'
'set cmark 1'
'set missconn on'
'd skip(rmsm.1,8,1)'

'set ccolor 2'
'set cmark 2'
'd skip(rmsm.2,8,1)'

'set ccolor 3'
'set cmark 3'
'd skip(rmsm.3,8,1)'

'set ccolor 4'
'set cmark 4'
'd skip(rmsm.4,8,1)'

'set ccolor 5'
'set cmark 5'
*'d rmsm.5'

'set cstyle 5'
'set ccolor 1'
'set cmark 1'
'set missconn on'
'd skip(sprd.1,8,1)'

'set cstyle 5'
'set ccolor 2'
'set cmark 2'
'd skip(sprd.2,8,1)'

'set cstyle 5'
'set ccolor 3'
'set cmark 3'
'd skip(sprd.3,8,1)'

'set cstyle 5'
'set ccolor 4'
'set cmark 4'
'd skip(sprd.4,8,1)'

*'set cstyle 5'
*'set ccolor 5'
*'set cmark 5'
*'d sprd.5'

'draw xlab Forecast Days'
'draw ylab Ensemble Medium RMSM(solid) and SPREAD(dash)'
'set vpage 0.0 11.0 0.0 8.5'
'draw title 'titreg' FIELD \ Ensemble Medium RMSE and Ensemble SPREAD\ Average For 'STYMD' - 'EDYMD''
days=drawds(16)

*'run linesmpos.gs leg_lines 2.3 5.7 4.4 7.0'
'run linesmpos.gs leg_lines 2.3 5.7 4.8 7.0'

'set string 4'
'set strsiz 0.10'
*'draw string 7.8 0.09 BO CUI, GCWMB/EMC/NCEP/NOAA'
'print'
*'printim rtma_field_rms_CYC.gif x1100 y850'
'disable print'
'c'

*say 'type in c to continue or quit to exit'
*pull corquit
*corquit

*
* 5). plotting MERR and ABSE
*
'clear'
grfile='rtma_field_merr_CYC.gr'
say grfile
'enable print 'grfile
'reset'
'set vpage 0 11 0 8.0'
'set grads off'
'set xlab  off'
'set x 0 64'
'set y 1'
'set z 1'
'set t 1'
maxtop=geterr(field)
*minbot=getmerrmin(field)
'set vrange -1 'maxtop''
'set missconn on'
*'set cthick 8'

'set ccolor 1'
'set cmark 1'
'd skip(merr.1,8,1)'

'set ccolor 2'
'set cmark 2'
'd skip(merr.2,8,1)'

'set ccolor 3'
'set cmark 3'
'd skip(merr.3,8,1)'

'set ccolor 4'
'set cmark 4'
'd skip(merr.4,8,1)'

'set cstyle 5'
'set ccolor 1'
'set cmark 1'
'set missconn on'
'd skip(abse.1,8,1)'

'set cstyle 5'
'set ccolor 2'
'set cmark 2'
'd skip(abse.2,8,1)'

'set cstyle 5'
'set ccolor 3'
'set cmark 3'
'd skip(abse.3,8,1)'

'set cstyle 5'
'set ccolor 4'
'set cmark 4'
'd skip(abse.4,8,1)'

'draw xlab Forecast Days'
'draw ylab MERR(solid) and ABS. ERR(dash)'
'set vpage 0.0 11.0 0.0 8.5'
'draw title 'titreg' FIELD \ Ensemble Mean Error and Ensemble Abs. Error\ Average For 'STYMD' - 'EDYMD''
days=drawds(16)

*'run linesmpos.gs leg_lines 2.3 5.7 4.4 7.0'
'run linesmpos.gs leg_lines 2.3 5.7 4.8 7.0'

'set string 4'
'set strsiz 0.10'
*'draw string 7.8 0.09 BO CUI, GCWMB/EMC/NCEP/NOAA'
'print'
'disable print'
'c'

*say 'type in c to continue or quit to exit'
*pull corquit
*corquit

*
* 6). plotting P10 and P90
*
'clear'
grfile='rtma_field_ctp_CYC.gr'
say grfile
'enable print 'grfile
'reset'
'set vpage 0 11 0 8.2'
'set grads off'
'set xlab  off'
'set x 0 64'
'set y 1'
'set z 1'
'set t 1'
'set vrange 0 1'
'set missconn on'
*'set cthick 8'

'set ccolor 1'
'set cmark 1'
'd skip(ctp10.1,8,1)'

'set ccolor 2'
'set cmark 2'
'd skip(ctp10.2,8,1)'

'set ccolor 3'
'set cmark 3'
'd skip(ctp10.3,8,1)'

'set ccolor 4'
'set cmark 4'
'd skip(ctp10.4,8,1)'

'set cstyle 5'
'set ccolor 1'
'set cmark 1'
'd skip(1-ctp90.1,8,1)'

'set cstyle 5'
'set ccolor 2'
'set cmark 2'
'd skip(1-ctp90.2,8,1)'

'set cstyle 5'
'set ccolor 3'
'set cmark 3'
'd skip(1-ctp90.3,8,1)'

'set cstyle 5'
'set ccolor 4'
'set cmark 4'
'd skip(1-ctp90.4,8,1)'

'draw xlab Forecast Days'
'draw ylab CTP10(solid) and CTP90(dash)'
'set vpage 0.0 11.0 0.0 8.5'
'draw title 'titreg' FIELD \ Forecast Verification For 'STYMD' - 'EDYMD''
days=drawds(16)

*'run linesmpos.gs leg_lines 2.3 5.7 4.4 7.0'
*'run linesmpos.gs leg_lines 2.3 3.5 4.4 4.8'
'run linesmpos.gs leg_lines 2.3 3.5 4.8 4.8'

'set string 4'
'set strsiz 0.10'
*'draw string 7.8 0.09 BO CUI, GCWMB/EMC/NCEP/NOAA'
'print'
'disable print'
'c'

*say 'type in c to continue or quit to exit'
*pull corquit
*corquit

reg=reg+1
endwhile

'quit'

function getreg(reg)
if(reg=1);titreg='NH';endif;
if(reg=2);titreg='SH';endif;
if(reg=3);titreg='TROPICS';endif;
if(reg=4);titreg='GLOBAL';endif;
if(reg=5);titreg='NAEFS CONUS';endif;
return titreg

function getgreg(reg)
if(reg=1);greg='nh';endif;
if(reg=2);greg='sh';endif;
if(reg=3);greg='tr';endif;
if(reg=4);greg='global';endif;
if(reg=5);greg='conus';endif;
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

function getcrp(field)
if(field=pres);maxcrp=1500;endif;
if(field=u10m);maxcrp=2.2;endif;
if(field=v10m);maxcrp=2.2;endif;
if(field=t2m);maxcrp=2.6;endif;
if(field=dpt);maxcrp=3.0;endif;
if(field=wdir);maxcrp=60;endif;
if(field=wspd);maxcrp=1.6;endif;
if(field=tmax);maxcrp=3.0;endif;
if(field=tmin);maxcrp=3.0;endif;
if(field=td2m);maxcrp=4.0;endif;
if(field=rh2m);maxcrp=10.0;endif;
return maxcrp

function getcrpc(field)
if(field=pres);maxcrpc=1500;endif;
if(field=u10m);maxcrpc=3.0;endif;
if(field=v10m);maxcrpc=3.0;endif;
if(field=t2m);maxcrpc=5.0;endif;
if(field=dpt);maxcrpc=5.0;endif;
if(field=wdir);maxcrpc=65;endif;
if(field=wspd);maxcrpc=2.5;endif;
if(field=tmax);maxcrpc=3.0;endif;
if(field=tmin);maxcrpc=3.0;endif;
if(field=td2m);maxcrpc=4.0;endif;
if(field=rh2m);maxcrpc=20.0;endif;
return maxcrpc

function getcrpmin(field)
if(field=pres);mincrp=0;endif;
if(field=u10m);mincrp=0.8;endif;
if(field=v10m);mincrp=0.8;endif;
if(field=t2m);mincrp=0.5;endif;
if(field=dpt);mincrp=0.5;endif;
if(field=wdir);mincrp=25;endif;
if(field=wspd);mincrp=0.8;endif;
if(field=tmax);mincrp=0.5;endif;
if(field=tmin);mincrp=0.5;endif;
if(field=td2m);mincrp=0.5;endif;
if(field=rh2m);mincrp=5.0;endif;
return mincrp

function getrms(field)
if(field=pres);maxrms=2000;endif;
if(field=u10m);maxrms=4.5;endif;
if(field=v10m);maxrms=4.5;endif;
if(field=t2m);maxrms=5.0;endif;
if(field=dpt);maxrms=6.0;endif;
if(field=wdir);maxrms=90;endif;
if(field=wspd);maxrms=3;endif;
if(field=tmax);maxrms=5;endif;
if(field=tmin);maxrms=5;endif;
if(field=rh2m);maxrms=18;endif;
return maxrms

function geterr(field)
if(field=pres);maxerr=2000;endif;
if(field=u10m);maxerr=3.0;endif;
if(field=v10m);maxerr=3.0;endif;
if(field=t2m);maxerr=4;endif;
if(field=dpt);maxerr=5;endif;
if(field=wdir);maxerr=80;endif;
if(field=wspd);maxerr=2.5;endif;
if(field=tmax);maxerr=5;endif;
if(field=tmin);maxerr=5;endif;
if(field=rh2m);maxerr=15;endif;
return maxerr


function getminbot(field)
if(field=pres);minbot=-250;endif;
if(field=u10m);minbot=0;endif;
if(field=v10m);minbot=0;endif;
if(field=t2m);minbot=-0.5;endif;
if(field=dpt);minbot=-0.5;endif;
if(field=wdir);minbot=-0.5;endif;
if(field=wspd);minbot=-0.5;endif;
if(field=tmax);minbot=-0.5;endif;
if(field=tmin);minbot=-0.5;endif;
return minbot


function getlev(field)
if(field=pres);lev=0;endif;
if(field=u10m);lev=0;endif;
if(field=v10m);lev=0;endif;
if(field=t2m);lev=0;endif;
if(field=wdir);lev=0;endif;
if(field=wspd);lev=0;endif;
if(field=tmax);lev=0;endif;
if(field=tmin);lev=0;endif;
if(field=dpt);lev=0;endif;
return lev

function gettxt(field)
if(field=pres);txt='Surface Pressure';endif;
if(field=u10m);txt='10m U Component';endif;
if(field=v10m);txt='10m V Component';endif;
if(field=t2m);txt='2m Temperature';endif;
if(field=dpt);txt='2m Dew Point Temperature';endif;
if(field=tmax);txt='Max Temperature';endif;
if(field=tmin);txt='Min Temperature';endif;
if(field=wspd);txt='Wind Speed';endif;
if(field=wdir);txt='Wind Direction';endif;
return txt   

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
return days

function getytxt(field)
if(field=pres);ytxt='Continuous Ranked Probability Score (Pa)';endif;
if(field=u10m);ytxt='Continuous Ranked Probability Score (m/s)';endif;
if(field=v10m);ytxt='Continuous Ranked Probability Score (m/s)';endif;
if(field=t2m);ytxt='Continuous Ranked Probability Score (C)';endif;
if(field=dpt);ytxt='Continuous Ranked Probability Score (C)';endif;
if(field=tmax);ytxt='Continuous Ranked Probability Score (C)';endif;
if(field=tmin);ytxt='Continuous Ranked Probability Score (C)';endif;
if(field=wspd);ytxt='Continuous Ranked Probability Score (m/s)';endif;
if(field=wdir);ytxt='Continuous Ranked Probability Score (Degree)';endif;
return ytxt
