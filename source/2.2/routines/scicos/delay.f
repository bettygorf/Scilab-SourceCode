      subroutine delay(t,x,nx,z,nz,u,nu,rpar,nrpar,ipar,nipar,nclock,
     &     out,nout,flag)
c     delay
c     delay=nx*dt
c!
      double precision t,x(*),z(*),u(*),rpar(*),out(*)
      integer ipar(*),flag,i
c
      if(flag.eq.1) then
c     interpolate to find values at t-delay
         out(1)=z(1)
      elseif(flag.eq.2) then
c     .  shift buffer   
         do 10 i=1,nz
            z(i)=z(i+1)
 10      continue
c     .  add new point to the buffer
         z(nz)=u(1)
       endif
      end
