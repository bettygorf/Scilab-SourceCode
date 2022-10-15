      subroutine logblk(t,x,nx,z,nz,u,nu,rpar,nrpar,ipar,nipar,nclock,
     &     out,nout,flag)
      double precision t,x(*),u(*),rpar(*),out(*),z(*)
      integer ipar(*),flag
c     LOGBLK, Alvaro:17-5-95
c     Continous block, MIMO
c     rpar(1) is log basis
      common /dbcos/ idb
c
      if(idb.eq.1) then
         write(6,'(''logblk     t='',e10.3,'' flag='',i1)') t,flag
      endif
      if(flag.eq.1) then
c     flag=1
         do 15 i=1,nu
            if(u(i).gt.0.0d0) then
               out(i)=log(u(i))/log(rpar(1))
            else
               flag=-2
               return
            endif
 15      continue
      else
c     flag=2 or 3 --> ERROR
         write(*,'(''ERROR; block log flag:'',i2,'' t '',e10.3)') flag,t
         flag=-1
      endif
      end
