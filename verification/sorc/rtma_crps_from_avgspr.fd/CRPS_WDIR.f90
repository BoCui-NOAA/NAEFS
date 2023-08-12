!+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
!  Subroutine      CRPS_WDIR(fst,m,obs,ccrps,ictl,irt)
!  Prgmmr: Yuejian Zhu           Org: np23          Date: 2006-12-26
!
!  This is the subroutine to calculete Continuous Ranked Probability Score
!         for NAEFS project on IBM-SP
!
!   parameters:
!      fst   -- forecasts for m ensemble members
!      m     -- ensemble size   
!      obs   -- analysis or observation, or climatology (truth)                
!      ccrps -- crp scores (local normalize score: 0 - 1.0)
!                          (standard score: 0 - infinite  )
!      ictl  -- =1 (make local normalize score)              
!      irt   -- 0-successful
!               10-need to review ensemble forecast data
!
!   Fortran 90 on IBMSP
!   Called subroutine: sortmm
!
!--------+---------+---------+---------+---------+----------+---------+--

subroutine crps_wdir(fst,m,obs,ccrps,ictl,irt)

implicit none

real    fst(m),ena(m,3),temp
integer m,ictl,irt,k,i,n
real    ta,ccrps,obs,tds,erend,ds,fac,erhf,elend,elhf

irt=0
k=0
ta=0.0
ccrps=0.0

if (m.le.0) goto 999

do n = 1, m
  ena(n,1)=fst(n)
enddo

! call sortmm to re-arrange the data from low to high
call sortmm(ena,m,3,1)

! print *, (ena(i,1),i=1,m)
! print *, (ena(i,2),i=1,m)
! print *, (ena(i,3),i=1,m)

do n = 1, m
  if (obs.lt.ena(n,2)) goto 100
  k=n
enddo

100  continue

! left end point (approximately)
! right end point (approximately)

if (m.gt.1) then
  elhf=(ena(2,2)-ena(1,2))/2.0
  elend=ena(1,2)-elhf                    
  erhf=(ena(m,2)-ena(m-1,2))/2.0
  erend=ena(m,2)+erhf                          
  call phasechange(elend,1,3)
  call phasechange(erend,1,3)
  if(elend.ge.erend) then
    print*,'elend bigger erend',elend,erend
    temp=erend
    erend=elend
    elend=temp  
    print*,'elend bigger erend',elend,erend
  endif
else
  elend=ena(1,2)
  erend=ena(1,2)
endif


if (obs.gt.elend.and.obs.lt.erend) then
  tds=erend-elend                   
  if(abs(tds).gt.180) then
    print*,'0a wind dir difference bigger than 180, stop!' 
    !print*, 'erend-elend= ',erend,elend                                    
    !print*, 'ena(m,2),erhf= ',ena(m,2),erhf                                
    !print *, (ena(i,1),i=1,m)
    !print *, (ena(i,2),i=1,m)
    !print *, (ena(i,3),i=1,m)
   endif
else
  if (obs.lt.elend) then
    tds=erend-obs
    if(abs(tds).gt.180) then; print*,'0b wind dir difference bigger than 180, stop!'; endif  
  else
    tds=obs-elend
    if(abs(tds).gt.180) then; print*,'0c wind dir difference bigger than 180, stop!'; endif  
  endif
endif

if (k.le.0) then
  do n = 1, m
    fac=1.0-float(n-1)/float(m)
    if (n.eq.1) then
      ds=ena(1,2)-obs              
      if(abs(ds).gt.180) then; print*,'1 wind dir difference bigger than 180, stop!'; endif  
      ta=ta+fac*fac*ds
    else
      ds=ena(n,2)-ena(n-1,2)
      if(abs(ds).gt.180) then; print*,'2 wind dir difference bigger than 180, stop!'; endif  
      ta=ta+fac*fac*ds
    endif
  enddo
  ! print *, 'k=',k,' ds=',ds,' ta=',ta,' obs=',obs
elseif (k.ge.m) then
  do n = 1, m
    fac=float(n)/float(m)
    if (n.eq.m) then
      ds=obs-ena(m,2)
      if(abs(ds).gt.180) then; print*,'3 wind dir difference bigger than 180, stop!'; endif  
      ta=ta+fac*fac*ds
    else
      ds=ena(n+1,2)-ena(n,2)
      if(abs(ds).gt.180) then; print*,'4 wind dir difference bigger than 180, stop!'; endif  
      ta=ta+fac*fac*ds
    endif
    ! print *, 'k=',k,' ds=',ds,' ta=',ta,' obs=',obs
  enddo
else
  do n = 1, k
    fac=float(n)/float(m)
    if (n.ne.k) then
      ds=ena(n+1,2)-ena(n,2)
      if(abs(ds).gt.180) then; print*,'5 wind dir difference bigger than 180, stop!'; endif  
      ta=ta+fac*fac*ds
    else
      ds=obs-ena(n,2)
      if(abs(ds).gt.180) then; print*,'6 wind dir difference bigger than 180, stop!'; endif  
      ta=ta+fac*fac*ds
    endif
    ! print *, 'k=',k,' ds=',ds,' ta=',ta,' obs=',obs
  enddo
  do n = k+1, m
    fac=1.0-float(n-1)/float(m)
    if (n.ne.k+1) then
      ds=ena(n,2)-ena(n-1,2)
      if(abs(ds).gt.180) then; print*,'7 wind dir difference bigger than 180, stop!'; endif  
      ta=ta+fac*fac*ds
    else
      ds=ena(n,2)-obs
      if(abs(ds).gt.180) then; print*,'8 wind dir difference bigger than 180, stop!'; endif  
      ta=ta+fac*fac*ds
    endif
    ! print *, 'k=',k,' ds=',ds,' ta=',ta,' obs=',obs
  enddo
endif

if (tds.ne.0.0.and.ictl.eq.1) then
  ta=ta/tds
endif
ccrps=ta

! print *, ccrps,obs,(ena(i,2),i=1,m)

return   
999  print *, "ensemble size is less than one, crps=0, quit"
irt=10
return
end
