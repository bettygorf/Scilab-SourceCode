      subroutine powblk(t,x,nx,z,nz,u,nu,rpar,nrpar,ipar,nipar,nclock,
     &     out,nout,flag)
      double precision t,x(*),u(*),rpar(*),out(*),z(*)
      integer ipar(*),flag
c     POWBLK, Alvaro:17-5-95
c     Continous block, MIMO
c     rpar(1) is power
      common /dbcos/ idb
c
      if(idb.eq.1) then
         write(6,'(''powblk     t='',e10.3,'' flag='',i1)') t,flag
      endif
      if(flag.eq.1) then
c     flag=1
         if (nrpar.eq.1) then
         do 15 i=1,nu
            if(u(i).le.0.d0) then
               flag=-2
               return
            endif
            out(i)=u(i)**rpar(1)
 15      continue
      else
         do 25 i=1,nu
            out(i)=u(i)**ipar(1)
 25      continue
      endif
      else
c     flag=2 or 3 --> ERROR
         write(*,'(''ERROR; block pow flag:'',i2,'' t '',e10.3)') flag,t
         flag=-1
      endif
      end
