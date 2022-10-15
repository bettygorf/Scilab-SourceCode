      subroutine dqrsm(x,ldx,n,p,y,ldy,nc,b,ldb,k,jpvt,qraux,work)
      integer ldx,n,p,ldy,nc,ldb,k,jpvt(*)
      double precision x(ldx,*),y(ldy,*),b(ldb,*),qraux(*),work(*)
c
c!purpose
c     sqrsm is a subroutine to compute least squares solutions
c     to the system
c
c     (1)               x * b = y,
c
c     which may be either under-determined or over-determined.
c     the relative machine precision eps is used as a tolerance
c     to limit the columns of x used in computing the solution.
c     in effect, a set of columns with a condition number
c     approximately rounded by 1/eps is used, the other
c     components of b being set to zero
c     if n.eq.1 and nc.gt.1 the elements in the nc-th column of b
c     are set to one).
c!calling sequence
c
c     subroutine dqrsm(x,ldx,n,p,y,ldy,nc,b,ldb,k,jpvt,qraux,work)
c
c     on entry
c
c        x     real(ldx,p), where ldx.ge.n
c              x contains the nxp coefficient matrix of
c              the system (1), x is destroyed by sqrsm.
c
c        ldx   integer
c              ldx is the leading dimension of the array x.
c
c        n     integer
c              n is the number of rows of the matrix x.
c
c        p     integer
c              p is the number of columns of the matrix x.
c
c        y     real(ldy,nc)
c              y contains the right hand side of the system(1).
c
c        ldy   integer
c              ldy is the leading dimension of the array y.
c
c        nc    integer
c              nc is the number of columns of the matrix y.
c
c        jpvt  integer(p)
c              jpvt is an integer array used by sqrdc.
c
c        qraux real(p)
c              qraux is an array used by sqrdc and sqrsl
c
c        work  real(p)
c              work is a array used by sqrdc.
c
c     on return
c
c        x     x contains the output array from sqrdc.
c
c        b     real(ldb,nc)
c              b contains the solution matrix. components
c              corresponding io columns not used are set to zero
c              (if n.eq.1 and nc.gt.1 the elements in the nc-th
c              column of b are set to one).
c
c        ldb   integer
c
c        k     integer
c              k contains the number of columns used in the
c              solutions.
c
c        jpvt  contains the pivot information from sqrdc.
c
c        qraux contains the array output by sqrdc.
c
c     on return the arrays x, jpvt and qraux contain the
c     usual output from dqrdc, so that the qr decomposition
c     of x with pivoting is fully available to the user.
c     in particular, columns jpvt(1), jpvt(2),...,jpvt(k)
c     were used in the solution, and the condition number
c     associated with those columns is estimated by
c     abs(x(1,1)/x(k,k)).
c!auxiliary routines
c     dqrdc dqrsl (linpack)
c!originator
c     this subroutine is a modification of the example program sqrst,
c     given in the linpack users' guide:
c     dongarra j.j., j.r.bunch, c.b.moler and g.w.stewart.
c     linpack users' guide. siam, philadelphia, 1979.
c!
c     internal variables
c
      integer info,j,kk,l,m
      double precision t
c
c     initialize jpvt so that all columns are free.
c
      do 10 j=1,p
          jpvt(j) = 0
   10 continue
c
c     reduce x.
c
      call dqrdc(x,ldx,n,p,qraux,jpvt,work,1)
c
c     determine which columns to use.
c
      k = 0
      m = min(n,p)
      do 20 kk=1,m
         t = abs(x(1,1)) + abs(x(kk,kk))
         if (t .eq. abs(x(1,1))) go to 30
         k = kk
   20 continue
   30 continue
c
c     solve the least squares problem.
c
      if (k .eq. 0) go to 160
      if (n .ge. p .or. n .gt. 1 .or. nc .eq. 1) go to 60
      np1 = n + 1
      do 50 j=1,n
         do 40 kk=np1,p
            y(j,nc) = y(j,nc) - x(j,kk)
  40     continue
  50  continue
  60  do 70 l=1,nc
        call dqrsl(x,ldx,n,k,qraux,y(1,l),t,y(1,l),b(1,l),t,t,100,info)
  70  continue
c
c    set the unused components of b to zero and initialize jpvt
c    for unscrambling.
c
      do 90 j=1,p
        jpvt(j) = -jpvt(j)
        if (j .le. k) go to 90
        do 80 l=1,nc
           b(j,l) = 0.0d+0
  80    continue
  90  continue
      if(n.ne.1.or.nc.le.1.or.p.le.n) goto 110
c
c    if n.eq.1 and nc.gt.1 set the elements in the nc-th
c    column of b to one.
c
      do 100 j=np1,p
        b(j,nc) = 1.0d+0
  100 continue
 110  continue
c
c    unscramble the solution.
c
      do 150 j=1,p
        if (jpvt(j) .gt. 0) go to 150
        kk = -jpvt(j)
        jpvt(j) = kk
 120    continue
           if (kk .eq. j) go to 140
           do 130 l=1,nc
              t = b(j,l)
              b(j,l) = b(kk,l)
              b(kk,l) = t
 130       continue
           jpvt(kk) = -jpvt(kk)
           kk = jpvt(kk)
        go to 120
 140    continue
 150  continue
 160  continue
      return
      end
