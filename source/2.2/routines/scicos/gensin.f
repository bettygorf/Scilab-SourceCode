      subroutine gensin(t,x,nx,z,nz,u,nu,rpar,nrpar,ipar,nipar,nclock,
     &     out,nout,flag)
      double precision t,x(*),z(*),u(*),rpar(*),out(*)
      integer ipar(*),flag
c           
      common /dbcos/ idb
c
c
      if(idb.eq.1) then
         write(6,'(''gensin     t='',e10.3,'' flag='',i1)') t,flag
      endif
c
      if (flag.eq.1) then
         out(1)=rpar(1)*sin(rpar(2)*t+rpar(3))
      else
         write(*,'(''ERROR; block gensin flag:'',i2,'' t '',e10.3)')
     $        flag,t
         flag=-1
      endif
      return
      end
