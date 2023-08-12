
'open FILENAME_12-36.ctl'
'open FILENAME_36-60.ctl'
'open FILENAME_60-84.ctl'
'open FILENAME_84-108.ctl'
'open FILENAME_108-132.ctl'
'open FILENAME_132-156.ctl'
'open FILENAME_156-180.ctl'
'open FILENAME_180-204.ctl'

'run /nfsuser/g01/wx20yz/grads/rgbset.gs'
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

'enable print gmeta_XXX_YYMMDDHH'
'set display color white'
'clear'
istart=1
iend=8
while (istart<=iend)
 if (istart=5)
 'set vpage 0.0 4.8 0.18 3.41'
 endif
 if (istart=6)
 'set vpage 0.0 4.8 2.61 5.84'
 endif
 if (istart=7)
 'set vpage 0.0 4.8 5.04 8.27'
 endif
 if (istart=8)
 'set vpage 0.0 4.8 7.47 10.7'
 endif
 if (istart=1)
 'set vpage 3.7 8.5 0.18 3.41'
 endif
 if (istart=2)
 'set vpage 3.7 8.5 2.61 5.84'
 endif
 if (istart=3)
 'set vpage 3.7 8.5 5.04 8.27'
 endif
 if (istart=4)
 'set vpage 3.7 8.5 7.47 10.70'
 endif

ttime=4          

'set t 'ttime''
'set grads off'
'set gxout shaded'
'set clevs  0.01 5.0 10.0 15.0 20.0 25.0 30.0'
'set ccols  0   21  22  31   33   35   37   39'
'd apcpsfc.'istart''
'set gxout contour'
'set cthick 2'
'set ccolor 1'
'set cstyle 1'
'set clevs   0.01 2.5 5.0 10.0 25.0'
'd apcpsfc.'istart''
'draw ylab 'istart'-day forecast'

if (istart=1)
'run /nfsuser/g01/wx20yz/grads/cbar.gs'
endif
if (istart=5)
'run /nfsuser/g01/wx20yz/grads/cbar.gs'
endif

istart=istart+1
endwhile

'set vpage 0.0 8.5 0.0 11.0'
'set strsiz 0.16'
'draw string 4.25 10.9 NCEP/GFS YYY Quantitative Precipitation Forecast (mm/day)'
'set strsiz 0.16'
'draw string 4.25 10.6 Ini: YYMMDDHH Valid for YMDH1-YMDH2'
'set string 4'
*'draw string 2.25 10.5 RAW'
*'draw string 6.25 10.5 CAL'
'set strsiz 0.08'
'draw string 1.6 0.15 YUEJIAN ZHU, GMB/EMC/NCEP/NOAA'
'print'

say 'type in c to continue or quit to exit'
pull corquit
corquit

'disable print gmeta_XXX_YYMMDDHH'

*'quit'

