C/MEMBR ADD NAME=PUTID,SSI=0
      subroutine putid(x,y)
c
c     store a name
c
      integer nsiz
      parameter (nsiz=2)
      integer x(nsiz),y(nsiz)
      do 10 i = 1, nsiz
   10 x(i) = y(i)
      return
      end
