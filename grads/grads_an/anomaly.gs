'open me.ctl'                   

'run rgbset.gs'
'set display color white'
'clear'

'set strsiz 0.14'
'set string 1 tl 6'
'set dfile 1'
'set map 15 3 2'
'set t 1'
'set vpage 0.5 10.5 0.0 8.0'
'set grads off'
'set gxout shaded'
*'set cint 4'
'set ccols 49 48 47 46 45 44 43 42 41 0 0 21 22 23 24 25 26 27 28 29'
'd tmp2m'
'run cbarn.gs'
'draw title Anomaly Forecast Percentile 2m Temperature \ Member MEM ini CDATE fcst fhr hr '

'gxprint t2m.png x1100 y850'

'c'
quit

