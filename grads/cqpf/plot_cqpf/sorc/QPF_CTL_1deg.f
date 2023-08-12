C--------+---------+---------+---------+---------+----------+---------+--
      program QPF_1deg
      parameter (ix=360,iy=181,im=1,ik=10,isize=100000)
      PARAMETER(ISTD=14)
      dimension fcst(ix*iy,im),fanl(ix*iy),data(ix*iy),f(ix*iy)
      DIMENSION RK(ISTD)
      dimension wght(ix*iy),dmask(ix*iy),mask(ix*iy)
      dimension ipds(25),igds(22),iens(5)
      dimension jpds(25),jgds(22),jens(5)
      dimension kpds(25),kgds(22),kens(5)
c     dimension kens2(im), kens3(im)
      DIMENSION XPROB(2),IMEMBR(80),IPROB(2),ICLUST(16)
      character*100 cf01,cf02,cf03,cf04,cf05
      character*3  cmon(12)
      character*3  cmdl

c      logical*1    lb(ix*iy)
      logical*1    cindex(ix,iy),lb(ix*iy)

      namelist/files/cf01,cf02,cf03,cf04,cf05                   
c      namelist/namin/ictl,nfhrs,ifd,isp,ilv,ilv2
c      namelist/namin/ictl,nfhrs,ifd,isp,ilv,ilv2,la1,la2,lo1,lo2
      namelist/namin/ictl,idate,nfhrs,ifd,isp,ilv,ilv2,la1,la2,lo1,lo2

      data cmon/'JAN','FEB','MAR','APR','MAY','JUN',
     .          'JUL','AUG','SEP','OCT','NOV','DEC'/

c      data kens2/1,3,3,3,3,3,3,3,3,3, 3, 3, 3, 3, 3,
c     .           3,3,3,3,3,3/
c      data kens3/2,1,2,3,4,5,6,7,8,9,10,11,12,13,14,
c     .           15,16,17,18,19,20/
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
c       print *, 'ifd,isp,ilv=',ifd,isp,ilv
       write(6,*) 'GRIB:BAOPEN ERR FOR DATA ',cf01  
       write(6,*) 'GRIB:BAOPEN ERR FOR DATA ',cf02
       write(6,*) 'GRIB:BAOPEN ERR FOR DATA ',cf03  
       write(6,*) 'GRIB:BAOPEN ERR FOR DATA ',cf04
       write(6,*) 'PLEASE CHECK DATA AVAILABLE OR NOT'
        stop
       endif
      write(*,886)
      do n = 1,1
       j    = 0
       jpds = -1
       jgds = -1
c       jpds(23) = 2
       jpds(5) = ifd
       jpds(6) = isp
       jpds(7) = ilv
       call getgb(21,0,ix*iy,j,jpds,jgds,kf,k,kpds,kgds,lb,data,iret)
       if (iret.eq.0) then
        call grange(kf,lb,data,dmin,dmax)
        write(*,888) k,(kpds(i),i=5,11),kpds(14),
     *               kf,dmax,dmin
        do ij = 1, ix*iy
         fcst(ij,n) = data(ij)
        enddo
       else
        print *, 'iret=',iret
        stop
       endif
       call getgb(22,0,ix*iy,j,jpds,jgds,kf,k,kpds,kgds,lb,data,iret)
       if (iret.eq.0) then
        call grange(kf,lb,data,dmin,dmax)
        write(*,888) k,(kpds(i),i=5,11),kpds(14),
     *               kf,dmax,dmin
        do ij = 1, ix*iy
         fcst(ij,n) = fcst(ij,n) + data(ij)
        enddo
       else
        print *, 'iret=',iret
        stop
       endif
       call getgb(23,0,ix*iy,j,jpds,jgds,kf,k,kpds,kgds,lb,data,iret)
       if (iret.eq.0) then
        call grange(kf,lb,data,dmin,dmax)
        write(*,888) k,(kpds(i),i=5,11),kpds(14),
     *               kf,dmax,dmin
        do ij = 1, ix*iy
         fcst(ij,n) = fcst(ij,n) + data(ij)
        enddo
       else
        print *, 'iret=',iret
        stop
       endif
       call getgb(24,0,ix*iy,j,jpds,jgds,kf,k,kpds,kgds,lb,data,iret)
       if (iret.eq.0) then
        call grange(kf,lb,data,dmin,dmax)
        write(*,888) k,(kpds(i),i=5,11),kpds(14),
     *               kf,dmax,dmin
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
       do jj = 1, 1
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
        do ii = 1,  ix*iy
           data(ii) = fcst(ii,jj)
c           if (data(ii).lt.0.0) print *, ii, data(ii)
           if (data(ii).lt.0.0) data(ii)=0.0
        enddo

        call putgb(50,ix*iy,ipds,igds,lb,data,iret)
      
       enddo      


       call baclose(21,iret21)
       call baclose(22,iret22)
       call baclose(23,iret23)
       call baclose(24,iret24)
       call baclose(50,iret50)

  886 format('Irec pds5 pds6 pds7 pds8 pds9 pd10 pd11 pd14',
     .       ' e2 e3  ndata  Maximun  Minimum')
c 888   FORMAT (i4,i3,2i5,4i3,i4,i4,5i4,i4,i7,2g12.4)       
  888 format (i4,8i5,6x,i7,2f9.2)


      stop
      end
