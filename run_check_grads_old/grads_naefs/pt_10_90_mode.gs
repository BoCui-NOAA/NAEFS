'open avg.ctl'
'open 10pt.ctl'
'open 90pt.ctl'
'open 50pt.ctl'
'open spread.ctl'

'run rgbset.gs'
'set display color white'
'clear'

'enable print z500.gr'
'set strsiz 0.14'
'set string 1 tl 6'
'set dfile 1'
'set map 15 3 2'
'set t 1'
'set lev 500'
'set vpage 0.2 5.4 4.25 8.05'
'set grads off'
'set gxout shaded'
'd hgtprs.5'
'run cbar'
'set gxout contour'
'set cint 40'
'd hgtprs'
'draw title Ensemble Average & Spread for 500 mb Height'

'set vpage 5.6 10.8 4.25 8.05'
'set cint 40'
'd hgtprs.2'
'draw title 10% Probability Forecast for 500 mb Height'

'set vpage 0.2 5.4 0.0 4.0'   
'set cint 40'
'd hgtprs.3'
'draw title 90% Probability Forecast for 500 mb Height'

'set vpage 5.6 10.8 0.0 4.0'
'set cint 40'
'd hgtprs.4'
'draw title 50% Probability Forecast for 500 mb Height'

'set string 4'
'set strsiz 0.12'
'draw string 8.6 0.15 BO CUI, GCWMB/EMC/NCEP/NOAA'
'print'
'disable print z500.gr'
'c'
quit

*say 'type in c to continue or quit to exit'
*pull corquit
*corquit
