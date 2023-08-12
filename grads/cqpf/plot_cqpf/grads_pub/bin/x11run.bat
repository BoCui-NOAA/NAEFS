@echo off
:
:  Prepares enviroment and run Win32 GrADS programs.
:
:  Arlindo da Silva (dasilva@gsfc.nasa.gov)
: -----------------------------------------------------------

: Set this to the directory where you installed PC/X11e GrADS
: usually c:\xgrads
: -----------------------------------------------------------
  set GAROOT=c:\win32grads

:if not exist %garoot%\win32\%1.exe goto nofile:

: Prepare environment
: -------------------
  set GADDIR=%GAROOT%\dat
  set GASCRP=%GAROOT%\lib
:  set GAUDFT=%GAROOT%\udf\udft
  set DISPLAY=localhost:0.0

: Run the program
: ---------------
  %1 %2 %3 %4 %5 %6 %7 %8 %9 

: Reset environment
: -----------------
:  set GAROOT=
:  set GADDIR=
:  set GASCRP=

  goto end:

:nofile
   echo x11run: cannot find executable file %garoot%\win32\%1

:end

