program biascal_update
!
! main program: biascal_update
!
! prgmmr: Bo Cui           org: np/wx20        date: 2006-07-21
!
! abstract: update bias estimation between rtma analysis and NCEP forecast                         
!
! usage:
!
!   input file: grib
!     unit 11 -    : prior bias estimation                                               
!     unit 12 -    : rtma analysis
!     unit 13 -    : ncep operational analysis
!
!   output file: grib
!     unit 51 -    : updated bias estimation pgrba file
!
!   parameters
!     fgrid -      : ensemble forecast
!     agrid -      : rtma 5km analysis data
!     bias  -      : bias estimation
!     dec_w -      : decay averaging weight 
!     nvar  -      : number of variables

! programs called:
!   baopenr          grib i/o
!   baopenw          grib i/o
!   baclose          grib i/o
!   getgbeh          grib reader
!   getgbe           grib reader
!   putgbe           grib writer
!
!   wind direction difference and mean error calculation
!
!     setp 1: read in forecast direction in phase [0,360)
!     setp 2: read in rtma wind speed and direction in phase [0,360)
!     setp 3: adjust forecast & rtma wind direction to (-180,180], then calculate their difference
!     setp 4: calculate wind error in phase (-180,180] 
!     setp 5: adjust error to phase (-180,180] in case any value is out of range

!   wind direction difference and mean absolute error calculation
!
!     setp 1: read in forecast direction in phase [0,360)
!     setp 2: read in rtma wind speed and direction in phase [0,360)
!     setp 3: adjust forecast & rtma wind direction to (-180,180], then calculate their difference
!     setp 4: calculate wind error in phase (-180,180] 
!     setp 5: adjust error in phase (-180,180] in case any value is out of range
!     setp 6: choose its absolute value

! exit states:
!   cond =   0 - successful run
!   cond =   1 - I/O abort
!
! attributes:
!   language: fortran 90
!
!$$$

implicit none

integer     nvar,ivar,i,k,icstart,odate,ij
parameter   (nvar=8)

real,       allocatable :: agrid(:),fgrid(:),bias(:)
logical(1), allocatable :: lbms(:),lbmsout(:)
real        dmin,dmax

real        dec_w

integer     ifile,afile,cfile,ofile1,ofile2
integer     jpds(200),jgds(200),jens(200),kpds(200),kgds(200),kens(200)
integer     kpdsout(200),kgdsout(200),kensout(200)
integer     pds5(nvar),pds6(nvar),pds7(nvar)

! variables: pres u10m v10m t2m
 
data pds5/1, 33, 34, 11, 31, 32, 17, 52/
data pds6/1,105,105,105,105,105,105,105/
data pds7/0, 10, 10,  2, 10, 10,  2,  2/

integer     maxgrd,ndata                                
integer     index,j,n,iret,jret             
character*7 cfortnn

namelist/message/icstart,dec_w,odate

read(5,message,end=1020)
write(6,message)

ifile=11
afile=12
cfile=13
ofile1=51
ofile2=52

! index=0, to get index buffer from the grib file not the grib index file
! j=0, to search from beginning,  <0 to read index buffer and skip -1-j messages
! lbms, logical*1 (maxgrd or kf) unpacked bitmap if present

index=0
j=0
jpds=-1  
jgds=-1
jens=-1
iret=0

! set the fort.* of intput files

write(cfortnn,'(a5,i2)') 'fort.',afile
call baopenr(afile,cfortnn,iret)
if (iret .ne. 0) then; print*,'there is no rtma data, stop!'; stop 1; endif

write(cfortnn,'(a5,i2)') 'fort.',cfile
call baopenr(cfile,cfortnn,iret)
!if (iret .ne. 0) then; print*,'there is no NCEP analysis data, stop!'; stop 1; endif
if (iret .ne. 0) then; print*,'there is no NCEP analysis data, stop!'; endif

!if(icstart.eq.0) then
!  write(cfortnn,'(a5,i2)') 'fort.',ifile
!  call baopenr(ifile,cfortnn,iret)
!  if (iret .ne. 0) then; print*,'there is no bias estimation data, please check!'; endif
!endif

! set the fort.* of output file

write(cfortnn,'(a5,i2)') 'fort.',ofile1
call baopenw(ofile1,cfortnn,iret)
if (iret .ne. 0) then; print*,'there is no output bias data, stop!'; stop 1; endif

write(cfortnn,'(a5,i2)') 'fort.',ofile2
call baopenw(ofile2,cfortnn,iret)
if (iret .ne. 0) then; print*,'there is no output bias data, stop!'; stop 1; endif

! find grib message. input: jpds,jgds and jens.  output: kpds,kgds,kens
! ndata: integer number of bites in the grib message

call getgbeh(afile,index,j,jpds,jgds,jens,ndata,maxgrd,j,kpds,kgds,kens,iret)
!if (iret .ne. 0) then; print*,' getgbeh ,afile,index,iret =',afile,index,iret; stop 1; endif
if (iret .ne. 0) then
  call getgbeh(ifile,index,j,jpds,jgds,jens,ndata,maxgrd,j,kpds,kgds,kens,iret)
    if (iret .ne. 0) then
     call getgbeh(cfile,index,j,jpds,jgds,jens,ndata,maxgrd,j,kpds,kgds,kens,iret)
    endif
endif

allocate (agrid(maxgrd),fgrid(maxgrd),bias(maxgrd),lbms(maxgrd),lbmsout(maxgrd))

do ivar = 1, nvar  

  index=0
  j=0
  iret=0
  jpds=-1
  jgds=-1
  jens=-1
  kpds=-1
  kgds=-1
  kens=-1
  kpdsout=-1
  kgdsout=-1
  kensout=-1

  bias=-9999.9999
  agrid=-9999.9999
  fgrid=-9999.9999

  ! read and process variable of input data

  jpds(5)=pds5(ivar)
  jpds(6)=pds6(ivar)
  jpds(7)=pds7(ivar)

  ! get initialized bias estimation

! if(icstart.eq.1) then
!   print *, '----- Cold Start for Bias Estimation -----'
!   print*, '  '
!   bias=0.0
! else
!   print *, '----- Initialized Bias for Current Time -----'
!   call getgbe(ifile,index,maxgrd,j,jpds,jgds,jens,ndata,j,kpds,kgds,kens,lbms,bias,iret)
!   if (iret .ne. 0) then; print*, 'iret ne 0', jpds(5),jpds(6),jpds(7); endif
!   if (iret .eq.99) then; print*, 'there is no variable ', jpds(5),jpds(6),jpds(7); endif
!   if (iret .ne. 0) bias=0.0 

!   call grange(maxgrd,lbms,bias,dmin,dmax)
!   print*, 'Irec pds5 pds6 pds7 pds8 pds9 pd10 pd11 pd14 e2  e3  ndata   Maximun    Minimum    data'
!   print '(i4,8i5,2i4,i8,3f10.2)',ivar,(kpds(i),i=5,11),kpds(14),(kens(i),i=2,3),maxgrd,dmax,dmin,bias(30000)
!   print*, '  '
! endif

  ! get operational ensemble forecast

  index=0
  j=0
  iret=0

  print *, '----- NCEP ensemble forecast for current Time ------'
  call getgbe(cfile,index,maxgrd,j,jpds,jgds,jens,ndata,j,kpdsout,kgdsout,kensout,lbmsout,fgrid,iret)

  if (iret .ne. 0) then; print*, 'iret ne 0, jpds5, 6, 7= ', jpds(5),jpds(6),jpds(7); endif
  if (iret .eq.99) then; print*, 'there is no variable ', jpds(5),jpds(6),jpds(7); endif
  if (iret .ne. 0) then
    kpdsout=kpds
    kgdsout=kgds
    kensout=kens
    lbmsout=lbms
  endif
  if (iret .ne. 0) goto 200

  call moreinfro(fgrid,maxgrd,kpdsout,kensout,lbmsout,ivar)

  ! adjust forecast & rtma wind direction from phase [0,360) to (-180,180]

  if(kpdsout(5).eq.31) then
    call phasechange(fgrid,maxgrd,1)
    print *, '----- GDAS Wind Direction in phase (-180,180] ------'
    call moreinfro(fgrid,maxgrd,kpdsout,kensout,lbms,ivar)
  endif

  ! get rtma data

  index=0
  j=0
  iret=0

  print *, '----- RTMA Analysis for Current Time ------'

  call getgbe(afile,index,maxgrd,j,jpds,jgds,jens,ndata,j,kpds,kgds,kens,lbms,agrid,iret)

  if (iret .ne. 0) then; print*, 'iret ne 0, jpds5, 6, 7= ', jpds(5),jpds(6),jpds(7); endif
  if (iret .eq.99) then; print*, 'there is no variable ', jpds(5),jpds(6),jpds(7); endif
  if (iret .ne. 0) goto 200

  call moreinfro(agrid,maxgrd,kpds,kens,lbms,ivar)

  ! adjust rtma wind direction from phase [0,360) to (-180,180]

  if(kpds(5).eq.31) then
    print *, '----- RTMA Wind Direction in phase (-180,180] ------'
    call phasechange(agrid,maxgrd,1)
    call moreinfro(agrid,maxgrd,kpdsout,kensout,lbms,ivar)
  endif

  if(kpdsout(5).ne.1) then
    kpdsout(22)=2
  endif

  bias=0.0
  do ij=1,maxgrd
    bias(ij)=fgrid(ij)-agrid(ij)
  enddo

  print *, '----- Output Bias Estimation for Current Time ------'
  call moreinfro(bias,maxgrd,kpdsout,kensout,lbmsout,ivar)

  if(kpdsout(5).eq.31) then
    call phasechange(bias,maxgrd,4)
    print *, '----- Wind Direction ME after Adjustment in (-180,180] ------'
    call moreinfro(bias,maxgrd,kpdsout,kensout,lbms,ivar)
  endif

  call putgbe(ofile1,maxgrd,kpdsout,kgdsout,kensout,lbmsout,bias,jret)

  bias=0.0

  if(kpdsout(5).eq.31) then
    do ij=1,maxgrd
      bias(ij)=fgrid(ij)-agrid(ij)
    enddo
    call phasechange(bias,maxgrd,4)
    print *, '----- Wind Direction MAE after Adjustment in (-180,180] ------'
    call moreinfro(bias,maxgrd,kpdsout,kensout,lbms,ivar)
    do ij=1,maxgrd
      bias(ij)=abs(bias(ij))
    enddo
  else
    do ij=1,maxgrd
      bias(ij)=abs(fgrid(ij)-agrid(ij))
    enddo
  endif

  print *, '----- Output Bias Estimation for Current Time ------'
  call moreinfro(bias,maxgrd,kpdsout,kensout,lbmsout,ivar)
  call putgbe(ofile2,maxgrd,kpdsout,kgdsout,kensout,lbmsout,bias,jret)

  200 continue

! end of bias estimation for one forecast lead time

enddo

call baclose(ifile,iret)
call baclose(afile,iret)
call baclose(cfile,iret)
call baclose(ofile1,iret)
call baclose(ofile2,iret)

print *,'Bias Estimation Successfully Complete'

stop

1020  continue

stop
end

subroutine decay(aveeror,fgrid,agrid,maxgrd,dec_w)

!     apply the decaying average scheme
!
!     parameters
!                  fgrid  ---> ensemble forecast
!                  agrid  ---> analysis data
!                  aveeror---> bias estimation
!                  dec_w  ---> decay weight

implicit none

integer maxgrd,ij
real aveeror(maxgrd),fgrid(maxgrd),agrid(maxgrd)
real dec_w           

do ij=1,maxgrd
  if(fgrid(ij).gt.-9999.0.and.fgrid(ij).lt.999999.0.and.agrid(ij).gt.-9999.0.and.agrid(ij).lt.999999.0) then
      if(aveeror(ij).gt.-9999.0.and.aveeror(ij).lt.999999.0) then
        aveeror(ij)= (1-dec_w)*aveeror(ij)+dec_w*(fgrid(ij)-agrid(ij))
      else
        aveeror(ij)= fgrid(ij)-agrid(ij)
      endif
  else
    if(aveeror(ij).gt.-9999.0 .and.aveeror(ij).lt.999999.0) then
      aveeror(ij)= aveeror(ij)                   
    else
      aveeror(ij)= -9999.999                          
    endif
  endif
enddo

return
end

subroutine grange(n,ld,d,dmin,dmax)
!$$$  SUBPROGRAM DOCUMENTATION BLOCK
!
! SUBPROGRAM: GRANGE(N,LD,D,DMIN,DMAX)
!   PRGMMR: YUEJIAN ZHU       ORG:NP23          DATE: 97-03-17
!
! ABSTRACT: THIS SUBROUTINE WILL ALCULATE THE MAXIMUM AND
!           MINIMUM OF A ARRAY
!
! PROGRAM HISTORY LOG:
!   97-03-17   YUEJIAN ZHU (WD20YZ)
!
! USAGE:
!
!   INPUT ARGUMENTS:
!     N        -- INTEGER
!     LD(N)    -- LOGICAL OF DIMENSION N
!     D(N)     -- REAL ARRAY OF DIMENSION N
!
!   OUTPUT ARGUMENTS:
!     DMIN     -- REAL NUMBER ( MINIMUM )
!     DMAX     -- REAL NUMBER ( MAXIMUM )
!
! ATTRIBUTES:
!   LANGUAGE: FORTRAN
!
!$$$
logical(1) ld(n)
real d(n)
real dmin,dmax
integer i,n
dmin=1.e30
dmax=-1.340
do i=1,n
  if(ld(i)) then
    dmin=min(dmin,d(i))
    dmax=max(dmax,d(i))
  endif
enddo
return
end

subroutine gribinf(lpds,idate)

! set the date information in lpds
! parameters
!     idate  ---> date of output bias
!     lpds   ---> output grib information

implicit none
integer lpds(200),idate,iy,im,id,ih

iy = mod(idate/1000000,100)
im = mod(idate/10000,  100)
id = mod(idate/100,    100)
ih = mod(idate,        100)
iy = iy - iy/100 *100
 
lpds(8) = iy
lpds(9) = im
lpds(10)= id
lpds(11)= ih
       
return
end

subroutine phasechange(angle,maxgrd,chndex)

! change wind direction phase from [0,360) to [-180,180]
!
!     parameters
!
!        input
!                  angle   ---> wind direction
!                  chndex  ---> index number
!
!        output
!                  angle   ---> adjusted wind direction
!
!    chndex = 1 : change wind direction phase from [0,360) to (-180,180]
!           = 2 : change wind direction phase from (-180,180], [0,360)
!           = 3 : adjust wind direction to locate in phase [0,360) if it is negative or biger than 360
!           = 4 : adjust wind direction in phase (-180,180] if it is less than -180 or biger than 180

!
implicit none

integer chndex,ij,maxgrd
real    angle(maxgrd)

!print *,chndex

if(chndex.eq.1) then
  do ij=1,maxgrd
    if(angle(ij).gt.180.) angle(ij)=angle(ij)-360.
  enddo
endif

if(chndex.eq.2) then
  do ij=1,maxgrd
    if(angle(ij).lt.0.) angle(ij)=360.0+angle(ij)
  enddo
endif

if(chndex.eq.3) then

  do ij=1,maxgrd
    if(angle(ij).lt.0.) angle(ij)=360.0+angle(ij)
    if(angle(ij).ge.360.) angle(ij)=angle(ij)-360.0
  enddo

  ! to avoid extram case

  do ij=1,maxgrd
    if(angle(ij).lt.0.) angle(ij)=360.0+angle(ij)
    if(angle(ij).ge.360.) angle(ij)=angle(ij)-360.0
  enddo

endif

if(chndex.eq.4) then
  do ij=1,maxgrd
    if(angle(ij).gt.180.) angle(ij)=angle(ij)-360.0
    if(angle(ij).lt.-180.) angle(ij)=angle(ij)+360.0
  enddo
  ! to avoid extram case
  do ij=1,maxgrd
    if(angle(ij).gt.180.) angle(ij)=angle(ij)-360.0
    if(angle(ij).lt.-180.) angle(ij)=angle(ij)+360.0
  enddo
endif

return
end


subroutine moreinfro(grid,maxgrd,kpds,kens,lbms,ivar)

! print data information

implicit none

integer    kpds(200),kens(200),ivar,maxgrd,i
real       grid(maxgrd),dmin,dmax
logical(1) lbms(maxgrd)

call grange(maxgrd,lbms,grid,dmin,dmax)

print '(a101)', 'Irec pds5 pds6 pds7 pds8 pds9 pd10 pd11 pd14 pd15 pd16 e2  e3  ndata   Maximun    Minimum   Example'
print '(i4,10i5,2i4,i8,3f11.1)',ivar,(kpds(i),i=5,11),(kpds(i),i=14,16),(kens(i),i=2,3),maxgrd,dmax,dmin,grid(8601)
print *, '   '

return
end

