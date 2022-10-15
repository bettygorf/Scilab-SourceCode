      subroutine logic
c     ====================================================================
c     
c     operations sur les booleens et matrices de booleens
c     
c     ====================================================================
c     
      INCLUDE '../stack.h'
c     
      integer plus,minus,star,dstar,slash,bslash,dot,colon,concat
      integer quote,extrac,insert,less,great,equal,et,ou,non
c     
      integer iadr,sadr,op,top0
c     
      data plus/45/,minus/46/,star/47/,dstar/62/,slash/48/
      data bslash/49/,dot/51/,colon/44/,concat/1/,quote/53/
      data less/59/,great/60/,equal/50/,extrac/3/,insert/2/
      data ou/57/,et/58/,non/61/
c
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
c     
      op=fin
      top0=top
c     
      if (ddt .eq. 4) then
         write(buf(1:4),'(i4)') fin
         call basout(io,wte,' logic op: '//buf(1:4))
      endif
c     
      lw=lstk(top+1)
      it2=0
      goto (04,03,02,01) rhs
      call error(39)
      return
c     
 01   il4=iadr(lstk(top))
      if(istk(il4).lt.0) il4=iadr(istk(il4+1))
      m4=istk(il4+1)
      n4=istk(il4+2)
      mn4=m4*n4
      if(istk(il4).eq.4) then
         l4=il4+3
      elseif(istk(il4).le.2) then
         it4=istk(il4+3)
         l4=sadr(il4+4)
      else
         err=4
         call error(44)
         return
      endif
      top=top-1
c     
 02   il3=iadr(lstk(top))
      if(istk(il3).lt.0) il3=iadr(istk(il3+1))
      m3=istk(il3+1)
      n3=istk(il3+2)
      mn3=m3*n3
      if(istk(il3).eq.4) then
         l3=il3+3
      elseif(istk(il3).le.2) then
         it3=istk(il3+3)
         l3=sadr(il3+4)
      else
         err=3
         call error(44)
         return
      endif
      top=top-1
c     
 03   il2=iadr(lstk(top))
      if(istk(il2).lt.0) il2=iadr(istk(il2+1))
      m2=istk(il2+1)
      n2=istk(il2+2)
      mn2=m2*n2
      if(istk(il2).eq.4) then
         l2=il2+3
      elseif(istk(il2).le.2) then
         it2=istk(il2+3)
         l2=sadr(il2+4)
      else
         err=2
         call error(44)
         return
      endif
      top=top-1
c     
 04   il1=iadr(lstk(top))
      if(istk(il1).lt.0) il1=iadr(istk(il1+1))
      m1=istk(il1+1)
      n1=istk(il1+2)
      mn1=m1*n1
      if(istk(il1).eq.4) then
         l1=il1+3
      elseif(istk(il1).eq.1) then
         it1=istk(il1+3)
         l1=sadr(il1+4)
      else
         err=1
         call error(44)
         return
      endif
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
c         cconc extrac insert rconc
      goto(75  ,  85  ,  79  ,78 ) op
c     
c     
c          :  +   -  * /  \
      goto(15,15,15,15,15,15,130,06,06,70,130,130) op+1-colon
      if(op.eq.ou.or.op.eq.et) goto 20
      if(op.eq.non) goto 30
c     
      
 06   if(op.gt.3*dot) goto 15
      if(op.ge.equal+equal) goto 130
      if(op.gt.dot) goto 15
      
c     

c     operations non implantees
 15   fin=-fin
      top=top0
      go to 999
c     
c     ou/et logique
 20   if(istk(il2).ne.4) then
         err=2
         call error(44)
         return
      endif
      if(istk(il1).ne.4) then
         err=1
         call error(44)
         return
      endif
      if(mn1.eq.1.and.mn2.gt.1) then
         l1=iadr(lw)
         err=sadr(l1+mn2)-lstk(bot)
         if(err.gt.0) then
            call error(17)
            return
         endif
         call iset(mn2,istk(il1+3),istk(l1),1)
         mn1=mn2
         m1=m2
         n1=n2
      elseif(mn2.eq.1.and.mn1.gt.1) then
         l2=iadr(lw)
         err=sadr(l2+mn2)-lstk(bot)
         if(err.gt.0) then
            call error(17)
            return
         endif
         call iset(mn1,istk(il2+3),istk(l2),1)
         mn2=mn1
         m2=m1
         n2=n1
      else if (n1 .ne. n2.or.m1.ne.m2) then
         call error(60)
         return
      else
         l1=il1+3
         l2=il2+3
      endif
      istk(il1+1)=m1
      istk(il1+2)=n1
      if(fin.eq.et) then
         do 21 k=0,n1*m1-1
            istk(il1+3+k)=istk(l1+k)*istk(l2+k)
 21      continue  
      else
         do 22 k=0,n1*m1-1
            istk(il1+3+k)=max(istk(l1+k),istk(l2+k))
 22      continue  
      endif
      lstk(top+1)=sadr(il1+3+m1*n1)
c         
      goto 999
c NOT
 30   continue
      do 31 k=0,n1*m1-1
         istk(il1+3+k)=1-istk(il1+3+k)
 31   continue  
      goto 999

c     transposition
 70   if(istk(il1).ne.4) then
         err=2
         call error(44)
         return
      endif
      if(mn1 .eq. 0) goto 999
      ll = l1+mn1+1
      err = sadr(ll+mn1) - lstk(bot)
      if (err .gt. 0) then
         call error(17)
         return
      endif
c     
      istk(il1+1)=n1
      istk(il1+2)=m1
c     
      call icopy(mn1,istk(l1),1,istk(ll),1)
      do 71 j=0,n1-1
         call icopy(m1,istk(ll+j*m1),1,istk(l1+j),n1)
 71   continue
c     
      goto 999
c     
c     concatenation
 75   if(m1.lt.0.or.m2.lt.0) then
         call error(14)
         return
      endif
      if(mn1.eq.0) then
         call icopy(mn2+3,istk(il2),1,istk(il1),1)
         lstk(top+1)=sadr(il1+4+mn2)
         goto 999
      endif
      if(mn2.eq.0)  goto 999
      if(istk(il1).ne.istk(il2)) then
         call error(43)
         return
      endif
      if(m1.ne.m2) then
         call error(5)
         return
      endif
      call icopy(mn2,istk(l2),1,istk(l1+mn1),1)
      istk(il1+2)=n1+n2
      lstk(top+1)=sadr(il1+3+m1*(n1+n2))
      goto 999

c     concatenation [a;b]
 78   if(n1.lt.0.or.n2.lt.0) then
            call error(14)
            return
      endif
      if(n2.eq.0) then
         goto 999
      elseif(n1.eq.0)then
         call dcopy(lstk(top+2)-lstk(top+1),stk(lstk(top+1)),1,
     &        stk(lstk(top)),1)
         lstk(top+1)=lstk(top)+lstk(top+2)-lstk(top+1)
         goto 999
      elseif(n1.ne.n2) then
         call error(6)
         return
      endif
      m=m1+m2
      mn=m*n1
      if(n1.eq.1) then
         call icopy(mn2,istk(l2),1,istk(l1+mn1),1)
         istk(il1+1)=m
         lstk(top+1)=sadr(l1+mn)
         goto 999
      endif
      lw1=l1+mn
      lw2=lw1+mn1
      err=sadr(lw2+mn2)-lstk(bot)
      if(err.gt.0) then
            call error(17)
            return
      endif
      call icopy(mn2,istk(l2),1,istk(lw2),1)
      call icopy(mn1,istk(l1),1,istk(lw1),1)
c
      call imcopy(istk(lw1),m1,istk(l1),m,m1,n1)
      call imcopy(istk(lw2),m2,istk(l1+m1),m,m2,n1)
      istk(il1+1)=m
      istk(il1+2)=n1
      lstk(top+1)=sadr(l1+mn)
      goto 999
c     
c     extraction
c     
 79   continue
      if(rhs.gt.2) goto 81
c     vect(arg)
      if(istk(il1).eq.4) then
         fin=-fin
         top=top0
         go to 999
      endif
      if(mn1.eq.0) goto 84
      if(m1.gt.1.and.n1.gt.1.or.it1.ne.0) then
         call error(21)
         return
      endif
      if(m2.lt.0) then
         call error(14)
         return
      endif
c     
      if(m1.lt.0) mn1=mn2
      err=sadr(il1+3+mn1)-lstk(bot)
      if(err.gt.0) then
         call error(17)
         return
      endif
c     
      l=il1+3
      do 80 i = 0, mn1-1
         ll = l1+i
         ls = l2+i
         if (m1 .gt. 0) then
            ls = l2 + int(stk(ll)) - 1
            if (ls .lt. l2) then
               call error(21)
               return
            endif
         endif
         istk(l+i) = istk(ls)
 80   continue
      m = 1
      n = 1
      if (m2 .gt. 1) m = mn1
      if (m2 .eq. 1) n = mn1
      istk(il1)=4
      istk(il1+1)=m
      istk(il1+2)=n
      lstk(top+1)=sadr(l+m*n)
      go to 999
c     
c     matrix(arg,arg)
 81   if(rhs.gt.4) then
         call error(36)
         return
      endif

      if(mn1*mn2.eq.0) goto 84
      if(istk(il1).eq.4.or.istk(il2).eq.4) then
         fin=-fin
         top=top0
         go to 999
      endif
      if(it1+it2.ne.0) then
         call error(21)
         return
      endif
      if(m3.lt.0) then
         call error(14)
         return
      endif
      m=mn1
      if(istk(il1+1).lt.0) m=istk(il3+1)
c     
      n=mn2
      if(istk(il2+1).lt.0) n=istk(il3+2)
c     
      l=iadr(lstk(top+2))
      mn = m*n
      err=sadr(l+mn)-lstk(bot)
      if(err.gt.0) then
         call error(17)
         return
      endif
      do 83 j = 0, n-1
         do 82 i = 0, m-1
            li = l1+i
            if (istk(il1+1) .gt. 0) li = l1 + int(stk(li)) - 1
            lj = l2+j
            if (istk(il2+1) .gt. 0) lj = l2 + int(stk(lj)) - 1
            ls = l3 + li-l1 + (lj-l2)*m3
            if (ls.lt.l3 ) then
               call error(21)
               return
            endif
            ll = l + i + j*m
            istk(ll) = istk(ls)
 82      continue
 83   continue
      call icopy(mn,istk(l),1,istk(il1+3),1)
      istk(il1)=4
      istk(il1+1)=m
      istk(il1+2)=n
      lstk(top+1)=sadr(il1+mn+4)
      go to 999
 84   continue
c     un des vecteurs d'indice est vide
      istk(il1)=1
      istk(il1+1)=0
      istk(il1+2)=0
      istk(il1+3)=0
      lstk(top+1)=sadr(il1+4)
      goto 999
c     
c     insertion
c     a(vl,vc)=m  a(v)=u
 85   ili=iadr(lstk(top0-1))
      if (istk(ili+1)*istk(ili+2).eq.0) then
         top=top0
         fin=-fin
         return
      endif
      m=-1
      n=-1
      goto (86,88),rhs-2
c     
c     vect(arg)
c     
 86   mk=m3
      nk=n3
      lk=l3
      md=m2
      nd=n2
      ld=l2
c     
      if(istk(il1).eq.4) then
         fin=-fin
         top=top0
         go to 999
      endif
      if(istk(il1).ne.1) then
         call error(21)
         return
      endif

      if(it1.ne.0) then
         call error(21)
         return
      endif
      if (n3.gt.1.or.n2.gt.1) go to 87
c     vecteur colonne
      m=isign(mn1,m1)
      if(m.ge.0) goto 90
      if(mn2.ne.mn3) then
         call error(15)
         return
      endif
      go to 90
c     vecteur ligne
 87   if (m3.gt.1.or.m2.gt.1) then
         call error(15)
         return
      endif
      n=isign(mn1,m1)
      l2=l1
      if(n.ge.0) goto 90
      if(mn2.ne.mn3) then
         call error(15)
         return
      endif
      go to 90
c     
c     m est une matrice
c     matrix(arg,arg)
 88   mk=m4
      nk=n4
      lk=l4
      md=m3
      nd=n3
      ld=l3
c     
      if(istk(il1).eq.4.or.istk(il2).eq.4) then
c     indices booleens
         fin=-fin
         top=top0
         go to 999
      endif
      if(istk(il1).ne.1.or.istk(il2).ne.1) then
         call error(21)
         return
      endif
      if(it1+it2.ne.0) then
         call error(21)
         return
      endif
      if(m1.ge.0) m=mn1
      if(m2.ge.0) n=mn2
      if(mn4.eq.0.and.(m.lt.0.or.n.lt.0)) then
         call error(15)
         return
      endif
      if(m.ge.0.and.n.ge.0) goto 90
      if(m.lt.0.and.m4.ne.m3) then
         call error(15)
         return
      endif
      if(n.lt.0.and.n4.ne.n3) then
         call error(15)
         return
      endif
      go to 90
c     
 90   mr=mk
      if (m .lt. 0) go to 92
      if(m.ne.md) then
         call error(15)
         return
      endif
      do 91 i = 0, m-1
         ls=int(stk(l1+i))
         if(ls.le.0) then
            call error(21)
            return
         endif
         mr=max(mr,ls)
 91   continue
 92   mr = max(mr,md)
c     
      nr=nk
      if (n .lt. 0) go to 94
      if(n.ne.nd) then
         call error(15)
         return
      endif
      do 93 i = 0, n-1
         ls=int(stk(l2+i))
         if(ls.le.0) then
            call error(21)
            return
         endif
         nr=max(nr,ls)
 93   continue
 94   nr = max(nr,nd)
c     
c     scalar matrix case
      mnk=mk*nk
      mnd=md*nd
      mnr=mr*nr
      lr=iadr(lw)
      err = sadr(lr + mnr) - lstk(bot)
      if (err .gt. 0) then
         call error(17)
         return
      endif
c     initialisation de r a 0
      call iset(mnr,0,istk(lr),1)
c     on reecrit a dans R
      if(mnk.ge.1) then
         call imcopy(istk(lk),mk,istk(lr),mr,mk,nk)
      endif
c     
      
c     on implante les coeff de M dans R
      do 99 j = 0, nd-1
         do 98 i = 0, md-1
            li = i
            if (m .gt. 0) li =   int(stk(l1+i)) - 1
            lj = j
            if (n .gt. 0) lj =  int(stk(l2+j)) - 1
            ll = lr+li+lj*mr
            ls = ld+i+j*md
            istk(ll) = istk(ls)
 98      continue
 99   continue
c     
      call icopy(mnr,istk(lr),1,istk(il1+3),1)
      istk(il1)=4
      istk(il1+1)=mr
      istk(il1+2)=nr
      lstk(top+1)=sadr(il1+4+mnr)
      goto 999
c     

c     comparaisons
c     
 130  continue
      itrue=1
      if(op.eq.less+great) itrue=0
      if(op.ne.equal.and.op.ne.less+great) then
         call error(43)
         return
      endif
      if(istk(il1).ne.istk(il2)) then
         istk(il1)=4
         istk(il1+1)=1
         istk(il1+2)=1
         istk(il1+3)=1-itrue
         lstk(top+1)=sadr(il1+4)
         return
      else if(mn1.eq.1.and.mn2.gt.1) then
         l1=iadr(lw)
         err=sadr(l1+mn2)-lstk(bot)
         if(err.gt.0) then
            call error(17)
            return
         endif
         call iset(mn2,istk(il1+3),istk(l1),1)
         mn1=mn2
         m1=m2
         n1=n2
         istk(il1+1)=m1
         istk(il1+2)=n1
      else if(mn2.eq.1.and.mn1.gt.1) then
         l2=iadr(lw)
         err=sadr(l2+mn1)-lstk(bot)
         if(err.gt.0) then
            call error(17)
            return
         endif
         call iset(mn1,istk(il2+3),istk(l2),1)
         mn2=mn1
         m2=m1
         n2=n1
      else if(n1.ne.n2.or.m1.ne.m2) then
         istk(il1)=4
         istk(il1+1)=1
         istk(il1+2)=1
         istk(il1+3)=1-itrue
         lstk(top+1)=sadr(il1+4)
         return
      else
         l1=il1+3
         l2=il2+3
      endif
      do 132 i=0,mn1-1
         if(istk(l1+i).eq.istk(l2+i)) then
            istk(il1+3+i)=itrue
         else
            istk(il1+3+i)=1-itrue
         endif
 132  continue
      istk(il1)=4
      istk(il1+1)=m1
      istk(il1+2)=n1
      lstk(top+1)=sadr(il1+3+mn1)
      goto 999
c     
 999  return
      end
