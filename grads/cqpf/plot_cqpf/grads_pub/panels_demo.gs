* panels_demo.gs 
* 
* This script demonstrates the use of panels.gsf, a dynamically 
* loaded script function that sets up the virtual page commands 
* for a multi-panel plot. 
* 
* Written by JMA March 2001
*
function main(args)
*  *rc = gsfallow("on")
  if (args='') 
    say 'Two arguments are required: the # of rows and # of columns'
    return 
  else 
    nrows = subwrd(args,1)
    ncols = subwrd(args,2)
  endif

** 'use model.ctl'
  'open pgbt62.ctl'
  'reset'
  panels(args)
  p = 1
  ptot = nrows * ncols
  'set mproj scaled'

* Loop through each panel and draw a plot
  while (p <= ptot)
    _vpg.p
   if (p = 2 )
    'set lat -60 60'
   endif
*   'set t 'p
    'set t 1'  
    'set grads off'
    'd t'
    p = p + 1
  endwhile

* panels.gsf
* 
* This function evenly divides the real page into a given number of rows
* and columns then creates global variables that contain the 'set vpage' 
* commands for each panel in the multi-panel plot. 
*
* Usage: panels(rows cols)
*
* Written by JMA March 2001
*
function panels(args)

* Get arguments
  if (args='') 
    say 'panels requires two arguments: the # of rows and # of columns'
    return 
  else 
    nrows = subwrd(args,1)
    ncols = subwrd(args,2)
  endif

* Get dimensions of the real page
  'query gxinfo'
  rec2  = sublin(result,2)
  xsize = subwrd(rec2,4)
  ysize = subwrd(rec2,6)

* Calculate coordinates of each vpage
  width  = xsize/ncols
  height = ysize/nrows
  row = 1
  col = 1
  panel = 1
  while (row <= nrows)
    yhi = ysize - (height * (row - 1))
    if (row = nrows)
      ylo = 0
    else
      ylo = yhi - height
    endif
    while (col <= ncols)  
      xlo = width * (col - 1)
      xhi = xlo + width
      _vpg.panel = 'set vpage 'xlo'  'xhi'  'ylo'  'yhi
      panel = panel + 1
      col = col + 1
    endwhile
    col = 1
    row = row + 1
  endwhile
  return

* THE END *




