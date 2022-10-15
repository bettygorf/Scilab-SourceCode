      subroutine lspops
c     
c     operations on boolean sparse matrices
c     
      include '../stack.h'
      integer op
c     
      integer iadr,sadr
c     
      integer plus,minus,star,dstar,slash,bslash,dot,colon,concat
      integer quote,extrac,insert,less,great,equal,ou,et,non
      integer top0
      data plus/45/,minus/46/,star/47/,dstar/62/,slash/48/
      data bslash/49/,dot/51/,colon/44/,concat/1/,quote/53/
      data extrac/3/,insert/2/,less/59/,great/60/,equal/50/
      data ou/57/,et/58/,non/61/
c     
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
c     
      op=fin
c     
      if (ddt .eq. 4) then
         write(buf(1:4),'(i4)') fin
         call basout(io,wte,' lspops op: '//buf(1:4))
      endif
c     
      top0=top
      lw=lstk(top+1)+1
      it2=0
      goto (04,03,02,01) rhs
      call error(39)
      return
c     
 01   il4=iadr(lstk(top))
      if(istk(il4).lt.0) il4=iadr(istk(il4+1))
      m4=istk(il4+1)
      n4=istk(il4+2)
      it4=istk(il4+3)
      if(istk(il4).eq.6) then
         nel4=istk(il4+4)
         irc4=il4+5
         l4=sadr(irc4+m4+nel4)
      else
         nel4=m4*n4
         l4=sadr(il4+4)
      endif
      mn4=m4*n4
      top=top-1
c     
 02   il3=iadr(lstk(top))
      if(istk(il3).lt.0) il3=iadr(istk(il3+1))
      m3=istk(il3+1)
      n3=istk(il3+2)
      it3=istk(il3+3)
      if(istk(il3).eq.6) then
         nel3=istk(il3+4)
         irc3=il3+5
         l3=sadr(irc3+m3+nel3)
      else
         l3=sadr(il3+4)
         nel3=m3*n3
      endif
      mn3=m3*n3
      top=top-1
c     
 03   il2=iadr(lstk(top))
      if(istk(il2).lt.0) il2=iadr(istk(il2+1))
      m2=istk(il2+1)
      n2=istk(il2+2)
      it2=istk(il2+3)
      if(istk(il2).eq.6) then
         nel2=istk(il2+4)
         irc2=il2+5
         l2=sadr(irc2+m2+nel2)
      else
         l2=sadr(il2+4)
         nel2=m2*n2
      endif
      mn2=m2*n2
      top=top-1
c     
 04   il1=iadr(lstk(top))
      if(istk(il1).lt.0) il1=iadr(istk(il1+1))
      m1=istk(il1+1)
      n1=istk(il1+2)
      it1=istk(il1+3)
      if(istk(il1).eq.6) then
         nel1=istk(il1+4)
         irc1=il1+5
         l1=sadr(irc1+m1+nel1)
      else
         l1=sadr(il1+4)
         nel1=m1*n1
      endif
      mn1=m1*n1
      top=top-1
c     
c     operations binaires et ternaires
c     --------------------------------
c     
      top=top+1
      itr=max(it1,it2)
c     
      fun = 0
c     
c     cconc  extrac insert rconc
      goto(75  ,  85  ,  80   ,78) op
c     
c           :  +  -  * /  \  =          '
      goto(07,07,07,07,07,07,130,05,05,70) op+1-colon
      if(op.eq.ou.or.op.eq.et) goto 20
      if(op.eq.non) goto 30
c     
 05   if(op.eq.dstar) goto 07
      if(op.ge.3*dot+star) goto 07
      if(op.ge.2*dot+star) goto 07
      if(op.ge.less+equal) goto 130
      if(op.ge.dot+star) goto 07
      if(op.ge.less) goto 130

 06   call error(43)
      return
c
 07   fin=-fin
      top=top0
      go to 999
c     
c     ou/et logique
 20   if(istk(il1).ne.6.or.istk(il2).ne.6) then
         fin=-fin
         top=top0
         go to 999
      endif
      if(mn1.eq.1.and.mn2.gt.1) then
         top=top0
         fin=-fin
         return
      elseif(mn2.eq.1.and.mn1.gt.1) then
         top=top0
         fin=-fin
         return
      else if (n1 .ne. n2.or.m1.ne.m2) then
         call error(60)
         return
      endif
      irc=iadr(lw)
      nelmx=iadr(lstk(bot))-irc-m1-10
      lw=sadr(irc+m1+nelmx)
      err=lw-lstk(bot)
      if(err.gt.0) then
         call error(17)
         return
      endif  
      nel=nelmx
      if(fin.eq.ou) then
         call lspasp(m1,n1,nel1,istk(irc1),nel2,istk(irc2),nel,
     $        istk(irc),ierr)
      else
         call lspxsp(m1,n1,nel1,istk(irc1),nel2,istk(irc2),nel,
     $        istk(irc),ierr)
      endif
      if(ierr.ne.0) then
         call error(17)
         return
      endif
      istk(il1+3)=0
      istk(il1+4)=nel
      call icopy(m1+nel,istk(irc),1,istk(irc1),1)
      l1=sadr(irc1+m1+nel)
      lstk(top+1)=l1
      go to 999

c NOT
 30   continue
      top=top+1
      il=iadr(lstk(top))
      istk(il)=4
      istk(il+1)=1
      istk(il+2)=1
      istk(il+3)=0
      lstk(top+1)=sadr(il+4)
      op=less+great
      goto 130

c     
c     
c     transposition
 70   istk(il1+1)=n1
      istk(il1+2)=m1
      if(nel1.eq.0) then
         lw=sadr(il1+5+n1)
         err=lw-lstk(bot)
         if(err.gt.0) then
            call error(17)
            return
         endif
         call iset(n1,0,istk(il1+5),1)
         lstk(top+1)=lw
         goto 999
      endif
      ia=iadr(lw)
      iat=ia+m1+1
      irc=iat+n1+1
      lw=sadr(irc+n1+nel1)
      err=lw-lstk(bot)
      if(err.gt.0) then
         call error(17)
         return
      endif
      istk(ia)=1
      do 71 i=1,m1
         istk(ia+i)=istk(ia+i-1)+istk(irc1+i-1)
 71   continue
      call lspt(m1,n1,nel1,istk(irc1),istk(ia),
     $     istk(iat),istk(irc))
      call icopy(n1+nel1,istk(irc),1,istk(irc1),1)
      l1=sadr(irc1+n1+nel1)
      lstk(top+1)=l1
      goto 999
c     
c     concatenation [a b]
 75   continue
      if(m1.lt.0.or.m2.lt.0) then
         call error(14)
         return
      endif
      if(m2.eq.0) then
         return
      elseif(m1.eq.0) then
         call icopy(5+m2+nel2,istk(il2),1,istk(il1),1)
         l1=sadr(il1+5+m2+nel2)
         lstk(top+1)=l1
         return
      elseif(m1.ne.m2) then
         call error(5)
         return
      endif
      if(istk(il1).ne.6.or.istk(il2).ne.6) then
         top=top0
         fin=-fin
         return
      endif
c
      nelr=nel1+nel2
      istk(il1+2)=n1+n2
      istk(il1+3)=0
      istk(il1+4)=nelr
      irc=iadr(lw)
      lw=sadr(irc+m1+nelr)
      err=lw-lstk(bot)
      if(err.gt.0) then
         call error(17)
         return
      endif
      call lspcsp(0,m1,n1,nel1,istk(irc1),
     $     m2,n2,nel2,istk(irc2),
     $     nelr,istk(irc))
      call icopy(m1+nelr,istk(irc),1,istk(irc1),1)
      l1=sadr(irc1+m1+nelr)
      lstk(top+1)=l1
      return
c     
c     concatenation [a;b]
 78   continue
      if(n1.lt.0.or.n2.lt.0) then
         call error(14)
         return
      endif
      if(n2.eq.0) then
         goto 999
      elseif(n1.eq.0)then
         call icopy(5+m2+nel2,istk(il2),1,istk(il1),1)
         l1=sadr(il1+5+m2+nel2)
         lstk(top+1)=l1
         goto 999
      elseif(n1.ne.n2) then
         call error(6)
         return
      endif
      if(istk(il1).ne.6.or.istk(il2).ne.6) then
         top=top0
         fin=-fin
         return
      endif


      nelr=nel1+nel2
      istk(il1+1)=m1+m2
      istk(il1+3)=0
      istk(il1+4)=nelr
      irc=iadr(lw)
      lw=sadr(irc+m1+m2+nelr)
      err=lw-lstk(bot)
      if(err.gt.0) then
         call error(17)
         return
      endif
      call lspcsp(1,m1,n1,nel1,istk(irc1),
     $        m2,n2,nel2,istk(irc2),
     $        nelr,istk(irc))
      call icopy(m1+m2+nelr,istk(irc),1,istk(irc1),1)
      l1=sadr(irc1+m1+m2+nelr)
      lstk(top+1)=l1
      goto 999
c     
c     extraction
c     
 80   continue
c     extraction
c     
      if(rhs.gt.2) goto 82
c     vect(arg)
      if(mn1.eq.0) then
c     un des vecteurs d'indice est vide
         istk(il1)=1
         istk(il1+1)=0
         istk(il1+2)=0
         lstk(top+1)=l1+1
         goto 999
      endif
      if(m1.gt.1.and.n1.gt.1.or.it1.ne.0) then
         call error(21)
         return
      endif
      if(m2.lt.0) then
         call error(14)
         return
      endif
c     
      if(istk(il1+1).lt.0) then
         if(n2.eq.1.or.m2.eq.1) then
            call icopy(5+m2+nel2,istk(il2),1,istk(il1),1)
            l1=sadr(il1+5+m2+nel2)
            lstk(top+1)=l1
         else
            call error(43)
            return
         endif
         return
      endif
      mm=max(m2,n2)
      li1=iadr(l1)
      do 81 j=0,mn1-1
         istk(li1+j)=stk(l1+j)
         if(istk(li1+j).lt.0.or.istk(li1+j).gt.mm) then
            call error(21)               
            return
         endif
 81   continue
      if(m2.eq.1) then
c     vecteur ligne
         m=-1
         n=mn1
         mr=n
      elseif(n2.eq.1) then
c     vecteur colonne
         m=mn1
         n=-1
         mr=m
      else
c     matrice, on retourne un vecteur colonne
         call error(43)
         return
      endif

      lptr=iadr(lw)
      irc=lptr+m2+1
      lw=sadr(irc+mr)
      nelr=iadr(lstk(bot))-iadr(lw)
      if(nelr.le.0) then
         err=lw-lstk(bot)
         call error(17)
         return
      endif
      lw=sadr(irc+mr+nelr)
      nel=nelr

      call lspe2(m2,n2,nel2,istk(irc2),
     $        istk(li1),m,istk(li1),n,mr,nr,
     $        nelr,istk(irc),istk(lptr),ierr)
      istk(il1)=6
      istk(il1+1)=mr
      istk(il1+2)=nr
      istk(il1+3)=0
      istk(il1+4)=nelr
      call icopy(m+nelr,istk(irc),1,istk(il1+5),1)
      l1=sadr(il1+5+mr+nelr)
      lstk(top+1)=l1
      go to 999

c
c     matrix(arg,arg)
 82   continue
      if(rhs.gt.4) then
         call error(36)
         return
      endif
      if(mn1*mn2.eq.0) then
c     un des vecteurs d'indice est vide
         istk(il1)=1
         istk(il1+1)=0
         istk(il1+2)=0
         lstk(top+1)=l1+1
         goto 999
      endif
      if(mn3.eq.0) then 
         istk(il1)=1
         istk(il1+1)=0
         istk(il1+2)=0
         lstk(top+1)=l1+1
         goto 999
      elseif(m3.lt.0) then
         call error(14)
         return
      endif
c
      li1=iadr(l1)
      if(istk(il1+1).lt.0) then
         m=-1
      else
         m=mn1
         do 83 j=0,mn1-1
            istk(li1+j)=stk(l1+j)
            if(istk(li1+j).lt.0.or.istk(li1+j).gt.m3) then
               call error(21)
               return
            endif
 83      continue
      endif
c.
      li2=iadr(l2)
      if(istk(il2+1).lt.0) then
         n=-1
      else
         n=mn2
         do 84 j=0,mn2-1
            istk(li2+j)=stk(l2+j)
            if(istk(li2+j).lt.0.or.istk(li2+j).gt.n3) then
               call error(21)
               return
            endif
 84      continue
      endif
c
      lptr=iadr(lw)
      irc=lptr+m3+1
      lw=sadr(irc+m)
      nelr=iadr(lstk(bot))-iadr(lw)
      if(nelr.le.0) then
         err=lw-lstk(bot)
         call error(17)
         return
      endif
      lw=sadr(irc+m+nelr)
      nel=nelr
      call lspe2(m3,n3,nel3,istk(irc3),istk(li1),m,
     $        istk(li2),n,mr,nr,nelr,istk(irc),istk(lptr),ierr)

      istk(il1)=6
      istk(il1+1)=mr
      istk(il1+2)=nr
      istk(il1+3)=0
      istk(il1+4)=nelr
      call icopy(m+nelr,istk(irc),1,istk(il1+5),1)
      l1=sadr(il1+5+m+nelr)
      lstk(top+1)=l1
      go to 999
      
c     insert
 85   if(rhs.eq.4) goto 90

c     vector case : arg3(arg1)=arg2
c     
      if(it1.ne.0) then
         call error(21)
         return
      endif
c
      if(istk(il3).ne.6) then
         top=top0
         fin=-fin
         return
      endif
c
      if(m2.ne.0.and.istk(il2).ne.4.and.istk(il2).ne.6) then
         top=top0
         fin=-fin
         return
      endif
      imax=0
      li1=iadr(l1)
      if(m1.gt.0) then
         do 87 i = 0, m1*n1-1
            istk(li1+i)=stk(l1+i)
            if(istk(li1+i).lt.0) then
               call error(21)
               return
            endif
            imax=max(imax,istk(li1+i))
 87      continue
      endif
      if(m2.ne.0.and.m3.gt.1.and.n3.gt.1) then
c     matrix(:)=vector
         call error(43)
         return
      elseif (n3.le.1.and.n2.le.1) then
c     column vector 
         m=isign(mn1,m1)
         n=-1
         nr=1
         if(m.lt.0) then
            if(mn2.eq.0) then
c     v(:)=[]
               istk(il1)=1
               istk(il1+1)=0
               istk(il1+2)=0
               istk(il1+3)=0
               lstk(top+1)=sadr(il1+4)
               return
            elseif(mn2.ne.mn3) then
               call error(15)
               return
            else
c     v(:)=u
               mr=m3
            endif
         else
            if(mn2.eq.0) then
c     v(i)=[]
               mr=m3-mn1
               if(mr.le.0) then
                  istk(il1)=1
                  istk(il1+1)=0
                  istk(il1+2)=0
                  istk(il1+3)=0
                  lstk(top+1)=sadr(il1+4)
                  return
               endif
            elseif(mn1.ne.mn2) then
               call error(15)
               return
            else
c     v(i)=u
               mr=max(m3,imax)
            endif
         endif
      elseif (m3.le.1.or.m2.le.1) then
c     row vecteur 
         m=-1
         n=isign(mn1,m1)
         mr=1
         if(n.lt.0) then
            if(mn2.eq.0) then
c     v(:)=[]
               istk(il1)=1
               istk(il1+1)=0
               istk(il1+2)=0
               istk(il1+3)=0
               lstk(top+1)=sadr(il1+4)
               return
            elseif(mn2.ne.mn3) then
               call error(15)
               return
            else
               nr=n3
            endif
         else
            if(mn2.eq.0) then
c     v(i)=[]
               nr=n3-mn1
               if(nr.le.0) then
                  istk(il1)=1
                  istk(il1+1)=0
                  istk(il1+2)=0
                  istk(il1+3)=0
                  lstk(top+1)=sadr(il1+4)
                  return
               endif
            elseif(mn1.ne.mn2) then
               call error(15)
               return
            else
               nr=max(n3,imax)
            endif
         endif
      endif

c     
      lptr=iadr(lw)
      irc=lptr+m3+1
      nelr=iadr(lstk(bot))-irc-mr
      if(nelr.le.0) then
         err=lw-lstk(bot)
         call error(17)
         return
      endif
      lw=sadr(irc+mr+nelr)
      nel=nelr
      if(istk(il3).eq.6) then
         if(istk(il2).eq.6) then
            call lspisp(m3,n3,nel3,istk(irc3),
     $              istk(li1),m,istk(li1),n,
     $              m2,n2,nel2,istk(irc2),
     $              mr,nr,nelr,istk(irc),istk(lptr),ierr)
         elseif(istk(il2).eq.4.or.istk(il2).eq.1) then
            l2=il2+3
            call lspis(m3,n3,nel3,istk(irc3),
     $              istk(li1),m,istk(li1),n,
     $              m2,n2,istk(l2),
     $              mr,nr,nelr,istk(irc),ierr) 
         endif
      endif
      if(ierr.ne.0) then
         buf='not enough memory'
         call error(9999)
         return
      endif
      istk(il1)=6
      istk(il1+1)=mr
      istk(il1+2)=nr
      istk(il1+3)=0
      istk(il1+4)=nelr
      call icopy(mr+nelr,istk(irc),1,istk(il1+5),1)
      l1=sadr(il1+5+mr+nelr)
      lstk(top+1)=l1
      go to 999
c     
c     matrix case : arg4(arg1,arg2)=arg3
 90   continue
c     
      if(it1+it2.ne.0) then
         call error(21)
         return
      endif
c
      m=-1
      if(m1.ge.0) m=mn1
      n=-1
      if(m2.ge.0) n=mn2
      if(mn4.eq.0.and.(m.lt.0.or.n.lt.0)) then
         call error(15)
         return
      endif
      if(m3*n3.eq.0.and.m.ge.0.and.n.ge.0) then
         call error(15)
         return
      endif
      if(m.lt.0.or.n.lt.0) then
         if(m.lt.0.and.m4.ne.m3) then
            call error(15)
            return
         endif
         if(n.lt.0.and.n4.ne.n3) then
            call error(15)
            return
         endif
      endif
c    

      mr=m4
      if(istk(il4).ne.6.or.istk(il3).ne.4.and.istk(il3).ne.6) then
         top=top0
         fin=-fin
         return
      endif

      if (m .ge. 0) then
         if(m3.ne.0.and.m.ne.m3) then
            call error(15)
            return
         endif
         li1=iadr(l1)
         do 91 i = 0, m-1
            istk(li1+i)=stk(l1+i)
            if(istk(li1+i).lt.0) then
               call error(21)
               return
            endif
            mr=max(mr,istk(li1+i))
 91      continue
      else
         mr = max(mr,m3)
      endif
      mr = max(mr,m3)
c     
      nr=n4
      if (n .ge. 0) then 
         if(n3.ne.0.and.n.ne.n3) then
            call error(15)
            return
         endif
         li2=iadr(l2)
         do 93 i = 0, n-1
            istk(li2+i)=stk(l2+i)
            if(istk(li2+i).lt.0) then
               call error(21)
               return
            endif
            nr=max(nr,istk(li2+i))
 93      continue
      else
         nr = max(nr,n3)
      endif
      nr = max(nr,n3)
c     
c     scalar matrix case
      lptr=iadr(lw)
      irc=lptr+m4+1
      nelr=iadr(lstk(bot))-irc-mr
      if(nelr.le.0) then
         err=lw-lstk(bot)
         call error(17)
         return
      endif
      lw=sadr(irc+mr+nelr)
      nel=nelr
      if(istk(il4).eq.6) then
         if(istk(il3).eq.6) then
            call lspisp(m4,n4,nel4,istk(irc4),
     $              istk(li1),m,istk(li2),n,
     $              m3,n3,nel3,istk(irc3),
     $              mr,nr,nelr,istk(irc),istk(lptr),ierr)
         elseif(istk(il3).eq.4) then
            l3=il3+3
            call lspis(m4,n4,nel4,istk(irc4),
     $              istk(li1),m,istk(li2),n,
     $              m3,n3,istk(l3),
     $              mr,nr,nelr,istk(irc),ierr) 
         endif
      endif
      if(ierr.ne.0) then
         buf='not enough memory'
         call error(9999)
         return
      endif
      istk(il1)=6
      istk(il1+1)=mr
      istk(il1+2)=nr
      istk(il1+3)=0
      istk(il1+4)=nelr
      call icopy(mr+nelr,istk(irc),1,istk(il1+5),1)
      l1=sadr(il1+5+mr+nelr)
      lstk(top+1)=l1
      go to 999
c
 130  continue
c     comparaisons
      if(mn2.eq.0.and.mn1.eq.0) then
         if(op.eq.equal.or.op.eq.less+great) then
            istk(il1)=4
            istk(il1+1)=1
            istk(il1+2)=1
            istk(il1+3)=1
            if(op.eq.less+great) istk(il1+3)=0
            lstk(top+1)=sadr(il1+4)
            goto 999
         else
            call error(60)
            return
         endif
      endif
      if(mn1.ne.1.and.mn2.ne.1) then
         if(n1.ne.n2.or.m1.ne.m2) then
            if(op.eq.equal.or.op.eq.less+great) then
               istk(il1)=4
               istk(il1+1)=1
               istk(il1+2)=1
               istk(il1+3)=0
               if(op.eq.less+great) istk(il1+3)=1
               lstk(top+1)=sadr(il1+4)
               return
            else
               call error(60)
               return
            endif
         endif
      endif
      if(istk(il1).ne.4.and.istk(il1).ne.6.or.
     $     istk(il2).ne.4.and.istk(il2).ne.6) then
         top=top0
         fin=-fin
         return
      endif
c
      mr=m1
      nr=n1
      if(m1*n1.eq.1) then
         mr=m2
         nr=n2
      endif
      irc=iadr(lw)
      nelmx=(iadr(lstk(bot))-irc-mr-10)
      lw=sadr(irc+mr+nelmx)
      err=lw-lstk(bot)
      if(err.gt.0) then
         call error(17)
         return
      endif  
      nel=nelmx
      if(istk(il1).eq.4) then
         l1=il1+3
         call lsosp(op,m1,n1,istk(l1),m2,n2,nel2,
     $        istk(irc2),nel,istk(irc),ierr)
      elseif(istk(il2).eq.4) then
         l2=il2+3
         call lspos(op,m1,n1,nel1,istk(irc1),
     $           m2,n2,istk(l2),nel,istk(irc),ierr)
      else
         call lsposp(op,m1,n1,nel1,istk(irc1),
     $           m2,n2,nel2,istk(irc2),
     $           nel,istk(irc),ierr)
      endif
      if(ierr.ne.0) then
         buf='not enough memory'
         call error(9999)
         return
      endif
      istk(il1)=6
      istk(il1+1)=mr
      istk(il1+2)=nr
      istk(il1+3)=0
      istk(il1+4)=nel
      irc1=il1+5
      call icopy(mr+nel,istk(irc),1,istk(irc1),1)
      l1=sadr(irc1+mr+nel)
      lstk(top+1)=l1
      go to 999
c     
 999  return
      end



