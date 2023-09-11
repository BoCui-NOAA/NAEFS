'open naefs_mevf.ctl'
'open land_ndgd.ctl'

'run rgbset.gs'
'set display color white'
'clear'

isvar=1
ievar=10
ivar=isvar
while (ivar<=ievar)
var=getvar(ivar)
fld=getfld(ivar)
vcint=getvcint(ivar)
mecols=getmecols(ivar)
meclev=getmeclev(ivar)
unit=getunit(ivar)
head=gethead(ivar)

'enable print naefs_'fld'.png'
'reset'
'set dfile 1'                 
'set map 15 3 2'
'set t 1'
'set vpage 0.0 10.0 0.0 8.0'
'set grads off'
'set gxout shaded'
'set ccols 'mecols''
'set clevs 'meclev''
*'d 'var''
'd maskout('var',landsfc.2-1.0e-45)'
'run cbarn'
'draw title ENSM Ens. Mean Forecast Error w.r.t RTMA \ 'head' ( shaded, 'unit' )\ Averaged From: SDY to EDY (nfhr h)'

'set t 1'
*'define tcnt=aave('var',x=1,x=XDEF,y=1,y=YDEF)'
'define tcnt=aave(maskout(abs('var'),landsfc.2-1.0e-45),x=1,x=XDEF,y=1,y=YDEF)'
'd tcnt'
say result
line=sublin(result,1)
word=subwrd(line,4)
prbnh500=digs(word,3)

'set vpage 0 11 0 8.5'
'set strsiz 0.14'
'set string 1 tl 6'
'draw string 4.4 1.7 ABSAVG='prbnh500

'set string 4'
'set strsiz 0.12'
*'draw string 6.9 0.02 BO CUI, GCWMB/EMC/NCEP/NOAA'
*'print'
*'printim 'fld'_bias_rtma.gif '
*'disable print 'fld'_bias_rtma.gr'
'gxprint 'fld'_bias_rtma.gr'
'c'

*say 'type in c to continue or quit to exit'
*pull corquit
*corquit

ivar=ivar+1
endwhile

'quit'

function getvar(ivar)
if(ivar=1);var='tmp2m';endif;
if(ivar=2);var='ugrd10m';endif;
if(ivar=3);var='vgrd10m';endif;
if(ivar=4);var='pressfc';endif;
if(ivar=5);var='wind10m';endif;
if(ivar=6);var='wdir10m';endif;
if(ivar=7);var='tmax2m';endif;
if(ivar=8);var='tmin2m';endif;
if(ivar=9);var='dpt2m';endif;
if(ivar=10);var='rh2m';endif;
return var

function getfld(ivar)
if(ivar=1);fld='t2m';endif;
if(ivar=2);fld='u10m';endif;
if(ivar=3);fld='v10m';endif;
if(ivar=4);fld='pres';endif;
if(ivar=5);fld='wind10m';endif;
if(ivar=6);fld='wdir10m';endif;
if(ivar=7);fld='tmax2m';endif;
if(ivar=8);fld='tmin2m';endif;
if(ivar=9);fld='dpt2m';endif;
if(ivar=10);fld='rh2m';endif;
return fld

function getvcint(ivar)
if(ivar=1);vcint=2;endif;
if(ivar=2);vcint=2;endif;
if(ivar=3);vcint=2;endif;
if(ivar=4);vcint=2000;endif;
return vcint

function getmecols(ivar)
if(ivar=1);mecols='49 48 47 46 45 44 43 42 41 0 0 21 22 23 24 25 26 27 28 29';endif;
if(ivar=2);mecols='49 48 47 46 45 44 43 42 41 0 0 21 22 23 24 25 26 27 28 29';endif;
if(ivar=3);mecols='49 48 47 46 45 44 43 42 41 0 0 21 22 23 24 25 26 27 28 29';endif;
if(ivar=4);mecols='49 48 47 46 45 44 43 42 41 0 0 21 22 23 24 25 26 27 28 29';endif;
if(ivar=5);mecols='49 48 47 46 45 44 43 42 41 0 0 21 22 23 24 25 26 27 28 29';endif;
*if(ivar=6);mecols='49 48 47 46 45 44 43 42 41 0 0 21 22 23 24 25 26 27 28 29';endif;
if(ivar=6);mecols='0 0 49 48 47 46 45 44 43 42 41 21 22 23 24 25 26 27 28 29';endif;
if(ivar=7);mecols='49 48 47 46 45 44 43 42 41 0 0 21 22 23 24 25 26 27 28 29';endif;
if(ivar=8);mecols='49 48 47 46 45 44 43 42 41 0 0 21 22 23 24 25 26 27 28 29';endif;
if(ivar=9);mecols='49 48 47 46 45 44 43 42 41 0 0 21 22 23 24 25 26 27 28 29';endif;
if(ivar=10);mecols='49 48 47 46 45 44 43 42 41 0 0 21 22 23 24 25 26 27 28 29';endif;
return mecols

function getmeclev(ivar)
if(ivar=1);meclev='-8.0 -5.0 -3.0 -2.0 -1.5 -1.0 -0.75 -0.5 -0.25 0.0 0.25 0.5 0.75 1.0 1.5 2.0 3.0 5.0 8.0';endif
if(ivar=2);meclev='-5.0 -3.0 -2.0 -1.5 -1.25 -1.0 -.75 -.5 -.25 .0 .25 .5 .75 1.0 1.25 1.5 2.0 3.0 5.0';endif;
if(ivar=3);meclev='-5.0 -3.0 -2.0 -1.5 -1.25 -1.0 -.75 -.5 -.25 .0 .25 .5 .75 1.0 1.25 1.5 2.0 3.0 5.0';endif;
if(ivar=4);meclev='-2500 2000 -1500 -1000 -800 -600 -400 -200 -100 0 100 200 400 600 800 1000 1500 2000 2500';endif;
if(ivar=5);meclev='-5.0 -3.0 -2.0 -1.5 -1.25 -1.0 -.75 -.5 -.25 .0 .25 .5 .75 1.0 1.25 1.5 2.0 3.0 5.0';endif;
*if(ivar=6);meclev='10 20 30 40 50 60 70 80 90 100 110 120 130 140 150 160 170 180 190';endif;
if(ivar=6);meclev='0 2 4 6 8 10 12 15 20 25 30 35 40 50 60 80 100 150 180 ';endif;
if(ivar=7);meclev='-8.0 -5.0 -3.0 -2.0 -1.5 -1.0 -0.75 -0.5 -0.25 0.0 0.25 0.5 0.75 1.0 1.5 2.0 3.0 5.0 8.0';endif
if(ivar=8);meclev='-8.0 -5.0 -3.0 -2.0 -1.5 -1.0 -0.75 -0.5 -0.25 0.0 0.25 0.5 0.75 1.0 1.5 2.0 3.0 5.0 8.0';endif
if(ivar=9);meclev='-8.0 -5.0 -3.0 -2.0 -1.5 -1.0 -0.75 -0.5 -0.25 0.0 0.25 0.5 0.75 1.0 1.5 2.0 3.0 5.0 8.0';endif
*if(ivar=10);meclev='-80 -60 -50 -40 -30 -20 -10 -5 -2 0.0 2 5 10 20 30 40 50 60 80';endif
if(ivar=10);meclev='-60 -40 -20 -15 -10 -8 -6 -4 -2 0 2 4 6 8 10 15 20 40 60' ;endif
return meclev

function gethead(ivar)
if(ivar=1);head='2m Temperature';endif
if(ivar=2);head='10m U';endif
if(ivar=3);head='10m V';endif
if(ivar=4);head='Surface Pressure';endif
if(ivar=5);head='Wind Speed';endif
if(ivar=6);head='Wind Direction';endif
if(ivar=7);head='2m Tmax';endif
if(ivar=8);head='2m Tmin';endif
if(ivar=9);head='2m Dew Point Temp';endif
if(ivar=10);head='2m RH';endif
return head

function getunit(ivar)
if(ivar=1);unit='K';endif
if(ivar=2);unit='m/s';endif
if(ivar=3);unit='m/s';endif
if(ivar=4);unit='Pa';endif
if(ivar=5);unit='m/s';endif
if(ivar=6);unit='Degree';endif
if(ivar=7);unit='K';endif
if(ivar=8);unit='K';endif
if(ivar=9);unit='K';endif
if(ivar=10);unit='%';endif
return unit

function digs(string,num)
  nc=0
  pt=""
  while(pt = "")
    nc=nc+1
    zzz=substr(string,nc,1)
    if(zzz = "."); break; endif
  endwhile
  end=nc+num
  str=substr(string,1,end)
return str