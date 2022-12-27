subroutine cal_rmssprd(agrid,ens_avg,ens_spr,inum,maxgrd,infow,wght,score)

implicit none

integer  pds5,pds6,pds7,maxgrd,n,inum
real     ens_avg(maxgrd),ens_spr(maxgrd),agrid(maxgrd),wght(maxgrd),score(4)
real     wfac,obs,acwt,it,ir,ave,xmed,sprd,rmsa,fsprd,frmsa,fmerr,fabse
real     trmsa,tsprd,tmerr,tabse,temp,index
integer  infow(20)

index=0

if(agrid(1).lt.-999.0.or.ens_avg(1).lt.-999.0.or.ens_spr(1).lt.-999.0) then
  tsprd = -999.99                        
  trmsa = -999.99                        
  tmerr = -999.99                        
  tabse = -999.99                        
  index=1
endif

if(index.eq.1) goto 1000

pds5=infow(4)
pds6=infow(5)
pds7=infow(6)

acwt = 0.0
fsprd= 0.0
frmsa= 0.0
fmerr= 0.0
fabse= 0.0

do n=1,maxgrd           

  wfac=wght(n)           
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
   
! if(n.le.5) then
!   write (6,*) n, 'grid calculated avg,ens_spr and sprd,wfac=', ave,ens_spr(n),sprd,wfac
!   write (6,*) 'input avg and sprd=', (ave-obs)*(ave-obs)*wfac, sprd*wfac                     
!   write (6,*) 'frmsa,fsprd,fmerr,fabse=',frmsa,fsprd,fmerr,fabse
!   write (6,*) ' '
! endif

  if(n.eq.maxgrd) then
    write (6,*) n, 'grid calculated avg and sprd=', ave, sprd
    write (6,*) 'input avg and sprd=', ens_avg(n),ens_spr(n),ens_spr(n)**2*float(inum-1)
    write (6,*) 'frmsa,fsprd,fmerr,fabse=',frmsa,fsprd,fmerr,fabse
  endif

enddo
 
tsprd = sqrt(fsprd/float(inum-1)/acwt)
trmsa = sqrt(frmsa/acwt)
tmerr = fmerr/acwt
tabse = fabse/acwt

score(1)=tsprd
score(2)=trmsa
score(3)=tmerr
score(4)=tabse

1000 continue

write (6,*) 'trmsa,tsprd,tmerr,tabse=',trmsa,tsprd,tmerr,tabse

return
end

