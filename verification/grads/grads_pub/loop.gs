
ts=00z02oct2001
te=00z02oct2001

'open pgbanl_loop.ctl'

*'set t 5'
*'set lat 0 90'
*'set lon 0 180'
*'set lev 850'
*'d tloop(ave(z,t-2,t+2))'
*'define ta=ave(t,time='ts',time='te')'
*say result
*line=sublin(result,1)
*word=subwrd(line,4)
*'set cint 5.'
*'d ta'

'set lon 0 180'
'set lat 0 90'
'set lev 500'
*'set t 2 3 '
*'d ave(z,t=2,t=2)'


