      subroutine macro
c
      include '../stack.h'
c     
      double precision val
      integer equal,eol
      logical eqid,ptover
      integer blank,r,ival(2),ptr,top1,count,iadr
      equivalence (ival(1),val)
      data blank/40/,equal/50/,eol/99/
      
c
      iadr(l)=l+l-1
c
      r=rstk(pt)
      if (ddt .eq. 4) then
         write(buf(1:18),'(2i4,i6)') pt,r,fin
         call basout(io,wte,' macro  pt:'//buf(1:4)//' rstk(pt):'//
     &        buf(5:8)//' fin:'//buf(9:14))
      endif
c     
      ir=r/100
      if(ir.ne.5) goto 10
      goto(40,40,60),r-500
      goto 99
c     
 10   continue
      if(r.eq.701.or.r.eq.902.or.r.eq.604) goto 50
c     initialisation de l'execution d'une macro
c----------------------------------------------
c     
      ilk=iadr(fin)
c     
      if(istk(ilk).eq.10) then
         mrhs=0
         rhs=0
         mlhs=0
         l=ilk+5+istk(ilk+1)*istk(ilk+2)
         last=isiz-4
         if(macr.ne.0.or.paus.ne.0) then
            k=lpt(1)-(13+nsiz)
            last=lin(k+5)
         endif
      else
         wmac=0
         if(nmacs.gt.0) then
            do 15 im=1,nmacs
               if(eqid(ids(1,pt),macnms(1,im))) then
                  wmac=im
                  goto 16
               endif
 15         continue
 16         continue
         endif
         l=ilk+1
         mrhs=0
         last=bot
c     set output variable name
         mlhs=istk(l)
         l0=l
         l=l+nsiz*mlhs+1
         if(mlhs.lt.lhs) then
            if(mlhs.ne.0.or.lhs.gt.1) then
               lhs=mlhs
               pstk(pt)=l0
               call error(59)
               return
            endif
         endif

c     set input variable name
         mrhs=istk(l)
         l=l+1
         l1=l+nsiz*(rhs-1)
         l = l + nsiz*mrhs + 1
         if(mrhs.eq.0.and.rhs.le.1) rhs=0
         if(mrhs.lt.rhs) then
            pstk(pt)=l1-(rhs-1)*nsiz
            rhs=mrhs
            call error(58)
            return
         endif
      endif
c     save line pointers
      k = lpt(6)
      if(k+13+nsiz.gt.lsiz) then
         call error(108)
         return
      endif
      lin(k+1) = lpt(1)
      lin(k+2) = lpt(2)
      lin(k+3) = lpt(3)
      lin(k+4) = lpt(4)
      lin(k+5) = last
      lin(k+6) = ilk
      lin(k+7) = l
      val = stk(lstk(isiz))
      lin(k+8) = ival(1)
      lin(k+9) = ival(2)
      lin(k+10)=char1
      lin(k+11)=sym
      call putid(lin(k+12),syn)
      lin(k+12+nsiz)=lct(8)
      lpt(1) = k + 13+nsiz
c     
      if ( ptover(1,psiz-1)) return
      ids(1,pt) = rhs
      ids(2,pt) = lhs
      pstk(pt)=lct(4)
c     
      macr=macr+1
c     set line pointers
      k=lpt(1)
      lin(k) = eol
      lpt(6) = k
      lpt(4) = lpt(1)
      lpt(3) = lpt(1)
      lpt(2) = lpt(1)
cc_ex lct(1) = 0
      if (ddt .ne. 2) lct(4)=-1
      char1 = blank
      lin(lpt(4)+1)=blank
c     
c     save input variables
      if(comp(1).eq.0.and.mrhs.gt.0) then
         mrhs=rhs
         rhs=0
         do 20 j=1,mrhs
            call stackp(istk(l1),0)
            l1=l1-nsiz
 20      continue
      endif
c     
      toperr=top
      if(istk(ilk).eq.13) then
         lct(8)=1
         rstk(pt)=501
         icall=6
c     *call* run
      else
         lct(8)=1
         rstk(pt)=502
         icall=7
c     *call* parse
      endif
      go to 99
c     
 40   continue
c     fin de l'execution d'une macro
c-----------------------------------
c     restaure  pointers
      k = lpt(1) - (13+nsiz)
      ilk=lin(k+6)
      char1=lin(k+10)
      sym=lin(k+11)
      call putid(syn,lin(k+12))
      lct(8)=lin(k+12+nsiz)
c     
      lhsr=lhs
c     
      rhs=ids(1,pt)
      lhs=ids(2,pt)
      lct(4)=pstk(pt)
c     
      if(comp(1).ne.0) then
         comp(2)=comp(1)
         comp(1)=0
         macr=macr-1
         goto 47
      endif
      if(istk(ilk).ne.10) then
c     recopie des variables de sorties en haut de la pile
         l0=ilk+1
c     set output variable name
         mlhs=istk(l0)
         if(mlhs.eq.0.and.lhs.le.1) lhs=0
         l0=l0+1
         if(lhs.gt.0) then
            mrhs=rhs
            rhs=0
            do 41 i=1,lhs
               fin=0
               call stackg(istk(l0))
               if(fin.eq.0) then
                  call putid(ids(1,pt+1),istk(l0))
                  call error(4)
                  if(err.gt.0) return
               endif
               l0=l0+nsiz
 41         continue
            rhs=mrhs
         endif
      endif
c     
      macr=macr-1
      if(istk(ilk).eq.10) goto 48
      bot=lin(k+5)
      if(lhsr.ne.0) then
c     gestion des variables retournees par resume
         lpt(1)=lin(k+1)
         top1=top
         top=top-lhs
         count=0
c     
         if(rstk(pt).eq.501) then
c     dans les macros compilees
            count=pstk(pt+2)
            lc=ids(1,pt+1)+1
            do 44 i=1,lhsr
               call stackp(istk(lc),0)
               if(err.gt.0) return
               lc=lc+nsiz+1
 44         continue
         else
c     dans les macros non compilees
            ptr=pstk(pt+1)
            count=pstk(pt+2)
            do 45 i=1,lhsr
               call stackp(ids(1,ptr),0)
               if(err.gt.0) return
               ptr=ptr-1
 45         continue
         endif
c
c      on depile les variables relatives au for ou select eventuels


         top=top-count
c     
         if(lhs.gt.0) then
c     remise en place  des variables de sorties la macros 
            top1=top1-lhs
            do 46 i=1,lhs
               top1=top1+1
               top=top+1
               call dcopy(lstk(top1+1)-lstk(top1),stk(lstk(top1)),1,
     1              stk(lstk(top)),1)
               lstk(top+1)=lstk(top)+lstk(top1+1)-lstk(top1)
 46         continue
         endif
      endif
c     
 47   continue
      if(lhs.eq.0) then
         top=top+1
         il=iadr(lstk(top))
         istk(il)=0
         lstk(top+1)=lstk(top)+1
      endif
 48   pt=pt-1
      lpt(1)=lin(k+1)
      lpt(2)=lin(k+2)
      lpt(3)=lin(k+3)
      lpt(4)=lin(k+4)
      lpt(6)=k
      ival(1)=lin(k+8)
      ival(2)=lin(k+9)
      stk(lstk(isiz))=val
      return
c     
c     exec
 50   continue
      k = lpt(6)
      if(k+13+nsiz.gt.lsiz) then
         call error(26)
         return
      endif
      lin(k+1) = lpt(1)
      lin(k+2) = lpt(2)
      lin(k+3) = lpt(3)
      lin(k+4) = lpt(4)
      lin(k+5) = isiz-4
      if(macr.ge.1) lin(k+5)=lin(lpt(1)-(8+nsiz))
      if(rio.eq.rte) lin(k+5)=bot
c     les deux lignes precedentes sont necessaires pour que stackp connaisse
c     l'environnement de la macro courante
      lin(k+6) = lct(4)
      lin(k+7)=0
c     la ligne precedente permet de distinguer si c'est une macro (<>0) ou un
c     exec (=0) qui est au top level d'execution
      lin(k+10)=char1
      lin(k+11)=sym
      lin(k+12+nsiz)=lct(8)
      lpt(1) = k + (13+nsiz)
      if(lct(4).le.-10) fin=-lct(4)-11
      lct(4) = fin
      if(rio.eq.rte) paus=paus+1
      sym = eol
      if ( ptover(1,psiz)) return
      lct(8)=0
      rstk(pt)=503
      pstk(pt)=wmac
      wmac=0
      icall=7
c     *call parse*
      go to 99
c     
c     fin exec
 60   k = lpt(1) - (13+nsiz)
      lpt(1) = lin(k+1)
      lpt(2) = lin(k+2)
      lpt(3) = lin(k+3)
      lpt(4) = lin(k+4)
      lct(4) = lin(k+6)
      lpt(6) = k
      char1=lin(k+10)
      sym=lin(k+11)
      lct(8)=lin(k+12+nsiz)
      if(rio.eq.rte.and.paus.gt.0) then
         bot=lin(k+5)
         paus=paus-1
         call stsync(1)
      endif
      wmac=pstk(pt)
      pt=pt-1

      go to 99
c     
 99   continue
      return
      end
