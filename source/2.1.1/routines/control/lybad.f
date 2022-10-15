        subroutine lybad(n,a,na,c,x,u,eps,wrk,mode,ierr)
c******************************************************************
c
c name                lybad
c
c        subroutine lybad(n,a,na,c,x,u,wrk,mode,ierr)
c
c        integer n,na,mode,ierr
c        double precision a(na,n),c(na,n),x(na,n),u(na,n),wrk(n)
c
c
c!purpose
c
c        to solve the double precision matrix equation
c               trans(a)*x*a - x = c
c        where  c  is symmetric, and  trans(a)  denotes
c        the transpose of  a.
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
c! calling sequence
c arguments in
c
c       n        integer
c                -the dimension of a.
c
c       a        double precision(n,n)
c                -the coefficient matrix  a  of the equation. on
c                exit, a  is overwritten, but see  comments  below.
c
c       c        double precision(n,n)
c                -the coefficient matrix  c  of the equation.
c
c       na       integer
c                -the declared first dimension of  a, c, x  and  u
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
c       x        double precision(n,n)
c                -the solution matrix
c
c       u        double precision(n,n)
c                - u  contains the orthogonal matrix which was
c                used to reduce  a  to upper triangular form
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
c        wrk        double precision(n)
c
c!origin: adapted from
c
c                control systems research group, dept eecs, kingston
c                polytechnic, penrhyn road, kingston-upon-thames, u.k.
c
c!comments
c                note that the contents of  a  are overwritten by
c                this routine by the triangularised form of  a.
c                if required, a  can be re-formed from the matrix
c                product u' * a * u. this is not done by the routine
c                because the factored form of  a  may be required by
c                further routines.
c
c!
c
        integer n,na,mode,ierr
        double precision a(na,n),c(na,n),x(na,n),u(na,n),wrk(n)
c
c        internal variables:
c
        integer i,j
        double precision ddot,t,eps
c
        if (mode .eq. 1) go to 10
      call orthes(na,n,1,n,a,wrk)
      call ortran(na,n,1,n,a,wrk,u)
      call hqror2(na,n,1,n,a,t,t,u,ierr,11)
        if (ierr .ne. 0) go to 140
c
  10    do 20 j = 1, n
                do 15 i = 1,n
                        x(i,j) = c(i,j)
  15            continue
                x(j,j) = x(j,j) * 0.50d+0
  20    continue
        do 40 i = 1, n
                do 35 j = 1, n
                       wrk(j)=ddot(n-i+1,x(i,i),na,u(i,j),1)
  35            continue
                do 40 j = 1, n
                x(i,j) = wrk(j)
  40    continue
        do 60 j = 1, n
                do 55 i = 1, n
                       wrk(i)=ddot(n,u(1,i),1,x(1,j),1)
  55            continue
                do 60 i = 1, n
                        x(i,j) = wrk(i)
  60    continue
        do 70 i = 1, n
                do 70 j = i, n
                        x(i,j) = x(i,j) + x(j,i)
                        x(j,i) = x(i,j)
  70    continue
        call lydsr(n,a,na,x,ierr)
        if (ierr .ne. 0) return
        do 80 i = 1, n
                x(i,i) = x(i,i) * 0.50d+0
  80    continue
        do 100 i = 1, n
                do 95 j = 1, n
                       wrk(j)=ddot(n-i+1,x(i,i),na,u(j,i),na)
  95            continue
                do 100 j = 1, n
                        x(i,j) = wrk(j)
 100    continue
        do 120 j = 1, n
                do 115 i = 1, n
                       wrk(i)=ddot(n,u(i,1),na,x(1,j),1)
 115            continue
                do 120 i = 1, n
                        x(i,j) = wrk(i)
 120    continue
        do 130 i = 1, n
                do 130 j = i, n
                        x(i,j) = x(i,j) + x(j,i)
                        x(j,i) = x(i,j)
 130    continue
c
        go to 150
 140    ierr = 2
 150    return
        end
