      subroutine ext4f(n,a,b,c)
c     example 4 (reading a chain)
c     -->link('ext4f.o','ext4f');
c     -->a=[1,2,3];b=[4,5,6];n=3;yes='yes'
c     -->c=fort('ext4f',n,1,'i',a,2,'d',b,3,'d','out',[1,3],4,'d')
c     -->c=sin(a)+cos(b)
c     -->yes='no'
c     -->c=a+b
c     -->clear yes  --> undefined variable : yes
      double precision a(*),b(*),c(*)
      logical creadchain
      character*(10) ch

c     If chain named yes exists reads it in ch else return
      if(.not.creadchain('yes',lch,ch)) return
c     *********************************     
      if(ch(1:lch).eq.'yes') then
      do 1 k=1,n
   1  c(k)=sin(a(k))+cos(b(k))
	else
      do 2 k=1,n
   2  c(k)=a(k)+b(k)
      endif
      end

