      subroutine timblk(t,x,nx,z,nz,u,nu,rpar,nrpar,ipar,nipar,nclock,
     &     out,nout,flag)
      double precision t,x(*),z(*),u(*),rpar(*),out(*)
      integer ipar(*),flag
      common /dbcos/ idb
c
      if(idb.eq.1) then
         write(6,'(''timblk     t='',e10.3,'' flag='',i1)') t,flag
      endif

      if(flag.eq.1) then
c     flag=1
         out(1)=t
      endif
      end
