      subroutine sz2ptr(ind,m,ptr)
      integer ind(m),ptr(*)
      ptr(1)=1
      do 10 i=1,m
         ptr(i+1)=ptr(i)+ind(i)
 10   continue
      end
