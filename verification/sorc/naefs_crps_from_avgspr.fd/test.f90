
integer     ij,i,ii,k,odate,idate,im,imem,n,irt,nfhrs,itemp
parameter   (im=5)
real,       allocatable :: abc(:)

allocate(abc(im))

abc=-999
do ij=1,im
  abc(ij)=2
enddo

write(6,*) abc
write(6,*) abc(6)

stop
end
