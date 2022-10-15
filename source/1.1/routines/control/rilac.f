        subroutine rilac(n,nn,a,na,c,d,rcond,x,w,nnw,z,eps,
     +                iwrk,wrk1,wrk2,ierr)
c!purpose
c
c        to solve the continuous time algebraic equation
c
c                trans(a)*x + x*a + c - x*d*x  =  0
c
c        where  trans(a)  denotes the transpose of  a .
c
c!method
c
c        the method used is laub's variant of the hamiltonian -
c        eigenvector approach (schur method).
c
c!reference
c
c        a.j. laub
c        a schur method for solving algebraic riccati equations
c        ieee trans. automat. control, vol. ac-25, 1980.
c
c! auxiliary routines
c
c       orthes,ortran,balanc,balbak (eispack)
c       dgeco,dgesl (linpack)
c       hqror2,inva,exchgn,qrstep 
c
c! calling sequence
c        subroutine rilac(n,nn,a,na,c,d,rcond,x,w,nnw,z,
c    +                iwrk,wrk1,wrk2,ierr)
c
c        integer n,nn,na,nnw,iwrk(nn),ierr
c        double precision a(na,n),c(na,n),d(na,n)
c        double precision rcond,x(na,n),w(nnw,nn),z(nnw,nn)
c        double precision wrk1(nn),wrk2(nn)
c
c arguments in
c
c       n       integer
c               -the order of a,c,d and x
c
c       na      integer
c               -the declared first dimension of a,c,d and x
c
c       nn      integer
c               -the order of w and z
c                    nn = n + n
c
c       nnw     integer
c               -the declared first dimension of w and z
c
c
c       a       double precision(n,n)
c
c       c       double precision(n,n)
c
c       d       double precision(n,n)
c
c arguments out
c
c       x       double precision(n,n)
c               - x  contains the solution matrix
c
c       w       double precision(nn,nn)
c               - w  contains the ordered real upper-triangular
c               form of the hamiltonian matrix
c
c       z       double precision(nn,nn)
c               - z  contains the transformation matrix which
c               reduces the hamiltonian matrix to the ordered
c               real upper-triangular form
c
c       rcond   double precision
c               - rcond  contains an estimate of the reciprocal
c               condition of the  n-th order system of algebraic
c               equations from which the solution matrix is obtained
c
c       ierr    integer
c               -error indicator set on exit
c
c               ierr  =  0       successful return
c
c               ierr  =  1       the real upper triangular form of
c                                the hamiltonian matrix cannot be
c                                appropriately ordered
c
c               ierr  =  2       the hamiltonian matrix has less than n
c                                eigenvalues with negative real parts
c
c               ierr  =  3       the  n-th order system of linear
c                                algebraic equations, from which the
c                                solution matrix would be obtained, is
c                                singular to working precision
c
c               ierr  =  4       the hamiltonian matrix cannot be
c                                reduced to upper-triangular form
c
c working space
c
c       iwrk    integer(nn)
c
c       wrk1    double precision(nn)
c
c       wrk2    double precision(nn)
c
c!originator
c
c                control systems research group, dept. eecs, kingston
c                polytechnic, penrhyn rd.,kingston-upon-thames, england.
c
c! comments
c                if there is a shortage of storage space, then the
c                matrices  c  and  x  can share the same locations,
c                but this will, of course, result in the loss of  c.
c
c*******************************************************************
c
        integer n,nn,na,nnw,iwrk(nn),ierr
        double precision a(na,n),c(na,n),d(na,n)
        double precision rcond,x(na,n),w(nnw,nn),z(nnw,nn)
        double precision wrk1(nn),wrk2(nn)
c
c        local declarations:
c
        integer i,j,low,igh,ni,nj
        double precision eps,t
      external folhp
      logical fail
c
c
c         eps is a machine dependent parameter specifying
c        the relative precision of realing point arithmetic.
c
c        initialise the hamiltonian matrix associated with the problem
c
        do 10 j = 1,n
                nj = n + j
                do 10 i = 1,n
                        ni = n + i
                        w(i,j) = a(i,j)
                        w(ni,j) = -c(i,j)
                        w(i,nj) = -d(i,j)
                        w(ni,nj) = -a(j,i)
  10    continue
c
        call balanc(nnw,nn,w,low,igh,wrk1)
c
      call orthes(nn,nn,1,nn,w,wrk2)
      call ortran(nn,nn,1,nn,w,wrk2,z)
      call hqror2(nn,nn,1,nn,w,t,t,z,ierr,11)
        if (ierr .ne. 0) go to 70
      call inva(nn,nn,w,z,folhp,eps,ndim,fail,iwrk)
c
        if (ierr .ne. 0) go to 40
         if(ndim.ne.n) goto 50
c
        call balbak(nnw,nn,low,igh,wrk1,nn,z)
c
c
        call dgeco(z,nnw,n,iwrk,rcond,wrk1)
        if (rcond .lt. eps) go to 60
c
        do 30 j = 1,n
                nj = n + j
                do 20 i = 1,n
                        x(i,j) = z(nj,i)
  20            continue
                call dgesl(z,nnw,n,iwrk,x(1,j),1)
  30    continue
        go to 100
c
  40    ierr = 1
        go to 100
c
  50    ierr = 2
        go to 100
c
  60    ierr = 3
      goto 100
c
  70    ierr = 4
        go to 100
c
 100    return
        end
