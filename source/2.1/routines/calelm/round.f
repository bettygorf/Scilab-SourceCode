      double precision function round(x)
c!
      double precision x,y,z,e,h
      logical v
      data h/1.0d+9/
c
      if (x.eq.0d0) goto 40
      if ((2.0d0*x).eq.dble(int(2.d0*x))) then
      if (x.gt.0.d0) x=x-1.d-10
      if (x.lt.0.d0) x=x+1.d-10
      endif
      z = abs(x)
c     test des NaN
      v=.false.
      if (.not.(x.le.1)) then
         if(.not.(x.ge.1)) then
            v=.true.
         endif
      endif
      if(v) goto 40

      y = z + 1.0d+0
      if (y .eq. z) go to 40
      y = 0.0d+0
      e = h
   10 if (e .ge. z) go to 20
         e = 2.0d+0*e
         go to 10
   20 if (e .le. h) go to 30
         if (e .le. z) y = y + e
         if (e .le. z) z = z - e
         e = e/2.0d+0
         go to 20
   30 z = int(z + 0.50d+0)
      y = y + z
      if (x .lt. 0.0d+0) y = -y
      round = y
      return
   40 round = x
      return
      end
