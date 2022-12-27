program average    

implicit none

integer      ii,n,ilen,istymd,iedymd,nfcst,istep,ifh,nd,maxstep,step,interl
integer      numreg,numsc,ireg,isc,nrec
parameter    (istep=64,maxstep=istep+1,interl=6,numreg=6,numsc=9)

real         tprobsc(istep,numsc,numreg),probsc(numsc,numreg),prob(numsc,numreg)
integer      fdays(numreg)                                                     

integer      index(numreg),ifile(370)
integer      nfhrs                          

character*120 cfile(370),ofile,gfile
character*10  variable
character*80  title(numreg)         

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
  nrec=5*numreg*nfcst

  probsc=0.0

  fdays=0

  print *, ' forecast lead time step = ',nfcst,' nrec=',nrec
 
  do nd = 1, ilen         ! sample size: how many day of stats

    if(ifile(nd).eq.1) then

      open(unit=11,file=cfile(nd),form='FORMATTED',status='UNKNOWN')

      print *,'        '
      print *,' day  = ', nd

      ! the repeat of maxstep and istep is to find the right time step

      if(nrec.gt.0) then
        do ii = 1, nrec
           read(11,*)
        enddo
      endif

      do ireg=1,numreg  

        read(11,800,end=1000) title(ireg)              
        read(11,801,end=1000) variable,nfhrs
        read(11,802,end=1000)
        read(11,803,end=1000) index(ireg),(prob(isc,ireg),isc=1,numsc)
        read(11,802,end=1000)

        if(ifh.eq.nfhrs) then     
          write(6,*) " "
          write(6,800) title(ireg)              
          write(6,801) variable,nfhrs
          write(6,802)
          write(6,803) index(ireg),(prob(isc,ireg),isc=1,numsc)
          write(6,802)
        endif

      enddo     ! end of ireg region

      close(11)

      do ireg=1,numreg  
        if(index(ireg).eq.0) then                   
          do isc=1,numsc  
            probsc(isc,ireg)=probsc(isc,ireg)+prob(isc,ireg)
          enddo
          fdays(ireg)=fdays(ireg)+1
        endif
      enddo

    endif

  1000 continue

  enddo   ! endo ilen, how many day of stats

  write(6,*) "before "
  write(6,*) " fdays,fcrpsf,fcrpsc,frmsa,frmsm,fsprd,fmerr,fabse,fctp90,fctp10"
  do ireg=1,numreg  
    write(6,'(i4,9f10.4)') fdays(ireg),(probsc(isc,ireg),isc=1,numsc)
  enddo
  write(6,*) " "

  do ireg=1,numreg  

    if(fdays(ireg).ne.0) then
      do isc=1,numsc  
        tprobsc(nfcst,isc,ireg)=probsc(isc,ireg)/fdays(ireg)
      enddo
    else
      do isc=1,numsc  
        tprobsc(nfcst,isc,ireg)=-999.99                        
      enddo
    endif

  enddo

  write(6,*) "after "
  write(6,*) " fdays,fcrpsf,fcrpsc,frmsa,frmsm,fsprd,fmerr,fabse,fctp90,fctp10"
  do ireg=1,numreg  
    write(6,'(i4,9f10.4)') fdays(ireg),(tprobsc(nfcst,isc,ireg),isc=1,numsc)
  enddo
  write(6,*) " "

enddo    ! enddo lead-time

do isc=1,numsc  
  write(52) ((tprobsc(nfcst,isc,ireg),nfcst=1,istep),ireg=1,numreg)
enddo

do nfcst = 1, istep     ! forecast lead time

  ifh = interl*nfcst

  do ireg=1,numreg  
    write(51,800) title(ireg)                           
    write(51,901) variable,istymd,iedymd,ifh        
    write(51,902)
    write(51,903) (tprobsc(nfcst,isc,ireg),isc=1,numsc)
    write(51,*)
  enddo

enddo

800 format(a70)
801 format(a15,40x,i4)
802 format(72x)
803 format(i4,9f10.4)

901 format(' Var: ',a9,' Averaged Verification Scores From ',i10,' to ',i10,' at',i4,'hrs')
902 format('     CRPSF     CRPSC     RMSA      RMSM      SPRD      MERR      ABSE    COUNTP90  COUNTP10')
903 format(9f10.4)

2000 continue
stop
end

