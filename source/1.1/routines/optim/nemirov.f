C-------------------------------------------------------------------
C     GENERALIZED LINER-FRACTIONAL PROBLEM ON THE CONE OF POSITIVE
C     SEMIDEFINITE MATRICES BY PROJECTIVE
C     METHOD version 1.1 of November 25, 1991
C     Authors: A.S. Nemirovskii & Yu.E. Nesterov
C     to contact, please use e-mail
C     root@cemi.msk.su
C     Subject: Attn. Nesterov & Nemirovskii
C-------------------------------------------------------------------
C     This code implements the Projective polynomial time potential
C     reduction method as applied to the following problem:
C
C     (P)         minimize t subject to
C                   Ax + b    >= 0,
C                   t*(A*x+b) >= Q*x+p,
C                   t         >= tmin
C
C     where x belongs to R^n, A and Q are linear mappings from R^n in-
C     to the space
C                  S[m] = S^m(1) x ... x S^m(k),
C     S^i being the space of symmetric i*i matrices and >= means "po-
C     sitive semidefinite"
C     The description of the prototype of the method can be found in
C     Yu.E.Nesterov, A.S. Nemirovsky
C     Self-concordance and polynomial time interior point methods in
C     convex programming (extended version) - USSR Acad. Sci. Centr.
C     Econ. & Math. Inst., Moscow, 1990
C     (to appear in Lecture Notes in Mathematics under the title
C     Interior point polynomial methods in convex programming: theo-
C     ry and applications)
C*******************************************************************
C     ALL REALS ARE *8, ALL INTEGERS ARE *4 !!!
C*******************************************************************
      subroutine prfr(n,k,m,A,b,Q,p,ipin,rpin,xin,
     1                ipout,rpout,xout,war,iwar)

      implicit double precision (a-h,o-z)
      parameter (one=0.95d0, one1=0.99, mxdch=20,mxpr=3)
      external scal,aba,tinv,inv,sinv,mtv,tmtv,chol,schol,
     1         ltr,utr,msg,mtv1,tmtv1
      dimension A(*),b(*),Q(*),rpin(*),rpout(*),xin(*),xout(*),war(*)
      dimension p(*)
      dimension m(*),ipin(*),ipout(*),iwar(*)
C*******************************************************************
C     SEMANTICS:
C-------------------------------------------------------------------
C     REMARK: a lower-triangular q*q matrix R is stored as a linear
C     array R(1,1),R(2,1),R(2,2),...,R(q,1),...,R(q,q). A symmetric
C     matrix from S[m] is represented  by its lower-triangular part
C     stored as a lower-triangular matrix.
C*******************************************************************
C     INPUT/OUTPUT:
C-------------------------------------------------------------------
C     war      real working array
C     iwar     integer working array
C*******************************************************************
C     INPUT:
C-------------------------------------------------------------------
C-----Data----------------------------------------------------------
C     n        # of variables, see (P)
C     k        # of diagonal blocks, see (P)
C     m(k)     m(i) is the size of the i-th diagonal block, see (P)
C     A(nmm),  see (P); note that
C     Q(nmm)       nmm = n*{Len(m(1)) + ... + Len(m(k))},
C              where
C                       Len(i) = (i*(i+1))/2;
C              array A contains sequential columns of A stored as is
C              explained in the above Remark
C     b(mm),   see (P); note that
C     p(mm)        mm = Len(m(1)) + ... + Len(m(k))
C     xin(n),  initial approximate solution (optional)
C-----Control parameters--------------------------------------------
C     REMARK: when user sets a negative value of an input parameter,
C     it means that the value will be reset to the default value (it
C     is shown in angle brackets). The users are welcomed to  change
C     the parameters in order to achieve better performance
C-------------------------------------------------------------------
C     ipin(10) integer control parameters
C              ipin(1) <20> # of iterations allowed
C              ipin(2) <5>  # of primal dichotomy steps
C              ipin(3) <10> # of dual Newton steps
C                            0 - default dual step
C              ipin(4) <1>  0/1  to use/not use the initial approxi-
C                           mate solution (rpin(4),xin); if ipin(4)
C                           =0 and the solution is not strictly fe-
C                            asible, xin is ignored
C              ipin(5) <-1> printlevel:
C                            -1 no messages
C                             0 brief comments at the termination
C                             1 brief on-line messages
C                             2 full on-line messages
C                           Note that ipin(5) controls only screen
C                           messages. The method always create the
C                           protocol file
C              ipin(6) <17> # of channel for protocol file
C              ipin(7) <1>  length of war (in *8 reals)
C              ipin(8) <1>  length of iwar (in *4 integers)
C              ipin(9) <0>  0/1 Y/N on improved projection
C              ipin(10)<0>  0/1 Y/N on Cholesski for termination
C     rpin(8)  real control parameters
C              rpin(1) <1.d-6>  required relative accuracy. Theoreti-
C                               cally, after successful run value  vr
C                               of the objective at the resulting ap-
C                               proximate solution is greater than the
C                               optimal value by no more than
C                                   max{1,|vr|}*rpin(1)
C              rpin(2) <1.d-10> tolerance for "unfeasibility"
C              rpin(3) <1.d-12> tolerance for projection
C              rpin(4)          a priori upper bound for optimal value
C              rpin(5)          a priori tmin, see (P)
C              rpin(6)          not used
C              rpin(7)          not used
C              rpin(8)          not used
C********************************************************************
C     OUTPUT:
C--------------------------------------------------------------------
C     ipout(4) integer output characteristics 
C              ipout(1) reason for termination
C                       -2  iwar is too small
C                       -1  war is too small
C                       0  normal end
C                     > 0  cannot compute smth.
C              ipout(2) what is found 
C                       2  optimal solution found
C                       1  required accuracy achieved
C                       0  feasible solution found
C                      -1  unfeasibility found
C                      -2  below unboundedness found
C                      -3  below unboundedness or unfeasibility
C                          found
C                      -4  nothing found
C              ipout(3) # of iterations performed
C              ipout(4) not used
C     rpout(4) real output characteristics
C              rpout(1) t-component of the result, if ipout(2).ge.0
C              rpout(2) not used
C              rpout(3) not used
C              rpout(4) not used
C     xout(n)  x-component of the result, if ipout(2).ge.0
C*******************************************************************
C     MEMORY REQUIREMENTS:
C-------------------------------------------------------------------
C     the length of *4 integer array "iwar" should be at least 6*k
C     the length of *8 real array "war" should be at least
C        10*m2sum + 19*msum + mmax*(mmax+5) +
C        + (21*n*n+59*n)/2 + 18
C     where
C          m2sum = m(1)*m(1) + ... + m(k)*m(k),
C          msum = m(1) + ... + m(k),
C          mmax = max{m(1),...,m(k)}
C*******************************************************************
C*******************************************************************
C     DECLARATIONS
      logical feas,chok,dcht,dchok
      character *40 txt
      if (ipin(7).le.2) ipin(7)=1
      if (ipin(8).le.2) ipin(8)=1
C-------------------------------------------------------------------
C  1  MEMORY DISTRIBUTION: integer data
C-------------------------------------------------------------------
      kf=2*k
      mmax=0
      mu=0
      mlen=0
      mbnd=mlen+kf
      mfr=mbnd+kf
      mlst=mfr+kf
      if (mlst.gt.ipin(8)) then 
         ipout(1)=-2
         goto 9999
      endif
      lnmat=0
      lensm=0
      do 10 i=1,k
         len=(m(i)*(m(i)+1))/2
         iwar(mlen+i)=len
         iwar(mlen+k+i)=len
         lnmat=lnmat+len
         iwar(mbnd+i)=lnmat
         lensm=lensm+2*m(i)*m(i)
         if (m(i).gt.mmax) mmax=m(i)
         mu=mu+2*m(i)
   10 continue
      fmu=dble(float(mu))
      lmt=lnmat
      do 7 i=1,k
         len=iwar(mlen+i)
         lnmat=lnmat+len
         iwar(mbnd+k+i)=lnmat
    7 continue
      do 8 i=1,k
         iwar(mfr+i)=m(i)
         iwar(mfr+k+i)=m(i)
    8 continue
C-------------------------------------------------------------------
C     MEMORY DISTRIBUTION: real data
C-------------------------------------------------------------------
      n1=n+1
      lnn=(n1*(n1+1))/2
      nxp=0
      nxd=nxp+lnmat
      nrec=nxd+lnmat
      nwsn=nrec+n
      nwsm=nwsn+n1*n1
      nwstm=nwsm+mmax*mmax
      ntet=nwstm+lnmat
      ntetc=ntet+lnn
      ntetl=ntetc+lnn
      ntetq=ntetl+lnn
      ntet1=ntetq+lnn
      nctet=ntet1+lnn
      nctet1=nctet+lnn
      nv=nctet1+lnn
      nwn1=nv+lnmat
      nwn2=nwn1+n1
      nwne=nwn2+n1
      nwn3=nwne+n1
      nyv=nwn3+n1
      nu=nyv+n1
      nrxd=nu+lnmat
      ndm=nrxd+lnmat
      ndu=ndm+mu
      nksi=ndu+mu
      nksir=nksi+lnmat
      nw2m=nksir+lnmat
      nzet=nw2m+2*mmax
      nzetr=nzet+lnmat
      nmpv=nzetr+lnmat
      nmpc=nmpv+n1
      nmpe=nmpc+n1
      nc=nmpe+n1
      ne=nc+n1
      nchk=ne+n1
      nwe=nchk+lnmat
      nwm1=nwe+lnmat
      nwm2=nwm1+mmax
      nwm3=nwm2+mmax
      nlst=nwm3+mmax
      if (nlst.gt.ipin(7)) then
         ipout(1)=-1
         goto 9999
      endif
C-------------------------------------------------------------------
C     INITIALIZATION
C-------------------------------------------------------------------
      feas=.false.
      dinf=1.d0/rpin(2)
      opl=rpin(5)
      opb=rpin(5)
      opu=rpin(4)
      if (opu.le.opb) opu=opb + (1.d0+dabs(opb))*0.1
      dopu=opu-opb
      dopl=dopu
      itr=0
      iptot=0
      idtot=0
      iprr=0
      iwrn=1
      do 11 i=1,n
         war(ne+i)=0.d0
   11 continue
      war(ne+n1)=1.d0
      ipout(1)=0
      ipout(2)=-100
      if (ipin(1).lt.0) ipin(1)=20
      if (ipin(2).lt.0) ipin(2)=5
      if (ipin(3).lt.0) ipin(3)=10
      if (ipin(4).lt.0) ipin(4)=1
      if (ipin(5).lt.-2) ipin(5)=-2
      if (ipin(6).lt.0) then
         ipin(6)=17
         open(17,file='fr-lin.msg',status='unknown')
      endif
      if (ipin(9).lt.0) ipin(9)=0
      if (ipin(10).lt.0) ipin(10)=0
      if (rpin(1).lt.0.d0) rpin(1)=1.0d-6
      if (rpin(2).lt.0.d0) rpin(2)=1.0d-10
      if (rpin(3).le.0.d0) rpin(3)=1.0d-12
      txt='* upper bound for optimal value: '
      call msg(ipin,1,1,txt,0,rpin(4))
      txt='# of iterations allowed: '
      call msg(ipin,0,1,txt,ipin(1),0.0d0)
      txt='# of primal dichotomy steps: '
      call msg(ipin,0,1,txt,ipin(2),0.0d0)
      txt='# of dual Newton steps: '
      call msg(ipin,0,1,txt,ipin(3),0.0d0)
      txt='initial solution is given'
      if (ipin(4).ne.0) txt='default start'
      call msg(ipin,-1,1,txt,0,0.0d0)
      txt='accuracy required: '
      call msg(ipin,1,1,txt,0,rpin(1))
      if (ipin(5).eq.2) then
         txt='first tolerance: '
         call msg(ipin,1,1,txt,0,rpin(2))
      endif
C-------------------------------------------------------------------
C     START
C-------------------------------------------------------------------
C-----If initial strictly feasible solution is given, we should 
C     compute the corresponding xp and xd
c-------------------------------------------------------------------
      if (ipin(4).eq.0) then
         t=1.d0
         call mtv1(n,lnmat,A,b,Q,p,opu,xin,t,war(nxp+1))
         call sinv(kf,iwar(mfr+1),iwar(mbnd+1),war(nxp+1),
     1                   war(nxd+1),icc)
         if (icc.ne.0) then
            if (ipin(5).gt.0)
     1      write(*,*) '!!! Initial solution is unfeasible. ',
     2      'Default start'
            write(ipin(6),*) '!!! Initial solution is unfeasible. ',
     1      'Default start'
            goto 25
         endif
         rec=opu
         feas=.true.
         chok=.false.
         goto 40
      endif
C-----Default start: xd is the unit-----------------------------------
   25 continue
      itd=nxd+1
      itp=nxp+1
      ird=nrxd+1
      do 30 ib=1,k
         l=m(ib)
         do 31 i=1,l
            do 32 j=1,i
               s=0.d0
               if (i.eq.j) s=1.d0
               war(itd)=s
               war(itp)=s
               war(ird)=s
               war(itd+lmt)=s
               war(itp+lmt)=s
               war(ird+lmt)=s
               itd=itd+1
               itp=itp+1
               ird=ird+1
   32       continue
   31    continue
   30 continue
      chok=.true.
C-----Main Cycle-------------------------------------------------------
   40 continue
      dcht=.false.
      itr=itr+1
      if (itr.gt.ipin(1)) then
         ipout(1)=0
         if (feas) then
            ipout(2)=0
         else
            ipout(2)=-4
         endif
         ipout(3)=itr-1
         goto 9999
      endif
      txt='# of iterations performed: '
      call msg(ipin,0,1,txt,itr-1,0.0d0)
      if (feas) then
         txt='Best found objective value = '
         call msg(ipin,1,1,txt,0,rec)
      endif
      if ((ipin(5).eq.2).and.(ipin(9).eq.0).and.(iprr.ne.0)) then
         if (iprr.eq.1) txt='ProjError(1) = '
         if (iprr.eq.2) txt='ProjError(2) = '
         if (iprr.eq.3) txt='ProjError(3) = '
         call msg(ipin,1,1,txt,0,sclr)
      endif
      if ((iwrn.eq.0).and.(ipin(5).eq.2)) then
         txt='warning: squared distance = '
         call msg (ipin,1,1,txt,0,gamma)
      endif
      iwrn=1
C-----Computing TetaC,TetaL,TetaQ
      ivjv=1
      ifr=0
      do 50 iv=1,n
         call aba(k,m,iwar(mbnd+1),war(nxd+1),A(ifr+1),
     1            war(nwstm+1),war(nwsm+1))
         ifr=ifr+lmt
         jfr=0
         do 51 jv=1,iv
            call scal(k,m,iwar(mbnd+1),war(nwstm+1),A(jfr+1),s)
            war(ntetc+ivjv)=s
            ivjv=ivjv+1
            jfr=jfr+lmt
   51    continue
   50 continue
      call aba(k,m,iwar(mbnd+1),war(nxd+1),b,
     1         war(nwstm+1),war(nwsm+1))
      jfr=0
      do 52 jv=1,n
         call scal(k,m,iwar(mbnd+1),war(nwstm+1),A(jfr+1),s)
         war(ntetc+ivjv)=s
         ivjv=ivjv+1
         jfr=jfr+lmt
   52 continue
      call scal(k,m,iwar(mbnd+1),war(nwstm+1),b,s)
      war(ntetc+ivjv)=s
      ivjv=1
      ifr=0
      do 53 iv=1,n
         call aba(k,m,iwar(mbnd+1),war(nxd+lmt+1),Q(ifr+1),
     1            war(nwstm+1),war(nwsm+1))

         call aba(k,m,iwar(mbnd+1),war(nxd+lmt+1),A(ifr+1),
     1            war(nwstm+lmt+1),war(nwsm+1))
         ifr=ifr+lmt
         jfr=0
         do 54 jv=1,iv
            call scal(k,m,iwar(mbnd+1),war(nwstm+1),Q(jfr+1),s)
            war(ntetc+ivjv)=war(ntetc+ivjv)+s
            call scal(k,m,iwar(mbnd+1),war(nwstm+lmt+1),A(jfr+1),s)
            war(ntetq+ivjv)=s
            call scal(k,m,iwar(mbnd+1),war(nwstm+1),A(jfr+1),s)
            war(ntetl+ivjv)=-s
            call scal(k,m,iwar(mbnd+1),war(nwstm+lmt+1),Q(jfr+1),s)
            war(ntetl+ivjv)=war(ntetl+ivjv)-s
            ivjv=ivjv+1
            jfr=jfr+lmt
   54    continue
   53 continue
      call aba(k,m,iwar(mbnd+1),war(nxd+lmt+1),p,
     1         war(nwstm+1),war(nwsm+1))
      call aba(k,m,iwar(mbnd+1),war(nxd+lmt+1),b,
     1         war(nwstm+lmt+1),war(nwsm+1))
      jfr=0
      do 55 jv=1,n
         call scal(k,m,iwar(mbnd+1),war(nwstm+1),Q(jfr+1),s)
         war(ntetc+ivjv)=war(ntetc+ivjv)+s
         call scal(k,m,iwar(mbnd+1),war(nwstm+lmt+1),A(jfr+1),s)
         war(ntetq+ivjv)=s
         call scal(k,m,iwar(mbnd+1),war(nwstm+1),A(jfr+1),s)
         war(ntetl+ivjv)=-s
         call scal(k,m,iwar(mbnd+1),war(nwstm+lmt+1),Q(jfr+1),s)
         war(ntetl+ivjv)=war(ntetl+ivjv)-s
         ivjv=ivjv+1
         jfr=jfr+lmt
   55 continue
      call scal(k,m,iwar(mbnd+1),war(nwstm+1),p,s)
      war(ntetc+ivjv)=war(ntetc+ivjv)+s
      call scal(k,m,iwar(mbnd+1),war(nwstm+lmt+1),b,s)
      war(ntetq+ivjv)=s
      call scal(k,m,iwar(mbnd+1),war(nwstm+1),b,s)
      war(ntetl+ivjv)=-s
      call scal(k,m,iwar(mbnd+1),war(nwstm+lmt+1),p,s)
      war(ntetl+ivjv)=war(ntetl+ivjv)-s
      opt=opu
      dcht=.false.
      dchok=.false.
C-----Dichotomy loop--------------------------------------------------
   56 continue
C-----Computing TetaCapital-------------------------------------------
      cf1=opt
      cf2=cf1*cf1
      do 57 i=1,lnn
         war(ntet+i)=war(ntetc+i)+cf1*war(ntetl+i)+cf2*war(ntetq+i)
   57 continue
C-----Computing Cholesski factorization of TetaCapital---------- 1 ---
      call chol(n1,war(ntet+1),war(nctet+1),icc)
      if (icc.ne.0) then
         ipout(1)=1
         ipout(3)=itr
         if (feas) then
            ipout(2)=0
         else
            ipout(2)=-4
         endif
          goto 9999
      endif
C---------------------------------------------------------------------
C     PRIMAL STEP
C---------------------------------------------------------------------
C-----Computing v
      call tmtv1(n,lnmat,k,m,iwar(mbnd+1),
     1             A,b,Q,p,opt,war(nxd+1),war(nwn1+1),tc)
      war(nwn1+n1)=tc
      call ltr(n1,war(nctet+1),war(nwn1+1),war(nwn2+1))
      call utr(n1,war(nctet+1),war(nwn2+1),war(nyv+1))
      tc=war(nyv+n1)
      iprj=1
      if (ipin(9).eq.0) then
 8002    continue
         call mtv1(n,lnmat,A,b,Q,p,opt,war(nyv+1),tc,war(nv+1))
         do 8000 i=1,lnmat
            war(nu+i)=war(nxp+i)-war(nv+i)
 8000    continue
         call aba(kf,iwar(mfr+1),iwar(mbnd+1),war(nxd+1),war(nu+1),
     1            war(nwstm+1),war(nwsm+1))
C--------Check projection  1
         call scal(kf,iwar(mfr+1),iwar(mbnd+1),war(nv+1),
     1             war(nwstm+1),sc)
         call scal(kf,iwar(mfr+1),iwar(mbnd+1),war(nu+1),
     1             war(nwstm+1),ss)
         call aba(kf,iwar(mfr+1),iwar(mbnd+1),war(nxd+1),war(nv+1),
     1            war(nchk+1),war(nwsm+1))
         call scal(kf,iwar(mfr+1),iwar(mbnd+1),war(nv+1),
     1             war(nchk+1),tt)
         if (tt*ss.gt.0.d0) then
            scl=dabs(sc)/dsqrt(tt*ss)
         else
            scl=dabs(sc)
         endif
         if (scl.gt.rpin(3)) then
            call tmtv1(n,lnmat,k,m,iwar(mbnd+1),
     1                 A,b,Q,p,opt,war(nwstm+1),war(nwn1+1),tc)
            war(nwn1+n1)=tc
            call ltr(n1,war(nctet+1),war(nwn1+1),war(nwn2+1))
            call utr(n1,war(nctet+1),war(nwn2+1),war(nwn3+1))
            do 8001 i=1,n1
               war(nyv+i)=war(nyv+i)+war(nwn3+i)
 8001       continue
            tc=war(nyv+n1)
            iprj=iprj+1
            if (iprj.le.mxpr) goto 8002
         endif
      endif
      if (.not.feas) then
         iprr=iprj
         sclr=scl
      endif
      if (tc.le.0.d0) then
         call ltr(n1,war(nctet+1),war(ne+1),war(nwn1+1))
         call utr(n1,war(nctet+1),war(nwn1+1),war(nwne+1))
         ee=0.d0
         ev=war(nyv+n1)
         do 58 i=1,n1
            ee=ee+war(nwne+i)*war(ne+i)
   58    continue
         cf=ev/ee
         do 59 i=1,n1
            war(nyv+i)=war(nyv+i)-cf*war(nwne+i)
   59    continue
         war(nyv+n1)=0.d0
      endif
      tc=war(nyv+n1)
      call mtv1(n,lnmat,A,b,Q,p,opt,war(nyv+1),tc,war(nv+1))
      call scal(kf,iwar(mfr+1),iwar(mbnd+1),war(nv+1),war(nxd+1),sc)
      if (sc.le.0.d0) then
         if (.not.feas) then
            if (opu.ge.dinf) then
               ipout(1)=0
               ipout(2)=-1
               ipout(3)=itr
               goto 9999
            endif
            opu=opu+dopu
            if (opu.gt.dinf) opu=dinf
            dopu=dopu*2.d0
            if (dopu.gt.dinf) dopu=dinf
            opt=opu
            txt='!!! incorrect upper bound; set to '
            call msg(ipin,1,1,txt,0,opu)
            goto 56
         endif
         if (.not.dcht) then
            ipout(1)=77
            ipout(2)=0
            ipout(3)=itr
            goto 9999
         endif
         goto 117
      endif
      if (.not.dcht) then
         nksic=nksi
         nzetc=nzet
      else
         nksic=nksir
         nzetc=nzetr
      endif
      sc=fmu/sc
      do 61 i=1,lnmat
         war(nksic+i)=sc*war(nv+i)-war(nxp+i)
   61 continue
      call aba(kf,iwar(mfr+1),iwar(mbnd+1),war(nxd+1),war(nksic+1),
     1         war(nzetc+1),war(nwsm+1))
      call scal(kf,iwar(mfr+1),iwar(mbnd+1),war(nksic+1),
     1          war(nzetc+1),gmmc)
      if (ipin(10).eq.0) then
         do 992 i=1,lnmat
            war(nu+i)=war(nxp+i)-war(nv+i)
  992    continue
         call schol(kf,iwar(mfr+1),iwar(mbnd+1),war(nu+1),war(nu+1),
     1              icc)
         if ((icc.eq.0).and.(opl.lt.opt)) then
            txt='*1* new lower bound: '
            call msg(ipin,1,1,txt,0,opt)
            opl=opt
            opb=opt
         endif
      endif
      if (.not.dcht) then
         gamma=gmmc
         if (gamma.ge.one) dchok=.true.
      endif
      if (gmmc.ge.(fmu*(fmu-1.d0))) then
         if (.not.feas) then
            if (opu.ge.dinf) then
               ipout(1)=0
               ipout(2)=-1
               ipout(3)=itr
               goto 9999
            endif
            txt='!!! incorrect upper bound; set to '
            opu=opu+dopu
            if (opu.gt.dinf) opu=dinf
            opt=opu
            call msg(ipin,1,1,txt,0,opu)
            dopu=dopu*2.d0
            if (dopu.gt.dinf) dopu=dinf
            goto 56
         endif
         if (opb.lt.opt) then
            txt='*2* new lower bound: '
            call msg(ipin,1,1,txt,0,opt)
            opl=opt
            opb=opt
         endif
      endif
C-----Check whether w is positive semidefinite
      call schol(kf,iwar(mfr+1),iwar(mbnd+1),war(nv+1),
     1           war(nwstm+1),icc)
      if ((.not.(dcht)).and.(icc.ne.0)) goto 555
      if (icc.eq.0) then
         if (gmmc.ge.0.d0) then
            dst=dsqrt(fmu*gmmc/(gmmc+fmu))
         else
            dst=0.d0
         endif
         if (dst.ge.one1) then
            rad=0.d0
         else
            rad=one1-dst
         endif
         t=war(nyv+n1)
         if (t.eq.0.d0) then
            if (rad.eq.0) then
               tt=1.d0
               call mtv1(n,lnmat,A,b,Q,p,opt,war(ne+1),tt,
     1                   war(nwe+1))
               ifr=0
               smax=0.d0
               do 8250 ib=1,kf
                  l=iwar(mfr+ib)
                  do 8251 j=1,l
                     do 8252 i=1,l
                        if (i.ge.j) then
                           ij=j+(i*(i-1))/2
                        else
                           ij=i+(j*(j-1))/2
                        endif
                        war(nwm1+i)=war(nwe+ifr+ij)
 8252                continue
                     call ltr(l,war(nwstm+ifr+1),war(nwm1+1),
     1                       war(nwm2+1))
                     nt=j
                     do 8253 i=1,l
                        war(nwsm+nt)=war(nwm2+i)
                        nt=nt+l
 8253                continue
 8251             continue
                  sm=0.d0
                  do 8254 i=1,l
                     ij=(i-1)*l+nwsm
                     do 8255 j=1,l
                        war(nwm1+j)=war(ij+j)
 8255                continue
                     call ltr(l,war(nwstm+ifr+1),war(nwm1+1),
     1                       war(nwm2+1))
                     do 8256 j=1,l
                        s=dabs(war(nwm2+i))
                        if (s.gt.sm) sm=s
 8256                continue
 8254             continue
                  sm=l*sm
                  if (sm.gt.smax) smax=sm
                  ifr=iwar(mbnd+ib)
 8250          continue
               if (smax.eq.0.d0) then
                  ss=1.d0
               else
                  ss=0.5d0/smax
               endif
               war(nyv+n1)=war(nyv+n1)+ss
               t=war(nyv+n1)
            else
               rad1=0.1d0*rad
               se=war(nwne+n1)
               if (se.le.0.d0) then
                  ipout(1)=66
                  if (feas) then
                     ipout(2)=0
                  else
                     ipout(2)=-4
                  endif
                  ipout(3)=itr
                  goto 9999
               endif
               se=rad1/dsqrt(se)
               do 8200 i=1,n1
                  war(nyv+i)=war(nyv+i)+se*war(nwne+i)
 8200          continue
               t=war(nyv+n1)
               rad=rad-rad1
            endif
         endif
         call mtv(n,lnmat,A,b,war(nyv+1),t,war(nwstm+1))
         call aba(k,m,iwar(mbnd+1),war(nxd+lmt+1),war(nwstm+1),
     1            war(nwstm+lmt+1),war(nwsm+1))
         call scal(k,m,iwar(mbnd+1),war(nwstm+1),war(nwstm+lmt+1),
     1             sn)
         if (sn.gt.0.d0) then
            sn=dsqrt(sn)
         else
            sn=rpin(2)
         endif
         opmax=opt-rad/sn
         if (opmax.lt.opb) opmax=opb
         opu=opmax
         if (.not.dcht) then
            opmin=opb
            if (opmin.gt.opmax) then
               txt='!!! incorrect lower bound; set to '
               opb=opmax-dopl
               opmin=opb
               if (opb.lt.opl) opb=opl
               dopl=dopl*2.d0
               if (dopl.gt.dinf) dopl=dinf
               call msg(ipin,1,0,txt,0,opb)
            endif
         endif
         if (.not.feas) then
            feas=.true.
            rec=opmax
         endif
         if (rec.ge.opmax) then
            cf=1.d0/war(nyv+n1)
            do 910 i=1,n
               war(nrec+i)=war(nyv+i)*cf
  910       continue
            rec=opmax
            sclr=scl
            if (iprj.eq.mxpr+1) then
               iprr=mxpr
            else
               iprr=iprj
            endif
         endif
         if (opmax.le.-dinf) then
            ipout(1)=0
            ipout(2)=-2
            ipout(3)=itr
            goto 9999
         endif
         if (dcht) then
            if (gmmc.ge.gamma) then
               do 911 i=1,lnmat
                  war(nksi+i)=war(nksic+i)
                  war(nzet+i)=war(nzetc+i)
  911          continue
               gamma=gmmc
               if (gamma.ge.one) dchok=.true.
            endif
         endif
         if (.not.dcht) then
            dcht=.true.
            idich=0
         endif
      else
         opmin=opt
c         if (opmin.le.opb) opmin=opb
      endif
  117 continue
      if (opmin.gt.opmax) then
         txt='!!! incorrect lower bound; set to '
         opmin=opmax-dopl
         if (opmin.lt.opl) opmin=opl
         opb=opmin
         dopl=2.d0*dopl
         if (dopl.gt.dinf) dopl=dinf
         call msg(ipin,1,0,txt,0,opb)
      endif
      if ((idich.gt.ipin(2)).and.(dchok)) goto 555
      idich=idich+1
      if (idich.gt.mxdch) then
         goto 555
      endif
      iptot=iptot+1
      opt=0.5d0*(opmax+opmin)
      goto 56
C-------------------------------------------------------------------
C     DUAL STEP
C-------------------------------------------------------------------
  555 continue
      if (feas) then
         sc=dabs(rec)
         if (sc.le.1.d0) sc=1.d0
         if (rec-opl.le.rpin(1)*sc) then
            ipout(2)=1
            ipout(1)=0
            ipout(3)=itr
            goto 9999
         endif
      endif

C-----Default dual step
      if (gamma.le.0.d0) then
         ipout(1)=99
         if (feas) then
            ipout(2)=0
         else
           ipout(2)=-4
         endif
         ipout(3)=itr
         goto 9999
      endif
      if (gamma.lt.one) iwrn=0
      step=1.d0/(1.d0+dsqrt(gamma))
      if (ipin(3).eq.0) goto 666
C-----If chok = .false. we should perform Cholesski factorization
C     of xd                                                  - 5 ---
      if (chok) goto 777
      call schol(kf,iwar(mfr+1),iwar(mbnd+1),war(nxd+1),
     1           war(nrxd+1),icc)
      if (icc.ne.0) then
         ipout(1)=5
         if (feas) then
            ipout(2)=0
         else
            ipout(2)=-4
         endif
         ipout(3)=itr
         goto 9999
      endif
      chok=.true.
C-----Three-diagonal factorization of xd^(1/2)*ksi*xd^(1/2)---- 7 ---
  777 continue
      idmf=ndm
      iduf=ndu
      iksif=nksi
      irxdf=nrxd
      do 80 i=1,kf
         l=iwar(mfr+i)
         call diag(l,war(iksif+1),war(irxdf+1),war(nwsm+1),
     1             war(idmf+1),war(iduf+1),war(nw2m+1),icc)
         if (icc.ne.0) then
            ipout(1)=7
            ipout(3)=itr
            if (feas) then
               ipout(2)=0
            else 
               ipout(2)=-4
            endif
            goto 9999
         endif
            
         idmf=idmf+l
         iduf=iduf+l
         iksif=nksi+iwar(mbnd+i)
         irxdf=nrxd+iwar(mbnd+i)
   80 continue 
      idit=0
      stold=step
  778 continue
      idit=idit+1
      if (ipin(3).lt.idit) goto 788
      stinv=1.d0/step
      rtm1=0.d0
      rt=1.d0/(-war(ndm+1)+stinv)
      dt=rt
      dtm1=0.d0
      gt=0.d0
      gtm1=0.d0
      il=iwar(mfr+1)
      ibl=1
      do 780 i=2,mu
         if (i.gt.il) then
            ibl=ibl+1
            il=il+iwar(mfr+ibl)
            bb=0.d0
         else
            bb=-war(ndu+i-1)
         endif
         aa=-war(ndm+i)
         s=aa+stinv-bb*bb*rt
         if (s.le.0.d0) goto 788
         rtt=1.d0/s
         dtt=rtt*(1.d0+(aa+stinv)*dt-bb*bb*dtm1*rt)
         gtt=rtt*(2.d0*dt+(aa+stinv)*gt-bb*bb*gtm1*rt)
         rtm1=rt
         rt=rtt
         dtm1=dt
         dt=dtt
         gtm1=gt
         gt=gtt
  780 continue
      df=-fmu*stinv+stinv*stinv*dt
      d2f=stinv*stinv*(fmu-2*stinv*dt+stinv*stinv*dt*dt-
     1    stinv*stinv*gt)
      s=fmu-step*gamma
      if (s.le.0.d0) goto 788
      df=df-fmu*gamma/s
      if (d2f.le.0.d0) d2f=rpin(2)
      st=df/d2f
      decr=dsqrt(df*df/d2f)
      st=st/(1.d0+decr)
      stold=step
      step=step-st
      idtot=idtot+1
      goto 778
  788 continue
      step=stold
C-----Dual movement-------------------------------------------------
  666 continue
      do 100 i=1,lnmat
         war(nxd+i)=war(nxd+i)-step*war(nzet+i)
  100 continue
C-----Computing Cholesski factorization of xd----------------- 2 ---
      call schol(kf,iwar(mfr+1),iwar(mbnd+1),war(nxd+1),
     1           war(nrxd+1),icc)
      if (icc.ne.0) then
         ipout(1)=2
         if (feas) then
            ipout(2)=0
         else
            ipout(2)=-4
         endif
         ipout(3)=itr
         goto 9999
      endif
      chok=.true.
C-----Computing xp-------------------------------------------- 3 ---
      irxdf=nrxd
      ixpf=nxp
      do 110 i=1,kf
         l=iwar(mfr+i)
         call inv(l,war(irxdf+1),war(ixpf+1),icc)
         if (icc.ne.0) then
            ipout(1)=3
            if (feas) then
               ipout(2)=0
            else
               ipout(2)=-4
            endif
            ipout(3)=itr
            goto 9999
         endif
         irxdf=nrxd+iwar(mbnd+i)
         ixpf=nxp+iwar(mbnd+i)
  110 continue
C-----Now loop------------------------------------------------------
      goto 40
C-------------------------------------------------------------------
C     TERMINATION
C-------------------------------------------------------------------
 9999 continue
      if (ipout(1).eq.-2) then
         txt='!!! Not enough integer memory'
         call msg(ipin,0,0,txt,mlst,0.0d0)
         txt='Memory in *4 integers should be >= '
         call msg(ipin,0,0,txt,mlst,0.d0)
      endif
      if (ipout(1).eq.-1) then
         txt='!!! Not enough real memory'
         call msg(ipin,0,0,txt,0,0.0d0)
         txt='Memory in *8 reals should be >= '
         call msg(ipin,0,0,txt,nlst,0.0d0)
      endif
      if (feas) then
         do 9998 i=1,n
            xout(i)=war(nrec+i)
 9998    continue
         rpout(1)=rec
      endif
      if (ipout(1).ge.0) then
         txt='*** Reason for termination:'
         call msg(ipin,-1,0,txt,0,0.0d0)
         if (ipout(1).eq.0) then
            txt=' Normal end'
            call msg(ipin,-1,0,txt,0,0.0d0)
         endif
         if (ipout(1).gt.0) then
            txt=' Difficulty # '
            call msg(ipin,0,0,txt,ipout(1),0.0d0)
         endif
         txt='*** Type of result:'
         call msg(ipin,-1,0,txt,0,0.0d0)
         if (ipout(2).eq.1) then
            txt=' Required accuracy ensured'
            call msg(ipin,-1,0,txt,0,0.0d0)
         endif
         if (ipout(2).eq.2) then
            txt=' Optimal solution found'
            call msg(ipin,-1,0,txt,0,0.0d0)
         endif
         if (ipout(2).eq.0) then
            txt=' Feasibility'
            call msg(ipin,-1,0,txt,0,0.0d0)
         endif
         if (ipout(2).eq.-1) then
            txt=' Unfeasibility'
            call msg(ipin,-1,0,txt,0,0.0d0)
         endif
         if (ipout(2).eq.-2) then
            txt=' Below unboundedness'
            call msg(ipin,-1,0,txt,0,0.0d0)
         endif
         if (ipout(2).eq.-3) then
            txt=' Below unboundenness / unfeasibility'
            call msg(ipin,-1,0,txt,0,0.0d0)
         endif
         if (ipout(2).eq.-4) then
            txt=' Nothing found'
            call msg(ipin,-1,0,txt,0,0.0d0)
         endif
         if (ipout(2).ge.0) then
            txt='*** Best value: '
            call msg(ipin,1,0,txt,0,rec)
c           txt='    Absolute accuracy < '
c           call msg(ipin,1,0,txt,0,rec-opb)
         endif

         txt='*** # of iterations: '
         call msg(ipin,0,0,txt,ipout(3),0.0d0)
         if (ipin(5).eq.2) then
            txt='   p-dichotomy steps per iteration: '
            call msg(ipin,1,0,txt,0,dble(float(iptot))/
     & dble(float(ipout(3))))
            txt='   d-Newton steps per iteration: '
            call msg(ipin,1,0,txt,0,dble(float(idtot))/
     & dble(float(ipout(3))))
         endif
      endif
      return
      end
C-----MSG-----------------------------------------------------------
      subroutine msg(ipin,int,iend,txt,nmb,rnmb)
c      double precision rnmb
      double precision rnmb
      dimension ipin(*)
      character *40 txt
      character *20 num
C-------------------------------------------------------------------
C     writes through channel ipin(6) the text "txt" and then
C     integer "nmb" (if int=0), real "rnmb" (if int>0) or nothing
C     (if int<0)
C     if ipin(2)=0 then the same is printed on the screen, provided
C     that iend=0, and if ipin(2)>0, then the output onto the screen
C     does not depend on iend
C-------------------------------------------------------------------
      if (((ipin(5).eq.0).and.(iend.eq.0)).or.(ipin(5).gt.0).or.
     1   ((ipin(5).eq.-2).and.(iend.eq.0))) then
         if (int.eq.0) then
            write(num,'(i20)') nmb
            call msgstxt(txt//num)
         elseif (int.gt.0) then
            write(num,'(e20.13)') rnmb
            call msgstxt(txt//num)
         elseif (int.lt.0) then
            call msgstxt(txt)
         endif
      endif
c      if ((ipin(5).gt.-2).or.(iend.eq.0)) then
c         if (int.eq.0) write(ipin(6),*) txt,nmb
c         if (int.gt.0) write(ipin(6),*) txt,rnmb
c         if (int.lt.0) write(ipin(6),*) txt
c      endif
      return
      end
C-----DIAG----------------------------------------------------------
      subroutine diag(l,ARG,ARG1,RES,DGM,DGU,war,icc)
      implicit double precision (a-h,o-z)
      parameter (one=0.99, maxrep=100)
      dimension ARG(1),ARG1(1),RES(1),DGM(1),DGU(1),war(1)
C-------------------------------------------------------------------
C     ARG is a l.t. part of an l*l symmetric matrix MATR0
C     ARG1 is a l.t. l*l matrix
C     These data define l*l symmetric matrix 
C                      MATR = Trans(ARG1)*MATR0*ARG1
C     RES is a l*l orthogonal matrix such that
C           RES*MATR*Trans(RES)[i,i] = DGM(i), i=1,...,l
C           RES*MATR*Trans(RES)[i,i+1] = DGU(i), i=1,...,l-1
C     and RES*MATR*Trans(RES) is 3-diagonal
C     NOTE: length of war at least 2*l!
C     icc - 0/1 Y/N success
C-------------------------------------------------------------------
      icc=0
      pp=1.d0
      nw1=0
      nw2=l
      RES(1)=1.d0
      do 1 j=2,l
         RES(j)=0.d0
    1 continue
      lp1=l+1
      do 2 i=2,lp1
         nrep=0
         im1=i-1
         im1b=(i-2)*l
         ib=im1b+l
         jk=1
         do 31 j=1,l
            s=0.d0
            do 41 k=1,j
               s=s+ARG1(jk)*RES(im1b+k)
               jk=jk+1
   41       continue
            war(nw1+j)=s
   31    continue
         do 32 j=1,l
            s=0.d0
            do 42 k=1,l
               if (j.ge.k) then
                  jk=k+(j*(j-1))/2
               else
                  jk=j+(k*(k-1))/2
               endif
               s=s+ARG(jk)*war(nw1+k)
   42       continue
            war(nw2+j)=s
   32    continue
         do 33 j=1,l
            s=0.d0
            kj=(j*(j+1))/2
            kjd=j
            do 43 k=j,l
               s=s+ARG1(kj)*war(nw2+k)
               kj=kj+kjd
               kjd=kjd+1
   43       continue
            war(nw1+j)=s
   33    continue
         sc=0.d0
         sn=0.d0
         do 50 j=1,l
            s=war(nw1+j)
            sc=sc+RES(im1b+j)*s
            sn=sn+s*s
            war(nw2+j)=s
   50    continue
         DGM(i-1)=sc
         if (i.eq.lp1) goto 100
         sn=dsqrt(sn)
         if (sn.eq.0) then
            sn=1.d0
            war(nw1+i)=1.d0
            goto 77
         endif
c        sn=1.d0/sn
         do 10 j=1,l
            war(nw1+j)=war(nw1+j)/sn
   10    continue
   77    continue
         nrep=nrep+1
         if (nrep.gt.maxrep) then
            icc=1
            goto 100
         endif
         ifr=0
         do 11 j=1,im1
            s=0.d0
            do 12 k=1,l
               s=s+war(nw1+k)*RES(ifr+k)
   12       continue
            do 13 k=1,l
               war(nw1+k)=war(nw1+k)-RES(ifr+k)*s
   13       continue
            ifr=ifr+l
   11    continue
         sn=0.d0
         do 14 k=1,l
            s=war(nw1+k)
            sn=sn+s*s
   14    continue
         sn=dsqrt(sn)
         if (sn.ge.one) then
c           sn=1.d0/sn
            do 15 k=1,l
               RES(ib+k)=war(nw1+k)/sn
   15       continue
            goto 88
         endif
         if (sn.eq.0.d0) then
            do 16 k=1,l
               s=dcos(pp*dble(float(k)))
               war(nw1+k)=s
               sn=sn+s*s
   16       continue
c           sn=1.d0/dsqrt(sn)
            do 17 k=1,l
               war(nw1+k)=war(nw1+k)/sn
   17       continue
            pp=pp+1.d0
            goto 77
         endif
c        sn=1.d0/sn
         do 18 k=1,l
            war(nw1+k)=war(nw1+k)/sn
   18    continue
         goto 77
   88    continue
         sc=0.d0
         do 19 k=1,l
            sc=sc+war(nw2+k)*RES(ib+k)
   19    continue
         DGU(im1)=sc
    2 continue
  100 continue
      return
      end

C-----SCAL----------------------------------------------------------
      subroutine scal(k,m,ibnd,ARG1,ARG2,sc)
      implicit double precision (a-h,o-z)
      dimension ARG1(1),ARG2(1),m(1),ibnd(1)
C-------------------------------------------------------------------
C     sc = <A1,A2>, where AI from S[m] have ARGI as their l.t. parts
C-------------------------------------------------------------------
      sc=0.d0
      ibf=0
      do 1 ib=1,k
         ij=1
         l=m(ib)
         do 2 i=1,l
            do 3 j=1,i
               if (i.eq.j) then
                  s=0.5d0*ARG1(ibf+ij)*ARG2(ibf+ij)
               else
                  s=ARG1(ibf+ij)*ARG2(ibf+ij)
               endif
               sc=sc+s
               ij=ij+1
    3       continue
    2    continue
         ibf=ibnd(ib)
    1 continue
      sc=2.d0*sc
      return
      end

C-----ABA-----------------------------------------------------------
      subroutine aba(k,m,ibnd,ARG1,ARG2,RES,war)
      implicit double precision (a-h,o-z)
      dimension m(1),ibnd(1),ARG1(1),ARG2(1),RES(1),war(1)
C-------------------------------------------------------------------
C     RES = ARG1*ARG2*ARG1,
C     where ARG1 and ARG2 are from S[m]
C     NOTE: ibnd(i) = SUM(Len(m(j)) | j=1,...,i)
C           length of working array war should be >= (Max(m(*)))^2
C-------------------------------------------------------------------
      ibf=0
      do 1 ib=1,k
         l=m(ib)
         ij=1
         do 2 i=1,l
            do 3 j=1,l
               s=0.d0
               do 4 is=1,l
                  if (i.ge.is) then
                     ia=i
                     isi=is
                  else
                     ia=is
                     isi=i
                  endif
                  if (is.ge.j) then
                     ja=is
                     isj=j
                  else
                     ja=j
                     isj=is
                  endif
                  ifr=isi+(ia*(ia-1))/2
                  isc=isj+(ja*(ja-1))/2
                  s=s+ARG2(ibf+ifr)*ARG1(ibf+isc)
    4          continue
               war(ij)=s
               ij=ij+1
    3       continue
    2    continue
         ij=1
         do 5 i=1,l
            do 6 j=1,i
               s=0.d0
               kj=j
               do 7 is=1,l
                  if (is.le.i) then
                     ik=is+(i*(i-1))/2
                  else
                     ik=i+(is*(is-1))/2
                  endif
                  s=s+ARG1(ibf+ik)*war(kj)
                  kj=kj+l
    7          continue
               RES(ibf+ij)=s
               ij=ij+1
    6       continue
    5    continue
         ibf=ibnd(ib)
    1 continue
      return
      end

C-----MATVEC--------------------------------------------------------
      subroutine mtv(n,mtln,A,b,ARG,t,RES)
      implicit double precision (a-h,o-z)
      dimension A(1),b(1),ARG(1),RES(1)
C-------------------------------------------------------------------
C     RES = [A|b]*(ARG,t),
C     where ARG is from R^n and A acts from R^n into S[m]
C     NOTE: mtln = SUM(Len(m(i)) | i = 1,...,k)
C-------------------------------------------------------------------
      do 1 i=1,mtln
         RES(i)=t*b(i)
    1 continue
      ic=1
      do 2 j=1,n
         do 3 i=1,mtln
            RES(i)=RES(i)+A(ic)*ARG(j)
            ic=ic+1
    3    continue
    2 continue
      return
      end

C-----TMATVEC-------------------------------------------------------
      subroutine tmtv(n,lnmt,k,m,ibnd,A,b,ARG,RES,t)
      implicit double precision (a-h,o-z)
      external scal
      dimension A(1),b(1),ARG(1),RES(1),ibnd(1),m(1)
C-------------------------------------------------------------------
C     (RES,t) = Transp([A|b])*ARG,
C     where  ARG is from S[m] and A acts from R^n into S[m]
C     NOTE: mtln = SUM(Len(m(i)) | i = 1,...,k)
C-------------------------------------------------------------------
      ibf=0 
      do 1 i=1,n
         call scal(k,m,ibnd,A(ibf+1),ARG,sc)
         RES(i)=sc
         ibf=ibf+lnmt
    1 continue
      call scal(k,m,ibnd,b,ARG,sc)
      t=sc
      return
      end

C-----SINV----------------------------------------------------------
      subroutine sinv(k,m,ibnd,ARG,RES,icc)
      implicit double precision (a-h,o-z)
      external inv, chol
      dimension m(1),ibnd(1),ARG(1),RES(1)
C-------------------------------------------------------------------
C     RES = (ARG)^(-1),
C     where ARG is from S[m]
C     NOTE: ibnd(i) = SUM(Len(m(j)) | j=1,...,i),
C           icc 0/1 Y/N success
C-------------------------------------------------------------------
      ibf=0
      do 1 ib=1,k
         l=m(ib)
         call chol(l,ARG(ibf+1),RES(ibf+1),icc)
         if (icc.ne.0) goto 100
         call inv(l,RES(ibf+1),RES(ibf+1),icc)
         if (icc.ne.0) goto 100
         ibf=ibnd(ib)
    1 continue
  100 continue
      return
      end

C-----INV-----------------------------------------------------------
      subroutine inv(l,ARG,RES,icc)
      implicit double precision (a-h,o-z)
      external tinv
      dimension ARG(1),RES(1)
C-------------------------------------------------------------------
C     RES is the l.t. part of (ARG*Trans(ARG))^(-1),
C     where ARG is l.t. l*l matrix
C     NOTE: icc 0/1 Y/N success
C-------------------------------------------------------------------
      call tinv(l,ARG,RES,icc)
      if (icc.ne.0) goto 100
      do 1 j=1,l
         do 2 i=j,l
            s=0.d0
            ii=(i*(i+1))/2
            ij=ii+j-i
            ki=ii
            kj=ij
            do 3 k=i,l
               s=s+RES(ki)*RES(kj)
               ki=ki+k
               kj=kj+k
    3       continue
            RES(ij)=s
    2    continue
    1 continue
  100 continue
      return
      end

C-----TINV----------------------------------------------------------
      subroutine tinv(l,ARG,RES,icc)
      implicit double precision (a-h,o-z)
      dimension ARG(1),RES(1)
C-------------------------------------------------------------------
C     RES = (ARG)^(-1),
C     where ARG is l.t. l*l matrix
C     NOTE: icc 0/1 Y/N success
C-------------------------------------------------------------------
      icc=0
      ii=0
      do 1 i=1,l
         ii=ii+i
         s=ARG(ii)
         if (s.eq.0.d0) then
            icc=1
            goto 100
         endif
         s=1.d0/s
         RES(ii)=s
         im1=i-1
         do 2 j=1,im1
            s1=0.d0
            ik=j+(i*(i-1))/2
            kj=(j*(j+1))/2
            kjd=j
            do 3 k=j,im1
               s1=s1+ARG(ik)*RES(kj)
               ik=ik+1
               kj=kj+kjd
               kjd=kjd+1
    3       continue
            RES(kj)=-s1*s
    2    continue
    1 continue
  100 continue
      return
      end

C-----SCHOL---------------------------------------------------------
      subroutine schol(k,m,ibnd,ARG,RES,icc)
      implicit double precision (a-h,o-z)
      external chol
      dimension m(1),ibnd(1),ARG(1),RES(1)
C-------------------------------------------------------------------
C     RES: l.t. element of Cholesski factorization of ARG
C     where ARG is from S[m]
C     NOTE: ibnd(i) = SUM(Len(m(j)) | j=1,...,i),
C           icc 0/1 Y/N success
C-------------------------------------------------------------------
      ibf=0
      do 1 ib=1,k
         l=m(ib)
         call chol(l,ARG(ibf+1),RES(ibf+1),icc)
         if (icc.ne.0) goto 100
         ibf=ibnd(ib)
    1 continue
  100 continue
      return
      end


C-----CHOL----------------------------------------------------------
      subroutine chol(l,ARG,RES,icc)
      implicit double precision (a-h,o-z)
      dimension ARG(1),RES(1)
      logical trial
C-------------------------------------------------------------------
C     RES is l.t. matrix such that ARG is l.t. part
C     of the l*l matrix RES*Trans(RES)
C     NOTE: icc 0/1 Y/N success
C-------------------------------------------------------------------
      trial=.true.
      icc=0
      ii=0
      do 1 i=1,l
         ii=ii+i
         s=ARG(ii)
         im1=i-1
         ip1=i+1
         do 2 j=1,im1
            s0=RES(ii-j)
            s=s-s0*s0
    2    continue
         if (s.le.0.d0) then
            icc=1
            goto 100
         endif
         s=DSQRT(s)
         RES(ii)=s
         s=1.d0/s
         kid=i
         ki=ii+kid
         do 3 k=ip1,l
            st=ARG(ki)
            do 4 is=1,im1
               st=st-RES(ii-is)*RES(ki-is)
    4       continue
            RES(ki)=st*s
            kid=kid+1
            ki=ki+kid
    3    continue
    1 continue
  100 continue
      return
      end

C-----LTR------------------------------------------------------
      subroutine ltr(l,A,RH,SOL)
      implicit double precision (a-h,o-z)
      dimension A(1),RH(1),SOL(1)
C--------------------------------------------------------------
C     SOL: A*SOL = RH,
C     where A is a l.t. l*l matrix
C--------------------------------------------------------------
      ij=1
      do 1 i=1,l
         s=0.d0
         im1=i-1
         do 2 j=1,im1
            s=s+A(ij)*SOL(j)
            ij=ij+1
    2    continue
         SOL(i)=(RH(i)-s)/A(ij)
         ij=ij+1
    1 continue
      return
      end

C-----UTR------------------------------------------------------
      subroutine utr(l,A,RH,SOL)
      implicit double precision (a-h,o-z)
      dimension A(1),RH(1),SOL(1)
C--------------------------------------------------------------
C     SOL: Trans(A)*SOL = RH,
C     where A is a l.t. l*l matrix
C--------------------------------------------------------------
      ii=(l*(l+1))/2
      do 1 im=1,l
         i=l-im+1
         s=0.d0 
         ip1=i+1
         jid=i
         ji=ii+jid
         do 2 j=ip1,l
            s=s+SOL(j)*A(ji)
            jid=jid+1
            ji=ji+jid
    2    continue
         SOL(i)=(RH(i)-s)/A(ii)
         ii=ii-i
    1 continue
      return
      end
C-----MATVEC1-------------------------------------------------------
      subroutine mtv1(n,mtln,A,b,Q,p,al,ARG,t,RES)
      implicit double precision (a-h,o-z)
      dimension A(1),b(1),Q(1),p(1),ARG(1),RES(1)
C-------------------------------------------------------------------
C     RES = [A|b|al*A-Q|al*b-p]*(ARG,t)
C-------------------------------------------------------------------
      mtl=mtln/2
      do 1 i=1,mtl
         RES(i)=t*b(i)
         RES(mtl+i)=al*RES(i)-t*p(i)
    1 continue
      ij=1
      do 2 j=1,n
         do 3 i=1,mtl
            s=A(ij)*ARG(j)
            RES(i)=RES(i)+s
            RES(i+mtl)=RES(i+mtl)+al*s-Q(ij)*ARG(j)
            ij=ij+1
    3    continue
    2 continue
      return
      end

C-----TMATVEC1------------------------------------------------------
      subroutine tmtv1(n,mtln,k,m,ibnd,A,b,Q,p,al,ARG,RES,t)
      implicit double precision (a-h,o-z)
      external scal
      dimension A(1),b(1),Q(1),p(1),ARG(1),RES(1),m(1),ibnd(1)
C-------------------------------------------------------------------
C     (RES,t) = Trans{[A|b|al*A-Q|al*b-p]}*ARG
C-------------------------------------------------------------------
      mtl=mtln/2
      ibf=0
      do 1 j=1,n
         call scal(k,m,ibnd,A(ibf+1),ARG,sc)
         s=sc
         call scal(k,m,ibnd,A(ibf+1),ARG(mtl+1),sc)
         call scal(k,m,ibnd,Q(ibf+1),ARG(mtl+1),sc1)
         s=s+al*sc-sc1
         RES(j)=s
         ibf=ibf+mtl
    1 continue
      call scal(k,m,ibnd,b,ARG,s)
      call scal(k,m,ibnd,b,ARG(mtl+1),sc)
      call scal(k,m,ibnd,p,ARG(mtl+1),sc1)
      t=s+al*sc-sc1
      return
      end
