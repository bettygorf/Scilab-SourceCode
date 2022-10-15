C/MEMBR ADD NAME=SYBAD,SSI=0
        subroutine sybad(n,m,a,na,b,nb,c,nc,u,v,eps,wrk,mode,ierr)
c
c
c!purpose
c
c        to solve the double precision matrix equation
c               a*x*b - x = c
c
c! calling sequence
c       subroutine sybad(n,m,a,na,b,nb,c,nc,u,v,eps,wrk,mode,ierr)
c
c        integer n,na,mode,ierr
c        double precision a(na,n),c(nc,m),u(na,n),wrk(max(n,m))
c        double precision b(nb,m),v(nb,m)
c
c arguments in
c
c       n        integer
c                -the dimension of a.
c
c       m        imteger
c                -the dimension of b.
c
c       a        double precision(n,n)
c                -the coefficient matrix  a  of the equation. on
c                exit, a  is overwritten, but see  comments  below.
c
c       na       integer
c                -the declared first dimension of  a and  u
c
c       b        double precision(m,m)
c                -the coefficient matrix  b  of the equation. on
c                exit, b  is overwritten, but see  comments  below.
c
c       nb       integer
c                -the declared first dimension of  b and  v
c
c       c        double precision(n,n)
c                -the coefficient matrix  c  of the equation.
c
c       nc       integer
c                -the declared first dimension of  c
c
c       mode     integer
c
c                - mode = 0  if  a  has not already been reduced to
c                                upper triangular form
c
c                - mode = 1  if  a  has been reduced to triangular form
c                         by (e.g.) a previous call to this routine
c
c arguments out
c
c       a        double precision(n,n)
c                -on exit, a  contains the transformed upper
c                triangular form of a.   (see comments below)
c
c       b        double precision(n,n)
c                -on exit, b  contains the transformed lower
c                triangular form of b.   (see comments below)
c
c       c        double precision(n,m)
c                -the solution matrix
c
c       u        double precision(n,n)
c                - u  contains the orthogonal matrix which was
c                used to reduce  a  to upper triangular form
c
c       v        double precision(m,m)
c                - v  contains the orthogonal matrix which was
c                used to reduce  b  to lower triangular form
c
c       ierr    integer
c               -error indicator
c
c               ierr = 0        successful return
c
c               ierr = 1        a  has reciprocal eigenvalues
c
c               ierr = 2        a  cannot be reduced to triangular form
c
c working space
c
c        wrk        double precision (max(n,m))
c
c!originator
c
c     Serge Steer Inria 1987
c
c!comments
c                note that the contents of  a  are overwritten by
c                this routine by the triangularised form of  a.
c                if required, a  can be re-formed from the matrix
c                product u' * a * u. this is not done by the routine
c                because the factored form of  a  may be required by
c                further routines.
c
c!method
c
c        this routine is a modification of the subroutine d2lyb,
c        written and discussed by a.y.barraud (see reference).
c
c!reference
c
c        a.y.barraud
c        "a numerical algorithm to solve  a' * x * a  -  x  =  q  ",
c        ieee trans. automat. control, vol. ac-22, 1977, pp 883-885
c
c!auxiliary routines
c
c       ddot (blas)
c       orthes,ortran (eispack)
c       sgefa,sgesl   (linpack)
c
c!
c
        integer n,na,mode,ierr
        double precision a(na,n),c(nc,m),u(na,n),wrk(*)
      double precision b(nb,m),v(nb,m)
c
c        internal variables:
c
        integer i,j
        double precision ddot,t,eps
c
      if (mode .eq. 1) go to 30
      do 10 i=1,n
      do 10 j=1,i
      t=a(i,j)
      a(i,j)=a(j,i)
      a(j,i)=t
   10 continue
      call orthes(na,n,1,n,a,wrk)
      call ortran(na,n,1,n,a,wrk,u)
      call hqror2(na,n,1,n,a,t,t,u,ierr,11)
      if (ierr .ne. 0) go to 140
      call orthes(nb,m,1,m,b,wrk)
      call ortran(nb,m,1,m,b,wrk,v)
      call hqror2(nb,m,1,m,b,t,t,v,ierr,11)
      if (ierr .ne. 0) go to 140
c
   30   do 40 i = 1, n
                do 35 j = 1, m
                       wrk(j)=ddot(m,c(i,1),nc,v(1,j),1)
  35            continue
                do 40 j = 1, m
                c(i,j) = wrk(j)
  40    continue
        do 60 j = 1, m
                do 55 i = 1, n
                       wrk(i)=ddot(n,u(1,i),1,c(1,j),1)
  55            continue
                do 60 i = 1, n
                        c(i,j) = wrk(i)
  60    continue
c
        call sydsr(n,m,a,na,b,nb,c,nc,ierr)
        if (ierr .ne. 0) return
c
        do 100 i = 1, n
                do 95 j = 1, m
                       wrk(j)=ddot(m,c(i,1),nc,v(j,1),nb)
  95            continue
                do 100 j = 1, m
                        c(i,j) = wrk(j)
 100    continue
        do 120 j = 1, m
                do 115 i = 1, n
                       wrk(i)=ddot(n,u(i,1),na,c(1,j),1)
 115            continue
                do 120 i = 1, n
                        c(i,j) = wrk(i)
 120    continue
c
        go to 150
 140    ierr = 2
 150    return
        end
