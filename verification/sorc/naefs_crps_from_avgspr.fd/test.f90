
integer     ij,i,ii,k,odate,idate,im,imem,n,irt,nfhrs,itemp
parameter   (im=50)
!real,       allocatable :: abc(:)
real prob

!allocate(abc(im))

prob_down=0.01  

! im=30, ii=1, prob=0.015
!        ii=2, prob=0.048

do ii=1,im
  prob=prob_down+(ii-1)/real(im)
  write(6,'(f10.2)') prob
enddo

!print *, ' fvalue=',fst

!abc=-999
!do ij=1,im
!  abc(ij)=2
!enddo
!
!write(6,*) abc
!write(6,*) abc(6)

stop
end
