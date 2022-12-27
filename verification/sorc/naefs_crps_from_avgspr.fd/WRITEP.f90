subroutine writep(probsc,variable,infow,idx,im,ofile)
!
!  input
!       im        --  number of ensemble members
!       variable  -- variable name
!

implicit none

character*3 cmdl
character*7 variable
character*2 reg

integer  ictl,idate,odate,ifd,ilv,ilv2,ofile,idx,ii
integer  la1,la2,lo1,lo2

real     probsc(20)
integer  infow(20)

integer  nfhrs,im

ictl  = infow(1) 
idate = infow(2)
nfhrs = infow(3)

la1   = infow(7)
la2   = infow(8)
lo1   = infow(9)
lo2   = infow(10)
!ib    = infow(11)

if (la1.eq.11.and.la2.eq.70.and.lo1.eq.1.and.lo2.eq.360) reg='NH'
if (la1.eq.110.and.la2.eq.170.and.lo1.eq.1.and.lo2.eq.360) reg='SH'
if (la1.eq.70.and.la2.eq.110.and.lo1.eq.1.and.lo2.eq.360) reg='TR'
if (la1.eq.30.and.la2.eq.70.and.lo1.eq.220.and.lo2.eq.315) reg='NA'
if (la1.eq.11.and.la2.eq.60.and.lo1.eq.1.and.lo2.eq.45) reg='EU'
if (la1.eq.11.and.la2.eq.80.and.lo1.eq.45.and.lo2.eq.140) reg='AS'
!if (la1.eq.21.and.la2.eq.37.and.lo1.eq.17.and.lo2.eq.49) reg='IN'

call iaddate(idate,nfhrs,odate)

write(ofile,501) reg,la1,la2,lo1,lo2
write(ofile,502) variable,odate,idate,nfhrs
write(ofile,503)
write(ofile,504) idx,(probsc(ii),ii=1,9)
write(ofile,*)

501 format('###  PROB SCORES for Region: ', a2,'(la1=',i3,' la2=',i3,' lo1=',i3,' lo2=',i3,')')
502 format(' Var: ',a9, 'at Valid Time ',i10,' (ic: ',i10,i4,'hrs)')
503 format(' IDX     CRPSF     CRPSC     RMSA      RMSM      SPRD      MERR      ABSE    COUNTP90  COUNTP10')
504 format(i4,9f10.4)

return
end
