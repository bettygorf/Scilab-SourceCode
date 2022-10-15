      subroutine dperm(vv,nv,ind)
c apply an in-situ  permutation 
      double precision vv(nv),x
      integer ind(nv)
c
      x=vv(1)
      i0=1
      i=i0
 10   continue
      if(ind(i).eq.i0) then 
        ind(i)=-ind(i)
        vv(i)=x
        i1=0
 11     i1=i1+1
        if(i1.gt.nv) goto 20
        if(ind(i1).lt.0) goto 11
        i0=i1
        i=i0
        x=vv(i0)
      else
         vv(i)=vv(ind(i))
         i1=ind(i)
         ind(i)=-ind(i)
         i=i1
      endif
      goto 10
 20   continue
      do 30 i=1,nv
         ind(i)=-ind(i)
 30   continue
      end
