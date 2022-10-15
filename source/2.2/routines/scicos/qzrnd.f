c---------------------------------------------------------------------------



c **************************************************************************
c     QUANTIZATION METHODS
c     Notes for understanding header comments
c        Ceil(x): largest whole number that is less than or equal to x
c                 Ceil(x)=ANINT(x+0.5)
c        Floor(x): smallest whole number that is greater than or equal to x
c                 Floor(x)=ANINT(x-0.5)

c---------------------------------------------------------------------------
      subroutine qzrnd(t,x,nx,z,nz,u,nu,rpar,nrpar,ipar,nipar,nclock,
     &     out,nout,flag)
      double precision t,x(*),u(*),rpar(*),out(*),z(*)
      integer ipar(*),flag
c     QZRND, Alvaro:9-6-95
c     Continous block, MIMO
c     Gives quantized signals by rounding method
c     rpar(i) quantization step
c     if u<0 , out=rpar*(Ceil(u/rpar)-0.5)
c     else     out=rpar*(Floor(u/rpar)+0.5)
c
      integer i
      common /dbcos/ idb
c
      if(idb.eq.1) then
         write(6,'(''Qzrnd     t='',e10.3,'' flag='',i1)') t,flag
      endif

      goto(10,20,20) flag

c flag=1
      
 10   continue
      
      do 15 i=1,nu
         if (u(i).lt.0)then
            out(i)=rpar(i)*(ANINT(u(i)/rpar(i)+0.5)-0.5)
         else
            out(i)=rpar(i)*(ANINT(u(i)/rpar(i)-0.5)+0.5)
         endif
 15   continue
      return
c flag=2 OR 3
 20   continue
c ERROR
      write(*,'(''ERROR; block round flag:'',i2,'' t '',e10.3)') flag,t
      return
      end
