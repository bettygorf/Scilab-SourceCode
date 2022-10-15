      subroutine f(a,ma,na,b,mb,nb,err) 
c     Copyright INRIA
      integer err,ma,na,mb,nb
      double precision a(*),b(*)
      do 10 i=1,ma*na
         a(i)=2*a(i)
 10   continue 
      do 20 i=1,mb*nb
         b(i)=3*b(i)
 20   continue
      return
      end
