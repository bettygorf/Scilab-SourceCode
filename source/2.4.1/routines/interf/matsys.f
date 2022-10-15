      subroutine matsys
c     ====================================================================
c     
c     evaluate system functions
c     
c     ====================================================================
c
c     Copyright INRIA
      include '../stack.h'
      parameter (nz1=nsiz-1,nz2=nsiz-2)
c     
      common /mprot/ macprt
c
      
      integer eol,comma,p,iadr,sadr,r
      integer id(nsiz),fe,fv,semi
      integer double,reel,ent,sort,errn,orts,rtso,tsor,out
      integer uto,tou
      integer top2,tops,pt0,count,fptr,bbots,cmode
      integer local
      double precision x
      logical flag,eqid
      integer offset
c     
      character*(nlgh)    name
c
      common /mtlbc/ mmode
c
      integer resume(nsiz),sel(nsiz)
      data resume/505155099,673713686,nz2*673720360/
      data sel/236260892,673717516,nz2*673720360/
      data eol/99/,semi/43/
      data comma/52/

      data fe/14/,fv/31/
      data double/13/,reel/27/,ent/18/,sort/28/
      data orts/24/,rtso/27/,tsor/29/,out/24/,uto/30/,tou/29/
      data local/21/
c    
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
c     
c     fonction/fin
c     debu who        line argn comp   fort  mode type error
c     1    2    3    4    5    6      7     8    9    10
c     resu form  link   exists errcatch errclear iserror predef
c     11   12     XXX    14      15       16       17      18
c     newfun clearfun  funptr  macr2lst setbpt delbpt dispbpt
c     19      20       21       22       23     24      25
c     funcprot whereis where   timer havewindow memory stacksize
c     26         27    28      29       30       31     32
c     mtlb_mode  link     ulink  c_link addinter  fhelp  fapropos
c     33         34        35     36    37       38     39
c     fclear    what    sciargs  chdir getcwd ieee typename
c     40         41       42     43     44     45    46

      if (ddt .eq. 4) then
         write(buf(1:4),'(i4)') fin
         call basout(io,wte,' matsys '//buf(1:4))
      endif
c     
      if(rstk(pt).eq.901) goto 71

      if(rhs.gt.0) il=iadr(lstk(top))
      goto (10 ,20 ,998 ,55,60 ,70 ,80 ,120,130,140,
     +      150,160,190,180,200,210,220,230,240,250,
     +      250,300,320,320,370,380,390,400,410,420,
     +      450,500,510,600,610,620,630,640,650,660,
     +      670,680,681,682,683,684),fin
c     
c     debug
 10   if(rhs.le.0) then
         call error(39)
         return
      endif
      l=sadr(il+4)
      ddt = int(stk(l))
      write(buf(1:4),'(i4)') ddt
      call basout(io,wte,' debug '//buf(1:4))
      istk(il)=0
      go to 999
c  
c     who
c
 20   continue
      if(rhs.gt.1) then
         call error(39)
         return
      endif
      if(rhs.le.0) then
         if(lhs.ne.1) then
            call error(41)
            return
         endif
         call msgs(38,0)
         call prntid(idstk(1,bot),isiz-bot+1,wte)
         l = lstk(isiz) - lstk(bot) + 1
         write (buf,'(4i10)') l, lstk(isiz)-lstk(1), isiz-bot, isiz-1
         call msgs(39,0)
c     
         top=top+1
         il = iadr(lstk(top))
         istk(il) = 0
         lstk(top+1) = lstk(top) + 1
         return
      endif
c
      if(lhs.gt.2) then
         call error(41)
         return
      endif
      n=isiz-bot
      il=iadr(lstk(top))
      lw=sadr(il+5+n+n*nlgh)
      err=lw-lstk(bot)
      if(err.gt.0) then
         call error(17)
         return
      endif
      ip=il+4
      l=ip+n+1
      istk(il)=10
      istk(il+1)=n
      istk(il+2)=1
      istk(il+3)=0
      istk(ip)=1
      do 21 i=0,n-1
         call namstr(idstk(1,bot+i),istk(l),nl,1)
         istk(ip+1+i)=istk(ip+i)+nl
         l=l+nl
 21   continue
      lstk(top+1)=sadr(l)
      if(lhs.eq.1) goto 999
      top=top+1
      il=iadr(lstk(top))
      l=sadr(il+4)
      err=l+n-lstk(bot)
      if(err.gt.0) then
         call error(17)
         return
      endif
      istk(il)=1
      istk(il+1)=n
      istk(il+2)=1
      istk(il+3)=0
      do 22 i=0,n-1
         stk(l+i)=dble(lstk(bot+i+1)-lstk(bot+i))
 22   continue
      lstk(top+1)=l+n
      goto 999
c     
c     lines
 55   if(rhs.le.0) goto 57
      if(rhs.gt.2) then
         call error(39)
         return
      endif
      if(rhs.eq.1) goto 56
      if(istk(il).ne.1) then
         err=rhs
         call error(53)
         return
      endif
      l=sadr(il+4)
      if(stk(l).lt.10) then
         err=rhs
         call error(36)
         return
      endif
      lct(5)=int(stk(l))
      top=top-1
 56   il=iadr(lstk(top))
      if(istk(il).ne.1) then
         err=1
         call error(53)
         return
      endif
      l=sadr(il+4)
      lct(2) = max(0,int(stk(l)))
      istk(il)=0
      go to 999
c     retour des valeurs
 57   top=top+1
      if(lhs.ne.1) then
         call error(41)
         return
      endif
      il=iadr(lstk(top))
      istk(il)=1
      istk(il+1)=1
      istk(il+2)=2
      istk(il+3)=0
      l=sadr(il+4)
      stk(l)=lct(5)
      stk(l+1)=lct(2)
      lstk(top+1)=l+2
      goto 999
c     
c     argn
 60   if(rhs.eq.1)  top=top-1
      if (rhs .gt. 1) then
         call error(39)
         return
      endif
      if(macr.eq.0) goto 999
      if(top+lhs+1.ge.bot) then
         call error(18)
         return
      endif
      top=top+1
      il=iadr(lstk(top))
      istk(il)=1
      istk(il+1)=1
      istk(il+2)=1
      istk(il+3)=0
      l=sadr(il+4)
c     
      p=pt+1
 61   p=p-1
      if(rstk(p).ne.501.and.rstk(p).ne.502) goto 61
c     
      stk(l)=dble(ids(2,p))
      lstk(top+1)=l+1
      if(lhs.eq.1) goto 999
      top=top+1
      il=iadr(lstk(top))
      istk(il)=1
      istk(il+1)=1
      istk(il+2)=1
      istk(il+3)=0
      l=sadr(il+4)
      stk(l)=dble(max(ids(1,p),0))
      lstk(top+1)=l+1
      goto 999
c     
c     compilation
 70   if(rhs.ne.1.and.rhs.ne.2) then
         call error(39)
         return
      endif
      if(rhs.eq.2) then
         il=iadr(lstk(top))
         if(istk(il).ne.1) then
            err=2
            call error(53)
            return
         endif
         if(istk(il+1)*istk(il+2).ne.1) then
            err=2
            call error(42)
            return
         endif
         cmode=stk(sadr(il+4))
         if(cmode.ne.0.and.cmode.ne.1) then
            err=2
            call error(42)
            return
         endif
         top=top-1
         rhs=1
      else
         cmode=0
      endif
      il=iadr(lstk(top))
      l=il+2
      if(istk(il).eq.13) then
c     function is already compiled
         call msgs(80,0)
         goto 72
      endif
      if(istk(il).ne.11) then
         err=1
         call error(44)
         return
      endif
      l=il+1
      mlhs=istk(l)
      l=l+nsiz*mlhs+1
      mrhs=istk(l)
      l = l + nsiz*mrhs + 2
      pt=pt+1
      ids(1,pt)=l
      pstk(pt)=fin
      fin=lstk(top)
cx    if(mrhs.eq.0) then
cx    top=top+1
cx    lstk(top+1)=lstk(top)
cx    endif
      comp(1)=iadr(lstk(top+1))
      comp(2)=0
      comp(3)=cmode
      rstk(pt)=901
      icall=5
c     *call* parse  macro
      return
 71   l=ids(1,pt)
      pt=pt-1
      if(err1.ne.0) then
         comp(3)=0
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
      comp(3)=0
      call icopy(n,istk(il1),1,istk(l),1)
      istk(l-1)=n
      lstk(top+1)=sadr(l+n)
      istk(il)=13
 72   rhs=0
      call stackp(idstk(1,top),1)
      if(err.gt.0) goto 999
      top=top+1
      il=iadr(lstk(top))
      istk(il)=0
      lhs=0
c     
      goto 999
c     
c     fort
c     ----
 80   call intfort('fort')
      goto 999
c     
c     mode
 120  if(rhs.ne.1) then
         call error(39)
         return
      endif
      il=iadr(lstk(top))
      if(istk(il).ne.1) then
         err=1
         call error(53)
         return
      endif
      lct(4)=int(stk(sadr(il+4)))
      if(lct(4).eq.7.or.lct(4).eq.4) call msgs(26,0)
      istk(il)=0
      goto 999
c     
c     type
 130  if (rhs .ne. 1) then
         call error(39)
         return
      endif
      if (lhs .ne. 1) then
         call error(41)
         return
      endif
      il=iadr(lstk(top))
      k=istk(il)
      istk(il)=1
      istk(il+1)=1
      istk(il+2)=1
      istk(il+3)=0
      l=sadr(il+4)
      stk(l)=dble(k)
      lstk(top+1)=l+1
      goto 999
c     
c     error
 140  continue
      if(rhs.gt.2) then
         call error(39)
         return
      endif
      if (lhs .ne. 1) then
         call error(41)
         return
      endif
      il=iadr(lstk(top+1-rhs))
      if(istk(il).ne.1) goto 141
c     error(errn [,numero_d'argument])
      if(rhs.eq.2) then
         il=iadr(lstk(top))
         if(istk(il).ne.1) then
            err=2
            call error(53)
            return
         endif
         nb=int(stk(sadr(il+4)))
         top=top-1
         il=iadr(lstk(top))
      else
         nb=0
      endif
      errn=int(stk(sadr(il+4)))
      err=nb
      call error(errn)
      return
c     
c     error(str [,errn])
 141  if(rhs.eq.2) then
         il=iadr(lstk(top))
         if(istk(il).ne.1) then
            err=2
            call error(53)
            return
         endif
         errn=int(stk(sadr(il+4)))
         if(errn.ge.100000) then
            err=2
            call error(116)
            return
         endif
         top=top-1
         il=iadr(lstk(top))
      else
         errn=10000
      endif
      if(istk(il).ne.10) then
         err=1
         call error(55)
         return
      endif
      n=istk(il+5)-1
      il=il+istk(il+1)*istk(il+2)+5
      buf=' '
      call cvstr(n,istk(il),buf,1)
      call error(errn)
      return
c     
c     resume/return
c     
 150  if(rhs.ne.lhs) then
         call error(41)
         return
      endif
c
      count=0
      pt0=pt+1
 151  pt0=pt0-1
      if(pt0.le.0) goto 156
       if(rstk(pt0).eq.802.or.rstk(pt0).eq.612 .or.
     &     (rstk(pt0).eq.805.and.eqid(ids(1,pt0),sel)).or.
     &     (rstk(pt0).eq.616.and.pstk(pt0).eq.10)) count=count+1
      if(int(rstk(pt0)/100).ne.5) goto 151
c
 152  if(rstk(pt0).eq.501) then
c     resume in a compiled macro
         lc=pstk(pt)
         ids(1,pt0+1)=lc
         pstk(pt0+2)=count
      elseif(rstk(pt0).eq.502) then
c     resume in an uncompiled macro or an exec or an execstr
         if(rstk(pt0-1).eq.903) then
c     .  in an execstr, check execstr calling context

            pt0=pt0-2
 153        pt0=pt0-1
            if(pt0.le.0) goto 156
            if(rstk(pt0).eq.802.or.rstk(pt0).eq.612 .or.
     &           (rstk(pt0).eq.805.and.eqid(ids(1,pt0),sel)).or.
     &           (rstk(pt0).eq.616.and.pstk(pt0).eq.10)) count=count+1
            if(rstk(pt0).ne.501.and.rstk(pt0).ne.502) goto 153
            if(paus.ne.0.and.rstk(pt0).eq.201) then
c     .        ???
               r=rstk(pt0-4)
               if (r.eq.701.or.r.eq.604) goto 156
            endif
c    .      resume in an execstr, simulate a resume in the calling macro
c    .      see macro.f code for details 
            k = lpt(1) - (13+nsiz)
            lpt(1)=lin(k+1)
            macr=macr-1

c     .     get location of lhs var names
            lvar=pt-3
            rstk(pt0)=502
            pstk(pt0+1)=lvar
            pstk(pt0+2)=count+1
         else
c     .     resume in an uncompiled macro
            if(rstk(pt-1).ne.201
     &           .or.rstk(pt-2).ne.101
     &           .or.rstk(pt-3).ne.703
     &           .or.(sym.ne.semi.and.sym.ne.comma.and.sym.ne.eol)) 
     &           goto 156
            pt=pt-3
            pstk(pt0+1)=pt
            pstk(pt0+2)=count
         endif
      elseif(rio.eq.rte) then
c     resume in a pause
         if(rstk(pt-1).ne.201
     &        .or.rstk(pt-2).ne.101
     &        .or.rstk(pt-3).ne.703
     &        .or.(sym.ne.semi.and.sym.ne.comma.and.sym.ne.eol)) 
     &         goto 156
         pt=pt-3
         k=lpt(1)-(13+nsiz)
         bot=lin(k+5)
         mrhs=rhs
         rhs=0
         paus=paus-1
         do 155 i=1,mrhs
            call stackp(ids(1,pt),0)
            pt=pt-1
 155     continue
         paus=paus+1
         lin(k+5)=bot
         top=top-count
      else
         goto 156
      endif
      pt=pt0
      goto 999
 156  continue
      call putid(ids(1,pt),resume)
      call error(72)
      return
c     
c     format
c     
 160  if(rhs.le.0) goto 167
      if(rhs.gt.2) then
         call error(39)
         return
      endif
      il=iadr(lstk(top))
      if(istk(il).ne.1) goto 161
c     nbre de digits
      l=sadr(il+4)
      nd=max(2,int(stk(l)))
      if(lct(6).eq.0) nd=max(nd,8)
      lct(7)=nd
      goto 165
c     type du format
 161  if(istk(il).ne.10) then
         err=1
         call error(55)
         return
      endif
      l=il+5+istk(il+1)*istk(il+2)
      if(abs(istk(l)).ne.fe) goto 162
      lct(6)=0
      lct(7)=max(8,lct(7))
      goto 165
 162  if(abs(istk(l)).ne.fv) then
         err=1
         call error(36)
         return
      endif
      lct(6)=1
      goto 165
 165  if(rhs.eq.1) goto 166
      top=top-1
      rhs=rhs-1
      goto 160
 166  istk(il)=0
      goto 999
c     retour du format
 167  top=top+1
      if(lhs.ne.1) then
         call error(41)
         return
      endif
      il=iadr(lstk(top))
      istk(il)=1
      istk(il+1)=1
      istk(il+2)=2
      istk(il+3)=0
      l=sadr(il+4)
      stk(l)=lct(6)
      stk(l+1)=lct(7)
      lstk(top+1)=l+2
      goto 999
c     
c     exists
 180  continue
      if(rhs.ne.1.and.rhs.ne.2) then
         call error(39)
         return
      endif

      flag=.false.
c
      if(rhs.eq.2) then
         il=iadr(lstk(top))
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
         if(istk(il+6).eq.local) flag=.true.
         top=top-1
      endif

      il=iadr(lstk(top))
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
      n=istk(il+5)-1
      l=il+6
      call namstr(id,istk(l),n,0)

c     look for  variables in the stack
      if(flag) then
c      just in local environnement
         fin=-3
         call stackg(id)
         ilw=iadr(lstk(top))
         top=top-1
         if(istk(ilw).lt.0) then
            fin=1
         else
            fin=0
         endif
      else
c     in all the stack
         fin=-1
         call stackg(id)
         if (fin.le.0) then
c     look for libraries functions
            fin=-3
            kfun=fun
            call funs(id)
            fun=kfun
         endif
      endif
c
      istk(il)=1
      l=sadr(il+4)
      if (fin.gt.0) then
         stk(l)=1.0d0
      else
         stk(l)=0.0d0
      endif
      lstk(top+1)=l+1
      fin=1
      goto 999
c     
c     link dynamique
c     
 190  continue
      return
c
c     errcatch
 200  continue
      if(rhs.gt.3) then
         call error(39)
         return
      endif
      if(rhs.eq.0) then
         errct=0
         errpt=0
         top=top+1
         il=iadr(lstk(top))
         istk(il)=0
         lstk(top+1)=lstk(top)+1
         return
      endif
      num=0
      imode=0
      imess=0
      do 201 i=1,rhs
         il=iadr(lstk(top))
         if(istk(il).eq.1) then
            l=sadr(il+4)
            num=nint(stk(l))
         else if(istk(il).eq.10) then
            if(istk(il+1)*istk(il+2).ne.1) then
               err=rhs-1+i
               call error(36)
               return
            endif
            l=abs(istk(il+6))
            if(l.eq.12) imode=1
            if(l.eq.25) imode=2
            if(l.eq.23) imess=1
            if(l.eq.28) imode=3
         else
            err=rhs-1+i
            call error(44)
            return
         endif
         top=top-1
 201  continue
      errct=(8*imess+imode)*100000+abs(num)
      if(num.lt.0) errct=-errct
      p=pt+1
 202  p=p-1
      if(p.eq.0) goto 203
      if(int(rstk(p)/100).ne.5) goto 202
 203  errpt=pt
      top=top+1
      istk(il)=0
      lstk(top+1)=lstk(top)+1
      goto 999
c     
c     errclear
 210  continue
      if (rhs .gt. 1) then
         call error(39)
         return
      endif
      if (lhs .ne. 1) then
         call error(41)
         return
      endif
      err2=0
      if(rhs.eq.1) top=top-1
      top=top+1
      il=iadr(lstk(top))
      istk(il)=0
      lstk(top+1)=lstk(top)+1
      return
c     
c     iserror
 220  if(rhs.gt.1) then
         call error(39)
         return
      elseif(rhs.eq.1) then
         il=iadr(lstk(top))
         if(istk(il+1)*istk(il+2).ne.1) then
            err=1
            call error(36)
            return
         endif
         if(istk(il+3).ne.0) then
            err=1
            call error(53)
            return
         endif
         l=sadr(il+4)
         num=nint(stk(l))
      else
         num=0
         il=iadr(lstk(top+1))
         istk(il)=1
         istk(il+1)=1
         istk(il+2)=1
         istk(il+3)=0
         l=sadr(il+4)
         top=top+1
         lstk(top+1)=l+1
      endif
      if(num.ge.1) then
         if(err2.eq.num) then
            stk(l)=1.0d+0
         else
            stk(l)=0.0d+0
         endif
      else
         if(err2.ne.0) then
            stk(l)=1.0d+0
         else
            stk(l)=0.0d+0
         endif
      endif
      goto 999
c     
c     predef
c     
 230  continue
      if (rhs .gt. 1) then
         call error(39)
         return
      endif
      if(lhs.ne.1) then
         call error(41)
         return
      endif
      bbots=bbot
      if(rhs.le.0) then
         bbot=bot
         top=top+1
      else
         if(istk(il).ne.1) then
            err=rhs
            call error(53)
            return
         endif
         if(istk(il+1)*istk(il+2).ne.1) then
            err=rhs
            call error(36)
            return
         endif
         if(istk(il+3).ne.0) then
            err=rhs
            call error(52)
            return
         endif
         l=sadr(il+4)
         is=isiz
         bbot=max(bot,isiz-max( nint(stk(l)),(isiz-bot0) ) )
      endif
      il=iadr(lstk(top))
      istk(il)=1
      istk(il+1)=1
      istk(il+2)=2
      istk(il+3)=0
      l=sadr(il+4)
      stk(l)=isiz-bbots
      stk(l+1)=isiz-bbot
      lstk(top+1)=l+3
      goto 999
c     
c     newfun
c     
 240  continue
      if(rhs.ne.2) then
         call error(39)
         return
      endif
      il=iadr(lstk(top))
      if(istk(il).ne.1) then
         err=rhs
         call error(53)
         return
      endif
      if(istk(il+1)*istk(il+2).ne.1) then
         err=rhs
         call error(36)
         return
      endif
      if(istk(il+3).ne.0) then
         err=rhs
         call error(52)
         return
      endif
      fptr=int(stk(sadr(il+4)))
c     
      top=top-1
      il=iadr(lstk(top))
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
      n=istk(il+5)-1
      l=il+6
      call namstr(id,istk(l),n,0)
c     
      call funtab(id,fptr,3)
      if(err.gt.0) return
      il=iadr(lstk(top))
      istk(il)=0
      l=sadr(il+1)
      lstk(top+1)=l+1
      goto 999
c     
c     clearfun funptr
c     
 250  continue
      if(rhs.ne.1) then
         call error(39)
         return
      endif
      il=iadr(lstk(top))
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
      n=istk(il+5)-1
      l=il+6
      call namstr(id,istk(l),n,0)
      if(fin.eq.20) then
c
c     clearfun
c
         call funtab(id,fptr,4)
c     
         istk(il)=0
         l=sadr(il+1)
         lstk(top+1)=l+1
      else
c
c     funptr
c
         call funtab(id,fptr,1)
c     
         istk(il)=1
         istk(il+1)=1
         istk(il+2)=1
         istk(il+3)=0
         l=sadr(il+4)
         stk(l)=dble(fptr)
         lstk(top+1)=l+1
      endif
      goto 999
c
c     macrovar 
c
 300  continue
      if (rhs .ne. 1) then
         call error(39)
         return
      endif
      if (lhs .ne. 1) then
         call error(41)
         return
      endif
      lw=lstk(top+1)
      illist=iadr(lw)
      call tradsl(top,illist,nlist)
      if(err.gt.0) return
      il=iadr(lstk(top))
      call icopy(nlist,istk(illist),1,istk(il),1)
      lstk(top+1)=sadr(il+nlist)
      Goto 999
c
c     setbpt delbpt
c
 320  continue
      if (rhs .lt. 0) then
         call error(39)
         return
      endif
      if(rhs.eq.2) then
         il=iadr(lstk(top))
         if(istk(il).ne.1) then
            err=rhs
            call error(53)
            return
         endif
         if(istk(il+1)*istk(il+2).ne.1) then
            err=rhs
            call error(36)
            return
         endif
         if(istk(il+3).ne.0) then
            err=rhs
            call error(52)
            return
         endif
         lnb=int(stk(sadr(il+4)))
         top=top-1
      endif
      il=iadr(lstk(top))
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
      n=istk(il+5)-1
      l=il+6
      call namstr(id,istk(l),n,0)
      if(fin.eq.24) goto 350
c
      if(rhs.eq.1) lnb=1
      if(nmacs.gt.0) then
         do 323 kmac=1,nmacs
            if(eqid(macnms(1,kmac),id)) goto 325
 323     continue
      endif
      nmacs=nmacs+1
      call putid(macnms(1,nmacs),id)
      lgptrs(nmacs+1)=lgptrs(nmacs)+1
      bptlg(lgptrs(nmacs))=lnb
      goto 330
 325  if(kmac.eq.nmacs) then
         lgptrs(nmacs+1)=lgptrs(nmacs+1)+1
         bptlg(lgptrs(nmacs+1)-1)=lnb
      else
         do 326 kk=nmacs,kmac,-1
            l0=lgptrs(kk)
            call icopy(lgptrs(kk+1)-l0,bptlg(l0),-1,bptlg(l0+1),-1)
            lgptrs(kk+1)=lgptrs(kk+1)+1
 326     continue
         bptlg(lgptrs(kmac+1)-1)=lnb
      endif
 330  continue
      istk(il)=0
      lstk(top+1)=sadr(il+2)
      goto 999
c
c delbpt 

 350  continue
      if(nmacs.eq.0) goto 360
c
      do 353 kmac=1,nmacs
         if(eqid(macnms(1,kmac),id)) goto 355
 353  continue
      goto 360
      
 355  continue
      if(rhs.eq.1) then
c     on supprime tous les points d'arret de la macro
         if(kmac.lt.nmacs) then
            l0=lgptrs(kmac+1)
            call icopy(lgptrs(nmacs+1)-l0 ,bptlg(l0),1,
     $           bptlg(lgptrs(kmac)),1)
            do 356 kk=kmac,nmacs-1
               call icopy(nsiz,macnms(1,kk+1),1,macnms(1,kk),1)
               lgptrs(kk)=lgptrs(kk+1)
 356        continue
            lgptrs(nmacs)=lgptrs(nmacs+1)
         endif
         nmacs=nmacs-1
         goto 360
      endif

      kk1=lgptrs(kmac)-1
      do 357 kk=lgptrs(kmac),lgptrs(kmac+1)-1
         if(bptlg(kk).ne.lnb) then
            kk1=kk1+1
            bptlg(kk1)=bptlg(kk)
         endif
 357  continue
      if(kk.eq.kk1) goto 360

      if(kmac.lt.nmacs) then
         l0=lgptrs(kmac+1)
         do 358 kk=kmac+1,nmacs
            call icopy(lgptrs(kk+1)-l0,bptlg(l0),1,bptlg(l0-1),1)
            l0=lgptrs(kk+1)
            lgptrs(kk+1)=lgptrs(kk+1)-1
 358        continue
      endif
      lgptrs(kmac+1)=lgptrs(kmac+1)-1
      if(lgptrs(kmac+1).eq.lgptrs(kmac)) then
         if(kmac.lt.nmacs) then
            do 359 kk=kmac,nmacs-1
               call icopy(nsiz,macnms(1,kk+1),1,macnms(1,kk),1)
               lgptrs(kk)=lgptrs(kk+1)
 359        continue
         endif
         lgptrs(nmacs)=lgptrs(nmacs+1)
         nmacs=nmacs-1
      endif

 360  continue
      istk(il)=0
      lstk(top+1)=sadr(il+2)
      goto 999
c
c     dispbpt
c
 370  continue
      if(rhs.gt.0) then
         call error(39)
         return
      endif

      if(nmacs.gt.0) then
         do 375 kk=1,nmacs
            call cvname(macnms(1,kk),buf(1:nlgh),1)
            call msgs(27,0)
            do 373 kl=lgptrs(kk),lgptrs(kk+1)-1
               write(buf(1:10),'(5x,i5)') bptlg(kl)
               call basout(io,wte,buf(1:10))
 373        continue
 375     continue
      endif
      top=top+1
      il=iadr(lstk(top))
      istk(il)=0
      lstk(top+1)=sadr(il+3)
      goto 999
c
c     funcprot
 380  continue
      if (rhs .le. 0) then
         top=top+1
         il=iadr(lstk(top))
         istk(il)=1
         istk(il+1)=1
         istk(il+2)=1
         istk(il+3)=0
         l=sadr(il+4)
         stk(l)=macprt
         lstk(top+1)=l+1
         goto 999
      endif
      if (rhs .ne. 1) then
         call error(39)
         return
      endif
      if (lhs .ne. 1) then
         call error(41)
         return
      endif
      if(istk(il).ne.1) then
         err=1
         call error(55)
         return
      endif
      if(istk(il+1)*istk(il+2).ne.1) then
         err=1
         call error(60)
         return
      endif
      l=sadr(il+4)
      m=int(stk(l))
      if(m.lt.0.or.m.gt.2) then
         err=1
         call error(116)
         return
      endif
      macprt=m
      istk(il)=0
      lstk(top+1)=lstk(top+1)
      goto 999
c
c     whereis
 390  continue
      if(rhs.ne.1.or.lhs.ne.1) then
         call error(39)
         return
      endif
      il=iadr(lstk(top))
      if(istk(il).eq.11.or.istk(il).eq.13) then
         call putid(id,idstk(1,top))
      elseif(istk(il).eq.10) then
         if(istk(il+1)*istk(il+2).ne.1) then
            err=1
            call error(89)
            return
         endif
         n=istk(il+5)-1
         l=il+6
         call namstr(id,istk(l),n,0)
      else
         err=1
         call error(44)
         return
      endif
      fin=-3
      call funs(id)
      if(err.gt.0) return
      if(fun.eq.0) then
         istk(il)=1
         istk(il+1)=0
         istk(il+2)=0
         istk(il+3)=0
         lstk(top+1)=sadr(il+5)+1
      else
         istk(il)=10
         istk(il+1)=1
         istk(il+2)=1
         istk(il+3)=0
         istk(il+4)=1
         l=il+6
         call putid(id,idstk(1,fun))
         fun=0
         call namstr(id,istk(l),n,1)
         istk(il+5)=n+1
         lstk(top+1)=sadr(l+n)
      endif
      return
c
c     where
 400  continue
      call where
      return
c
 410  continue
c     timer
      if (rhs .gt. 0) then
         call error(39)
         return
      endif
      if (lhs .ne. 1) then
         call error(41)
         return
      endif
      top=top+1
      il=iadr(lstk(top))
      err=lstk(top+5)-lstk(bot)
      if(err.gt.0) then
         call error(17)
         return
      endif
      istk(il)=1
      istk(il+1)=1
      istk(il+2)=1
      istk(il+3)=0
      l=sadr(il+4)
      call timer(stk(l))
      lstk(top+1)=l+1
      return
c
 420  continue
c     notify XXXX unused 
      if(rhs.ne.1) then
         call error(39)
         return
      endif
      if(lhs.gt.1) then
         call error(41)
         return
      endif
      il=iadr(lstk(top))
      l=sadr(il+4)
      ntfy=stk(l)
      istk(il)=0
      return
c
 450  continue
c     havewindow
      call xscion(iflag)
      top=top+1
      il=iadr(lstk(top))
      istk(il)=4
      istk(il+1)=1
      istk(il+2)=1
      istk(il+3)=iflag
      lstk(top+1)=sadr(il+4)
      return
c
 500  continue
c     stacksize
      if (rhs .gt. 1) then
         call error(39)
         return
      endif
      if (lhs .ne. 1) then
         call error(41)
         return
      endif
      if (rhs.ne.1) then
         top=top+1
         il=iadr(lstk(top))
         istk(il)=1
         istk(il+1)=1
         istk(il+2)=2
         istk(il+3)=0
         l=sadr(il+4)
         stk(l)=lstk(isiz)-lstk(1)
         stk(l+1)=lstk(isiz)-lstk(bot)+1
         lstk(top+1)=l+2
         return
      endif
      if(istk(il).ne.1) then
         err=1
         call error(53)
         return
      endif
      if(istk(il+1)*istk(il+2).ne.1) then
         err=1
         call error(60)
         return
      endif
      top=top-1
      if (top.ne.0) then
         buf='memory cannot be used in this context'
         call error(1502)
         return
      endif
      mem=stk(sadr(il+4))
      memold=lstk(isiz)-lstk(1)
      if (mem.eq.memold) goto 502
      l=lstk(isiz)-lstk(bot)
      if (mem.lt.l) then
         buf='Required memory too small for defined data'
         call error(1503)
         return
      endif
      call scimem(mem+1,offset)
      if(offset.eq.0) then
         call error(112)
         return
      endif
      offset=offset+1
      call dcopy(l,stk(lstk(bot)),1,stk(offset+mem-l),1)
      kd=offset-lstk(1)+mem-memold
      do 501 k=bot,isiz
         lstk(k)=lstk(k)+kd
 501  continue 
      call freemem()
      lstk(1)=offset
      leps=sadr(iadr(lstk(isiz-5)) +4)

 502  continue
      top=top+1
      il=iadr(lstk(top))
      istk(il)=0
      lstk(top+1)=lstk(top)+1
      goto 999
c
c     mtlb_mode
 510  continue
      if(rhs.gt.1) then
         call error(39)
         return
      endif
      if(rhs.le.0) then
         top=top+1
         il=iadr(lstk(top))
         istk(il)=4
         istk(il+1)=1
         istk(il+2)=1
         istk(il+3)=mmode
         lstk(top+1)=sadr(il+4)
         goto 999
      else
         if(istk(il).ne.4) then
            err=1
            call error(208)
            return
         endif
         if(istk(il+1)*istk(il+2).ne.1) then
            err=1
            call error(36)
            return
         endif
         mmode=istk(il+3)
         istk(il)=0
         lstk(top+1)=sadr(il+1)
      endif
      goto 999
 600  call scilink("link")
      goto 999
 610  call sciulink("unlink")
      goto 999
 620  call sciislink("c_link")
      goto 999
 630  call scidint("addinter")
      goto 999
 640  call scifhelp("fhelp")
      goto 999
 650  call scifapr("fapropos")
      goto 999
 660  call intclear("clear")
      goto 999
 670  call intwhat("what")
      goto 999
 680  call intsciargs("sciargs")
      goto 999
 681  call intschdir("chdir")
      goto 999
 682  call intsgetdir("getcwd")
      goto 999
 683  call intsieee("ieee")
      goto 999
 684  call inttypnam("typnam")
      goto 999

 998  continue
c     fake calls : only to force the 
c     linker to load the following functions
c     in scilab executable 
      call rcopy(m*n,ar,1,ar,1)
      call ccopy(1,'tutu',1,buf,1)
      call matz(ar,ai,lda,m,n,name,job)
      call readmat(' ',m,n,ar)
      i=creadmat(' ',m,n,w)
      i=creadchain(' ',m,w)
      call matptr(' ',m,n,n)
      i=cmatptr(' ',m,n,n)
      call matc(' ',lda,m,n,buf,job)
      call readchain(' ',m,buf)
      call matzs(ar,ai,lda,m,n,' ',job)
      call rea2db(n,dx,incx,dy,incy)
      call freeptr(i)
      call csparsef(ar,it,m,n,nel,mnel,icol,ar,ar)
 999  return
      end

      subroutine scilink(fname) 
C     ================================================================
C    link function  
C     ================================================================
      character*(*) fname
cc    implicit undefined (a-z)
      include '../stack.h'
      integer topk,iadr
      integer m3,n3,lr3,nlr3,m2,n2,il2,ild2,m1,n1,il1,ild1
      integer ilib,gettype,iv ,l1
      logical getwsmat,checkrhs,getsmat,getscalar,cremat
      character*(2) strf
      iadr(l)=l+l-1
      strf='f'//char(0)
      if (.not.checkrhs(fname,1,3)) return
      topk=top
C     third argument if present is a char 
      if (rhs.ge.3) then
         if(.not.getsmat(fname,topk,top,m3,n3,1,1,lr3,nlr3))return
         if (nlr3.ne.1) then
            buf=fname //' : flag has a wrong size, 1 expected'
            call error(999)
            return
         endif
         call cvstr(nlr3,istk(lr3),strf,1)
         top=top-1
      endif
C     second argument 
      if (rhs.ge.2) then
         if (.not.getwsmat(fname,topk,top,m2,n2,il2,ild2)) return
         top=top-1
      endif
C     first argument 
      itype=gettype(top) 
      if ( itype.eq.1) then 
         if (.not.getscalar(fname,topk,top,l1)) return
         if (rhs.eq.1) then 
            buf = fname // ': must have two arguments when '
     $           // 'first arg is an integer'
            call error(999)
            return
         endif
         ilib=int(stk(l1))
         iflag = 1
         call iscilink(iv,iv,iv,
     $        istk(il2),istk(ild2),m2*n2,strf,ilib,iflag,rhs)
      else 
         if (.not.getwsmat(fname,topk,top,m1,n1,il1,ild1)) return
         iflag = 0
         if ( rhs.eq.1) then 
            call iscilink(istk(il1),istk(ild1),m1*n1,
     $           iv,iv,iv,strf,ilib,iflag,rhs)
         else
            call iscilink(istk(il1),istk(ild1),m1*n1,
     $           istk(il2),istk(ild2),m2*n2,strf,ilib,iflag,rhs)
         endif
         if ( ilib.lt.0 ) then 
            if (ilib.eq.-1) then
               call error(236)
            elseif (ilib.eq.-2) then
               call error(239)
            elseif (ilib.eq.-3) then
               call error(238)
            elseif (ilib.eq.-4) then
               call error(237)
            elseif (ilib.eq.-5) then
               call error(235)
            elseif (ilib.eq.-6) then
               call error(235)
            else
               buf= fname // ': Error'
               call error(999)
            endif
            return
         endif
         if (.not.cremat(fname,top,0,1,1,lr,lc)) return
         stk(lr) = ilib
         return
      endif
      return
      end

      subroutine scidint(fname) 
C     ================================================================
C     addinter 
C     ================================================================
      character*(*) fname
cc    implicit undefined (a-z)
      include '../stack.h'
      integer topk,iadr
c      integer m3,n3,lr3,nlr3,m2,n2,il2,ild2,m1,n1,il1,ild1
c      integer ilib,gettype,iv ,l1
      logical getwsmat,checkrhs,getsmat
      character*(25) strf
      iadr(l)=l+l-1
      if (.not.checkrhs(fname,3,3)) return
      topk=top
      if (.not.getwsmat(fname,topk,top,m3,n3,il3,ild3)) return
      top=top-1
      if(.not.getsmat(fname,topk,top,m2,n2,1,1,lr2,nlr2))return
      if ( m2*n2.ne.1) then
         buf=fname //' : ename has a wrong size, 1x1 expected'
         call error(999)
         return
      endif
      if ( nlr2.gt.24) then 
         buf=fname //' : ename max size 24'
         call error(999)
         return
      endif
      call cvstr(nlr2,istk(lr2),strf,1)
      strf(nlr2+1:nlr2+1)=char(0)
      top=top-1
C     first argument 
      if (.not.getwsmat(fname,topk,top,m1,n1,il1,ild1)) return
      call addinter(istk(il1),istk(ild1),m1*n1,strf,
     $     istk(il3),istk(ild3),m3*n3,ierr)
      if(ierr.ne.0) then
         if (ierr.eq.-1) then
            call error(236)
         elseif (ierr.eq.-2) then
            call error(239)
         elseif (ierr.eq.-3) then
            call error(238)
         elseif (ierr.eq.-4) then
            call error(237)
         elseif (ierr.eq.-5) then
            call error(231)
         elseif (ierr.eq.-6) then
            call error(234)
         elseif (ierr.eq.1) then
            call error(233)
         elseif (ierr.eq.2) then
            call error(232)
         else
            buf = fname // ': Error '
            call error(999)
         endif
         return
      endif
      call objvide(fname,top)
      return
      end

      subroutine sciulink(fname) 
C     ================================================================
C     unlink function  (unlik a whole shared lib ) 
C     ================================================================
      character*(*) fname
cc    implicit undefined (a-z)
      include '../stack.h'
      integer ilib,l1,topk
      logical getscalar,checkrhs
      character*(2) strf
      topk=top
      if (.not.checkrhs(fname,1,1)) return
      if (.not.getscalar(fname,topk,top,l1)) return
      ilib=int(stk(l1))
      call isciulink(ilib)
      call objvide(fname,top)
      return
      end

      subroutine sciislink(fname) 
C     ================================================================
C     [%t|%false,number]=c_link(name [,ilib]) 
C     checks if name is linked and optionaly linked form lib number ilib
C     ================================================================
      character*(*) fname
cc    implicit undefined (a-z)
      include '../stack.h'
      integer topk,iadr
c      integer m3,n3,lr3,nlr3,m2,n2,il2,ild2,m1,n1,il1,ild1
      integer ilib,iv ,l1
      logical checkrhs,crebmat,getscalar,getsmat,cremat
      iadr(l)=l+l-1
      if (.not.checkrhs(fname,1,2)) return
      if (.not.checkrhs(fname,1,2)) return
      topk=top
      if (rhs.eq.2) then 
         if(.not.getscalar(fname,topk,top,lr))return
         ilib = int(stk(lr))
         top=top-1
      else
         ilib=-1
      endif
      if(.not.getsmat(fname,topk,top,m3,n3,1,1,lr3,nlr3))return
      call cvstr(nlr3,istk(lr3),buf,1)
      buf(nlr3+1:nlr3+1)=char(0)
      call iislink(buf,ilib,irep)
      if (.not.crebmat(fname,top,1,1,lr)) return
      if (ilib.eq.-1)  then 
         istk(lr) = 0
      else
         istk(lr) = 1
      endif
      if ( lhs.eq.2) then 
         top=top+1
         if (.not.cremat(fname,top,0,1,1,lr,lc)) return
         stk(lr)= ilib
      endif
      return
      end


      subroutine scifhelp(fname)
c     =============================
c     fhelp(name)
      character*(*) fname
      character*80 h
      logical checkrhs,checklhs,getsmat,checkval,cresmat2,bufstore
      include '../stack.h'
      integer a, blank,percent
      data a/10/,blank/40/,percen/56/
c
      rhs = max(0,rhs)
      lbuf = 1
      if(.not.checkrhs(fname,0,1)) return
      if(rhs.eq.0) then
         h='help'
         h(5:5)= char(0)
         call iscihelp(buf,h,ierr)
      else
         if(.not.getsmat(fname,top,top-rhs+1,m1,n1,1,1,lr1,nlr1)) return
         if(.not.checkval(fname,m1*n1,1)) return
         if(nlr1.gt.0) then
            ic=abs(istk(lr1))
            if(.not.((ic.ge.a.and.ic.lt.blank) .or. ic.eq.percen)) then
               h='symbols'
               h(8:8)= char(0)
               call iscihelp(buf,h,ierr)
            else
               if(.not.bufstore(fname,lbuf,lbufi1,lbuff1,lr1,nlr1))
     $              return
               call iscihelp(buf,buf(lbufi1:lbuff1),ierr)
            endif
         endif
      endif
      call objvide(fname,top)
      return
      end
c
      subroutine scifapr(fname)
c     =============================
c     fapropos(name)
      character*(*) fname
      logical checkrhs,checklhs,getsmat,checkval,cresmat2,bufstore
      include '../stack.h'
      rhs = max(0,rhs)
      lbuf = 1
      if(.not.checkrhs(fname,1,1)) return
      if(.not.getsmat(fname,top,top-rhs+1,m1,n1,1,1,lr1,nlr1)) return
      if(.not.checkval(fname,m1*n1,1)) return
c     conversion to lower case
      do 10 i=0,nlr1-1
         istk(lr1+i)=abs(istk(lr1+i))
 10   continue
      if(.not.bufstore(fname,lbuf,lbufi1,lbuff1,lr1,nlr1)) return
      call isciap(buf,buf(lbufi1:lbuff1),ierr)
      call objvide(fname,top)
      return
      end

      subroutine intfort(fname)
c     =====================================
c     interface for the scilab fort command 
c     =====================================
      include '../stack.h'
cc      implicit undefined (a-z)
      character*(*) fname
      character*1   type
      logical checkrhs,checklhs,getsmat,checkval,cresmat2,bufstore
      logical flag,getscalar ,getmat,getrhsvar,cremat,lcres
      logical createvar
      integer gettype,sadr,iadr,top2,tops,topl,topk

      parameter (fortname=24)
      character  name*25
      common /inter/ name
      common /ibfu/ ibuf(intersiz*6)
       iadr(l)=l+l-1
      sadr(l)=(l/2)+1
      if (rhs .eq. 0) then
         call error(39)
         return
      endif
      nbvars = 0
      flag=.false.
c     maximum number of variables ( see stack.h) 
c     
      namax=intersiz
      call iset(namax,0,ladr,1)
c     get a scilab string the fort function name 
      top2=top-rhs+1
      if(.not.getsmat(fname,top,top2,m1,n1,1,1,lrc,nc))return
      name=' '
      if ( nc.gt.fortname ) then 
         buf = fname // ' first argument must be of length < 24'
         call error(999)
         return
      endif
      call cvstr(nc,istk(lrc),name,1)
      name(nc+1:nc+1)=char(0)
C     Check the name in the <<fort>> table 
      call setinterf(name,irep)
      if ( irep.eq.1) then 
         buf = name
         call error(50)
         return
      endif
C     test the argument list : search for 'out' or 'sort'
c     ----------------------------------------------------
      do 81 i=1,rhs-1
         tops=top2+i
         itype = gettype(tops) 
         if ( itype.eq.10 ) then 
            if(.not.getsmat(fname,top,tops,m1,n1,1,1,lr1,nlr1)) return
            if(.not.checkval(fname,m1*n1,1)) return
            lbuf=1
            if(.not.bufstore(fname,lbuf,lbufi1,lbuff1,lr1,nlr1)) return
            if (buf(lbufi1:lbuff1).eq.'sort'.or.
     $           buf(lbufi1:lbuff1).eq.'out') goto 82 
         endif
 81   continue
c     'sort' or 'out' are not in the calling list we use the brief form 
C     we call the routine directly 
C     the routine must deal itself with the stack 
c     ----------------------------------------------------
      call interf1(name(1:nc))
      return
c     Now the long form 
c     -----------------
 82   continue
c     for the long form the call to interf is hardcoded 
c     with a limit of 30 arguments
      namax=min(intersiz,30)
c     ie : number of input arguments 
      ie=(tops-1-top2)/3
c     computing iss : 
c     number of output variables described after the 'out'  string 
c     -----------------
      jjj=tops+1
      iss=0
 86   if ( jjj.gt.top) goto 861
      itype = gettype(jjj)
      if (itype.eq.1) then 
         if(.not.getmat(fname,top,jjj,it1,m,n,lr1,lc1)) return
         if( m*n.eq.2 ) then 
            jjj = jjj+3 
         else
            jjj = jjj+1 
         endif
         iss = iss+1
      else
         err= jjj-top2+1
         call cvname(ids(1,pt+1),fname,0)
         call error(81) 
         return
      endif
      goto 86 
 861  continue
      if( iss.gt.0 .and. lhs.gt.iss) then
         call error(41)
         return
      endif
      if( err.gt.0) return
      ieis=ie+iss
      if(ie.ne.0) then 
c     input arguments 
c     storing information in ibuf for each input variable
c     ibuf(6*(i-1)+ j) 
c       j=1,2,3,4,5,6 ==>[call position,adress of data,type, nrow,ncol
c         number-in-the-caling-stack]
c     -------------------------------------------------------------
         do 87 i=1,ie
            ir1=top2+1+3*(i-1)
            if(.not.getsmat(fname,top,ir1+2,m1,n1,1,1,lr1,nlr1)) return
            if( m1*n1.ne.1.or.nlr1.ne.1) then 
               buf = fname // ': argument must be "c","d","i",or "r"'
               call error(999)
               return
            endif
c           stack-position 
            ibuf(6+6*(i-1)) = ir1-top2+1
            call cvstr(nlr1,istk(lr1),type,1)
            ibuf(3+6*(i-1)) = ichar(type)
            if(.not.getscalar(fname,top,ir1+1,lr1))return
            ibuf(1+6*(i-1)) = int(stk(lr1))
            if(.not.getrhsvar(2+3*(i-1),type,m1,n1,lr1)) return
            ibuf(2+6*(i-1)) = lr1 
            ibuf(4+6*(i-1)) = m1
            ibuf(5+6*(i-1)) = n1
            if (type.eq.'d' ) then 
               ladr(ibuf(1+6*(i-1))) = lr1 
            else if (type.eq.'r') then 
               ladr(ibuf(1+6*(i-1))) = sadr(lr1)
            else if (type.eq.'i') then 
               ladr(ibuf(1+6*(i-1))) = sadr(lr1)
            else if (type.eq.'c') then 
               call cs2st(lr1,lr2)
               ladr(ibuf(1+6*(i-1))) = lr2
            endif

 87      continue
      endif
c     Output variables 
c     -------------------------------------------------------------
c     icre will output variables which need to be created
      icre=0
      jjj=tops+1
      if(iss.eq.0) goto 95
      do 94 i=1,iss
         ilm=iadr(lstk(jjj))
         if(istk(ilm+1)*istk(ilm+2).eq.1) then 
c           output variable is described by position only 
            ipla=int(stk(sadr(ilm+4)))
c           get the data of the associated input var 
            do 91 j=1,ie
               jj=6*(j-1)
               if(ibuf(jj+1).eq.ipla) then 
                  call icopy(6,ibuf(jj+1),1,ibuf(6*(ie+i-1)+1),1)
                  jjj=jjj+1
                  goto 94 
               endif
 91         continue
            buf = fname // ': output variable described by position'
     $          // ' must be an input variable'
            call error(999)
         else
c           explicit dimension of the output var 
            if(.not.getsmat(fname,top,jjj+2,m1,n1,1,1,lr1,nlr1)) return
            if( m1*n1.ne.1.or.nlr1.ne.1) then 
               buf = fname // ': argument must be "c","d","i",or "r"'
               call error(999)
               return
            endif
            call cvstr(nlr1,istk(lr1),type,1)
            if(.not.getscalar(fname,top,jjj+1,lr1))return
            ipla = int(stk(lr1))
            if(.not.getmat(fname,top,jjj,it1,m1,n1,lr1,lc1)) return
            if (m1*n1.ne.2) then 
               buf = fname 
     $              // 'Output argument dimension must be [nr,nc]'
               call error(999)
               return
            endif
            m1 = int(stk(lr1))
            n1 = int(stk(lr1+1))
c           maybe this output variable was also an input variable
c           we must check that dimensions and type are compatible 
            iecor=0
            do 910 j=1,ie
               jj=6*(j-1)
               if(ibuf(jj+1).eq.ipla) then 
                  iecor= j
                  goto 911
               endif
 910        continue
 911        continue 
            if ( iecor.eq.0 ) then 
c           we must create a new entry 
c           for an output variable 
               icre=icre+1
               if (.not.createvar(rhs+icre,type,m1,n1,lr1)) return
               ipos=6*(ie+i-1)
               ibuf(ipos+1) = ipla  
               ibuf(ipos+2) = lr1
               ibuf(ipos+3) = ichar(type)
               ibuf(ipos+4) = m1
               ibuf(ipos+5) = n1 
               ibuf(ipos+6) = rhs + icre 
               narg = ibuf(6*(ie+i-1)+1)
               if(narg.gt.namax) then
                  call error(70)
                  return
               endif            
               if (type.eq.'d' ) then 
                  ladr(ipla) = lr1 
               else if (type.eq.'r') then 
                  ladr(ipla) = sadr(lr1)
               else if (type.eq.'i') then 
                  ladr(ipla) = sadr(lr1)
               else if (type.eq.'c') then 
                  ladr(ipla) = sadr((lr1/4)+1)
               endif
            else
c           we must check input-output consistency 
               ii=6*(iecor-1)
               if (m1*n1.gt.ibuf(ii+4)*ibuf(ii+5)
     $              .or.ichar(type).ne.ibuf(ii+3)) then
                  buf = fname // ': incompatibility between '
     $                 //'input and output variable'
                  call error(999)
                  return
               endif
               ibuf(ii+4)=m1
               ibuf(ii+5)=n1
               call icopy(6,ibuf(ii+1),1,ibuf(6*(ie+i-1)+1),1)
            endif
            jjj=jjj+3
         endif
 94   continue
 95   continue
      call interf(stk(ladr(1)),stk(ladr(2)),
     $     stk(ladr(3)),stk(ladr(4)),stk(ladr(5)),stk(ladr(6)),
     $     stk(ladr(7)),stk(ladr(8)),stk(ladr(9)),stk(ladr(10)),
     $     stk(ladr(11)),stk(ladr(12)),stk(ladr(13)),stk(ladr(14)),
     $     stk(ladr(15)),stk(ladr(16)),stk(ladr(17)),stk(ladr(18)),
     $     stk(ladr(19)),stk(ladr(20)),stk(ladr(21)),stk(ladr(22)),
     $     stk(ladr(23)),stk(ladr(24)),stk(ladr(25)),stk(ladr(26)),
     $     stk(ladr(27)),stk(ladr(28)),stk(ladr(29)),stk(ladr(30)))
      if(iss.le.0) then
         top=top2
         call objvide(fname,top)
      else
c        check if output variabe are in increasing order in the stack 
         lcres=.true.
         ibufprec=0
         do 105 i=1,lhs 
            ir1= 6*(ie+1-1)
            if ( ibuf(ir1+1).lt.ibufprec) then 
               lcres=.false.
               goto 106 
            else
               ibufprec = ibuf(ir1+1)
            endif
 105     continue
 106     continue
         if ( lcres) then 
            top=top2-1
         else
            topk=top2-1
            topl=top+icre
            top=topl
         endif
         ir1= 6*(ie+1-1)
         do 104 i=1,lhs
            top=top+1
            type=char(ibuf(ir1+3)) 
            m = ibuf(ir1+4)
            n = ibuf(ir1+5)
            if (type.eq.'d') then 
               if (.not.cremat(fname,top,0,m,n,lr1,lc1)) return
               call dcopy(m*n,stk(ibuf(ir1+2)),1,stk(lr1),1)
            else if (type.eq.'i') then 
               if (.not.cremat(fname,top,0,m,n,lr1,lc1)) return
               call entier2d(m*n,stk(lr1),istk(ibuf(ir1+2)))
            else if (type.eq.'r') then 
               if (.not.cremat(fname,top,0,m,n,lr1,lc1)) return
               call simple2d(m*n,stk(lr1),sstk(ibuf(ir1+2)))
            else if (type.eq.'c') then 
               if (.not.cresmat2(fname,top,m*n,lr1)) return
               l1=ibuf(ir1+2)
               call cvstr(m*n,istk(lr1),cstk(l1:l1+m*n),0)
            endif
            ir1=ir1+6
 104     continue
         if (.not.lcres) then 
            do 107 i=1,lhs 
               call copyobj(fname,topl+i,topk+i)
 107        continue
            top=topk+lhs
         endif
      endif
      return
      end

      subroutine intsciargs(fname)
c     fapropos(name)
      character*(*) fname
      character*40 arg
      logical checkrhs,checklhs
      integer iadr,sadr
      include '../stack.h'
c
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
c
      rhs = max(0,rhs)
      lbuf = 1

      if(.not.checkrhs(fname,0,0)) return
      if(.not.checklhs(fname,1,1)) return

      nargs = iargc()

      top=top+1
      il=iadr(lstk(top))
      l=il+5+nargs+1
      err=sadr(l)-lstk(bot)
      if(err.gt.0) then
         call error(17)
         return
      endif
      istk(il)=10
      istk(il+1)=nargs+1
      istk(il+2)=1
      istk(il+3)=0
      istk(il+4)=1

      do 20 k=0,nargs
         call fgetarg(k,arg)
         l1=len(arg)+1
 10      l1=l1-1
         if(arg(l1:l1).eq.' ') goto 10
         err=sadr(l+l1)-lstk(bot)
         if(err.gt.0) then
            call error(17)
            return
         endif
         call cvstr(l1,istk(l),arg,0)
         istk(il+5+k)=istk(il+4+k)+l1
         l=l+l1
 20   continue
      lstk(top+1)=sadr(l)
      return
      end


      subroutine intschdir(fname)
      character*(*) fname
      logical getrhsvar, createvar,  putlhsvar
      logical checkrhs,checklhs
      include '../../routines/stack.h'
      nbvars=0
      if(.not.checkrhs(fname,1,1)) return
      if(.not.checklhs(fname,1,1)) return
      if(.not.getrhsvar(1,'c',m1,n1,l1)) return
      if(.not.createvar(2,'i',1,1,l2)) return
      call scichdir(cstk(l1:l1+m1*n1),istk(l2))
      if(istk(l2) .gt. 0) then 
         buf = fname // ': Internal Error' 
         call error(998)
         return
      endif
      lhsvar(1)=2
      if(.not.putlhsvar()) return
      return 
      end

      subroutine intsgetdir(fname)
c     --------------------------
      character*(*) fname
      logical checkrhs,checklhs
      include '../../routines/stack.h'
      logical putlhsvar, createvarfromptr
      double precision l1
      nbvars = 0
      rhs = max(0,rhs)
      if(.not.checkrhs(fname,0,0)) return
      if(.not.checklhs(fname,1,1)) return
      call scigetcwd(l1,m,err)
      if(err .gt. 0) then 
         buf = fname // ': Internal Error' 
         call error(998)
         return
      endif
      if(.not.createvarfromptr(1,'c',m,1,l1)) return
      lhsvar(1)=1
      if(.not.putlhsvar()) return
      end
      
      subroutine intsieee(fname)
c     --------------------------
      character*(*) fname
      logical checkrhs,checklhs
      include '../../routines/stack.h'
      logical cremat, getscalar

      integer iadr
c
      iadr(l)=l+l-1
C
      nbvars = 0
      rhs = max(0,rhs)
      if(.not.checkrhs(fname,0,1)) return
      if(.not.checklhs(fname,1,1)) return
      if(rhs.le.0) then
         top=top+1
         if(.not.cremat(fname,lw,0,1,1,lr,lc)) return
         stk(lr)=ieee
      else
         if(.not.getscalar(fname,top,top,lr)) return
         i=stk(lr)
         if(i.lt.0.or.i.gt.2) then
            err=1
            call error(116)
            return
         endif
         ieee=i
         il=iadr(lstk(top))
         istk(il)=0
      endif
      end
      
      subroutine inttypnam(fname)
c     --------------------------
      character*(*) fname
      logical checkrhs,checklhs
      include '../../routines/stack.h'
      logical cremat, getscalar
c     following common defines the initial database of type names
      integer maxtyp,nmmax,ptmax
      parameter (maxtyp=50,nmmax=200)
      integer tp(maxtyp),ptr(maxtyp),ln(maxtyp),namrec(nmmax)
      common /typnams/ tp,ptr,ln,namrec,ptmax
C
      integer iadr,sadr
c
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
C
      nbvars = 0
      rhs = max(0,rhs)
      
      if(rhs.eq.0) then
         if(.not.checklhs(fname,1,2)) return
c     compute number of defined types
         nt=0
         do 01 it=1,maxtyp
            if(ln(it).ne.0) nt=nt+1
 01      continue
c     allocate results
         top=top+1
c     .  vector of type numbers
         il=iadr(lstk(top))
         l=sadr(il+4)
         iln=iadr(l+nt)
         lw1=sadr(iln+5+nt+ptmax)
         err=lw1-lstk(bot)
         if(err.gt.0) then
            call error(17)
            return
         endif
c
         istk(il)=1
         istk(il+1)=nt
         istk(il+2)=1
         istk(il+3)=0
         lstk(top+1)=l+nt
c
         top=top+1
c     .  vector of type names
         iln=iadr(lstk(top))
         istk(iln)=10
         istk(iln+1)=nt
         istk(iln+2)=1
         istk(iln+3)=0
         istk(iln+4)=1
         ilc=iln+5+nt

         i1=0

         do 02 it=1,maxtyp
            if(ln(it).ne.0) then
               stk(l+i1)=tp(it)
               istk(iln+5+i1)=istk(iln+4+i1)+ln(it)
               call icopy(ln(it),namrec(ptr(it)),1,istk(ilc),1)
               ilc=ilc+ln(it)
               i1=i1+1
            endif
 02      continue
         lstk(top+1)=sadr(ilc)
         if(lhs.eq.1) top=top-1
         return
      endif
c
      if(.not.checkrhs(fname,0,2)) return
      if(.not.checklhs(fname,0,1)) return
      if(.not.getscalar(fname,top,top,lr)) return
      itype=stk(lr)
      if(itype.le.0) then
         err=1
         call error(116)
         return
      endif
      top=top-1
      il=iadr(lstk(top))
      if(istk(il).ne.10) then
         err=1
         call error(55)
         return
      endif
      if(istk(il+1).ne.1.or.istk(il+2).ne.1) then 
         err=1
         call error(60)
         return
      endif
      n=istk(il+5)-1
      call cvstr(n,istk(il+6),buf,1)

      call addtypename(itype,buf(1:n),ierr)
      if(ierr.eq.1) then
         call error(224)
         return
      elseif(ierr.eq.2) then
         call error(225)
         return
      elseif(ierr.eq.3) then
         call error(224)
         return
      endif
      istk(il)=0
      return
      end
