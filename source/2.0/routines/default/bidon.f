      subroutine bidon(a,ia,b,ib,c,ic,d,w,nw)
c  test routine for fort command 
c         (see interf.f is this directory)
c  inputs:  a,b and c
c  integer real double precision resp.
c  size ia,ib,ic resp.
c  outputs: a,b and c times 2
c  and d of same dimension as c with
c  d(k)=c(k)+k.
c  w is a working array of size nw
c!
       dimension a(*),b(*),c(*),d(*),w(nw)
       integer a
       real b
       double precision c,d,w
       do 1 k=1,ia
       a(k)=2*a(k)
    1  continue
       do 2 k=1,ib
       b(k)=2.0d+0*b(k)
   2   continue
       do 3 k=1,ic
       c(k)=2.0d+0*c(k)
    3  continue
       do 4 k=1,ic
       w(k)=dble(k)
       d(k)=w(k)+c(k)
   4   continue
       return
       end
