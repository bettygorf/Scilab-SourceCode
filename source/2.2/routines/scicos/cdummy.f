      subroutine cdummy(t,x,nx,z,nz,u,nu,rpar,nrpar,ipar,nipar,nclock,
     &     out,nout,flag)
      double precision t,x(*),z(*),u(*),rpar(*),out(*)
      integer ipar(*),flag
c
c     ipar(1:nu)=threshold values
c     
      common /dbcos/ idb
c
      if(idb.eq.1) then
         write(6,'(''Cdummy     t='',e10.3,'' flag='',i1)') t,flag
      endif
      out(1)=0
      end
