      subroutine run
c ======================================================================== 
C     Execution of a compiled macro 
c ======================================================================== 
c     
      include '../stack.h'
c     
      double precision x
      integer op,equal,less,great,r,ix(2)
      equivalence (x,ix(1))
      logical logops,ok,iflag,istrue,ptover,cremat,cresmat,
     $     vcopyobj,ilog
      integer p,lr,nlr,lcc
      common /basbrk/ iflag
      integer otimer,ntimer,stimer
      external stimer
      save otimer
      data otimer/0/
      data equal/50/,less/54/,great/55/
c     
      call xscion(inxsci)
      if (ddt .eq. 4) then
         write(buf(1:8),'(2i4)') pt,rstk(pt)
         call basout(io,wte,' run pt:'//buf(1:4)//' rstk(pt):'
     &        //buf(5:8))
      endif
c     
      l0=0
      nc=0
c     
      if ( ptover(0,psiz-2)) return
c     
      r=rstk(pt)
      ir=r/100
      if(ir.ne.6) goto 01
      goto(33,66,82,92,58),r-600
c     
c     debut d'une macro compilee
 01   continue
      toperr=top
      k=lpt(1)-(13+nsiz)
      lc=lin(k+7)
c     
 10   if(err.gt.0) return
c$$$      if(err1.ne.0) then
c$$$        if(err2.eq.0) err2=err1
c$$$        err1=0
c$$$        imode=abs(errct/10000)
c$$$        if(imode-4*int(imode/4).eq.2) iflag=.true.
c$$$      endif
      if(iflag) then
         iflag=.false.
         goto 91
      endif
      if(lc-l0.ne.nc) goto 11
      r=rstk(pt)-610
      goto(46,47,52,56,57,61),r
c     
c     nouvelle 'operation'
 11   continue
      op=istk(lc)
      goto(20,25,40,42,30,41,45,49,49,55,15,90,95,100,105,110,
     $     120) ,op
c     matfns
      if(op.ge.100) goto 80
c     return
      if(op.eq.99) then
c     le return s'est-il produit dans un for (si oui il faut depiler la variable
c     de boucle
         p=pt+1
 12      p=p-1
         if(rstk(p).eq.612) then
            top=top-1
         else if(rstk(p).ne.501) then
            goto 12
         endif
 13      fin = 2
         goto 998
      endif
c     
 15   continue
      call error(60)
      return
c     
 20   continue
      call stackp(istk(lc+1),0)
      lc=lc+1+nsiz
      goto 10
c     
 25   fin=istk(lc+nsiz+1)
      rhs=istk(lc+nsiz+2)
 26   call stackg(istk(lc+1))
      if(err.gt.0) then 
         lc=lc+nsiz+3
         goto 10
      endif
      if(fin.ne.0) goto 28
      call funs(istk(lc+1))
      if(err.gt.0) return
      if(fun.ne.-2) then
         call putid(ids(1,pt+1),istk(lc+1))
         if(fun.eq.0) then
            call error(4)
         else
            call error(110)
         endif
         lc=lc+nsiz+3
         goto 10   
      endif
      fin=istk(lc+nsiz+1)
      goto 26
 28   lc=lc+nsiz+3
      if(fin.gt.0) goto 65
      goto 10
c     
c     allops
 30   fin=istk(lc+1)
      rhs=istk(lc+2)
      lhs=istk(lc+3)
      lc=lc+4
      pt=pt+1
      rstk(pt)=601
      icall=4
      pstk(pt)=lc
c     *call* allops
      return
 33   continue
      lc=pstk(pt)
      pt=pt-1
      goto 70
c     
c     string
 40   n=istk(lc+1)
      top=top+1
      if (cresmat("run",top,1,1,n)) then 
         call getsimat("run",top,top,mm1,nn1,1,1,lr,nlr)         
         call icopy(n,istk(lc+2),1,istk(lr),1)
      endif
      lc=lc+n+2
      goto 10
c     num
 41   ix(1)=istk(lc+1)
      ix(2)=istk(lc+2)
      top=top+1
      if (cremat("run",top,0,1,1,lr,lcc)) then 
         stk(lr)=x
      endif
      lc=lc+3
      goto 10
c     
 42   call defmat
      lc=lc+1
      goto 10
c     
c     for
 45   nc=istk(lc+1)
      lc=lc+2
      l0=lc
      if ( ptover(1,psiz)) then 
         lc=lc+nc
         lc=lc+nsiz+istk(lc)
         goto 10
      endif
      toperr=top
      rstk(pt)=611
      ids(1,pt)=l0
      ids(2,pt)=nc
      goto 10
c     
 46   nc=istk(lc)
      l0=lc+1+nsiz
      rstk(pt)=612
      pstk(pt)=0
      ids(1,pt)=l0
      ids(2,pt)=lct(8)
 47   lc=l0
      call nextj(istk(l0-nsiz),pstk(pt))
      if(pstk(pt).ne.0) then
         lct(8)=ids(2,pt)
         if (inxsci.eq.1) then
            ntimer=stimer()
            if (ntimer.ne.otimer) then
               call sxevents()
               otimer=ntimer
            endif
         endif
         goto 10
      endif
c     fin for
      lc=lc+nc
      pt=pt-1
      goto 70
c     
c     if - while  (Anciennes versions maintenue pour compatibilite)
 49   continue
      li=lc
      if(istk(li+1).lt.0) goto 55
      if ( ptover(1,psiz)) then 
         lc=lc+1+istk(lc+2)+istk(lc+3)+istk(lc+4)
         goto 10
      endif
c     evaluation de l'expression logique
      nc=istk(li+2)
      lc=li+5
      pstk(pt)=lct(8)
 51   kc=0
      rstk(pt)=613
      ids(1,pt)=li
      l0=lc
      ids(2,pt)=kc
      goto 10
c
 52   if(kc.eq.0) then
         lhs=0
         toperr=top
         if(istk(li+1).gt.0) then
c     cet appel permet de garder la compatibilite avec les macro compilees
c     precedemment a l'existence des booleens.
            ok=logops(istk(li+1))
         else
            ok=istrue(1)
         endif
         if(ok) then
c     evaluation des instructions du then
            lct(8)=pstk(pt)
            nc=istk(li+3)
            kc=1
         else
            nc=istk(li+4)
            lc=lc+istk(li+3)
            kc=2
         endif
         l0=lc
         ids(2,pt)=kc
         goto 10
      endif
c     
      if(kc.ne.2.and.istk(li).eq.9) goto 51
      lct(8)=pstk(pt)
      lc=li+5+istk(li+2)
      lc=lc+istk(li+3)+istk(li+4)
      pt=pt-1
      goto 70
c     
c     select - case  ou nouveau "if elseif else end"
 55   continue
      if ( ptover(1,psiz)) then 
         lc=lc+abs(istk(lc+1))
         goto 10
      endif
      pstk(pt)=lc
c     
      if(istk(lc+1).gt.0) then
c     premiere expression
         nc=istk(lc+3)
         rstk(pt)=614
         lc=lc+4
         l0=lc
         ids(1,pt)=l0
         ids(2,pt)=nc
         goto 10
      else
         lc=lc+4
      endif
c     
c     expri
 56   continue
      if(istk(pstk(pt)).eq.10) then
c     recopie de la premiere expression 
         if (.not.vcopyobj("run",top,top+1)) return
         top=top+1
      endif
c     
      nc=istk(lc)
      rstk(pt)=615
      lc=lc+1
      l0=lc
      ids(1,pt)=l0
      ids(2,pt)=nc
      goto 10
c     
c     instructions i
 57   continue
      toperr=top
      if(nc.eq.0) then
c     si nc=0 l'instruction i correspond a l'isntruction associee au  else
         ok=.true.
         if(istk(pstk(pt)).eq.10) top=top-1
         goto 59
      elseif(istk(pstk(pt)).ne.10) then
         ok=istrue(1)
         if(err.gt.0) return
         goto 59
      endif
      pt=pt+1
      fin=equal
      rhs=2
      lhs=1
      rstk(pt)=605
      icall=4
      pstk(pt)=lc
c     *call* allops(equal)
      return
c
 58   continue
      lc=pstk(pt)
      pt=pt-1
      ok=istrue(1)
      if(err.gt.0) return
 59   nc=istk(lc)
      if(ok) then
         lc=lc+1
         if(istk(pstk(pt)).eq.10) top=top-1
         l0=lc
         ids(1,pt)=l0
         ids(2,pt)=nc
         rstk(pt)=616
         if (inxsci.eq.1) then
            ntimer=stimer()
            if (ntimer.ne.otimer) then
               call sxevents()
               otimer=ntimer
            endif
         endif
         goto 10
      else
         if(istk(pstk(pt)).eq.9) goto 62
         lc=lc+nc+1
         goto 56
      endif
c     
 61   continue
c     fin if while select/case
      l0=pstk(pt)
      if(istk(pstk(pt)).eq.9) then
         lc=l0+4
         goto 56
      endif
 62   l0=pstk(pt)
      lc=l0+abs(istk(l0+1))
      pt=pt-1
      goto 70
c     
c     macro
 65   rhs=max(istk(lc+2)-1,0)
      lhs=istk(lc+3)
      lc=lc+4
c     
      if ( ptover(1,psiz)) goto 10 
      rstk(pt)=602
      pstk(pt)=lc
      ids(1,pt)=wmac
      icall=5
      fun=0
c     *call* macro
      return
 66   lc=pstk(pt)
      wmac=ids(1,pt)
      pt=pt-1
      goto 70
c     
 70   continue
      if (inxsci.eq.1) then
         ntimer=stimer()
         if (ntimer.ne.otimer) then
            call sxevents()
            otimer=ntimer
         endif
      endif
      r=rstk(pt)-610
      goto(74,71,72,73,73,73) ,r
      goto 10
c     retour d'une boucle interne ou d'une macro vers un for
 71   j=pstk(pt)
      l0=ids(1,pt)
      nc=istk(l0-1-nsiz)
      goto 10
c     retour  d'une boucle interne ou d'une macro vers un if/while
 72   li=ids(1,pt)
      kc=ids(2,pt)
      nc=istk(li+2)
      l0=li+5
      if(kc.eq.0) goto 10
      l0=l0+nc
      nc=istk(li+3)
      if(kc.eq.1) goto 10
      l0=l0+nc
      nc=istk(li+4)
      goto 10
c     retour d'une boucle interne vers une clause select
 73   l0=ids(1,pt)
      nc=ids(2,pt)
      goto 10
c     
 74   l0=ids(1,pt)
      nc=ids(2,pt)
      goto 10
c     
 80   fun=op/100
      rhs=istk(lc+1)
      lhs=istk(lc+2)
      fin=istk(lc+3)
      lc=lc+4
c     
 81   pt=pt+1
      rstk(pt)=603
      pstk(pt)=lc
      icall=9
      ids(2,pt)=0
      
c     *call* matfns
      return
 82   continue
      lc=pstk(pt)
      pt=pt-1
      if(ids(2,pt+1).eq.0) goto 70
c     fin resume
      lhs=ids(2,pt+1)
      goto 999
c     
c     pause
 90   lc=lc+1
 91   continue
      if ( ptover(1,psiz)) goto 10
      pstk(pt)=rio
      rio=rte
      fin=2
      if(lct(4).le.-10) then
         fin=-1
         lct(4)=-lct(4)-11 
      endif
      ids(1,pt)=lc
      ids(2,pt)=top
      rstk(pt)=604
      icall=5
c     *call* macro
      return
 92   lc=ids(1,pt)
      top=ids(2,pt)
      rio=pstk(pt)
      pt=pt-1
      call stsync(1)
      goto 70
c     
c     break
 95   continue
      pt=pt+1
 96   pt=pt-1
      if(pt.eq.0) then
         lc=lc+1
         goto 10
      endif
      if(rstk(pt).eq.612) then
c     break dans un for
         l0=ids(1,pt)
         lc=l0+istk(l0-1-nsiz)
         pt=pt-1
         top=top-1
         goto 70
      elseif(rstk(pt).eq.616.and.istk(pstk(pt)).eq.9) then
c     break dans un while 
         l0=pstk(pt)
         lc=l0+abs(istk(l0+1))
         pt=pt-1
         goto 70
      else
         goto 96
      endif
c     
c     abort
 100  continue
      pt=pt+1
 101  pt=pt-1
      if(pt.eq.0) goto 102
      if(int(rstk(pt)/100).eq.5) then
         k = lpt(1) - (13+nsiz)
         lpt(1) = lin(k+1)
         lpt(2) = lin(k+2)
         lpt(3) = lin(k+3)
         lpt(4) = lin(k+4)
         lct(4) = lin(k+6)
         lpt(6) = k
         if(rstk(pt).le.502) bot=lin(k+5)
      endif
      goto 101
 102  continue
      icall=10
      top=0
      comp(1)=0
      if(niv.gt.1)  err=9999999
      return
c
 105  continue

c     eol
c     la gestion de la recuperation des erreurs devrait plutot se trouver
c     a la fin de l'instruction (mais il n'y a pas actuellement d'indicateur
c     de fin d'instruction dans les macros
      if(err1.ne.0) then
        if(err2.eq.0) err2=err1
        err1=0
        imode=abs(errct/10000)
        if(imode-4*int(imode/4).eq.2) iflag=.true.
      endif

c     gestion des points d'arrets dynamiques
      if(wmac.ne.0) then
         do 106 ibpt=lgptrs(wmac),lgptrs(wmac+1)-1
            if(lct(8).eq.bptlg(ibpt)) then
               call cvname(macnms(1,wmac),buf(1:nlgh),1)
               write(buf(nlgh+2:nlgh+7),'(i5)') lct(8)
               call msgs(32,0)
               iflag=.true.
               goto 107
            endif
 106      continue
      endif
 107   continue
c
      lct(8)=lct(8)+1
      lc=lc+1
      if (inxsci.eq.1) then
         ntimer=stimer()
         if (ntimer.ne.otimer) then
            call sxevents()
            otimer=ntimer
         endif
      endif
      goto 10
c     
c     set line number. Au debut de chaque expression liee a un then et a 
c     la fin de chaque clause, le compilateur (compcl) inscrit
c     la valeur de la ligne. ceci permet de mettre rapidement a jour le
c     compteur de ligne sans avoir a analyser la suite des codes operatoires
 110  continue
      lct(8)=istk(lc+1)
      lc=lc+2
      goto 10
c
c     quit
c
 120  continue 
      fun=99
      return

 998  continue
      lhs=0
 999  continue
      if(rstk(pt).ne.501) then
         pt=pt-1
         goto 999
      endif
      fun=0
      return
c     
      end
