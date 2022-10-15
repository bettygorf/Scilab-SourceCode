      subroutine select(t,x,nx,z,nz,u,nu,rpar,nrpar,ipar,nipar,nclock,
     &     out,nout,flag)
c     delay
c     delay=nx*dt
c!
      double precision t,x(*),z(*),u(*),rpar(*),out(*)
      integer ipar(*),flag
      common /dbcos/ idb
c
      if(idb.eq.1) then
         write(6,'(''Select     t='',e10.3,'' flag='',i1)') t,flag
      endif

c
      if(flag.eq.1) then
         out(1)=u(int(z(1)))
      elseif(flag.eq.2) then
         z(1)=dble(nclock)
      endif
      end
