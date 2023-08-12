
'open opr/opr_036.ctl'
'run rgbset.gs'
'set lon 210 310'
'set lat 10 65 '
'set mproj nps '
'set mpvals -120 -75 20 55'
'set gxout shaded'
'set mpdset mres'
'set display color white'
'clear'

*--------------figure 1-------------------------------------
'enable print gmeta_ctl_YYMMDDHHa'
'set display color white'
'clear'
istart=36
iend=108
'close 1'
while (istart<=iend)
 ini=istart-24
 if (istart=36)
'set parea 0.3 3.0  7.2 9.7'
 'open opr/opr_036.ctl'
 endif
 if (istart=60)
'set parea 0.3 3.0  4.9 7.4 '
 'open  opr/opr_060.ctl'
 endif
 if (istart=84)
 'open  opr/opr_084.ctl'
'set parea 0.3 3.0 2.6 5.1'
 endif
 if (istart=108)
 'open  opr/opr_108.ctl'
'set parea 0.3 3.0 0.3 2.8'
 endif

'set t 1'
'set grads off'
'run rgbset.gs'
'set lon 210 310'
'set lat 10 65 '
'set mproj nps '
'set mpvals -120 -75 20 55'
'set gxout shaded'
'set mpdset mres'
*'set clevs  0.02 1.0 3.2 5.0 7.0 10.0 15.0'
*'set ccols  0   21  22  31   33   35   37   39'
*'set ccols  0 33 36 43 46 53 56 69 66 62'
'set clevs 0.1 2 5 10 15 20 25 35 50 75 100 125 150 175'
'set ccols 0 33 36 39 49 45 42 53 56 87 88 29 26 24 95 93'
'd apcpsfc'
'set gxout contour'
'set cthick 2'
'set ccolor 1'
'set cstyle 1'
'set clevs   0.02 1.0 3.2 5.0 7.0 10.0 15.0'
'set clopts -1 -1 0.05'
*'d apcpsfc'
'draw ylab \\ 'ini'-'istart' hr fcst'

if (istart=108)
*'run cbar.gs'
endif
'close 1'
istart=istart+24
endwhile

istart=36
iend=108
while (istart<=iend)
 if (istart=36)
 'open cal/cal_036.ctl'
'set parea 3.0 5.7 7.2 9.7'
 endif
 if (istart=60)
 'open cal/cal_060.ctl'
'set parea 3.0 5.7 4.9 7.4'
 endif
 if (istart=84)
 'open cal/cal_084.ctl'
'set parea 3.0 5.7 2.6 5.1' 
 endif
 if (istart=108)
 'open cal/cal_108.ctl'
'set parea 3.0 5.7 0.3 2.8' 
 endif

'set t 1'
'set grads off'
'run rgbset.gs'
'set lon 210 310'
'set lat 10 65 '
'set mproj nps '
'set mpvals -120 -75 20 55'
'set gxout shaded'
'set mpdset mres'
'set clevs 0.1 2 5 10 15 20 25 35 50 75 100 125 150 175'
'set ccols 0 33 36 39 49 45 42 53 56 87 88 29 26 24 95 93'
'd apcpsfc'
'set gxout contour'
'set cthick 2'
'set ccolor 1'
'set cstyle 1'
'set clevs   0.02 1.0 3.2 5.0 7.0 10.0 15.0'
'set clopts -1 -1 0.05'
*'d apcpsfc'

if (istart=108)
'run cbarn.gs 0.7 0 4.25 0.2'
endif
'close 1'
istart=istart+24
endwhile


istart=36
iend=108
while (istart<=iend)
 if (istart=36)
 'open obs/obs_036.ctl'
'set parea 5.7 8.4 7.2 9.7'
 endif
 if (istart=60)
 'open obs/obs_060.ctl'
'set parea 5.7 8.4 4.9 7.4'
 endif
 if (istart=84)
 'open obs/obs_084.ctl'
'set parea 5.7 8.4 2.6 5.1' 
 endif
 if (istart=108)
 'open obs/obs_108.ctl'
'set parea 5.7 8.4 0.3 2.8' 
 endif

'set t 1'
'set grads off'
'run rgbset.gs'
'set lon 210 310'
'set lat 10 65 '
'set mproj nps '
'set mpvals -120 -75 20 55'
'set gxout shaded'
'set mpdset mres'
'set clevs 0.1 2 5 10 15 20 25 35 50 75 100 125 150 175'
'set ccols 0 33 36 39 49 45 42 53 56 87 88 29 26 24 95 93'
'd apcpsfc'
'set gxout contour'
'set cthick 2'
'set ccolor 1'
'set cstyle 1'
'set clevs   0.02 1.0 3.2 5.0 7.0 10.0 15.0'
'set clopts -1 -1 0.05'
*'d apcpsfc'

if (istart=108)
*'run cbar.gs'
endif
'close 1'
istart=istart+24
endwhile

'set vpage 0.0 8.5 0.0 11.0'
'set strsiz 0.16'
'set string 1 tc 6'
'draw string 4.25 10.6 GEFS/CTL Quantitative Precipitation Forecast (QPF)'
'set strsiz 0.16'
'draw string 4.25 10.3 Ini: YYMMDDHH'
'set string 4 tc 6'
'draw string 1.8 9.8 RAW'
'draw string 4.4 9.8 CAL_bc'
'draw string 7.1 9.8 OBS'
'set strsiz 0.08'
*'draw string 1.6 0.15 YUEJIAN ZHU, GMB/EMC/NCEP/NOAA'
'print'
'printim actl_YYMMDDHH.gif gif x850 y1100 white'
*say 'type in c to continue or quit to exit'
*pull *corquit
*corquit

'disable print gmeta_ctl_YYMMDDHHa'

*--------------Figure 2-------------------------------------
'enable print gmeta_ctl_YYMMDDHHb'
'set display color white'
'clear'
istart=132
iend=204
while (istart<=iend)
ini=istart-24
 if (istart=132)
'set parea 0.3 3.0  7.2 9.7'
 'open opr/opr_132.ctl'
 endif
 if (istart=156)
'set parea 0.3 3.0  4.9 7.4 '
 'open  opr/opr_156.ctl'
 endif
 if (istart=180)
 'open  opr/opr_180.ctl'
'set parea 0.3 3.0 2.6 5.1'
 endif
 if (istart=204)
 'open  opr/opr_204.ctl'
'set parea 0.3 3.0 0.3 2.8'
 endif

'set t 1'
'set grads off'
'run rgbset.gs'
'set lon 210 310'
'set lat 10 65 '
'set mproj nps '
'set mpvals -120 -75 20 55'
'set gxout shaded'
'set mpdset mres'
'set clevs 0.1 2 5 10 15 20 25 35 50 75 100 125 150 175'
'set ccols 0 33 36 39 49 45 42 53 56 87 88 29 26 24 95 93'
'd apcpsfc'
'set gxout contour'
'set cthick 2'
'set ccolor 1'
'set cstyle 1'
'set clevs   0.02 1.0 3.2 5.0 7.0 10.0 15.0'
'set clopts -1 -1 0.05'
*'d apcpsfc'
'draw ylab \\ 'ini'-'istart' hr fcst'

if (istart=204)
*'run cbar.gs'
endif
'close 1'
istart=istart+24
endwhile

istart=132
iend=204
while (istart<=iend)
 if (istart=132)
 'open cal/cal_132.ctl'
'set parea 3.0 5.7 7.2 9.7'
 endif
 if (istart=156)
 'open cal/cal_156.ctl'
'set parea 3.0 5.7 4.9 7.4'
 endif
 if (istart=180)
 'open cal/cal_180.ctl'
'set parea 3.0 5.7 2.6 5.1' 
 endif
 if (istart=204)
 'open cal/cal_204.ctl'
'set parea 3.0 5.7 0.3 2.8' 
 endif

'set t 1'
'set grads off'
'run rgbset.gs'
'set lon 210 310'
'set lat 10 65 '
'set mproj nps '
'set mpvals -120 -75 20 55'
'set gxout shaded'
'set mpdset mres'
'set clevs 0.1 2 5 10 15 20 25 35 50 75 100 125 150 175'
'set ccols 0 33 36 39 49 45 42 53 56 87 88 29 26 24 95 93'
'd apcpsfc'
'set gxout contour'
'set cthick 2'
'set ccolor 1'
'set cstyle 1'
'set clevs   0.02 1.0 3.2 5.0 7.0 10.0 15.0'
'set clopts -1 -1 0.05'
*'d apcpsfc'

if (istart=204)
'run cbarn.gs 0.7 0 4.25 0.2'
endif
'close 1'
istart=istart+24
endwhile


istart=132
iend=204
while (istart<=iend)
 if (istart=132)
 'open obs/obs_132.ctl'
'set parea 5.7 8.4 7.2 9.7'
 endif
 if (istart=156)
 'open obs/obs_156.ctl'
'set parea 5.7 8.4 4.9 7.4'
 endif
 if (istart=180)
 'open obs/obs_180.ctl'
'set parea 5.7 8.4 2.6 5.1' 
 endif
 if (istart=204)
 'open obs/obs_204.ctl'
'set parea 5.7 8.4 0.3 2.8' 
 endif

'set t 1'
'set grads off'
'run rgbset.gs'
'set lon 210 310'
'set lat 10 65 '
'set mproj nps '
'set mpvals -120 -75 20 55'
'set gxout shaded'
'set mpdset mres'
'set clevs 0.1 2 5 10 15 20 25 35 50 75 100 125 150 175'
'set ccols 0 33 36 39 49 45 42 53 56 87 88 29 26 24 95 93'
'd apcpsfc'
'set gxout contour'
'set cthick 2'
'set ccolor 1'
'set cstyle 1'
'set clevs   0.02 1.0 3.2 5.0 7.0 10.0 15.0'
'set clopts -1 -1 0.05'
*'d apcpsfc'

if (istart=204)
*'run cbar.gs'
endif
'close 1'
istart=istart+24
endwhile

'set vpage 0.0 8.5 0.0 11.0'
'set strsiz 0.16'
'set string 1 tc 6'
'draw string 4.25 10.6 GEFS/CTL Quantitative Precipitation Forecast (QPF)'
'set strsiz 0.16'
'draw string 4.25 10.3 Ini: YYMMDDHH'
'set string 4 tc 6'
'draw string 1.8 9.8 RAW'
'draw string 4.4 9.8 CAL_bc'
'draw string 7.1 9.8 OBS'
'set strsiz 0.08'
*'draw string 1.6 0.15 YUEJIAN ZHU, GMB/EMC/NCEP/NOAA'
'print'
'printim bctl_YYMMDDHH.gif gif x850 y1100 white'
*say 'type in c to continue or quit to exit'
*pull *corquit
*corquit

'disable print gmeta_ctl_YYMMDDHHb'

*--------------day 3-------------------------------------
'enable print gmeta_ctl_YYMMDDHHc'
'set display color white'
'clear'
istart=228
iend=300
while (istart<=iend)
ini=istart-24
 if (istart=228)
'set parea 0.3 3.0  7.2 9.7'
 'open opr/opr_228.ctl'
 endif
 if (istart=252)
'set parea 0.3 3.0  4.9 7.4 '
 'open  opr/opr_252.ctl'
 endif
 if (istart=276)
 'open  opr/opr_276.ctl'
'set parea 0.3 3.0 2.6 5.1'
 endif
 if (istart=300)
 'open  opr/opr_300.ctl'
'set parea 0.3 3.0 0.3 2.8'
 endif

'set t 1'
'set grads off'
'run rgbset.gs'
'set lon 210 310'
'set lat 10 65 '
'set mproj nps '
'set mpvals -120 -75 20 55'
'set gxout shaded'
'set mpdset mres'
'set clevs 0.1 2 5 10 15 20 25 35 50 75 100 125 150 175'
'set ccols 0 33 36 39 49 45 42 53 56 87 88 29 26 24 95 93'
'd apcpsfc'
'set gxout contour'
'set cthick 2'
'set ccolor 1'
'set cstyle 1'
'set clevs   0.02 1.0 3.2 5.0 7.0 10.0 15.0'
'set clopts -1 -1 0.05'
*'d apcpsfc'
'draw ylab \\ 'ini'-'istart' hr fcst'

if (istart=300)
*'run cbar.gs'
endif
'close 1'
istart=istart+24
endwhile

istart=228
iend=300
while (istart<=iend)
 if (istart=228)
 'open cal/cal_228.ctl'
'set parea 3.0 5.7 7.2 9.7'
 endif
 if (istart=252)
 'open cal/cal_252.ctl'
'set parea 3.0 5.7 4.9 7.4'
 endif
 if (istart=276)
 'open cal/cal_276.ctl'
'set parea 3.0 5.7 2.6 5.1' 
 endif
 if (istart=300)
 'open cal/cal_300.ctl'
'set parea 3.0 5.7 0.3 2.8' 
 endif

'set t 1'
'set grads off'
'run rgbset.gs'
'set lon 210 310'
'set lat 10 65 '
'set mproj nps '
'set mpvals -120 -75 20 55'
'set gxout shaded'
'set mpdset mres'
'set clevs 0.1 2 5 10 15 20 25 35 50 75 100 125 150 175'
'set ccols 0 33 36 39 49 45 42 53 56 87 88 29 26 24 95 93'
'd apcpsfc'
'set gxout contour'
'set cthick 2'
'set ccolor 1'
'set cstyle 1'
'set clevs   0.02 1.0 3.2 5.0 7.0 10.0 15.0'
'set clopts -1 -1 0.05'
*'d apcpsfc'

if (istart=300)
'run cbarn.gs 0.7 0 4.25 0.2'
endif
'close 1'
istart=istart+24
endwhile


istart=228
iend=300
while (istart<=iend)
 if (istart=228)
 'open obs/obs_228.ctl'
'set parea 5.7 8.4 7.2 9.7'
 endif
 if (istart=252)
 'open obs/obs_252.ctl'
'set parea 5.7 8.4 4.9 7.4'
 endif
 if (istart=276)
 'open obs/obs_276.ctl'
'set parea 5.7 8.4 2.6 5.1' 
 endif
 if (istart=300)
 'open obs/obs_300.ctl'
'set parea 5.7 8.4 0.3 2.8' 
 endif

'set t 1'
'set grads off'
'run rgbset.gs'
'set lon 210 310'
'set lat 10 65 '
'set mproj nps '
'set mpvals -120 -75 20 55'
'set gxout shaded'
'set mpdset mres'
'set clevs 0.1 2 5 10 15 20 25 35 50 75 100 125 150 175'
'set ccols 0 33 36 39 49 45 42 53 56 87 88 29 26 24 95 93'
'd apcpsfc'
'set gxout contour'
'set cthick 2'
'set ccolor 1'
'set cstyle 1'
'set clevs   0.02 1.0 3.2 5.0 7.0 10.0 15.0'
'set clopts -1 -1 0.05'
*'d apcpsfc'

if (istart=300)
*'run cbar.gs'
endif
'close 1'
istart=istart+24
endwhile

'set vpage 0.0 8.5 0.0 11.0'
'set strsiz 0.16'
'set string 1 tc 6'
'draw string 4.25 10.6 GEFS/CTL Quantitative Precipitation Forecast (QPF)'
'set strsiz 0.16'
'draw string 4.25 10.3 Ini: YYMMDDHH'
'set string 4 tc 6'
'draw string 1.8 9.8 RAW'
'draw string 4.4 9.8 CAL_bc'
'draw string 7.1 9.8 OBS'
'set strsiz 0.08'
*'draw string 1.6 0.15 YUEJIAN ZHU, GMB/EMC/NCEP/NOAA'
'print'
'printim cctl_YYMMDDHH.gif gif x850 y1100 white'
*say 'type in c to continue or quit to exit'
*pull *corquit
*corquit

'disable print gmeta_ctl_YYMMDDHHc'

*--------------day 4-------------------------------------
'enable print gmeta_ctl_YYMMDDHHd'
'set display color white'
'clear'
istart=324
iend=372
while (istart<=iend)
ini=istart-24
 if (istart=324)
'set parea 0.3 3.0  7.2 9.7'
 'open opr/opr_324.ctl'
 endif
 if (istart=348)
'set parea 0.3 3.0  4.9 7.4 '
 'open  opr/opr_348.ctl'
 endif
 if (istart=372)
 'open  opr/opr_372.ctl'
'set parea 0.3 3.0 2.6 5.1'
 endif

'set t 1'
'set grads off'
'run rgbset.gs'
'set lon 210 310'
'set lat 10 65 '
'set mproj nps '
'set mpvals -120 -75 20 55'
'set gxout shaded'
'set mpdset mres'
'set clevs 0.1 2 5 10 15 20 25 35 50 75 100 125 150 175'
'set ccols 0 33 36 39 49 45 42 53 56 87 88 29 26 24 95 93'
'd apcpsfc'
'set gxout contour'
'set cthick 2'
'set ccolor 1'
'set cstyle 1'
'set clevs   0.02 1.0 3.2 5.0 7.0 10.0 15.0'
'set clopts -1 -1 0.05'
*'d apcpsfc'
'draw ylab \\ 'ini'-'istart' hr fcst'

if (istart=372)
*'run cbar.gs'
endif
'close 1'
istart=istart+24
endwhile

istart=324
iend=372
while (istart<=iend)
 if (istart=324)
 'open cal/cal_324.ctl'
'set parea 3.0 5.7 7.2 9.7'
 endif
 if (istart=348)
 'open cal/cal_348.ctl'
'set parea 3.0 5.7 4.9 7.4'
 endif
 if (istart=372)
 'open cal/cal_372.ctl'
'set parea 3.0 5.7 2.6 5.1' 
 endif

'set t 1'
'set grads off'
'run rgbset.gs'
'set lon 210 310'
'set lat 10 65 '
'set mproj nps '
'set mpvals -120 -75 20 55'
'set gxout shaded'
'set mpdset mres'
'set clevs 0.1 2 5 10 15 20 25 35 50 75 100 125 150 175'
'set ccols 0 33 36 39 49 45 42 53 56 87 88 29 26 24 95 93'
'd apcpsfc'
'set gxout contour'
'set cthick 2'
'set ccolor 1'
'set cstyle 1'
'set clevs   0.02 1.0 3.2 5.0 7.0 10.0 15.0'
'set clopts -1 -1 0.05'
*'d apcpsfc'

if (istart=372)
'run cbarn.gs 0.7 0 4.25 0.2'
endif
'close 1'
istart=istart+24
endwhile


istart=324
iend=372
while (istart<=iend)
 if (istart=324)
 'open obs/obs_324.ctl'
'set parea 5.7 8.4 7.2 9.7'
 endif
 if (istart=348)
 'open obs/obs_348.ctl'
'set parea 5.7 8.4 4.9 7.4'
 endif
 if (istart=372)
 'open obs/obs_372.ctl'
'set parea 5.7 8.4 2.6 5.1' 
 endif

'set t 1'
'set grads off'
'run rgbset.gs'
'set lon 210 310'
'set lat 10 65 '
'set mproj nps '
'set mpvals -120 -75 20 55'
'set gxout shaded'
'set mpdset mres'
'set clevs 0.1 2 5 10 15 20 25 35 50 75 100 125 150 175'
'set ccols 0 33 36 39 49 45 42 53 56 87 88 29 26 24 95 93'
'd apcpsfc'
'set gxout contour'
'set cthick 2'
'set ccolor 1'
'set cstyle 1'
'set clevs   0.02 1.0 3.2 5.0 7.0 10.0 15.0'
'set clopts -1 -1 0.05'
*'d apcpsfc'

if (istart=324)
*'run cbar.gs'
endif
'close 1'
istart=istart+24
endwhile

'set vpage 0.0 8.5 0.0 11.0'
'set strsiz 0.16'
'set string 1 tc 6'
'draw string 4.25 10.6 GEFS/CTL Quantitative Precipitation Forecast (QPF)'
'set strsiz 0.16'
'draw string 4.25 10.3 Ini: YYMMDDHH'
'set string 4 tc 6'
'draw string 1.8 9.8 RAW'
'draw string 4.4 9.8 CAL_bc'
'draw string 7.1 9.8 OBS'
'set strsiz 0.08'
*'draw string 1.6 0.15 YUEJIAN ZHU, GMB/EMC/NCEP/NOAA'
'print'
'printim dctl_YYMMDDHH.gif gif x850 y1100 white'
*say 'type in c to continue or quit to exit'
*pull *corquit
*corquit

'disable print gmeta_ctl_YYMMDDHHd'

'quit'

