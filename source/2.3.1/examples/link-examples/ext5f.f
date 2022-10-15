      subroutine ext5f(b,c)
c     example 5
c     reading a vector in scilab internal stack using creadmat
c     (see SCIDIR/system2/creadmat.f)
c     -->link('ext5f.o','ext5f')
c     -->a=[1,2,3];b=[2,3,4];
c     -->c=fort('ext5f',b,1,'d','out',[1,3],2,'d')
c     -->c=a+2*b
      double precision a(3),b(*),c(*)
      logical creadmat

c     If 'a' exists reads it else return
      if(.not.creadmat('a',m,n,a)) then
         write(6,*) 'ext5', m,n,a(1),a(2),a(3)
      return
      endif
c     ***************************

c  same as
c      call matz(a,w,m,m,n,'a',0)
c
c     [m,n]=size(a)  here m=1 n=3
      do 1 k=1,n
   1  c(k)=a(k)+2.0d0*b(k)
      end
