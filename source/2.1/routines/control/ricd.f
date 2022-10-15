C/MEMBR ADD NAME=RICD,SSI=0
      subroutine ricd(nf,nn,f,n,h,g,cond,x,z,nz,w,eps,ipvt,
     x                wrk1,wrk2,ierr)
c!purpose
c     this subroutine solves the discrete-time algebraic matrix
c     riccati equation
c
c                t        t               t      -1    t
c           x = f *x*f - f *x*g1*((g2 + g1 *x*g1)  )*g1 *x*f + h
c
c     by laub's variant of the hamiltonian-eigenvector approach.
c
c!method
c      laub, a.j., a schur method for solving algebraic riccati
c           equations, ieee trans. aut. contr., ac-24(1979), 913-921.
c
c     the matrix f is assumed to be nonsingular and the matrices g1 and
c     g2 are assumed to be combined into the square array g as follows:
c                                    -1   t
c                           g = g1*g2  *g1
c
c     in case f is singular, see: pappas, t., a.j. laub, and n.r.
c       sandell, on the numerical solution of the discrete-time
c       algebraic riccati equation, ieee trans. aut. contr., ac-25(1980
c       631-641.
c
c!calling sequence
c     subroutine ricd (nf,nn,f,n,h,g,cond,x,z,nz,w,eps
c    +                    ipvt,wrk1,wrk2,ierr   )
c
c     integer nf,ng,nh,nz,n,nn,itype(nn),ipvt(n),ierr
c     double precision f(nf,n),g(ng,n),h(nh,n),z(nz,nn),w(nz,nn),
c    +                 ,wrk1(nn),wrk2(nn),x(nf,n)
c     on input:
c        nf,nz      row dimensions of the arrays containing
c                         (f,g,h) and (z,w), respectively, as
c                         declared in the calling program dimension
c                         statement;
c
c        n                order of the matrices f,g,h;
c
c        nn               = 2*n = order of the internally generated
c                         matrices z and w;
c
c        f                a nonsingular n x n (real) matrix;
c
c        g,h              n x n symmetric, nonnegative definite
c                         (real) matrices.
c
c      eps      relative machine precision
c
c
c     on output:
c
c        x                n x n array containing txe unique positive
c                         (or nonnegative) definite solution of the
c                         riccati equation;
c
c
c        z,w              2*n x 2*n real scratch arrays used for
c                         computations involving the symplectic
c                         matrix associated with the riccati equation;
c
c        wrk1,wrk2       real scratch vectors of lengths  2*n
c
c      cond
c                         condition number estimate for the final nth
c                         order linear matrix equation solved;
c
c        ipvt       integer scratch vector of length 2*n
c
c        ierr             error code
c                         ierr=0 : ok
c                         ierr=-1 : singular linear system
c                         ierr=i : i th eigenvalue is badly calculated
c
c     ***note:  all scratch arrays must be declared and included
c               in the call.***
c
c!comments
c     it is assumed that:
c        (1)  f is nonsingular (can be relaxed; see ref. above   )
c        (2)  g and h are nonnegative definite
c        (3)  (f,g1) is stabilizable and (c,f) is detectable where
c              t
c             c *c = h (c of full rank = rank(h)).
c     under these assumptions the solution (returned in the array h) is
c     unique and nonnegative definite.
c
c!originator
c     written by alan j. laub (dep't. of elec. engrg. - systems, univ.
c     of southern calif., los angeles, ca 90007; ph.: (213) 743-5535),
c     sep. 1977.
c     most recent version: apr. 15, 1981.
c
c!auxiliary routines
c     hqror2,inva,fout,mulwoa,mulwob
c     dgeco,dgesl (linpack   )
c     balanc,balbak,orthes,ortran (eispack   )
c     ddot (blas)
c!
c
c     *****parameters:
      integer nf,nz,n,nn,ipvt(nn),ierr
      double precision f(nf,n),g(nf,n),h(nf,n),z(nz,nn),w(nz,nn),
     +                 wrk1(nn),wrk2(nn),x(nf,n)
      logical fail
      external fout
c
c     *****local variables:
      integer i,j,low,igh,nlow,npi,npj,nup
      double precision eps,t,cond,det,ddot
c
c
c     - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
c
c     eps is a  machine dependent parameter
c     specifying the relative precision of realing point arithmetic.
c     for example, eps = 16.0d+0**(-13) for double precision arithmetic
c     on ibm s360/s370.
c
c
c                             ( f**-1            (f**-1)*g             )
c  set up symplectic matrix z=(                                        )
c                             ( h*(f**-1)        h*(f**-1)*g+trans(f)  )
c
c z11=f**-1
      fail=.false.
      do 20 j=1,n
         do 10 i=1,n
            z(i,j)=f(i,j)
   10    continue
   20 continue
      call dgeco (z,nz,n,ipvt,cond,wrk1)
      if ((cond+1.0d+0) .le. 1.0d+0) go to 200
      call dgedi(z,nz,n,ipvt,det,wrk1,01)
c z21=h*f**-1; z12=(f**-1)*g
      do 90 j=1,n
         npj=n+j
         do 90 i=1,n
           npi=n+i
            z(i,npj)=ddot(n,z(i,1),nz,g(1,j),1)
            z(npi,j)=ddot(n,h(i,1),nf,z(1,j),1)
   90    continue
c z22=transp(f)+h*(f**-1)*g
      do 140 j=1,n
         npj=n+j
         do 130 i=1,n
            npi=n+i
            z(npi,npj)=f(j,i)+ddot(n,z(npi,1),nz,g(1,j),1)
  130    continue
  140 continue
c
c     balance z
c
      call balanc (nz,nn,z,low,igh,wrk1)
c
c     reduce z to real schur form with eigenvalues outside the unit
c     disk in the upper left n x n upper quasi-triangular block
c
      nlow=1
      nup=nn
      call orthes (nz,nn,nlow,nup,z,wrk2)
      call ortran (nz,nn,nlow,nup,z,wrk2,w)
      call hqror2(nz,nn,1,nn,z,t,t,w,ierr,11)
      if(ierr.ne.0) goto 210
      call inva(nz,nn,z,w,fout,eps,ndim,fail,ipvt)
      if(fail) goto 220
      if(ndim.ne.n) goto 230
c
c     compute solution of the riccati equation from the orthogonal
c     matrix now in the array w.  store the result in the array h.
c
      call balbak (nz,nn,low,igh,wrk1,nn,w)
c resolution systeme lineaire
      call dgeco(w,nz,n,ipvt,cond,wrk1)
      if(cond+1.0d+0.le.1.0d+0) goto 200
      do 160 j=1,n
         npj=n+j
         do 150 i=1,n
            x(i,j)=w(npj,i)
  150    continue
  160 continue
      do 165 i=1,n
  165 call dgesl(w,nz,n,ipvt,x(1,i),1)
      return
  200 continue
c systeme lineaire numeriquement singulier
      ierr=-1
      return
  210 continue
c   erreur dans hqror2
      ierr=i
      return
c
  220 continue
c      erreur dans inva
      return
c
  230 continue
c    la matrice symplectique n'a pas le
c    bon nombre de val. propres  de module
c    inferieur a 1.
      return
c
c     last line of ricd
c
      end
