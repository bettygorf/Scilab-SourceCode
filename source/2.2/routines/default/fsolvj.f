      subroutine fsolvj(n,x,fjac,iflag)
c     interface for solve fortran external (jacobian)
      include '../stack.h'
      integer n,iflag
      double precision x(n),fjac(n,n)
      character*6 namef,namej,name
      common/csolve/namef,namej
c
      call majmin(6,namej,name)
c
c INSERT CALL TO YOUR OWN ROUTINE HERE 
c The routine resid is an example: it is called when the
c string 'resid' is given as a parameter 
c in the calling sequence of scilab's impl built-in
c function 
c+

      if(name.eq.'essai') then
c         call essai(n,x,fjac,iflag)
         return
      endif
c+
c     dynamic link
      call tlink(name,0,it1)
      if(it1.le.0) goto 2000
      call dyncall(it1-1,n,x,fvec,iflag)
cc fin
      return
c
 2000 indsim=0
      buf=name
      call error(50)
      return
      end
