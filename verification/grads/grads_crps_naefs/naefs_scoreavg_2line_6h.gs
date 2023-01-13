'open grads_EXPID1.ctl'
'open grads_EXPID2.ctl'
*'open grads_EXPID3.ctl'
*'open grads_EXPID4.ctl'

lev=getlev(field)
minbot=0

regs=1
rege=6
reg=regs
while (reg<=rege)
titreg=getreg(reg)
greg=getgreg(reg)

'set display color white'
'clear'
*
* 1). plotting CRPSF Scores
*
grfile=''greg'_field_crpsf_CYC.gr'
say grfile
'enable print 'grfile
'reset'
'set vpage 0.0 11.0 0.0 8.0'
'set grads off'
'set xlab  off'
'set x 0 64'
'set y 'reg
'set z 1'
'set t 1'
maxtop=getcrp(field)
minbot=getcrpmin(field)
'set vrange 0.0 'maxtop
*'set vrange 'minbot' 'maxtop''
'set ccolor 1'
'set cmark 1'
'set missconn on'
'd crpsf.1'

'set ccolor 2'
'set cmark 2'
'd crpsf.2'

'set ccolor 3'
'set cmark 3'
'd crpsf.3'

'set ccolor 4'
'set cmark 4'
'd crpsf.4'

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

'run linesmpos.gs leg_lines 2.3 5.7 4.4 7.0'

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
grfile=''greg'_field_crpsc_CYC.gr'
say grfile
'enable print 'grfile
'reset'
'set vpage 0.0 11.0 0.0 8.0'
'set grads off'
'set xlab  off'
'set x 0 64'
'set y 'reg
'set z 1'
'set t 1'
*minbot=getcrpmin(field)
maxtop=getrms(field)
'set vrange 0.0 'maxtop
*'set vrange 'minbot' 'maxtop''
'set ccolor 1'
'set cmark 1'
'set missconn on'
'd crpsc.1'

'set ccolor 2'
'set cmark 2'
'd crpsc.2'

'set ccolor 3'
'set cmark 3'
'd crpsc.3'

'set ccolor 4'
'set cmark 4'
'd crpsc.4'

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
'run linesmpos.gs leg_lines 2.3 1.3 4.4 2.6'

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
grfile=''greg'_field_rmsa_CYC.gr'
say grfile
'enable print 'grfile
'reset'

'set vpage 0 11 0.0 8.0'
'set grads off'
'set xlab  off'
'set x 0 64'
'set y 'reg
'set z 1'
'set t 1'
maxtop=getrms(field)
'set vrange 0 'maxtop
*'set cthick 8'

'set ccolor 1'
'set cmark 1'
'set missconn on'
'd rmsa.1'

'set ccolor 2'
'set cmark 2'
'd rmsa.2'

'set ccolor 3'
'set cmark 3'
'd rmsa.3'

'set ccolor 4'
'set cmark 4'
'd rmsa.4'

'set ccolor 5'
'set cmark 5'
*'d rmsa.5'

'set cstyle 5'
'set ccolor 1'
'set cmark 1'
'set missconn on'
'd sprd.1'

'set cstyle 5'
'set ccolor 2'
'set cmark 2'
'd sprd.2'

'set cstyle 5'
'set ccolor 3'
'set cmark 3'
'd sprd.3'

'set cstyle 5'
'set ccolor 4'
'set cmark 4'
'd sprd.4'

*'set cstyle 5'
*'set ccolor 5'
*'set cmark 5'
*'d sprd.5'

'draw xlab Forecast Days'
'draw ylab Ensemble Mean RMSA(solid) and SPREAD(dash)'
'set vpage 0.0 11.0 0.0 8.5'
'draw title 'titreg' FIELD \ Ensemble Mean RMSE and Ensemble SPREAD\ Average For 'STYMD' - 'EDYMD''
days=drawds(16)

'run linesmpos.gs leg_lines 2.3 5.7 4.4 7.0'

'set string 4'
'set strsiz 0.10'
*'draw string 7.8 0.09 BO CUI, GCWMB/EMC/NCEP/NOAA'
'print'
*'printim 'greg'_field_rms_CYC.gif x1100 y850'
'disable print'
'c'

*say 'type in c to continue or quit to exit'
*pull corquit
*corquit

*
* 4). plotting RMSM ( w.r.t 50% Prib fcst) and SPRD
*
'clear'
grfile=''greg'_field_rmsm_CYC.gr'
say grfile
'enable print 'grfile
'reset'

'set vpage 0 11 0.0 8.0'
'set grads off'
'set xlab  off'
'set x 0 64'
'set y 'reg
'set z 1'
'set t 1'
maxtop=getrms(field)
'set vrange 0 'maxtop
*'set cthick 8'

'set ccolor 1'
'set cmark 1'
'set missconn on'
'd rmsm.1'

'set ccolor 2'
'set cmark 2'
'd rmsm.2'

'set ccolor 3'
'set cmark 3'
'd rmsm.3'

'set ccolor 4'
'set cmark 4'
'd rmsm.4'

'set ccolor 5'
'set cmark 5'
*'d rmsm.5'

'set cstyle 5'
'set ccolor 1'
'set cmark 1'
'set missconn on'
'd sprd.1'

'set cstyle 5'
'set ccolor 2'
'set cmark 2'
'd sprd.2'

'set cstyle 5'
'set ccolor 3'
'set cmark 3'
'd sprd.3'

'set cstyle 5'
'set ccolor 4'
'set cmark 4'
'd sprd.4'

*'set cstyle 5'
*'set ccolor 5'
*'set cmark 5'
*'d sprd.5'

'draw xlab Forecast Days'
'draw ylab Ensemble Medium RMSM(solid) and SPREAD(dash)'
'set vpage 0.0 11.0 0.0 8.5'
'draw title 'titreg' FIELD \ Ensemble Medium RMSE and Ensemble SPREAD\ Average For 'STYMD' - 'EDYMD''
days=drawds(16)

'run linesmpos.gs leg_lines 2.3 5.7 4.4 7.0'

'set string 4'
'set strsiz 0.10'
*'draw string 7.8 0.09 BO CUI, GCWMB/EMC/NCEP/NOAA'
'print'
*'printim 'greg'_field_rms_CYC.gif x1100 y850'
'disable print'
'c'

*say 'type in c to continue or quit to exit'
*pull corquit
*corquit

*
* 5). plotting MERR and ABSE
*
'clear'
grfile=''greg'_field_merr_CYC.gr'
say grfile
'enable print 'grfile
'reset'
'set vpage 0 11 0 8.0'
'set grads off'
'set xlab  off'
'set x 0 64'
'set y 'reg
'set z 1'
'set t 1'
maxtop=getmaxerr(field)
minbot=getminbot(field)
'set vrange 'minbot' 'maxtop''
'set missconn on'
*'set cthick 8'

'set ccolor 1'
'set cmark 1'
'd merr.1'

'set ccolor 2'
'set cmark 2'
'd merr.2'

'set ccolor 3'
'set cmark 3'
'd merr.3'

'set ccolor 4'
'set cmark 4'
'd merr.4'

'set cstyle 5'
'set ccolor 1'
'set cmark 1'
'set missconn on'
'd abse.1'

'set cstyle 5'
'set ccolor 2'
'set cmark 2'
'd abse.2'

'set cstyle 5'
'set ccolor 3'
'set cmark 3'
'd abse.3'

'set cstyle 5'
'set ccolor 4'
'set cmark 4'
'd abse.4'

'draw xlab Forecast Days'
'draw ylab MERR(solid) and ABS. ERR(dash)'
'set vpage 0.0 11.0 0.0 8.5'
'draw title 'titreg' FIELD \ Ensemble Mean Error and Ensemble Abs. Error\ Average For 'STYMD' - 'EDYMD''
days=drawds(16)

'run linesmpos.gs leg_lines 2.3 5.7 4.4 7.0'

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
grfile=''greg'_field_ctp_CYC.gr'
say grfile
'enable print 'grfile
'reset'
'set vpage 0 11 0 8.0'
'set grads off'
'set xlab  off'
'set x 0 64'
'set y 'reg
'set z 1'
'set t 1'
'set vrange 0 1'
'set missconn on'
*'set cthick 8'

'set ccolor 1'
'set cmark 1'
'd ctp10.1'

'set ccolor 2'
'set cmark 2'
'd ctp10.2'

'set ccolor 3'
'set cmark 3'
'd ctp10.3'

'set ccolor 4'
'set cmark 4'
'd ctp10.4'

'set cstyle 5'
'set ccolor 1'
'set cmark 1'
'd 1-ctp90.1'

'set cstyle 5'
'set ccolor 2'
'set cmark 2'
'd 1-ctp90.2'

'set cstyle 5'
'set ccolor 3'
'set cmark 3'
'd 1-ctp90.3'

'set cstyle 5'
'set ccolor 4'
'set cmark 4'
'd 1-ctp90.4'

'draw xlab Forecast Days'
'draw ylab CTP10(solid) and CTP90(dash)'
'set vpage 0.0 11.0 0.0 8.5'
'draw title 'titreg' FIELD \ Forecast Verification For 'STYMD' - 'EDYMD''
days=drawds(16)

*'run linesmpos.gs leg_lines 2.3 5.7 4.4 7.0'
'run linesmpos.gs leg_lines 2.3 3.5 4.4 4.8'

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
if(reg=1);titreg='Northern Hemisphere';endif;
if(reg=2);titreg='Southern Hemisphere';endif;
if(reg=3);titreg='Tropical';endif;
if(reg=4);titreg='North American';endif;
if(reg=5);titreg='Europe';endif;
if(reg=6);titreg='Asia';endif;
return titreg

function getgreg(reg)
if(reg=1);greg='nh';endif
if(reg=2);greg='sh';endif
if(reg=3);greg='tr';endif
if(reg=4);greg='na';endif
if(reg=5);greg='eu';endif
if(reg=6);greg='as';endif
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
if(field=u10m);maxcrp=3.0;endif;
if(field=v10m);maxcrp=3.0;endif;
if(field=t2m);maxcrp=2.5;endif;
if(field=td2m);maxcrp=2.5;endif;
if(field=wdir);maxcrp=65;endif;
if(field=wspd);maxcrp=2.5;endif;
if(field=tmax);maxcrp=3.0;endif;
if(field=tmin);maxcrp=3.0;endif;
if(field=td2m);maxcrp=4.0;endif;
if(field=rh2m);maxcrp=20.0;endif;
if(field=z500);maxcrp=60.0;endif
if(field=z1000);maxcrp=40.0;endif
if(field=t850);maxcrp=3.0;endif
if(field=tcdc);maxcrp=30.0;endif
return maxcrp

function getcrpmin(field)
if(field=pres);mincrp=0;endif;
if(field=u10m);mincrp=1.0;endif;
if(field=v10m);mincrp=1.0;endif;
if(field=t2m);mincrp=0.5;endif;
if(field=td2m);mincrp=0.5;endif;
if(field=wdir);mincrp=25;endif;
if(field=wspd);mincrp=0.5;endif;
if(field=tmax);mincrp=0.5;endif;
if(field=tmin);mincrp=0.5;endif;
if(field=td2m);mincrp=0.5;endif;
if(field=rh2m);mincrp=5.0;endif;
if(field=z500);mincrp=0.0;endif
if(field=z1000);mincrp=0.0;endif
if(field=t850);mincrp=0.0;endif
if(field=tcdc);mincrp=10.0;endif
return mincrp

function getrms(field)
if(field=pres);maxrms=2000;endif;
if(field=u10m);maxrms=5.0;endif;
if(field=v10m);maxrms=5.0;endif;
if(field=t2m);maxrms=5;endif;
if(field=td2m);maxrms=5;endif;
if(field=wdir);maxrms=120;endif;
if(field=wspd);maxrms=4;endif;
if(field=tmax);maxrms=5;endif;
if(field=tmin);maxrms=5;endif;
if(field=td2m);maxrms=7;endif;
if(field=rh2m);maxrms=35;endif;
if(field=z500);maxrms=120.0;endif
if(field=z1000);maxrms=80.0;endif
if(field=t850);maxrms=5.0;endif
if(field=tcdc);maxrms=45.0;endif
return maxrms

function getmaxerr(field)
if(field=pres);maxerr=2000;endif;
if(field=u10m);maxerr=5.0;endif;
if(field=v10m);maxerr=5.0;endif;
if(field=t2m);maxerr=4;endif;
if(field=td2m);maxerr=4;endif;
if(field=wdir);maxerr=120;endif;
if(field=wspd);maxerr=4;endif;
if(field=tmax);maxerr=5;endif;
if(field=tmin);maxerr=5;endif;
if(field=td2m);maxerr=7;endif;
if(field=rh2m);maxerr=35;endif;
if(field=z500);maxerr=120.0;endif
if(field=z1000);maxerr=80.0;endif
if(field=t850);maxerr=5.0;endif
if(field=tcdc);maxerr=40.0;endif
return maxerr

function getminbot(field)
if(field=pres);minbot=-250;endif;
if(field=u10m);minbot=-1;endif;
if(field=v10m);minbot=-1;endif;
if(field=t2m);minbot=-1.0;endif;
if(field=td2m);minbot=-1.0;endif;
if(field=wdir);minbot=-0.5;endif;
if(field=wspd);minbot=-0.5;endif;
if(field=tmax);minbot=-0.5;endif;
if(field=tmin);minbot=-0.5;endif;
if(field=z500);minbot=-10.0;endif
if(field=z1000);minbot=-10.0;endif
if(field=t850);minbot=-1.0;endif
if(field=tcdc);minbot=-20.0;endif
return minbot


function getlev(field)
if(field=pres);lev=0;endif;
if(field=u10m);lev=0;endif;
if(field=v10m);lev=0;endif;
if(field=t2m);lev=0;endif;
if(field=td2m);lev=0;endif;
if(field=wdir);lev=0;endif;
if(field=wspd);lev=0;endif;
if(field=tmax);lev=0;endif;
if(field=tmin);lev=0;endif;
if(field=tcdc);lev=0;endif;
return lev

function gettxt(field)
if(field=pres);txt='Surface Pressure';endif;
if(field=u10m);txt='10m U Component';endif;
if(field=v10m);txt='10m V Component';endif;
if(field=t2m);txt='2m Temperature';endif;
if(field=td2m);txt='Dew Point Temperature';endif;
if(field=tmax);txt='Max Temperature';endif;
if(field=tmin);txt='Min Temperature';endif;
if(field=wspd);txt='Wind Speed';endif;
if(field=wdir);txt='Wind Direction';endif;
if(field=tcdc);txt='Total Cloud Cover';endif;
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
'draw string 10.2 0.55 10'
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
if(field=td2m);ytxt='Continuous Ranked Probability Score (C)';endif;
if(field=tmax);ytxt='Continuous Ranked Probability Score (C)';endif;
if(field=tmin);ytxt='Continuous Ranked Probability Score (C)';endif;
if(field=wspd);ytxt='Continuous Ranked Probability Score (m/s)';endif;
if(field=wdir);ytxt='Continuous Ranked Probability Score (Degree)';endif;
if(field=tcdc);ytxt='Total Cloud Cover (Percent)';endif;
return ytxt
