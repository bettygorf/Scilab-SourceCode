      subroutine hltblk(t,x,nx,z,nz,u,nu,rpar,nrpar,ipar,nipar,nclock,
     &     out,nout,flag)
      double precision t,x(*),z(*),u(*),rpar(*),out(*)
      integer ipar(*),flag
      integer halt
      common /coshlt/ halt
      common /dbcos/ idb
c
      if(idb.eq.1) then
         write(6,'(''hltblk     t='',e10.3,'' flag='',i1)') t,flag
      endif

c
      if(flag.eq.2) then
         halt=1
         if(nipar.gt.0) then
            z(1)=ipar(1)
         else
            z(1)=0.0d0
         endif
      endif
      return
      end
