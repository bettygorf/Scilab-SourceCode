      subroutine stepf(t,x,nx,z,nz,u,nu,rpar,nrpar,ipar,nipar,nclock,
     &     out,nout,flag)
      double precision t,x(*),u(*),rpar(*),out(*),z(*)
      integer ipar(*),flag
c     TEST by Alvaro
c     Continous block
c     Step function starting when t=rpar(1)
c     with amplitude=rpar(2);
c
      common /dbcos/ idb
c
      if(idb.eq.1) then
         write(6,'(''Stepf     t='',e10.3,'' flag='',i1)') t,flag
      endif

      if(flag.eq.1) then
         out(1)=0.0d0
         if(t.ge.rpar(1)) out(1)=rpar(2)
      endif
      return
      end
