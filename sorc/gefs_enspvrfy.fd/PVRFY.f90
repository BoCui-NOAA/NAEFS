      program pvrfy
!
! MAIN PROGRAM: PVRFY
!
! PROGRAM HISTORY LOG:
!  1996-09-10  MARK BALDWIN
!  2002-09-20  YUEJIAN ZHU MODIFIED FOR IMPLEMENTATION
!  2011-12-15  YAN LUO MODIFIED FOR UPGRADE OF PRECIPITATION CALIBRATION
!  2013-08-06  YAN LUO MODIFIED TO CONVERT I/O FROM GRIB1 TO GRIB2
!
!  ABSTRACT:
!  GENERAL PRECIP VERF CODE, USES M IRDELL'S IPLIB TO INTERPOLATE
!   CODE IS MORE OR LESS GENERAL, DRIVEN BY THE ANALYSIS GDS
!    BUT DIMENSIONS, ETC ARE SET UP TO GO TO GRID 211 (80km LMBC)
!    PARTICULARLY FOR THE REGIONAL MASKS
!
!  1. READ IN PRECIP ANALYSIS
!  2. READ IN PRECIP FORECAST
!  3. INTERPOLATE FORECAST TO ANALYSIS GRID
!  4. DO VERIFICATION
!  5. OUTPUT STATS, FORECAST ON ANALYSIS GRID FOR ARCHIVE
!
!  INPUT UNIT 5
!   CONTROLS THE INPUT
! LINE
!  #  
!  1   PATH TO PCP ANALYSIS FILE
!  2   PATH TO PCP OBS FILE
!  
!  3   MODEL NAME, SEE GETARCH FOR PROPER SPELLING AND PATH TO ARCHIVE
!  4   GRID NUMBER TO PULL FROM FCSTS, -1 MEANS USE THE FIRST ONE FOUND
!  5   NUMBER OF CYCLES AVAILABLE=N  (ex, 1 for ecmwf, possibly 4 for avn)
!  5+1  CYCLE #1 (eg, 0)
!  5+2  CYCLE #1 (eg, 12)
! ....
!  5+N  CYCLE #N
!  6+N OUTPUT FREQUENCY IN HOURS (ex, 3 for meso, 12 for eta, 24 for ecmwf)
!  7+N FORECAST DURATIONIN HOURS (ex, 36 (not 33) for meso, 72 for ecmwf)
!  ...
!  ...REPEAT LINES 2-7+N FOR ALL MODELS YOU WANT TO VERIFY
!  ...
! LAST  'done'
!
! USAGE:
!
!   INPUT FILE:
!     
!     UNIT 05 -    : CONTROL INPUT FOR RUNNING THE CODE
!     UNIT 11 -    : PRECIP ANALYSIS IN GRIB2 
!     UNIT 13 -    : REGIONAL MASKS FOR THIS GRID IN BINARY
!     UNIT 17 -    : MODEL INFO (READ IN GRID NUM, NUM OF START TIMES
!                    MODEL START TIME CYCLES, OUTPUT FREQUENCY, FORECAST
!                    DURATION, ETC.)in ASCII
!     UNIT 21 -    : PRECIP FORECAST IN GRIB2
!     UNIT 31 -    : OBS PRECIP ANALYSIS (CCPA DATA) IN GRIB2
!
!   OUTPUT FILE: 
!     UNIT 82 -    : STATS OUTPUT IN ASCII
!
! PROGRAMS CALLED:
!   
!   BAOPENR          GRIB I/O
!   BACLOSE          GRIB I/O
!   GETGB2           GRIB2 READER
!   PUTGB2           GRIB2 WRITER
!   GF_FREE          FREE UP MEMORY FOR GRIB2 
!   INIT_PARM        DEFINE GRID DEFINITION AND PRODUCT DEFINITION
!   PRINTINFR        PRINT GRIB2 DATA INFORMATION
!   VRFY             PERFORM PRECIP VERIFICATION
!
! ATTRIBUTES:
!   LANGUAGE: FORTRAN 90
!
!$$$

      use grib_mod
      use params
 
      implicit none

      integer numreg,numthr
      parameter(numreg=12,numthr=9) 

      integer ipopt(20)
      integer total(numreg)
      integer icyc(8),mnth(12)
      integer lumask,mdlinf,lstout,lcmask,lctmpd,lpgb,lpoi,logb
      integer fmrf,iret,ierrs,ier11,ier21,ier31,maxgrd,igrid,ksthr
      integer ivyr,ivmn,ngrid,nstart,n,ifreq,ifdur,kdat,jsize,kk
      integer inumf,ifreq2,ktime,ntime,kn,ifhr,ifhr1
      integer iacc,ivda,ivhr,ismn,isyr,isda,ishr
      integer jacc,jvyr,jvmn,jvda,jvhr,igmdl,igridf,incomplete

      integer :: igds(5)=(/0,0,0,0,0/)
      integer :: kpds(200),kgds(200),kens(200),kprob(2)

      integer ipd1,ipd2,ipd10,ipd11,ipd12
      integer jskp,jdisc,jpdtn,jgdtn,idisc,ipdtn,igdtn
      integer,dimension(200) :: jids,jpdt,jgdt,iids,ipdt,igdt
      common /param/jskp,jdisc,jids,jpdtn,jpdt,jgdtn,jgdt

      type(gribfield) :: gfld,gfldo
      integer :: currlen=0
      logical :: unpack=.true.
      logical :: expand=.false.
      logical :: first=.true.
! VAIABLE: APCP

      data ipd1 /1/
      data ipd2 /8/
      data ipd10/1/
      data ipd11/0/
      data ipd12/0/

      real,allocatable :: fgrid(:),fci(:),ana(:),smask(:)
      integer,allocatable :: maskreg(:)
      logical*1,allocatable :: lfci(:),lana(:)

      real thresh(numthr),thresh2(numthr)

      character gdso(400),fname*255,pname*255, fnamei*255,mdlnam*10
      character ocyc(4)*4,cycle*4
      character datestr*15,month(12)*3,mdlverf*10
      character datcmd*18,fname2*255,fname2i*255
      character*255 cpgba,cpgbf,pcpda,cmask,dmask,ctmpd
      character*255 opgbf
      character fmask(numreg)*4 

      data thresh/0.2,1.,2.,3.2,5.,7.,10.,15.,25./
      data total/263,325,598,215,311,404,209,188,121,88,245,378/
!      data total/244,322,596,215,308,403,209,188,115,88,245,356/
!     data thresh/0.2,1.,2.,5.,10.,15.,25.,35.,50./
!     data thresh/.1,.25,1.,2.5,5.,10.,20.,25.,30.,40.,50.,75./
      data thresh2/0.01,0.10,0.25,0.50,0.75,1.0,1.5,2.0,3.0/
      data mnth/31,28,31,30,31,30,31,31,30,31,30,31/
      data month/'jan','feb','mar','apr','may','jun','jul','aug','sep',&
                 'oct','nov','dec'/
      data ocyc/'t00z','t06z','t12z','t18z'/
!
!  ASSIGN THE UNITS
      lumask = 13
      mdlinf = 17
      lstout = 82
!
!  SET UP READING CART DATA FORMAT
 80   format(a255)
 88   format(a10)
 98   format(a40)
 8810 format(8a10)

!
!  ASSIGN AND OPEN STATS OUTPUT FILE 
      open (unit=lstout,file='stat.out',form='formatted')
!
!  READ IN MODEL INFO FILE NAME AND OPENED
      read   (5,80) fname
      write  (6,*) 'MODEL  INFORMATION FILE: ',fname(1:40)
      close  (mdlinf)
      open   (unit=mdlinf,file=fname,form='formatted')
 99   rewind (mdlinf)

!
!  READ IN CONUS and US REGIONAL DATA FILE                   
      read   (5,80,end=9000) cmask 
      write  (6,*) 'CON US AND REGIONAL MASK: ',cmask(1:80) 
      lcmask=len_trim(cmask)

!
!  READ IN FOR TEMP DIRECTORY                                
      read   (5,80,end=9000) ctmpd 
      write  (6,*) 'FOR TEMP DIRECTORY: ',ctmpd(1:50) 
      lctmpd=len_trim(ctmpd)

!
!  READ IN GRIB ANALYSIS PRECIPITATION FILE NAME AND OPENED
      read   (5,80,end=9000) cpgba  
      write  (6,*) 'GRIB PRECIPITATION FILE: ',cpgba(1:40) 
      lpgb=len_trim(cpgba)
      cycle=cpgba(lpgb-3:lpgb+1)
      write  (6,*) 'Running Cycle:  ',cycle 
      call baopenr(11,cpgba(1:lpgb),ier11)
      ierrs = ier11 
      if (ierrs.ne.0) then
       write(6,*) 'GRIB:BAOPEN ERR FOR DATA ',cpgba                      
       write(6,*) 'PLEASE CHECK DATA AVAILABLE OR NOT !!!'        
       goto 9000 
      endif

!
!  READ IN OBSERVATION PRECIPITATION DATA FILE NAME
      read   (5,80,end=9000)  pcpda
      write  (6,*) 'OBS  PRECIPITATION FILE: ',pcpda(1:40)
      lpoi=len_trim(pcpda)

!
!  READ IN MRF FACTOR FOR BIAS CORECTION ( Default:1.0 )
      read   (5,*) fmrf
      write  (6,*) 'MRF FACTER IS ',fmrf
!
!  READ IN PRECIP ANALYSIS AND FORECAST ( GRIB FORMAT )
!  Find GRIB MESSAGE

      iids=-9999;ipdt=-9999; igdt=-9999
      idisc=-1;  ipdtn=-1;   igdtn=-1
      call init_parm(ipdtn,ipdt,igdtn,igdt,idisc,iids)
      call getgb2(11,0,jskp,jdisc,jids,jpdtn,jpdt,jgdtn,jgdt,&
                  unpack,jskp,gfld,iret)
!      call gf_free(gfld)
      maxgrd=gfld%ngrdpts
      
      print *, 'maxgrd= ', maxgrd
     allocate (fgrid(maxgrd),fci(maxgrd),ana(maxgrd))
     allocate (lfci(maxgrd),lana(maxgrd))
     allocate (smask(maxgrd),maskreg(maxgrd))

         !
         !   Construct GDS
         !
         igds(1)=gfld%griddef
         igds(2)=gfld%ngrdpts
         igds(3)=gfld%numoct_opt
         igds(4)=gfld%interp_opt
         igds(5)=gfld%igdtnum
         if ( .NOT. associated(gfld%list_opt) )&
                 allocate(gfld%list_opt(1))
         call gdt2gds(igds,gfld%igdtmpl,gfld%num_opt,gfld%list_opt,&
                     kgds,igrid,iret)
         if (iret.ne.0) then
           print *,'cnv21: could not create gds'
         endif
         print *,' SAGT: NCEP GRID: ',igrid




! READ AND PROCESS VARIABLE OF INPUT DATA

      iids=-9999;ipdt=-9999; igdt=-9999
      idisc=-1;  ipdtn=-1;   igdtn=-1

      ipdt(1)=ipd1
      ipdt(2)=ipd2
      ipdt(10)=ipd10
      ipdt(11)=ipd11
      ipdt(12)=ipd12

      ipdtn=-1; igdtn=-1
      call init_parm(ipdtn,ipdt,igdtn,igdt,idisc,iids)
      call getgb2(11,0,jskp,jdisc,jids,jpdtn,jpdt,jgdtn,jgdt,&
                  unpack,jskp,gfld,iret)
      if (iret.eq.0) then
       fgrid(1:maxgrd) = gfld%fld(1:maxgrd)
!       call printinfr(gfld,1)
      ksthr = gfld%idsect(9)
      else
       write(6,*) 'GETGB PROBLEM FOR ANALYSIS : IRET=',iret
       goto 9000
      endif
!
!  READ IN REGIONAL MASKS FOR THIS GRID
       open(unit=lumask,file=cmask,form='unformatted')
       read(lumask) smask
       close(lumask)

       jsize = maxgrd
       do kk=1,jsize
        maskreg(kk)=nint(smask(kk))
       enddo

!
!  SET UP DATES FOR VERIFICATION VALID TIME
!      write (6,*) 'YEAR MN DY HR  =', (gfld%idsect(i),i=6,9)
      write (6,*)  'gfld%ipdtmpl(9)=',gfld%ipdtmpl(9),&
                   'gfld%idsect(9)=', gfld%idsect(9)
      iacc = gfld%ipdtmpl(30)
      ivyr = gfld%idsect(6)
      ivmn = gfld%idsect(7)
      if (mod(ivyr,100).ne.0.and.mod(ivyr,4).eq.0) mnth(2)=29
      if (mod(ivyr,400).eq.0) mnth(2)=29
      ivda = gfld%idsect(8) - 1
      ivhr = gfld%idsect(9) + gfld%ipdtmpl(30)
      do while (ivhr.gt.23)
      ivda = ivda + 1 
      ivhr = ivhr - 24
      enddo
      if (ivda.gt.mnth(ivmn)) then
       ivda = ivda - mnth (ivmn)
       ivmn = ivmn + 1
       endif 
       if (ivmn.gt.12) then
       ivmn = 1
       ivyr = ivyr + 1
       endif
!       write(6,*) 'VERIFICATION DATE: ',ivyr,ivmn,ivda,ivhr 
       call gf_free(gfld)
       call baclose(11,ier11)
!
!  MAIN LOOP, MAIN LOOP, MAIN LOOP
!  LOOP THROUGH MODELS TO VERIFY
!
!  READ MODEL NAME  
!
      read(mdlinf,88,end=99) mdlnam
      do while (mdlnam.ne.'done      ')
!CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
!      READ IN GRID NUM          - NGRID        C
!      NUM OF START TIMES        - NSTART       C
!      MODEL START TIME CYCLES   - ICYC         C
!      OUTPUT FREQUENCY          - IFREQ        C
!      FORECAST DURATION         - IFDUR        C
!CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
       read(mdlinf,*) ngrid
       read(mdlinf,*) nstart
       do n=1,nstart
        read(mdlinf,*) icyc(n)
        write(6,*) 'ICYC(N): ',icyc(n)
       enddo
       read(mdlinf,*) ifreq
       read(mdlinf,*) ifdur
       write(6,*) 'MDLNAM: ', mdlnam
       write(6,*) 'NGRID: ', ngrid
       write(6,*) 'NSTART: ', nstart
       write(6,*) 'IFREQ: ', ifreq
       write(6,*) 'IFDUR: ', ifdur
!
       kdat = index(mdlnam,' ') -1
       if (kdat.le.0) kdat = len(mdlnam)

!  SET UP DATES FOR FORECAST START TIME, GIVEN VALID TIME
!
       inumf  = iacc/ifreq
       ifreq2 = ifreq
!
!  GET THE FORECASTS THAT ARE VALID AT THE ANALYSIS DATE/TIME
!  AND COVER THE SAME ACCUMULATION PERIOD AS THE ANALYSIS
!
       do ktime=0, ifdur-6,ifreq2
        ismn=ivmn
        isyr=ivyr
       if (cycle.eq.'t00z') then
        isda=ivda+1
        ishr=ivhr-ktime
       elseif (cycle.eq.'t12z') then
        isda=ivda
        ishr=ivhr-ktime
       else
        isda=ivda+1
        ishr=ivhr-ktime-12
       endif
        do while (ishr.lt.0)
         isda=isda-1
         ishr=ishr+24
        enddo
        do while (isda.lt.1)
         ismn=ismn-1
         do while (ismn.lt.1)
          isyr=isyr-1
          ismn=ismn+12
         enddo
         isda=isda+mnth(ismn)
        enddo

!  LOOP OVER FORECAST START CYCLEs
!
       do n=1,nstart
         if (ishr.eq.icyc(n)) then
!
! LOOP OVER THE NUMBER OF FORECASTS WE NEED TO GET AN IACC H ACCUM
!
          do kn=1,inumf
!           ifhr=ktime + ivhr - ksthr - (kn-1)*ifreq
           ifhr=ktime + 6
           ifhr1=ifhr - ifreq
           if (mdlnam.eq.'ecmwf     ') then
            ifhr1=ifhr
            ifhr=0
           endif

! MODIFIED BY YUEJIAN ZHU (12/14/98)
!           if (ifhr1.lt.100.and.ifhr.lt.100) then
!           write (datcmd,120) mod(isyr,100),ismn,isda,ishr,ifhr1,ifhr
!            write (datcmd,120) isyr,ismn,isda,ksthr,ifhr1,ifhr
!           elseif (ifhr1.lt.100.and.ifhr.ge.100) then
!           write (datcmd,121) mod(isyr,100),ismn,isda,ishr,ifhr1,ifhr
!           write (datcmd,121) isyr,ismn,isda,ishr,ifhr1,ifhr
!            write (datcmd,121) isyr,ismn,isda,ksthr,ifhr1,ifhr
!           else
!           write (datcmd,122) mod(isyr,100),ismn,isda,ishr,ifhr1,ifhr
!           write (datcmd,122) isyr,ismn,isda,ishr,ifhr1,ifhr
            write (datcmd,122) isyr,ismn,isda,ksthr,ifhr1,ifhr
!           endif
!           if ((mdlnam.eq.'meso      ').and.(kn.lt.inumf.or.ishr.eq.0)) then
!            write (datcmd,120) mod(isyr,100),ismn,isda,ishr+3,ifhr1-3,ifhr-3
!           endif
! 120       format(i4.4,3i2.2,'_',i2.2,'_',i2.2)
! 121       format(i4.4,3i2.2,'_',i2.2,'_',i3.3)
 122       format(i4.4,3i2.2,'_',i3.3,'_',i3.3)

           cpgbf = ctmpd(1:lctmpd) // '/' //mdlnam(1:kdat) // '_' // datcmd         
!
!        CALL FUNCTION STAT TO FIND NUMBER OF BYTES IN FILE
!
        write  (6,*) '=============================================='
           write  (6,*) 'FORECAST DATA NAME: ',cpgbf(1:80)
           lpgb=len_trim(cpgbf)
           call baopenr(21,cpgbf(1:lpgb),ier21)
           ierrs = ier21 
           if (ierrs.ne.0) then
            write(6,*) 'GRIB:BAOPEN ERR FOR DATA ',cpgbf
            write(6,*) 'PLEASE CHECK DATA AVAILABLE OR NOT'
            goto 9100
           endif
!
!  READ IN PRECIP FORECAST, AND SUM UP IF NEEDED
      iids=-9999;ipdt=-9999; igdt=-9999
      idisc=-1;  ipdtn=-1;   igdtn=-1

      ipdt(1)=ipd1
      ipdt(2)=ipd2
      ipdt(10)=ipd10
      ipdt(11)=ipd11
      ipdt(12)=ipd12

      ipdtn=11; igdtn=-1
      call init_parm(ipdtn,ipdt,igdtn,igdt,idisc,iids)
      call getgb2(21,0,jskp,jdisc,jids,jpdtn,jpdt,jgdtn,jgdt,&
                  unpack,jskp,gfldo,iret)
      if (iret.eq.0) then
       fci(1:maxgrd) = gfldo%fld(1:maxgrd) 
!       lfci(1:maxgrd) = gfldo%bmap(1:maxgrd)
       call printinfr(gfldo,1)
      else
       write(6,*) 'GETGB PROBLEM FOR ANALYSIS : IRET=',iret
       goto 9000
      endif

!  SET UP DATES FOR FORECAST STARTED TIME
      write (6,*)  'gfldo%ipdtmpl(9)=', gfldo%ipdtmpl(9),&
                   'gfldo%idsect(9)=', gfldo%idsect(9)
      isyr = gfldo%idsect(6)
      ismn = gfldo%idsect(7)
      if (mod(isyr,100).ne.0.and.mod(isyr,4).eq.0) mnth(2)=29
      if (mod(isyr,400).eq.0) mnth(2)=29
      isda = gfldo%idsect(8)
      ishr = gfldo%idsect(9)
      do while (ishr.gt.23)
       isda = isda + 1
       ishr = ishr - 24
      enddo
      if (isda.gt.mnth(ismn)) then
       isda = isda-mnth(ismn)
       ismn = ismn + 1
      endif
      if (ismn.gt.12) then
       ismn = 1
       isyr = isyr + 1
      endif
        write(6,*) 'STARTED      TIME: ',isyr,ismn,isda,ishr
       call gf_free(gfldo)
       call baclose(21,ier21)
          enddo
!
       endif
         enddo

!      READ IN PRECIP OBS
       ntime=ktime/ifreq+1
       if (cycle.eq.'t00z') then
       if(mod(ntime,4).eq.1)       write(pname,868) ocyc(2)
       if(mod(ntime,4).eq.2)       write(pname,868) ocyc(3)
       if(mod(ntime,4).eq.3)       write(pname,868) ocyc(4)
       if(mod(ntime,4).eq.0)       write(pname,868) ocyc(1)
       endif
       if (cycle.eq.'t06z') then
       if(mod(ntime,4).eq.1)       write(pname,868) ocyc(3)
       if(mod(ntime,4).eq.2)       write(pname,868) ocyc(4)
       if(mod(ntime,4).eq.3)       write(pname,868) ocyc(1)
       if(mod(ntime,4).eq.0)       write(pname,868) ocyc(2)
       endif
       if (cycle.eq.'t12z') then
       if(mod(ntime,4).eq.1)       write(pname,868) ocyc(4)
       if(mod(ntime,4).eq.2)       write(pname,868) ocyc(1)
       if(mod(ntime,4).eq.3)       write(pname,868) ocyc(2)
       if(mod(ntime,4).eq.0)       write(pname,868) ocyc(3)
       endif
       if (cycle.eq.'t18z') then
       if(mod(ntime,4).eq.1)       write(pname,868) ocyc(1)
       if(mod(ntime,4).eq.2)       write(pname,868) ocyc(2)
       if(mod(ntime,4).eq.3)       write(pname,868) ocyc(3)
       if(mod(ntime,4).eq.0)       write(pname,868) ocyc(4)
       endif
868    format (a4,'.06h')
       opgbf=ctmpd(1:lctmpd) // '/' //pcpda(1:lpoi) // '.' // pname(1:8)&
             //'.0p5.conus.gb2'

       write (6,*) 'OBS PRECIP DATA NAME: ', opgbf(1:80)

           logb = len_trim(opgbf)
           call baopenr(31,opgbf(1:logb),ier31)
           ierrs = ier31
           if (ierrs.ne.0) then
            write(6,*) 'GRIB:BAOPEN ERR FOR DATA ',opgbf
            write(6,*) 'PLEASE CHECK DATA AVAILABLE OR NOT'
           goto 9100
           endif

!
!  READ IN OBS PRECIP ANALYSIS (CCPA DATA)

      iids=-9999;ipdt=-9999; igdt=-9999
      idisc=-1;  ipdtn=-1;   igdtn=-1

      ipdt(1)=ipd1
      ipdt(2)=ipd2
      ipdt(10)=ipd10
      ipdt(11)=ipd11
      ipdt(12)=ipd12

      ipdtn=8; igdtn=-1
      call init_parm(ipdtn,ipdt,igdtn,igdt,idisc,iids)
      call getgb2(31,0,jskp,jdisc,jids,jpdtn,jpdt,jgdtn,jgdt,&
                  unpack,jskp,gfldo,iret)
      if (iret.eq.0) then
       ana(1:maxgrd) = gfldo%fld(1:maxgrd)
       lana(1:maxgrd) = gfldo%bmap(1:maxgrd)
       call printinfr(gfldo,1)
      else
       write(6,*) 'GETGB PROBLEM FOR ANALYSIS : IRET=',iret
       goto 9000
      endif
!  SET UP DATES FOR VERIFICATION VALID TIME
      write (6,*)  'gfldo%ipdtmpl(9)=',gfldo%ipdtmpl(9),&
                   'gfldo%idsect(9)=', gfldo%idsect(9)
      jacc = gfldo%ipdtmpl(9) + 6
      jvyr = gfldo%idsect(6)
      jvmn = gfldo%idsect(7)
      if (mod(jvyr,100).ne.0.and.mod(jvyr,4).eq.0) mnth(2)=29
      if (mod(ivyr,400).eq.0) mnth(2)=29
      jvda = gfldo%idsect(8)
      jvhr = jacc + gfldo%idsect(9)
      do while (jvhr.gt.23)
       jvda = jvda + 1
       jvhr = jvhr - 24
      enddo
      if (jvda.gt.mnth(jvmn)) then
       jvda = jvda - mnth(jvmn)
       jvmn = jvmn + 1
      endif
      if (jvmn.gt.12) then
       jvmn = 1
       jvyr = jvyr + 1
      endif
      write(6,*) 'VERIFICATION DATE: ',jvyr,jvmn,jvda,jvhr
       call gf_free(gfldo)
       call baclose(31,ier31)
!  MAIN VERIFICATION PROGRAM CALL
!
      igmdl = igrid
      igridf = igrid
      call verf(fci,ana,lfci,lana,maskreg,maxgrd,numreg,numthr,thresh,&
                1,igridf,igmdl,1,fmask,isyr,ismn,isda,ishr,&
                jvyr,jvmn,jvda,jvhr,ktime,iacc,mdlnam,lstout,&
                total,incomplete)
      write(6,*) 'NUMBER OF CENTERS WITH INCOMPLETE OBS DATA: ',incomplete
      if (incomplete.gt.0) then
      write(6,*) 'MISSING OBS DATA VALUES, LEAVING THE PROGRAM!!!'
      go to  9000
      endif
9100   continue

       enddo    ! do ktime=iacc,ifdur,ifreq2
!
!  READ NEXT MODEL NAME  
!
      read(mdlinf,88,end=99) mdlnam
      enddo    ! do while (mdlnam.ne.'done      ')

       deallocate (fgrid,fci,ana)
       deallocate (lfci,lana)
       deallocate (smask,maskreg)

 9000 stop
      end





