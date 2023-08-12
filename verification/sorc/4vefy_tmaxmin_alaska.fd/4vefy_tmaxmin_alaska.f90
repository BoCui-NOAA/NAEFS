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

! exit states:
!   cond =   0 - successful run
!   cond =   1 - I/O abort
!
! attributes:
!   language: fortran 90
!
!$$$

implicit none

integer     nvar,ivar,i,k,icstart,odate,ij,ii
parameter   (nvar=1)

real,       allocatable :: agrid(:),fgrid(:),bias(:),tmax(:),tmin(:)
logical(1), allocatable :: lbms(:),lbmsout(:)
real        dmin,dmax

real        dec_w

integer     ifile,afile,cfile,ofile1,ofile2,ofile3
integer     jpds(200),jgds(200),jens(200),kpds(200),kgds(200),kens(200)
integer     kpds_tmaxmin(200),kgds_tmaxmin(200),kpds_last
integer     kpdsout(200),kgdsout(200),kensout(200)
integer     pds5,pds6,pds7

integer     maxgrd,ndata                                
integer     index,j,n,iret,jret             
character*7 cfortnn
character*7 variable 

namelist/namens/icstart,dec_w,variable

read(5,namens,end=1020)
write(6,namens)

if(variable.eq.'tmax') then
  pds5=15
  pds6=105
  pds7=2
endif

if(variable.eq.'tmin') then
  pds5=16
  pds6=105
  pds7=2
endif

ifile=11
afile=12
cfile=13
ofile1=51
ofile2=52
ofile3=53

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
!if (iret .ne. 0) then; print*,'there is no rtma data, stop!'; endif

write(cfortnn,'(a5,i2)') 'fort.',cfile
call baopenr(cfile,cfortnn,iret)
if (iret .ne. 0) then; print*,'there is no forcast data, stop!'; stop 1; endif
if (iret .ne. 0) goto 1020
!if (iret .ne. 0) then; print*,'there is no forecast data, stop!'; endif

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

write(cfortnn,'(a5,i2)') 'fort.',ofile3
call baopenw(ofile3,cfortnn,iret)
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

allocate (agrid(maxgrd),fgrid(maxgrd),bias(maxgrd),lbms(maxgrd),lbmsout(maxgrd),tmax(maxgrd),tmin(maxgrd))

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

  jpds(5)=pds5
  jpds(6)=pds6
  jpds(7)=pds7

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
!   call message(bias,maxgrd,kpds,kens,lbms,ivar,iret)
! endif

  ! get operational ensemble forecast

  index=0
  j=0
  iret=0

  print *, '----- Downscaled forecast for current Time ------'
  call getgbe(cfile,index,maxgrd,j,jpds,jgds,jens,ndata,j,kpdsout,kgdsout,kensout,lbmsout,fgrid,iret)

! if (iret .ne. 0) then; print*, 'iret ne 0, jpds5, 6, 7= ', jpds(5),jpds(6),jpds(7); endif
  if (iret .eq.99) then; print*, 'there is no variable ', jpds(5),jpds(6),jpds(7); endif
! if (iret .ne. 0) goto 200

  call message(fgrid,maxgrd,kpdsout,kensout,lbmsout,ivar,iret)

  ! get rtma data : only t2m and choose its maximum or minumum

  tmax=0
  tmin=999

  index=0
  j=0
  iret=0

  jpds=-1
  jgds=-1
  jens=-1
  jpds(5)=11  
  jpds(6)=105   
  jpds(7)=2    

  kpds_tmaxmin=-1  
  kgds_tmaxmin=-1  

  100 continue

  call getgb(afile,index,maxgrd,j,jpds,jgds,ndata,j,kpds,kgds,lbms,agrid,iret)

! if(j.eq.3) then
  if(iret.eq.0) then
    kpds_tmaxmin=kpds
    kgds_tmaxmin=kgds
  endif

! give the time of the last available t2m data

  if(iret.eq.0) then
    kpds_last=kpds(11)
  endif

  if (iret.eq.0) then

    print *, '----- RTMA Analysis for Current Time ------'
    call message(agrid,maxgrd,kpds,kens,lbms,ivar,iret)

    if(variable.eq."tmax") then
      do ii=1,maxgrd
        if(agrid(ii).gt.tmax(ii)) tmax(ii)=agrid(ii)
      enddo
      print *, '----- RTMA Tmax for Current Cycle ------'
      call message(tmax,maxgrd,kpds,kens,lbms,ivar,iret)
    endif

    if(variable.eq."tmin") then
      do ii=1,maxgrd
        if(agrid(ii).lt.tmin(ii)) tmin(ii)=agrid(ii)
      enddo
      print *, '----- RTMA Tmin for Current Cycle ------'
      call message(tmin,maxgrd,kpds,kens,lbms,ivar,iret)
    endif

  else if (iret.eq.99) then
    goto 881
  else
    goto 991
  endif

  goto 100

  881 continue


  if(variable.eq."tmax") then
    agrid=tmax
    kpds_tmaxmin(5)=15
    kpds_tmaxmin(14)=kpds_tmaxmin(11)
    kpds_tmaxmin(15)=kpds_last
  endif

  if(variable.eq."tmin") then
    agrid=tmin
    kpds_tmaxmin(5)=16
    kpds_tmaxmin(14)=kpds_tmaxmin(11)
    kpds_tmaxmin(15)=kpds_last
  endif

  if(agrid(1).ge.990.or.agrid(1).le.-990) goto 200
  if(agrid(1).eq.0) goto 200

  print *, '----- Output RTMA TMAX or Tmin for Current Time ------'
  call putgbe(ofile3,maxgrd,kpds_tmaxmin,kgds_tmaxmin,kensout,lbms,agrid,jret)
  call message(agrid,maxgrd,kpds_tmaxmin,kensout,lbms,ivar,jret)

  if(kpdsout(5).ne.1) then
    kpdsout(22)=2
  endif

  bias=0.0
  do ij=1,maxgrd
    if(lbmsout(ij)) then
      bias(ij)=fgrid(ij)-agrid(ij)
    else
      bias(ij)=-999.9
    endif
  enddo

  print *, '----- Output Bias Estimation for Current Time ------'
  call putgbe(ofile1,maxgrd,kpdsout,kgdsout,kensout,lbmsout,bias,jret)
  call message(bias,maxgrd,kpdsout,kensout,lbmsout,ivar,jret)

  bias=0.0
  do ij=1,maxgrd
    if(lbmsout(ij)) then
      bias(ij)=abs(fgrid(ij)-agrid(ij))
    else
      bias(ij)=-999.9
    endif
  enddo

  print *, '----- Output Bias Estimation for Current Time ------'
  call putgbe(ofile2,maxgrd,kpdsout,kgdsout,kensout,lbmsout,bias,jret)
  call message(bias,maxgrd,kpdsout,kensout,lbmsout,ivar,jret)

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

991 print *, ' there is a problem to open pgb file !!! '

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
dmin=1.e20
dmax=-1.e20
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


subroutine message(grid,maxgrd,kpds,kens,lbms,ivar,iret)

! print data information

implicit none

integer    kpds(200),kens(200),ivar,maxgrd,i,iret
real       grid(maxgrd),dmin,dmax
logical(1) lbms(maxgrd)

call grange(maxgrd,lbms,grid,dmin,dmax)

if (iret.ne.0) then; print*, 'iret ne 0', kpds(5),kpds(6),kpds(7); endif
!if (iret.eq.99) then; print*, 'there is no variable ', kpds(5),kpds(6),kpds(7); endif

print '(a101)', 'Irec pds5 pds6 pds7 pds8 pds9 pd10 pd11 pd14 pd15 pd16 e2  e3  ndata   Maximun    Minimum   Example'
print '(i4,10i5,2i4,i8,3f10.2)',ivar,(kpds(i),i=5,11),(kpds(i),i=14,16),(kens(i),i=2,3),maxgrd,dmax,dmin,grid(8601)
print *, '   '

return
end

