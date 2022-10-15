      subroutine sum(t,x,nx,z,nz,u,nu,rpar,nrpar,ipar,nipar,nclock,
     &     out,nout,flag)
      double precision t,x(*),z(*),u(*),rpar(*),out(*)
      integer ipar(*),flag,i
c     adds the inputs weighed by par
      common /dbcos/ idb
c
      if(idb.eq.1) then
         write(6,'(''Som     t='',e10.3,'' flag='',i1)') t,flag
      endif

      out(1)=0.0d0
      do 1 i=1,nu
         out(1)=out(1)+u(i)*rpar(i)
 1    continue
      return
      end
