      subroutine ext7f(a,b)
c     example 7
c     creating vector c in scilab internal stack
c     -->link('ext7f.o','ext7f')
c     -->a=[1,2,3]; b=[2,3,4];
c     c does not exist (c made by the call to matz)
c     -->fort('ext7f',a,1,'d',b,2,'d','out',1);
c     c now exists
c     -->c=a+2*b
      double precision a(3),b(3),c(3),w
      do 1 k=1,3
   1  c(k)=a(k)+2.0d0*b(k)
      call matz(c,w,1,1,3,'c',1)
c     [m,n]=size(a)  here m=1 n=3
      end
