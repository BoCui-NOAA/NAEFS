'open version.ctl'

'run rgbset.gs'
'set display color white'
'clear'

'set strsiz 0.14'
'set string 1 tl 6'
'set dfile 1'
'set map 15 3 2'
'set t tef'
'set vpage 0.0 10.0 0.0 8.0'
'set grads off'
'set gxout shaded'
*'set ccols 49 48 47 46 45 44 43 42 41 0 0 21 22 23 24 25 26 27 28 29'
*'set clevs -100 -60 -40 -30 -25 -20 -15 -10 -5 0.0 5 10 15 20 25 30 40 60 100'
*'set clevs -3.0 -2.0 -1.5 -1.0 -0.8 -0.6 -0.4 -0.2 -0.1 0.0 0.1 0.2 0.4 0.6 0.8 1.0 1.5 2.0 3.0'
'set clevs 0 10 20 30 40 50 60 70 80 90 100'
'd var'
'run cbarn.gs'
'draw title NAEFS version INTER PQPF  > PRCP mm \ CDATE fcst fhr hr'

'gxprint enscqpf.png x1100 y850'
'c'

quit

