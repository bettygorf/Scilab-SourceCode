      subroutine expblk(t,x,nx,z,nz,u,nu,rpar,nrpar,ipar,nipar,nclock,
     &     out,nout,flag)
      double precision t,x(*),u(*),rpar(*),out(*),z(*)
      integer ipar(*),flag
c     EXPBLK, Alvaro:17-5-95 a^u
c     Continous block, MIMO
      if(flag.eq.1) then
c     flag=1
         do 15 i=1,nu
            out(i)=exp(log(rpar(1))*u(i))
 15      continue
      else
c     flag=2 or 3 --> ERROR
         write(*,'(''ERROR; block exp flag:'',i2,'' t '',e10.3)') flag,t
         flag=-1
      endif
      end
