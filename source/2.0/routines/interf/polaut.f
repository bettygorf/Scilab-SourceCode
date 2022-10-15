      subroutine polaut
c ====================================================================
c      calculs sur les polynomes/automatque
c ====================================================================
c
      include '../stack.h'
      integer adr
c
      integer vol1,vol2,vol3,var(4)
      double precision v,eps,errl2,phi,gnrm
      logical all
      common/no2f/gnrm
      common/arl2c/info,ierr
c
      if (ddt .eq. 4) write(wte,1000) fin
 1000 format(1x,'polaut',i4)
c
c     functions/fin
c     1    2   3    4    5
c   arl2 resi ldiv     
c
      if(top+lhs-rhs.ge.bot) then
         call error(18)
         return
      endif
      if(rhs.le.0) then
         call error(39)
         return
      endif
c
      eps=stk(leps)
c
      lw=lstk(top+1)
c
      il1=adr(lstk(top+1-rhs),0)
      if(istk(il1).gt.2) then
         err=1
         call error(44)
         return
      endif
      m1=istk(il1+1)
      n1=istk(il1+2)
      it1=istk(il1+3)
      mn1=m1*n1
      if(istk(il1).eq.1) goto 01
      id1=il1+8
      vol1=istk(id1+mn1)-1
      l1r=adr(id1+mn1+1,1)
      l1i=l1r+vol1
      goto 05
   01 id1=adr(lw,0)
      l1r=adr(il1+4,1)
      l1i=l1r+mn1
      lw=adr(id1+mn1+1,1)
      err=lw-lstk(bot)
      if(err.gt.0) then
         call error(17)
         return
      endif
      do 02 i=1,mn1
   02 istk(id1+i-1)=i
      istk(id1+mn1)=mn1+1
      vol1=mn1
c
   05 goto (80,20,40,99,99) fin
c
c residu
  20  continue
      if(rhs.ne.3.or.lhs.ne.1) then
         call error(39)
         return
      endif
c
      il2=adr(lstk(top+2-rhs),0)
      if(istk(il2).gt.2) then
         err=1
         call error(54)
         return
      endif
      m2=istk(il2+1)
      n2=istk(il2+2)
      it2=istk(il2+3)
      mn2=m2*n2
      if(istk(il2).eq.1) goto 21
      id2=il2+8
      vol2=istk(id2+mn2)-1
      l2r=adr(id2+mn2+1,1)
      l2i=l2r+vol2
      goto 25
   21 id2=adr(lw,0)
      l2r=adr(il2+4,1)
      l2i=l2r+mn2
      lw=adr(id2+mn2+1,1)
      err=lw-lstk(bot)
      if(err.gt.0) then
         call error(17)
         return
      endif
      do 22 i=1,mn2
   22 istk(id2+i-1)=i
      istk(id2+mn2)=mn2+1
      vol2=mn2
c
   25 il3=adr(lstk(top+3-rhs),0)
      if(istk(il3).gt.2) then
         err=3
         call error(54)
         return
      endif
      m3=istk(il3+1)
      n3=istk(il3+2)
      it3=istk(il3+3)
      mn3=m3*n3
      if(istk(il3).eq.1) goto 26
      id3=il3+8
      vol3=istk(id3+mn3)-1
      l3r=adr(id3+mn3+1,1)
      l3i=l3r+vol3
      goto 30
   26 id3=adr(lw,0)
      l3r=adr(il3+4,1)
      l3i=l3r+mn3
      lw=adr(id3+mn3+1,1)
      err=lw-lstk(bot)
      if(err.gt.0) then
         call error(17)
         return
      endif
      do 27 i=1,mn3
   27 istk(id3+i-1)=i
      istk(id3+mn3)=mn3+1
      vol3=mn3
c
   30 if(m1.ne.m2.or.m1.ne.m3.or.n1.ne.n2.or.n1.ne.n3) then
         call error(60)
         return
      endif
      top=top+1-rhs
      if(it1+it2+it3.ne.0) goto 35
      lr=l1r
      do 31 k=1,mn1
      nd1=istk(id1+k)-istk(id1+k-1)
      nd2=istk(id2+k)-istk(id2+k-1)
      nd3=istk(id3+k)-istk(id3+k-1)
      call residu(stk(l1r),nd1-1,stk(l2r),nd2-1,stk(l3r),nd3-1,v,
     1             eps,ierr)
      if(ierr.gt.0) then
         call error(27)
         return
      endif
      stk(lr)=v
      l1r=l1r+nd1
      l2r=l2r+nd2
      l3r=l3r+nd3
      lr=lr+1
   31 continue
      l1=adr(il1+4,1)
      call dcopy(mn1,stk(lr-mn1),1,stk(l1),1)
      istk(il1)=1
      lstk(top+1)=l1+mn1
      goto 99
c
   35 if(it1.eq.0) then
                       l1i=lw
                       lw=l1i+vol1
                       err=lw-lstk(bot)
                       if(err.gt.0) then
                          call error(17)
                          return
                       endif
                       call dset(vol1,0.0d+0,stk(l1i),1)
      endif
      if(it2.eq.0) then
                       l2i=lw
                       lw=l2i+vol2
                       err=lw-lstk(bot)
                       if(err.gt.0) then
                          call error(17)
                          return
                       endif
                       call dset(vol2,0.0d+0,stk(l2i),1)
      endif
      if(it3.eq.0) then
                       l3i=lw
                       lw=l3i+vol3
                       err=lw-lstk(bot)
                       if(err.gt.0) then
                          call error(17)
                          return
                       endif
                       call dset(vol3,0.0d+0,stk(l3i),1)
      endif
      lr=lw
      lw=lr+mn1*2
      err=lw-lstk(bot)
      if(err.gt.0) then
         call error(17)
         return
      endif
      do 36 k=1,mn1
      nd1=istk(id1+k)-istk(id1+k-1)
      nd2=istk(id2+k)-istk(id2+k-1)
      nd3=istk(id3+k)-istk(id3+k-1)
      call wesidu(stk(l1r),stk(l1i),nd1-1,stk(l2r),stk(l2i),nd2-1,
     &         stk(l3r),stk(l3i),nd3-1,stk(lr+k-1),stk(lr+mn1+k-1),
     &         eps,ierr)
      if(ierr.gt.0) then
         call error(27)
         return
      endif
      l1r=l1r+nd1
      l1i=l1i+nd1
      l2r=l2r+nd2
      l2i=l2i+nd2
      l3r=l3r+nd3
      l3i=l3i+nd3
   36 continue
      l1=adr(il1+4,1)
      call dcopy(mn1*2,stk(lr),1,stk(l1),1)
      istk(il1)=1
      istk(il1+1)=m1
      istk(il1+2)=n1
      istk(il1+3)=1
      lstk(top+1)=l1+mn1*2
      goto 99
c
c
c ldiv
  40  continue
      if(rhs.ne.3.or.lhs.ne.1) then
         call error(39)
         return
      endif
c
      il2=adr(lstk(top+2-rhs),0)
      if(istk(il2).gt.2) then
         err=2
         call error(54)
         return
      endif
      m2=istk(il2+1)
      n2=istk(il2+2)
      it2=istk(il2+3)
      if(it2.ne.0) then
         err=2
         call error(52)
         return
      endif
      mn2=m2*n2
      if(istk(il2).eq.1) goto 41
      id2=il2+8
      vol2=istk(id2+mn2)-1
      l2r=adr(id2+mn2+1,1)
      l2i=l2r+vol2
      goto 45
   41 id2=adr(lw,0)
      l2r=adr(il2+4,1)
      l2i=l2r+mn2
      lw=adr(id2+mn2+1,1)
      err=lw-lstk(bot)
      if(err.gt.0) then
         call error(17)
         return
      endif
      do 42 i=1,mn2
   42 istk(id2+i-1)=i
      istk(id2+mn2)=mn2+1
      vol2=mn2
c
      if(m2.ne.m1.or.n2.ne.n1) then
         call error(60)
         return
      endif
      if(it1.ne.0) then
         err=1
         call error(52)
         return
      endif
c
   45 il3=adr(lstk(top+3-rhs),0)
      if(istk(il3).ne.1) then
         err=3
         call error(53)
         return
      endif
      l3=adr(il3+4,1)
      nmax=stk(l3)
c
      lr=lw
      err=lw+nmax*mn1-lstk(bot)
      if(err.gt.0) then
         call error(17)
         return
      endif
c
      do 46 k=1,mn1
      nd1=istk(id1+k)-istk(id1+k-1)
      nd2=istk(id2+k)-istk(id2+k-1)
      call dtild(nd1,stk(l1r),1)
      call dtild(nd2,stk(l2r),1)
      call expan(stk(l2r),nd2,stk(l1r),nd1,stk(lr),nmax)
      l2r=l2r+nd2
      l1r=l1r+nd1
      lr=lr+nmax
   46 continue
      l1=adr(il1+4,1)
      call dcopy(nmax*mn1,stk(lw),1,stk(l1),1)
      istk(il1)=1
      istk(il1+1)=m1*nmax
      istk(il1+2)=n1
      top=top-rhs+lhs
      lstk(top+1)=l1+nmax*mn1
      goto 99
c
c arl2
   80 continue
      all=.false.
      il=adr(lstk(top),0)
      if(istk(il).eq.10) then
         all=.true.
         top=top-1
         rhs=rhs-1
      endif
      if(rhs.lt.3.or.rhs.gt.4) then
         call error(39)
         return
      endif
      info=0
      if(rhs.eq.4) then
           il=adr(lstk(top),0)
           if(istk(il).ne.1) then
              err=4
              call error(53)
              return
           endif
           l=adr(il+4,1)
           if(stk(l).lt.0.0d+0) then
              err=4
              call error(36)
              return
           endif
           info=int(stk(l))
           top=top-1
      endif
      il=adr(lstk(top),0)
      if(istk(il).ne.1) then
         err=3
         call error(53)
         return
      endif
      l=adr(il+4,1)
      if(stk(l).lt.1.0d+0) then
         err=3
         call error(36)
         return
      endif
      itmax=int(stk(l))
c
      top=top-1
      lw=lstk(top+1)
      ild=adr(lstk(top),0)
      if(istk(ild).ne.2) then
         err=2
         call error(54)
         return
      endif
      if(istk(ild+3).ne.0) then
         err=2
         call error(52)
         return
      endif
      if(istk(ild+1)*istk(ild+2).ne.1) then
         err=2
         call error(36)
         return
      endif
      call icopy(4,istk(ild+4),1,var,1)
      nd=istk(ild+9)-2
      ld=adr(ild+10,1)
      call idegre(stk(ld),istk(ild+9)-2,nd)
      call dscal(nd+1,1.0d+0/stk(ld+nd),stk(ld),1)
c
      if(it1.ne.0) then
         err=1
         call error(52)
         return
      endif
      nf=mn1
      if(istk(il1).eq.2) then
                        if(mn1.ne.1) then
                           err=1
                           call error(43)
                           return
                        endif
                        nf=istk(id1+mn1)-1
      endif
      if (nf.gt.600) then
         buf='600 points au maximun'
         call error(999)
         return
      endif
      lf=l1r
      ilf=il1
      if(all) then
         mxsol=20
         lw=ld+(itmax+1)*mxsol
         ilw=adr(lw+itmax**2+32*itmax+25+4*(itmax+1)*mxsol,0)
         err=adr(ilw+20+itmax+2*mxsol,1)-lstk(bot)
      else
         ln=ld+itmax+1
         lw=ln+itmax+1
         ilw=adr(lw+itmax**2+29*itmax+24,0)
         err=adr(ilw+20+itmax,0)-lstk(bot)
      endif
      if(err.gt.0) then
         call error(17)
         return
      endif
c
c
      if(all) goto 82
      call arl2(stk(lf),nf,stk(ln),stk(ld),nd,itmax,errl2,stk(lw),
     1       istk(ilw),info,ierr,wte)
      if(ierr.ne.0) then
         if(ierr.eq.3) then
            buf='arl2 : boucle indesirable sur 2 ordres'
         else if(ierr.eq.4) then
            buf='arl2 : plantage de l''integrateur'
         else if(ierr.eq.5) then
            buf='arl2 : plantage dans la recherche de ' //
     +          'l''intersection avec une face'
         else if(ierr.eq.7) then
            buf='arl2 : trop de solutions'
         endif
         call error(999)
      endif
      call icopy(4,var,1,istk(ilf+4),1)
      istk(ilf+8)=1
      istk(ilf+9)=1+itmax+1
      l=adr(ilf+10,1)
      call dcopy(itmax+1,stk(ld),1,stk(l),1)
      istk(ilf)=2
      istk(ilf+1)=1
      istk(ilf+2)=1
      l=l+itmax+1
      lstk(top)=l+1
      if(lhs.eq.1) goto 99
      il=adr(lstk(top),0)
      istk(il)=2
      istk(il+1)=1
      istk(il+2)=1
      istk(il+3)=0
      call icopy(4,var,1,istk(il+4),1)
      istk(il+8)=1
      istk(il+9)=1+itmax
      l=adr(il+10,1)
      call dcopy(itmax,stk(ln),1,stk(l),1)
      lstk(top+1)=l+itmax
      if(lhs.eq.2) goto 99
c
      top=top+1
      il=adr(lstk(top),0)
      istk(il)=1
      istk(il+1)=1
      istk(il+2)=1
      istk(il+3)=0
      l=adr(il+4,1)
      stk(l)=errl2
      lstk(top+1)=l+1
      goto 99
c
 82   continue
      call arl2a(stk(lf),nf,stk(ld),mxsol,nsol,itmax,info,ierr,wte,
     $     stk(lw),istk(ilw))
      if(ierr.ne.0) then
         if(ierr.eq.3) then
            buf='arl2 : boucle indesirable sur 2 ordres'
         else if(ierr.eq.4) then
            buf='arl2 : plantage de l''integrateur'
         else if(ierr.eq.5) then
            buf='arl2 : plantage dans la recherche de ' //
     +          'l''intersection avec une face'
         else if(ierr.eq.7) then
            buf='arl2 : trop de solutions'
         endif
         call error(999)
      endif
c on recupere les denominateurs
      call icopy(4,var,1,istk(ilf+4),1)
      istk(ilf+8)=1
      do 83 is=1,nsol
         istk(ilf+8+is)=istk(ilf+7+is)+itmax+1
 83   continue
      l=adr(ilf+9+nsol,1)
      l0=l
      do 84 is=1,nsol
      call dcopy(itmax,stk(ld-1+is),mxsol,stk(l),1)
      stk(l+itmax)=1.0d0
      l=l+itmax+1
 84   continue
      istk(ilf)=2
      istk(ilf+1)=nsol
      istk(ilf+2)=1
      lstk(top)=l+1
      if(lhs.eq.1) goto 99
c on recupere les numerateurs
      il=adr(lstk(top),0)
      istk(il)=2
      istk(il+1)=nsol
      istk(il+2)=1
      istk(il+3)=0
      call icopy(4,var,1,istk(il+4),1)
      istk(il+8)=1
      do 85 is=1,nsol
         istk(il+8+is)=istk(il+7+is)+itmax
 85   continue
      l=adr(il+9+nsol,1)
      lw=l+itmax*nsol+1
      gnrm=sqrt(gnrm)
      l1=l0
      do 86 is=1,nsol
      call lq(itmax,stk(l1),stk(l),stk(lw))
      call dscal(itmax,gnrm,stk(l),1)
      l1=l1+itmax+1
      l=l+itmax
 86   continue
      lstk(top+1)=l+1
      if(lhs.eq.2) goto 99
c on recupere les erreurs
      top=top+1
      il=adr(lstk(top),0)
      istk(il)=1
      istk(il+1)=nsol
      istk(il+2)=1
      istk(il+3)=0
      l=adr(il+4,1)
      l1=l0
      do 87 i=1,nsol
      stk(l)=sqrt(phi(stk(l1),itmax))*gnrm
      l1=l1+itmax+1
      l=l+1
 87   continue
      lstk(top+1)=l+1
      goto 99
c
   99 return
      end
