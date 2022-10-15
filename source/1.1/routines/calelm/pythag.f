C/MEMBR ADD NAME=PYTHAG,SSI=0
      double precision function pythag(a,b)
c!but
c     pythag calcule (a**2+b**2)**(1/2), par une methode iterative
c!liste d'appel
c     double precision function pythag(a,b)
c     double precision a,b
c!
      double precision a,b
      double precision p,q,r,s,t
      logical v
c     test des NaN
      v=.false.
      if (.not.(a.le.1)) then
         if(.not.(a.ge.1)) then
            pythag=a
            return
         endif
      endif
      if (.not.(b.le.1)) then
         if(.not.(b.ge.1)) then
            pythag=b
            return
         endif
      endif
      p = max(abs(a),abs(b))
      q = min(abs(a),abs(b))
      if (q .eq. 0.0d+0) go to 20
   10 r = (q/p)**2
      t = 4.0d+0 + r
      if (t .eq. 4.0d+0) go to 20
      s = r/t
      p = p + 2.0d+0*p*s
      q = q*s
      go to 10
   20 pythag = p
      return
      end
