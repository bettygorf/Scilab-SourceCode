      subroutine wij2sp(m,n,nel,ij,vr,vi,ind,nind,iw,ierr)
      double precision vr(nel),vi(nel)
      integer ij(nel,2),ind(nind),iw(nel)
c
      ierr=0
      if(nel.eq.0) then
         call iset(m,0,ind,1)
         return
      endif
      call isort1(ij(1,1),nel,iw,1)
      call iperm(ij(1,2),nel,iw)
      call dperm(vr,nel,iw)
      call dperm(vi,nel,iw)
c     mm=max(i),nn=max(j)
      mm=ij(nel,1)
      nm=0
      if(nel.gt.0) then
         do 10 k=1,nel
            nm=max(nm,ij(k,2))
 10      continue
      endif
      if(n.gt.0) then
         if(n.lt.nm.or.m.lt.mm) then
            ierr=1
            return
         endif
      else
         n=nm
         m=mm
      endif
      if(nind.lt.m+nel) then
         ierr=2
         return
      endif
c     calcul du nombre d'element non nul par lignes et tri par colonne    
         i0=1
         do 20 lp=1,m
            i=i0-1
 21         i=i+1
            if(i.le.nel) then
               if(ij(i,1).eq.lp) goto 21
            endif
            nl=i-i0
c     nl est le nombre d'element dans la ligne
            ind(lp)=nl
            if(nl.gt.1) then
               call isort1(ij(i0,2),nl,iw,1)
               call dperm(vr(i0),nl,iw)
               call dperm(vi(i0),nl,iw)
            endif
            i0=i
 20      continue
         call icopy(nel,ij(1,2),1,ind(m+1),1)
         end
      
