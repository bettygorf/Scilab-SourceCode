      subroutine matsys
c     ====================================================================
c     
c     evaluate system functions
c     
c     ====================================================================
c
      include '../stack.h'
      parameter (nz1=nsiz-1,nz2=nsiz-2)
c     
      common /mprot/ macprt
c
      
      integer eol,comma,p,iadr,sadr
      integer id(nsiz),fe,fv,semi
      integer double,reel,ent,sort,errn,orts,rtso,tsor,out
      integer uto,tou
      integer top2,tops,pt0,count,fptr,bbots
      double precision x
      logical flag,eqid
      integer offset
c     
      character*24    name
      common /inter/ name
      common /ibfu/ ibuf(200)
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
     +      450,500,510,600,610,620,630,640,650),fin
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
      if(rhs.gt.0) then
         call error(39)
         return
      endif
      if(lhs.gt.2) then
         call error(41)
         return
      endif
      n=isiz-bot
      top=top+1
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
 70   if(rhs.ne.1) then
         call error(39)
         return
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
      rstk(pt)=901
      icall=5
c     *call* parse  macro
      return
 71   l=ids(1,pt)
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
 80   continue
      if (rhs .eq. 0) then
         call error(39)
         return
      endif
      flag=.false.
      is=0
      namax=30
      call iset(namax,0,ladr,1)
      top2=top-rhs+1
      il=iadr(lstk(top2))
      nc=istk(il+5)-1
      name=' '
      call cvstr(nc,istk(il+6),name,1)
      name(nc+1:nc+1)=char(0)
C     Check the name in the <<fort>> table 
      call setinterf(name,irep)
      if ( irep.eq.1) then 
         buf = name
         call error(50)
         return
      endif
C     calcul de ie,tops,ipal,is1
      do 81 i=1,rhs
         tops=top2+i
         il=iadr(lstk(tops))
c     if(istk(il).eq.10.and.abs(istk(il+6)).eq.sort) goto 82
         if(istk(il).eq.10) then
            if(istk(il+6).eq.sort.and.istk(il+7).eq.orts.and.
     $      istk(il+8).eq.rtso.and.istk(il+9).eq.tsor) goto 82
            if(istk(il+6).eq.out.and.istk(il+7).eq.uto.and.
     $      istk(il+8).eq.tou) goto 82
         endif
 81   continue
c     la chaine 'sort' n apparait pas ; on va a la forme breve
      goto 110
 82   continue
      ie=(tops-1-top2)/3
      ipal=sadr(il)
      lbot=lstk(bot)
      is1=3*ie+1
c     ie :nb de variables d entree transmises
c     
c     calcul de iss: nombre de variables de sorties
c     transmises (apres le sort)
      jjj=tops+1
      iss=0
      if(jjj.gt.top) goto 86
      do 85 i=1,namax
         ilm=iadr(lstk(jjj))
         if(istk(ilm+1)*istk(ilm+2).eq.2) goto 83
c     forme courte;position seulmt.
         jjj=jjj+1
         goto 84
 83      continue
         jjj=jjj+3
 84      continue
         iss=iss+1
         if(jjj.gt.top) goto 86
 85   continue
 86   continue
      if(iss.gt.0 .and. lhs.gt.iss) then
         call error(41)
         return
      endif
      if(err.gt.0) return
      ieis=ie+iss
      if(ie.eq.0) goto 88
c     traitement des variables d'entree
      do 87 i=1,ie
         ir1=top2+1+3*(i-1)
         ir=ir1+1
         irt=ir+1
         il=iadr(lstk(ir))
         il1=iadr(lstk(ir1))
         ivol=istk(il1+1)*istk(il1+2)
         l=sadr(il+4)
         l1=sadr(il1+4)
         ipla=int(stk(l))
         ilt=iadr(lstk(irt))
         if(istk(ilt).ne.10) then
            err=i*3+1
            call error(55)
            return
         endif
         itf=abs(istk(ilt+5+istk(il+1)*istk(il+2)))
         ibuf(1+3*(i-1))=ipla
         ibuf(2+3*(i-1))=l1
         ibuf(3+3*(i-1))=itf
c     test simple,entier...et conversion
         if(itf.eq.double) goto 87
         if(itf.eq.reel) call simple(ivol,stk(l1),stk(l1))
         if(itf.eq.ent.or.itf.eq.12) call entier(ivol,stk(l1),stk(l1))
         if(itf.eq.12) then
            call in2str(ivol,istk(iadr(l1)),istk(iadr(l1)))
         endif
         if(itf.eq.reel.or.itf.eq.ent.or.itf.eq.12) goto 87
         if(itf.ne.reel.and.itf.ne.double.and.itf.
     + ne.ent.and.itf.ne.12) then
            call error(71)
            return
         endif
 87   continue
c     
 88   continue
c     
c     traitement des variables de sortie
      jjj=tops+1
      if(iss.eq.0) goto 95
      do 94 i=1,iss
         ilm=iadr(lstk(jjj))
         if(istk(ilm+1)*istk(ilm+2).eq.2) goto 93
c     forme courte:position seulmt.
         lm=sadr(ilm+4)
         ipla=int(stk(lm))
         ijk=3*ie+1+(i-1)*3
         ijkl=3*ie+3*iss+3*(i-1)+1
c     on va chercher nlgn,ncol,type
         do 91 j=1,ie
            jj=1+3*(j-1)
            if(ibuf(jj).eq.ipla) goto 92
 91      continue
c     variable de sortie qui n'est pas une variable d'entree
         flag=.true.
         goto 94
 92      continue
         itf=ibuf(jj+2)
c     ivol= size(jj+1,nlgn,ncol)
         jadr=iadr(ibuf(jj+1))
         nlgn=istk(jadr-3)
         ncol=istk(jadr-2)
         ivol=nlgn*ncol
cccc  call alloc(ipla,ivol,nlgn,ncol,typfor)
         is=is+1
         is2=is1+3*is
         la=is1+3*(2*is-1)
         ibuf(la)=nlgn
         ibuf(la+1)=ncol
         ibuf(la+2)=itf
         call icopy(3*(is-1),ibuf(is1+(is-1)*3),-1,ibuf(is1+3*is),-1)
         ka=is1+(is-1)*3
         ibuf(ka)=ipla
         ibuf(ka+1)=ivol
         ibuf(ka+2)=itf
cccc  
         jjj=jjj+1
         goto 94
 93      continue
c     cas standard on met plac,vol,type + nl,nc,type
         il=iadr(lstk(jjj+1))
         ilp=iadr(lstk(jjj+2))
         lm=sadr(ilm+4)
         nlgn=int(stk(lm))
         ncol=int(stk(lm+1))
         ivol=nlgn*ncol
         l=sadr(il+4)
         itf=abs(istk(ilp+5+istk(ilp+1)*istk(ilp+2)))
         ipl=int(stk(l))
cccc  call alloc(ipl,ivol,nlgn,ncol,typfor)
         is=is+1
         is2=is1+3*is
         la=is1+3*(2*is-1)
         ibuf(la)=nlgn
         ibuf(la+1)=ncol
         ibuf(la+2)=itf
         call icopy(3*(is-1),ibuf(is1+(is-1)*3),-1,ibuf(is1+3*is),-1)
         ka=is1+(is-1)*3
         ibuf(ka)=ipl
         ibuf(ka+1)=ivol
         ibuf(ka+2)=itf
cccc  
         jjj=jjj+3
 94   continue
 95   continue
c     
c     calcul des adresses ladr(.)
      narg=0
      do 100 i=1,ieis
         narg=max(narg,ibuf(3*(i-1)+1))
 100  continue
      nbarg=narg
      if(narg.gt.namax) then
         call error(70)
         return
      endif
      n=namax-narg
      if(.not.flag) then
         do 101 k=1,n
            ladr(narg+k)=lbot-1
 101     continue
      endif
      do 103 j=1,narg
         do 102 i=1,ieis
            i1=3*(i-1)+1
            if(ibuf(i1).ne.j) goto 102
            if(i.le.ie) ladr(j)=ibuf(i1+1)
            if(i.gt.ie.and.ladr(j).eq.0) ladr(j)=ipal
            if(i.gt.ie.and.ladr(j).eq.ipal) ipal=ipal+ibuf(i1+1)
            err=ipal-lbot
            if(err.gt.0) then
               call error(17)
               return
            endif
 102     continue
 103  continue
c     
      if(.not.flag) call interf(stk(ladr(1)),stk(ladr(2)),
     $     stk(ladr(3)),stk(ladr(4)),stk(ladr(5)),stk(ladr(6)),
     $     stk(ladr(7)),stk(ladr(8)),stk(ladr(9)),stk(ladr(10)),
     $     stk(ladr(11)),stk(ladr(12)),stk(ladr(13)),stk(ladr(14)),
     $     stk(ladr(15)),stk(ladr(16)),stk(ladr(17)),stk(ladr(18)),
     $     stk(ladr(19)),stk(ladr(20)),stk(ladr(21)),stk(ladr(22)),
     $     stk(ladr(23)),stk(ladr(24)),stk(ladr(25)),stk(ladr(26)),
     $     stk(ladr(27)),stk(ladr(28)),stk(ladr(29)),stk(ladr(30)))
      if(flag) call interf(x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,
     1     x,x,x,x,x,x,x,x,x,x,x,x,x,x,x)
      top=top2
      if(iss.le.0) then
         il=iadr(lstk(top))
         istk(il)=0
         lstk(top+1)=lstk(top)+1
      else
         ir1=is1
         do 104 i=1,lhs
            no=ibuf(ir1)
            call back(no)
            ir1=ir1+3
 104     continue
         top=top-1
      endif
      goto 999
 110  continue
c     no out: interface automatique...forme breve
      top=top2
      lbot=lstk(bot)
      ipal=sadr(il)
      ie=rhs-1
      do 111 i=1,ie
         ir1=top2+i
         il=iadr(lstk(ir1))
         ivol=istk(il+1)*istk(il+2)
         l1=sadr(il+4)
         if(istk(il).ne.1) then
         buf='fort: invalid input parameter'
         call error(9999)
         return
         endif
         ibuf(1+3*(i-1))=i
         ibuf(2+3*(i-1))=l1
         ibuf(3+3*(i-1))=0
         ladr(i)=l1
 111  continue
      call interf(x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,
     1     x,x,x,x,x,x,x,x,x,x,x,x,x,x,x)
      top=top2+lhs-1
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
      if(rstk(pt0).eq.501) then
c     resume dans une macro compilee
         lc=pstk(pt)
         ids(1,pt0+1)=lc
         pstk(pt0+2)=count
      elseif(rstk(pt0).eq.502) then
c     resume dans une macro non compilee
         if(rstk(pt-1).ne.201
     &        .or.rstk(pt-2).ne.101
     &        .or.rstk(pt-3).ne.703
     &        .or.(sym.ne.semi.and.sym.ne.comma.and.sym.ne.eol)) 
     &         goto 156
         pt=pt-3
         pstk(pt0+1)=pt
         pstk(pt0+2)=count
      elseif(rio.eq.rte) then
c     resume dans une pause
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
c     look for  variables in the stack
      fin=-1
      call stackg(id)
      if (fin.le.0) then
c     look for libraries functions
         fin=-3
         kfun=fun
         call funs(id)
         fun=kfun
      endif
      if (fin.gt.0) fin=1
      istk(il)=1
      l=sadr(il+4)
      stk(l)=dble(fin)
      lstk(top+1)=l+1
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
      errct=(8*imess+imode)*10000+abs(num)
      if(num.lt.0) errct=-errct
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
         buf='Required memory to small for defined data'
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
c
 998  continue
c     fake calls for link
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
            buf= fname // ': Error'
            call error(999)
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
     $     istk(il3),istk(ild3),m3*n3)
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
      logical checkrhs,crebmat,getscalar,getsmat
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
      return
      end


      subroutine scifhelp(fname)
c     =============================
c     fhelp(name)
      character*(*) fname
      logical checkrhs,checklhs,getsmat,checkval,cresmat2,bufstore
      include '../stack.h'
      rhs = max(0,rhs)
      lbuf = 1
      if(.not.checkrhs(fname,1,1)) return
      if(.not.getsmat(fname,top,top-rhs+1,m1,n1,1,1,lr1,nlr1)) return
      if(.not.checkval(fname,m1*n1,1)) return
      if(.not.bufstore(fname,lbuf,lbufi1,lbuff1,lr1,nlr1)) return
      call iscihelp(buf,buf(lbufi1:lbuff1),ierr)
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
      if(.not.bufstore(fname,lbuf,lbufi1,lbuff1,lr1,nlr1)) return
      call isciap(buf,buf(lbufi1:lbuff1),ierr)
      call objvide(fname,top)
      return
      end

      subroutine in2str(n,line,str)
c     int to string (cvstr)
c!
c
      include '../stack.h'
      integer eol
c
      integer line(*)
      character str*(*),mc*1
      data eol/99/
c
c     conversion code ->ascii
      do 30 j=1,n
      m=line(j)
      if(abs(m).gt.csiz) m=99
      if(m.eq.99) goto 10
      if(m.lt.0) then
                     str(j:j)=alfb(abs(m)+1)
                 else
                     str(j:j)=alfa(m+1)
      endif
      goto 30
   10 str(j:j)='!'
   30 continue
      j=n+1
         str(j:j)=char(0)
      return
c
      end








