program rtma_crps_from_avgspr
!
! main program: rtma_crps_from_avgspr
!
! abstract: This is ensemble verification program for NAEFS downscaled products
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

integer     nvar,ivar,ij,i,ii,k,odate,idate,im,imem,n,irt,nfhrs,inum,itemp
parameter   (nvar=1)
parameter   (im=20)

! trmsa: RMS w.r.t average
! trmsm: RMS w.r.t 50% prob fcst

real,       allocatable :: agrid(:),cgrid(:),fgrid(:,:),fst(:),bias(:)
real,       allocatable :: rpsff(:),rpsfc(:),ens_avg(:),ens_spr(:),ens_p10(:),ens_p90(:),ens_p50(:)
logical(1), allocatable :: lbms(:)
real        dmin,dmax,ensfst(im),temp
real        score,tsprd,trmsa,trmsm,tmerr,tabse
integer     idx,jdate,kdate,jpds9,jpds10,jpds11,kpds9,kpds10,kpds11,ipdym1

real        wfac,obs,acwt,it,ir,ave,xmed,sprd,rmsa,fsprd,frmsa,fmerr,fabse
real        crpsff,crpsf,crpsc,fctp10,fctp90

real        ens_pcent                             

integer     afile1,afile2,cfile1,cfile2,ofile1,bfile,ofile2
integer     jpds(200),jgds(200),jens(200),kpds(200),kgds(200),kens(200)
integer     pds5,pds6,pds7

integer       maxgrd,ndata,if_ndgd,ifout_avgspr,if_nospr                                
integer       index,j,iret,jret             
character*10  cfortnn,variable

namelist/message/nfhrs,odate,idate,variable,if_ndgd,ifout_avgspr

namelist/varlist/pds5,pds6,pds7

read(5,message,end=1020)
read(5,varlist,end=1020)
write(6,message)
write(6,varlist)

afile1=11
afile2=12
cfile1=13
cfile2=14

bfile=15

ofile1=51
ofile2=52

! index=0, to get index buffer from the grib file not the grib index file
! j=0, to search from beginning,  <0 to read index buffer and skip -1-j messages
! lbms, logical*1 (maxgrd or kf) unpacked bitmap if present

index=0; j=0;     jpds=-1  
jgds=-1; jens=-1; iret=0

idx=1

crpsf=-999.99
crpsc=-999.99
trmsa=-999.99
trmsm=-999.99
tsprd=-999.99
tmerr=-999.99
tabse=-999.99
fctp10=-999.99
fctp90=-999.99

if_nospr=0             

! set the fort.* of intput files

write(cfortnn,'(a5,i2)') 'fort.',afile1
call baopenr(afile1,cfortnn,iret)
if (iret .ne. 0) then; print*,'there is no rtma data, stop!'; endif
if (iret .ne. 0) goto 600

write(cfortnn,'(a5,i2)') 'fort.',afile2
call baopenr(afile2,cfortnn,iret)
if (iret .ne. 0) then; print*,'there is no climate mean data, stop!'; endif
!if (iret .ne. 0) goto 1000

write(cfortnn,'(a5,i2)') 'fort.',cfile1
call baopenr(cfile1,cfortnn,iret)
if(iret.ne.0) then; print*,'there is no downscaled fcst mean, stop!'; endif
if(iret.ne.0) goto 600

write(cfortnn,'(a5,i2)') 'fort.',cfile2
call baopenr(cfile2,cfortnn,iret)
if(iret.ne.0) then; print*,'there is no downscaled fcst spread, stop!'; endif
!if(iret.ne.0) goto 600

if(if_ndgd.eq.0) then
  write(cfortnn,'(a5,i2)') 'fort.',bfile
  call baopenr(bfile,cfortnn,iret)
  if(iret.ne.0) then; print*,'there is no dv, stop!'; endif
endif

! set the fort.* of output file

write(cfortnn,'(a5,i2)') 'fort.',ofile1
call baopenw(ofile1,cfortnn,iret)
if (iret.ne.0) then; print*,'there is no output CRPS data, stop!'; endif

if(ifout_avgspr.eq.1.or.ifout_avgspr.eq.2) then
  write(cfortnn,'(a5,i2)') 'fort.',ofile2
  call baopenwa(ofile2,cfortnn,iret)
  if (iret .ne. 0) then; print*,'there is no output ens_avg, stop!'; endif
endif

call getgbeh(afile1,index,j,jpds,jgds,jens,ndata,maxgrd,j,kpds,kgds,kens,iret)
if (iret .ne. 0) then
  call getgbeh(afile1,index,j,jpds,jgds,jens,ndata,maxgrd,j,kpds,kgds,kens,iret)
  if (iret .ne. 0) then
    call getgbeh(cfile1,index,j,jpds,jgds,jens,ndata,maxgrd,j,kpds,kgds,kens,iret)
  endif
endif

allocate(agrid(maxgrd),fgrid(maxgrd,im),fst(im),rpsff(maxgrd),rpsfc(maxgrd),   &
         lbms(maxgrd),cgrid(maxgrd),bias(maxgrd))
allocate(ens_avg(maxgrd),ens_spr(maxgrd),ens_p10(maxgrd),ens_p90(maxgrd),ens_p50(maxgrd))

do ivar = 1, nvar  

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
   
  ! get ensemble mean 

  index=0; j=0;     iret=0
  kpds=-1; kgds=-1; kens=-1

  print *, '----- NCEP Ensemble Mean for Current Time ------'
  call getgbe(cfile1,index,maxgrd,j,jpds,jgds,jens,ndata,j,kpds,kgds,kens,lbms,ens_avg,iret)

  if(iret.ne.0) goto 400

  do ij=1,maxgrd
    if(ens_avg(ij).le.10) ens_avg(ij)=-999.99
  enddo

  call printinf(ens_avg,maxgrd,kpds,kens,lbms,0)

  if(if_ndgd.eq.0) then

    index=0; j=0;     iret=0
    kpds=-1; kgds=-1; kens=-1

    print *, '----- Downscaling Vector for Current Time ------'
    call getgbe(bfile,index,maxgrd,j,jpds,jgds,jens,ndata,j,kpds,kgds,kens,lbms,bias,iret)

    if(iret.ne.0) bias=0.0
    call printinf(bias,maxgrd,kpds,kens,lbms,0)

    call debias(bias,ens_avg,maxgrd)

    print *, '----- Ensemble Mean After Downscaling ------'
    call printinf(ens_avg,maxgrd,kpds,kens,lbms,0)

  endif

  if(ifout_avgspr.eq.1.or.ifout_avgspr.eq.2) then
    call putgbe(ofile2,maxgrd,kpds,kgds,kens,lbms,ens_avg,jret)
  endif

  index=0; j=0;     iret=0
  kpds=-1; kgds=-1; kens=-1

  print *, '----- NCEP Ensemble Spread for Current Time ------'
  call getgbe(cfile2,index,maxgrd,j,jpds,jgds,jens,ndata,j,kpds,kgds,kens,lbms,ens_spr,iret)

  if(iret.ne.0) if_nospr=1

  if(iret.ne.0) goto 150
  call printinf(ens_spr,maxgrd,kpds,kens,lbms,0)

  print *, '----- Get NCEP 10% 50% 90% Forecast from Ens. Mean & Spread ------'

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

  print *, '----- Get NCEP Member Forecast from Ens. Mean & Spread ------'

  do ij=1,maxgrd
    call getensfcst(ensfst,im,ens_avg(ij),ens_spr(ij))
    fgrid(ij,1:im)=ensfst(1:im)
  enddo
  inum=im

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

  150 continue

  ! get rtma analysis

  index=0; j=0;     iret=0
  kpds=-1; kgds=-1; kens=-1
  jpds=-1; jgds=-1; jens=-1

  jpds(5)=pds5; jpds(6)=pds6; jpds(7)=pds7

  print *, '----- RTMA Analysis for Current Time ------'
  call getgbe(afile1,index,maxgrd,j,jpds,jgds,jens,ndata,j,kpds,kgds,kens,lbms,agrid,iret)

  if(iret.ne.0) goto 400 
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

! if (ipdym1.eq.1) then
!   jpds(9) = kpds9
!   jpds(10)= kpds10
!   jpds(11)= kpds11
! else
    jpds(9) = jpds9
    jpds(10)= jpds10
    jpds(11)= jpds11
! endif

  jpds(5)=pds5;    jpds(6)=pds6;      jpds(7)=pds7

! print *,' jpds(9) = ', jpds(9), 'jpds(10) = ', jpds(10), 'jpds(11) = ', jpds(11)

  index=0; j=0;     iret=0
  kpds=-1; kgds=-1; kens=-1

  print *, '----- Climate Mean for Current Time ------'
  call getgbe(afile2,index,maxgrd,j,jpds,jgds,jens,ndata,j,kpds,kgds,kens,lbms,cgrid,iret)

! if(iret.ne.0) goto 400 
  call printinf(cgrid,maxgrd,kpds,kens,lbms,0)

  if(if_nospr.eq.1) goto 250

  ! calculate CRPS with respect to Observation                      

  print *, '+++++++++++++++++++++++++++++++++++++++++++++++'
  print *, ' Continuous Ranked Probability Score w.r.t Obs'
  print *, '+++++++++++++++++++++++++++++++++++++++++++++++'
  print*, '  '

  do n=1,maxgrd
    fst(1:inum)=fgrid(n,1:inum)
    obs=agrid(n)
    call crps(fst,inum,obs,crpsff,0,irt)
    rpsff(n)=crpsff
  enddo

  print *, '----- CRPS w.r.t Obs ------'
  call printinf(rpsff,maxgrd,kpds,kens,lbms,0)

  crpsf=0.0
  wfac=1.0
  do n=1,maxgrd
    crpsf = crpsf + rpsff(n)*wfac
  enddo

  crpsf=crpsf/float(maxgrd)

  print *, 'crpsf=',crpsf

  ! calculate CRPS with respect to climate                      

  print *, '+++++++++++++++++++++++++++++++++++++++++++++++++++'
  print *, ' Continuous Ranked Probability Score w.r.t Climate'
  print *, '+++++++++++++++++++++++++++++++++++++++++++++++++++'
  print*, '  '

  do n=1,maxgrd
    fst(1:inum)=fgrid(n,1:inum)
    obs=cgrid(n)
    if(obs.le.-999.) then
      crpsff=-999.99
    else
      call crps(fst,inum,obs,crpsff,0,irt)
    endif
    rpsfc(n)=crpsff
  enddo

  print *, '----- CRPS w.r.t Climate ------'
  call printinf(rpsfc,maxgrd,kpds,kens,lbms,0)

  crpsc=0.0
  wfac=1.0
  itemp=0

  do n=1,maxgrd
    if(rpsfc(n).ge.-990) then
      crpsc = crpsc + rpsfc(n)*wfac
      itemp=itemp+1
    endif
  enddo

  if(itemp.eq.0) crpsc=-999.99
  if(itemp.ge.1) crpsc=crpsc/float(itemp)

  print *, 'crpsc=',crpsc
 
! crpsc=crpsc/float(maxgrd)


  ! calculate RMS using 50% probability forecast 

  print *, '++++++++++++++++++++++++++'
  print *, ' RMS of 50% prob fcst '
  print *, '++++++++++++++++++++++++++'

  call cal_rmssprd(agrid,ens_p50,ens_spr,inum,maxgrd,pds5,pds6,pds7,trmsm,tsprd,tmerr,tabse)

  write (*,*) 'idx,trmsm,tsprd,tmerr,tabse'                
  write (*,*) idx,trmsm,tsprd,tmerr,tabse                
  write (*,*) "   "

  250 continue

  ! calculate RMS and spread           

  print *, '++++++++++++++++++++'
  print *, ' RMS w.r.t. obs  '
  print *, '++++++++++++++++++++'

  call cal_rmssprd(agrid,ens_avg,ens_spr,inum,maxgrd,pds5,pds6,pds7,trmsa,tsprd,tmerr,tabse)

  idx=0

  write (*,*) 'idx,trmsa,tsprd,tmerr,tabse'                
  write (*,*) idx,trmsa,tsprd,tmerr,tabse                
  write (*,*) "   "

  if(if_nospr.eq.1) then
    tsprd=-999.99
  endif

  if(if_nospr.eq.1) goto 400

! 10% prob and 90% count with repective to obs

  fctp90=0
  fctp10=0

  do n=1,maxgrd           
    obs=agrid(n)
    if(obs.lt.ens_p10(n)) then
      fctp10=fctp10+1   
    endif
    if(obs.gt.ens_p90(n)) then
      fctp90=fctp90+1   
    endif
  enddo
 
  print *, 'fctp10,fctp90=',fctp10,fctp90

  fctp10=fctp10/maxgrd     
  fctp90=fctp90/maxgrd     

! print *, 'fctp10,fctp90=',fctp10,fctp90

  400 continue

! end of variable                                          

enddo

600 continue

write(ofile1,800) variable,odate,idate,nfhrs
write(ofile1,801) 
write(ofile1,802) idx,crpsf,crpsc,trmsa,trmsm,tsprd,tmerr,tabse,fctp90,fctp10
write(ofile1,*)

800 format(' Var: ',a9, 'at Valid Time ',i10,' (ic: ',i10,i4,'hrs)') 
801 format(' IDX     CRPSF     CRPSC     RMSA      RMSM      SPRD      MERR      ABSE    COUNTP90  COUNTP10')
802 format(i4,9f10.4)

call baclose(afile1,iret)
call baclose(afile2,iret)
call baclose(cfile1,iret)
call baclose(cfile2,iret)

call baclose(ofile1,iret)
call baclose(ofile2,iret)

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

double precision prob,fvalue,opare(2),quanor
real   ens_spr,ens_avg,prob_top,prob_down
real   fst(im)

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
! print *, 'prob=',prob,' fvalue=',fst(ii)
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

subroutine cal_rmssprd(agrid,ens_avg,ens_spr,inum,maxgrd,pds5,pds6,pds7,trmsa,tsprd,tmerr,tabse)

implicit none

integer  pds5,pds6,pds7,maxgrd,n,inum
real     ens_avg(maxgrd),ens_spr(maxgrd),agrid(maxgrd)
real     wfac,obs,acwt,it,ir,ave,xmed,sprd,rmsa,fsprd,frmsa,fmerr,fabse
real     trmsa,tsprd,tmerr,tabse,temp

acwt = 0.0
fsprd= 0.0
frmsa= 0.0
fmerr= 0.0
fabse= 0.0

write(6,*) "test mask", ens_avg(97066)
do n=1,maxgrd           

  if(ens_avg(n).ge.-999.00.and.agrid(n).ge.-999.00) then

  wfac=1.0               
  acwt=acwt+wfac
  obs=agrid(n)                

  if(pds5.eq.31.and.pds6.eq.105.and.pds7.eq.10) then

    ave=ens_avg(n)
    sprd=ens_spr(n)**2*float(inum-1)

    fsprd = fsprd + sprd*wfac

    temp=ave-obs
    if(temp.gt.180.) temp=temp-360.0
    if(temp.lt.-180.) temp=temp+360.0

    frmsa = frmsa + temp*temp*wfac
    fmerr = fmerr + temp*wfac
    fabse = fabse + abs(temp)*wfac

  else

    ave=ens_avg(n)
    sprd=ens_spr(n)**2*float(inum-1)
    fsprd = fsprd + sprd*wfac
    frmsa = frmsa + (ave-obs)*(ave-obs)*wfac
    fmerr = fmerr + (ave-obs)*wfac
    fabse = fabse + abs(ave-obs)*wfac

  endif
   
!    if(n.eq.8601) then
!     write (6,*) 'jpds(5),jpds(6)=', pds5,pds6
!     write(6,'(10f10.1)') fst                           
!     write (6,*) 'calculated avg and sprd=', ave, sprd
!     write (6,*) 'input avg and sprd=', ens_avg(8601),ens_spr(8601),ens_spr(8601)**2*float(inum-1)
!     write (6,*) 'trmsa,tsprd,tmerr,tabse=',frmsa,fsprd,fmerr,fabse
!    endif

  endif
enddo
 
tsprd = sqrt(fsprd/float(inum-1)/acwt)
trmsa = sqrt(frmsa/acwt)
tmerr = fmerr/acwt
tabse = fabse/acwt

write (6,*) 'trmsa,tsprd,tmerr,tabse=',trmsa,tsprd,tmerr,tabse
write (6,*) 'trmsa,tsprd,tmerr,tabse=',acwt                      

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

double precision prob,fvalue,opare(2),quanor
real   ens_spr,ens_avg
integer maxgrd
real   fst,pcent

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

subroutine debias(bias,fgrid,maxgrd)

!     apply the bias correction
!
!     parameters
!                  fgrid  ---> ensemble forecast
!                  bias   ---> bias estimation

implicit none

integer maxgrd,ij
real bias(maxgrd),fgrid(maxgrd)

do ij=1,maxgrd
  if(fgrid(ij).gt.-99999.0.and.fgrid(ij).lt.999999.0.and.bias(ij).gt.-99999.0.and.bias(ij).lt.999999.0) then
    fgrid(ij)=fgrid(ij)-bias(ij)
  else
    fgrid(ij)=fgrid(ij)
  endif
enddo

return

end

