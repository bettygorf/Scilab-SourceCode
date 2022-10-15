      subroutine dband(t,x,nx,z,nz,u,nu,rpar,nrpar,ipar,nipar,nclock,
     &     out,nout,flag)
      double precision t,x(*),u(*),rpar(*),out(*),z(*)
      integer ipar(*),flag
c     Dead Band, Alvaro:17-5-95
c     Continous block, MIMO
c     Dead Band=rpar(1;nu)
c     if u(i)<0 ,out(i)=min(0,u+DB/2)
c     else       out(i)=max(0,u-DB/2)
c
      goto(10,20,20) flag
c flag=1
 10   do 15 i=1,nu
            if (u(i).lt.0)then
               out(i)=min(0.0d0,u(i)+rpar(i)/2.0d0)
            else if(u(i).ge.0)then
               out(i)=max(0.0d0,u(i)-rpar(i)/2.0d0)
            endif
 15   continue
      return

c flag=2
 20   continue
c ERROR
      write(*,'(''ERROR; block dband flag:'',i2,'' t '',e10.3)') flag,t
      flag=-1
      return
      end
