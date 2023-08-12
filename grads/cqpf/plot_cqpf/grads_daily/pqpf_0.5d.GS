
'open FILENAME1'
'open FILENAME2'

'run rgbset.gs'
'set lon 210 310'
'set lat 10 65 '
'set mproj nps '
'set mpvals -120 -75 20 55'
'set gxout shaded'
'set mpdset mres'
'set display color white'
'clear'

***
*** t=3 (0-24 hrs)
*** t=4 (12-36 hrs)
*** t=5 (24-48 hrs)
*** t=6 (36-60 hrs)
*** t=7 (48-72 hrs)
*** t=8 (60-84 hrs)
*** t=9 (72-96 hrs)
*** t=10 (84-108 hrs)
*** t=11 (96-120 hrs)
***
*--------------day 1-------------------------------------
'enable print gmeta_AMT1_YYMMDDHHa'
'set display color white'
'clear'
istart=36
iend=108
while (istart<=iend)
 ini=istart-24
 if (istart=36)
 'set parea 0.3 3.0 7.2 9.7'
 endif
 if (istart=60)
 'set parea 0.3 3.0 4.9 7.4'
 endif
 if (istart=84)
 'set parea 0.3 3.0 2.6 5.1'
 endif
 if (istart=108)
 'set parea 0.3 3.0 0.3 2.8'
 endif

ttime=(istart-12)/24

'set t 'ttime''
'set grads off'
'set gxout shaded'
'set clevs  5 15 25 35 45 55 65 75 85 95'
'set ccols  0 41 31 32 33 34 35 36 37 38 39'
'd probsfc'
'set gxout contour'
'set cthick 2'
'set ccolor 1'
'set cstyle 1'
'set clevs 5 35 65 95  '
'set clopts -1 -1 0.05'  
'd probsfc'
'draw ylab \\ 'ini'-'istart' hr fcst'

if (istart=24)
*'run cbar.gs'
endif

istart=istart+24
endwhile

istart=36
iend=108
while (istart<=iend)
 if (istart=36)
 'set parea 3.0 5.7 7.2 9.7'
 endif
 if (istart=60)
 'set parea 3.0 5.7 4.9 7.4'
 endif
 if (istart=84)
 'set parea 3.0 5.7 2.6 5.1'
 endif
 if (istart=108)
 'set parea 3.0 5.7 0.3 2.8'
 endif

ttime=(istart-12)/24

'set t 'ttime''
'set grads off'
'set gxout shaded'
'set clevs  5 15 25 35 45 55 65 75 85 95'
'set ccols  0 41 31 32 33 34 35 36 37 38 39'
'd probsfc.2'
'set gxout contour'
'set cthick 2'
'set ccolor 1'
'set cstyle 1'
'set clevs 5 35 65 95  '
'set clopts -1 -1 0.05'  
'd probsfc.2'
*'draw ylab 'istart'-hour forecast'

if (istart=108)
'run cbarn.gs 0.5 0 3.1 0.2'
endif

istart=istart+24
endwhile

'close 2'
'close 1'

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
'set clevs  AMT1' 
'set ccols  0  35'  
'set cmin AMT1'
'd apcpsfc.1'
'set gxout contour'
'set cthick 2'
'set ccolor 1'
'set cstyle 1'
'set clevs AMT1'  
'set clopts -1 -1 0.05'  
'set cmin AMT1'
'd apcpsfc.1'

if (istart=108)
'run cbarn.gs 0.45 0 6.95 0.2'
endif
'close 1'
istart=istart+24
endwhile

'set vpage 0.0 8.5 0.0 11.0'
'set strsiz 0.15'
'set string 1 tc 6'
'draw string 4.25 10.6 Ens Prob of Precip Amount Exceeding 'AMT2' inch ('AMT1' mm/24hrs)'
'set strsiz 0.15'
'draw string 4.25 10.3 Ini: YYMMDDHH'
'set string 4 tc 6'
'draw string 1.8 9.8 RAW'
'draw string 4.4 9.8 CAL_bc'
'draw string 7.1 9.8 OBS'
'set strsiz 0.08'
*'draw string 1.6 0.15 YUEJIAN ZHU, GMB/EMC/NCEP/NOAA'
'print'
'printim aAMT1_YYMMDDHH.gif gif x850 y1100 white'
*say 'type in c to continue or quit to exit'
*pull corquit
*corquit

'disable print gmeta_AMT1_YYMMDDHHa'
*--------------day 2-------------------------------------
'enable print gmeta_AMT1_YYMMDDHHb'
'set display color white'
'clear'

'open FILENAME1'
'open FILENAME2'

istart=132
iend=204
while (istart<=iend)
ini=istart-24
 if (istart=132)
 'set parea 0.3 3.0  7.2 9.7'
 endif
 if (istart=156)
 'set parea 0.3 3.0  4.9 7.4'
 endif
 if (istart=180)
 'set parea 0.3 3.0 2.6 5.1'
 endif
 if (istart=204)
 'set parea 0.3 3.0 0.3 2.8'
 endif

ttime=(istart-12)/24

jstart=istart+4
'set t 'ttime''
'set grads off'
'set gxout shaded'
'set clevs  5 15 25 35 45 55 65 75 85 95'
'set ccols  0 41 31 32 33 34 35 36 37 38 39'
'd probsfc'
'set gxout contour'
'set cthick 2'
'set ccolor 1'
'set cstyle 1'
'set clevs 5 35 65 95  '
'set clopts -1 -1 0.05'  
'd probsfc'
'draw ylab \\ 'ini'-'istart' hr fcst'
if (istart=48)
*'run cbar.gs'
endif

istart=istart+24
endwhile

istart=132
iend=204
while (istart<=iend)
 if (istart=132)
 'set parea 3.0 5.7 7.2 9.7'
 endif
 if (istart=156)
 'set parea 3.0 5.7 4.9 7.4'
 endif
 if (istart=180)
 'set parea 3.0 5.7 2.6 5.1'
 endif
 if (istart=204)
 'set parea 3.0 5.7 0.3 2.8'
 endif

ttime=(istart-12)/24
jstart=istart+4

'set t 'ttime''
'set grads off'
'set gxout shaded'
'set clevs  5 15 25 35 45 55 65 75 85 95'
'set ccols  0 41 31 32 33 34 35 36 37 38 39'
'd probsfc.2'
'set gxout contour'
'set cthick 2'
'set ccolor 1'
'set cstyle 1'
'set clevs 5 35 65 95  '
'set clopts -1 -1 0.05'  
'd probsfc.2'
*'draw ylab 'istart'-hour forecast'

if (istart=204)
'run cbarn.gs 0.5 0 3.1 0.2'
endif

istart=istart+24
endwhile

'close 2'
'close 1'

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
'set clevs  AMT1' 
'set ccols  0  35'  
'set cmin AMT1'
'd apcpsfc.1'
'set gxout contour'
'set cthick 2'
'set ccolor 1'
'set cstyle 1'
'set clevs AMT1'  
'set clopts -1 -1 0.05'  
'set cmin AMT1'
'd apcpsfc.1'

if (istart=204)
'run cbarn.gs 0.45 0 6.95 0.2'
endif
'close 1'
istart=istart+24
endwhile

'set vpage 0.0 8.5 0.0 11.0'
'set strsiz 0.15'
'set string 1 tc 6'
'draw string 4.25 10.6 Ens Prob of Precip Amount Exceeding 'AMT2' inch ('AMT1' mm/24hrs)'
'set strsiz 0.15'
'draw string 4.25 10.3 Ini: YYMMDDHH'
'set string 4 tc 6'
'draw string 1.8 9.8 RAW'
'draw string 4.4 9.8 CAL_bc'
'draw string 7.1 9.8 OBS'
'set strsiz 0.08'
*'draw string 1.6 0.15 YUEJIAN ZHU, GMB/EMC/NCEP/NOAA'
'print'
'printim bAMT1_YYMMDDHH.gif gif x850 y1100 white'
*say 'type in c to continue or quit to exit'
*pull corquit
*corquit

'disable print gmeta_AMT1_YYMMDDHHb'

*--------------day 3-------------------------------------
'enable print gmeta_AMT1_YYMMDDHHc'
'set display color white'
'clear'
'open FILENAME1'
'open FILENAME2'

istart=228
iend=300
while (istart<=iend)
ini=istart-24
 if (istart=228)
 'set parea 0.3 3.0  7.2 9.7'
 endif
 if (istart=252)
 'set parea 0.3 3.0  4.9 7.4'
 endif
 if (istart=276)
 'set parea 0.3 3.0 2.6 5.1'
 endif
 if (istart=300)
 'set parea 0.3 3.0 0.3 2.8'
 endif

ttime=(istart-12)/24
jstart=istart+8

'set t 'ttime''
'set grads off'
'set gxout shaded'
'set clevs  5 15 25 35 45 55 65 75 85 95'
'set ccols  0 41 31 32 33 34 35 36 37 38 39'
'd probsfc'
'set gxout contour'
'set cthick 2'
'set ccolor 1'
'set cstyle 1'
'set clevs 5 35 65 95  '
'set clopts -1 -1 0.05'  
'd probsfc'
'draw ylab \\ 'ini'-'istart' hr fcst'
if (istart=72)
*'run cbar.gs'
endif

istart=istart+24
endwhile

istart=228
iend=300
while (istart<=iend)
 if (istart=228)
 'set parea 3.0 5.7 7.2 9.7'
 endif
 if (istart=252)
 'set parea 3.0 5.7 4.9 7.4'
 endif
 if (istart=276)
 'set parea 3.0 5.7 2.6 5.1'
 endif
 if (istart=300)
 'set parea 3.0 5.7 0.3 2.8'
 endif

ttime=(istart-12)/24
jstart=istart+8

'set t 'ttime''
'set grads off'
'set gxout shaded'
'set clevs  5 15 25 35 45 55 65 75 85 95'
'set ccols  0 41 31 32 33 34 35 36 37 38 39'
'd probsfc.2'
'set gxout contour'
'set cthick 2'
'set ccolor 1'
'set cstyle 1'
'set clevs 5 35 65 95  '
'set clopts -1 -1 0.05'  
'd probsfc.2'
*'draw ylab 'istart'-hour forecast'

if (istart=300)
'run cbarn.gs 0.5 0 3.1 0.2'
endif

istart=istart+24
endwhile

'close 2'
'close 1'

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
'set clevs  AMT1' 
'set ccols  0  35'  
'set cmin AMT1'
'd apcpsfc.1'
'set gxout contour'
'set cthick 2'
'set ccolor 1'
'set cstyle 1'
'set clevs AMT1'  
'set clopts -1 -1 0.05'  
'set cmin AMT1'
'd apcpsfc.1'

if (istart=300)
'run cbarn.gs 0.45 0 6.95 0.2'
endif
'close 1'
istart=istart+24
endwhile

'set vpage 0.0 8.5 0.0 11.0'
'set strsiz 0.15'
'set string 1 tc 6'
'draw string 4.25 10.6 Ens Prob of Precip Amount Exceeding 'AMT2' inch ('AMT1' mm/24hrs)'
'set strsiz 0.15'
'draw string 4.25 10.3 Ini: YYMMDDHH'
'set string 4 tc 6'
'draw string 1.8 9.8 RAW'
'draw string 4.4 9.8 CAL_bc'
'draw string 7.1 9.8 OBS'
'set strsiz 0.08'
*'draw string 1.6 0.15 YUEJIAN ZHU, GMB/EMC/NCEP/NOAA'
'print'
'printim cAMT1_YYMMDDHH.gif gif x850 y1100 white'
*say 'type in c to continue or quit to exit'
*pull corquit
*corquit

'disable print gmeta_AMT1_YYMMDDHHc'

*--------------day 4-------------------------------------
'enable print gmeta_AMT1_YYMMDDHHd'
'set display color white'
'clear'
'open FILENAME1'
'open FILENAME2'

istart=324
iend=372
while (istart<=iend)
ini=istart-24
 if (istart=324)
 'set parea 0.3 3.0  7.2 9.7'
 endif
 if (istart=348)
 'set parea 0.3 3.0  4.9 7.4'
 endif
 if (istart=372)
 'set parea 0.3 3.0 2.6 5.1'
 endif

ttime=(istart-12)/24
jstart=istart+12

'set t 'ttime''
'set grads off'
'set gxout shaded'
'set clevs  5 15 25 35 45 55 65 75 85 95'
'set ccols  0 41 31 32 33 34 35 36 37 38 39'
'd probsfc'
'set gxout contour'
'set cthick 2'
'set ccolor 1'
'set cstyle 1'
'set clevs 5 35 65 95  '
'set clopts -1 -1 0.05'  
'd probsfc'
'draw ylab \\ 'ini'-'istart' hr fcst'
if (istart=96)
*'run cbar.gs'
endif

istart=istart+24
endwhile

istart=324
iend=372
while (istart<=iend)
 if (istart=324)
 'set parea 3.0 5.7 7.2 9.7'
 endif
 if (istart=348)
 'set parea 3.0 5.7 4.9 7.4'
 endif
 if (istart=372)
 'set parea 3.0 5.7 2.6 5.1'
 endif

ttime=(istart-12)/24
jstart=istart+12

'set t 'ttime''
'set grads off'
'set gxout shaded'
'set clevs  5 15 25 35 45 55 65 75 85 95'
'set ccols  0 41 31 32 33 34 35 36 37 38 39'
'd probsfc.2'
'set gxout contour'
'set cthick 2'
'set ccolor 1'
'set cstyle 1'
'set clevs 5 35 65 95  '
'set clopts -1 -1 0.05'  
'd probsfc.2'
*'draw ylab 'istart'-hour forecast'

if (istart=372)
'run cbarn.gs 0.5 0 3.1 0.2'
endif

istart=istart+24
endwhile

'close 2'
'close 1'

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
'set clevs  AMT1' 
'set ccols  0  35'  
'set cmin AMT1'
'd apcpsfc.1'
'set gxout contour'
'set cthick 2'
'set ccolor 1'
'set cstyle 1'
'set clevs AMT1'  
'set clopts -1 -1 0.05'  
'set cmin AMT1'
'd apcpsfc.1'

if (istart=372)
'run cbarn.gs 0.45 0 6.95 0.2'
endif
'close 1'
istart=istart+24
endwhile

'set vpage 0.0 8.5 0.0 11.0'
'set strsiz 0.15'
'set string 1 tc 6'
'draw string 4.25 10.6 Ens Prob of Precip Amount Exceeding 'AMT2' inch ('AMT1' mm/24hrs)'
'set strsiz 0.15'
'draw string 4.25 10.3 Ini: YYMMDDHH'
'set string 4 tc 6'
'draw string 1.8 9.8 RAW'
'draw string 4.4 9.8 CAL_bc'
'draw string 7.1 9.8 OBS'
'set strsiz 0.08'
*'draw string 1.6 0.15 YUEJIAN ZHU, GMB/EMC/NCEP/NOAA'
'print'
'printim dAMT1_YYMMDDHH.gif gif x850 y1100 white'
*say 'type in c to continue or quit to exit'
*pull corquit
*corquit

'disable print gmeta_AMT1_YYMMDDHHd'

'quit'
