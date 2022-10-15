      subroutine matio
c     ====================================================================
c     
c     file handling and other i/o
c     
c     ====================================================================
c     
c     Copyright INRIA
      INCLUDE '../stack.h'
      integer    lch
      parameter (lch=1024)
      character chaine*(lch)
c     
      integer blank,flag,top2,tops,topk,semi,percen,id(nlgh),h(nsiz)
      integer status,access,form,recl,old,new,scratc,unknow
      integer sequen,direct,forma1,unform
      integer clo,rew,bak,ope,ftyp,fmttyp,mode(2),retu(6),comma,eol
      integer nocomp
      double precision eps,xxx
      logical opened,eptover
      integer iadr,sadr
      character bu1*(bsiz),bu2*(bsiz)
c
      save opened,lunit,job,icomp
c     
      data blank/40/,semi/43/,percen/56/
      data old/857368/,new/2100759/,scratc/1707037/,unknow/1316638/
      data sequen/1707548/,direct/1774093/,forma1/1775631/
      data unform/988958/
      data clo/12/,ope/24/,rew/27/,bak/11/,last/21/,nclas/29/
      data retu/27,14,29,30,27,23/,comma/52/,eol/99/
      data nocomp/23/
c     
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
c     
      if (ddt .eq. 4) then
         write(buf(1:4),'(i4)') fin
         call basout(io,wte,' matio '//buf(1:4))
      endif
c     
      tops=top
c
      if(int(rstk(pt)/100).ne.9) goto 01
      if(rstk(pt).eq.902) goto 12
      if(rstk(pt).eq.903) goto 24
      if(rstk(pt).eq.904) goto 57
      if(rstk(pt).eq.908) goto 203
      if(rstk(pt).eq.909) goto 16
c     
c     functions/fin
c     
c     load read  getf exec lib   diary save write print mac  deff rat
c     1    2     3    4     5     6    7     8     9    10   11   12
c     file hosts readb writb execstr  disp  getpid getenv read4b write4b
c     13   14    15    16     17      18     19     20     22      23
c     
c     
 01   goto ( 35, 120, 54,10, 130,27, 30,60, 25, 160,
     +       50, 45, 140,170,190,180,20,200,205,210,
     +       170,220,230),fin
c     
c     exec
 10   continue
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
      if(istk(il).eq.11.or.istk(il).eq.13) goto 15
      mode(1)=-1
      mode(2)=0
      call v2unit(top,mode,lunit,opened,ierr)
      if(ierr.gt.0) return
c     
      flag = 3
      if (sym .eq. semi) flag = 0
      if(rhs.eq.1) goto 11
      il2=iadr(lstk(top2))
      l=sadr(il2+4)
      flag = int(stk(l))
      if(flag.ge.4) call basout(io,wte,
     &     'step-by-step mode: enter carriage return to proceed')
 11   top=top-1
      pt=pt+1
      pstk(pt)=rio
      rio = lunit
      rstk(pt)=902
      icall=5
      fin=flag
c     *call*  macro
      go to 999
 12   call clunit(-rio,buf,mode)
      rio=pstk(pt)
      pt=pt-1
      top=top+1
      il=iadr(lstk(top))
      istk(il)=0
      lstk(top+1)=sadr(il+1)
      goto 999

c     exec of a function
 15   continue
      flag = 3
      if (sym .eq. semi) flag = 0
      if(rhs.eq.2) then
         il2=iadr(lstk(top2))
         l=sadr(il2+4)
         flag = int(stk(l))
         if(flag.ge.4) call basout(io,wte,
     &        'step-by-step mode: enter carriage return to proceed')
         top=top-1
      endif
      rstk(pt)=909
      icall=5
c     *call*  macro
      go to 999
 16   pt=pt-1
      top=top+1
      il=iadr(lstk(top))
      istk(il)=0
      lstk(top+1)=sadr(il+1)
      goto 999
c     
c     execstr
 20   continue
      if(rhs.ne.1.and.rhs.ne.2) then
         call error(39)
         return
      endif
      if(rhs.eq.2) then
         rhs=1
         top=top-1
         icheck=1
      else
         icheck=0
      endif
      lw=lstk(top+1)
      il=iadr(lstk(top))
      if(lhs.gt.1) then
         call error(41)
         return
      endif
      if(istk(il).ne.10) then 
         if(istk(il).eq.1.and.istk(il+1).eq.0) then
            istk(il)=0
            lstk(top+1)=lstk(top)+1
            return
         endif
         err=1
         call error(55)
         return
      endif
      n=istk(il+1)*istk(il+2)
      l=il+5+n
      if(n.gt.1) then
c     .  add <eol> at the end of the first n-1 lines
         i1=n-1
         do 21 i=n,2,-1
            ld=l+istk(il+3+i)-1
            ln=istk(il+4+i)-istk(il+3+i)
            call icopy(ln,istk(ld),-1,istk(ld+i1),-1)
            i1=i1-1
            istk(ld+i1)=eol
            istk(il+4+i)=istk(il+4+i)+i-1
 21      continue 
      endif
c     add ",return,<eol>,<eol>" at the end of the last line
      l1=l-1+istk(l-1)
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
c     error control
      ids(2,pt)=errct
      ids(3,pt)=err2
      ids(4,pt)=err1
      if(icheck.eq.0) then
         ids(1,pt)=0
      else
         ids(1,pt)=1
         errct=-900001
      endif
      icall=5
c     *call*  macro
      go to 999
 24   continue
      if(ids(1,pt).eq.1) then
c     return error number
         il=iadr(lstk(top))
         istk(il)=1
         istk(il+1)=1
         istk(il+2)=1
         istk(il+3)=0
         l=sadr(il+4)
         stk(l)=err1
         lstk(top+1)=l+1
         errct=ids(2,pt)
         err2=ids(3,pt)
         err1=ids(4,pt)
         fun=0
      else
         il=iadr(lstk(top))
         istk(il)=0
         lstk(top+1)=lstk(top)+1
         err1=0
      endif

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
      call v2unit(top,mode,lunit,opened,ierr)
      if(ierr.gt.0) return
c     
      l = lct(2)
      if(lunit.ne.wte) then
         lct(2) = 0
      endif
      top=top2
      do 26 i=2,rhs
         tops=top
         call print(idstk(1,top),tops,lunit)
         top=top-1
 26   continue
      lct(2) = l
      istk(il)=0
      if(.not.opened) then
         mode(1)=0
         mode(2)=0
         call clunit(-lunit,buf,mode)
      endif
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
      call v2unit(top,mode,lunit,opened,ierr)
      if(ierr.gt.0) return

c     
      if(wio.ne.0) then
         mode(1)=0
         mode(2)=0
         call clunit(-wio,buf,mode)
      endif
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
      call v2unit(top,mode,lunit,opened,ierr)
      if(ierr.gt.0) return
c     
      call savlod(lunit,id,-1,top)
      if(err.gt.0) goto 33
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
 33   if(.not.opened) then
         mode(1)=0
         mode(2)=0
         call clunit(-lunit,buf,mode)
      endif
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
      call v2unit(top,mode,lunit,opened,ierr)
      if(ierr.gt.0) return
      call savlod(lunit,id,-2,top)
      if(err.gt.0) goto 39
c     
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
 39   if(.not.opened) then
         mode(1)=0
         mode(2)=0
         call clunit(-lunit,buf,mode)
      endif
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
      if(rhs.gt.2) then
         call error(42)
         return
      endif
      if(lhs.gt.2) then
         call error(41)
         return
      endif
      if(rhs.eq.2) then
         il=iadr(lstk(top))
         if(istk(il).ne.1) then
            err=2
            call error(52)
            return
         endif
         eps=stk(sadr(il+4))
         top=top-1
      else
         eps=1.d-6
      endif
      lw=lstk(top+1)
      il=iadr(lstk(top))
      l=sadr(il+4)

      il=iadr(lstk(top))
      if(istk(il).ne.1) then
         call funnam(ids(1,pt+1),'rat',iadr(lstk(top)))
         top=tops
         fun=-1
         return
      endif
      l=sadr(il+4)
      m=istk(il+1)
      n=istk(il+2)
      it=istk(il+3)
      mn=m*n*(it+1)
      
      l2 = l
c     
      if(lhs.eq.1) goto 48
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
      xxx=0.0d0
      do 47 i1=0,mn-1
         xxx=max(xxx,abs(stk(l+i1)))
 47   continue
      if(xxx.gt.0.0d0) eps=eps*xxx
 48   do 49 i=1,mn
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
 49   continue
      go to 999
c     
c     deff
 50   continue
      icomp=1
      if(rhs.eq.3) then
         ilc=iadr(lstk(top))
         if(istk(ilc).eq.10) then
            if(istk(ilc+5+istk(ilc+1)*istk(ilc+2)).eq.nocomp) then
               icomp=0
            endif
         endif
         rhs=rhs-1
         top=top-1
      endif
      if(rhs.ne.2) then
         call error(42)
         return
      endif
      if(lhs.gt.1) then
         call error(41)
         return
      endif
      lw=lstk(top+1)
      il=iadr(lstk(top))
      call getfun(0)
      if(err.gt.0) goto 999
      if(icomp.eq.1) then
         call dcopy(lstk(top+1)-lstk(top),stk(lstk(top)),1,
     $       stk(lstk(top-1)),1) 
         lstk(top)=lstk(top-1)+lstk(top+1)-lstk(top)
         call putid(idstk(1,top-1),idstk(1,top))
         top=top-1
         job=1
         opened=.true.
         goto 56
      endif
      call stackp(idstk(1,top),0)
      top=top-1
      il=iadr(lstk(top))
      istk(il)=0
      fun=0
      goto 999
c     
c     getf
 54   continue
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
      call v2unit(top,mode,lunit,opened,ierr)
      if(ierr.gt.0) return
c     
      if(rhs.gt.1) then
         ilc=iadr(lstk(top+1))
         icomp=1
         if(istk(ilc).eq.10) then
            if(istk(ilc+5+istk(ilc+1)*istk(ilc+2)).eq.nocomp) then
               icomp=0
            endif
         endif
      else
         icomp=1
      endif
 55   call getfun(lunit)
      fun=0
      job=fin
      if(err.gt.0.or.err1.gt.0) then

         if(.not.opened) then
            mode(1)=0
            mode(2)=0
            call clunit(-lunit,buf,mode)
         endif
         return
      endif
      if(job.lt.0) goto 59
      if(icomp.ne.1) goto 58
c     procedure de compilation des macros (copie de ce qui est dans matsys)
 56   rhs=1
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
      comp(2)=0
      comp(3)=0
      rstk(pt)=904
      icall=5
c     *call* parse  macro
      return
 57   l=ids(1,pt)
      pt=pt-1
      if(err1.ne.0) then
         comp(2)=0
         comp(1)=0
         il=iadr(lstk(top))
         istk(il)=0
         lhs=0
         err2=err1
         err1=0
         return
      endif
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
      if(job.eq.0) goto 55

c     
 59   il=iadr(lstk(top))
      istk(il)=0
      comp(1)=0
      fun=0
      if(.not.opened) then
            mode(1)=0
            mode(2)=0
            call clunit(-lunit,buf,mode)
      endif
      goto 999
c     
c     --------------
c     write formatte
c     --------------
c     
 60   continue
      ftyp=0
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
      call v2unit(top,mode,lunit,opened,ierr)
      if(ierr.gt.0) return
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
            goto 996
         endif
      endif
c     analyse du format
      if(istk(il).ne.10) then
         err=top2-top+1
         call error(55)
         goto 996
      endif
      nc=istk(il+5)-1
      l=il+5+istk(il+1)*istk(il+2)
      ftyp=fmttyp(istk(l),nc)
      if(ftyp.eq.0) then
         call error(49)
         goto 996
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
         goto 996
      endif
      if(fin.lt.0.and.ftyp.ne.1.and.ftyp.ne.2) then
         call error(49)
         goto 996
      endif
      m=istk(il+1)
      n=istk(il+2)
      l=sadr(il+4)
      if(ftyp.eq.2) then
         call entier(m*n,stk(l),istk(iadr(l)))
         l=iadr(l)
      endif
c---- ecriture de flottants
      if(iacces.eq.0) then
c     acces sequentiel
         if(lunit.ne.wte) then
            do 63 i=1,m
               li=l+i-1
               if(fin.gt.0) then
                  write(lunit,*,err=139)
     1                 (stk(li+(j-1)*m),j=1,n)
               else
                  if(ftyp.eq.1) then
                     write(lunit,buf(1:nc),err=139)
     1                    (stk(li+(j-1)*m),j=1,n)
                  else
                     write(lunit,buf(1:nc),err=139)
     1                    (istk(li+(j-1)*m),j=1,n)
                  endif
               endif
 63         continue
         else
            do 68 i=1,m
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
                  if(ftyp.eq.1) then
                     write(buf(ib:),buf(1:nc),err=139)
     &                    (stk(li+j*m),j=0,n-1)
                  else
                     write(buf(ib:),buf(1:nc),err=139)
     &                    (istk(li+j*m),j=0,n-1)
                  endif
                  lb1=bsiz+1
 66               lb1=lb1-1
                  if(lb1.ge.ib+1.and.buf(lb1:lb1).eq.' ') goto 66
                  call basout(io,wte,buf(ib:lb1))
               endif
 68         continue
         endif
c     
      else
c     acces direct
         if(nb.ne.m) then
            call error(42)
            goto 996
         endif
         do 69 i=1,m
            li=l+i-1
            if(ftyp.eq.1) then
               write(lunit,buf(1:nc),rec=istk(ilb+i-1),
     1              err=139)  (stk(li+(j-1)*m),j=1,n)
            else
               write(lunit,buf(1:nc),rec=istk(ilb+i-1),
     1              err=139)  (istk(li+(j-1)*m),j=1,n)
            endif
 69      continue
      endif
      goto 78
c     
c     ecriture des chaines de caracteres
 70   if(istk(il).ne.10) then
         err=top2-top+1
         call error(55)
         goto 996
      endif
      if(fin.lt.0.and.ftyp.ne.4) then
         call error(49)
         goto 996
      endif
      n=istk(il+2)*istk(il+1)
      m=istk(il+1)
      il=il+4
      l=il+n+1
      if(iacces.ne.0) then
         if(nb.ne.m) then
            call error(42)
            goto 996
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
      if(.not.opened) then
            mode(1)=0
            mode(2)=0
            call clunit(-lunit,buf,mode)
      endif
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
      call v2unit(top,mode,lunit,opened,ierr)
      if(ierr.gt.0) return
c     
      iacces=0
      if(rhs.eq.3) goto 121
      il=iadr(lstk(top2))
      if(rhs.eq.5) then
         iacces=top2-1
      else
         if(istk(il).eq.1) then
            call error(61)
            goto 996
         endif
      endif
c     analyse du format
      if(istk(il).ne.10) then
         err=rhs
         call error(55)
         goto 996
      endif
      nc=istk(il+5)-1
      l=il+5+istk(il+1)*istk(il+2)
      ftyp=fmttyp(istk(l),nc)
      if(ftyp.eq.0) then
         call error(49)
         goto 996
      endif
      call cvstr(nc,istk(l),buf,1)
      top2=top2-1
      fin=-fin
 121  if(iacces.eq.0) goto 123
      ilb=iadr(lstk(iacces))
      if(istk(ilb+3).ne.0) then
         err=top2-top+1
         call error(52)
         goto 996
      endif
      nb=istk(ilb+1)*istk(ilb+2)
      lb=sadr(ilb+4)
      ilb=iadr(lw)
      err=sadr(ilb+nb)-lstk(bot)
      if(err.gt.0) then
         call error(17)
         goto 996
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
         if(.not.opened) then
            mode(1)=0
            mode(2)=0
            call clunit(-lunit,buf,mode)
         endif
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
c     .     nombre de ligne precise
            do 124,i=0,m-1
               call dbasin(ierr,lunit,buf(1:nc),stk(l+i),m,n)
               if(ierr.eq.1) then
                  goto 997
               elseif(ierr.eq.2) then
                  goto 998
               endif
 124        continue
         else
c     .     nombre de ligne non precise
            i=-1
 1241       i=i+1
            li=l+n*i
            err=li+n-lstk(bot)
            if(err.gt.0) then
               call error(17)
               goto 996
            endif
            call dbasin(ierr,lunit,buf(1:nc),stk(li),1,n)
            if(ierr.eq.0) goto 1241
            if(ierr.eq.2) goto 998
            m=i
            if(m.ne.0) then
               if(m.ge.1.and.n.ge.1) then
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
               istk(il+1)=0
               istk(il+2)=0
            endif
         endif         
      else
c     acces direct
         if(nb.ne.m) then
            call error(42)
            goto 996
         endif
         if(fin.gt.0) then
            call error(61)
            goto 996
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
      if(.not.opened) then
         mode(1)=0
         mode(2)=0
         call clunit(-lunit,buf,mode)
      endif
      goto 999
c     
c---- lecture des chaines de caracteres
 126  if(ftyp.ne.4) then
         call error(49)
         goto 996
      endif
      if(n.ne.1) then
         err=iacces-top
         call error(36)
         goto 996
      endif
      if(iacces.ne.0) then
         if(nb.ne.m) then
            call error(42)
            goto 996
         endif
      endif
      ili=il+4
      if(m.gt.0) then
c     .  nombre de ligne a lire precise
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
c     .  nombre de ligne a lire non precise
         if(iacces.ne.0) then
            call error(43)
            goto 996
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
            goto 996
         endif
         call cvstr(mn,istk(li+1),buf(nc+1:),0)
         istk(li)=mn
         li=li+mn+1
         if(ierr.eq.0) goto 1281
         if(ierr.eq.2) goto 998
         m=i
         if(m.le.0) then
            istk(il)=1
            istk(il+1)=0
            istk(il+2)=0
            istk(il+3)=0
            lstk(top+1)=sadr(il+4)
         else
            call icopy(li-ili+1,istk(ili),-1,istk(li+2),-1)
            lis=li+2
            istk(il)=10
            istk(il+1)=m
            istk(il+2)=min(m,1)
            istk(ili)=1
            li=ili+m+1
            do 1283 j=1,m
               mn=istk(lis)
               istk(ili+1)=istk(ili)+mn
               call icopy(mn,istk(lis+1),1,istk(li),1)
               lis=lis+mn+1
               li=li+mn
               ili=ili+1
 1283       continue
            lstk(top+1)=sadr(li+1)
         endif
      endif
      if(.not.opened) then
         mode(1)=0
         mode(2)=0
         call clunit(-lunit,buf,mode)
      endif
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
      mode(1)=0
      mode(2)=0
      call clunit(-lunit,' ',mode)
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
         ic=max(1,ic-9)
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
      if(.not.opened) then
         mode(1)=0
         mode(2)=0
         call clunit(-lunit,buf,mode)
      endif
      return
c     
c     filemgr
c     
 140  continue
      lw=lstk(top+1)
      il=iadr(lstk(top))
      if(lhs.gt.2) then
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
      if(istk(il+1)*istk(il+2).ne.1) then
         err=1
         call error(36)
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
      if(istk(il+1)*istk(il+2).ne.1) then
         err=2
         call error(36)
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
         if(lhs.eq.1) then
            buf(mn+1:)=' '
            call error(err)
            return
         else
           top=top-1
           il=iadr(lstk(top))
           istk(il)=1
           istk(il+1)=0
           istk(il+2)=0
           istk(il+3)=0
           l=sadr(il+4)
           lstk(top+1)=l+1 

           top=top+1
           il=iadr(lstk(top))
           istk(il)=1
           istk(il+1)=1
           istk(il+2)=1
           istk(il+3)=0
           l=sadr(il+4)
           stk(l)=err
           lstk(top+1)=l+1
           err=0
           return
        endif
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
      if(lhs.eq.2) then
           top=top+1
           il=iadr(lstk(top))
           istk(il)=1
           istk(il+1)=1
           istk(il+2)=1
           istk(il+3)=0
           l=sadr(il+4)
           stk(l)=0.0d0
           lstk(top+1)=l+1
        endif

         
      goto 999
c     
 150  continue
      if(lhs.ne.1) then
         call error(41)
         return
      endif
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
      mode(1)=0
      call clunit(-lunit,buf,mode)
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
      istk(il)=1
      istk(il+1)=1
      istk(il+2)=1
      istk(il+3)=0
      l=sadr(il+4)
      stk(l)=ierr
      lstk(top+1)=l+1
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

      if(rhs.eq.3) then
         iacces=top
         ilb=iadr(lstk(iacces))
         if(istk(ilb+3).ne.0) then
            err=3
            call error(52)
            return
         endif
         nb=istk(ilb+1)*istk(ilb+2)
         lb=sadr(ilb+4)
         top=top-1
         rhs=rhs-1
         mode(1)=110
      elseif(rhs.eq.2) then
         mode(1)=100
         iacces=0
      else
         call error(39)
         return
      endif


c     opening file
      top2 = top
      top = top-rhs+1
      il=iadr(lstk(top))
      mode(2)=0
      call v2unit(top,mode,lunit,opened,ierr)
      if(ierr.gt.0) return
c     
      if(lunit.eq.wte) then
         call error(49)
         goto 996
      endif
      nc=0
      il=iadr(lstk(top2))
      if(istk(il).ne.1) then
         err=2
         call error(53)
         goto 996
      endif
      if(istk(il+3).ne.0) then
         err=2
         call error(52)
         goto 996
      endif

c     
      m=istk(il+1)
      n=istk(il+2)
      l=sadr(il+4)
      if(iacces.ne.0) then
         if(nb.ne.m) then
            call error(42)
            goto 996
         endif
         call entier(nb,stk(lb),istk(ilb))
         li=l
         do 181 i=1,m
            write(lunit,rec=istk(ilb-1+i),err=998)
     $           (stk(li+(j-1)*m),j=1,n)
            li=li+1
 181     continue
      else
         li=l
         do 182 i=1,m
            write(lunit,err=998) (stk(li+(j-1)*m),j=1,n)
            li=li+1
 182     continue
      endif
c     
      il=iadr(lstk(top))
      istk(il)=0
      if(.not.opened) then
         mode(1)=0
         mode(2)=0
         call clunit(-lunit,buf,mode)
      endif
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
      iacces=0
      mode(2)=0
      if(rhs.eq.4) then
         iacces=top
         ilb=iadr(lstk(iacces))
         if(istk(ilb+3).ne.0) then
            err=top
            call error(52)
            return
         endif
         nb=istk(ilb+1)*istk(ilb+2)
         lb=sadr(ilb+4)
         top=top-1
         rhs=rhs-1
         mode(1)=-111
      elseif(rhs.eq.3) then  
         mode(1)=-101
      else
         call error(39)
         return
      endif
c     opening file
      top2 = top
      top = top-rhs+1
      il=iadr(lstk(top))

      call v2unit(top,mode,lunit,opened,ierr)
      if(ierr.gt.0) return
c     
      if(lunit.eq.wte) then
         call error(49)
         goto 996
      endif
c     
      il=iadr(lstk(top2))
      if(istk(il).ne.1) then
         err=3
         call error(53)
         goto 996
      endif
      if(istk(il+3).ne.0) then
         err=3
         call error(52)
         return
      endif
      if(istk(il+1)*istk(il+2).ne.1) then
         err=3
         call error(89)
         goto 996
      endif
      l=sadr(il+4)
      n=int(stk(l))
c     
      top2=top2-1
      il=iadr(lstk(top2))
      if(istk(il).ne.1) then
         err=2
         call error(53)
         goto 996
      endif
      if(istk(il+3).ne.0) then
         err=2
         call error(52)
         goto 996
      endif
      if(istk(il+1)*istk(il+2).ne.1) then
         err=2
         call error(89)
         goto 996
      endif
      l=sadr(il+4)
      m=int(stk(l))
      if(iacces.ne.0) then
         if(m.ne.nb) then
            call error(42)
            goto 996
         endif
      endif
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
         lw=l+m*n
         if(iacces.ne.0) then
            ilb=iadr(lw)
            lw=sadr(ilb+nb)
         endif
         err=lw-lstk(bot)
         if(err.gt.0) then
            call error(17)
            goto 996
         endif
      endif
c     
      if(iacces.eq.0) then
c     .  sequential acces
         if(m.gt.0) then
            do 191 i=0,m-1
               read(lunit,end=997,err=998) (stk(l+i+j*m),j=0,n-1)
 191        continue
         else
            i=-1
 192        i=i+1
            li=l+n*i
            err=li+n-lstk(bot)
            if(err.gt.0) then
               call error(17)
               goto 996
            endif
            read(lunit,end=193,err=998) (stk(li+j),j=0,n-1)
            goto 192
 193        m=i
            lstk(top+1)=l+m*n
            err=lstk(top+1)+m*n-lstk(bot)
            if(err.gt.0) then
               call error(17)
               goto 996
            endif
            l1=l+m*n
            call dcopy(m*n,stk(l),1,stk(l1),1)
            call mtran(stk(l1),n,stk(l),m,n,m)
            istk(il+1)=m
         endif
      else
c     .  direct access
         call entier(nb,stk(lb),istk(ilb))
         do 194 i=0,m-1
            read(lunit,rec=istk(ilb+i),err=998)
     $           (stk(l+i+j*m),j=0,n-1)
 194     continue
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

c     loop on variable to display
      i=1
 201  continue
      topk=top
 202  call print(id,topk,wte)
      if(topk.eq.0) goto 204
c     overloaded display call macro
      if ( eptover(1,psiz)) return
      rstk(pt)=908
      pstk(pt)=i
      ids(1,pt)=rhs
      icall=5
c     *call* macro
      return
 203  continue
      i=pstk(pt)
      rhs=ids(1,pt)
      pt=pt-1
      goto 202
 204  continue
c     next variable to display
      i=i+1
      top=top-1
      if(i.le.rhs) goto 201

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
      call intsgetenv("getenv")
      goto 999

c     read4b      
 220  call intread4b
      goto 999

c     write4b
 230  call intwrite4b
      goto 999
c     --------------
c     erreur lecture
c     --------------
c     
 996  if(.not.opened) call clunit(-lunit,buf,mode)
      return
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

      subroutine v2unit(k,mode,lunit,opened,ierr)
c     given variable #k (scalar or string) and mode 
c     v2unit return a  logical unit attached to corresponding file

      INCLUDE '../stack.h'
c
      logical opened
      integer mode(2)
      integer iadr,sadr
c     
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
c
      ierr=0
      il=iadr(lstk(k))
      if (istk(il).eq.1) then
         lunit = int(stk(sadr(il+4)))
         if (istk(il+1)*istk(il+2).ne.1.or.istk(il+3).ne.0.or.
     $        lunit .lt. 0) then
            err=1
            ierr=1
            call error(36)
            return
         endif
         opened=.true.
      elseif(istk(il).eq.10) then
         if(istk(il+1)*istk(il+2).ne.1) then
            err=1
            ierr=1
            call error(36)
            return
         endif


         kk = abs(mode(1))
         ifor = kk / 100
         kk    = kk - 100 *ifor
         iacc = kk / 10
         if(mode(2).eq.0.and.iacc.eq.1) then
            ierr=1
            call error(242)
            return
         endif

         mn=istk(il+5)-1
         call cvstr(mn,istk(il+5+istk(il+1)*istk(il+2)),buf,1)
         lunit = 0
         call clunit(lunit,buf(1:mn),mode)
         if(err.gt.0) then
            ierr=1
            buf(mn+1:)=' '
            call error(err)
            return
         endif
         opened=.false.
      else
         err=1
         ierr=1
         call error(36)
         return
      endif
      end

      subroutine intsgetenv(fname)
c     =============================
c     getenv('varname' [,'rep'])
       character*(*) fname
       logical checkrhs,checklhs,getsmat,checkval,cresmat2,bufstore
       include '../stack.h'
       rhs = max(0,rhs)
       lbuf = 1
       if(.not.checkrhs(fname,1,2)) return
       if(.not.checklhs(fname,1,1)) return
       if(.not.getsmat(fname,top,top-rhs+1,m1,n1,1,1,lr1,nlr1)) return
       if(.not.checkval(fname,m1*n1,1)) return
       if(.not.bufstore(fname,lbuf,lbufi1,lbuff1,lr1,nlr1)) return
       if(rhs.eq.2) then
          if(.not.getsmat(fname,top,top-rhs+2,m2,n2,1,1,lr2,nlr2)) 
     $         return
          top=top-1
       endif
       nc =bsiz
       call getenvc(ierr,buf(lbufi1:lbuff1),buf,nc,0)
       if(ierr.ne.0) then 
          if (rhs.eq.1) then
             buf='Undefined environment variable'
             call error(999)
          else
             call copyobj(fname,top+1,top)             
          endif
       else
          if(.not.cresmat2(fname,top,nc,ilrs)) return
          call cvstr(nc,istk(ilrs),buf,0)
       endif
       return
       end
c

