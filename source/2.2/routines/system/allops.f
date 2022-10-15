      subroutine allops
c ======================================================================
c     Calling function according to arguments type
c ======================================================================
      include '../stack.h'
      integer ogettype, vt,vt1,id(nsiz),r
      logical compil,ptover
      integer iadr,sadr
c
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1

      r=0
      if(pt.gt.0) r=rstk(pt)
c
      if (ddt .eq. 4) then
         write(buf(1:12),'(3i4)') fin,pt,r
         call basout(io,wte,' allops op:'//buf(1:4)//' pt:'//buf(5:8)//
     &                   ' rstk(pt):'//buf(9:12))
      endif
c
c     compilation allops :<5 fin rhs lhs>
      if ( compil(5,fin,rhs,lhs,0)) then
         if (err.gt.0) return
         fun=0
         return
      endif
c
 01   ir=r/100
      if(ir.eq.4) then
         if (r.eq.401) then 
            call putid(syn(1),ids(1,pt))
            pt=pt-1
         else if (r.eq.402) then 
            pt=pt-1
         endif
         return
      endif
      if(err1.gt.0) return
      vt=0
      do 03 i=1,rhs
         vt1=abs(ogettype(top+1-i))
         if(vt1.gt.vt) vt=vt1
 03   continue
c
      goto (10,20,05,30,70,35,05,05,05,40,60,05,60,60,50,50) ,vt
 05   call error(43)
      return
 10   call matops
      goto 80
 20   call polops
      goto 80
 30   call logic
      goto 80
 35   call lspops
      goto 80
 40   call strops
      goto 80
 50   call lstops
      goto 80
 60   call misops
      goto 80
 70   call spops
      goto 80

c
 80   if(err.gt.0) return
      if(fun.ne.0) then 
c        ------appel d'un matfn necessaire pour achever l'evaluation
         if (ptover(1,psiz)) return
         rstk(pt)=402
         icall=9
c        *call* matfns
      return
      endif
      if(fin.gt.0) return
c     ---------------recherche d'une macro associee a une operation macro 
c                    programme
      fin=-fin
      call mname(fin,id)
      if(err.gt.0) return
c     ---------------appel de la macro
      fin=lstk(fin)
      if (ptover(1,psiz)) return
      call putid(ids(1,pt),syn(1))
c next line suppressed to allow multiple extraction
c      lhs=1
      rstk(pt)=401
      icall=5
c     *call* macro
      return
      end
