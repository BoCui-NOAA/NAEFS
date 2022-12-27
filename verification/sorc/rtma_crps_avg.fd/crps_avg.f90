program average    

implicit none

integer      ivar,n,ilen,istymd,iedymd,nfcst,istep,ifh,nd,maxstep,step,interl
!parameter    (istep=64,maxstep=65,interl=6)
parameter    (istep=128,maxstep=129,interl=3)

real         crpsf,crpsc,rmsa,rmsm,sprd,merr,abse,ctp90,ctp10
real         fcrpsf,fcrpsc,frmsa,frmsm,fsprd,fmerr,fabse,fctp90,fctp10
real         tcrpsf(istep),tcrpsc(istep),trmsa(istep),trmsm(istep),tsprd(istep) 
real         tmerr(istep),tabse(istep),tctp90(istep),tctp10(istep)
integer      fdays                                                     

integer      index,ifile(400)
integer      nfhrs                          

character*150 cfile(400),ofile,gfile
character*10  variable

namelist/filec/ cfile,ofile,gfile
namelist/filei/ ifile
namelist/namin/ ilen,istymd,iedymd

read  (5,filec,end=2000)
!write (6,filec)

read  (5,filei,end=2000)
write (6,filei)

read  (5,namin,end=2000)
write (6,namin)

open(unit=51,file=ofile,form='FORMATTED',status='NEW')
open(unit=52,file=gfile,form='UNFORMATTED',status='NEW')

do nfcst = 1, istep     ! forecast lead time

  ifh = interl*nfcst
  fcrpsf=0.0              
  fcrpsc=0.0              
  frmsa=0.0              
  frmsm=0.0              
  fsprd=0.0              
  fmerr=0.0              
  fabse=0.0              
  fctp90=0.0              
  fctp10=0.0              

  fdays=0

  print *, ' forecast lead time step = ',nfcst
 
  do nd = 1, ilen         ! sample size: how many day of stats

    if(ifile(nd).eq.1) then

      open(unit=11,file=cfile(nd),form='FORMATTED',status='UNKNOWN')

      print *,'        '
      print *,' day  = ', nd

      ! the repeat of maxstep and istep is to find the right time step

      do step=1,maxstep

        read(11,800,end=1000) variable,nfhrs
        read(11,801,end=1000)
        read(11,802,end=1000) index,crpsf,crpsc,rmsa,rmsm,sprd,merr,abse,ctp90,ctp10
        read(11,801,end=1000)

        if(ifh.eq.nfhrs) then     
          write(6,*) " "
          write(6,*) "nfhrs=",nfhrs," ifh=",ifh
          write(6,802) index,crpsf,crpsc,rmsa,rmsm,sprd,merr,abse,ctp90,ctp10
        endif
        if(ifh.eq.nfhrs) goto 200 
      enddo

      200 continue

      if(index.eq.0) then                   
        fcrpsf=fcrpsf+crpsf
        fcrpsc=fcrpsc+crpsc
        frmsa=frmsa+rmsa
        frmsm=frmsm+rmsm
        fsprd=fsprd+sprd
        fmerr=fmerr+merr
        fabse=fabse+abse
        fctp90=fctp90+ctp90
        fctp10=fctp10+ctp10
        fdays=fdays+1
      endif

    endif

  1000 continue

  enddo   ! endo ilen

  write(6,*) "before "
  write(6,*) " fdays,fcrpsf,fcrpsc,frmsa,frmsm,fsprd,fmerr,fabse,fctp90,fctp10"
  write(6,'(i4,9f10.4)') fdays,fcrpsf,fcrpsc,frmsa,frmsm,fsprd,fmerr,fabse,fctp90,fctp10
  write(6,*) " "

  if(fdays.ne.0) then
    tcrpsf(nfcst)=fcrpsf/fdays
    tcrpsc(nfcst)=fcrpsc/fdays
    trmsa(nfcst)=frmsa/fdays
    trmsm(nfcst)=frmsm/fdays
    tsprd(nfcst)=fsprd/fdays
    tmerr(nfcst)=fmerr/fdays
    tabse(nfcst)=fabse/fdays
    tctp90(nfcst)=fctp90/fdays
    tctp10(nfcst)=fctp10/fdays
  else
    tcrpsf(nfcst)=-999.99     
    tcrpsc(nfcst)=-999.99     
    trmsa(nfcst)=-999.99     
    trmsm(nfcst)=-999.99     
    tsprd(nfcst)=-999.99     
    tmerr(nfcst)=-999.99     
    tabse(nfcst)=-999.99     
    tctp90(nfcst)=-999.99     
    tctp10(nfcst)=-999.99     
  endif

! write(6,*) "after "
! write(6,*) " fdays,fcrpsf,fcrpsc,frmsa,frmsm,fsprd,fmerr,fabse,fctp90,fctp10"
! write(6,'(i4,9f10.4)') fdays,fcrpsf,fcrpsc,frmsa,frmsm,fsprd,fmerr,fabse,fctp90,fctp10
! write(6,*) " "

enddo    ! enddo lead-time

write(52) (tcrpsf(nfcst),nfcst=1,istep)
write(52) (tcrpsc(nfcst),nfcst=1,istep)
write(52) (trmsa(nfcst),nfcst=1,istep)
write(52) (trmsm(nfcst),nfcst=1,istep)
write(52) (tsprd(nfcst),nfcst=1,istep)
write(52) (tmerr(nfcst),nfcst=1,istep)
write(52) (tabse(nfcst),nfcst=1,istep)
write(52) (tctp90(nfcst),nfcst=1,istep)
write(52) (tctp10(nfcst),nfcst=1,istep)

do nfcst = 1, istep     ! forecast lead time

  ifh = interl*nfcst
  write(51,900) variable,istymd,iedymd,ifh        
  write(51,901)
  write(51,902) tcrpsf(nfcst),tcrpsc(nfcst),trmsa(nfcst),trmsm(nfcst),   &
                tsprd(nfcst),tmerr(nfcst),tabse(nfcst),tctp90(nfcst),tctp10(nfcst)
  write(51,*)

enddo

800 format(a15,40x,i4)
801 format(72x)
802 format(i4,9f10.4)

900 format(' Var: ',a9,' Averaged Verification Scores From ',i10,' to ',i10,' at',i4,'hrs')
901 format('     CRPSF     CRPSC     RMSA      RMSM      SPRD      MERR      ABSE    COUNTP90  COUNTP10')
902 format(9f10.4)

2000 continue
stop
end

