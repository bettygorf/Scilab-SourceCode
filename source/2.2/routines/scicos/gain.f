      subroutine gain(t,x,nx,z,nz,u,nu,rpar,nrpar,ipar,nipar,nclock,
     &     out,nout,flag)
      double precision t,x(*),z(*),u(*),rpar(*),out(*)
      integer ipar(*),flag
      common /dbcos/ idb
c
      if(idb.eq.1) then
         write(6,'(''Gain     t='',e10.3,'' flag='',i1)') t,flag
      endif
      call dmmul(rpar,nout,u,nu,out,nout,nout,nu,1)
      return
      end
