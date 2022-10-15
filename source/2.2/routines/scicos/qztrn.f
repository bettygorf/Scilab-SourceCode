c---------------------------------------------------------------------------
c---------------------------------------------------------------------------
      subroutine qztrn(t,x,nx,z,nz,u,nu,rpar,nrpar,ipar,nipar,nclock,
     &     out,nout,flag)
      double precision t,x(*),u(*),rpar(*),out(*)
      integer ipar(*),flag
c     QZRND, Alvaro:9-6-95
c     Continous block, MIMO
c     Gives quantized signal by truncation method
c     rpar(i): quantization step for i input
c     if u<0,  out=rpar*ceil(u/rpar)
c     else     out=rpar*floor(u/rpar)
c

      integer i
      common /dbcos/ idb
c
      if(idb.eq.1) then
         write(6,'(''qztrn     t='',e10.3,'' flag='',i1)') t,flag
      endif

      goto(10,20,20) flag

c flag=1
      
 10   continue
      
      do 15 i=1,nu
          if (u(i).lt.0)then
            out(i)=rpar(i)*(ANINT(u(i)/rpar(i)+0.5))
         else
            out(i)=rpar(i)*(ANINT(u(i)/rpar(i)-0.5))
         endif  
 15   continue
      return
c flag=2 OR 3
 20   continue
c ERROR
      write(*,'(''ERROR; block trunc flag:'',i2,'' t '',e10.3)') flag,t
      return
      end
