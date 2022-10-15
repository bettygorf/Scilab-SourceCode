      subroutine cstblk(t,x,nx,z,nz,u,nu,rpar,nrpar,ipar,nipar,nclock,
     &     out,nout,flag)
      double precision t,x(*),z(*),u(*),rpar(*),out(*)
      integer ipar(*),flag
c     Constant, Alvaro:17-5-95
c     Continous block, MIMO
c           
      common /dbcos/ idb
c
c     out(i)=rpar(i)
c
      if(idb.eq.1) then
         write(6,'(''Const     t='',e10.3,'' flag='',i1)') t,flag
      endif
c
      if (flag.eq.1) then
         call dcopy(nrpar,rpar,1,out,1)
      elseif(flag.gt.5.or.flag.eq.3) then
         write(*,'(''ERROR; block const flag:'',i2,'' t '',e10.3)')
     $        flag,t
         flag=-1
      endif
      return
      end
