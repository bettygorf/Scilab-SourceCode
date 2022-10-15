      subroutine ext3f(ch,n,a,b,c)
c     example 3 (passing a chain)
c     -->link('ext3f.o','ext3f');
c     -->a=[1,2,3];b=[4,5,6];n=3;yes=str2code('yes')
c     -->c=fort('ext3f',yes,1,'c',n,2,'i',a,3,'d',b,4,'d','out',[1,3],5,'d')
c     -->c=sin(a)+cos(b)
      double precision a(*),b(*),c(*)
      character*(*) ch
      if(ch(1:3).eq.'yes') then
      do 1 k=1,n
   1  c(k)=sin(a(k))+cos(b(k))
	else
      do 2 k=1,n
   2  c(k)=a(k)+b(k)
      endif
      end
