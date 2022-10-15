        subroutine sszer(n,m,p,a,na,b,c,nc,d,eps,zeror,zeroi,nu,irank,
     1        af,naf,bf,mplusn,wrka,wrk1,nwrk1,wrk2,nwrk2,ierr)
c
c! calling sequence
c
c        subroutine sszer(n,m,p,a,na,b,c,nc,d,zeror,zeroi,nu,irank,
c     1       af,naf,bf,mplusn,wrka,wrk1,nwrk1,wrk2,nwrk2,ierr)
c
c        integer n,m,p,na,nc,nu,irank,nabf,mplusn,nwrk1,nwrk2,ierr
c
c        double precision a(na,n),b(na,m),c(nc,n),d(nc,m),wrka(na,n)
c        double precision af(naf,mplusn),bf(naf,mplusn)
c        double precision wrk1(nwrk1),wrk2(nwrk2)
c        double precision zeror(n),zeroi(n)
c
c arguments in
c
c        n       integer
c                -the number of state variables in the system
c
c        m       integer
c                -the number of inputs to the system
c
c        p       integer
c                -the number of outputs from the system
c
c        a       double precision (n,n)
c                -the state dynamics matrix of the system
c
c        na      integer
c                -the declared first dimension of matrices a and b
c
c        b       double precision (n,m)
c                -the  input/state  matrix of the system
c
c        c       double precision (p,n)
c                -the  state/output  matrix of the system
c
c        nc      integer
c                -the declared first dimension of matrices  c and d
c
c        d       double precision (p,m)
c                -the  input/output  matrix of the system
c
c        naf     integer
c                -the declared first dimension of matrices  af and bf
c                 naf must be at least  n + p
c
c        mplusn  integer
c                -the second dimension of  af and bf.  mplusn  must be
c                at least  m + n .
c
c        nwrk1   integer
c                -the length of work vector wrk1.
c                nwrk1  must be at least  max(m,p)
c
c        nwrk2   integer
c                -the length of work vector  wrk2.
c                nwrk2  must be at least  max(n,m,p)+1
c
c arguments out
c
c        nu      integer
c                -the number of (finite) invariant zeros
c
c        irank   integer
c                -the normal rank of the transfer function
c
c        zeror   double precision (n)
c        zeroi   double precision (n)
c                -the real  and imaginary parts of the zeros
c
c        af      double precision ( n+p , m+n )
c        bf      double precision ( n+p , m+n )
c                -the coefficient matrices of the reduced pencil
c
c        ierr    integer
c                -error indicator
c
c                ierr = 0        successful return
c
c                ierr = 1        incorrect dimensions of matrices
c
c                ierr = 2        attempt to divide by zero
c
c                ierr = i > 2    ierr value i-2 from qitz (eispack)
c
c!working space
c
c        wrka    double precision (na,n)
c
c        wrk1    double precision (nwrk1)
c
c        wrk2    double precision (nwrk2)
c
c!purpose
c
c        to compute the invariant zeros of a linear multivariable
c        system given in state space form.
c
c!method
c
c        this routine extracts from the system matrix of a state-space
c        system  a,b,c,d  a regular pencil   lambda * bf  -  af
c        which has the invariant zeros of the system as generalized
c        eigenvalues.
c
c!reference
c
c        emami-naeini, a. and van dooren, p.
c        'computation of zeros of linear multivariable systems'
c        report na-80-03, computer science department, stanford univ.
c
c!originator
c
c                a.emami-naeini, computer science department,
c                stanford university.
c
        integer n,m,p,na,nc,nu,irank,naf,mplusn,nwrk1,nwrk2,ierr
c
      double precision a(na,n),b(na,m),c(nc,n),d(nc,m)
      double precision wrka(na,n),zeror(n),zeroi(n)
      double precision af(naf,mplusn),bf(naf,mplusn),wrk1(nwrk1)
     1    ,wrk2(nwrk2)
      double precision eps,sum,heps,xxx
c
c       local variables:
c
        logical zero,matq,matz
c
        integer mm,nn,pp,mu,iro,isigma,numu,mnu,numu1,mnu1,i,j,j1
        integer mj,ni,nu1
c
      double precision s
        ierr = 1
        if (na .lt. n) return
        if (nc .lt. p) return
        if (naf .lt. n+p) return
        if (nwrk1.lt. m) return
        if (nwrk1.lt. p) return
        if (nwrk2.lt. n) return
        if (nwrk2.lt. m) return
        if (nwrk2.lt. p) return
        if (mplusn .lt. m+n) return
        ierr = 0
c       construct the compound matrix (b      a) of dimension
c                                     (d      c)
c       (n + p) * (m + n)
c
        sum = 0.0d+0
        do 30 i = 1,n
           do 10 j = 1,m
              bf(i,j) = b(i,j)
              sum = sum + (b(i,j) * b(i,j) )
  10          continue
           do 30 j = 1,n
              mj = m + j
              bf(i,mj) = a(i,j)
              sum = sum + (a(i,j) * a(i,j) )
  30          continue
c
        do 60 i = 1,p
           ni = n + i
           do 40 j = 1,m
              bf(ni,j) = d(i,j)
              sum = sum + (d(i,j) * d(i,j) )
  40          continue
           do 60 j = 1,n
              mj = m + j
              bf(ni,mj) = c(i,j)
              sum = sum + (c(i,j) * c(i,j) )
  60          continue
c
        heps = eps * sqrt(sum)
c
c       reduce this system to one with the same invariant zeros and with
c       d full row rank mu (the normal rank of the original system)
c
        iro = p
        isigma = 0
c
        call reduce(bf,naf,mplusn,m,n,p,heps,iro,isigma,mu,nu,
     1              wrk1,nwrk1,wrk2,nwrk2)
c
        irank = mu
        if (nu .eq. 0) return
c
c       pertranspose the system
c
        numu = nu + mu
        mnu = m + nu
        numu1 = numu + 1
        mnu1 = mnu + 1
        do 70 i = 1,numu
           ni = numu1 - i
           do 70 j = 1,mnu
              mj = mnu1 - j
              af(mj,ni) = bf(i,j)
  70          continue
c
        mm = m
        nn = n
        pp = p
        if (mu .eq. mm) go to 80
        pp = mm
        nn = nu
        mm = mu
c
c       reduce the system to one with the same invariant zeros and with
c       d square and of full rank
c
        iro = pp - mm
        isigma = mm
c
        call reduce(af,naf,mplusn,mm,nn,pp,heps,iro,isigma,mu,nu,
     1              wrk1,nwrk1,wrk2,nwrk2)
c
        if (nu .eq. 0) return
        mnu = mm + nu
  80    continue
        do 100 i = 1,nu
           ni = mm + i
           do 90 j = 1,mnu
              bf(i,j) = 0.0d+0
  90          continue
           bf(i,ni) = 1.0d+0
 100       continue
c
        if (irank .eq. 0) return
        nu1 = nu + 1
        numu = nu + mu
        j1 = mm
        do 120 i = 1,mm
           j1 = j1 - 1
           do 110 j = 1,nu1
              mj = j1 + j
              wrk2(j) = af(numu,mj)
 110          continue
c
           call house(wrk2,nu1,nu1,heps,zero,s)
           call tr2(af,naf,mplusn,wrk2,s,1,numu,j1,nu1)
           call tr2(bf,naf,mplusn,wrk2,s,1,nu,j1,nu1)
c
           numu = numu - 1
 120       continue
         matz = .false.
         matq = .false.
cc
          call qhesz(naf,nu,af,bf,matq,xxx,matz,wrka)
          call qitz(naf,nu,af,bf,eps,matq,xxx,matz,wrka,ierr)
         if (ierr .ne. 0) go to 150
cc
       call qvalz(naf,nu,af,bf,eps,zeror,zeroi,wrk2,matq,xxx,matz,wrka)
cc
c         do 130 i = 1,nu
c            if (wrk2(i) .eq. 0.0d+0) go to 140
c            zeror(i) = zeror(i)/wrk2(i)
c            zeroi(i) = zeroi(i)/wrk2(i)
c  130       continue
cc
cc       successful completion
cc
         ierr = 0
         return
cc
cc       attempt to divide by zero
cc
c  140    ierr = 2
c         return
cc
cc       failure in subroutine qzit
cc
  150    ierr = ierr + 2
        return
        end
        subroutine reduce(abf,naf,mplusn,m,n,p,heps,iro,isigma,mu,nu,
     1                    wrk1,nwrk1,wrk2,nwrk2)
c%calling sequence
c       subroutine reduce(abf,naf,mplusn,m,n,p,heps,iro,isigma,mu,nu,
c    1                    wrk1,nwrk1,wrk2,nwrk2)
c       integer naf,mplusn,m,n,p,iro,isigma,mu,nu,nwrk1,nwrk2
c       double precision abf(naf,mplusn),wrk1(nwrk1),wrk2(nwrk2)
c
c%purpose
c
c     this routine is only to be called from slice routine sszer
c%
        integer naf,mplusn,m,n,p,iro,isigma,mu,nu,nwrk1,nwrk2
c
        double precision abf(naf,mplusn),wrk1(nwrk1),wrk2(nwrk2)
c
c       local variables:
c
        integer i,j,i1,m1,n1,i2,mm1,mn1,irj,itau,iro1,icol
        integer ibar,numu,irow
c
        logical zero
c
        double precision s,temp
c
        double precision sum,heps
c
c
        mu = p
        nu = n
 10     if (mu .eq. 0) return
        iro1 = iro
        mnu = m + nu
        numu = nu + mu
        if (m .eq. 0) go to 120
        iro1 = iro1 + 1
        irow = nu
        if (isigma .le. 1) go to 40
c
c       compress rows of d: first exploit triangular shape
c
        m1 = isigma - 1
        do 30 icol = 1,m1
           do 20 j = 1,iro1
              irj = irow + j
              wrk2(j) = abf(irj,icol)
 20           continue
c
           call house(wrk2,iro1,1,heps,zero,s)
c
           call tr1(abf,naf,mplusn,wrk2,s,irow,iro1,icol,mnu)
c
           irow = irow + 1
 30        continue
c
c       continue with householder transformation with pivoting
c
 40     if (isigma .ne. 0) go to 45
        isigma = 1
        iro1 = iro1 - 1
 45     if (isigma .eq. m) go to 60
        do 55 icol = isigma,m
           sum = 0.0d+0
           do 50 j = 1,iro1
              irj = irow + j
              sum = sum + (abf(irj,icol) * abf(irj,icol) )
 50           continue
           wrk1(icol) = sum
 55        continue
c
 60     continue
        do 100 icol = isigma,m
c
c          pivot if necessary
c
           if (icol .eq. m) go to 80
c
           call pivot(wrk1,temp,ibar,icol,m)
c
           if (ibar .eq. icol) go to 80
           wrk1(ibar) = wrk1(icol)
           wrk1(icol) = temp
           do 70 i = 1,numu
              temp = abf(i,icol)
              abf(i,icol) = abf(i,ibar)
 70           abf(i,ibar) = temp
c
c          perform householder transformation
c
 80        continue
           do 90 i = 1,iro1
              irj = irow + i
 90           wrk2(i) = abf(irj,icol)
c
           call house(wrk2,iro1,1,heps,zero,s)
c
           if (zero) go to 120
           if (iro1 .eq. 1) return
c
           call tr1(abf,naf,mplusn,wrk2,s,irow,iro1,icol,mnu)
c
           irow = irow + 1
           iro1 = iro1 - 1
           do 100 j = icol,m
 100          wrk1(j) = wrk1(j) - (abf(irow,j) * abf(irow,j) )
c
 120    itau = iro1
        isigma = mu - itau
c
c       compress the columns of c
c
        i1 = nu + isigma
        mm1 = m + 1
        n1 = nu
        if (itau .eq. 1) go to 140
        do 135 i = 1,itau
           irj = i1 + i
           sum = 0.0d+0
           do 130 j = mm1,mnu
 130          sum = sum + (abf(irj,j) * abf(irj,j) )
 135       wrk1(i) = sum
c
 140    continue
        do 200 iro1 = 1,itau
           iro = iro1 - 1
           i = itau - iro
           i2 = i + i1
c
c          pivot if necessary
c
           if (i .eq. 1) go to 160
c
           call pivot(wrk1,temp,ibar,1,i)
c
           if (ibar .eq. i) go to 160
           wrk1(ibar) = wrk1(i)
           wrk1(i) = temp
           irj = ibar + i1
           do 150 j = mm1,mnu
              temp = abf(i2,j)
              abf(i2,j) = abf(irj,j)
 150          abf(irj,j) = temp
c
c          perform householder transformation
c
 160       do 170 j = 1,n1
              irj = m + j
 170          wrk2(j) = abf(i2,irj)
c
           call house(wrk2,n1,n1,heps,zero,s)
c
           if (zero) go to 210
           if (n1 .eq. 1) go to 220
c
           call tr2(abf,naf,mplusn,wrk2,s,1,i2,m,n1)
c
           mn1 = m + n1
c
           call tr1(abf,naf,mplusn,wrk2,s,0,n1,1,mn1)
c
           do 190 j = 1,i
              irj = i1 + j
 190          wrk1(j) = wrk1(j) - (abf(irj,mn1) * abf(irj,mn1) )
           mnu = mnu - 1
 200       n1 = n1 - 1
c
        iro = itau
 210    nu = nu - iro
        mu = isigma + iro
        if (iro .eq. 0) return
        go to 10
c
 220    mu = isigma
        nu = 0
c
        return
        end
        subroutine house(wrk2,k,j,heps,zero,s)
c
c  warning - this routine is only to be called from slice routine
c            sszer
c
c% purpose
c       this routine constructs a householder transformation h = i-s.uu
c       that 'mirrors' a vector wrk2(1,...,k) to the j-th unit vector.
c       if norm(wrk2) < heps, zero is put equal to .true.
c       upon return, u is stored in wrk2
c
c%
        integer k,j
c
        double precision wrk2(k),heps,s
c
        logical zero
c
c       local variables:
c
        integer i
c
        double precision alfa,dum1
c
        double precision sum
c
c
        zero = .true.
        sum = 0.0d+0
        do 10 i = 1,k
 10        sum = sum + (wrk2(i) * wrk2(i) )
c
        alfa = sqrt(sum)
        if (alfa .le. heps) return
c
        zero = .false.
        dum1 = wrk2(j)
        if (dum1 .gt. 0.0d+0) alfa = -alfa
        wrk2(j) = dum1 - alfa
        s = 1.0d+0 / (sum - (alfa * dum1) )
c
        return
        end

        subroutine tr1(a,na,n,u,s,i1,i2,j1,j2)
c% calling sequence
c
c        subroutine tr1(a,na,n,u,s,i1,i2,j1,j2)
c
c%purpose
c
c       this subroutine performs the householder transformation
c                       h = i - s.uu
c       on the rows i1 + 1 to i1 + i2 of a, this from columns j1 to j2.
c% comments
c
c  warning - this routine is only to be called from slice routine
c            sszer
c
c%
        integer na,n,i1,i2,j1,j2
c
        double precision a(na,n),u(i2),s
c
c       local variables:
c
        integer i,j,irj
c
        double precision y
c
        double precision sum
c
c
        do 20 j = j1,j2
           sum = 0.0d+0
           do 10 i = 1,i2
              irj = i1 + i
 10           sum = sum + (u(i) * a(irj,j) )
c
           y = sum * s
c
           do 20 i = 1,i2
              irj = i1 + i
 20           a(irj,j) = a(irj,j) - (u(i) * y)
c
        return
        end

        subroutine tr2(a,na,n,u,s,i1,i2,j1,j2)
c% calling sequence
c
c        subroutine tr2(a,na,n,u,s,i1,i2,j1,j2)
c%purpose
c
c       this routine performs the householder transformation h = i-s.uu
c       on the columns j1 + 1 to j1 + j2 of a, this from rows i1 to i2.
c
c% comments
c
c  warning - this routine is only to be called from slice routine
c            sszer
c%
        integer na,n,i1,i2,j1,j2
c
        double precision a(na,n),u(j2),s
c
c       local variables:
c
        integer i,j,irj
c
        double precision y
c
        double precision sum
c
c
        do 20 i = i1,i2
          sum = 0.0d+0
           do 10 j = 1,j2
              irj = j1 + j
 10           sum = sum + (u(j) * a(i,irj) )
c
           y = sum * s
c
           do 20 j = 1,j2
              irj = j1 + j
 20           a(i,irj) = a(i,irj) - (u(j) * y)
c
        return
        end

        subroutine pivot(vec,vmax,ibar,i1,i2)
c% calling sequence
c       subroutine pivot(vec,vmax,ibar,i1,i2)
c       integer ibar,i1,i2
c       double precision vec(i2),vmax
c
c% purpose
c
c       this subroutine computes the maximal norm element (vthe max)
c       of the vector vec(i1,...,i2), and its location ibar
c
c       this routine is only to be called from slice routine sszer
c
c%
        integer ibar,i1,i2
c
        double precision vec(i2),vmax
c
c       local variables:
c
        integer i,i11
c
c
        ibar = i1
        vmax = vec(i1)
        if (i1 .ge. i2) go to 20
        i11 = i1 + 1
        do 10 i = i11,i2
           if (abs(vec(i) ) .lt. vmax) go to 10
           vmax = abs (vec(i) )
           ibar = i
  10       continue
c
  20    if (vec(ibar) .lt. 0.0d+0) vmax = -vmax
c
        return
        end
