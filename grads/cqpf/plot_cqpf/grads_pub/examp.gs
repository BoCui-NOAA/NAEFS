*  Script to draw an XY plot.  
*
function main(args)

#'set display color white'
#'clear'

if (args='') 
  say 'Enter Record Number'
  pull lrec 
else
  lrec = args
endif

fname = "tmp.dat"                     

*  Read record: 

irec=1
while (irec<=lrec)
ret = read(fname)
rc = sublin(ret,1)
if (rc>0) 
  say 'File Error'
  return
endif
rec = sublin(ret,2)
p1 = subwrd(rec,1)
p2 = subwrd(rec,2)
p3 = subwrd(rec,3)
p4 = subwrd(rec,4)
p5 = subwrd(rec,5)
p6 = subwrd(rec,6)
p7 = subwrd(rec,7)
p8 = subwrd(rec,8)
p9 = subwrd(rec,9)

irec = irec + 1
endwhile

'set string 4 l'
'set strsiz 0.08'
'draw string 2.45 0.90 'p1  
'draw string 3.05 0.90 'p2  
'draw string 3.65 0.90 'p3 
'draw string 4.25 0.90 'p4 
'draw string 4.85 0.90 'p5 
'draw string 5.45 0.90 'p6 
'draw string 6.05 0.90 'p7 
'draw string 6.65 0.90 'p8 
'draw string 7.25 0.90 'p9  

function digs(string,num)
  nc=0
  pt=""
  while(pt = "")
    nc=nc+1
    zzz=substr(string,nc,1)
    if(zzz = "."); break; endif
  endwhile
  end=nc+num-1
  str=substr(string,1,end)
return str

