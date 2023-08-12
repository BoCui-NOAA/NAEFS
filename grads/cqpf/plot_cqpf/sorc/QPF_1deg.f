C--------+---------+---------+---------+---------+----------+---------+--
      program QPF_1deg
      parameter (ix=360,iy=181,im=21,ik=10,isize=100000)
      PARAMETER(ISTD=14)
      dimension fcst(ix*iy,im),fanl(ix*iy),data(ix*iy),f(ix*iy)
      DIMENSION RK(ISTD)
      dimension wght(ix*iy),dmask(ix*iy),mask(ix*iy)
      dimension ipds(25),igds(22),iens(5)
      dimension jpds(25),jgds(22),jens(5)
      dimension kpds(25),kgds(22),kens(5)
      dimension kens2(im), kens3(im)
      DIMENSION XPROB(2),IMEMBR(80),IPROB(2),ICLUST(16)
      character*99 cf01,cf02,cf03,cf04,cf05,cf06    
      character*3  cmon(12)
      character*3  cmdl

c      logical*1    lb(ix*iy)
      logical*1    cindex(ix,iy),lb(ix*iy)

      namelist/files/cf01,cf02,cf03,cf04,cf05,cf06                        
c      namelist/namin/ictl,nfhrs,ifd,isp,ilv,ilv2
c      namelist/namin/ictl,nfhrs,ifd,isp,ilv,ilv2,la1,la2,lo1,lo2
      namelist/namin/ictl,idate,nfhrs,ifd,isp,ilv,ilv2,la1,la2,lo1,lo2

      data cmon/'JAN','FEB','MAR','APR','MAY','JUN',
     .          'JUL','AUG','SEP','OCT','NOV','DEC'/

      data kens2/1,3,3,3,3,3,3,3,3,3, 3, 3, 3, 3, 3,
     .           3,3,3,3,3,3/
      data kens3/2,1,2,3,4,5,6,7,8,9,10,11,12,13,14,
     .           15,16,17,18,19,20/
      DATA RK/0.254,1,1.27,2.54,5,6.35,10,12.7,20,25.4,38.1,
     &        50.8,101.6,152.4/

c ----
c     job will be controled by read card
c ----

      read  (5,files,end=1000)
      write (6,files)
 1000 continue
      read  (5,namin,end=1020)
      write (6,namin)
 1020 continue

c ----
c     to set up verifying index
c ----
      cindex=.FALSE.
      do ny = la1, la2
       do nx = lo1, lo2
        cindex(nx,ny)=.TRUE.
       enddo
      enddo
    
c ----
c     to calculate the weight based on the latitudes
c ----
      do lat = 1, iy  
       do lon = 1, ix  
        ij = (lat - 1)*ix + lon
        wght(ij) = sin( (lat-1.0) * 1.0 * 3.1415926 / 180.0)
       enddo
      enddo

c ----
c     convert initial time + forecast time to verified time
c ----
      call iaddate(idate,nfhrs,jdate)

c ----
c     get ensemble forecasts of precipitation
c ----

      write(*,886)

       lpgb1=len_trim(cf01)
       lpgb2=len_trim(cf02)
       lpgb3=len_trim(cf03)
       lpgb4=len_trim(cf04)
       write(6,*) 'FORECAST DATA NAME: ',cf01(1:lpgb1)
       write(6,*) 'FORECAST DATA NAME: ',cf02(1:lpgb2)
       write(6,*) 'FORECAST DATA NAME: ',cf03(1:lpgb3)
       write(6,*) 'FORECAST DATA NAME: ',cf04(1:lpgb4)
       call baopenr(21,cf01(1:lpgb1),iret21)
       call baopenr(22,cf02(1:lpgb2),iret22)
       call baopenr(23,cf03(1:lpgb3),iret23)
       call baopenr(24,cf04(1:lpgb4),iret24)
       ierrs = iret21 + iret22 + iret23 + iret24 
       if (ierrs.ne.0) then
c      print *, 'ifd,isp,ilv=',ifd,isp,ilv
       write(6,*) 'GRIB:BAOPEN ERR FOR DATA ',cf01  
       write(6,*) 'GRIB:BAOPEN ERR FOR DATA ',cf02
       write(6,*) 'GRIB:BAOPEN ERR FOR DATA ',cf03  
       write(6,*) 'GRIB:BAOPEN ERR FOR DATA ',cf04
       write(6,*) 'PLEASE CHECK DATA AVAILABLE OR NOT'
        stop
       endif
      write(*,886)
      do n = 1,im
       j    = 0
       jpds = -1
       jgds = -1
       jens = -1
       jpds(23) = 2
       jpds(5) = ifd
c       jpds(6) = isp
c       jpds(7) = ilv
       jensem = 21
       jens(2) = kens2(n)
       jens(3) = kens3(n)

        call getgbe(21,0,ix*iy,j,jpds,jgds,jens,
     *              kf,k,kpds,kgds,kens,lb,data,iret)
       if (iret.eq.0) then
        call grange(kf,lb,data,dmin,dmax)
         write(*,888) k, (kpds(i),i=5,11),kpds(13),kpds(14),
     *             kpds(15),kpds(16),(kens(i),i=2,5),kf,dmax,dmin

        do ij = 1, ix*iy
         fcst(ij,n) = data(ij)
        enddo
       else
        print *, 'iret=',iret
        stop
       endif

       call getgbe(22,0,ix*iy,j,jpds,jgds,jens,
     *              kf,k,kpds,kgds,kens,lb,data,iret)
       if (iret.eq.0) then
        call grange(kf,lb,data,dmin,dmax)
         write(*,888) k, (kpds(i),i=5,11),kpds(13),kpds(14),
     *             kpds(15),kpds(16),(kens(i),i=2,5),kf,dmax,dmin

        do ij = 1, ix*iy
         fcst(ij,n) = fcst(ij,n) + data(ij)
        enddo
       else
        print *, 'iret=',iret
        stop
       endif

       call getgbe(23,0,ix*iy,j,jpds,jgds,jens,
     *              kf,k,kpds,kgds,kens,lb,data,iret)
       if (iret.eq.0) then
        call grange(kf,lb,data,dmin,dmax)
         write(*,888) k, (kpds(i),i=5,11),kpds(13),kpds(14),
     *             kpds(15),kpds(16),(kens(i),i=2,5),kf,dmax,dmin

        do ij = 1, ix*iy
         fcst(ij,n) = fcst(ij,n) + data(ij)
        enddo
       else
        print *, 'iret=',iret
        stop
       endif

       call getgbe(24,0,ix*iy,j,jpds,jgds,jens,
     *              kf,k,kpds,kgds,kens,lb,data,iret)
       if (iret.eq.0) then
        call grange(kf,lb,data,dmin,dmax)
         write(*,888) k, (kpds(i),i=5,11),kpds(13),kpds(14),
     *             kpds(15),kpds(16),(kens(i),i=2,5),kf,dmax,dmin

        do ij = 1, ix*iy
         fcst(ij,n) = fcst(ij,n) + data(ij)
        enddo
       else
        print *, 'iret=',iret
        stop
       endif

      enddo

!ccc
!ccc    write out the results
!ccc

       lpgb5=len_trim(cf05)
       write(6,*) 'FORECAST DATA NAME: ',cf05(1:lpgb5) 
       call baopen(50,cf05(1:lpgb5),iret50)
       do jj = 1, im
         DO II = 1, 25
          IPDS(II)=KPDS(II)
         ENDDO
         DO II = 1, 22
          IGDS(II)=KGDS(II)
         ENDDO
         if (nfhrs.le.252) then
         ipds(14)=nfhrs-24
         ipds(15)=nfhrs
         else
         ipds(14)=nfhrs/6-4
         ipds(15)=nfhrs/6
         endif         
         DO II = 1, 5 
          IENS(II)=KENS(II)
         ENDDO 
        IENSEM=21
        iens(2)  = kens2(jj)
        iens(3)  = kens3(jj)
        do ii = 1,  ix*iy
           data(ii) = fcst(ii,jj)
c           if (data(ii).lt.0.0) print *, ii, data(ii)
           if (data(ii).lt.0.0) data(ii)=0.0
        enddo

        call putgbe(50,ix*iy,ipds,igds,iens,lb,data,iret)
      
       enddo      


!ccc
!ccc    Step 2: calculate the PQPF
!ccc
       lpgb6=len_trim(cf06)
       write(6,*) 'FORECAST DATA NAME: ',cf06(1:lpgb6)
       call baopen(51,cf06(1:lpgb6),iret51)

       do k = 1, istd
        f   = 0.0
        do ii = 1, ix*iy
!ccccc to exclude GFS/AVN high resolution forecast
         do jj = 1, im
          if (fcst(ii,jj).ge.rk(k)) then
           f(ii) = f(ii) + 1.0
          endif
         enddo
         f(ii) = f(ii)*100.00/float(21)
         if (f(ii).ge.99.0) then
          f(ii) = 100.0
         endif
        enddo
        ipds(5)=191         !: OCT 9
        ipds(13)=11         !: Time unit = 6 hours
         if (nfhrs.le.252) then
         ipds(14)=nfhrs-24
         ipds(15)=nfhrs
         else
         ipds(14)=nfhrs/6-4
         ipds(15)=nfhrs/6
         endif
        ipds(14)=nfhrs/6-4
        ipds(15)=nfhrs/6
        iens(2)=5           !: OCT 42
        iens(3)=0           !: OCT 43
        iens(4)=0           !: OCT 44
        iprob(1)=61         !: OCT 46
        iprob(2)=2          !: OCT 47
        xprob(1)=0.0        !: OCT 48-51
        xprob(2)=rk(k)      !: OCT 52-55
        iclust(1)=im    !: OCT 61
        call putgbex(51,ix*iy,ipds,igds,iens,iprob,xprob,
     &               iclust,imembr,lb,f,iret)
       enddo
       call baclose(21,iret21)
       call baclose(22,iret22)
       call baclose(23,iret23)
       call baclose(24,iret24)
       call baclose(50,iret50)
       call baclose(51,iret51)

  886 format('Irec pds5 pds6 pds7 pds8 pds9 pd10 pd11 pd14',
     .       ' e2 e3  ndata  Maximun  Minimum')
 888   FORMAT (i4,i3,2i5,4i3,i4,i4,5i4,i4,i7,2g12.4)       


      stop
      end
