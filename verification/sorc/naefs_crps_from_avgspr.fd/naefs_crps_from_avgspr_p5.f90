program naefs_crps_from_avgspr
!
! main program: rtma_crps_from_avgspr
!
! abstract: This is ensemble verification program for NAEFS  products on 1 degree
! 
! For:   1. CRPSf
!        2. CRPSc
!        3. RMSE(w.r.t. average) 
!        4. RMSE(w.r.t. 50%)
!        5. Spread
!        6. ME - Bias
!        7. MABSE
!        8. 10% counts
!        9. 90% counts
!
! usage:
!
!   input file: grib
!     unit 11 -    : ensemble mean 
!     unit 12 -    : ensemble spread
!     unit 13 -    : rtma analysis             
!
!   output file: grib
!     unit 51 -    : updated bias estimation pgrba file
!
!   parameters
!     fgrid -      : ensemble forecast
!     agrid -      : rtma 5km analysis data
!     cgrid -      : climate mean            
!     bias  -      : bias estimation

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

integer     ij,i,ii,k,odate,idate,im,imem,n,irt,nfhrs,itemp,numsc
parameter   (im=20,numsc=9)

! trmsa: RMS w.r.t average
! trmsm: RMS w.r.t 50% prob fcst

real,       allocatable :: agrid(:),cgrid(:),fgrid(:,:),fst(:),sgrid(:)
real,       allocatable :: rpsff(:),rpsfc(:),ens_avg(:),ens_spr(:),ens_p10(:),ens_p90(:),ens_p50(:)
logical(1), allocatable :: lbms(:)

real,       allocatable :: p_agrid(:),p_cgrid(:),p_fgrid(:,:)
real,       allocatable :: p_ens_avg(:),p_ens_spr(:),p_ens_p10(:),p_ens_p90(:),p_ens_p50(:)

real        ens_pcent

real        dmin,dmax,ensfst(im),temp
real        tsprd,trmsa,trmsm,tmerr,tabse
integer     idx,jdate,kdate,jpds9,jpds10,jpds11,kpds9,kpds10,kpds11,ipdym1

!real        wfac,obs,acwt,it,ir,ave,xmed,sprd,rmsa,fsprd,frmsa,fmerr,fabse
!real        crpsff,crpsf,crpsc,fctp10,fctp90

real        probsc(numsc)
integer     infow(20),jret,iret

integer     afile1,afile2,cfile1,cfile2,ofile
integer     jpds(200),jgds(200),jens(200),kpds(200),kgds(200),kens(200)
integer     pds5,pds6,pds7

real,       allocatable :: wght(:)
integer     la1,la2,lo1,lo2,ictl,ix,iy,lengrd,num

integer       maxgrd,ndata                                
integer       index,j
character*10  cfortnn,variable

namelist/message/nfhrs,odate,idate,variable
namelist/varlist/pds5,pds6,pds7
namelist/domlist/ictl,la1,la2,lo1,lo2

read(5,message,end=1020)
read(5,varlist,end=1020)
write(6,message)
write(6,varlist)

afile1=11
afile2=12
cfile1=13
cfile2=14

ofile=51

infow(2) = idate
infow(3) = nfhrs
infow(4) = pds5
infow(5) = pds6
infow(6) = pds7

idx=1
probsc=-999.99

! index=0, to get index buffer from the grib file not the grib index file
! j=0, to search from beginning,  <0 to read index buffer and skip -1-j messages
! lbms, logical*1 (maxgrd or kf) unpacked bitmap if present

index=0; j=0;     jpds=-1  
jgds=-1; jens=-1; iret=0

! set the fort.* of intput files

write(cfortnn,'(a5,i2)') 'fort.',afile1
call baopenr(afile1,cfortnn,iret)
if (iret .ne. 0) then; print*,'there is no analysis data, stop!'; endif
if (iret .ne. 0) goto 1040

write(cfortnn,'(a5,i2)') 'fort.',afile2
call baopenr(afile2,cfortnn,iret)
if (iret .ne. 0) then; print*,'there is no climate mean data, stop!'; endif
!if (iret .ne. 0) goto 1040

write(cfortnn,'(a5,i2)') 'fort.',cfile1
call baopenr(cfile1,cfortnn,iret)
if (iret .ne. 0) then; print*,'there is no gefs fcst mean , stop!'; endif
if (iret .ne. 0) goto 1040

write(cfortnn,'(a5,i2)') 'fort.',cfile2
call baopenr(cfile2,cfortnn,iret)
if (iret .ne. 0) then; print*,'there is no gefs fcst spread , stop!'; endif
if (iret .ne. 0) goto 1040

! set the fort.* of output file

write(cfortnn,'(a5,i2)') 'fort.',ofile
call baopenw(ofile,cfortnn,iret)
if (iret .ne. 0) then; print*,'there is no output CRPS data, stop!'; endif
!if (iret .ne. 0) goto 400

call getgbeh(afile1,index,j,jpds,jgds,jens,ndata,maxgrd,j,kpds,kgds,kens,iret)
if (iret .ne. 0) then
  call getgbeh(afile1,index,j,jpds,jgds,jens,ndata,maxgrd,j,kpds,kgds,kens,iret)
  if (iret .ne. 0) then
    call getgbeh(cfile1,index,j,jpds,jgds,jens,ndata,maxgrd,j,kpds,kgds,kens,iret)
  endif
endif

! get No. of points along x - grid direction, 360
! get No. of points along y - grid direction, 181

ix=kgds(2)
iy=kgds(3)

!print *, 'ix=,iy=,',ix,iy

allocate(agrid(maxgrd),fgrid(maxgrd,im),fst(im),rpsff(maxgrd),rpsfc(maxgrd),lbms(maxgrd),cgrid(maxgrd))
allocate(ens_avg(maxgrd),ens_spr(maxgrd),ens_p10(maxgrd),ens_p90(maxgrd),ens_p50(maxgrd))
allocate(wght(maxgrd),sgrid(maxgrd))

agrid=-999.99
fgrid=-999.99
cgrid=-999.99

ens_avg=-999.99
ens_spr=-999.99
ens_p10=-999.99
ens_p90=-999.99
ens_p50=-999.99

! read and process variable of input data

jpds=-1; jgds=-1; jens=-1

jpds(5)=pds5    
jpds(6)=pds6
jpds(7)=pds7
   
! get ensemble mean, spread, 10%, 50% and 90% prob fcst 

index=0; j=0;     iret=0
kpds=-1; kgds=-1; kens=-1

print *, '----- NCEP Ensemble Mean for Current Time ------'
call getgbe(cfile1,index,maxgrd,j,jpds,jgds,jens,ndata,j,kpds,kgds,kens,lbms,ens_avg,iret)

if(iret.ne.0) goto 1040
call printinf(ens_avg,maxgrd,kpds,kens,lbms,0)

call cvncep(ens_avg,maxgrd,kpds,kgds,kens,lbms,0)

index=0; j=0;     iret=0
kpds=-1; kgds=-1; kens=-1

print *, '----- NCEP Ensemble Spread for Current Time ------'
call getgbe(cfile2,index,maxgrd,j,jpds,jgds,jens,ndata,j,kpds,kgds,kens,lbms,ens_spr,iret)

if(iret.ne.0) goto 1040
call printinf(ens_spr,maxgrd,kpds,kens,lbms,0)

call cvncep(ens_spr,maxgrd,kpds,kgds,kens,lbms,0)

do ij=1,maxgrd
  call getfcstp(ens_pcent,0.1,ens_avg(ij),ens_spr(ij))
  ens_p10(ij)=ens_pcent
enddo

print *, '----- NCEP Ensemble 10% Prob for Current Time ------'
call printinf(ens_p10,maxgrd,kpds,kens,lbms,0)

do ij=1,maxgrd
  call getfcstp(ens_pcent,0.9,ens_avg(ij),ens_spr(ij))
  ens_p90(ij)=ens_pcent
enddo

print *, '----- NCEP Ensemble 90% Prob for Current Time ------'
call printinf(ens_p90,maxgrd,kpds,kens,lbms,0)

do ij=1,maxgrd
  call getfcstp(ens_pcent,0.5,ens_avg(ij),ens_spr(ij))
  ens_p50(ij)=ens_pcent
enddo

print *, '----- NCEP Ensemble 50% Prob for Current Time ------'
call printinf(ens_p50,maxgrd,kpds,kens,lbms,0)

! get NCEP member fcst from ensemble mean snd spread

print *, '----- Get NCEP Member Forecast from Ens. Mean & Spread ------'

do ij=1,maxgrd
  call getensfcst(ensfst,im,ens_avg(ij),ens_spr(ij))
  fgrid(ij,1:im)=ensfst(1:im)
enddo

if(jpds(5).eq.31.and.jpds(6).eq.105.and.jpds(7).eq.10) then

  print *, '----- check if wind direction is out of range ------'

  do ii=1,im

    print *, '----- Wind Direction before Adjustment ------'
    call printinf(fgrid(1,ii),maxgrd,kpds,kens,lbms,0)

    print *, '----- Wind Direction after Adjustment in [0,360) ------'
    call phasechange(fgrid(1,ii),maxgrd,3)
    call printinf(fgrid(1,ii),maxgrd,kpds,kens,lbms,0)

  enddo

endif

write(6,'(10f10.1)') (fgrid(8601,ij),ij=1,20)
print *, '  '

! get gdas analysis

index=0; j=0;     iret=0
kpds=-1; kgds=-1; kens=-1
jpds=-1; jgds=-1; jens=-1

jpds(5)=pds5; jpds(6)=pds6; jpds(7)=pds7

print *, '----- GDAS Analysis for Current Time ------'
call getgbe(afile1,index,maxgrd,j,jpds,jgds,jens,ndata,j,kpds,kgds,kens,lbms,agrid,iret)

if(iret.ne.0) goto 1040 
call printinf(agrid,maxgrd,kpds,kens,lbms,0)

! get climate mean

jpds=-1; jgds=-1; jens=-1

jdate=kpds(8)*1000000 + kpds(9)*10000 + kpds(10)*100 + kpds(11)
jdate=jdate + 2000000000

! print *,' jdate = ',jdate
! print *,' kpds(14) = ', kpds(14), 'kpds(15) = ', kpds(15), 'kpds(16) = ', kpds(16)
! print *,' kpds(9) = ', kpds(9), 'kpds(10) = ', kpds(10), 'kpds(11) = ', kpds(11)

jpds9  = mod(jdate/10000,  100)
jpds10 = mod(jdate/100,    100)
jpds11 = mod(jdate,        100)

call iaddate(jdate,-6,kdate)

! print *,' kdate = ',kdate

kpds9  = mod(kdate/10000,  100)
kpds10 = mod(kdate/100,    100)
kpds11 = mod(kdate,        100)

ipdym1=0

if(pds5.eq.11.and.pds6.eq.105.and.pds7.eq.2) ipdym1=1
if(pds5.eq.15.and.pds6.eq.105.and.pds7.eq.2) ipdym1=1
if(pds5.eq.16.and.pds6.eq.105.and.pds7.eq.2) ipdym1=1
if(pds5.eq.33.and.pds6.eq.105.and.pds7.eq.10) ipdym1=1
if(pds5.eq.34.and.pds6.eq.105.and.pds7.eq.10) ipdym1=1

!if (ipdym1.eq.1) then
!  jpds(9) = kpds9
!  jpds(10)= kpds10
!  jpds(11)= kpds11
!else
  jpds(9) = jpds9
  jpds(10)= jpds10
  jpds(11)= jpds11
!endif

jpds(5)=pds5;    jpds(6)=pds6;      jpds(7)=pds7

print *,' jpds(9) = ', jpds(9), 'jpds(10) = ', jpds(10), 'jpds(11) = ', jpds(11)

index=0; j=0;     iret=0
kpds=-1; kgds=-1; kens=-1

print *, '----- Climate Mean for Current Time ------'
call getgbe(afile2,index,maxgrd,j,jpds,jgds,jens,ndata,j,kpds,kgds,kens,lbms,cgrid,jret)

if(iret.ne.0) goto 1040 
call printinf(cgrid,maxgrd,kpds,kens,lbms,0)

! start verification score calculation

1040 continue
read(5,domlist,end=1020)
write(6,domlist)

infow(1) = ictl
infow(7) = la1
infow(8) = la2
infow(9) = lo1
infow(10)= lo2

print *, '1 iret=',iret                         
print *, 'infow=,',(infow(ii),ii=1,10)

if(iret.ne.0) goto 400  

! get weight for each grid point
 
call getweight(wght,lengrd,maxgrd,ix,iy,la1,la2,lo1,lo2,ictl)

print *, '----- Weight for Each Grid Point ------'
jpds=-1; jgds=-1; jens=-1
call printinf(wght,lengrd,jpds,jens,lbms,0)

allocate(p_agrid(lengrd),p_fgrid(lengrd,im),p_cgrid(lengrd))
allocate(p_ens_avg(lengrd),p_ens_spr(lengrd),p_ens_p10(lengrd),p_ens_p90(lengrd),p_ens_p50(lengrd))

! get regional data for fcst, obs, climate and etc.

do num=1,im
  sgrid(1:maxgrd)=fgrid(1:maxgrd,num)
! call get_datadom(sgrid,maxgrd,p_fgrid(1,num),lengrd,ix,iy,la1,la2,lo1,lo2,ictl)
  call get_datadom(fgrid(1,num),maxgrd,p_fgrid(1,num),lengrd,ix,iy,la1,la2,lo1,lo2,ictl)
! print *,'p_fgrid(2000,num)=',num, p_fgrid(2000,num)
enddo

call get_datadom(agrid,maxgrd,p_agrid,lengrd,ix,iy,la1,la2,lo1,lo2,ictl)
call get_datadom(cgrid,maxgrd,p_cgrid,lengrd,ix,iy,la1,la2,lo1,lo2,ictl)
call get_datadom(ens_avg,maxgrd,p_ens_avg,lengrd,ix,iy,la1,la2,lo1,lo2,ictl)
call get_datadom(ens_spr,maxgrd,p_ens_spr,lengrd,ix,iy,la1,la2,lo1,lo2,ictl)
call get_datadom(ens_p10,maxgrd,p_ens_p10,lengrd,ix,iy,la1,la2,lo1,lo2,ictl)
call get_datadom(ens_p90,maxgrd,p_ens_p90,lengrd,ix,iy,la1,la2,lo1,lo2,ictl)
call get_datadom(ens_p50,maxgrd,p_ens_p50,lengrd,ix,iy,la1,la2,lo1,lo2,ictl)

!print *,'other grid=', agrid(32580),cgrid(32580),ens_avg(32580),ens_spr(32580)
!print *,'other grid=', ens_p10(32580),ens_p90(32580),ens_p50(32580)

!print *, 'lengrd,p_fgrid=',lengrd,(p_fgrid(1,num),num=1,20)
!print *, 'lengrd,p_fgrid=',lengrd,(p_fgrid(lengrd,num),num=1,20)
!print *, 'lengrd,p_fgrid=',lengrd,(p_fgrid(lengrd+1,num),num=1,20) 

call getprobsc(probsc,p_fgrid,p_agrid,p_cgrid,p_ens_avg,p_ens_spr,p_ens_p10,p_ens_p50,p_ens_p90,wght,infow,lengrd,im)

idx=0

deallocate(p_agrid,p_fgrid,p_cgrid,p_ens_avg,p_ens_spr,p_ens_p10,p_ens_p90,p_ens_p50)

400 continue

write(6,*) "before call w"
call writep(probsc,variable,infow,idx,im,ofile)

goto 1040 

call baclose(afile1,iret)
call baclose(afile2,iret)
call baclose(cfile1,iret)
call baclose(cfile2,iret)

call baclose(ofile,iret)

print *,'CRPS Calculation Successfully Complete'

stop

1000  print *,'There is no Forecast, CRPS Calculation Stop !'

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
dmin=1.e30
dmax=-1.e30
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


subroutine getensfcst(fst,im,ens_avg,ens_spr)

!  subroutine getensfcst
!
! This is subroutine to get 10%, 50% and 90% probability forecast
!
!   subroutine
!              quagev---> quantile function of the generalized extreme-value diftribution

!
!   output
!         favalue    -- probabilaity forecast
!
!--------+---------+---------+---------+---------+----------+---------+--

double precision prob,fvalue,opare(2)
real   ens_spr,ens_avg,prob_top,prob_down
real   fst(im)
double precision quanor

!cc
!c!       Using L-moment ratios and GEV method
!cc
!--------+---------+---------+---------+---------+---------+---------+---------+
!     print *, 'Calculates the L-moment ratios, by prob. weighted'

!print *, 'im,ens_avg,ens_spr'
!print *,  im,ens_avg,ens_spr 

if(ens_spr.le.0) ens_spr=0.001

opare(1)=ens_avg
opare(2)=ens_spr

prob_top=1.025
prob_down=0.025

do ii=1,im
  prob=prob_down+(ii-1)*(prob_top-prob_down)/im
  fvalue=quanor(prob,opare)
  fst(ii)=fvalue
enddo

!print *, ' fvalue=',fst

return
end

subroutine printinf(grid,maxgrd,kpds,kens,lbms,ivar)

! print data information

implicit none

integer    kpds(200),kens(200),ivar,maxgrd,i
real       grid(maxgrd),dmin,dmax
logical(1) lbms(maxgrd)

call grange(maxgrd,lbms,grid,dmin,dmax)

print '(a101)', 'Irec pds5 pds6 pds7 pds8 pds9 pd10 pd11 pd14 pd15 pd16 e2  e3  ndata   Maximun    Minimum   Example'
print '(i4,10i5,2i4,i8,3f10.2)',ivar,(kpds(i),i=5,11),(kpds(i),i=14,16),(kens(i),i=2,3),maxgrd,dmax,dmin,grid(8601)
print *, '   '

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


SUBROUTINE IADDATE(IDATE,IHOUR,JDATE)

IMPLICIT NONE

INTEGER   MON(12),IC,IY,IM,ID,IHR,IDATE,JDATE,IHOUR
DATA MON/31,28,31,30,31,30,31,31,30,31,30,31/

IC = MOD(IDATE/100000000,100 )
IY = MOD(IDATE/1000000,100 )
IM = MOD(IDATE/10000  ,100 )
ID = MOD(IDATE/100    ,100 )
IHR= MOD(IDATE        ,100 ) + IHOUR

IF(MOD(IY,4).EQ.0) MON(2) = 29
1 IF(IHR.LT.0) THEN
    IHR = IHR+24
    ID = ID-1
    IF(ID.EQ.0) THEN
      IM = IM-1
      IF(IM.EQ.0) THEN
        IM = 12
        IY = IY-1
        IF(IY.LT.0) IY = 99
      ENDIF
      ID = MON(IM)
    ENDIF
    GOTO 1
  ELSEIF(IHR.GE.24) THEN
    IHR = IHR-24
    ID = ID+1
    IF(ID.GT.MON(IM)) THEN
      ID = 1
      IM = IM+1
        IF(IM.GT.12) THEN
          IM = 1
        IY = MOD(IY+1,100)
        ENDIF
     ENDIF
     GOTO 1
  ENDIF

JDATE = IC*100000000 + IY*1000000 + IM*10000 + ID*100 + IHR
RETURN
END


subroutine getweight(wght,len,maxgrd,ix,iy,la1,la2,lo1,lo2,ictl)

!  subroutine getweight 
!
! This is subroutine to calculate the weight based on the latitudes
!
!
!   input 
!         la1,la2,lo1,lon2,maxgrd,ix,iy,ictl
!   output
!         wght,len                                     
!
!--------+---------+---------+---------+---------+----------+---------+--
! 
!

implicit none

integer  i,j,ix,iy,nx,ny,nlat,nxy,len,ictl,maxgrd,ngp
real     wght(maxgrd),aloc(ix,iy),weight(ix,iy)
integer  la1,la2,lo1,lo2
real     sumwgt(maxgrd),swgt                      

print *, 'call weight calculation'

print *, 'ix,iy,la1,la2,lo1,lo2,ictl=',ix,iy,la1,la2,lo1,lo2,ictl

! ----
! to calculate the weight based on the latitudes
! ----

if (ictl.eq.1) then

  do i = 1, ix
    do j = 1, iy
!     aloc(i,j) = 90.0 - float(j-1)*1
      aloc(i,j) = 90.0 - float(j-1)/2.
    enddo
  enddo

  call wgt2d(aloc,ix,iy,weight)

  ngp  = (la2-la1+1)*(lo2-lo1+1)

  sumwgt  = 0.
  swgt    = 0.

  do nx = lo1, lo2
    nlat  = 0
    do ny = la1, la2
      nlat = nlat + 1
      sumwgt(nx) = sumwgt(nx) + weight(nx,ny)
      swgt       = swgt + weight(nx,ny)
    enddo
  enddo

  do nx = lo1, lo2
    do ny = la1, la2
      weight(nx,ny)=weight(nx,ny)*float(ngp)/swgt
    enddo
  enddo

elseif (ictl.eq.2) then
  weight = 1.0

else

  print *, 'ICTL=',ictl,' is not well defined, please verify!!!'
  stop 10

endif

nxy = 0

do ny = la1, la2
  do nx = lo1, lo2
    nxy = nxy + 1
    wght(nxy) = weight(nx,ny)
 enddo
enddo

len=nxy

print *, 'len, nxy=,',len,nxy 

return

end


subroutine get_datadom(data,maxgrd,p_data,len,ix,iy,la1,la2,lo1,lo2,ictl)

! subroutine get_datadom
!
! This is subroutine to obtain regional data from global
!
!   input 
!         la1,la2,lo1,lon2,maxgrd,ix,iy
!   output
!         data,len                                     
!
!--------+---------+---------+---------+---------+----------+---------+--
! 

implicit none

integer  i,j,ix,iy,nx,ny,nxy,len,ictl,ij,maxgrd
real     data(maxgrd),p_data(len),glb(ix,iy)
integer  la1,la2,lo1,lo2

p_data=-99999.999

if(ictl.eq.2) then
  len=maxgrd
  p_data(1:maxgrd)=data(1:maxgrd)
endif

if(ictl.eq.2) return            

!
! to save global data on a tempory array
!

do i = 1, ix
  do j = 1, iy
    ij=(j-1)*ix + i
    glb(i,j)=data(ij)
  enddo
enddo

nxy = 0

do ny = la1, la2
  do nx = lo1, lo2
    nxy = nxy + 1
    p_data(nxy) = glb(nx,ny)
 enddo
enddo

len=nxy

!print *, 'glb=',glb(66,77)                                
!print *, 'len=',len,' p_data(len)=',p_data(len) 
!print *, 'len=',len,' p_data(len+1)=',p_data(len+1) 

return

end

subroutine getfcstp(fst,pcent,ens_avg,ens_spr)

!  subroutine getfcstp
!
! This is subroutine to get 10%, 50% and 90% probability forecast
!
!   subroutine
!              quagev---> quantile function of the generalized extreme-value diftribution

!
!   output
!         favalue    -- probabilaity forecast
!
!--------+---------+---------+---------+---------+----------+---------+--

double precision prob,fvalue,opare(2)
real   ens_spr,ens_avg
integer maxgrd
real   fst,pcent
double precision quanor

!cc
!c!       Using L-moment ratios and GEV method
!cc
!--------+---------+---------+---------+---------+---------+---------+---------+
!     print *, 'Calculates the L-moment ratios, by prob. weighted'


if(ens_spr.le.0) ens_spr=0.001

opare(1)=ens_avg
opare(2)=ens_spr

prob=pcent

!print *, prob,ens_avg,ens_spr 

fvalue=quanor(prob,opare)

fst=fvalue

return
end


subroutine cvncep(fgrid,maxgrd,kpds,kgds,kens,lbms,ivar)

! invert CMC data from north to south
!
!  parameters

!        fgrid    ---> ensemble forecast
!        lpds     ---> grid descraption sction from NCEP GEFS data
!                      CMC global ensemble data kgds(1-11) = 0 360 181 -90000 0 136  90000 359000 1000 1000 64
!                      start point ( -90.0 0), end point (  90.0, 359)
!                      NCEP global ensemble data kgds(1-11)= 0 360 181  90000 0 128 -90000 -1000 1000 1000 0
!                      start point (  90.0 0), end point ( -90.0, -1.0)
!                      the difinination of lon 359 and -1.0 are for the same point
!
!         input:  fgrid before invert

!         output: fgrid after invert
!

implicit none

integer    maxgrd,i,j,ij,ijcv,ilon,ilat,ivar,iret
integer    kpds(200),kgds(200),kens(200),lgds(11)
data       lgds/0,360,181,90000,0,128,-90000,-1000,1000,1000,0/
real       fgrid(maxgrd),temp(maxgrd)
logical(1) lbms(maxgrd)

! judge if all read in  data have the same format as NCEP GEFS

if(kgds(4).eq.lgds(4).and.kgds(7).eq.lgds(7)) return

! invert forecast data from north to south

print *, '   '
print *, '----- Reading In Data Before Invert, South to North ------'
call printinf(fgrid,maxgrd,kpds,kens,lbms,ivar)

ilon=kgds(2)
ilat=kgds(3)

do i = 1, ilon
  do j = 1, ilat
   ij=(j-1)*ilon + i
   ijcv=(ilat-j)*ilon + i
   temp(ijcv)=fgrid(ij)
 enddo
enddo

fgrid=temp

do i=1,11
  kgds(i)=lgds(i)
enddo

print *, '----- Reading In Data After Invert, North to South ------'
call printinf(fgrid,maxgrd,kpds,kens,lbms,ivar)

return
end
