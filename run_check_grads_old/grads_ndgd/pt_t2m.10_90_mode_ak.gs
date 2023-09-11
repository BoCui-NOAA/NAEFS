'open avg.ctl'
'open 10pt.ctl'
'open 90pt.ctl'
'open 50pt.ctl'
'open spread.ctl'

'run rgbset.gs'
'set display color white'
'clear'

'enable print t2m.gr'
'set strsiz 0.14'
'set string 1 tl 6'
'set dfile 1'
'set map 15 3 2'
'set t 1'
'set vpage 0.2 5.4 4.25 8.05'
'set lon 150 266.5'
'set lat 40 76'
'set grads off'
'set gxout shaded'
'd tmp2m.5'
'run cbar'
'set gxout contour'
'set cint 4'
'd tmp2m'
'draw title Ensemble Average & Spread for 2m Temp'

'set vpage 5.6 10.8 4.25 8.05'
'set cint 4'
'set ccols 49 48 47 46 45 44 43 42 41 0 0 21 22 23 24 25 26 27 28 29'
'set clevs 220 230 236 240 244 248 252 256 260 264 268 272 276 280 284 288 292 296 302 312'
'd tmp2m.2'
'draw title 10% Probability Forecast for 2m Temp'

'set vpage 0.2 5.4 0.0 4.0'   
'set cint 4'
'set ccols 49 48 47 46 45 44 43 42 41 0 0 21 22 23 24 25 26 27 28 29'
'd tmp2m.3'
'draw title 90% Probability Forecast for 2m Temp'

'set vpage 5.6 10.8 0.0 4.0'
'set cint 4'
'set ccols 49 48 47 46 45 44 43 42 41 0 0 21 22 23 24 25 26 27 28 29'
'd tmp2m.4'
'draw title 50% Probability Forecast for 2m Temp'

'set string 4'
'set strsiz 0.12'
'draw string 8.6 0.15 BO CUI, GCWMB/EMC/NCEP/NOAA'
'print'
'disable print t2m.gr'
'c'
quit

*say 'type in c to continue or quit to exit'
*pull corquit
*corquit