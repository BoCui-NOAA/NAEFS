
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
istart=6
iend=24
while (istart<=iend)
 if (istart=6)
 'set parea 0.4 3.1  7.2 9.7'
 endif
 if (istart=12)
 'set parea 0.4 3.1  4.9 7.4'
 endif
 if (istart=18)
 'set parea 0.4 3.1 2.6 5.1'
 endif
 if (istart=24)
 'set parea 0.4 3.1 0.3 2.8'
 endif

ttime=istart/6

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
'draw ylab \\ 'istart'-hour forecast'

if (istart=24)
*'run cbar.gs'
endif

istart=istart+6
endwhile

istart=6
iend=24
while (istart<=iend)
 if (istart=6)
 'set parea 3.1 5.8 7.2 9.7'
 endif
 if (istart=12)
 'set parea 3.1 5.8 4.9 7.4'
 endif
 if (istart=18)
 'set parea 3.1 5.8 2.6 5.1'
 endif
 if (istart=24)
 'set parea 3.1 5.8 0.3 2.8'
 endif

ttime=istart/6

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

if (istart=24)
'run cbarn.gs 0.5 0 3.1 0.2'
endif

istart=istart+6
endwhile

'close 2'
'close 1'

istart=6
iend=24
while (istart<=iend)
 if (istart=6)
 'open obs/obs_06.ctl'
'set parea 5.8 8.5 7.2 9.7'
 endif
 if (istart=12)
 'open obs/obs_12.ctl'
'set parea 5.8 8.5 4.9 7.4'
 endif
 if (istart=18)
 'open obs/obs_18.ctl'
'set parea 5.8 8.5 2.6 5.1' 
 endif
 if (istart=24)
 'open obs/obs_24.ctl'
'set parea 5.8 8.5 0.3 2.8' 
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

if (istart=24)
'run cbarn.gs 0.45 0 6.95 0.2'
endif
'close 1'
istart=istart+6
endwhile

'set vpage 0.0 8.5 0.0 11.0'
'set strsiz 0.15'
'set string 1 tc 6'
'draw string 4.25 10.6 Ens Prob of Precip Amount Exceeding 'AMT2' inch ('AMT1' mm/6hrs)'
'set strsiz 0.15'
'draw string 4.25 10.3 Ini: YYMMDDHH'
'set string 4 tc 6'
'draw string 1.8 9.8 RAW'
'draw string 4.4 9.8 CAL'
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

istart=30
iend=48
while (istart<=iend)
 if (istart=30)
 'set parea 0.4 3.1  7.2 9.7'
 endif
 if (istart=36)
 'set parea 0.4 3.1  4.9 7.4'
 endif
 if (istart=42)
 'set parea 0.4 3.1 2.6 5.1'
 endif
 if (istart=48)
 'set parea 0.4 3.1 0.3 2.8'
 endif

ttime=istart/6

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
'draw ylab \\ 'istart'-hour forecast'

if (istart=48)
*'run cbar.gs'
endif

istart=istart+6
endwhile

istart=30
iend=48
while (istart<=iend)
 if (istart=30)
 'set parea 3.1 5.8 7.2 9.7'
 endif
 if (istart=36)
 'set parea 3.1 5.8 4.9 7.4'
 endif
 if (istart=42)
 'set parea 3.1 5.8 2.6 5.1'
 endif
 if (istart=48)
 'set parea 3.1 5.8 0.3 2.8'
 endif

ttime=istart/6
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

if (istart=48)
'run cbarn.gs 0.5 0 3.1 0.2'
endif

istart=istart+6
endwhile

'close 2'
'close 1'

istart=30
iend=48
while (istart<=iend)
 if (istart=30)
 'open obs/obs_30.ctl'
'set parea 5.8 8.5 7.2 9.7'
 endif
 if (istart=36)
 'open obs/obs_36.ctl'
'set parea 5.8 8.5 4.9 7.4'
 endif
 if (istart=42)
 'open obs/obs_42.ctl'
'set parea 5.8 8.5 2.6 5.1' 
 endif
 if (istart=48)
 'open obs/obs_48.ctl'
'set parea 5.8 8.5 0.3 2.8' 
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

if (istart=48)
'run cbarn.gs 0.45 0 6.95 0.2'
endif
'close 1'
istart=istart+6
endwhile

'set vpage 0.0 8.5 0.0 11.0'
'set strsiz 0.15'
'set string 1 tc 6'
'draw string 4.25 10.6 Ens Prob of Precip Amount Exceeding 'AMT2' inch ('AMT1' mm/6hrs)'
'set strsiz 0.15'
'draw string 4.25 10.3 Ini: YYMMDDHH'
'set string 4 tc 6'
'draw string 1.8 9.8 RAW'
'draw string 4.4 9.8 CAL'
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

istart=54
iend=72
while (istart<=iend)
 if (istart=54)
 'set parea 0.4 3.1  7.2 9.7'
 endif
 if (istart=60)
 'set parea 0.4 3.1  4.9 7.4'
 endif
 if (istart=66)
 'set parea 0.4 3.1 2.6 5.1'
 endif
 if (istart=72)
 'set parea 0.4 3.1 0.3 2.8'
 endif

ttime=istart/6
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
'draw ylab \\ 'istart'-hour forecast'

if (istart=72)
*'run cbar.gs'
endif

istart=istart+6
endwhile

istart=54
iend=72
while (istart<=iend)
 if (istart=54)
 'set parea 3.1 5.8 7.2 9.7'
 endif
 if (istart=60)
 'set parea 3.1 5.8 4.9 7.4'
 endif
 if (istart=66)
 'set parea 3.1 5.8 2.6 5.1'
 endif
 if (istart=72)
 'set parea 3.1 5.8 0.3 2.8'
 endif

ttime=istart/6
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

if (istart=72)
'run cbarn.gs 0.5 0 3.1 0.2'
endif

istart=istart+6
endwhile

'close 2'
'close 1'

istart=54
iend=72
while (istart<=iend)
 if (istart=54)
 'open obs/obs_54.ctl'
'set parea 5.8 8.5 7.2 9.7'
 endif
 if (istart=60)
 'open obs/obs_60.ctl'
'set parea 5.8 8.5 4.9 7.4'
 endif
 if (istart=66)
 'open obs/obs_66.ctl'
'set parea 5.8 8.5 2.6 5.1' 
 endif
 if (istart=72)
 'open obs/obs_72.ctl'
'set parea 5.8 8.5 0.3 2.8' 
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

if (istart=72)
'run cbarn.gs 0.45 0 6.95 0.2'
endif
'close 1'
istart=istart+6
endwhile

'set vpage 0.0 8.5 0.0 11.0'
'set strsiz 0.15'
'set string 1 tc 6'
'draw string 4.25 10.6 Ens Prob of Precip Amount Exceeding 'AMT2' inch ('AMT1' mm/6hrs)'
'set strsiz 0.15'
'draw string 4.25 10.3 Ini: YYMMDDHH'
'set string 4 tc 6'
'draw string 1.8 9.8 RAW'
'draw string 4.4 9.8 CAL'
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

istart=78
iend=96
while (istart<=iend)
 if (istart=78)
 'set parea 0.4 3.1  7.2 9.7'
 endif
 if (istart=84)
 'set parea 0.4 3.1  4.9 7.4'
 endif
 if (istart=90)
 'set parea 0.4 3.1 2.6 5.1'
 endif
 if (istart=96)
 'set parea 0.4 3.1 0.3 2.8'
 endif

ttime=istart/6
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
'draw ylab \\ 'istart'-hour forecast'

if (istart=96)
*'run cbar.gs'
endif

istart=istart+6
endwhile

istart=78
iend=96
while (istart<=iend)
 if (istart=78)
 'set parea 3.1 5.8 7.2 9.7'
 endif
 if (istart=84)
 'set parea 3.1 5.8 4.9 7.4'
 endif
 if (istart=90)
 'set parea 3.1 5.8 2.6 5.1'
 endif
 if (istart=96)
 'set parea 3.1 5.8 0.3 2.8'
 endif

ttime=istart/6
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

if (istart=96)
'run cbarn.gs 0.5 0 3.1 0.2'
endif

istart=istart+6
endwhile

'close 2'
'close 1'

istart=78
iend=96
while (istart<=iend)
 if (istart=78)
 'open obs/obs_78.ctl'
'set parea 5.8 8.5 7.2 9.7'
 endif
 if (istart=84)
 'open obs/obs_84.ctl'
'set parea 5.8 8.5 4.9 7.4'
 endif
 if (istart=90)
 'open obs/obs_90.ctl'
'set parea 5.8 8.5 2.6 5.1' 
 endif
 if (istart=96)
 'open obs/obs_96.ctl'
'set parea 5.8 8.5 0.3 2.8' 
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

if (istart=96)
'run cbarn.gs 0.45 0 6.95 0.2'
endif
'close 1'
istart=istart+6
endwhile

'set vpage 0.0 8.5 0.0 11.0'
'set strsiz 0.15'
'set string 1 tc 6'
'draw string 4.25 10.6 Ens Prob of Precip Amount Exceeding 'AMT2' inch ('AMT1' mm/6hrs)'
'set strsiz 0.15'
'draw string 4.25 10.3 Ini: YYMMDDHH'
'set string 4 tc 6'
'draw string 1.8 9.8 RAW'
'draw string 4.4 9.8 CAL'
'draw string 7.1 9.8 OBS'
'set strsiz 0.08'
*'draw string 1.6 0.15 YUEJIAN ZHU, GMB/EMC/NCEP/NOAA'
'print'
'printim dAMT1_YYMMDDHH.gif gif x850 y1100 white'
*say 'type in c to continue or quit to exit'
*pull corquit
*corquit

'disable print gmeta_AMT1_YYMMDDHHd'

*--------------day 5-------------------------------------
'enable print gmeta_AMT1_YYMMDDHHe'
'set display color white'
'clear'
'open FILENAME1'
'open FILENAME2'

istart=102
iend=120
while (istart<=iend)
 if (istart=102)
 'set parea 0.4 3.1  7.2 9.7'
 endif
 if (istart=108)
 'set parea 0.4 3.1  4.9 7.4'
 endif
 if (istart=114)
 'set parea 0.4 3.1 2.6 5.1'
 endif
 if (istart=120)
 'set parea 0.4 3.1 0.3 2.8'
 endif

ttime=istart/6

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
'draw ylab \\ 'istart'-hour forecast'

if (istart=120)
*'run cbar.gs'
endif

istart=istart+6
endwhile

istart=102
iend=120
while (istart<=iend)
 if (istart=102)
 'set parea 3.1 5.8 7.2 9.7'
 endif
 if (istart=108)
 'set parea 3.1 5.8 4.9 7.4'
 endif
 if (istart=114)
 'set parea 3.1 5.8 2.6 5.1'
 endif
 if (istart=120)
 'set parea 3.1 5.8 0.3 2.8'
 endif

ttime=istart/6

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

if (istart=120)
'run cbarn.gs 0.5 0 3.1 0.2'
endif

istart=istart+6
endwhile

'close 2'
'close 1'

istart=102
iend=120
while (istart<=iend)
 if (istart=102)
 'open obs/obs_102.ctl'
'set parea 5.8 8.5 7.2 9.7'
 endif
 if (istart=108)
 'open obs/obs_108.ctl'
'set parea 5.8 8.5 4.9 7.4'
 endif
 if (istart=114)
 'open obs/obs_114.ctl'
'set parea 5.8 8.5 2.6 5.1' 
 endif
 if (istart=120)
 'open obs/obs_120.ctl'
'set parea 5.8 8.5 0.3 2.8' 
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

if (istart=120)
'run cbarn.gs 0.45 0 6.95 0.2'
endif
'close 1'
istart=istart+6
endwhile

'set vpage 0.0 8.5 0.0 11.0'
'set strsiz 0.15'
'set string 1 tc 6'
'draw string 4.25 10.6 Ens Prob of Precip Amount Exceeding 'AMT2' inch ('AMT1' mm/6hrs)'
'set strsiz 0.15'
'draw string 4.25 10.3 Ini: YYMMDDHH'
'set string 4 tc 6'
'draw string 1.8 9.8 RAW'
'draw string 4.4 9.8 CAL'
'draw string 7.1 9.8 OBS'
'set strsiz 0.08'
*'draw string 1.6 0.15 YUEJIAN ZHU, GMB/EMC/NCEP/NOAA'
'print'
'printim eAMT1_YYMMDDHH.gif gif x850 y1100 white'
*say 'type in c to continue or quit to exit'
*pull corquit
*corquit

'disable print gmeta_AMT1_YYMMDDHHe'

*--------------day 6-------------------------------------
'enable print gmeta_AMT1_YYMMDDHHf'
'set display color white'
'clear'
'open FILENAME1'
'open FILENAME2'

istart=126
iend=144
while (istart<=iend)
 if (istart=126)
 'set parea 0.4 3.1  7.2 9.7'
 endif
 if (istart=132)
 'set parea 0.4 3.1  4.9 7.4'
 endif
 if (istart=138)
 'set parea 0.4 3.1 2.6 5.1'
 endif
 if (istart=144)
 'set parea 0.4 3.1 0.3 2.8'
 endif

ttime=istart/6

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
'draw ylab \\ 'istart'-hour forecast'

if (istart=144)
*'run cbar.gs'
endif

istart=istart+6
endwhile

istart=126
iend=144
while (istart<=iend)
 if (istart=126)
 'set parea 3.1 5.8 7.2 9.7'
 endif
 if (istart=132)
 'set parea 3.1 5.8 4.9 7.4'
 endif
 if (istart=138)
 'set parea 3.1 5.8 2.6 5.1'
 endif
 if (istart=144)
 'set parea 3.1 5.8 0.3 2.8'
 endif

ttime=istart/6
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

if (istart=144)
'run cbarn.gs 0.5 0 3.1 0.2'
endif

istart=istart+6
endwhile

'close 2'
'close 1'

istart=126
iend=144
while (istart<=iend)
 if (istart=126)
 'open obs/obs_126.ctl'
'set parea 5.8 8.5 7.2 9.7'
 endif
 if (istart=132)
 'open obs/obs_132.ctl'
'set parea 5.8 8.5 4.9 7.4'
 endif
 if (istart=138)
 'open obs/obs_138.ctl'
'set parea 5.8 8.5 2.6 5.1' 
 endif
 if (istart=144)
 'open obs/obs_144.ctl'
'set parea 5.8 8.5 0.3 2.8' 
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

if (istart=144)
'run cbarn.gs 0.45 0 6.95 0.2'
endif
'close 1'
istart=istart+6
endwhile

'set vpage 0.0 8.5 0.0 11.0'
'set strsiz 0.15'
'set string 1 tc 6'
'draw string 4.25 10.6 Ens Prob of Precip Amount Exceeding 'AMT2' inch ('AMT1' mm/6hrs)'
'set strsiz 0.15'
'draw string 4.25 10.3 Ini: YYMMDDHH'
'set string 4 tc 6'
'draw string 1.8 9.8 RAW'
'draw string 4.4 9.8 CAL'
'draw string 7.1 9.8 OBS'
'set strsiz 0.08'
*'draw string 1.6 0.15 YUEJIAN ZHU, GMB/EMC/NCEP/NOAA'
'print'
'printim fAMT1_YYMMDDHH.gif gif x850 y1100 white'
*say 'type in c to continue or quit to exit'
*pull corquit
*corquit

'disable print gmeta_AMT1_YYMMDDHHf'

*--------------day 7-------------------------------------
'enable print gmeta_AMT1_YYMMDDHHg'
'set display color white'
'clear'

'open FILENAME1'
'open FILENAME2'

istart=150
iend=168
while (istart<=iend)
 if (istart=150)
 'set parea 0.4 3.1  7.2 9.7'
 endif
 if (istart=156)
 'set parea 0.4 3.1  4.9 7.4'
 endif
 if (istart=162)
 'set parea 0.4 3.1 2.6 5.1'
 endif
 if (istart=168)
 'set parea 0.4 3.1 0.3 2.8'
 endif

ttime=istart/6
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
'draw ylab \\ 'istart'-hour forecast'

if (istart=168)
*'run cbar.gs'
endif

istart=istart+6
endwhile

istart=150
iend=168
while (istart<=iend)
 if (istart=150)
 'set parea 3.1 5.8 7.2 9.7'
 endif
 if (istart=156)
 'set parea 3.1 5.8 4.9 7.4'
 endif
 if (istart=162)
 'set parea 3.1 5.8 2.6 5.1'
 endif
 if (istart=168)
 'set parea 3.1 5.8 0.3 2.8'
 endif

ttime=istart/6
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

if (istart=168)
'run cbarn.gs 0.5 0 3.1 0.2'
endif

istart=istart+6
endwhile

'close 2'
'close 1'

istart=150
iend=168
while (istart<=iend)
 if (istart=150)
 'open obs/obs_150.ctl'
'set parea 5.8 8.5 7.2 9.7'
 endif
 if (istart=156)
 'open obs/obs_156.ctl'
'set parea 5.8 8.5 4.9 7.4'
 endif
 if (istart=162)
 'open obs/obs_162.ctl'
'set parea 5.8 8.5 2.6 5.1' 
 endif
 if (istart=168)
 'open obs/obs_168.ctl'
'set parea 5.8 8.5 0.3 2.8' 
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

if (istart=168)
'run cbarn.gs 0.45 0 6.95 0.2'
endif
'close 1'
istart=istart+6
endwhile

'set vpage 0.0 8.5 0.0 11.0'
'set strsiz 0.15'
'set string 1 tc 6'
'draw string 4.25 10.6 Ens Prob of Precip Amount Exceeding 'AMT2' inch ('AMT1' mm/6hrs)'
'set strsiz 0.15'
'draw string 4.25 10.3 Ini: YYMMDDHH'
'set string 4 tc 6'
'draw string 1.8 9.8 RAW'
'draw string 4.4 9.8 CAL'
'draw string 7.1 9.8 OBS'
'set strsiz 0.08'
*'draw string 1.6 0.15 YUEJIAN ZHU, GMB/EMC/NCEP/NOAA'
'print'
'printim gAMT1_YYMMDDHH.gif gif x850 y1100 white'
*say 'type in c to continue or quit to exit'
*pull corquit
*corquit

'disable print gmeta_AMT1_YYMMDDHHg'

*--------------day 8-------------------------------------
'enable print gmeta_AMT1_YYMMDDHHh'
'set display color white'
'clear'
'open FILENAME1'
'open FILENAME2'

istart=174
iend=180
while (istart<=iend)
 if (istart=174)
 'set parea 0.4 3.1  7.2 9.7'
 endif
 if (istart=180)
 'set parea 0.4 3.1  4.9 7.4'
 endif
 if (istart=186)
 'set parea 0.4 3.1 2.6 5.1'
 endif
 if (istart=192)
 'set parea 0.4 3.1 0.3 2.8'
 endif

ttime=istart/6
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
'draw ylab \\ 'istart'-hour forecast'

if (istart=180)
*'run cbar.gs'
endif

istart=istart+6
endwhile

istart=174
iend=180
while (istart<=iend)
 if (istart=174)
 'set parea 3.1 5.8 7.2 9.7'
 endif
 if (istart=180)
 'set parea 3.1 5.8 4.9 7.4'
 endif
 if (istart=186)
 'set parea 3.1 5.8 2.6 5.1'
 endif
 if (istart=192)
 'set parea 3.1 5.8 0.3 2.8'
 endif

ttime=istart/6
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

if (istart=180)
'run cbarn.gs 0.5 0 3.1 4.8'
endif

istart=istart+6
endwhile

'close 2'
'close 1'

istart=174
iend=180
while (istart<=iend)
 if (istart=174)
 'open obs/obs_174.ctl'
'set parea 5.8 8.5 7.2 9.7'
 endif
 if (istart=180)
 'open obs/obs_180.ctl'
'set parea 5.8 8.5 4.9 7.4'
 endif
 if (istart=186)
 'open obs/obs_186.ctl'
'set parea 5.8 8.5 2.6 5.1' 
 endif
 if (istart=192)
 'open obs/obs_192.ctl'
'set parea 5.8 8.5 0.3 2.8' 
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

if (istart=180)
'run cbarn.gs 0.45 0 6.95 4.8'
endif
'close 1'
istart=istart+6
endwhile

'set vpage 0.0 8.5 0.0 11.0'
'set strsiz 0.15'
'set string 1 tc 6'
'draw string 4.25 10.6 Ens Prob of Precip Amount Exceeding 'AMT2' inch ('AMT1' mm/6hrs)'
'set strsiz 0.15'
'draw string 4.25 10.3 Ini: YYMMDDHH'
'set string 4 tc 6'
'draw string 1.8 9.8 RAW'
'draw string 4.4 9.8 CAL'
'draw string 7.1 9.8 OBS'
'set strsiz 0.08'
*'draw string 1.6 0.15 YUEJIAN ZHU, GMB/EMC/NCEP/NOAA'
'print'
'printim hAMT1_YYMMDDHH.gif gif x850 y1100 white'
*say 'type in c to continue or quit to exit'
*pull corquit
*corquit

'disable print gmeta_AMT1_YYMMDDHHh'
'quit'
