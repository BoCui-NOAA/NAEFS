
subroutine getprobsc(probsc,fgrid,agrid,cgrid,ens_avg,ens_spr,ens_p10,ens_p50,ens_p90,wght,infow,lengrd,inum)

!+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
!
! This is simple version of probabilistic verification sub-program
!         for NAEFS project on IBM-SP
!
!   parameters:
!      len   -- total grid points/observations
!      inum  -- ensemble members
!
!   Fortran 90 on IBMSP
!
!--------+---------+---------+---------+---------+----------+---------+--

implicit none

integer n,lengrd,inum,irt,itemp
real    agrid(lengrd),cgrid(lengrd),fgrid(lengrd,inum),fst(inum)
real    ens_avg(lengrd),ens_spr(lengrd),ens_p10(lengrd),ens_p90(lengrd),ens_p50(lengrd)
real    wght(lengrd),rpsff(lengrd),rpsfc(lengrd),score(4)

real    wfac,obs,acwt,it,ir,ave,xmed,sprd,rmsa,fsprd,frmsa,fmerr,fabse
real    crpsff,crpsf,crpsc,fctp10,fctp90
real    tsprd,trmsa,trmsm,tmerr,tabse

real    probsc(20)
integer infow(20)

integer pds5,pds6,pds7                 

pds5=infow(4)
pds6=infow(5)
pds7=infow(6)

!print *, 'lengrd,inum=',lengrd,inum
!print *, 'fst=',(fgrid(1,n),n=1,20)
!print *, 'fst=',(fgrid(lengrd,n),n=1,20)

!print *,'in getprobsc='
!print *, fgrid(1,1),agrid(1),cgrid(1)
!print *, ens_avg(1),ens_spr(1),ens_p10(1),ens_p50(1),ens_p90(1)
!print *, wght(1),infow(1),lengrd,inum
!print *, pds5,pds6,pds7              

! calculate CRPS with respect to Observation                      

print *, ' '
print *, '+++++++++++++++++++++++++++++++++++++++++++++++'
print *, ' Continuous Ranked Probability Score w.r.t Obs'
print *, '+++++++++++++++++++++++++++++++++++++++++++++++'
print*, '  '

do n=1,lengrd    
  fst(1:inum)=fgrid(n,1:inum)
  obs=agrid(n)
  call crps(fst,inum,obs,crpsff,0,irt)
  rpsff(n)=crpsff
enddo

print *, 'fst=',(fgrid(1,n),n=1,inum)
print *, 'obs=',agrid(1)
print *, 'fst=',(fgrid(lengrd,n),n=1,inum)
print *, 'obs=',agrid(lengrd)
print *, 'crpsff=',crpsff             

print *, '----- CRPS w.r.t Obs ------'
call messageinf(rpsff,lengrd)

crpsf=0.0
do n=1,lengrd    
  wfac=wght(n)
  crpsf = crpsf + rpsff(n)*wfac
enddo

crpsf=crpsf/float(lengrd)

print *, 'crpsf=',crpsf

! calculate CRPS with respect to climate                      

print *, '+++++++++++++++++++++++++++++++++++++++++++++++++++'
print *, ' Continuous Ranked Probability Score w.r.t Climate'
print *, '+++++++++++++++++++++++++++++++++++++++++++++++++++'
print*, '  '

do n=1,lengrd
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
call messageinf(rpsfc,lengrd)

crpsc=0.0
itemp=0

do n=1,lengrd
  wfac=wght(n)
  if(rpsfc(n).ge.-990) then
    crpsc = crpsc + rpsfc(n)*wfac
    itemp=itemp+1
  endif
enddo

if(itemp.eq.0) crpsc=-999.99
if(itemp.ge.1) crpsc=crpsc/float(itemp)

print *, 'crpsc=',crpsc
 
! calculate RMS using 50% probability forecast 

print *, '++++++++++++++++++++++++++++++++'
print *, ' RMS of 50% prob fcst w.r.t obs '
print *, '++++++++++++++++++++++++++++++++'

call cal_rmssprd(agrid,ens_p50,ens_spr,inum,lengrd,infow,wght,score)

trmsm=score(2)

write (*,*) 'trmsm=',trmsm                              

! calculate RMS and spread           

print *, '++++++++++++++++++++'
print *, ' RMS w.r.t. obs  '
print *, '++++++++++++++++++++'

call cal_rmssprd(agrid,ens_avg,ens_spr,inum,lengrd,infow,wght,score)

tsprd=score(1)
trmsa=score(2)
tmerr=score(3)
tabse=score(4)

write (*,*) 'idx,trmsa,tsprd,tmerr,tabse'                
write (*,*) trmsa,tsprd,tmerr,tabse                
write (*,*) "   "

! 10% prob and 90% count with repective to obs

if(agrid(1).lt.-999.0.or.ens_p10(1).lt.-999.0) then
  fctp10= -999.99
endif
if(agrid(1).lt.-999.0.or.ens_p90(1).lt.-999.0) then
  fctp90= -999.99
endif

if(agrid(1).lt.-999.0.or.ens_p10(1).lt.-999.0) goto 200
if(agrid(1).lt.-999.0.or.ens_p90(1).lt.-999.0) goto 200

fctp90=0
fctp10=0

do n=1,lengrd           
  obs=agrid(n)
  if(obs.lt.ens_p10(n)) then
    fctp10=fctp10+1   
  endif
  if(obs.gt.ens_p90(n)) then
    fctp90=fctp90+1   
  endif
enddo
 
print *, 'fctp10,fctp90=',fctp10,fctp90

fctp10=fctp10/lengrd     
fctp90=fctp90/lengrd     

200 continue

print *, 'fctp10,fctp90=',fctp10,fctp90

probsc(1)= crpsf
probsc(2)= crpsc
probsc(3)= trmsa
probsc(4)= trmsm
probsc(5)= tsprd
probsc(6)= tmerr
probsc(7)= tabse
probsc(8)= fctp90
probsc(9)= fctp10

print *, 'probsc(1-9=',(probsc(n),n=1,9)

return
end


subroutine messageinf(grid,maxgrd)

! print data information

implicit none

integer    maxgrd,i
real       grid(maxgrd),dmin,dmax

dmin=1.e30
dmax=-1.e30

do i=1,maxgrd
  dmin=min(dmin,grid(i))
  dmax=max(dmax,grid(i))
enddo

print*, 'ndata   Maximun    Minimum   Example'
print '(i5,3f10.2)',maxgrd,dmax,dmin,grid(int(maxgrd/2))
print *, '   '

return
end
