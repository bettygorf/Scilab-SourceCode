      subroutine lusat(t,x,nx,z,nz,u,nu,rpar,nrpar,ipar,nipar,nclock,
     &     out,nout,flag)
      double precision t,x(*),u(*),rpar(*),out(*),z(*)
      integer ipar(*),flag
c     Lower-Upper saturation, Alvaro:17-5-95
c     Continous block, MIMO
c     Lower saturation rpar(1;nu)
c     Upper saturation rpar(nu+1;2*nu)
c     out(i)=Max(-rpar(i),Min(u(i),rpar(i+nu))
c
      common /dbcos/ idb
c
      if(idb.eq.1) then
         write(6,'(''lusat     t='',e10.3,'' flag='',i1)') t,flag
      endif
      goto(10,20,20) flag

c flag=1
 10   do 15 i=1,nu
            if (u(i).le.rpar(i))then
               out(i)=rpar(i)
            else if(u(i).ge.rpar(i+nu))then
               out(i)=rpar(i+nu)
            else
               out(i)=u(i)
            endif
 15   continue
      return
c flag=2 OR 3
 20   continue
c ERROR
      write(*,'(''ERROR; block lusat flag:'',i2,'' t '',e10.3)') flag,t
      return
      end
