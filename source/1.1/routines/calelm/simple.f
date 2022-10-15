C/MEMBR ADD NAME=SIMPLE,SSI=0
      subroutine simple(n,d,s)
c!
      double precision d(*)
      real s(*),rmax,r1mach
c
      rmax=r1mach(2)
c
      do 10 i=1,n
      if(abs(d(i)).gt.rmax) then
        s(i)=real(sign(dble(rmax),d(i)))
      else
        s(i)=real(d(i))
      endif
   10 continue
      return
      end
