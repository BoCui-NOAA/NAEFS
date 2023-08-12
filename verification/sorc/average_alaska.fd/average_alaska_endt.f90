program biascal_update
!
! main program: biascal_update
!
! prgmmr: Bo Cui           org: np/wx20        date: 2006-07-21
!
! abstract: update bias estimation between rtma analysis and NCEP operational analyis
!
! usage:
!
!   input file: grib
!     unit 11 -    : prior bias estimation                                               
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

!  wind direction difference average calculation
!
!     setp 1: all average are in phase (-180,180]
!     setp 2: change bias accumulation to phase [0,360)


! programs called:
!   baopenr          grib i/o
!   baopenw          grib i/o
!   baclose          grib i/o
!   getgbeh          grib reader
!   getgbe           grib reader
!   putgbe           grib writer

! exit states:
!   cond =   0 - successful run
!   cond =   1 - I/O abort
!
! attributes:
!   language: fortran 90
!
!$$$

implicit none

integer     nvar,ivar,i,k,icstart,nd
parameter   (nvar=8)

real,       allocatable :: agrid(:),fgrid(:),bias(:),tbias(:)
logical(1), allocatable :: lbms(:),lbmsout(:)
real        dmin,dmax

real        dec_w

integer     ifile,numday,infile(200),afile,ofile
integer     jpds(200),jgds(200),jens(200),kpds(200),kgds(200),kens(200)
integer     kpdsout(200),kgdsout(200),kensout(200)
integer     pds5(nvar),pds6(nvar),pds7(nvar)

! variables: pres u10m v10m t2m, tmax tmin, wind speed, wind direction
 
data pds5/1, 33, 34, 11, 15, 16, 31, 32/
data pds6/1,105,105,105,105,105,105,105/
data pds7/0, 10, 10,  2,  2,  2, 10, 10/

integer     maxgrd,ndata,ilen,lpgb,odate                                
integer     index,j,n,iret,jret             
character*7 cfortnn
character*120 cfile(200),outfile,cpgb

namelist/filec/cfile,outfile
namelist/filei/infile
namelist/namin/ilen,odate

read(5,filec,end=1020)
!write(6,filec)

read(5,filei,end=1020)
!write(6,filei)

read(5,namin,end=1020)
!write(6,namin)

ifile=11
ofile=10

! index=0, to get index buffer from the grib file not the grib index file
! j=0, to search from beginning,  <0 to read index buffer and skip -1-j messages
! lbms, logical*1 (maxgrd or kf) unpacked bitmap if present

index=0
j=0
jpds=-1  
jgds=-1
jens=-1
iret=0

lpgb=len_trim(outfile)
call baopen(ofile,outfile(1:lpgb),iret)

if(infile(1).eq.1) then
  cpgb=cfile(1)
  lpgb=len_trim(cpgb)
  call baopenr(ifile,cpgb(1:lpgb),iret)
  if (iret .ne. 0) then; print*,'there is no rtma data, stop!'; stop 1; endif
endif

call getgbeh(ifile,index,j,jpds,jgds,jens,ndata,maxgrd,j,kpds,kgds,kens,iret)
if (iret .ne. 0) then; print*,' getgbeh ,ifile,index,iret =',ifile,index,iret; stop 1; endif

allocate (bias(maxgrd),tbias(maxgrd),lbms(maxgrd),lbmsout(maxgrd))

kpdsout=-1
kgdsout=-1
kensout=-1

do 100 ivar = 1, nvar  

  tbias=0.0
  numday=0

  ifile=11

  print *, '----- Bias for Current Variable -----'

  do 200 nd = 1, ilen         ! sample size: how many day of stats

    ifile=11+nd-1
    index=0
    j=0
    iret=0
    jpds=-1
    jgds=-1
    jens=-1
    kpds=-1
    kgds=-1
    kens=-1

    bias=-9999.9999

  ! read and process variable of input data

    jpds(5)=pds5(ivar)
    jpds(6)=pds6(ivar)
    jpds(7)=pds7(ivar)

  ! get initialized bias estimation

    if(infile(nd).eq.1) then

      cpgb=cfile(nd)
      lpgb=len_trim(cpgb)
      call baopenr(ifile,cpgb(1:lpgb),iret)

      call getgbe(ifile,index,maxgrd,j,jpds,jgds,jens,ndata,j,kpds,kgds,kens,lbms,bias,iret)
      if (iret .ne. 0) then; print*, 'iret ne 0', jpds(5),jpds(6),jpds(7); endif
      if (iret .eq.99) then; print*, 'there is no variable ', jpds(5),jpds(6),jpds(7); endif

      if (iret.eq.0) then
        do i=1,maxgrd
          if(bias(i).ne.-9999.9999) then
            tbias(i)=tbias(i)+bias(i)
          endif
        enddo
        numday=numday+1
      endif

!     print *,' day =', nd, ' numday=',numday,cpgb(1:lpgb)
!     print *,' day =', nd, ' numday=',numday

!     if(nd.eq.ilen.and.iret.eq.0) then
!       kpdsout(1:200)=kpds(1:200)
!       kgdsout(1:200)=kgds(1:200)
!       kensout(1:200)=kens(1:200)
!       lbmsout(1:maxgrd)=lbms(1:maxgrd)
!     endif

      if (iret.eq.0) then
!       kpdsout(5)=pds5(ivar)
!       kpdsout(6)=pds6(ivar)
!       kpdsout(7)=pds7(ivar)
        kpdsout=kpds
        kgdsout=kgds
        kensout=kens
        lbmsout=lbms
        call moreinfro(bias,maxgrd,kpdsout,kensout,lbms,ivar)
      endif

    endif

  200 continue

  if(numday.eq.0) goto 100

  if(numday.ge.1) then
    tbias(1:maxgrd)=tbias(1:maxgrd)/numday
  endif
  
  print *, '----- Output Bias Estimation for Current Time ------'

  call moreinfro(tbias,maxgrd,kpdsout,kensout,lbms,ivar)

  call gribinf(kpdsout,odate)

  call putgbe(ofile,maxgrd,kpdsout,kgdsout,kensout,lbmsout,tbias,jret)

100 continue

call baclose(ifile,iret)
call baclose(ofile,iret)

print *,'Bias Estimation Successfully Complete'

stop

1020  continue

stop
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
dmin=9999.9 
dmax=-999.9
do i=1,n
  if(ld(i)) then
    dmin=min(dmin,d(i))
    dmax=max(dmax,d(i))
  endif
enddo
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

print*, 'Irec pds5 pds6 pds7 pds8 pds9 pd10 pd11 pd14 pd15 pd16 e2  e3  ndata   Maximun    Minimum   Example'
print '(i4,10i5,2i4,i8,3f10.2)',ivar,(kpds(i),i=5,11),(kpds(i),i=14,16),(kens(i),i=2,3),maxgrd,dmax,dmin,grid(8601)
print *, '   '

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

