      subroutine fsolvf(n,x,fvec,iflag)
c interface for fsolve fortran external
      include '../stack.h'
      integer n,iflag
      double precision x(n),fvec(n)
      character*6 namef,namej,name
      common/csolve/namef,namej
c
      call majmin(6,namef,name)
c INSERT CALL TO YOUR OWN ROUTINE HERE 
c The routine myprog is an example: it is called when the
c string 'myprog' is given as a parameter 
c in the calling sequence of scilab's fsolve built-in
c function 

c+
      if(name.eq.'myprog') then
c         call myprog(n,x,fvec,iflag)
         return
      endif
c+
c     dynamic link
      call tlink(name,0,it1)
      if(it1.le.0) goto 2000
      call dyncall(it1-1,n,x,fvec,iflag)
cc    fin
      return
c
 2000 indsim=0
      buf=name
      call error(50)
      return
      end

c         subroutine myprog(n,x,fvec,iflag)
c         integer n,iflag
c         double precision x(n),fvec(n)
c         ----------
c         calculate the functions at x and
c         return this vector in fvec.
c         ---------
c         return
c         end
c
c         the value of iflag should not be changed by fcn unless
c         the user wants to terminate execution of hybrd.
c         in this case set iflag to a negative integer.
c
c       n is a positive integer input variable set to the number
c         of functions and variables.
c
c       x is an array of length n. on input x must contain
c         an initial estimate of the solution vector. on output x
c         contains the final estimate of the solution vector.
c
c       fvec is an output array of length n which contains
c         the functions evaluated at the output x.

