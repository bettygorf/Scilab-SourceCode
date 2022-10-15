      subroutine matio
c     ====================================================================
c     
c     file handling and other i/o
c     
c     ====================================================================
c     
      INCLUDE '../stack.h'
      integer    lch
      parameter (lch=255)
      character chaine*(lch)
c     
      integer blank,flag,top2,semi,percen,id(nlgh),h(nsiz)
      integer status,access,form,recl,old,new,scratc,unknow
      integer sequen,direct,forma1,unform
      integer clo,rew,bak,ope,ftyp,fmttyp,mode(2),retu(6),comma,eol
      double precision eps,xxx
      logical opened
      integer iadr,sadr
      character bu1*(bsiz),bu2*(bsiz)
c
      logical sciv1,first
      common /compat/ sciv1,first
c     
      save opened,lunit,job,icomp
c     
      data blank/40/,semi/43/,percen/56/
      data old/857368/,new/2100759/,scratc/1707037/,unknow/1316638/
      data sequen/1707548/,direct/1774093/,forma1/1775631/
      data unform/988958/
      data clo/12/,ope/24/,rew/27/,bak/11/,last/21/,nclas/29/
      data retu/27,14,29,30,27,23/,comma/52/,eol/99/
c     
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
c     
      if (ddt .eq. 4) then
         write(buf(1:4),'(i4)') fin
         call basout(io,wte,' matio '//buf(1:4))
      endif
c     
      if(rstk(pt).eq.902) goto 22
      if(rstk(pt).eq.903) goto 24
      if(rstk(pt).eq.904) goto 57
c     
c     functions/fin
c     
c     load read  getf exec lib   diary save write print mac  deff rat
c     1    2     3    4     5     6    7     8     9    10   11   12
c     file hosts readb writb execstr  disp  getpid getenv
c     13   14    15    16     17      18     19     20
c     
c     
      goto ( 35,120, 55, 20,130, 27, 30, 60, 25, 160,
     +     50, 45,140,170,190,180,23,200,205,210,170),fin
c     
c     exec
 20   continue
      lw=lstk(top+1)
      il=iadr(lstk(top))
      if(rhs.gt.2.or.rhs.lt.1) then
         call error(42)
         return
      endif
      if(lhs.gt.1) then
         call error(41)
         return
      endif
c     opening file
      top2=top
      top = top-rhs+1
      il=iadr(lstk(top))
      mode(1)=-1
      mode(2)=0
      if (istk(il).eq.1) then
         lunit = int(stk(sadr(il+4)))
         if(lunit .lt. 0) then
            err=1
            call error(36)
            return
         endif
         opened=.true.
      elseif(istk(il).eq.10) then
         mn=istk(il+5)-1
         call cvstr(mn,istk(il+5+istk(il+1)*istk(il+2)),buf,1)
         lunit = 0
         call clunit(lunit,buf(1:mn),mode)
         if(err.gt.0) then
            buf(mn+1:)=' '
            call error(err)
            return
         endif
         opened=.false.
      else
         err=1
         call error(55)
         return
      endif
c     
      flag = 3
      if (sym .eq. semi) flag = 0
      if(rhs.eq.1) goto 21
      il2=iadr(lstk(top2))
      l=sadr(il2+4)
      flag = int(stk(l))
      if(flag.ge.4) call basout(io,wte,
     &     'mode pas a pas. entrez des lignes blanches.')
 21   top=top-1
      pt=pt+1
      pstk(pt)=rio
      rio = lunit
      rstk(pt)=902
      icall=5
      fin=flag
c     *call*  macro
      go to 999
 22   call clunit(-rio,buf,0)
      rio=pstk(pt)
      pt=pt-1
      top=top+1
      il=iadr(lstk(top))
      istk(il)=0
      lstk(top+1)=sadr(il+1)
      goto 999
c     
c     execstr
 23   continue
      lw=lstk(top+1)
      il=iadr(lstk(top))
      if(rhs.ne.1) then
         call error(39)
         return
      endif
      if(lhs.gt.1) then
         call error(41)
         return
      endif
      if(istk(il).ne.10) then 
         err=1
         call error(55)
         return
      endif
      l=il+5+istk(il+1)*istk(il+2)
      l1=l+istk(l-1)-1
      istk(l1)=comma
      l1=l1+1
      call icopy(6,retu,1,istk(l1),1)
      l1=l1+6
      istk(l1)=comma
      l1=l1+1
      istk(l1)=eol
      l1=l1+1
      istk(l1)=eol
      istk(l-1)=istk(l-1)+10
      lstk(top+1)=sadr(l1)+1
c     
      fin=lstk(top)
      pt=pt+1
      pstk(pt)=top
      rstk(pt)=903
      icall=5
c     *call*  macro
      go to 999
 24   continue
      il=iadr(lstk(top))
      istk(il)=0
      lstk(top+1)=lstk(top)+1
      pt=pt-1
      goto 999
c     
c     print
 25   continue
      lw=lstk(top+1)
      il=iadr(lstk(top))
      if(rhs.le.1) then
         call error(42)
         return
      endif
      if(lhs.gt.1) then
         call error(41)
         return
      endif
c     opening file
      top2 = top
      top = top-rhs+1
      il=iadr(lstk(top))
      mode(1)=0
      mode(2)=0
      if (istk(il).eq.1) then
         lunit = int(stk(sadr(il+4)))
         if(lunit .lt. 0) then
            err=1
            call error(36)
            return
         endif
         opened=.true.
      elseif(istk(il).eq.10) then
         mn=istk(il+5)-1
         call cvstr(mn,istk(il+5+istk(il+1)*istk(il+2)),buf,1)
         lunit = 0
         call clunit(lunit,buf(1:mn),mode)
         if(err.gt.0) then
            buf(mn+1:)=' '
            call error(err)
            return
         endif
         opened=.false.
      else
         err=1
         call error(55)
         return
      endif
c     
      l = lct(2)
      if(lunit.ne.wte) then
         lct(2) = 0
      endif
      top=top2
      do 26 i=2,rhs
         call print(idstk(1,top),top,lunit)
         top=top-1
 26   continue
      lct(2) = l
      istk(il)=0
      if(.not.opened) call clunit(-lunit,buf,0)
      go to 999
c     
c     diary
 27   continue
      lw=lstk(top+1)
      il=iadr(lstk(top))
      if(rhs.gt.1) then
         call error(42)
         return
      endif
      if(lhs.gt.1) then
         call error(41)
         return
      endif

c     opening file
      top = top-rhs+1
      il=iadr(lstk(top))
      mode(1)=0
      mode(2)=0
      if (istk(il).eq.1) then
         lunit = int(stk(sadr(il+4)))
         if(lunit .lt. 0) then
            err=1
            call error(36)
            return
         endif
         opened=.true.
      elseif(istk(il).eq.10) then
         mn=istk(il+5)-1
         call cvstr(mn,istk(il+5+istk(il+1)*istk(il+2)),buf,1)
         lunit = 0
         call clunit(lunit,buf(1:mn),mode)
         if(err.gt.0) then
            buf(mn+1:)=' '
            call error(err)
            return
         endif
         opened=.false.
      else
         err=1
         call error(55)
         return
      endif
c     
      if(wio.ne.0) call clunit(-wio,buf,0)
      if(lunit.eq.0) goto 29
      wio=lunit
      istk(il)=0
      goto 999
 29   wio=0
      istk(il)=0
      goto 999
c     
c     ----
c     save
c     ----
c     
 30   continue
      lw=lstk(top+1)
      il=iadr(lstk(top))
      if(rhs.lt.1) then
         call error(42)
         return
      endif
      if(lhs.gt.1) then
         call error(41)
         return
      endif

c     opening file
      top2 = top
      top = top-rhs+1
      il=iadr(lstk(top))
      mode(1)=100
      mode(2)=0
      if (istk(il).eq.1) then
         lunit = int(stk(sadr(il+4)))
         if(lunit .lt. 0) then
            err=1
            call error(36)
            return
         endif
         opened=.true.
      elseif(istk(il).eq.10) then
         mn=istk(il+5)-1
         call cvstr(mn,istk(il+5+istk(il+1)*istk(il+2)),buf,1)
         lunit = 0
         call clunit(lunit,buf(1:mn),mode)
         if(err.gt.0) then
            buf(mn+1:)=' '
            call error(err)
            return
         endif
         opened=.false.
      else
         err=1
         call error(55)
         return
      endif
c     
      if(rhs.ge.2) then
         k=top2
      else
         k=bbot-1
         if(k.lt.bot) goto 999
      endif
 32   continue
      l=k
      ilk=iadr(lstk(k))
      if(istk(ilk).lt.0) l=istk(ilk+1)
      if(fin.eq.7) call savlod(lunit,idstk(1,k),0,l)
      k = k-1
      if(k.ge.bot.and.rhs.eq.1 .or. k.gt.top.and.rhs.gt.1) goto 32
      if(.not.opened) call clunit(-lunit,buf,0)
      istk(il)=0
      go to 999
c     
c     load
 35   continue
      lw=lstk(top+1)
      il=iadr(lstk(top))
      if(rhs.lt.1) then
         call error(42)
         return
      endif
      if(lhs.gt.1) then
         call error(41)
         return
      endif

c     opening file
      top2 = top
      top = top-rhs+1
      il=iadr(lstk(top))
      mode(1)=-101
      mode(2)=0
      if (istk(il).eq.1) then
         lunit = int(stk(sadr(il+4)))
         if(lunit .lt. 0) then
            err=1
            call error(36)
            return
         endif
         opened=.true.
      elseif(istk(il).eq.10) then
         mn=istk(il+5)-1
         call cvstr(mn,istk(il+5+istk(il+1)*istk(il+2)),buf,1)
         lunit = 0
         call clunit(lunit,buf(1:mn),mode)
         if(err.gt.0) then
            buf(mn+1:)=' '
            call error(err)
            return
         endif
         opened=.false.
      else
         err=1
         call error(55)
         return
      endif
c     
      sciv1=.false.
      first=.true.

      if(rhs.gt.1) goto 40
 36   job = lstk(bot) - lstk(top)
      id(1)=blank
      call savlod(lunit,id,job,top)
      il=iadr(lstk(top))
      if(istk(il).eq.0) goto 39
      sym = semi
      rhs = 0
      call stackp(id,1)
      top = top + 1
      go to 36
 39   if(.not.opened) call clunit(-lunit,buf,0)
      istk(il)=0
      go to 999
c     
 40   top=top2
      sym=semi
      m=rhs
      rhs=0
      do 44 k=2,m
         job = lstk(bot) - lstk(top)
         il=iadr(lstk(top))
         if(istk(il).ne.10) then
            err=k
            call error(55)
            return
         endif
         lc=il+5+istk(il+1)*istk(il+2)
         nc=min(nlgh,istk(il+5)-1)
         call namstr(h,istk(lc),nc,0)
         call savlod(lunit,h,job,top)
         if(istk(il).eq.0) goto 39
         call stackp(h,1)
         if(k.lt.m) rewind(lunit)
 44   continue
      il=iadr(lstk(top))
      goto 39
c     
c     rat
 45   continue
      lw=lstk(top+1)
      il=iadr(lstk(top))
      if(rhs.ne.1) then
         call error(42)
         return
      endif
      if(lhs.gt.2) then
         call error(41)
         return
      endif

      l=sadr(il+4)
      eps=stk(leps)
      if (rhs .eq. 1) go to 46
      top=top-1
      eps=stk(l)
      il=iadr(lstk(top))
 46   l=sadr(il+4)
      m=istk(il+1)
      n=istk(il+2)
      it=istk(il+3)
      mn=m*n*(it+1)
      l2 = l
c     
      if(lhs.eq.1) goto 47
      if(top+2.ge.bot) then
         call error(18)
         return
      endif
      top=top+1
      il=iadr(lstk(top))
      l2=sadr(il+4)
      err = l2+mn - lstk(bot)
      if (err .gt. 0) then
         call error(17)
         return
      endif
      istk(il)=1
      istk(il+1)=m
      istk(il+2)=n
      istk(il+3)=it
      lstk(top+1)=l2+mn
c     
 47   do 48 i=1,mn
         i1=i-1
         xxx=stk(l+i1)
         call rat(abs(xxx),eps,ns,nt,err)
         if(xxx.lt.0.0d+0) ns=-ns
         if(err.gt.0) then
            call error(24)
            return
         endif
         stk(l+i1) = dble(ns)
         stk(l2+i1) = dble(nt)
         if (lhs .eq. 1) stk(l+i1) = dble(ns)/dble(nt)
 48   continue
      go to 999
c     
c     deff
 50   continue
      lw=lstk(top+1)
      il=iadr(lstk(top))
      if(rhs.ne.2) then
         call error(42)
         return
      endif
      if(lhs.gt.1) then
         call error(41)
         return
      endif
      call getfun(0)
      if(err.gt.0) goto 999
      call stackp(idstk(1,top),0)
      top=top-1
      il=iadr(lstk(top))
      istk(il)=0
      fun=0
      goto 999
c     
c     getf
 55   continue
      lw=lstk(top+1)
      il=iadr(lstk(top))
      if(rhs.gt.2) then
         call error(42)
         return
      endif
      if(lhs.gt.1) then
         call error(41)
         return
      endif
c     opening file
      top = top-rhs+1
      il=iadr(lstk(top))
      mode(1)=-1
      mode(2)=0
      if (istk(il).eq.1) then
         lunit = int(stk(sadr(il+4)))
         if(lunit .lt. 0) then
            err=1
            call error(36)
            return
         endif
         opened=.true.
      elseif(istk(il).eq.10) then
         mn=istk(il+5)-1
         call cvstr(mn,istk(il+5+istk(il+1)*istk(il+2)),buf,1)
         lunit = 0
         call clunit(lunit,buf(1:mn),mode)
         if(err.gt.0) then
            buf(mn+1:)=' '
            call error(err)
            return
         endif
         opened=.false.
      else
         err=1
         call error(55)
         return
      endif
c     
      if(rhs.gt.1) then
         icomp=1
      else
         icomp=0
      endif
 56   call getfun(lunit)
      fun=0
      job=fin
      if(err.gt.0) then
         if(.not.opened) call clunit(-lunit,buf,0)
         return
      endif
      if(job.lt.0) goto 59
      if(icomp.ne.1) goto 58
c     procedure de compilation des macros (copie de ce qui est dans matsys)
      rhs=1
      il=iadr(lstk(top))
      l=il+1
      mlhs=istk(l)
      l=l+nsiz*mlhs+1
      mrhs=istk(l)
      l = l + nsiz*mrhs + 2
      pt=pt+1
      ids(1,pt)=l
      ids(2,pt)=lunit
      pstk(pt)=fin
      fin=lstk(top)
      comp(1)=iadr(lstk(top+1))
      rstk(pt)=904
      icall=5
c     *call* parse  macro
      return
 57   l=ids(1,pt)
      pt=pt-1
      il=iadr(lstk(top))
      il1=iadr(lstk(top+1))
      n=comp(2)-il1
      comp(2)=0
      call icopy(n,istk(il1),1,istk(l),1)
      istk(l-1)=n
      lstk(top+1)=sadr(l+n)
      istk(il)=13
      rhs=0
c     
 58   call stackp(idstk(1,top),0)
      if(job.eq.0) goto 56
c     
 59   il=iadr(lstk(top))
      istk(il)=0
      if(.not.opened) call clunit(-lunit,buf,0)
      goto 999
c     
c     --------------
c     write formatte
c     --------------
c     
 60   continue
      lw=lstk(top+1)
      il=iadr(lstk(top))
      if(rhs.gt.4.or.rhs.lt.2) then
         call error(42)
         return
      endif
      if(lhs.gt.1) then
         call error(41)
         return
      endif

c     opening file
      top2 = top
      top = top-rhs+1
      il=iadr(lstk(top))
      mode(1)=0
      mode(2)=0
      if (istk(il).eq.1) then
         lunit = int(stk(sadr(il+4)))
         if(lunit .lt. 0) then
            err=1
            call error(36)
            return
         endif
         opened=.true.
      elseif(istk(il).eq.10) then
         mn=istk(il+5)-1
         call cvstr(mn,istk(il+5+istk(il+1)*istk(il+2)),buf,1)
         lunit = 0
         call clunit(lunit,buf(1:mn),mode)
         if(err.gt.0) then
            buf(mn+1:)=' '
            call error(err)
            return
         endif
         opened=.false.
      else
         err=1
         call error(55)
         return
      endif
c     

      nc=0
      iacces=0
      if(rhs.eq.2) goto 61
      il=iadr(lstk(top2))
      if(rhs.eq.4) then
         iacces=top2-1
      else
         if(istk(il).ne.10) then
            call error(61)
            return
         endif
      endif
c     analyse du format
      if(istk(il).ne.10) then
         err=top2-top+1
         call error(55)
         return
      endif
      nc=istk(il+5)-1
      l=il+5+istk(il+1)*istk(il+2)
      ftyp=fmttyp(istk(l),nc)
      if(ftyp.eq.0) then
         call error(49)
         return
      endif
      call cvstr(nc,istk(l),buf,1)
      top2=top2-1
      fin=-fin
 61   if(iacces.ne.0) then
c     analyse des numero d'enregistrement
         ilb=iadr(lstk(iacces))
         if(istk(ilb+3).ne.0) then
            err=top2-top
            call error(52)
            return
         endif
         nb=istk(ilb+1)*istk(ilb+2)
         lb=sadr(ilb+4)
         do 62 i=1,nb
            istk(ilb-1+i)=int(stk(lb-1+i))
 62      continue
         top2=iacces-1
      endif
      il=iadr(lstk(top2))
      if(istk(il).ne.1) goto 70
      if(istk(il+3).ne.0) then
         err=top2-top+1
         call error(52)
         return
      endif
      if(fin.lt.0.and.ftyp.ne.1) then
         call error(49)
         return
      endif
      m=istk(il+1)
      n=istk(il+2)
      l=sadr(il+4)
c---- ecriture de flottants
      if(iacces.eq.0) then
c     acces sequentiel
         if(lunit.ne.wte) then
            do 63 i=1,m
               li=l+i-1
               if(fin.gt.0) write(lunit,*,err=139)
     1              (stk(li+(j-1)*m),j=1,n)
               if(fin.le.0) write(lunit,buf(1:nc),err=139)
     1              (stk(li+(j-1)*m),j=1,n)
 63         continue
         else
            do 66 i=1,m
               li=l+i-1
               if(fin.gt.0) then
                  buf=' '
                  nv=lct(5)/18
                  write(chaine,'(''('',i2,''(1x,1pd17.10))'')') nv
                  do 64 k1=1,n,nv
                     k2=min(n,k1+nv-1)
                     write(buf,chaine,err=139) 
     &                    (stk(li+(j-1)*m),j=k1,k2)
                     lc=18*(k2-k1+1)
                     call basout(io,wte,buf(1:lc))
 64               continue
               else
                  ib=nc+1
                  write(buf(ib:),buf(1:nc),err=139)
     &                 (stk(li+j*m),j=0,n-1)
                  lb1=bsiz+1
 65               lb1=lb1-1
                  if(lb1.ge.ib+1.and.buf(lb1:lb1).eq.' ') goto 65
                  call basout(io,wte,buf(ib:lb1))
               endif
 66         continue
         endif
c     
      else
c     acces direct
         if(nb.ne.m) then
            call error(42)
            return
         endif
         do 67 i=1,m
            li=l+i-1
            write(lunit,buf(1:nc),rec=istk(ilb+i-1),
     1           err=139)  (stk(li+(j-1)*m),j=1,n)
 67      continue
      endif
      goto 78
c     
c     ecriture des chaines de caracteres
 70   if(istk(il).ne.10) then
         err=top2-top+1
         call error(55)
         return
      endif
      if(fin.lt.0.and.ftyp.ne.4) then
         call error(49)
         return
      endif
      n=istk(il+2)*istk(il+1)
      m=istk(il+1)
      il=il+4
      l=il+n+1
      if(iacces.ne.0) then
         if(nb.ne.m) then
            call error(42)
            return
         endif
      endif
      do 77 i=1,n
         m=istk(il+i)-istk(il+i-1)
         if(iacces.eq.0) then
            lm=l
            if(lunit.ne.wte) then
c     fichier format libre
               if(fin.gt.0) then
                  do 73 i1=1,m,lch
                     i2=min(m,i1+lch-1)
                     m1=i2-i1+1
                     call cvstr(m1,istk(lm),chaine(1:m1),1)
                     write(lunit,*,err=139) chaine(1:m1)
                     lm=lm+m1
 73               continue
               else
c     fichier format donne
                  do 74 i1=1,m,lch
                     i2=min(m,i1+lch-1)
                     m1=i2-i1+1
                     call cvstr(m1,istk(lm),chaine(1:m1),1)
                     write(lunit,buf(1:nc),err=139) chaine(1:m1)
                     lm=lm+m1
 74               continue
               endif
            else
               if(fin.gt.0) then
c     ecran format libre
                  do 75 i1=1,m,bsiz
                     i2=min(m,i1+bsiz-1)
                     m1=i2-i1+1
                     call cvstr(m1,istk(lm),buf(1:m1),1)
                     call basout(io,lunit, buf(1:m1))
                     lm=lm+m1
 75               continue
               else
c     ecran format donne
                  m1=min(bsiz,m)
                  call cvstr(m1,istk(l),bu1,1)
                  write(bu2,buf(1:nc),err=139) bu1(1:m1)
                  lb=bsiz+1
 71               lb=lb-1
                  if(lb.ge.2.and.bu2(lb:lb).eq.' ') goto 71
                  call basout(io,wte,bu2(1:lb))
               endif
            endif
         else
c     acces direct
            m1=min(bsiz,m)
            call cvstr(m1,istk(l),bu1,1)
            write(lunit,buf(1:nc),rec=istk(ilb+i-1),err=139)
     +           bu1(1:m1)
         endif
         l=l+m
 77   continue
c     
c     fin generale de write
 78   il=iadr(lstk(top))
      istk(il)=0
      if(.not.opened) call clunit(-lunit,buf,mode)
      goto 999
c--------------
c     read formatte
c--------------
c     
 120  continue
      lw=lstk(top+1)
      il=iadr(lstk(top))
      if(rhs.gt.5.or.rhs.lt.3) then
         call error(39)
         return
      endif
      if(lhs.gt.1) then
         call error(41)
         return
      endif
c
c     opening file
      top2 = top
      top = top-rhs+1
      il=iadr(lstk(top))
      mode(1)=-1
      mode(2)=0
      if (istk(il).eq.1) then
         lunit = int(stk(sadr(il+4)))
         if(lunit .lt. 0) then
            err=1
            call error(36)
            return
         endif
         opened=.true.
      elseif(istk(il).eq.10) then
         mn=istk(il+5)-1
         call cvstr(mn,istk(il+5+istk(il+1)*istk(il+2)),buf,1)
         lunit = 0
         call clunit(lunit,buf(1:mn),mode)
         if(err.gt.0) then
            buf(mn+1:)=' '
            call error(err)
            return
         endif
         opened=.false.
      else
         err=1
         call error(55)
         return
      endif
c     
      iacces=0
      if(rhs.eq.3) goto 121
      il=iadr(lstk(top2))
      if(rhs.eq.5) then
         iacces=top2-1
      else
         if(istk(il).eq.1) then
            call error(61)
            return
         endif
      endif
c     analyse du format
      if(istk(il).ne.10) then
         err=rhs
         call error(55)
         return
      endif
      nc=istk(il+5)-1
      l=il+5+istk(il+1)*istk(il+2)
      ftyp=fmttyp(istk(l),nc)
      if(ftyp.eq.0) then
         call error(49)
         return
      endif
      call cvstr(nc,istk(l),buf,1)
      top2=top2-1
      fin=-fin
 121  if(iacces.eq.0) goto 123
      ilb=iadr(lstk(iacces))
      if(istk(ilb+3).ne.0) then
         err=top2-top+1
         call error(52)
         return
      endif
      nb=istk(ilb+1)*istk(ilb+2)
      lb=sadr(ilb+4)
      ilb=iadr(lw)
      err=sadr(ilb+nb)-lstk(bot)
      if(err.gt.0) then
         call error(17)
         return
      endif
      do 122 i=1,nb
         istk(ilb+i-1)=int(stk(lb+i-1))
 122  continue
      top2=iacces-1
 123  il=iadr(lstk(top2))
      l=sadr(il+4)
      n=int(stk(l))
      top2=top2-1
      il=iadr(lstk(top2))
      l=sadr(il+4)
      m=int(stk(l))
      il=iadr(lstk(top))
      l=sadr(il+4)
      if(m.eq.0.or.n.le.0) then
         istk(il)=1
         istk(il+1)=0
         istk(il+2)=0
         istk(il+3)=0
         lstk(top+1)=sadr(il+4)
         if(.not.opened) call clunit(-lunit,buf,mode)
         goto 999
      endif

      istk(il)=1
      istk(il+1)=m
      istk(il+2)=n
      istk(il+3)=0

      if(m.gt.0) then
         err=l+m*n-lstk(bot)
         if(err.gt.0) then
            call error(17)
            return
         endif
      endif

      if(fin.lt.0.and.ftyp.ne.1) goto 126
      if(fin.gt.0) then 
         buf(1:1)='*'
         nc=1
      endif
c     
c---- lecture de flottants
      if(iacces.eq.0) then
c     acces sequentiel
         if(m.gt.0) then
            do 124,i=0,m-1
               call dbasin(ierr,lunit,buf(1:nc),stk(l+i),m,n)
               if(ierr.eq.1) then
                  goto 997
               elseif(ierr.eq.2) then
                  goto 998
               endif
 124        continue
         else
            i=-1
 1241       i=i+1
            li=l+n*i
            err=li+n-lstk(bot)
            if(err.gt.0) then
               call error(17)
               return
            endif
            call dbasin(ierr,lunit,buf(1:nc),stk(li),1,n)
            if(ierr.eq.0) goto 1241
            if(ierr.eq.2) goto 998
            m=i
            lstk(top+1)=l+m*n
            err=lstk(top+1)+m*n-lstk(bot)
            if(err.gt.0) then
               call error(17)
               return
            endif
            l1=l+m*n
            call dcopy(m*n,stk(l),1,stk(l1),1)
            call mtran(stk(l1),n,stk(l),m,n,m)
            istk(il+1)=m
         endif         
      else
c     acces direct
         if(nb.ne.m) then
            call error(42)
            return
         endif
         if(fin.gt.0) then
            call error(61)
            return
         endif
         if(m.lt.0) then
            call  error(43)
            return
         endif
         do 125 i=0,m-1
            li=l+i
            read(lunit,buf(1:nc),rec=istk(ilb+i),err=998)
     +           (stk(li+j*m),j=0,n-1)
 125     continue
      endif
      lstk(top+1)=l+m*n
      if(.not.opened) call clunit(-lunit,buf,mode)
      goto 999
c     
c---- lecture des chaines de caracteres
 126  if(ftyp.ne.4) then
         call error(49)
         return
      endif
      if(n.ne.1) then
         err=iacces-top
         call error(36)
         return
      endif
      if(iacces.ne.0) then
         if(nb.ne.m) then
            call error(42)
            return
         endif
      endif
      ili=il+4
      if(m.gt.0) then
c     nombre de ligne a lire precise
         li=ili+m+1
         istk(ili)=1
         do 128 i=1,m
            if(iacces.eq.0) then
               call basin(ierr,lunit,buf(nc+1:),buf(1:nc))
               if(ierr.eq.1) goto 997
               if(ierr.eq.2) goto 998
            else
               read(lunit,buf(1:nc),rec=istk(ilb+i-1),err=998)
     $              buf(nc+1:)
            endif
            mn=bsiz+1
 127        mn=mn-1
            if(buf(mn:mn).eq.' ') goto 127
            mn=max(1,mn-nc)
            err=sadr(li+mn)-lstk(bot)
            if(err.gt.0) then
               call error(17)
               return
            endif
            call cvstr(mn,istk(li),buf(nc+1:),0)
            li=li+mn
            ili=ili+1
            istk(ili)=istk(ili-1)+mn
 128     continue
         istk(il)=10
         lstk(top+1)=sadr(li)
      else
         if(iacces.ne.0) then
            call error(43)
            return
         endif
         li=ili
         i=-1
 1281    i=i+1
         call basin(ierr,lunit,buf(nc+1:),buf(1:nc))
         mn=bsiz+1
 1282    mn=mn-1
         if(buf(mn:mn).eq.' ') goto 1282
         mn=max(1,mn-nc)
         err=sadr(li+mn+1)-lstk(bot)
         if(err.gt.0) then
            call error(17)
            return
         endif
         call cvstr(mn,istk(li+1),buf(nc+1:),0)
         istk(li)=mn
         li=li+mn+1
         if(ierr.eq.0) goto 1281
         if(ierr.eq.2) goto 998
         m=i
         call icopy(li-ili+1,istk(ili),-1,istk(li+2),-1)
         lis=li+2
         istk(il)=10
         istk(il+1)=m
         istk(il+2)=1
         istk(ili)=1
         li=ili+m+1
         do 1283 j=1,m
            mn=istk(lis)
            istk(ili+1)=istk(ili)+mn
            call icopy(mn,istk(lis+1),1,istk(li),1)
            lis=lis+mn+1
            li=li+mn
            ili=ili+1
 1283    continue
         lstk(top+1)=sadr(li+1)
      endif
      if(.not.opened) call clunit(-lunit,buf,0)
      goto 999

c     
c     lib
 130  continue
      lw=lstk(top+1)
      il=iadr(lstk(top))
      if(rhs.ne.1) then
         call error(42)
         return
      endif
      if(lhs.ne.1) then
         call error(41)
         return
      endif
c     path  du repertoire
      il=iadr(lstk(top))
      if(istk(il).ne.10) then
         err=1
         call error(55)
         return
      endif
      n=istk(il+5)-1
      call icopy(n,istk(il+6),1,istk(il+2),1)
      istk(il+1)=n
      istk(il)=14
      il0=il+2+n
      ilc=il0+1
      iln=ilc+nclas+1
c     
c     ouverture du fichier lib
      call cvstr(n,istk(il+2),buf,1)
      buf=buf(1:n)//'names'
      mode(1)=-1
      lunit=0
      call clunit(lunit,buf(1:n+5),mode)
      if(err.gt.0) then
         buf(n+6:)=' '
         call error(err)
         return
      endif
      m=0
      il=iln
c     lecture des noms
 131  read(lunit,'(a)',err=139,end=132) buf
      err=sadr(il+nsiz)-lstk(bot)
      if(err.gt.0) then
         call error(17)
         return
      endif
      call cvname(istk(il),buf(1:nlgh),0)
      il=il+nsiz
      m=m+1
      goto 131
 132  continue
      call clunit(-lunit,' ',0)
c     tri dans l'ordre alphabetique
      il2=il+1
      err=sadr(il2+(nsiz+1)*m)-lstk(bot)
      if(err.gt.0) then
         call error(17)
         return
      endif
      call icopy(nsiz*m,istk(iln),1,istk(il2),1)
      call iset(nclas+1,0,istk(ilc),1)
      il=iln
      il1=il
      do 133 i=1,m
         call namstr(istk(il),id,nn,1)
         ic=abs(id(1))
         if(ic.eq.percen) then
            ic=abs(id(2))
         endif
         ic=ic-9
         istk(ilc+ic)=istk(ilc+ic)+1
         istk(il1)=ic
         il=il+nsiz
         il1=il1+1
 133  continue
      il1=il2+m*nsiz
      call isort(istk(iln),m,istk(il1))
      il1=il1+m
      il=iln
      do 134 i=1,m
         il1=il1-1
         ic=istk(il1)
         call putid(istk(il),istk(il2+nsiz*(ic-1)))
         il=il+nsiz
 134  continue
c     table des pointeurs
      istk(ilc)=1
      do 135 i=1,nclas
         istk(ilc+i)=istk(ilc+i-1)+istk(ilc+i)
 135  continue
      istk(il0)=m
      lstk(top+1)=sadr(iln+m*nsiz)
      goto 999
c     
 139  call error(49)
      if(.not.opened) call clunit(-lunit,buf,0)
      return
c     
c     filemgr
c     
 140  continue
      lw=lstk(top+1)
      il=iadr(lstk(top))
      if(lhs.ne.1) then
         call error(41)
         return
      endif
c     action
      il=iadr(lstk(top+1-rhs))
      if(istk(il).ne.10) then
         err=1
         call error(55)
         return
      endif
      l=il+5+istk(il+1)*istk(il+2)
      itype=abs(istk(l))
      if(itype.ne.ope) goto 150
c     
c     open
 141  if(rhs.gt.6) then
         call error(39)
         return
      endif
c     path
      il=iadr(lstk(top+2-rhs))
      if(istk(il).ne.10) then
         err=2
         call error(55)
         return
      endif
      l=il+5+istk(il+1)*istk(il+2)
      mn=istk(il+5)-1
      buf=' '
      call cvstr(mn,istk(l),buf,1)
      rhs=rhs-2
      status=0
      access=0
      form=0
      recl=0
      if(rhs.eq.0) goto 145
      do 143 i=1,rhs
         il=iadr(lstk(top))
         if(istk(il).eq.10) then
            l=il+5+istk(il+1)*istk(il+2)
            if(istk(il+5)-1.lt.3) then
               call error(36)
               return
            endif
            itype=abs(istk(l))+256*(abs(istk(l+1))+256*abs(istk(l+2)))
            if(itype.eq.new) then
               status=0
            elseif(itype.eq.old) then
               status=1
            elseif(itype.eq.scratc) then
               status=2
            elseif(itype.eq.unknow) then
               status=3
            elseif(itype.eq.sequen) then
               access=0
            elseif(itype.eq.direct) then
               access=1
            elseif(itype.eq.forma1) then
               form=0
            elseif(itype.eq.unform) then
               form=1
            endif
         elseif(istk(il).eq.1) then
            recl=int(stk(sadr(il+4)))
            mode(2)=recl
         else
            err=i
            call error(53)
            return
         endif
         top=top-1
 143  continue
 145  mode(1)=status+10*(access+10*(form))
      lunit=0
      call clunit(lunit,buf(1:mn),mode)
      if(err.gt.0) then
         buf(mn+1:)=' '
         call error(err)
         return
      endif
      top=top-1
      il=iadr(lstk(top))
      istk(il)=1
      istk(il+1)=1
      istk(il+2)=1
      istk(il+3)=0
      l=sadr(il+4)
      stk(l)=dble(lunit)
      lstk(top+1)=l+1
      goto 999
c     
 150  continue
      if(rhs.ne.2) then
         call error(36)
         return
      endif
      il1=iadr(lstk(top))
      if(istk(il1).ne.1) then
         err=rhs
         call error(53)
         return
      endif
      lunit=int(stk(sadr(il1+4)))
      top=top-1
      if(itype.ne.clo) goto 151
c     close
      call clunit(-lunit,buf,0)
      istk(il)=0
      goto 999
 151  if(itype.ne.rew) goto 152
c     rewind
      rewind(lunit)
      istk(il)=0
      goto 999
 152  if(itype.ne.bak) goto 153
c     backspace
      backspace(lunit)
      istk(il)=0
      goto 999
c     last
 153  if(itype.ne.last) go to 157
 154  read(lunit,'(a)',err=156,end=155)
      go to 154
 155  backspace(lunit)
      istk(il)=0
      go to 999
 156  call error(49)
      return
 157  call error(36)
      return
c     
c     macsym
 160  continue
      goto 999
c     
c     host  (appel du system hote)
c     
 170  continue
      lw=lstk(top+1)
      il=iadr(lstk(top))
      if(rhs.ne.1) then
         call error(42)
         return
      endif
      if(lhs.gt.1) then
         call error(41)
         return
      endif

      if(istk(il).ne.10) then
         err=1
         call error(55)
         return
      endif
      if(istk(il+1)*istk(il+2).ne.1) then
         err=1
         call error(89)
         return
      endif
      ilf=il+6
      lc=istk(il+5)-istk(il+4)
      if (lc.gt.0) call cvstr(lc,istk(ilf),buf,1)
      call bashos(buf,lc,ls,ierr)
      if(ierr.ne.0) then
         call error(85)
         return
      endif
      if(ls.gt.0) then
         call cvstr(ls,istk(ilf),buf,0)
         istk(il+5)=istk(il+4)+ls
         lstk(top+1)=sadr(il+6+ls)
      else
         istk(il)=0
         lstk(top+1)=lstk(top)+1
      endif
      goto 999
c     
c     -------------
c     write binaire
c     -------------
c     
 180  continue
      lw=lstk(top+1)
      il=iadr(lstk(top))
      if(lhs.gt.1) then
         call error(41)
         return
      endif

c     opening file
      top2 = top
      top = top-rhs+1
      il=iadr(lstk(top))
      mode(1)=100
      mode(2)=0
      if (istk(il).eq.1) then
         lunit = int(stk(sadr(il+4)))
         if(lunit .lt. 0) then
            err=1
            call error(36)
            return
         endif
         opened=.true.
      elseif(istk(il).eq.10) then
         mn=istk(il+5)-1
         call cvstr(mn,istk(il+5+istk(il+1)*istk(il+2)),buf,1)
         lunit = 0
         call clunit(lunit,buf(1:mn),mode)
         if(err.gt.0) then
            buf(mn+1:)=' '
            call error(err)
            return
         endif
         opened=.false.
      else
         err=1
         call error(55)
         return
      endif
c     
      if(lunit.eq.wte) then
         call error(49)
         return
      endif
      if(rhs.ne.2) then
         call error(39)
         return
      endif
      nc=0
      il=iadr(lstk(top2))
      if(istk(il).ne.1) then
         err=2
         call error(53)
         return
      endif
      if(istk(il+3).ne.0) then
         err=2
         call error(52)
         return
      endif
c     
      m=istk(il+1)
      n=istk(il+2)
      l=sadr(il+4)
      li=l
      do 181 i=1,m
         write(lunit,err=998) (stk(li+(j-1)*m),j=1,n)
         li=li+1
 181  continue
c     
      il=iadr(lstk(top))
      istk(il)=0
      if(.not.opened) call clunit(-lunit,buf,mode)
      goto 999
c     
c     ------------
c     read binaire
c     ------------
c     
 190  continue
      lw=lstk(top+1)
      il=iadr(lstk(top))
      if(lhs.ne.1) then
         call error(42)
         return
      endif
      if(rhs.ne.3) then
         call error(39)
         return
      endif

c     opening file
      top2 = top
      top = top-rhs+1
      il=iadr(lstk(top))
      mode(1)=-101
      mode(2)=0
      if (istk(il).eq.1) then
         lunit = int(stk(sadr(il+4)))
         if(lunit .lt. 0) then
            err=1
            call error(36)
            return
         endif
         opened=.true.
      elseif(istk(il).eq.10) then
         mn=istk(il+5)-1
         call cvstr(mn,istk(il+5+istk(il+1)*istk(il+2)),buf,1)
         lunit = 0
         call clunit(lunit,buf(1:mn),mode)
         if(err.gt.0) then
            buf(mn+1:)=' '
            call error(err)
            return
         endif
         opened=.false.
      else
         err=1
         call error(55)
         return
      endif
c     
      if(lunit.eq.wte) then
         call error(49)
         return
      endif
c     
      il=iadr(lstk(top2))
      if(istk(il).ne.1) then
         err=3
         call error(53)
         return
      endif
      if(istk(il+3).ne.0) then
         err=3
         call error(52)
         return
      endif
      if(istk(il+1)*istk(il+2).ne.1) then
         err=3
         call error(89)
         return
      endif
      l=sadr(il+4)
      n=int(stk(l))
c     
      top2=top2-1
      il=iadr(lstk(top2))
      if(istk(il).ne.1) then
         err=2
         call error(53)
         return
      endif
      if(istk(il+3).ne.0) then
         err=2
         call error(52)
         return
      endif
      if(istk(il+1)*istk(il+2).ne.1) then
         err=2
         call error(89)
         return
      endif
      l=sadr(il+4)
      m=int(stk(l))
c     
      il=iadr(lstk(top))
      if(m.eq.0.or.n.le.0) then
         istk(il)=1
         istk(il+1)=0
         istk(il+2)=0
         istk(il+3)=0
         lstk(top+1)=sadr(il+4)
         if(.not.opened) call clunit(-lunit,buf,mode)
         goto 999
      endif

      l=sadr(il+4)
      istk(il)=1
      istk(il+1)=m
      istk(il+2)=n
      istk(il+3)=0

      if(m.gt.0) then
         err=l+m*n-lstk(bot)
         if(err.gt.0) then
            call error(17)
            return
         endif
      endif
c     
      if(m.gt.0) then
         do 191 i=0,m-1
            read(lunit,end=997,err=998) (stk(l+i+j*m),j=0,n-1)
 191     continue
      else
         i=-1
 192     i=i+1
         li=l+n*i
         err=li+n-lstk(bot)
         if(err.gt.0) then
            call error(17)
            return
         endif
         read(lunit,end=193,err=998) (stk(li+j),j=0,n-1)
         goto 192
 193     m=i
         lstk(top+1)=l+m*n
         err=lstk(top+1)+m*n-lstk(bot)
         if(err.gt.0) then
            call error(17)
            return
         endif
         l1=l+m*n
         call dcopy(m*n,stk(l),1,stk(l1),1)
         call mtran(stk(l1),n,stk(l),m,n,m)
         istk(il+1)=m
      endif
      lstk(top+1)=l+m*n
      if(.not.opened) call clunit(-lunit,buf,mode)
      goto 999
c
c     disp
c     ----
 200  continue
      lw=lstk(top+1)
      il=iadr(lstk(top))
      if(rhs.lt.1) then
         call error(42)
         return
      endif
      if(lhs.gt.1) then
         call error(41)
         return
      endif
      id(1)=0
      do 201 i=1,rhs
         call print(id,top,wte)
         top=top-1
 201  continue
      top=top+1
      il=iadr(lstk(top))
      istk(il)=0
      lstk(top+1)=lstk(top)+1

      go to 999

c     
c     getpid get process id 
 205  continue
      if(lhs.ne.1) then
         call error(42)
         return
      endif
      if(rhs.ge.1) then
         call error(39)
         return
      endif
      top=top+1
      il=iadr(lstk(top))
      l=sadr(il+4)
      err=l+1-lstk(bot)
      if(err.gt.0) then
         call error(17)
         return
      endif
      istk(il)=1
      istk(il+1)=1
      istk(il+2)=1
      istk(il+3)=0
      call getpidc(idp)
      stk(l)=idp
      lstk(top+1)=l+1
      goto 999
c
c     getenv

 210  continue
      if(rhs.ne.1) then
         call error(42)
         return
      endif
      if(lhs.gt.1) then
         call error(41)
         return
      endif
      lw=lstk(top+1)
      il=iadr(lstk(top))

      if(istk(il).ne.10) then
         err=1
         call error(55)
         return
      endif
      if(istk(il+1)*istk(il+2).ne.1) then
         err=1
         call error(89)
         return
      endif
      ilf=il+6
      lc=istk(il+5)-istk(il+4)
      if (lc.gt.0) call cvstr(lc,istk(ilf),buf,1)
      call getenvc(ierr,buf(1:lc)//char(0),buf)
      if(ierr.ne.0) then
         buf='Undefined environment variable'
         call error(999)
         return
      endif
      ls=0
 211  ls=ls+1
      if(buf(ls:ls).ne.char(0).and.ls.lt.bsiz) goto 211
      ls=ls-1
      if(ls.gt.0) then
         call cvstr(ls,istk(ilf),buf,0)
         istk(il+5)=istk(il+4)+ls
         lstk(top+1)=sadr(il+6+ls)
      else
         istk(il)=0
         lstk(top+1)=lstk(top)+1
      endif
      goto 999


c     --------------
c     erreur lecture
c     --------------
c     
 997  err=i
      call error(62)
      if(.not.opened) call clunit(-lunit,buf,mode)
      return
 998  call error(49)
      if(.not.opened) call clunit(-lunit,buf,mode)
      return
c     
 999  return
      end

