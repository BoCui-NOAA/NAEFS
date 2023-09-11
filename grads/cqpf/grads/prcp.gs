*
'open prcp.ctl'

'run /nfsuser/g01/wx20yz/grads/rgbset.gs'
'set lon 210 310'
'set lat 10 65'
'set mproj nps'
'set mpvals -120 -75 20 55'
'set gxout shaded'
'set mpdset mres'

'set display color white'
'clear'
'enable print gmeta_prcp'
'set grads off'
'set gxout shaded'
'set clevs  0.01 5.0 10.0 15.0 20.0 25.0 30.0'
'set ccols  0   21  22  31   33   35   37   39'
'set t 2'
'd prcp'
'set gxout contour'
'set cthick 2'
'set ccolor 1'
'set clevs   0.01 2.5 5.0 10.0 25.0'
'd prcp'
'draw title 24 hours accumulated precipitation by end of 2001051512'
'run /nfsuser/g01/wx20yz/grads/cbar.gs'
'print'

