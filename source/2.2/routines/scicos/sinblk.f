      subroutine sinblk(t,x,nx,z,nz,u,nu,rpar,nrpar,ipar,nipar,nclock,
     &     out,nout,flag)
      double precision t,x(*),z(*),u(*),rpar(*),out(*)
      integer ipar(*),flag
c     SINBLK, Alvaro:17-5-95
c     Continous block, MIMO
      common /dbcos/ idb
c
      if(idb.eq.1) then
         write(6,'(''Sinblk     t='',e10.3,'' flag='',i1)') t,flag
      endif

      if(flag.eq.1) then
c     flag=1
         do 15 i=1,nu
            out(i)=sin(u(i))
 15      continue
      else
c     flag=2 or 3 --> ERROR
         write(*,'(''ERROR; block sin flag:'',i2,'' t '',e10.3)') flag,t
         flag=-1
      endif
      end
