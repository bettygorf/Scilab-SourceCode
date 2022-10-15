      subroutine sawtth(t,x,nx,z,nz,u,nu,rpar,nrpar,ipar,nipar,nclock,
     &     out,nout,flag)
      double precision t,x(*),z(*),u(*),rpar(*),out(*)
      integer ipar(*),flag
c           
      common /dbcos/ idb
c
c
      if(idb.eq.1) then
         write(6,'(''sawtth     t='',e10.3,'' flag='',i1)') t,flag
      endif
c
      if (flag.eq.1) then
         out(1)=t-z(1)
      elseif (flag.eq.2) then
         z(1)=t
      elseif (flag.eq.3) then
         out(1)=t+rpar(1)
      endif
      return
      end
