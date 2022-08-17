'open me.ctl'

'run rgbset.gs'
'set display color white'
'clear'

'set strsiz 0.14'
'set string 1 tl 6'
'set dfile 1'
'set map 15 3 2'
**'set t tef'
*'set t 40'
'set vpage 0.0 10.0 0.0 8.0'
'set grads off'
'set gxout shaded'
'd tmp2m.1 '
'run cbarn.gs'
'draw title Bias Corrected Fcst of 2m Temperature \ on CDATE for fcst fhr hr '

'gxprint t2m_me.png x1100 y850'
'c'

'set strsiz 0.14'
'set string 1 tl 6'
'set dfile 1'
'set map 15 3 2'
**'set t tef'
*'set t 40'
'set vpage 0.0 10.0 0.0 8.0'
'set grads off'
'set gxout shaded'
'set z 5'
'd hgtprs.1'
'run cbarn.gs'
'draw title Bias Corrected Fcst of 500mb Height \ on CDATE for fcst fhr hr '

'gxprint z500_me.png x1100 y850'
'c'

'set strsiz 0.14'
'set string 1 tl 6'
'set dfile 1'
'set map 15 3 2'
*'set t tef'
'set vpage 0.0 10.0 0.0 8.0'
'set grads off'
'set gxout shaded'
'set z 6'
'd hgtprs.1'
'run cbarn.gs'
'draw title Bias Corrected Fcst of 250mb Height \ on CDATE for fcst fhr hr '

'gxprint z250_me.png x1100 y850'
'c'

'set strsiz 0.14'
'set string 1 tl 6'
'set dfile 1'
'set map 15 3 2'
*'set t tef'
'set vpage 0.0 10.0 0.0 8.0'
'set grads off'
'set gxout shaded'
'set z 3'
'd tmpprs.1'
'run cbarn.gs'
'draw title Bias Corrected Fcst of 850mb Temp \ on CDATE for fcst fhr hr '

'gxprint t850_me.png x1100 y850'
'c'

'set strsiz 0.14'
'set string 1 tl 6'
'set dfile 1'
'set map 15 3 2'
*'set t tef'
'set vpage 0.0 10.0 0.0 8.0'
'set grads off'
'set gxout shaded'
'd UGRD10m'
'run cbarn.gs'
'draw title Bias Corrected Fcst of U10m \ on CDATE for fcst fhr hr '

'gxprint u10m_me.png x1100 y850'
'c'

'set strsiz 0.14'
'set string 1 tl 6'
'set dfile 1'
'set map 15 3 2'
*'set t tef'
'set vpage 0.0 10.0 0.0 8.0'
'set grads off'
'set gxout shaded'
'd VGRD10m'
'run cbarn.gs'
'draw title Bias Corrected Fcst of V10m \ on CDATE for fcst fhr hr '

'gxprint v10m_me.png x1100 y850'
'c'






quit

