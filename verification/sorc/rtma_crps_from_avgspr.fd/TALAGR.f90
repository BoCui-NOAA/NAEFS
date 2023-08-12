subroutine talagr(n,m,en,ve,ave,xmed,sprd,rmsa)
!CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
!                                                                            C
!     USAGE: TO CALCULATE TALAGRAND HISTOGRAM FOR ENSEMBLE FORECASTS         C
!            ON ONE GRID POINT                                               C
!     CODE : F77 on IBMSP --- Yuejian Zhu (07/26/2004)                       C
!                                                                            C
!     INPUT: n    number of ensember forecasts                               C
!            m    number of ensember forecasts to be verify                  C
!            en   vector of n containning forecasts at gridpoint             C
!            ve   value of verification at gridpoint ( analysis )            C
!                                                                            C
!     OUTPUT: ital vector of n+1 containing zeroes except 1 for              C
!                  bin containing truth                                      C
!             irel vector of n containning the relative position             C
!                  between analysis and forecasts                            C
!             ave  average of ensemble fcsts                                 C
!             xmed median of ensemble fcsts                                  C
!             sprd spread of ensemble fcsts                                  C
!             rmsa root mean square error for analysis and mean (ave)        C
!                                                                            C
!CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
!--------+----------+----------+----------+----------+----------+----------+--
implicit none

integer   n,m,jjj,im,iii,i
real      en(n),em(m),enb(m,2),ena(m,3)
real      ave,xmed,sprd,rmsa,ve
integer   ital(m+1),irel(m)

irel = 0
ital = 0
ave  = 0.0      
xmed = 0.0             
sprd = 0.0        
rmsa = 0.0        
do i = 1, m
  if (en(i).eq.-9999.9999) print*, ' Data Wrong, Return '
  if (en(i).eq.-9999.9999) goto 999
  em(i) = en(i)
enddo
      
do i=1,m
  enb(i,1)=i
  enb(i,2)=em(i)
  ena(i,1)=i
  ena(i,2)=em(i)
  ital(i)=0
! ----
! calculate the average
! ----
  ave=ave+em(i)/float(m)
enddo
! ----
! to calculate the spread
! ----
do i=1,m
  sprd=sprd+(em(i)-ave)*(em(i)-ave)
enddo
! ----
! to calculate the root mean square error for analysis and ensemble ave
! ----
rmsa=(ve-ave)*(ve-ave)
! ----

999 continue

return
end

