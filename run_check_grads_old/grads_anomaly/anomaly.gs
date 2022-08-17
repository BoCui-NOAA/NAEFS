'open anomaly.ctl'

'run rgbset.gs'
'set display color white'
'clear'

'enable print t2m.gr'
'set strsiz 0.14'
'set string 1 tl 6'
'set dfile 1'
'set map 15 3 2'
'set t 1'
'set grads off'
'set gxout shaded'
'set cint 4'
'set ccols 49 48 47 46 45 44 43 42 41 0 0 21 22 23 24 25 26 27 28 29'
'd tmp2m'
'run cbarn.gs'
'draw title Anomaly Forecast for T2m'

'set string 4'
'set strsiz 0.12'
*'draw string 8.6 0.15 BO CUI, GCWMB/EMC/NCEP/NOAA'
'print'
'disable print t2m.gr'
'c'
quit

*say 'type in c to continue or quit to exit'
*pull corquit
*corquit
