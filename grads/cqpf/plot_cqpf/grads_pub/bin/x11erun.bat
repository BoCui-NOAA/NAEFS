@echo off
:
:  Prepares enviroment and run PC/X11e programs.
:
:  Arlindo da Silva (dasilva@gsfc.nasa.gov)
: -----------------------------------------------------------

: Set this to the directory where you installed PC/X11e GrADS
: usually c:\xgrads
: -----------------------------------------------------------
  set GAROOT=c:\pcgrads

: Set your DISPLAY type; use test_vga to find out your resolution
: ---------------------------------------------------------------
  set DISPLAY=800x600x256
  rem set DISPLAY=640x400x256

:if not exist %garoot%\bin\x%1.exe goto nofile:

: Prepare environment
: -------------------
  set GADDIR=%GAROOT%\dat
  rem set HOME=%GAROOT%\lib
  set GASCRP=%GAROOT%\lib
  set GAUDFT=%GAROOT%\udf\udft
  set GRXFONT=%GAROOT%\dat\grxfonts


: Run the program
: ---------------
:  %garoot%\bin\x%1.exe %2 %3 %4 %5 %6 %7 %8 %9 
  %1 %2 %3 %4 %5 %6 %7 %8 %9 

: Reset environment
: -----------------
: set GAROOT=  
:  set GRXFONT=
:  set GO32=
:  set DISPLAY=
:  set HOME=

: Restore video mode, etc
: -----------------------
:  mode co80
  goto end:

:nofile
   echo x11erun: cannot find executable file %garoot%\bin\%1

:end
