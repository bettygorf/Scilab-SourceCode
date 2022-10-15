      subroutine integr(t,x,nx,z,nz,u,nu,rpar,nrpar,ipar,nipar,nclock,
     &     out,nout,flag)
c     integrator
c!
      double precision t,x(*),z(*),u(*),rpar(*),out(*)
      integer ipar(*),flag
      common /dbcos/ idb
c
      if(idb.eq.1) then
         write(6,'(''Integr   t='',e10.3,'' flag='',i1)') t,flag
      endif

      if(flag.eq.1) then
         out(1)=x(1)
      elseif(flag.eq.2) then
         out(1)=u(1)
      endif
      return
      end
