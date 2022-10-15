      subroutine lsplit(t,x,nx,z,nz,u,nu,rpar,nrpar,ipar,nipar,nclock,
     &     out,nout,flag)
      double precision t,x(*),z(*),u(*),rpar(*),out(*)
      integer ipar(*),flag,i
c     splitting signals
c     no parameter
      common /dbcos/ idb
c
      if(idb.eq.1) then
         write(6,'(''Split     t='',e10.3,'' flag='',i1)') t,flag
      endif

      do 1 i=1,nout
         out(i)=u(1)
 1    continue
      return
      end
