
      subroutine pload(t,x,nx,z,nz,u,nu,rpar,nrpar,ipar,nipar,nclock,
     &     out,nout,flag)
      double precision t,x(*),u(*),rpar(*),out(*),z(*)
      integer ipar(*),flag
c     pload, Alvaro:17-5-95
c     Continous block, MIMO
c     Preload function
c     if in(i).lt.0 then out(i)=-in(i)-rpar(i)
c     else out(i)=in(i)+rpar(i)
      common /dbcos/ idb
c
      if(idb.eq.1) then
         write(6,'(''Pload     t='',e10.3,'' flag='',i1)') t,flag
      endif
      goto(10,20,20) flag
c flag=1
 10   do 15 i=1,nu
            if (u(i).lt.0)then
               out(i)=u(i)-rpar(i)
            else if(u(i).gt.0)then
               out(i)=u(i)+rpar(i)
            else
               out(i)=0.0d0
            endif
 15   continue
      return
c flag=2 or 3
 20   continue
c ERROR
      write(*,'(''ERROR; block - pload- flag:'',i2,'' t '',e10.3)') flag,t
      return
      end
