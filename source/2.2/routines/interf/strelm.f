      subroutine strelm
c ====================================================================
c
c evaluation des fonctions elementaires sur les chaines de caracteres
c
c ====================================================================
c
      INCLUDE '../stack.h'
c
      logical lgq
      integer blank,eol,vol
c
      integer iadr,sadr
      data    blank/40/,eol/99/,nclas/29/
c
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
c
      if (ddt .eq. 4) then
         write(buf(1:4),'(i4)') fin
         call basout(io,wte,' strelm '//buf(1:4))
      endif
c
c     functions/fin
c     1       2       3       4       5           6       7       8
c   length    part   string  convstr  emptystr str2code code2str
c
c
      goto (10,20,25,50,60,70,80) fin
c
c     length
c
   10 if(lhs*rhs.ne.1) then
         call error(39)
         return
      endif
      il1=iadr(lstk(top+1-rhs))
      itype=istk(il1)
      if(itype.eq.1.or.itype.eq.2.or.itype.eq.4) then
c     length( )=prod(size( )) for matrices (+ polynomial and boolean)
         l=sadr(il1+4)
         stk(l)=dble(istk(il1+1)*istk(il1+2))
         istk(il1)=1
         istk(il1+1)=1
         istk(il1+2)=1
         istk(il1+3)=0
         lstk(top+1)=l+1
      elseif(itype.eq.15.or.itype.eq.16) then
c     length(list)=size(list)
         l=sadr(il1+4)
         stk(l)=dble(istk(il1+1))
         istk(il1)=1
         istk(il1+1)=1
         istk(il1+2)=1
         istk(il1+3)=0
         lstk(top+1)=l+1
      elseif(itype.eq.10) then
         m1=istk(il1+1)
         n1=istk(il1+2)
         mn1=m1*n1
         id1=il1+4
         l1=sadr(id1+mn1+1)
         vol=istk(id1+mn1)-1
         lw=lstk(top+1)
c
         l=sadr(il1+4)
         do 11 k=1,mn1
            stk(l1-1+k)=dble(istk(id1+k)-istk(id1+k-1))
 11      continue
         call dcopy(mn1,stk(l1),1,stk(l),1)
         lstk(top+1)=l+mn1
         istk(il1)=1
         istk(il1+3)=0
      else
         err=1
         call error(55)
         return
      endif
      goto 999
c
c part
   20 if(lhs.ne.1.or.rhs.ne.2) then
         call error(39)
         return
      endif
      il1=iadr(lstk(top+1-rhs))
      if(istk(il1).ne.10) then
         err=1
         call error(55)
         return
      endif
c
      m1=istk(il1+1)
      n1=istk(il1+2)
      mn1=m1*n1
      id1=il1+4
      l1=id1+mn1+1
      vol=istk(id1+mn1)-1
      lw=lstk(top+1)
c
      lr=iadr(lw)
      ilv=iadr(lstk(top))
      if(istk(ilv).ne.1) then
         err=rhs
         call error(53)
         return
      endif
      if(istk(ilv+1).gt.1.and.istk(ilv+2).gt.1) then
         err=rhs
         call error(89)
         return
      endif
      if(istk(ilv+3).ne.0) then
         err=rhs
         call error(52)
         return
      endif
      nv=istk(ilv+1)*istk(ilv+2)
      if(nv.eq.0) then
         call iset(mn1+1,1,istk(id1),1)
         top=top-1
         lstk(top+1)=sadr(l1)
         goto 999
      endif
      lv=sadr(ilv+4)
      do 21 k=0,nv-1
         if(int(stk(lv+k)).le.0) then
            err=2
            call error(36)
            return
         endif
 21   continue
      err=sadr(lr+mn1*nv)-lstk(bot)
      if(err.gt.0) then
         call error(17)
         return
      endif
      call iset(mn1*nv,blank,istk(lr),1)
      lrijk=lr
      lij=l1
      do 23 ij=1,mn1
      nij=istk(id1+ij)-istk(id1+ij-1)
      do 22 k=1,nv
      mv=int(stk(lv-1+k))
      if(mv.gt.nij) goto 22
      istk(lrijk)=istk(lij-1+mv)
 22   lrijk=lrijk+1
      lij=lij+nij
 23   continue
c
      istk(id1)=1
      do 24 ij=1,mn1
      istk(id1+ij)=istk(id1+ij-1)+nv
 24   continue
      top=top-1
      call icopy(mn1*nv,istk(lr),1,istk(l1),1)
      lstk(top+1)=sadr(l1+istk(id1+mn1))
      goto 999
c
c string
c
  25  continue
      if(rhs.ne.1) then
         call  error(39)
         return
      endif
      il=iadr(lstk(top))
      lw=iadr(lstk(top+1))
      if(istk(il).eq.10) goto 999
      if(istk(il).eq.1) then
c
c     conversion d'une matrice de scalaires
c     -------------------------------------
         if(lhs*rhs.ne.1) then
            call error(39)
            return
         endif
         m=istk(il+1)
         n=istk(il+2)
         if(m*n.eq.0) goto 999
         it=istk(il+3)
         l=sadr(il+4)
         err=sadr(lw+m*n*(2*lct(7)+4))-lstk(bot)
         if(err.gt.0) then
            call error(17)
            return
         endif
         lstr=lw+m*n+1
         if(it.eq.0) call cvdm(stk(l),m,m,n,lct(7),lct(6),
     1        istk(lstr),istk(lw))
         if(it.eq.1) call cvwm(stk(l),stk(l+m*n),m,m,n,lct(7),lct(6),
     1        istk(lstr),istk(lw))
         nstr=istk(lw+m*n)-1
         call icopy(m*n+1+nstr,istk(lw),1,istk(il+4),1)
         istk(il)=10
         istk(il+3)=0
         lstk(top+1)=sadr(il+5+m*n+nstr)
         goto 999
      elseif(abs(istk(il)).eq.11.or.abs(istk(il)).eq.13) then
c
c     conversion d'une macro non compilee
c     -----------------------------------
         l=istk(il+1)
         if(istk(il).lt.0) il=iadr(lstk(l))
         ilm=il
c
         if(lhs.ne.3) then
            call error(41)
            return
         endif
c     generation du vecteur des variables de sorties/puis d'entree
         il=il+1
c     Ligne suivante ajoutee : c'etait un bug, mais pourquoi ca marchait
c     parfois avant ? ? ?
         lw=lstk(top+1)
         do 37 i=1,2
            n=istk(il)
            il=il+1
            ilio=iadr(lw)
            istk(ilio)=10
            if(n.eq.0) istk(ilio)=1
            istk(ilio+1)=min(1,n)
            istk(ilio+2)=n
            istk(ilio+3)=0
            ilp=ilio+4
            istk(ilp)=1
            l=ilp+n
            if (n.eq.0) goto 35
            do 34 j=1,n
               call namstr(istk(il),istk(l+1),nn,1)
               l=l+nn
               istk(ilp+j)=l+1-(ilp+n)
               il=il+nsiz
 34         continue
 35         if(i.eq.1) then
               lout=lw
            else
               llin=lw
            endif
            lw=sadr(l+1)
 37      continue
c
c
         if(istk(ilm).eq.13) then
            ltxt=lw
            ilt=iadr(ltxt)
            istk(ilt)=1
            istk(ilt+2)=0
            istk(ilt+3)=0
            istk(ilt+4)=1
            ilt=ilt+4
            goto 43
         endif
         ltxt=lw
         ilt=iadr(ltxt)
         istk(ilt)=10
         istk(ilt+2)=1
         istk(ilt+3)=0
         istk(ilt+4)=1
         ilp=ilt+4
c     
c     calcul du nombre de lignes de la macro
         nch=istk(il)
         nl=0
         il=il+1
         l=il-1
 39      l=l+1
         if(istk(l).eq.eol) then
            if(istk(l+1).eq.eol) goto 40
            nl=nl+1
         endif
         goto 39
c
 40      continue
         istk(ilt+1)=nl
         if(nl.eq.0) then
            istk(ilt)=1
            istk(ilt+2)=0
            ilt=ilt+3
            goto 43
         endif
         ilt=ilp+nl+1
         l=il
 41      if(istk(l).eq.eol) goto 42
         l=l+1
         goto 41
 42      if(istk(l+1).eq.eol) goto 43
         n=l-il
         ilp=ilp+1
         istk(ilp)=istk(ilp-1)+n
         call icopy(n,istk(il),1,istk(ilt),1)
         ilt=ilt+n
         il=l+1
         l=il
         goto 41
c
 43      continue
         lw=sadr(ilt+1)
c     on remet la pile en forme
         if(lhs.eq.3) then
            n=llin-lout
            call dcopy(n,stk(lout),1,stk(lstk(top)),1)
            lstk(top+1)=lstk(top)+n+1
            top=top+1
            n=ltxt-llin
            call dcopy(n,stk(llin),1,stk(lstk(top)),1)
            lstk(top+1)=lstk(top)+n+1
            top=top+1
         endif
         n=lw-ltxt
         call dcopy(n,stk(ltxt),1,stk(lstk(top)),1)
         lstk(top+1)=lstk(top)+n+1
         goto 999
      elseif(istk(il).eq.14) then
c     librairies
         if(lhs*rhs.ne.1) then
            call error(39)
            return
         endif
         ilr=lw
         il0=il
         n1=istk(il+1)
         l1=il+2
         il=il+n1+2
         n=istk(il)
         il=il+nclas+2

         err=sadr(ilr+6+n1+(nlgh+1)*n)-lstk(bot)
         if(err.gt.0) then
            call error(17)
            return
         endif
         istk(ilr)=10
         istk(ilr+1)=n+1
         istk(ilr+2)=1
         istk(ilr+3)=0
         istk(ilr+4)=1
         l=ilr+6+n
         call icopy(n1,istk(l1),1,istk(l),1)
         istk(ilr+5)=1+n1
         l=l+n1
         do 49  k=1,n
           call namstr(istk(il),istk(l),nn,1)
           istk(ilr+5+k)=istk(ilr+4+k)+nn
           l=l+nn
           il=il+nsiz
 49     continue
        call icopy(l-ilr,istk(ilr),1,istk(il0),1)
        lstk(top+1)=sadr(il0+l-ilr)
        goto 999
      else
         err=1
         call error(44)
         return
      endif
c
c -------
c convstr
c -------
c
   50 continue
      if(rhs.gt.2.or.rhs.lt.1) then
         call error(39)
         return
      endif
      lgq=.false.
      if(rhs.eq.1) goto 51
c
c deuxieme parametre
c
      il1=iadr(lstk(top))
      if(istk(il1).ne.10) then
         err=2
         call error(55)
         return
      endif
      if(istk(il1+1).ne.1.or.istk(il1+2).ne.1) then
         err=2
         call error(89)
         return
      endif
      if(abs(istk(il1+6)).eq.30) then
         lgq=.true.
      elseif(abs(istk(il1+6)).ne.21) then
         err=2
         call error(36)
         return
      endif
      top=top-1
c
c premier parametre
c
   51 continue
      il1=iadr(lstk(top))
      if(istk(il1).ne.10) then
         err=1
         call error(55)
         return
      endif
      m1=istk(il1+1)
      n1=istk(il1+2)
      if (lgq) goto 53
c
c conversion en minuscule
c
      k=iadr(lstk(top+1))-1
      do 52 i=il1+5,k
         if(istk(i).lt.-35.or.istk(i).gt.-10) goto 52
         istk(i)=-istk(i)
   52 continue
      goto 999
c
c conversion en majuscule
c
   53 continue
      k0=il1+4
      k =k0+m1*n1
      do 55 i=1,m1*n1
        k1=istk(k0+1)-istk(k0)
        k0=k0+1
        do 54 l=1,k1
          k=k+1
          if(istk(k).lt.10.or.istk(k).gt.35) goto 54
          istk(k)=-istk(k)
   54   continue
   55 continue
      goto 999
c
c     emptystr
 60   continue
      if(rhs.eq.2) then
         il=iadr(lstk(top))
         if(istk(il).ne.1) then
            err=2
            call error(53)
            return
         endif
         if(istk(il+1)*istk(il+2).ne.1) then
            err=2
            call error(89)
            return
         endif
         if(istk(il+3).ne.0) then
            err=2
            call error(52)
            return
         endif
         n=int(stk(sadr(il+4)))
         top=top-1
c
         il=iadr(lstk(top))
         if(istk(il).ne.1) then
            err=1
            call error(53)
            return
         endif
         if(istk(il+1)*istk(il+2).ne.1) then
            err=1
            call error(89)
            return
         endif
         if(istk(il+3).ne.0) then
            err=1
            call error(52)
            return
         endif
         m=int(stk(sadr(il+4)))
      elseif(rhs.eq.1) then
         il=iadr(lstk(top))
         if(istk(il).gt.10) then
            err=1
            call error(44)
            return
         endif
         if(istk(il+3).ne.0) then
            err=1
            call error(52)
            return
         endif
         m=istk(il+1)
         n=istk(il+2)
         if(m*n.eq.0) return
      elseif(rhs.le.0) then
         m=1
         n=1
         top=top+1
      else
         call error(58)
         return
      endif
      if(lhs.ne.1) then 
         call error(59)
         return
      endif
      il=iadr(lstk(top))
      istk(il)=10
      istk(il+1)=m
      istk(il+2)=n
      istk(il+3)=0
      call iset(m*n+1,1,istk(il+4),1)
      lstk(top+1)=sadr(il+6+m*n)
      goto 999 
c     
c     str2code
 70   if (rhs .ne. 1) then
         call error(39)
         return
      endif
      if (lhs .ne. 1) then
         call error(41)
         return
      endif
c     checking variable str (number 1)
c       
      il1 = iadr(lstk(top-rhs+1))
      if (istk(il1) .ne. 10) then
         err = 1
         call error(55)
         return
      endif
      if (istk(il1+1)*istk(il1+2) .ne. 1) then
         err = 1
         call error(89)
         return
      endif
      n1 = istk(il1+5)-1
      l1 = il1+6
      call icopy(n1,istk(l1),1,istk(l1-2),1)
      l1=sadr(il1+4)
      call int2db(n1,istk(il1+4),-1,stk(l1),-1)
      istk(il1)=1
      istk(il1+1)=n1
      istk(il1+2)=1
      istk(il1+3)=0
      lstk(top+1)=l1+n1
      goto 999
c     

c     
c     code2str
 80   if (rhs .ne. 1) then
         call error(39)
         return
      endif
      if (lhs .ne. 1) then
         call error(41)
         return
      endif
c     checking variable str (number 1)
c       
      il1 = iadr(lstk(top-rhs+1))
      if (istk(il1) .ne. 1) then
         err = 1
         call error(53)
         return
      endif
      if (istk(il1+3) .ne. 0) then
         err = 1
         call error(52)
         return
      endif
      n1 = istk(il1+1)*istk(il1+2)
      l1 = sadr(il1+4)
      call dcopy(n1,stk(l1),-1,stk(l1+2),-1)
      istk(il1+4)=1
      istk(il1+5)=n1+1
      do 71 i=1,n1
         istk(il1+5+i)=stk(l1+1+i)
 71   continue
      istk(il1)=10
      istk(il1+1)=1
      istk(il1+2)=1
      istk(il1+3)=0
      lstk(top+1)=sadr(il1+6+n1)
      goto 999
c     
  999 return
      end
